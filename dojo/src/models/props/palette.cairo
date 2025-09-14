
#[derive(Copy, Drop, Serde, PartialEq, Introspect)]
pub enum Palette {
    None,
    Palette1,
    Palette2,
    Palette3,
    Palette4,
    Palette5,
}


//---------------------------------------
// Traits
//

#[generate_trait]
pub impl PaletteImpl of PaletteTrait {
    fn palette_count() -> u8 {
        (5)
    }
    //---------------------------------------
    // generated from:
    // https://editor.p5js.org/rsodre/sketches/LbtLW29da
    //
    // fn get_bg(self: @Palette) -> ByteArray {
    //     (match self {
    //         Palette::None     => "#000000",
    //         Palette::Palette1 => "#000000",
    //         Palette::Palette2 => "#000000",
    //         Palette::Palette3 => "#000000",
    //         Palette::Palette4 => "#000000",
    //         Palette::Palette5 => "#000000",
    //     })
    // }
    // fn get_colors(self: @Palette) -> Span<ByteArray> {
    //     (match self {
    //         Palette::None     => array![],
    //         Palette::Palette1 => array!["#c2e0fd", "#C2FDE0", "#dddddd"],
    //         Palette::Palette2 => array!["#B47D40", "#D76017", "#dddddd"],
    //         Palette::Palette3 => array!["#F6DFC0", "#b98b3d", "#dddddd"],
    //         Palette::Palette4 => array!["#3DBAA5", "#b98b3d", "#dddddd"],
    //         Palette::Palette5 => array!["#67b4f8", "#ff33cc", "#FFFFFF"],
    //     }).span()
    // }
    fn get_styles(self: @Palette) -> ByteArray {
        (match self {
            Palette::None     => "",
            Palette::Palette1 => ".bg{fill:#000000;}.p0{fill:#903286;}.p1{fill:#ae3ed0;}.p2{fill:#d77bf7;}.p3{fill:#cfa7ec;}.p4{fill:#ece2fd;}.m0{fill:#6e2014;}.m1{fill:#a55921;}.m2{fill:#d18c32;}.m3{fill:#eeb441;}",
            Palette::Palette2 => ".bg{fill:#000000;}.p0{fill:#903286;}.p1{fill:#ae3ed0;}.p2{fill:#d77bf7;}.p3{fill:#cfa7ec;}.p4{fill:#ece2fd;}.m0{fill:#6e2014;}.m1{fill:#a55921;}.m2{fill:#d18c32;}.m3{fill:#eeb441;}",
            Palette::Palette3 => ".bg{fill:#000000;}.p0{fill:#903286;}.p1{fill:#ae3ed0;}.p2{fill:#d77bf7;}.p3{fill:#cfa7ec;}.p4{fill:#ece2fd;}.m0{fill:#6e2014;}.m1{fill:#a55921;}.m2{fill:#d18c32;}.m3{fill:#eeb441;}",
            Palette::Palette4 => ".bg{fill:#000000;}.p0{fill:#903286;}.p1{fill:#ae3ed0;}.p2{fill:#d77bf7;}.p3{fill:#cfa7ec;}.p4{fill:#ece2fd;}.m0{fill:#6e2014;}.m1{fill:#a55921;}.m2{fill:#d18c32;}.m3{fill:#eeb441;}",
            Palette::Palette5 => ".bg{fill:#000000;}.p0{fill:#903286;}.p1{fill:#ae3ed0;}.p2{fill:#d77bf7;}.p3{fill:#cfa7ec;}.p4{fill:#ece2fd;}.m0{fill:#6e2014;}.m1{fill:#a55921;}.m2{fill:#d18c32;}.m3{fill:#eeb441;}",
        })
    }
}




impl PaletteIntoByteArray of Into<Palette, ByteArray> {
    fn into(self: Palette) -> ByteArray {
        (match self {
            Palette::None       => "?",
            Palette::Palette1   => "Palette1",
            Palette::Palette2   => "Palette2",
            Palette::Palette3   => "Palette3",
            Palette::Palette4   => "Palette4",
            Palette::Palette5   => "Palette5",
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
            _ => Palette::None,
        }
    }
}

