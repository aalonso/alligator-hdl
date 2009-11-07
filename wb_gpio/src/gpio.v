/* gpio.v General pourpuse parallel input/output module
 * Wishbone complaint
 *
 * Copyright (C) 2009 Adrian Alonso Lazcano <aalonso00@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with self library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 *
*/

module gpio_in (clk_i, rst_i, we_i, stb_i, ack_o, data_i, data_o, irq_o);
    parameter size = 16;
	/* wb slave interface */
	input clk_i, rst_i, we_i, stb_i;
    output ack_o;
    input [size:0] data_i;
    output [size:0] data_o;
	/* input port signals */
    input [size:0] gpio_i;
	/* interrupt signal */
	output irq_o;

	/* Trigger interrupt irq_o ^ irq */
	reg irq;
	
	/* Read data */
	always @ (posedge clk_i)
	begin
		if (rst_i) begin
			ack_o <= 0;
			data_o <= {size{1'b 0}};
		end
		else if (we_i and stb_i) begin
			ack_o <= 1;
			data_o <= gpio_i;
		end
		else begin
			ack_o <= 0;
			data_o <= data_o;
		end
	end
	
	/* Generate interrupt */
	always @ (negedge gpio_i)
	begin
		if (rst_i)
			irq <= 0;
		else
			irq<= 1;
	end    
	
	always @ (irq) begin
		if (rst_i or ~irq) 
			irq_o <= 0;	
		else begin
			irq_o <= irq_o ^ irq;
			irq <= 0;
		end
	end
endmodule

module gpio_out (clk_i, rst_i, we_i, stb_i, ack_o, data_i, data_o);
    parameter size = 16;
	/* wb slave interface */
	input clk_i, rst_i, we_i, stb_i;
    output ack_o;
    input [size:0] data_i;
    output [size:0] data_o;
	/* output port signals */
    output reg [size:0] gpio_o;
    
	assign ack_o <= stb_i;
	assign data_o <= gpio_o;	

	/* Write data */
    always @ (posedge clk_i)
    begin
		if (rst_i)
			gpio_o <= {size{1'b 0}};
		else if (we_i and stb_i)
			gpio_o <= data_i;
		else
			gpio_o <= gpio_o;
    end
endmodule
