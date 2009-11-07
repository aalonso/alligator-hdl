/* ps2_rx.v PS/2 keyboard interface
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

module ps2_rx (rst, en, ps2_data_i, ps2_clk_i, data_o, status, sync, busy);
    input rst, en, ps2_data_i, ps2_clk_i;
    output sync, busy;
    output reg [7:0] data_o;
    output reg [7:0] status;

    reg [3:0] nbit;    
    reg [8:0] data;
		
    always @ (posedge ps2_clk_i)
    begin
        sync <= 1;
        if (~rst) begin        
            nbit <= 4'b 0000;          
            sync <= 0;
            busy <= 1;
        end
        else if (en) begin
            if (nbit < 4'b 1001) begin
                busy <= 1;                        /* Bussy */
                nbit <= nbit + 1;
                data <= {data[8:1], ps2_data_i};
            end
            else begin
                nbit <= 4'b 0000;
                data_o <= data;                     /* Output data*/
                status[0] <= ~^data;                /* Parity bit */
                status[1] <= status[0] & data[8];   /* Error bit */
                status[2] <= 1;                     /* Data ready */
                busy <= 0;                          /* Clear busy and sync */
                sync <= 0;
            end     
        end
    end
endmodule

