library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity SAD_tb is
end SAD_tb;

architecture beh of SAD_tb is

	--const def
	constant clk_period	: time := 100 ns;
	constant NBit_input : positive := 8;
	constant NBit_output: positive := 16;

	--component dut
	component SAD
		generic (
			counter_threshold: positive := 256; -- when counter reaches this value data_valid is set to 1.
			NBit_input: positive := 8;
			NBit_output: positive := 16
		);
		port (
			clk			: in std_logic;
			rst			: in std_logic;
			en			: in std_logic;
			PA			: in std_logic_vector(NBit_input-1 downto 0); -- value of pixel A
			PB			: in std_logic_vector(NBit_input-1 downto 0); -- value of pixel B 
			sad			: out std_logic_vector(NBit_output-1 downto 0 ); -- output of |A - B|
			data_valid	: out std_logic -- set to 1 when SAD calculation is over
		);
	end component;

	--signal of testbench
	signal clk_ext	: std_logic := '0' ;
	signal rst_ext 	: std_logic := '0' ;
	signal en_ext 	: std_logic := '1';
	signal PA_ext	: std_logic_vector(NBit_input-1 downto 0) := b"00000001";
	signal PB_ext	: std_logic_vector(NBit_input-1 downto 0) := b"00000010";	
	signal sad_ext	: std_logic_vector(NBit_output-1 downto 0) ;
	signal data_valid_ext : std_logic;
	signal testing	: boolean := true ;
	
	--testbench
	begin
		clk_ext <= not clk_ext after clk_period/2 when testing else '0';
		
		--component instantiation
		dut: SAD
		port map(
			clk => clk_ext,
			rst => rst_ext,
			en => en_ext,
			PA => PA_ext,
			PB => PB_ext,
			sad => sad_ext,
			data_valid => data_valid_ext
		);
		
		stimulus: process --no sensitivity list
		begin
			-- report "The value of 'testing' is " & boolean'image(testing);
			rst_ext <= '1';
			wait for 30 ns;
			rst_ext <= '0';
			
			-- standard working experiment, the result is the sum of clocks
			wait until rising_edge(clk_ext);
			PA_ext <= b"00000011";
			PB_ext <= b"00000100";
			wait until rising_edge(clk_ext);
			PA_ext <= b"00000101";
			PB_ext <= b"00000110";
			
			wait for 26000 ns;
			testing <= false; 
		end process;
end beh;
	
	
	

