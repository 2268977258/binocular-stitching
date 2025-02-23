/************************************************************************************
 Company:           
 Author:            han
 Author Email:      sciencefuture@163.com
 Create Date:       2022-02-22
 Module Name:       
 HDL Type:        Verilog HDL
 Description: 
    calculate how many continuous pixels are there
    by now it's only support 16bit value for the FAST keypoint 

    simulation and hardware check ready 2022-03-10
 Additional Comments: 

************************************************************************************/

module Count_Continuous_Bit (
    input             i_clk,

    input  [15:0]     i_value,
    output            o_valid
    );



logic Valid;
assign o_valid=Valid;

logic [11:0] Marker=12'b1111_1111_1000;//here supports how many continuous pixel to detect a keypoint


always @(posedge i_clk)
begin
    if(Marker==(i_value[11:0]&Marker))//1
    begin
        Valid<=16'd1;
    end
    else if(Marker==(i_value[12:1]&Marker))
    begin
        Valid<=16'd1;
    end
    else if(Marker==(i_value[13:2]&Marker))
    begin
        Valid<=16'd1;
    end
    else if(Marker==(i_value[14:3]&Marker))
    begin
        Valid<=16'd1;
    end
    else if(Marker==(i_value[15:4]&Marker))
    begin
        Valid<=16'd1;
    end
    else if(Marker==({i_value[0:0],i_value[15:5]}&Marker))
    begin
        Valid<=16'd1;
    end
    else if(Marker==({i_value[1:0],i_value[15:6]}&Marker))
    begin
        Valid<=16'd1;
    end
    else if(Marker==({i_value[2:0],i_value[15:7]}&Marker))
    begin
        Valid<=16'd1;
    end
    else if(Marker==({i_value[3:0],i_value[15:8]}&Marker))
    begin
        Valid<=16'd1;
    end
    else if(Marker==({i_value[4:0],i_value[15:9]}&Marker))
    begin
        Valid<=16'd1;
    end
    else if(Marker==({i_value[5:0],i_value[15:10]}&Marker))
    begin
        Valid<=16'd1;
    end
    else if(Marker==({i_value[6:0],i_value[15:11]}&Marker))
    begin
        Valid<=16'd1;
    end
    else if(Marker==({i_value[7:0],i_value[15:12]}&Marker))
    begin
        Valid<=16'd1;
    end
    else if(Marker==({i_value[8:0],i_value[15:13]}&Marker))
    begin
        Valid<=16'd1;
    end
    else if(Marker==({i_value[9:0],i_value[15:14]}&Marker))
    begin
        Valid<=16'd1;
    end
    else if(Marker==({i_value[10:0],i_value[15:15]}&Marker))
    begin
        Valid<=16'd1;
    end
    else
    begin
        Valid<=16'd0;
    end
end


endmodule
