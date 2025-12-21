
#[derive(Copy, Drop, Serde, PartialEq, Introspect)]
pub enum Palette {
    None,
    Palette1,
    Palette2,
    Palette3,
    Palette4,
    Palette5,
    Palette6,
}


//---------------------------------------
// Traits
//

#[generate_trait]
pub impl PaletteImpl of PaletteTrait {
    fn palette_count() -> u8 {
        (6)
    }
    fn get_styles(self: @Palette) -> ByteArray {
        (match self {
            Palette::None     => "",
            Palette::Palette1 => ".sh{filter:drop-shadow(1px 1px 2px #90325B80);}.bg{fill:#100010;}.p0{fill:#90325B;}.p1{fill:#D03E80;}.p2{fill:#F77BAF;}.p3{fill:#ECA7CB;}.p4{fill:#FBDDEA;}.m0{fill:#732C2C;}.m1{fill:#A52135;}.m2{fill:#E9583E;}.m3{fill:#FBB451;}",
            Palette::Palette2 => ".sh{filter:drop-shadow(1px 1px 2px #54096780);}.bg{fill:#100010;}.p0{fill:#540967;}.p1{fill:#7724AE;}.p2{fill:#BA39BC;}.p3{fill:#E26DFF;}.p4{fill:#DF92FD;}.m0{fill:#3b2628;}.m1{fill:#9b622a;}.m2{fill:#e0aa42;}.m3{fill:#f3cb45;}",
            Palette::Palette3 => ".sh{filter:drop-shadow(1px 1px 2px #313B7380);}.bg{fill:#000010;}.p0{fill:#313B73;}.p1{fill:#485799;}.p2{fill:#707DBE;}.p3{fill:#ACB9F1;}.p4{fill:#C0E8FF;}.m0{fill:#3b2628;}.m1{fill:#783C1A;}.m2{fill:#BB873E;}.m3{fill:#E4AF4D;}",
            Palette::Palette4 => ".sh{filter:drop-shadow(1px 1px 2px #3C40BB80);}.bg{fill:#000010;}.p0{fill:#3C40BB;}.p1{fill:#4D5CFC;}.p2{fill:#2B00FF;}.p3{fill:#4E69FF;}.p4{fill:#AC9AFF;}.m0{fill:#3b2628;}.m1{fill:#9B442A;}.m2{fill:#E08442;}.m3{fill:#F3EA45;}",
            Palette::Palette5 => ".sh{filter:drop-shadow(1px 1px 2px #AD842B80);}.bg{fill:#101000;}.p0{fill:#AD842B;}.p1{fill:#F3C81B;}.p2{fill:#F0DC01;}.p3{fill:#FFF984;}.p4{fill:#FFFEE4;}.m0{fill:#3b2628;}.m1{fill:#9B442A;}.m2{fill:#E08442;}.m3{fill:#FBFFC9;}",
            Palette::Palette6 => ".sh{filter:drop-shadow(1px 1px 2px #6a0e0380);}.bg{fill:#101000;}.p0{fill:#6A0303;}.p1{fill:#CA1B0F;}.p2{fill:#FF2A00;}.p3{fill:#FF892E;}.p4{fill:#FFB339;}.m0{fill:#72402F;}.m1{fill:#CD882F;}.m2{fill:#FCBB42;}.m3{fill:#FDF59A;}",
        })
    }
    fn get_background_color(self: @Palette) -> ByteArray {
        (match self {
            Palette::None     => "000000",
            Palette::Palette1 => "100010",
            Palette::Palette2 => "100010",
            Palette::Palette3 => "000010",
            Palette::Palette4 => "000010",
            Palette::Palette5 => "101000",
            Palette::Palette6 => "101000",
        })
    }
}


impl PaletteIntoByteArray of Into<Palette, ByteArray> {
    fn into(self: Palette) -> ByteArray {
        (match self {
            Palette::None       => "?",
            Palette::Palette1   => "Pink",
            Palette::Palette2   => "Purple",
            Palette::Palette3   => "Cerulean",
            Palette::Palette4   => "Blue",
            Palette::Palette5   => "Yellow",
            Palette::Palette6   => "Red",
        })
    }
}
impl PaletteIntoU8 of Into<Palette, u8> {
    fn into(self: Palette) -> u8 {
        match self {
            Palette::None => 0,
            Palette::Palette1 => 1,
            Palette::Palette2 => 2,
            Palette::Palette3 => 3,
            Palette::Palette4 => 4,
            Palette::Palette5 => 5,
            Palette::Palette6 => 6,
        }
    }
}
impl U8IntoPalette of Into<u8, Palette> {
    fn into(self: u8) -> Palette {
        match self {
            0 => Palette::None,
            1 => Palette::Palette1,
            2 => Palette::Palette2,
            3 => Palette::Palette3,
            4 => Palette::Palette4,
            5 => Palette::Palette5,
            6 => Palette::Palette6,
            _ => Palette::None,
        }
    }
}

