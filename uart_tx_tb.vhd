library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uart_tx_tb is

end entity uart_tx_tb;

architecture simulation of uart_tx_tb is
    signal clk, nrst   :   std_logic := '0';
    signal tx          :   std_logic;
    signal tx_data     :   std_logic_vector(7 downto 0);
    signal tx_load     :   std_logic;
    signal tx_busy     :   std_logic;
    
begin
    
    uut :   entity work.uart_tx
        generic map (9600, 50e6)
        port map(clk, nrst, tx, tx_data, tx_load, tx_busy);

        clk <= not clk after 10 ns;
        nrst <= '1';

        SIM_PROC : process
        begin
            tx_data <= x"48";
            wait for 50 ns;

            tx_load <= '1';
            wait for 50 ns;

            tx_load <= '0';
            wait;

        end process;
    
end architecture simulation;