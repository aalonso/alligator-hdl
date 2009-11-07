/* wb_ps2.v PS/2 keyboard interface
 * Copyright (C) 2009 Adrian Alonso <aalonso00@gmail.com>
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

module wb_ps2 (addr_i, cyc_i, stb_i, we_i, rst_i,
		clk_i, ack_o, data_i, data_o);
	input addr_i, cyc_i, we_i, rst_i, clk_i;
	output ack_o;
	input [7:0] data_i;
	output [7:0] data_o;

	/* Internal registers */
	reg [7:0] wcreg;
	reg [7:0] wdreg;

	/* Read/Write internal registers */
	always @ (posedge clk_i)
	begin
		if (rst_i) begin
			wcreg <= {8{1'b 0}};
			wdreg <= {8{1'b 0}};
		end
		else if (addr_i)
			wdreg <= data_i;
		else
			wcreg <= data_i;
	end
	/* Todo: Complete me */

	end
endmodule

