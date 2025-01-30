
module sm_engine (
    input clk,
    input rst,
    input lever,

    output [8:0]  symbols,
    output [47:0] symbols_y_coords,
    output        symbols_valid,

    output reg [15:0] bal_bcd
);

    ///////////////////////////////////////////////////////////////////////////
    // Slot Machine FSM
    ///////////////////////////////////////////////////////////////////////////
    localparam IDLE           = 8'b00000001;
    localparam UPDATE_BCD1    = 8'b00000010;
    localparam ANIMATE_REELS  = 8'b00000100;
    localparam UPDATE_BALANCE = 8'b00001000;
    localparam UPDATE_BCD2    = 8'b00010000;

    reg  [7:0]  state = IDLE;

    reg         animate_start = 1'b0;
    wire        animate_done;

    reg  [15:0] balance = 'd1000;
    wire [15:0] payout;

    reg         update_bcd = 1'b1;

    always @(posedge clk) begin
        if (rst) begin
            animate_start <= 1'b0;
            balance <= 'd1000;
            update_bcd <= 1'b1;

            state <= IDLE;
        end else begin
            // default values
            animate_start <= 1'b0;
            update_bcd <= 1'b0;

            case (state)
                IDLE: begin
                    if (lever) begin
                        balance <= balance - 1;

                        animate_start <= 1'b1;
    
                        state <= UPDATE_BCD1;
                    end
                end

                UPDATE_BCD1: begin
                    update_bcd <= 1'b1;

                    state <= ANIMATE_REELS;
                end

                ANIMATE_REELS: begin
                    if (animate_done) begin
                        state <= UPDATE_BALANCE;
                    end
                end

                UPDATE_BALANCE: begin
                    balance <= balance + payout;

                    state <= UPDATE_BCD2;
                end

                UPDATE_BCD2: begin
                    update_bcd <= 1'b1;

                    state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    ///////////////////////////////////////////////////////////////////////////
    // Reels Animation Engine
    ///////////////////////////////////////////////////////////////////////////
    reels_engine reels_engine (
        .clk              (clk),
        .rst              (rst),
        .start            (animate_start),
      
        .done             (animate_done),
        .symbols          (symbols),
        .symbols_y_coords (symbols_y_coords),
        .symbols_valid    (symbols_valid)
    );

    ///////////////////////////////////////////////////////////////////////////
    // Payout Calculation Table
    ///////////////////////////////////////////////////////////////////////////
    payout_table payout_table (
        .symbols (symbols),
        .payout  (payout)
    );

    ///////////////////////////////////////////////////////////////////////////
    // Binary to BCD Conversion
    ///////////////////////////////////////////////////////////////////////////
    wire        bcd_done;
    wire [15:0] dat_bcd_o;

    binary_to_bcd #(
        .BCD_DIGITS_OUT_PP (4)
    ) binary_to_bcd (
        .clk_i        (clk),
        .ce_i         (1'b1),
        .rst_i        (rst),
        .start_i      (update_bcd),
        .dat_binary_i (balance),
        .dat_bcd_o    (dat_bcd_o),
        .done_o       (bcd_done)
    );

    always @(posedge clk) begin
        if (bcd_done)
        begin
            bal_bcd <= dat_bcd_o;
        end
    end

endmodule
