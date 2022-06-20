library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity accumulator is
	generic (
		NBit: positive := 16 
	);
	
	port(
		i: in std_logic_vector(NBit-1 downto 0);
		rst,clk : in std_logic;
		en: in std_logic;
		counter_ow: in std_logic;
		o: out std_logic_vector( NBit-1 downto 0 );
		data_valid: out std_logic
	);
end accumulator;

-- Sum the input at each clock if en = '0', set data_valid to 1 when counter overflows
architecture beh of accumulator is

signal output_oreg : std_logic_vector (NBit-1 downto 0);
signal data_valid_oreg : std_logic;

begin
	accumulator_p: process(rst, clk)
	begin
	
		if(rst = '1') then 
			output_oreg <= (others => '0');
			data_valid_oreg <= '0';
			
		elsif(rising_edge(clk) and en='1' and data_valid_oreg='0') then 
		
			output_oreg <= std_logic_vector(unsigned(output_oreg) + unsigned(i));
			
			-- check on counter overflow value to prevent the restart of summing 
			-- when overflow
			if(counter_ow = '1') then 
				data_valid_oreg <= '1';
			end if;
				
		end if;
		
	end process accumulator_p;
	
	-- Mapping the output
	data_valid <= data_valid_oreg;
	o <= output_oreg;
	
end beh;
