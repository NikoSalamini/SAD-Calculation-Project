library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity accumulator_tb is
end accumulator_tb;

architecture beh of accumulator_tb is

	--const def
	constant clk_period	: time := 100 ns;
	constant NBit : positive := 16;
	constant NBit_counter: positive := 8;

	--component dut
	component accumulator
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
	end component;

	--signal of testbench
	signal i_ext : std_logic_vector(NBit-1 downto 0) := b"0000000000000001";
	signal clk_ext : std_logic := '0' ;
	signal rst_ext : std_logic := '0' ;
	signal en_ext : std_logic := '1';
	signal counter_ow_ext : std_logic := '0';
	signal o_ext : std_logic_vector(NBit-1 downto 0);
	signal data_valid_ext : std_logic;
	signal testing : boolean := true;
	
	--testbench
	begin
		clk_ext <= not clk_ext after clk_period/2 when testing else '0';
		
		--component instantiation
		dut: accumulator
		port map(
			i => i_ext,
			clk => clk_ext,
			rst => rst_ext,
			en => en_ext,
			counter_ow => counter_ow_ext,
			o => o_ext,
			data_valid => data_valid_ext
		);
		
		-- accumulator must stop summing at b"0000000010000000"=256
		stimulus: process 
		begin
			rst_ext <= '1';
			wait for 30 ns;
			rst_ext <= '0';
			wait for 25500 ns;
			counter_ow_ext <= '1';
			wait until rising_edge(clk_ext);
			wait until rising_edge(clk_ext);
			wait until rising_edge(clk_ext);
			testing <= false; 
			wait until rising_edge(clk_ext);
		end process;
end beh;
