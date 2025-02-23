//  by CrazyBird
module ddr_rw_ctrl
(
    input  wire                 ddr_clk         ,
    input  wire                 ddr_rst         ,
    
    input  wire                 ddr_wr_busy     ,
    output wire     [127:0]     ddr_wr_data     ,
    output wire     [ 15:0]     ddr_wr_mask     ,
    output wire     [ 31:0]     ddr_wr_addr     ,
    output reg                  ddr_wr_en       ,
    input  wire                 ddr_wr_ack      ,
    
    input  wire                 ddr_rd_busy     ,
    output wire     [ 31:0]     ddr_rd_addr     ,
    output reg                  ddr_rd_en       ,
    input  wire     [127:0]     ddr_rd_data     ,
    input  wire                 ddr_rd_valid    ,
    
    input  wire                 wframe_pclk     ,
    input  wire                 wframe_vsync    ,
    input  wire                 wframe_data_en  ,
    input  wire     [ 63:0]     wframe_data     ,
    
    input  wire                 rframe_pclk     ,
    input  wire                 rframe_vsync    ,
    input  wire                 rframe_data_en  ,
    output wire     [ 15:0]     rframe_data     
);
//----------------------------------------------------------------------
parameter C_BURST_LEN = 32;
parameter C_RD_END_ADDR = 38400;                                        //  1024*600/16
assign ddr_wr_mask = 16'b0;

//----------------------------------------------------------------------
reg             [3:0]           wframe_vsync_dly;
reg             [3:0]           rframe_vsync_dly;

always @(posedge ddr_clk)
begin
    if(ddr_rst == 1'b1)
    begin
        wframe_vsync_dly <= 4'b0;
        rframe_vsync_dly <= 4'b0;
    end
    else
    begin
        wframe_vsync_dly <= {wframe_vsync_dly[2:0],wframe_vsync};
        rframe_vsync_dly <= {rframe_vsync_dly[2:0],rframe_vsync};
    end
end

reg             [4:0]           wfifo_cnt;

always @(posedge ddr_clk)
begin
    if(ddr_rst == 1'b1)
        wfifo_cnt <= 5'h1f;
    else
    begin
        if(wframe_vsync_dly[3:2] == 2'b01)
            wfifo_cnt <= 5'h1f;
        else if(wfifo_cnt > 5'd0)
            wfifo_cnt <= wfifo_cnt - 1'b1;
        else
            wfifo_cnt <= 5'b0;
    end
end

reg             [4:0]           rfifo_cnt;

always @(posedge ddr_clk)
begin
    if(ddr_rst == 1'b1)
        rfifo_cnt <= 5'h1f;
    else
    begin
        if(rframe_vsync_dly[3:2] == 2'b10)
            rfifo_cnt <= 5'h1f;
        else if(rfifo_cnt > 5'd0)
            rfifo_cnt <= rfifo_cnt - 1'b1;
        else
            rfifo_cnt <= 5'b0;
    end
end

reg                             wfifo_rst;

always @(posedge ddr_clk)
begin
    if(ddr_rst == 1'b1)
        wfifo_rst <= 1'b1;
    else
    begin
        if(wfifo_cnt == 5'b0)
            wfifo_rst <= 1'b0;
        else
            wfifo_rst <= 1'b1;
    end
end

reg                             rfifo_rst;

always @(posedge ddr_clk)
begin
    if(ddr_rst == 1'b1)
        rfifo_rst <= 1'b1;
    else
    begin
        if(rfifo_cnt == 5'b0)
            rfifo_rst <= 1'b0;
        else
            rfifo_rst <= 1'b1;
    end
end

//----------------------------------------------------------------------
wire            [127:0]         wfifo_rdata;
wire                            wfifo_renb;
wire            [  9:0]         wfifo_rcnt;

W0_FIFO u_W0_FIFO
(
    .a_rst_i        (wfifo_rst      ),
    .rst_busy       (               ),
    
    .wr_clk_i       (wframe_pclk    ),
    .wdata          (wframe_data    ),
    .wr_en_i        (wframe_data_en ),
    .full_o         (               ),
    .wr_datacount_o (               ),
    
    .rd_clk_i       (ddr_clk        ),
    .rdata          (wfifo_rdata    ),
    .rd_en_i        (wfifo_renb     ),
    .empty_o        (               ),
    .rd_datacount_o (wfifo_rcnt     )
);

wire            [7:0]           rfifo_wcnt;

R0_FIFO u_R0_FIFO
(
    .a_rst_i        (rfifo_rst      ),
    .rst_busy       (               ),
    
    .wr_clk_i       (ddr_clk        ),
    .wdata          (ddr_rd_data    ),
    .wr_en_i        (ddr_rd_valid   ),
    .full_o         (               ),
    .wr_datacount_o (rfifo_wcnt     ),
    
    .rd_clk_i       (rframe_pclk    ),
    .rdata          (rframe_data    ),
    .rd_en_i        (rframe_data_en ),
    .empty_o        (               ),
    .rd_datacount_o (               )
);

//----------------------------------------------------------------------
reg             [1:0]               wframe_index;

always @(posedge ddr_clk)
begin
    if(ddr_rst == 1'b1)
        wframe_index <= 2'b0;
    else
    begin
        if(wframe_vsync_dly[3:2] == 2'b10)
        begin
            if(wframe_index < 2'd2)
                wframe_index <= wframe_index + 1'b1;
            else
                wframe_index <= 2'b0;
        end
        else
            wframe_index <= wframe_index;
    end
end

reg             [1:0]               rframe_index;

always @(posedge ddr_clk)
begin
    if(ddr_rst == 1'b1)
        rframe_index <= 2'd0;
    else
    begin
        if(rframe_vsync_dly[3:2] == 2'b10)
        begin
            if(wframe_index == 2'd0)
                rframe_index <= 2'd2;
            else
                rframe_index <= wframe_index - 1'b1;
        end
        else
            rframe_index <= rframe_index;
    end
end

//----------------------------------------------------------------------
//  state machine 
localparam S_IDLE  = 2'd0;
localparam S_WRITE = 2'd1;
localparam S_READ  = 2'd2;
localparam S_FINISH= 2'd3;

reg             [1:0]           state;
reg             [8:0]           wdata_cnt;
reg             [8:0]           rdata_cnt;

reg             [18:0]          raddr;

always @(posedge ddr_clk)
begin
    if(ddr_rst == 1'b1)
        state <= S_IDLE;
    else
    begin
        case(state)
            S_IDLE : 
            begin
                if(wfifo_rcnt >= C_BURST_LEN)
                    state <= S_WRITE;
                else if((raddr < C_RD_END_ADDR)&&(rfifo_wcnt < 8'd64))
                    state <= S_READ;
                else
                    state <= S_IDLE;
            end
            S_WRITE : 
            begin
                if((ddr_wr_busy == 1'b0)&&(wdata_cnt == C_BURST_LEN - 1'b1))
                    state <= S_FINISH;
                else
                    state <= S_WRITE;
            end
            S_READ : 
            begin
                if((ddr_rd_busy == 1'b0)&&(rdata_cnt == C_BURST_LEN - 1'b1))
                    state <= S_FINISH;
                else
                    state <= S_READ;
            end
            S_FINISH : state <= S_IDLE;
        endcase
    end
end

always @(posedge ddr_clk)
begin
    if(state == S_WRITE)
    begin
        if(ddr_wr_busy == 1'b0)
            wdata_cnt <= wdata_cnt + 1'b1;
        else
            wdata_cnt <= wdata_cnt;
    end
    else
        wdata_cnt <= 9'b0;
end

always @(posedge ddr_clk)
begin
    if(state == S_READ)
    begin
        if(ddr_rd_busy == 1'b0)
            rdata_cnt <= rdata_cnt + 1'b1;
        else
            rdata_cnt <= rdata_cnt;
    end
    else
        rdata_cnt <= 9'b0;
end

reg             [18:0]          waddr;

always @(posedge ddr_clk)
begin
    if(ddr_rst == 1'b1)
        waddr <= 19'b0;
    else
    begin
        if(wframe_vsync_dly[3:2] == 2'b01)
            waddr <= 19'b0;
        else if((state == S_WRITE)&&(ddr_wr_busy == 1'b0))
            waddr <= waddr + 1'b1;
        else
            waddr <= waddr;
    end
end

always @(posedge ddr_clk)
begin
    if(ddr_rst == 1'b1)
        raddr <= 19'b0;
    else
    begin
        if(rframe_vsync_dly[3:2] == 2'b01)
            raddr <= 19'b0;
        else if((state == S_READ)&&(ddr_rd_busy == 1'b0))
            raddr <= raddr + 1'b1;
        else
            raddr <= raddr;
    end
end

assign ddr_wr_addr = {wframe_index,waddr};
assign ddr_wr_data = wfifo_rdata;

always @(posedge ddr_clk)
begin
    if(ddr_rst == 1'b1)
        ddr_wr_en <= 1'b0;
    else
    begin
        if((state == S_WRITE)&&(ddr_wr_busy == 1'b0))
            ddr_wr_en <= 1'b1;
        else
            ddr_wr_en <= 1'b0;
    end
end

assign wfifo_renb = ddr_wr_en;

assign ddr_rd_addr = {rframe_index,raddr};

always @(posedge ddr_clk)
begin
    if(ddr_rst == 1'b1)
        ddr_rd_en <= 1'b0;
    else
    begin
        if((state == S_READ)&&(ddr_rd_busy == 1'b0))
            ddr_rd_en <= 1'b1;
        else
            ddr_rd_en <= 1'b0;
    end
end

endmodule
