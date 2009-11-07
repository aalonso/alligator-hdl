/* ps2_tx.v PS/2 keyboard interface
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

/*
 * status register
 * status[0] -> Parity bit
 * status[1] -> Error bit
 * status[2] -> Data ready
 */

module ps2_tx (clk, rst, en, ps2_data_o, ps2_clk_o, data_i, status, sync, busy);
    input clk, rst, en, sync;
    input [7:0] data_i;
    output ps2_data_o, ps2_clk_o, busy;
    output reg [7:0] status;

    reg parity, start;
    reg [8:0] frame;

    integer i;

    initial begin
        i = 0;
    end

    parity = data_i[7] ^ data_i[6] ^ data_i[5] ^ data_i[4]
             data_i[3] ^ data_i[2] ^ data_i[1] ^ data_i[0];
                 
    frame = {parity, data_i};

    always (posedge clk or posedge ps2_clk_o)
    begin
        if (~rst) begin
            i <= 0;
            start <= 0;
        end
        else if (~start)
            ps2_clk_o <= 0;
            if (start_bit)
                ps2_data_o <= 0;
            if (start_bit)
                start <= 1;
            start_bit <= 1;
        else if (start && i < 9) begin
            ps2_data_o <= frame[i];    
            i = i + 1;
        end
        else begin
        end
    end
endmodule

