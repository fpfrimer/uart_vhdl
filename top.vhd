library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.sevenSegPro.all;

entity top is
    port (
        MAX10_CLK1_50   :   in  std_logic;
        SW              :   in  std_logic_vector(9 downto 0);
        LEDR            :   out std_logic_vector(9 downto 0);
        KEY             :   in  std_logic_vector(1 downto 0);
        HEX0            :   out std_logic_vector(0 to 6);
        HEX1            :   out std_logic_vector(0 to 6);
        ARDUINO_IO      :   inout std_logic_vector(15 downto 0)
    );
end entity top;

architecture behavioral of top is

    signal clk, nrst    :   std_logic;
    signal rx, tx       :   std_logic;
    signal rx_busy      :   std_logic;
    signal tx_busy      :   std_logic;
    signal rx_rdy       :   std_logic;
    signal tx_data      :   std_logic_vector(7 downto 0);
    signal rx_data      :   std_logic_vector(7 downto 0);
    signal hex          :   display_vector(1 downto 0);
    signal tx_load      :   std_logic;

begin

    clk <= MAX10_CLK1_50;
    nrst <= KEY(0);
    tx_load <= KEY(1);
    ARDUINO_IO(1) <= tx;
    rx <= ARDUINO_IO(0);
    tx_data <= SW(7 downto 0);
    HEX0 <= hex(0);
    HEX1 <= hex(1);
    LEDR(0) <= tx_busy;
    LEDR(1) <= rx_busy;
    LEDR(2) <= rx_rdy;

    hex <= display(rx_data, 2, 16, anode);

    utx :   entity work.uart_tx
        generic map (115200, 50e6)
        port map(clk, nrst, tx, tx_data, tx_load, tx_busy);

    urx :   entity work.uart_rx
        generic map (115200, 50e6)
        port map(clk, nrst, rx, rx_data, rx_rdy, rx_busy, '1');

end architecture;