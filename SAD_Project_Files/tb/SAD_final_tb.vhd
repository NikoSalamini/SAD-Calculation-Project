library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity SAD_final_tb is
end SAD_final_tb;

architecture beh of SAD_final_tb is

	--const def
	constant clk_period	: time := 100 ns;
	constant NBit_input : positive := 8;
	constant NBit_output: positive := 16;
	constant N_pixels	: positive := 256; -- default: 16x16 = 256 pixels

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
	signal PA_ext	: std_logic_vector(NBit_input-1 downto 0) := b"00000000";
	signal PB_ext	: std_logic_vector(NBit_input-1 downto 0) := b"00000000";	
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
		file file_handler1     : text open read_mode is "../tb/test/default_list1.txt"; -- specify the relative directory
		file file_handler2     : text open read_mode is "../tb/test/default_list2.txt"; -- specify the relative directory
		variable row          : line;
		variable v_data_read  : integer;
		begin
			rst_ext <= '1';
			wait for 30 ns;
			rst_ext <= '0';
			
			-- reading the testing values from file
			for i in 0 to N_pixels-1 loop 
				if i > 0 then
					wait until rising_edge(clk_ext);
				end if;
				if (not endfile(file_handler1) and not endfile(file_handler2)) then
					readline(file_handler1, row);
					read(row, v_data_read);
					PA_ext <= std_logic_vector(to_unsigned(v_data_read, PA_ext'length));
					readline(file_handler2, row);
					read(row, v_data_read);
					PB_ext <= std_logic_vector(to_unsigned(v_data_read, PB_ext'length));
				end if;
			end loop;
			
			wait for 1000 ns;
			testing <= false; 
		end process;
end beh;
	
	
	
