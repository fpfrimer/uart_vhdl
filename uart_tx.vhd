library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uart_tx is
    generic(
        baud        :   integer := 9600;    -- Baud rate
        input_freq  :   integer := 50e6     -- Frequência do sistema
    );
    port (
        clk, nrst   :   in  std_logic;
        tx          :   out std_logic;                      -- Pino TX
        tx_data     :   in  std_logic_vector(7 downto 0);   -- Dado a ser transmitido
        tx_load     :   in  std_logic;                      -- Envia o dado
        tx_busy     :   out std_logic                       -- Indica que o dado está sendo enviado
    );
end entity uart_tx;

architecture behavioral of uart_tx is

    constant max_cycles     :   integer := input_freq/baud; -- ciclos para um período de transmissão
    signal shift_register   :   std_logic_vector(9 downto 0);   -- Registrador de deslocamento para transmissão
    signal tx_loaded        :   boolean;    -- Indica que um dado foi carregado no registrador de deslocamento 
    signal tx_transf        :   boolean;    -- Habilita a transmissão de um bit

begin    
    
    -- Processo de envio
    tx_proc: process(clk, nrst)
        variable i : integer range 0 to 10;
    begin
        if nrst = '0' then
            shift_register <= (others => '1');
            tx_loaded <= False;            
            tx_busy <= '0';
            tx <= '1';
            i := 0;
        elsif rising_edge(clk) then
            if tx_load = '0' then
                shift_register <= '1' & tx_data & '0';
                tx_loaded <= True;
                tx_busy <= '1';
            elsif tx_loaded then
                if tx_transf then
                    tx <= shift_register(0); 
                    shift_register <= '1' & shift_register(9 downto 1);                    
                    if i = 10 then 
                        tx_loaded <= False;
                        tx_busy <= '0';
						--tx <= '1';
                        i := 0;
                    else
                        i := i + 1;
                    end if;
                end if;
            end if;
            
        end if;
    end process tx_proc;

    -- processo de cadência (baud rate)
    baud_proc: process(clk, nrst)
        variable i  :   integer range 0 to max_cycles;        
    begin
        if nrst = '0' or not tx_loaded then
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