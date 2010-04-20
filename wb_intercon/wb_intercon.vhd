----------------------------------------------------------------------------------
-- Company: National Polytechnic Institute
-- Engineer: Adrian Alonso <aalonso00@gmail.com>
-- 
-- Create Date:    18:08:06 04/12/2010 
-- Design Name: 
-- Module Name:    wb_intercon - behavioral 
-- Project Name:   wb_intercon
-- Target Devices: Virtex5
-- Tool versions: 
-- Description: Wishbone complaint intercon module 
--              shared bus multiplexor
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
-- 
-- Adress decoding
--      x"0000FF00"
--        ||||||++---> Access wb slave registers
--        ||||++-----> Address to access wb slv module
--        ++++-------> Kernel magic numbers       
                
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--
entity wb_intercon is
    generic (
        C_WB_DBUS_SIZE  : integer := 32;
        C_LOW_ADDR      : std_logic_vector (0 to C_WB_DBUS_SIZE-1) := x"00000000"
        C_SLV_NUM       : integer := 32
    );
    port ( 
        wb_clk_i     : in  std_logic;
        wb_rst_i     : in  std_logic;
        wb_stb_i     : in  std_logic;
        wb_cyc_i     : in  std_logic;
        wb_we_i      : in  std_logic;
        -- wishbone master
        mst_addr_i   : in  std_logic_vector(0 to C_WB_DBUS_SIZE-1);
        mst_data_i   : out std_logic_vector(0 to C_WB_DBUS_SIZE-1);
        mst_ack_o    : out std_logic;
        -- wisbone slave 0
        slv_data_o_0 : in  std_logic_vector(0 to C_WB_DBUS_SIZE-1);
        slv_ack_o_0  : in  std_logic;
        -- wishbone slave 1
        slv_data_o_1 : in  std_logic_vector(0 to C_WB_DBUS_SIZE-1);
        slv_ack_o_1  : in  std_logic;
        wb_err_o     : out std_logic;
        wb_rty_o     : out std_logic
    );
end wb_intercon;

architecture behavioral of wb_intercon is

    signal addr_reg std_logic_vector(0 to 7);

begin
    
    mst_ack_o <= slv_ack_o_0 or slv_ack_o_1;

    addr_reg <= mst_addr_i (8 to 15);

    pdecode: process (addr_reg)
    begin
        case addr_reg is
            when x"00" => mst_data_i <= slv_data_o_0;
            when x"01" => mst_data_i <= slv_data_o_1;
            when others => mst_data_i <= x"00000000";
        end case;
    end process pdecode;

    pstb: process (mst_stb_i, mst_cyc_i, addr_reg)
    begin
        if (add_reg = x"00") then
            slv_stb_o_0 <= mst_stb and mst_cyc;
        elsif (add_reg = x"01") then
            slv_stb_o_1 <= mst_stb and mst_cyc;
        else
            slv_stb_o_0 <= '0';
            slv_stb_o_1 <= '0';
        end if;
    end process pstb;
end behavioral;
