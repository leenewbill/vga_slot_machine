module payout_table (
    input [8:0] symbols,
    output [15:0] payout
);

    `include "defs.vh"

    wire [2:0] symbol [2:0];
    
    assign {symbol[2], symbol[1], symbol[0]} = symbols;

    assign payout = 
            ((symbol[0] == COCONUT)   && (symbol[1] == COCONUT)   && (symbol[2] == COCONUT))   ? 5000 :
            ((symbol[0] == CHERRY)    && (symbol[1] == CHERRY)    && (symbol[2] == CHERRY))    ? 2000 :
            ((symbol[0] == BLUEBERRY) && (symbol[1] == BLUEBERRY) && (symbol[2] == BLUEBERRY)) ? 1000 :
            ((symbol[0] == BANANA)    && (symbol[1] == BANANA)    && (symbol[2] == BANANA))    ? 500  :
            ((symbol[0] == GRAPE)     && (symbol[1] == GRAPE)     && (symbol[2] == GRAPE))     ? 100  :
            ((symbol[0] == ORANGE)    && (symbol[1] == ORANGE)    && (symbol[2] == ORANGE))    ? 25   :
            ((symbol[0] == LIME)      && (symbol[1] == LIME)      && (symbol[2] == LIME))      ? 10   :
            (((symbol[0] == CHERRY) && (symbol[1] == CHERRY)) || 
             ((symbol[0] == CHERRY) && (symbol[2] == CHERRY)) ||
             ((symbol[1] == CHERRY) && (symbol[2] == CHERRY)))                                 ? 50   :
            ((symbol[0] == CHERRY) || (symbol[1] == CHERRY) || (symbol[2] == CHERRY))          ? 5    :
            ((symbol[0] != BLANK) && (symbol[1] != BLANK) && (symbol[2] != BLANK))             ? 1    : 0;
                    
endmodule

