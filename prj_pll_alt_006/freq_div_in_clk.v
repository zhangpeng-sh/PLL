`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         Beijing ICfusion technology Co.Ltd
// Website:         http://icfusion.com/
// Create Date:     24/04/2020
//
// Design Name:     weide
// Target Devices:  PRA006
// Tool Versions:   Quartus Prime 18.1
//
// Module Name:     freq_div
// Project Name:
// Description:     Divide the input pulse frequency into the frequency as the parameter specified with the inputted clk.
// 
// Dependencies: 
// Revision:
// Additional Comments: DIV_COEF must be LESS THAN 65535.
//
//////////////////////////////////////////////////////////////////////////////////

module freq_div_in_clk #(
	parameter		DIV_COEF = 50
)
(
	input				clk,					    	//时钟50MHz
	input				rst_n,				    	//复位信号，低电平有效
	output	reg	out_p							//分频DIV_COEF倍后输出信号
);

reg	[15:0]		div_cnt;						//分频计数器

//=======================================================
//用输入脉冲产生DIV_COEF倍分频脉冲
always @ (posedge clk or negedge rst_n)
	if (~rst_n)										//如果复位
	begin
		div_cnt <= 0;								//分频计数器清零
		out_p <= 1'b0;								//输出脉冲清零
	end
	else												//如果没复位
	begin
		if (div_cnt < (DIV_COEF - 1))			//如果分频计数器小于分频系数减1
		begin
			out_p <= 0;								//输出脉冲保持0
			div_cnt <= div_cnt + 1;				//分频计数器在每个时钟脉冲上升沿加1
		end
		else											//如果分频计数器不小于分频系数减1
		begin
			div_cnt <= 0;							//分频计数器清零
			out_p <= 1;								//输出分频后时间脉冲
		end
	end

endmodule