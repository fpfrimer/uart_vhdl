library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uart_tx is
    generic(
        baud        :   integer := 9600;
        input_freq  :   integer := 50e6
    );
    port (
        clk, nrst   :   in  std_logic;
        tx          :   out std_logic;
        tx_data     :   in  std_logic_vector(7 downto 0);
        tx_load     :   in  std_logic;
        tx_busy     :   out std_logic
    );
end entity uart_tx;

architecture behavioral of uart_tx is
    constant max_cycles     :   integer := input_freq/baud;
    signal shift_register   :   std_logic_vector(9 downto 0);
    signal tx_loaded        :   boolean;
    signal tx_transf        :   boolean;
begin
    
    

    tx_proc: process(clk, nrst)
        variable i : integer range 0 to 9;
    begin
        if nrst = '0' then
            shift_register <= (others => '1');
            tx_loaded <= False;            
            tx_busy <= '0';
            tx <= '1';
            i := 0;
        elsif rising_edge(clk) then
            if tx_load = '1' then
                shift_register <= '0' & tx_data & '1';
                tx_loaded <= True;
                tx_busy <= '1';
                tx <= '1';
            elsif tx_loaded then
                if tx_transf then
                    tx <= shift_register(0); 
                    shift_register <= '1' & shift_register(9 downto 1);                    
                    if i = 9 then 
                        tx_loaded <= False;
                        tx_busy <= '0';
                        i := 0;
                    else
                        i := i + 1;
                    end if;
                end if;
            end if;
            
        end if;
    end process tx_proc;

    baud_proc: process(clk, nrst)
        variable i  :   integer range 0 to max_cycles;        
    begin
        if nrst = '0' then
            i := 0;
            tx_transf <= False;
        elsif rising_edge(clk) then
            if i = max_cycles - 1 then
                i := 0;
                tx_transf <= True;
            else
                i := i + 1;
                tx_transf <= False;
            end if;
        end if;
    end process baud_proc;
    
    
end architecture behavioral;