----------------------------------------------------------------------------------
-- Company: N/A
-- Engineer: Felipe Walter Dafico Pfrimer - fpfirmer@gmail.com
-- 
-- Create Date: 30/05/2024
-- Design Name: SevenSegPro
-- Project Name: SevenSegPro Package
-- Target Devices: Any
-- Tool Versions: Any
-- Description: 
--     SevenSegPro is a comprehensive package for controlling 7-segment displays,
--     enabling easy integration and display of decimal, hexadecimal, and multibase digits
--     in digital systems.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

-- Libraries and packages
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

----------------------------------------------------------------------------------
-- Package sevenSegPro: a comprehensive package for controlling 7-segment displays, 
-- enabling easy integration and display of decimal, hexadecimal, and multibase digits 
-- in digital systems.
package sevenSegPro is

	-- Types Declaration:

	-- Define the types for 7-segment display configurations and vectors.
	type display_type is (anode, catode);
	type display_vector is array(natural range <>) of std_logic_vector(0 to 6);

	-- Functions Declaration:

	----------------------------------------------------------------------------------
	-- Function: seven_segment_decode
	-- 
	-- Description:
	--     The `seven_segment_decode` function converts a 4-bit hexadecimal input 
	--     (hex_num) into a 7-segment display output. It supports both common anode 
	--     and common cathode displays, as specified by the mode parameter.
	--     - hex_num: 4-bit input representing a hexadecimal digit (0-9, A-F).
	--     - mode: Specifies the type of 7-segment display (anode or cathode).
	--     - Returns: A 7-bit std_logic_vector where each bit represents a segment 
	--       (a-g) of the 7-segment display, with the mapping dependent on the display type.
	----------------------------------------------------------------------------------
	function seven_segment_decode (
		hex_num : in std_logic_vector(3 downto 0); 
		mode 	: in display_type) 
	return std_logic_vector;

	----------------------------------------------------------------------------------
	-- Function: sl_to_dt
	-- 
	-- Description:
	--     The `sl_to_dt` function converts a single bit std_logic input (mode) to 
	--     the corresponding display_type enumeration. This is typically used to 
	--     select between common anode and common cathode display types based on 
	--     a binary control signal.
	--     - mode: std_logic input representing the display mode.
	--       '0' indicates anode, '1' indicates cathode.
	--     - Returns: A display_type value (anode or cathode).
	----------------------------------------------------------------------------------
	function sl_to_dt(mode	:	std_logic) return display_type;

	----------------------------------------------------------------------------------
	-- Function: display
	-- Engineer: [Your Name]
	-- 
	-- Description:
	--     The `display` functions generates a vector of 7-segment display outputs 
	--     for a given integer, unsigned or std_logic_vector. It supports displaying numbers in various bases 
	--     (e.g., decimal, hexadecimal) across multiple 7-segment digits. The function 
	--     also allows for both common anode and common cathode displays.
	--     - number: The integer value to be displayed.
	--     - digits: The number of 7-segment digits to use for the display.
	--     - num_base: The numerical base (e.g., 10 for decimal, 16 for hexadecimal).
	--     - mode: Specifies the type of 7-segment display (anode or cathode).
	--     - Returns: A display_vector where each element is a 7-segment encoded value 
	--       corresponding to a digit of the input number.
	----------------------------------------------------------------------------------
	function display(
		number 	: integer; 
		digits	: positive; 
		num_base: integer; 
		mode 	: display_type) 
	return display_vector;

	function display(
		number 	: unsigned; 
		digits	: positive; 
		num_base: integer; 
		mode 	: display_type) 
	return display_vector;

	function display(
		number 	: std_logic_vector; 
		digits	: positive; 
		num_base: integer; 
		mode 	: display_type) 
	return display_vector;
	
	----------------------------------------------------------------------------------
	-- Component: counter
	-- 
	-- Description:
	--     The `counter` component is a configurable binary counter designed to generate 
	--     test patterns for the 7-segment display module. This counter can be used to 
	--     produce a sequence of values at a specified update frequency, which can then 
	--     be displayed and verified on the 7-segment display.
	-- 
	-- Generics:
	--     - clk_freq: The clock frequency in Hz (default is 50 MHz).
	--     - update_freq: The frequency in Hz at which the counter updates its value 
	--       (default is 100 Hz).
	--     - n_bits: The number of bits for the counter (default is 10 bits).
	-- 
	-- Ports:
	--     - clk: The input clock signal.
	--     - nRst: Active-low reset signal to initialize the counter.
	--     - en: Enable signal for the counter.
	--     - q: The output value of the counter as an unsigned vector.
	-- 
	-- Usage:
	--     Instantiate this counter in a testbench or a design to generate input values 
	--     for testing the 7-segment display. The counter's output can be connected to 
	--     the display module to observe and verify the correct representation of 
	--     numerical values.
	-- 
	-- Note:
	--     This component is intended to assist in testing and verifying the display 
	--     functionality and should be adapted accordingly for specific test scenarios.
	----------------------------------------------------------------------------------
	component counter is
		generic(
			clk_freq	:	integer := 50e6;
			update_freq	:	integer := 100;
			n_bits		:	integer := 10
		);
		port(
			clk		:	in		std_logic;
			nRst	:	in		std_logic;
			en		:	in		std_logic;
			q		:	out 	unsigned(n_bits - 1 downto 0)
		);
	end component counter;
	
end package sevenSegPro;

-- Package body:
package body sevenSegPro is

	-- Functions Declaration
	function seven_segment_decode (hex_num : in std_logic_vector(3 downto 0); mode : in display_type) return std_logic_vector is
		variable segment_out : std_logic_vector(6 downto 0);
	begin
		-- decoder
		case hex_num is
			when "0000" => segment_out := "0000001";  -- Displays 0
			when "0001" => segment_out := "1001111";  -- Displays 1
			when "0010" => segment_out := "0010010";  -- Displays 2
			when "0011" => segment_out := "0000110";  -- Displays 3
			when "0100" => segment_out := "1001100";  -- Displays 4
			when "0101" => segment_out := "0100100";  -- Displays 5
			when "0110" => segment_out := "0100000";  -- Displays 6
			when "0111" => segment_out := "0001111";  -- Displays 7
			when "1000" => segment_out := "0000000";  -- Displays 8
			when "1001" => segment_out := "0000100";  -- Displays 9
			when "1010" => segment_out := "0001000";  -- Displays A
			when "1011" => segment_out := "1100000";  -- Displays B
			when "1100" => segment_out := "0110001";  -- Displays C
			when "1101" => segment_out := "1000010";  -- Displays D
			when "1110" => segment_out := "0110000";  -- Displays E
			when "1111" => segment_out := "0111000";  -- Displays F
			when others => segment_out := "1111111";  -- Turns off all segments
		end case;

		-- Display type
		if mode = catode then
			return not segment_out;
		else 
			return segment_out;
		end if;
	end function seven_segment_decode;
	
	function sl_to_dt(mode	:	std_logic) return display_type is
	begin
		if mode = '1' then
			return catode;
		else 
			return anode;
		end if;
			
	end function sl_to_dt;
	
	function display(number : integer; digits: positive; num_base : integer; mode : in display_type) return display_vector is
		variable dec_digits	:	display_vector(digits - 1 downto 0);
		variable temp			:	integer;
	begin
		assert num_base <= 16 and num_base >= 0
			report "num_base is greater than 16"
			severity error;
			
		temp := number;
		for i in 0 to digits - 1 loop
			
			dec_digits(i) := seven_segment_decode(std_logic_vector(to_unsigned(temp mod num_base, 4)), mode);
			temp := temp/num_base;
			
		end loop;
		return dec_digits;
	end function display;
	
	function display(number : unsigned; digits: positive; num_base : integer; mode : in display_type) return display_vector is
		variable dec_digits	:	display_vector(digits - 1 downto 0);
		variable temp			:	integer;
	begin
		assert num_base <= 16 and num_base >= 0
			report "num_base is greater than 16"
			severity error;
			
		temp := to_integer(number);
		for i in 0 to digits - 1 loop
			
			dec_digits(i) := seven_segment_decode(std_logic_vector(to_unsigned(temp mod num_base, 4)), mode);
			temp := temp/num_base;
			
		end loop;
		return dec_digits;
	end function display;
	
	function display(number : std_logic_vector; digits: positive; num_base : integer; mode : in display_type) return display_vector is
		variable dec_digits	:	display_vector(digits - 1 downto 0);
		variable temp			:	integer;
	begin
		assert num_base <= 16 and num_base >= 0
			report "num_base is greater than 16"
			severity error;
		temp := to_integer(unsigned(number));
		for i in 0 to digits - 1 loop
			
			dec_digits(i) := seven_segment_decode(std_logic_vector(to_unsigned(temp mod num_base, 4)), mode);
			temp := temp/num_base;
			
		end loop;
		return dec_digits;
	end function display;
end sevenSegPro;

-- Conatador
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
	generic(
		clk_freq		:	integer := 50e6;
		update_freq	:	integer := 100;
		n_bits		:	integer := 10
	);
	port(
		clk	:	in		std_logic;
		nRst	:	in		std_logic;
		en		:	in		std_logic;
		q		:	out 	unsigned(n_bits - 1 downto 0)
	);
end entity counter;

architecture behavioral of counter is
	constant max	:	integer := clk_freq/update_freq;
begin

	process(clk, nRst) is
		variable ticks	:	integer range 0 to max - 1;
		variable cnt 	:	unsigned(n_bits - 1 downto 0);
	begin
		if nRst = '0' then
			cnt := (others => '0');
			ticks := 0; 
		elsif rising_edge(clk) then
			if en = '1' then
				if ticks = max - 1 then
					ticks := 0;
					cnt := cnt + 1;
				else 
					ticks := ticks + 1;
				end if;
			end if;
		end if;
		q <= cnt;
	end process;

end architecture;
