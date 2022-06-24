library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity SAD_NXN_tb is
end SAD_NXN_tb;

architecture beh of SAD_NXN_tb is

	--const def
	constant clk_period	: time := 100 ns;

	--component dut
	component SAD
		generic (
			NBit_input: positive := 8;
			NBit_output: positive := 16;
			NBit_counter: positive := 8; 	 -- Default: The counter must have 8 bits to count the sum of the differences of 16x16 = 256 pixel couples.
			NBit_subtractor : positive := 8; -- Default: The subtractor works on 8 bits because the case is the subtraction of 2 unsigned integers on 8 bits.
			NBit_DFF_N: positive := 8;		 -- Default: Each input is a number between 0 and 255, so it's 8 bits. 
			NBit_accumulator: positive := 16 -- Default: The accumulator must have 16 bits because the maximum number of the total sum is 255*256.
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
	
	-- 64x64 template
	constant NBit_input_c: positive := 8;		 -- 0,255
	constant NBit_output_c: positive := 20;	     -- 255*64*64=2^8*2^12=1044480, needs 20 bits	
	constant NBit_counter_c: positive := 12; 	 -- 64*64=2^12, 12 bits
	constant NBit_subtractor_c: positive := 8;   -- 0, 255
	constant NBit_DFF_N_c: positive := 8;		 -- 0, 255
	constant NBit_accumulator_c: positive := 20; -- 255*64*64=2^8*2^12=1044480, needs 20 bits
	

	--signal of testbench
	signal clk_ext	: std_logic := '0' ;
	signal rst_ext 	: std_logic := '0' ;
	signal en_ext 	: std_logic := '1';
	signal PA_ext	: std_logic_vector(NBit_input_c-1 downto 0) := b"00000001";
	signal PB_ext	: std_logic_vector(NBit_input_c-1 downto 0) := b"00000010";	
	signal sad_ext	: std_logic_vector(NBit_output_c-1 downto 0) ;
	signal data_valid_ext : std_logic;
	signal testing	: boolean := true ;
	
	--testbench
	begin
		clk_ext <= not clk_ext after clk_period/2 when testing else '0';
		
		--component instantiation
		dut: SAD
		generic map(
			NBit_input => NBit_input_c,
			NBit_output => NBit_output_c,
			NBit_counter => NBit_counter_c,
			NBit_subtractor => NBit_subtractor_c,
			NBit_DFF_N => NBit_DFF_N_c,
			NBit_accumulator => NBit_accumulator_c
		)
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
			
			-- standard working experiment, the result must be the sum of clocks
			wait until rising_edge(clk_ext);
			PA_ext <= b"00000011";
			PB_ext <= b"00000100";
			wait until rising_edge(clk_ext);
			PA_ext <= b"00000101";
			PB_ext <= b"00000110";
			
			wait for 409700 ns;
			
			rst_ext <= '1';
			wait for 30 ns;
			rst_ext <= '0';
			wait until rising_edge(clk_ext);
			PA_ext <= b"00000011";
			PB_ext <= b"00000100";
			wait until rising_edge(clk_ext);
			PA_ext <= b"00000101";
			PB_ext <= b"00000110";
			
			wait for 409700 ns;
			
			testing <= false; 
		end process;
end beh;
