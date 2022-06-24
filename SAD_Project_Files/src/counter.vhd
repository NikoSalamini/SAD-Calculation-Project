library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity counter is
	generic (
		NBit : positive := 8
	);
    port (
		en: in std_logic; 
		rst,clk : in std_logic;
		overflow: out std_logic;
		o: out std_logic_vector( NBit-1 downto 0 )
	);
end counter;

-- when en = '1' it counts the clock cycles, otherwise the counting is freezed
-- set overflow to 1 when max_val is reached

architecture beh of counter is
signal output_reg : std_logic_vector (NBit-1 downto 0);
constant max_val  : std_logic_vector (NBit-1 downto 0) := (others => '1');
begin
	counter_output_reg: process(clk, rst)
	begin
		if(rst = '1') then 
			output_reg <= (others => '0');
			overflow <= '0';
		elsif((rising_edge(clk))) then 
		
			if (en='1') then
			
				-- when max_val is reached the counter overflows and overflow is set to '1'
				if (unsigned(output_reg) = unsigned(max_val)) then 
					output_reg <= (others => '0');
					overflow <= '1';
				else
					output_reg <= output_reg + 1;
				end if;
				
			end if;
		end if;
	end process counter_output_reg;
	
	-- mapping the output
	o <= output_reg; 
end beh;
