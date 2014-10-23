library ieee;
use ieee.std_logic_1164.all;

entity ft_controller is
    generic (
        N : positive := 16;
        SIZE : positive := 64;
        DELAY : positive := 10000
    );
	port(
        CLK1: in std_logic;
        rst: in std_logic
    );
end ft_controller;

architecture Behavioral of ft_controller is

    COMPONENT bram
      PORT (
        clka : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
      );
    END COMPONENT;

    signal cc_start: std_logic := '1';
    signal cc_busy: std_logic;
    signal br_clka : STD_LOGIC;
    signal br_wea : STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal br_addra : STD_LOGIC_VECTOR(9 DOWNTO 0);
    signal br_dina : STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal br_douta : STD_LOGIC_VECTOR(15 DOWNTO 0);

begin

    cc1: entity work.cap_controller
        generic map (
            N => N,
            SIZE => SIZE
        )
        port map (
            CLK1 => CLK1,
            start => cc_start,
            busy => cc_busy,
            rst => rst
        );
        
    br1 : bram
        port map (
            clka => CLK1,
            wea => br_wea,
            addra => br_addra,
            dina => br_dina,
            douta => br_douta
        );
        
    process(CLK1)
        variable counter : natural range DELAY-1 downto 0 := 0;
    begin
    
        if rising_edge(CLK1) then
            
            if cc_busy = '1' then
                cc_start <= '0';
                counter := DELAY-1;
            elsif counter = 0 then
                cc_start <= '1';
            else
                counter := counter - 1;
            end if;
            
        end if;
    
    end process;


end Behavioral;

