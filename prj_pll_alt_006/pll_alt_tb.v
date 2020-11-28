`timescale 1ns/1ns

module pll_tb(
);

reg rst_n;								//reset, active low
reg clk_50m;							//clock, 50MHz

//=======================================================
//Initialization
initial
begin
	rst_n = 1;
	clk_50m = 0;
	
	#10000;								//simulation time 10000ns
	$stop;
end

always #10 clk_50m <= ~clk_50m;	//produce clock, 50MHz

//=======================================================
//Top module instanciation
pll_alt_top pll_altera_inst
(
	.IN_CLK_50M		(clk_50m),
	.IN_RST_N		(rst_n)
);

endmodule