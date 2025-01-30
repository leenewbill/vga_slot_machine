`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
///////////////////////////////////////////////////////////////////////////////
 
module top (
    input wire logic CLK100MHZ,
    input wire logic RST,
    input wire logic BUTT1,
    input wire logic LEVER,

    output logic [6:0]  SEG, 
    output logic [7:0]  AN,
    output logic [15:0] LED,
    output logic [3:0]  VGA_R,
    output logic [3:0]  VGA_G,
    output logic [3:0]  VGA_B,
    output logic        VGA_HS,
    output logic        VGA_VS
);

    ///////////////////////////////////////////////////////////////////////////
    // Clock Buffer
    ///////////////////////////////////////////////////////////////////////////
    logic clk_100;
         
    always_comb begin
        clk_100 = CLK100MHZ;
    end

    ///////////////////////////////////////////////////////////////////////////
    // Reset Bridge - Synchronize async reset deassertion
    ///////////////////////////////////////////////////////////////////////////
    (* ASYNC_REG = "TRUE" *) logic rst, rst_q;

    always_ff @(posedge clk_100 or posedge RST) begin
        if (RST) begin
            {rst, rst_q} <= 2'b11;
        end else begin
            {rst, rst_q} <= {rst_q, 1'b0};
        end
    end

    ///////////////////////////////////////////////////////////////////////////
    // Debounce Button Inputs
    ///////////////////////////////////////////////////////////////////////////
    logic butt1_pulse;
    logic lever_pulse;

    debouncer butt1_debounce (
        .clk           (clk_100),
        .signal_in     (BUTT1),
        .deb_pulse_out (butt1_pulse)
    );

    debouncer lever_debounce (
        .clk           (clk_100),
        .signal_in     (LEVER),
        .deb_pulse_out (lever_pulse)
    );

    ///////////////////////////////////////////////////////////////////////////
    // Slot Machine Engine
    ///////////////////////////////////////////////////////////////////////////
    logic [8:0]  symbols;
    logic [47:0] symbols_y_coords;
    logic        symbols_valid;
    logic [15:0] bal_bcd;

    sm_engine sm_engine (
        .clk   (clk_100),
        .rst,
        .lever (lever_pulse),

        .symbols,
        .symbols_y_coords,
        .symbols_valid,
        .bal_bcd
    );
    
    ///////////////////////////////////////////////////////////////////////////
    // Video Controller
    ///////////////////////////////////////////////////////////////////////////
    vga vga (
        .clk_100,
        .rst,
        .symbols,
        .symbols_y_coords,
        .symbols_valid,

        .vga_r  (VGA_R),
        .vga_g  (VGA_G),
        .vga_b  (VGA_B),
        .vga_hs (VGA_HS),
        .vga_vs (VGA_VS)
    );
    
    ///////////////////////////////////////////////////////////////////////////
    // Seven Segment Display
    ///////////////////////////////////////////////////////////////////////////
    logic        disp_bal_sym = 1'b1; // default to displaying balance on 7SDs
    logic [15:0] disp_data;
    logic [3:0]  an_out;

    always_ff @(posedge clk_100) begin
        if (rst) begin
            disp_bal_sym <= 1'b1;
        end else begin
            if (butt1_pulse) begin
                disp_bal_sym <= ~disp_bal_sym;
            end 
        end
    end

    always_comb begin
        disp_data = disp_bal_sym ? bal_bcd : {4'b0000, 
                                              1'b0, symbols[2:0], 
                                              1'b0, symbols[5:3], 
                                              1'b0, symbols[8:6]};
    end

    seven_seg_disp seven_seg_disp (
        .clk (clk_100),
        .x   (disp_data),
        .seg (SEG),
        .an  (an_out)
    );
 
    always_comb begin 
        AN = disp_bal_sym ? {4'b1111, an_out} : {5'b11111, an_out[2:0]};
    end

    ///////////////////////////////////////////////////////////////////////////
    // LEDs
    ///////////////////////////////////////////////////////////////////////////
    logic [15:0] lever_pulse_cnt = 'b0;

    always_ff @(posedge clk_100) begin
        if (rst) begin
            lever_pulse_cnt <= 'b0;
        end else begin
            if (lever_pulse) begin
                lever_pulse_cnt <= lever_pulse_cnt + 1;
            end
        end
    end

    always_comb begin
        LED = lever_pulse_cnt; 
    end

endmodule
