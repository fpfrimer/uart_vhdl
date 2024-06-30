library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uart_rx_tb is

end entity uart_rx_tb;

architecture simulation of uart_rx_tb is
    signal clk, nrst   :   std_logic := '0';
    signal tx, rx      :   std_logic;
    signal tx_data     :   std_logic_vector(7 downto 0);
    signal rx_data     :   std_logic_vector(7 downto 0) := (others => '0');
    signal tx_load     :   std_logic := '1';
    signal tx_busy     :   std_logic;
    signal rx_busy     :   std_logic;
    signal rx_rdy      :   std_logic;
    
begin
    
    utx :   entity work.uart_tx
        generic map (9600, 50e6)
        port map(clk, nrst, tx, tx_data, tx_load, tx_busy);

    urx :   entity work.uart_rx
        generic map (9600, 50e6)
        port map(clk, nrst, rx, rx_data, rx_rdy, rx_busy);

        rx <= tx;

        clk <= not clk after 10 ns; -- 50 MHz
        nrst <= '1';

        SIM_PROC : process
        begin
            tx_data <= x"48";
            wait for 50 ns;

            tx_load <= '0';
            wait for 50 ns;

            tx_load <= '1';
            wait for 2 ms;

            tx_data <= x"31";
            wait for 50 ns;

            tx_load <= '0';
            wait for 50 ns;

            tx_load <= '1';
            wait;

        end process;
    
end architecture simulation;