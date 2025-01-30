module physical_reel
(
    input wire logic [4:0] p_reel,

    output     logic [2:0] symbol
);

    `include "defs.vh"

    always_comb begin
        case (p_reel)
            1:  symbol = LIME;
            3:  symbol = BANANA;
            5:  symbol = ORANGE;
            7:  symbol = BLUEBERRY;
            9:  symbol = GRAPE;
            11: symbol = LIME;
            13: symbol = BANANA;
            15: symbol = CHERRY;
            17: symbol = ORANGE;
            19: symbol = GRAPE;
            21: symbol = LIME;
            23: symbol = BLUEBERRY;
            25: symbol = BANANA;
            27: symbol = ORANGE;
            29: symbol = GRAPE;
            31: symbol = COCONUT;
            default: symbol = BLANK;
        endcase
    end

endmodule

