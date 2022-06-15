library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity counter is
	generic (
		NBit : positive := 8
	);
    port (
		en: in std_logic; -- if set to 1 the counter increases
		rst,clk : in std_logic;
		o: out std_logic_vector( NBit-1 downto 0 )
	);
end Counter;

-- when en = '1' it counts the clock, otherwise it is freezed

architecture beh of counter is
signal count : std_logic_vector (NBit-1 downto 0);
begin
	counter_p: process(clk, rst)
	begin
		if(rst = '1') then 
			count <= (others => '0');
		elsif((rising_edge(clk)) AND en='1') then 
			count <= count + 1;
		end if;
		o <= count;
	end process counter_p;
end beh;
