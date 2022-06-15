library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtractor is
	generic (
		NBit: positive := 8
	);
	
	port (
		input1: in std_logic_vector (NBit-1 downto 0);
		input2: in std_logic_vector (NBit-1 downto 0);
		abs_diff: out std_logic_vector (NBit-1 downto 0)
	);
end subtractor;

-- Perform the difference between the 2 inputs and get the abs value

architecture beh of subtractor is
begin
	
	sub_process: process(input1, input2)
		begin
		
			if unsigned(input1) >= unsigned(input2) then 
				abs_diff <= std_logic_vector( unsigned(input1)-unsigned(input2) );
			else
				abs_diff <= std_logic_vector( unsigned(input2)-unsigned(input1) );
			end if;
			
		end process sub_process;

end architecture;