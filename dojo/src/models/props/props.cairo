use aster::models::props::{
    palette::{Palette, PaletteTrait},
};

#[derive(Drop)]
pub struct AsterProps {
    pub token_id: u128,
    pub seeder: Seeder,
    // props
    pub palette: Palette,
    pub density: u8,
    // metadata (optional)
    pub attributes: Span<Attribute>,
    pub additional_metadata: Span<Attribute>,
}

//---------------------------------------
// Traits
//
use nft_combo::utils::renderer::{Attribute};
use aster::models::seed::{Seed, Seeder, SeederTrait};

#[generate_trait]
pub impl AsterPropsImpl of AsterPropsTrait {
    // internal
    fn _generate_palette(ref self: Seeder) -> Palette {
        let palette_num: u8 = self.get_next_u8(PaletteTrait::palette_count()) + 1;
        (palette_num.into())
    }
    fn _generate_density(ref self: Seeder) -> u8 {
        let densities: Span<u8> = array![1, 2, 2, 3, 3, 4, 4, 5, 5, 6].span();
        let density_num: u8 = self.get_next_u8(densities.len().try_into().unwrap());
        (*densities.at(density_num.into()))
    }
    //
    // Props
    //
    fn generate(seed: @Seed, generate_attributes: bool) -> AsterProps {
        //
        // seeded props
        let mut seeder: Seeder = SeederTrait::new((*seed.seed).into());
        let palette: Palette = seeder._generate_palette();
        let density: u8 = seeder._generate_density();
        //
        // attributes (optional)
        let mut attributes: Span<Attribute> = (
            if (generate_attributes) {
                array![
                    Attribute {
                        key: "Palette",
                        value: palette.name(),
                    },
                    Attribute {
                        key: "Density",
                        value: format!("{}", density),
                    },
                ]
            } else {
                array![]
            }).span();
        let mut additional_metadata: Span<Attribute> = (
            if (generate_attributes) {
                array![
                    Attribute {
                        key: "Seed",
                        value: format!("{}", *seed.seed),
                    },
                ]
            } else {
                array![]
            }).span();
        //
        // return all generated props
        (AsterProps{
            token_id: *seed.token_id,
            seeder,
            palette,
            density,
            attributes,
            additional_metadata,
        })
    }
}
