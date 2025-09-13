use core::byte_array::ByteArrayTrait;
use core::array::{Array, ArrayTrait};
use aster::models::{
    seed::{Seeder, SeederTrait, RenderParams},
    gen2::{
        props::{Gen2Props},
        class::{ClassTrait},
        palette::{PaletteTrait},
    },
};
use aster::utils::math::{SafeMathU32};

const GAP: usize = 6;
const WIDTH: usize = (12 * 3);
const HEIGHT: usize = (12 * 4);

#[generate_trait]
pub impl Gen2RendererImpl of Gen2RendererTrait {

    //------------------------
    // SVG builder
    //
    fn render_svg(token_props: @Gen2Props) -> ByteArray {
        //---------------------------
        // get props
        //
        let (
            charset,
            charset_lengths,
            font_family,
            text_length,
            text_scale,
            font_size,
        ): (Span<felt252>, Span<usize>, ByteArray, ByteArray, ByteArray, ByteArray) = token_props.class.get_props();
        let (
            color_bg,
            color_ink,
            color_shadow,
        ): (ByteArray, ByteArray, ByteArray) = token_props.palette.get_props();
        //---------------------------
        // Build SVG
        //
        let mut result: ByteArray = "";
        let FULL_WIDTH: usize = (GAP + WIDTH + GAP);
        let FULL_HEIGHT: usize = (GAP + HEIGHT + GAP);
        let RES_X: usize = FULL_WIDTH * 20;     // 960
        let RES_Y: usize = FULL_HEIGHT * 20;    // 1200
        result.append(@format!(
            "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" version=\"1.1\" width=\"{}\" height=\"{}\" viewBox=\"-{} -{} {} {}\">",
                RES_X,
                RES_Y,
                GAP,
                GAP,
                FULL_WIDTH,
                FULL_HEIGHT,
        ));
        //
        // styles
        let shadow_style: ByteArray =
            if (color_shadow.len() != 0) {format!("text-shadow:0.8px 0.8px 1px {};", color_shadow)}
            else {""};
        result.append(@format!(
            "<style>.BG{{fill:{};}}text{{fill:{};font-family:'{}';font-size:{};{}transform:scaleX({});letter-spacing:0;dominant-baseline:hanging;shape-rendering:crispEdges;white-space:pre;cursor:default;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;}}</style>",
                color_bg,
                color_ink,
                font_family,
                font_size,
                shadow_style,
                text_scale,
        ));
        result.append(@format!(
            "<g><rect class=\"BG\" x=\"-{}\" y=\"-{}\" width=\"{}\" height=\"{}\" /><g>",
                GAP,
                GAP,
                FULL_WIDTH,
                FULL_HEIGHT,
        ));
        //---------------------------
        // Build text tags
        //
        let char_count: usize = charset.len();
        let cells: Span<usize> = Self::_make_cells(*token_props.seed, char_count);
        let mut y: usize = 0;
        loop {
            if (y == HEIGHT) { break; }
            // open <text>
            result.append(@format!(
                "<text y=\"{}\" textLength=\"{}\">",
                    y,
                    text_length,
            ));
            let mut x: usize = 0;
            loop {
                if (x == WIDTH) { break; }
                let value: @usize = cells.at(y * WIDTH + x);
                result.append_word(*charset.at(*value), *charset_lengths.at(*value));
                x += 1;
            };
            // close <text>
            result.append(@"</text>");
            y += 1;
        };
        //----------------
        // close it!
        //
        result.append(@"</g></g></svg>");
        (result)
    }


    //------------------------
    // token cell builder
    //
    fn _make_cells(seed: u256, char_count: usize) -> Span<usize> {
        let mut seeder: Seeder = SeederTrait::new(seed);
        // generate render params
        let HALF_W: usize = (WIDTH / 2);
        let HALF_H: usize = (HEIGHT / 2);
        let p: RenderParams = seeder.get_render_params(char_count, HALF_W, HALF_H);
        // build cells
        let mut cells:Array<usize> = array![];
        let mut y: usize = 0;
        loop {
            if (y == HEIGHT) { break; }
            let norm_y: usize = if (y < HALF_H) {y} else {HEIGHT - y};
            let mut x: usize = 0;
            loop {
                if (x == WIDTH) { break; }
                let norm_x: usize = if (x < HALF_W) {x} else {WIDTH - x};
                let mut value: usize = 0;

                if (x < HALF_W) {
                    // generate LEFT
                    value = (
                        (x * p.sc_x) + p.off_x + (x % p.mod_x) +
                        (y * p.sc_y) + p.off_y + (y % p.mod_y)
                    ) % char_count;
                    // fade out borders
                    let mut f: usize = 0;
                    if (p.fade_type == 1 && (x + norm_y) > HALF_H) { // inside-out
                        let fy = SafeMathU32::sub(norm_y, HALF_H);
                        f = ((x + fy) / p.fade_amount);
                    } else if (p.fade_type == 2 && (x + norm_y) < HALF_H) { // inverted border
                        f = ((x + norm_y) / p.fade_amount) * 2;
                    } else if (p.fade_type == 3 ) { // top/bottom v2
                        f = (SafeMathU32::sub(HALF_H, norm_y) / p.fade_amount);
                    } else if (p.fade_type == 4 ) { // top/bottom
                        f = (SafeMathU32::sub(norm_y, HALF_H) / p.fade_amount);
                    } else if (p.fade_type == 5 ) { // sides
                        f = (SafeMathU32::sub(HALF_W, norm_x) / p.fade_amount);
                    }
                    if (f > 0) {
                        value = SafeMathU32::sub(value, f);
                    }
                } else {
                    // mirror LEFT>RIGHT
                    value = *cells.at(y*WIDTH + (WIDTH-x-1));
                }
                cells.append(value);
                x += 1;
            };
            y += 1;
        };
        (cells.span())
    }
}



//----------------------------
// tests
//
#[cfg(test)]
mod unit {
    use super::{Gen2RendererTrait};
    use aster::models::gen2::{
        props::{Gen2Props},
        class::{Class, ClassTrait},
        palette::{PaletteTrait},
    };
    use aster::utils::hash::{make_seed};
    use aster::tests::tester::tester::{OWNER};

    fn _name_class_props(class: Class, token_id: u128) -> Gen2Props {
        let seed: u256 = make_seed(OWNER(), token_id).into();
        (Gen2Props {
            token_id,
            seed,
            class,
            palette: PaletteTrait::randomize(seed.high),
            realm_id: token_id,
            attributes: [].span(),
            additional_metadata: [].span(),
        })
    }

    fn _dump_class_svg(class: Class) {
        let i: u128 = class.into();
        let props = _name_class_props(class, (i+1));
        let svg = Gen2RendererTrait::render_svg(@props);
        println!("____SVG[{}][{}]:{}", i, class.name(), svg);
    }

    #[test]
    #[ignore]
    fn test_class_svgs() {
        let mut i: u128 = 0;
        loop {
            let class: Class = i.into();
            if (class == Class::Count) { break; }
            _dump_class_svg(class);
            i += 1;
        }
    }

    #[test]
    #[ignore]
    fn test_class_a() { _dump_class_svg(Class::A(0)); }
    #[test]
    #[ignore]
    fn test_class_b() { _dump_class_svg(Class::B(0)); }
    #[test]
    #[ignore]
    fn test_class_c() { _dump_class_svg(Class::C(0)); }
    #[test]
    #[ignore]
    fn test_class_d() { _dump_class_svg(Class::D(0)); }
    #[test]
    #[ignore]
    fn test_class_e() { _dump_class_svg(Class::E(0)); }
    #[test]
    #[ignore]
    fn test_class_f() { _dump_class_svg(Class::F(0)); }
    #[test]
    #[ignore]
    fn test_class_h() { _dump_class_svg(Class::H(0)); }
    #[test]
    #[ignore]
    fn test_class_v() { _dump_class_svg(Class::V(0)); }
    #[test]
    #[ignore]
    fn test_class_l() { _dump_class_svg(Class::L(0)); }

}
