library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity counter_tb is
end counter_tb;

architecture beh of counter_tb is

	--const def
	constant clk_period	: time := 100 ns;
	constant NBit : positive := 8;

	--component dut
	component counter
		generic (
			NBit : positive := 8
		);
		port (
			en: in std_logic; 
			rst,clk : in std_logic;
			overflow: out std_logic;
			o: out std_logic_vector( NBit-1 downto 0 )
		);
	end component;

	--signal of testbench
	signal clk_ext	: std_logic := '0' ;
	signal rst_ext 	: std_logic := '0' ;
	signal en_ext	: std_logic := '1';
	signal overflow_ext: std_logic;
	signal o_ext	: std_logic_vector(NBit-1 downto 0) ;
	signal testing	: boolean := true ;
	
	--testbench
	begin
		clk_ext <= not clk_ext after clk_period/2 when testing else '0';
		
		--component instantiation
		dut: counter
		generic map(
			NBit => NBit
		)
		port map(
			clk => clk_ext,
			en => en_ext,
			rst => rst_ext,
			overflow => overflow_ext,
			o => o_ext
		);
		
		stimulus: process
		begin
			rst_ext <= '1';
			wait for 30 ns;
			rst_ext <= '0';
			wait until rising_edge(clk_ext);
			rst_ext <= '0';
			wait for 100000 ns;
			testing <= false; 
		end process;
end beh;
	
	
	

