use aster::models::props::{
    palette::{Palette, PaletteTrait},
};

#[derive(Drop)]
pub struct AsterProps {
    pub token_id: u128,
    pub seeder: Seeder,
    // props
    pub palette: Palette,
    pub density: usize,
    pub distribution: Distribution,
    // metadata (optional)
    pub attributes: Span<Attribute>,
    pub additional_metadata: Span<Attribute>,
}


#[derive(Drop, Copy, PartialEq)]
pub enum Distribution {
    Order,
    Spread,
    Chaos,
}
impl DistributionIntoByteArray of Into<Distribution, ByteArray> {
    fn into(self: Distribution) -> ByteArray {
        (match self {
            Distribution::Order   => "Order",
            Distribution::Spread  => "Spread",
            Distribution::Chaos   => "Chaos",
        })
    }
}

//---------------------------------------
// Traits
//
use nft_combo::utils::renderer::{Attribute};
use aster::models::seed::{Seed, Seeder, SeederTrait};

#[generate_trait]
pub impl AsterPropsImpl of AsterPropsTrait {
    //
    // Props
    //
    fn generate(seed: @Seed, generate_attributes: bool) -> AsterProps {
        //
        // seeded props
        let mut seeder: Seeder = SeederTrait::new((*seed.seed).into(), *seed.token_id);
        let palette: Palette = seeder._generate_palette();
        let density: usize = seeder._generate_density();
        let distribution: Distribution =
            if (density == 1) {Distribution::Order}
            else {seeder._generate_distribution()};
        //
        // attributes (optional)
        let mut attributes: Span<Attribute> = (
            if (generate_attributes) {
                array![
                    Attribute {
                        key: "Palette",
                        value: palette.into(),
                    },
                    Attribute {
                        key: "Density",
                        value: format!("{}", density),
                    },
                    Attribute {
                        key: "Distribution",
                        value: distribution.into(),
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
            distribution,
            attributes,
            additional_metadata,
        })
    }
    //
    // internal
    fn _generate_palette(ref self: Seeder) -> Palette {
        let num: u8 = self.get_next_u8(PaletteTrait::palette_count()) + 1;
        (num.into())
    }
    fn _generate_density(ref self: Seeder) -> usize {
        let options: Span<usize> = array![1, 2, 2, 3, 3, 4, 4, 5, 5, 6].span();
        let num: u8 = self.get_next_u8(options.len().try_into().unwrap());
        (*options.at(num.into()))
    }
    fn _generate_distribution(ref self: Seeder) -> Distribution {
        let options: Span<Distribution> = array![Distribution::Order, Distribution::Chaos, Distribution::Chaos].span();
        let num: u8 = self.get_next_u8(options.len().try_into().unwrap());
        (*options.at(num.into()))
    }
}
