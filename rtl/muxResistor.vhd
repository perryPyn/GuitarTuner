library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity muxresistor is
  port (
    input : in    std_logic;
    sel   : in    std_logic;
    r_329 : out   std_logic;
    r_246 : out   std_logic;
    r_196 : out   std_logic;
    r_146 : out   std_logic;
    r_110 : out   std_logic;
    r_82  : out   std_logic
  );
end entity muxresistor;
