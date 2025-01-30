module reels_sprites #(
    H_RES = 640,    // horizontal resolution (pixels)
    CORDW = 16,     // signed coordinate width (bits)
    CHANW = 4,      // color channel width (bits)
    COLRW = 3*CHANW // color width: three channels (bits)
)(    
    input wire logic clk_pix,                            // clock
    input wire logic rst_pix,                            // reset
    input wire logic line,                           // start of active screen line
    input wire logic signed [CORDW-1:0] sx, sy,      // screen position
    input wire logic signed [CORDW-1:0] sprx [2:0], spry [2:0],  // sprite position
    input wire logic [8:0] symbols_pix,

    output logic [COLRW-1:0] spr_pix_colr [2:0],
    output logic drawing_spr [2:0]
);

    ///////////////////////////////////////////////////////////////////////
    // Sprites
    ///////////////////////////////////////////////////////////////////////
    // sprite parameters
    localparam SX_OFFS    =  3;  // horizontal screen offset (pixels): +1 for CLUT
    localparam SPR_WIDTH  = 32;  // bitmap width in pixels
    localparam SPR_HEIGHT = 32;  // bitmap height in pixels
    localparam SPR_SCALE  =  2;  // 2^2 = 4x scale
    localparam SPR_DRAWW  = SPR_WIDTH * 2**SPR_SCALE;  // draw width
    localparam SPR_SPX    =  2;  // horizontal speed (pixels/frame)
    
    // color parameters
    localparam CIDXW = 4;         // color index width (bits)
    localparam TRANS_INDX = 'h9;  // transparant color index
    localparam PAL_FILE = "slot_machine_4b.mem";  // palette file

    // bitmap files
    localparam SPR_FILE_0 = "blank.mem";
    localparam SPR_FILE_1 = "lime.mem";
    localparam SPR_FILE_2 = "orange.mem";
    localparam SPR_FILE_3 = "grape.mem";
    localparam SPR_FILE_4 = "banana.mem";
    localparam SPR_FILE_5 = "blueberry.mem";
    localparam SPR_FILE_6 = "cherry.mem";
    localparam SPR_FILE_7 = "coconut.mem";

    // sprite control signals
    logic [CIDXW-1:0] r0_spr_pix_indx [7:0], r1_spr_pix_indx [7:0], r2_spr_pix_indx [7:0];  // pixel colour index
    logic r0_drawing [7:0], r1_drawing [7:0], r2_drawing [7:0];  // drawing at (sx,sy)

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_0),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_0_spr_0 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[0]),
        .spry    (spry[0]),
        .pix     (r0_spr_pix_indx[0]),
        .drawing (r0_drawing[0])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_1),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_0_spr_1 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[0]),
        .spry    (spry[0]),
        .pix     (r0_spr_pix_indx[1]),
        .drawing (r0_drawing[1])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_2),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_0_spr_2 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[0]),
        .spry    (spry[0]),
        .pix     (r0_spr_pix_indx[2]),
        .drawing (r0_drawing[2])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_3),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_0_spr_3 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[0]),
        .spry    (spry[0]),
        .pix     (r0_spr_pix_indx[3]),
        .drawing (r0_drawing[3])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_4),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_0_spr_4 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[0]),
        .spry    (spry[0]),
        .pix     (r0_spr_pix_indx[4]),
        .drawing (r0_drawing[4])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_5),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_0_spr_5 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[0]),
        .spry    (spry[0]),
        .pix     (r0_spr_pix_indx[5]),
        .drawing (r0_drawing[5])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_6),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_0_spr_6 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[0]),
        .spry    (spry[0]),
        .pix     (r0_spr_pix_indx[6]),
        .drawing (r0_drawing[6])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_7),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_0_spr_7 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[0]),
        .spry    (spry[0]),
        .pix     (r0_spr_pix_indx[7]),
        .drawing (r0_drawing[7])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_0),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_1_spr_0 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[1]),
        .spry    (spry[1]),
        .pix     (r1_spr_pix_indx[0]),
        .drawing (r1_drawing[0])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_1),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_1_spr_1 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[1]),
        .spry    (spry[1]),
        .pix     (r1_spr_pix_indx[1]),
        .drawing (r1_drawing[1])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_2),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_1_spr_2 (
        .clk    (clk_pix),
        .rst    (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[1]),
        .spry    (spry[1]),
        .pix     (r1_spr_pix_indx[2]),
        .drawing (r1_drawing[2])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_3),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_1_spr_3 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[1]),
        .spry    (spry[1]),
        .pix     (r1_spr_pix_indx[3]),
        .drawing (r1_drawing[3])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_4),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_1_spr_4 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[1]),
        .spry    (spry[1]),
        .pix     (r1_spr_pix_indx[4]),
        .drawing (r1_drawing[4])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_5),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_1_spr_5 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[1]),
        .spry    (spry[1]),
        .pix     (r1_spr_pix_indx[5]),
        .drawing (r1_drawing[5])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_6),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_1_spr_6 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[1]),
        .spry    (spry[1]),
        .pix     (r1_spr_pix_indx[6]),
        .drawing (r1_drawing[6])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_7),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_1_spr_7 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[1]),
        .spry    (spry[1]),
        .pix     (r1_spr_pix_indx[7]),
        .drawing (r1_drawing[7])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_0),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_2_spr_0 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[2]),
        .spry    (spry[2]),
        .pix     (r2_spr_pix_indx[0]),
        .drawing (r2_drawing[0])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_1),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_2_spr_1 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[2]),
        .spry    (spry[2]),
        .pix     (r2_spr_pix_indx[1]),
        .drawing (r2_drawing[1])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_2),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_2_spr_2 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[2]),
        .spry    (spry[2]),
        .pix     (r2_spr_pix_indx[2]),
        .drawing (r2_drawing[2])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_3),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_2_spr_3 (
        .clk    (clk_pix),
        .rst    (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[2]),
        .spry    (spry[2]),
        .pix     (r2_spr_pix_indx[3]),
        .drawing (r2_drawing[3])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_4),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_2_spr_4 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[2]),
        .spry    (spry[2]),
        .pix     (r2_spr_pix_indx[4]),
        .drawing (r2_drawing[4])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_5),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_2_spr_5 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[2]),
        .spry    (spry[2]),
        .pix     (r2_spr_pix_indx[5]),
        .drawing (r2_drawing[5])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_6),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_2_spr_6 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[2]),
        .spry    (spry[2]),
        .pix     (r2_spr_pix_indx[6]),
        .drawing (r2_drawing[6])
    );

    sprite #(
        .CORDW      (CORDW),
        .H_RES      (H_RES),
        .SX_OFFS    (SX_OFFS),
        .SPR_FILE   (SPR_FILE_7),
        .SPR_WIDTH  (SPR_WIDTH),
        .SPR_HEIGHT (SPR_HEIGHT),
        .SPR_SCALE  (SPR_SCALE),
        .SPR_DATAW  (CIDXW)
    ) r_2_spr_7 (
        .clk     (clk_pix),
        .rst     (rst_pix),
        .line,
        .sx,
        .sy,
        .sprx    (sprx[2]),
        .spry    (spry[2]),
        .pix     (r2_spr_pix_indx[7]),
        .drawing (r2_drawing[7])
    );

    ///////////////////////////////////////////////////////////////////////
    // MUX sprite control signals
    ///////////////////////////////////////////////////////////////////////
    logic [CIDXW-1:0] spr_pix_indx [2:0];

    always_comb begin
        spr_pix_indx[0] = r0_spr_pix_indx[symbols_pix[2:0]];
        spr_pix_indx[1] = r1_spr_pix_indx[symbols_pix[5:3]];
        spr_pix_indx[2] = r2_spr_pix_indx[symbols_pix[8:6]];
    end            

    ///////////////////////////////////////////////////////////////////////
    // Color Lookup Tables
    ///////////////////////////////////////////////////////////////////////
    clut_simple #(
        .COLRW (COLRW),
        .CIDXW (CIDXW),
        .F_PAL (PAL_FILE)
    ) clut_0 (
        .clk_write  (clk_pix),
        .clk_read   (clk_pix),
        .we         (0),
        .cidx_write (0),
        .cidx_read  (spr_pix_indx[0]),
        .colr_in    (0),
        .colr_out   (spr_pix_colr[0])
    );

    clut_simple #(
        .COLRW (COLRW),
        .CIDXW (CIDXW),
        .F_PAL (PAL_FILE)
    ) clut_1 (
        .clk_write  (clk_pix),
        .clk_read   (clk_pix),
        .we         (0),
        .cidx_write (0),
        .cidx_read  (spr_pix_indx[1]),
        .colr_in    (0),
        .colr_out   (spr_pix_colr[1])
    );

    clut_simple #(
        .COLRW (COLRW),
        .CIDXW (CIDXW),
        .F_PAL (PAL_FILE)
    ) clut_2 (
        .clk_write  (clk_pix),
        .clk_read   (clk_pix),
        .we         (0),
        .cidx_write (0),
        .cidx_read  (spr_pix_indx[2]),
        .colr_in    (0),
        .colr_out   (spr_pix_colr[2])
    );

    // account for transparency and delay drawing signal to match CLUT delay (1 cycle)
    always_ff @(posedge clk_pix) begin
        drawing_spr[0] <= r0_drawing[symbols_pix[2:0]] && (spr_pix_indx[0] != TRANS_INDX);
        drawing_spr[1] <= r1_drawing[symbols_pix[5:3]] && (spr_pix_indx[1] != TRANS_INDX);
        drawing_spr[2] <= r2_drawing[symbols_pix[8:6]] && (spr_pix_indx[2] != TRANS_INDX);
    end

endmodule