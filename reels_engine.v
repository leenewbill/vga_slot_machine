module reels_engine (
    input clk,
    input rst,
    input start,

    output reg        done,
    output reg [8:0]  symbols,
    output reg [47:0] symbols_y_coords,
    output reg        symbols_valid
);

    `include "defs.vh"

    ///////////////////////////////////////////////////////////////////////
    // Reels Animation Engine FSM
    ///////////////////////////////////////////////////////////////////////
    localparam IDLE      = 8'b00000001;
    localparam CLEAR_ALL = 8'b00000010;
    localparam SPIN_ALL  = 8'b00000100;
    localparam STOP_0    = 8'b00001000;
    localparam STOP_1    = 8'b00010000;
    localparam STOP_2    = 8'b00100000;

    reg  [7:0]  state = IDLE;

    reg  [17:0] v_reel_rng = 'b0;

    wire [4:0]  p_reel_spin [2:0];
    reg  [4:0]  p_reel_spin_r [2:0];
    reg  [4:0]  p_reel [2:0];
    
    wire [2:0]  symbol [2:0];
    reg  [15:0] symbol_y_coord [2:0];
    reg         symbols_ready;
    
    reg  [3:0]  symbol_cnt = 'b0;
    reg  [17:0] clk_cnt_slow = 'b0;
    reg  [15:0] clk_cnt_fast = 'b0;

    always @(posedge clk) begin
        if (rst) begin
            {p_reel_spin_r[2], p_reel_spin_r[1], p_reel_spin_r[0]} <= 'b0;
            {p_reel[2], p_reel[1], p_reel[0]} <= 'b0;

            symbol_y_coord[0] <= 16'd176;
            symbol_y_coord[1] <= 16'd176;
            symbol_y_coord[2] <= 16'd176;

            symbols_ready <= 1'b1;

            symbol_cnt <= 'b0;
            clk_cnt_slow <= 'b0;
            clk_cnt_fast <= 'b0;

            done <= 1'b0;

            state <= IDLE;
        end else begin
            // default values
            done <= 1'b0;
            symbols_ready <= 1'b0;

            case (state)
                IDLE: begin
                    if (start) begin
                        p_reel_spin_r[0] <= p_reel_spin[0];
                        p_reel_spin_r[1] <= p_reel_spin[1];
                        p_reel_spin_r[2] <= p_reel_spin[2];

                        state <= CLEAR_ALL;
                    end
                end

                CLEAR_ALL: begin
                    if (symbol_y_coord[0] >= 16'd352) begin
                        symbol_y_coord[0] <= 'd0;
                        symbol_y_coord[1] <= 'd0;
                        symbol_y_coord[2] <= 'd0;

                        symbols_ready <= 1'b1;

                        state <= SPIN_ALL;
                    end else begin
                        if (&clk_cnt_slow) begin
                            symbol_y_coord[0] <= symbol_y_coord[0] + 1;
                            symbol_y_coord[1] <= symbol_y_coord[1] + 1;
                            symbol_y_coord[2] <= symbol_y_coord[2] + 1;

                            symbols_ready <= 1'b1;
                        end
                    
                        clk_cnt_slow <= clk_cnt_slow + 1;
                    end
                end

                SPIN_ALL: begin
                    if (symbol_y_coord[2] >= 16'd352) begin
                        symbol_y_coord[0] <= 'd0;
                        symbol_y_coord[1] <= 'd0;
                        symbol_y_coord[2] <= 'd0;

                        if (&symbol_cnt) begin
                            p_reel[0] <= p_reel_spin_r[0];

                            state <= STOP_0;
                        end else begin
                            p_reel[0] <= p_reel[0] + 1;
                            p_reel[1] <= p_reel[1] + 1;
                            p_reel[2] <= p_reel[2] + 1;
                        end

                        symbols_ready <= 1'b1;

                        symbol_cnt <= symbol_cnt + 1;
                    end else begin
                        if (&clk_cnt_fast) begin
                            symbol_y_coord[0] <= symbol_y_coord[0] + 1;
                            symbol_y_coord[1] <= symbol_y_coord[1] + 1;
                            symbol_y_coord[2] <= symbol_y_coord[2] + 1;

                            symbols_ready <= 1'b1;
                        end
                    
                        clk_cnt_fast <= clk_cnt_fast + 1;
                    end
                end

                STOP_0: begin
                    if (symbol_y_coord[0] < 16'd176) begin
                        if (&clk_cnt_slow) begin
                            symbol_y_coord[0] <= symbol_y_coord[0] + 1;

                            symbols_ready <= 1'b1;
                        end
                    
                        clk_cnt_slow <= clk_cnt_slow + 1;
                    end

                    if (symbol_y_coord[2] >= 16'd352) begin
                        symbol_y_coord[1] <= 'd0;
                        symbol_y_coord[2] <= 'd0;

                        if (&symbol_cnt) begin
                            p_reel[1] <= p_reel_spin_r[1];

                            state <= STOP_1;
                        end else begin
                            p_reel[1] <= p_reel[1] + 1;
                            p_reel[2] <= p_reel[2] + 1;
                        end

                        symbols_ready <= 1'b1;

                        symbol_cnt <= symbol_cnt + 1;
                    end else begin
                        if (&clk_cnt_fast) begin
                            symbol_y_coord[1] <= symbol_y_coord[1] + 1;
                            symbol_y_coord[2] <= symbol_y_coord[2] + 1;

                            symbols_ready <= 1'b1;
                        end
                    
                        clk_cnt_fast <= clk_cnt_fast + 1;
                    end
                end

                STOP_1: begin
                    if (symbol_y_coord[1] < 16'd176) begin
                        if (&clk_cnt_slow) begin
                            symbol_y_coord[1] <= symbol_y_coord[1] + 1;

                            symbols_ready <= 1'b1;
                        end
                    
                        clk_cnt_slow <= clk_cnt_slow + 1;
                    end

                    if (symbol_y_coord[2] >= 16'd352) begin
                        symbol_y_coord[2] <= 'd0;

                        if (&symbol_cnt) begin
                            p_reel[2] <= p_reel_spin_r[2];

                            state <= STOP_2;
                        end else begin
                            p_reel[2] <= p_reel[2] + 1;
                        end

                        symbols_ready <= 1'b1;

                        symbol_cnt <= symbol_cnt + 1;
                    end else begin
                        if (&clk_cnt_fast) begin
                            symbol_y_coord[2] <= symbol_y_coord[2] + 1;

                            symbols_ready <= 1'b1;
                        end
                    
                        clk_cnt_fast <= clk_cnt_fast + 1;
                    end
                end

                STOP_2: begin
                    if (symbol_y_coord[2] == 16'd176) begin
                        done <= 1'b1;

                        state <= IDLE;
                    end else begin
                        if (&clk_cnt_slow) begin
                            symbol_y_coord[2] <= symbol_y_coord[2] + 1;

                            symbols_ready <= 1'b1;
                        end
                    
                        clk_cnt_slow <= clk_cnt_slow + 1;
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    ///////////////////////////////////////////////////////////////////////
    // Virtual Reels "random number generator" (clock counter)
    ///////////////////////////////////////////////////////////////////////
    always @(posedge clk) begin
        v_reel_rng <= v_reel_rng + 1;
    end

    ///////////////////////////////////////////////////////////////////////
    // Map virtual reels to physical reels
    ///////////////////////////////////////////////////////////////////////
    virtual_reel virtual_reel0 (
        .v_reel (v_reel_rng[5:0]),
        .p_reel (p_reel_spin[0])
    );

    virtual_reel virtual_reel1 (
        .v_reel (v_reel_rng[11:6]),
        .p_reel (p_reel_spin[1])
    );

    virtual_reel virtual_reel2 (
        .v_reel (v_reel_rng[17:12]),
        .p_reel (p_reel_spin[2])
    );

    ///////////////////////////////////////////////////////////////////////
    // Map physical reels to symbols
    ///////////////////////////////////////////////////////////////////////
    physical_reel physical_reel0 (
        .p_reel (p_reel[0]),
        .symbol (symbol[0])
    );

    physical_reel physical_reel1 (
        .p_reel (p_reel[1]),
        .symbol (symbol[1])
    );

    physical_reel physical_reel2 (
        .p_reel (p_reel[2]),
        .symbol (symbol[2])
    );

    ///////////////////////////////////////////////////////////////////////
    // Register outputs
    ///////////////////////////////////////////////////////////////////////
    always @(posedge clk) begin
        symbols          <= {symbol[2], symbol[1], symbol[0]};
        symbols_y_coords <= {symbol_y_coord[2], symbol_y_coord[1], symbol_y_coord[0]};
        symbols_valid    <= symbols_ready;  
    end

endmodule
