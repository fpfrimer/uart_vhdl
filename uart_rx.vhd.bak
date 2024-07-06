library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uart_rx is
    generic(
        baud        :   integer := 9600;    -- Baud rate
        input_freq  :   integer := 50e6     -- Frequência do sistema
    );
    port (
        clk, nrst   :   in      std_logic;
        rx          :   in      std_logic;  -- Pino RX
        rx_data     :   out     std_logic_vector(7 downto 0);   -- Dado recebido
        rx_rdy      :   out     std_logic;  -- Flag de recepção 
        rx_busy     :   out     std_logic   -- Indica que um dado está chegando
    );
end entity uart_rx;

architecture behavioral of uart_rx is

    constant max_cycles     :   integer := input_freq/baud; -- ciclos para um período de recepção
    signal shift_register   :   std_logic_vector(9 downto 0);   -- Registrador de deslocamento para recepção
    signal rx_started       :   boolean;    -- Indica um start bit em RX
    signal rx_transf        :   boolean;    -- Habilita a recepção de um bit
    
begin
    
    -- Processo de recepção
    rx_proc: process(clk, nrst)
        variable i : integer range 0 to 10;
    begin
        if nrst = '0' then
            shift_register <= (others => '1');
            rx_started <= False;            
            rx_busy <= '0';
            rx_rdy <= '0';
            i := 0;
        elsif rising_edge(clk) then
            if rx_started then
                if rx_transf then
                    shift_register <= rx & shift_register(9 downto 1);                    
                    if i = 10 then
                        i := 0;
                        rx_busy <= '0';
                        rx_rdy <= '1';
                        rx_started <= False;
                        rx_data <= shift_register(8 downto 1);
                        shift_register <= (others => '0');
                    else
                        i := i + 1;
                    end if;
                end if;                
            elsif rx = '0' then
                rx_started <= True;
                rx_busy <= '1';
            end if;
            
        end if;
    end process rx_proc;


    -- processo de cadência (baud rate)
    baud_proc: process(clk, nrst)
        variable i  :   integer range 0 to max_cycles;        
    begin
        if nrst = '0' or not rx_started then
            i := 0;
            rx_transf <= False;
        elsif rising_edge(clk) then 
            if i = max_cycles - 1 then
                i := 0;
            elsif i = max_cycles/2 - 1 then
                rx_transf <= True;
                i := max_cycles/2;
            elsif rx_started then
                i := i + 1;
                rx_transf <= False;
            end if;
        end if;
    end process baud_proc;
    
end architecture behavioral;