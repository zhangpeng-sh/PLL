`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         Beijing ICfusion technology Co.Ltd
// Website:         http://icfusion.com/
// Create Date:     24/04/2020
//
// Design Name:     weide
// Target Devices:  PRA006
// Tool Versions:   Quartus Prime 18.1.0
//
// Module Name:     pll_alt_top
// Project Name:    
// Description:     
// 
// Dependencies: 
// Revision:
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module pll_alt_top
(
	input	IN_CLK_50M,							//输入时钟50MHz
	input	IN_RST_N								//复位信号，低电平有效
);

reg	pll_rst_n;								//用来复位PLL的变量
wire	locked;									//PLL锁定信号
wire	clk_100m;								//PLL的输出时钟，100MHz
wire	us_p;										//微秒时间脉冲
wire	ms_p;										//毫秒时间脉冲
wire	s_p;										//秒时间脉冲

assign	rst_n = locked;					//用PLL的锁定信号产生复位信号

//=======================================================
//复位信号同步化
always @ (posedge IN_CLK_50M)
	pll_rst_n <= IN_RST_N;					//用输入时钟对复位信号rst_n打一拍，
													//即把复位信号通过1个寄存器缓存一下，
													//可以把输入的复位信号与时钟同步化，提高系统稳定性

//=======================================================
//产生微秒脉冲信号
freq_div_in_clk #(
	.DIV_COEF	(50)							//分频系数
)
us_pulse_inst
(
	.clk			(IN_CLK_50M),				//输入时钟
	.rst_n		(rst_n),						//复位信号，低电平有效
	.out_p		(us_p)						//输出时间脉冲
);

//=======================================================
//产生毫秒脉冲信号
freq_div_in_pul #(
	.DIV_COEF	(1000)						//分频系数
)
ms_pulse_inst
(
	.clk			(IN_CLK_50M),				//输入时钟
	.rst_n		(rst_n),						//复位信号，低电平有效
	.in_p			(us_p),						//输入时间脉冲
	.out_p		(ms_p)						//输出时间脉冲
);

//=======================================================
//产生秒脉冲信号
freq_div_in_pul #(
	.DIV_COEF	(1000)
)
s_pulse_inst
(
	.clk			(IN_CLK_50M),
	.rst_n		(rst_n),
	.in_p			(ms_p),
	.out_p		(s_p)
);

//=======================================================
//PLL模块，输入时钟50MHz，输出时钟100MHz
pll_100m	pll_100m_inst 
(
	.areset		(!pll_rst_n),	//复位信号，高电平有效
	.inclk0		(IN_CLK_50M),	//输入时钟，50MHz
	.c0			(clk_100m),		//输出时钟，100MHz
	.locked		(locked)			//PLL锁定信号
);

endmodule