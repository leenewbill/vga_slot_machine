module vga
(
    input wire logic clk_100,
    input wire logic rst,
    input wire logic [8:0]  symbols,
    input wire logic [47:0] symbols_y_coords,
    input wire logic        symbols_valid,

    output logic [3:0] vga_r,
    output logic [3:0] vga_g,
    output logic [3:0] vga_b,
    output logic       vga_hs,
    output logic       vga_vs
);

    localparam H_RES = 640;     // screen dimensions
    localparam CORDW = 16;      // signed coordinate width (bits)
    localparam CHANW = 4;       // color channel width (bits)
    localparam COLRW = 3*CHANW; // color width: three channels (bits)

    ///////////////////////////////////////////////////////////////////////////
    // Generate pixel clock
    ///////////////////////////////////////////////////////////////////////////
    logic clk_pix;
    logic clk_pix_locked;
    logic rst_pix;

    clock_480p clock_pix_inst (
       .clk_100m (clk_100),
       .rst,
       .clk_pix,
       .clk_pix_5x (),  // not used for VGA output
       .clk_pix_locked
    );

    always_ff @(posedge clk_pix) begin
        rst_pix <= !clk_pix_locked;  // wait for clock lock
    end

    ///////////////////////////////////////////////////////////////////////////
    // Display sync signals and coordinates
    ///////////////////////////////////////////////////////////////////////////
    logic signed [CORDW-1:0] sx, sy;
    logic hsync, vsync;
    logic de, frame, line;

    display_480p #(
        .H_RES (H_RES), 
        .CORDW (CORDW)
    ) display_inst (
        .clk_pix,
        .rst_pix,
        .sx,
        .sy,
        .hsync,
        .vsync,
        .de,
        .frame,
        .line
    );

    ///////////////////////////////////////////////////////////////////////////
    // Sync symbols data from clk_100 to clk_pix domain
    ///////////////////////////////////////////////////////////////////////////

    // toggle reg when pulse received in clk_100 domain
    logic toggle_100 = 1'b0;
    
    always_ff @(posedge clk_100) begin 
        toggle_100 <= toggle_100 ^ symbols_valid;
    end

    // cross to clk_pix domain via shift reg
    (* ASYNC_REG = "TRUE" *) logic [3:0] shr_pix = 4'b0;
    
    always_ff @(posedge clk_pix) begin
        shr_pix <= {shr_pix[2:0], toggle_100};
    end

    // output pulse when transition occurs
    logic symbols_valid_pix;

    always_comb begin
        symbols_valid_pix = shr_pix[3] ^ shr_pix[2];
    end
    
    // register symbols data in clk_pix domain
    logic [8:0]  symbols_pix;
    logic [47:0] symbols_y_coords_pix;

    always_ff @(posedge clk_pix) begin
        if (rst_pix) begin
            symbols_pix <= 'b0;
            symbols_y_coords_pix <= {16'd176, 16'd176, 16'd176};
        end else begin
            if (symbols_valid_pix) begin
                symbols_pix <= symbols;
                symbols_y_coords_pix <= symbols_y_coords;
            end
        end
    end

    ///////////////////////////////////////////////////////////////////////////
    // Register coordinates to draw sprites
    ///////////////////////////////////////////////////////////////////////////
    logic signed [CORDW-1:0] sprx [2:0], spry [2:0];  

    always_ff @(posedge clk_pix) begin
        //if (symbols_valid_pix) begin
            sprx[0] <= 64;
            spry[0] <= symbols_y_coords_pix[15:0];

            sprx[1] <= 256;
            spry[1] <= symbols_y_coords_pix[31:16];

            sprx[2] <= 448;
            spry[2] <= symbols_y_coords_pix[47:32];
        //end
    end

    ///////////////////////////////////////////////////////////////////////////
    // Sprite control signals
    ///////////////////////////////////////////////////////////////////////////
    logic [COLRW-1:0] spr_pix_colr [2:0];
    logic drawing_spr [2:0];
    
    reels_sprites #(
        .H_RES (H_RES), 
        .CORDW (CORDW),
        .CHANW (CHANW),
        .COLRW (COLRW)
    ) reels_sprites (
        .clk_pix,
        .rst_pix,
        .line,
        .sx,
        .sy,
        .sprx,
        .spry,
        .symbols_pix,

        .spr_pix_colr,
        .drawing_spr
    );

    ///////////////////////////////////////////////////////////////////////////
    // calculate if coordinates are in slot machine frame
    ///////////////////////////////////////////////////////////////////////////
    logic drawing_frame;
    
    always_comb drawing_frame = 
            (sy != 239) && 
            ((sy < 128) ||  (sy >= 352) ||
             (sx < 64)  || 
             ((sx >= 192) && (sx < 256)) || 
             ((sx >= 384) && (sx < 448)) || 
             (sx >= 576));

    ///////////////////////////////////////////////////////////////////////////
    // display color: blanking, frame, sprite, or background
    ///////////////////////////////////////////////////////////////////////////
    logic [CHANW-1:0] display_r, display_g, display_b;

    always_comb {display_r, display_g, display_b} =
            (!de)            ? 'h000 :           // blanking interval: black
            (drawing_frame)  ? 'h333 :           // frame: dark grey
            (drawing_spr[0]) ? spr_pix_colr[0] : // reel 0 sprite color
            (drawing_spr[1]) ? spr_pix_colr[1] : // reel 1 sprite color
            (drawing_spr[2]) ? spr_pix_colr[2] : // reel 2 sprite color
                               'hFFF;            // else white

    ///////////////////////////////////////////////////////////////////////////
    // VGA output
    ///////////////////////////////////////////////////////////////////////////
    always_ff @(posedge clk_pix) begin
        vga_hs <= hsync;
        vga_vs <= vsync;
        vga_r <= display_r;
        vga_g <= display_g;
        vga_b <= display_b;
    end

endmodule