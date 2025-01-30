module virtual_reel
(
    input wire logic [5:0] v_reel,

    output     logic [4:0] p_reel
);

    always_comb begin
        case (v_reel)
            0:  p_reel = 0;  // BLANK
            1,
            2:  p_reel = 2;  // BLANK
            3:  p_reel = 4;  // BLANK
            4,
            5:  p_reel = 6;  // BLANK
            6:  p_reel = 8;  // BLANK
            7,
            8:  p_reel = 10; // BLANK
            9:  p_reel = 12; // BLANK
            10,
            11: p_reel = 14; // BLANK
            12: p_reel = 16; // BLANK
            13,
            14: p_reel = 18; // BLANK
            15: p_reel = 20; // BLANK
            16,
            17: p_reel = 22; // BLANK
            18: p_reel = 24; // BLANK
            19,
            20: p_reel = 26; // BLANK
            21: p_reel = 28; // BLANK
            22,
            23: p_reel = 30; // BLANK
            24,
            25,
            26,
            27: p_reel = 1;  // LIME
            28,
            29,
            30,
            31: p_reel = 11; // LIME
            32,
            33,
            34,
            35: p_reel = 21; // LIME
            36,
            37,
            38,
            39: p_reel = 5;  // ORANGE
            40,
            41,
            42: p_reel = 17; // ORANGE
            43,
            44,
            45: p_reel = 27; // ORANGE
            46,
            47,
            48: p_reel = 9;  // GRAPE
            49,
            50: p_reel = 19; // GRAPE
            51,
            52: p_reel = 29; // GRAPE
            53,
            54: p_reel = 3;  // BANANA
            55,
            56: p_reel = 13; // BANANA
            57: p_reel = 25; // BANANA
            58,
            59: p_reel = 7;  // BLUEBERRY
            60: p_reel = 23; // BLUEBERRY
            61,
            62: p_reel = 15; // CHERRY
            63: p_reel = 31; // COCONUT
            default: p_reel = 0; // BLANK
        endcase
    end

endmodule

