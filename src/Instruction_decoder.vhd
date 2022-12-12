------------------------------------------------------------------------------------------------------------------------
--
-- Title   : Instruction decoder
-- Design  : Soutys8
-- Author  : J.Zimnol
-- Company : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     Instruction decoder for selected instructions from AVR instruction set.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;

use ieee.std_logic_unsigned.all;
--------------------------------------------------------------------------------
-- ENTITY INSTRUCTION_DECODER
--------------------------------------------------------------------------------
entity Instruction_decoder is
    port(
        in_instruction       : in  std_logic_vector(31 downto 0);
        out_instruction_type : out std_logic_vector(5 downto 0);

        out_reg1_addr        : out std_logic_vector(4 downto 0);
        out_reg2_addr        : out std_logic_vector(4 downto 0);
        out_reg3_addr        : out std_logic_vector(4 downto 0);

        out_immediate        : out std_logic_vector(7 downto 0);
        out_sram_address     : out std_logic_vector(15 downto 0);

        out_branch_address   : out std_logic_vector(15 downto 0)
    );
end Instruction_decoder;

--------------------------------------------------------------------------------
-- ARCHITECTURE OF INSTRUCTION_DECODER
--------------------------------------------------------------------------------
architecture Instruction_decoder of Instruction_decoder is
    signal s_main_instruction       : std_logic_vector(15 downto 0) := (others => '0');
    signal s_instruction_completion : std_logic_vector(15 downto 0) := (others => '0');
    signal s_instruction_type       : std_logic_vector(5 downto 0)  := (others => '0');
    signal s_reg1_addr              : std_logic_vector(4 downto 0)  := (others => '0');
    signal s_reg2_addr              : std_logic_vector(4 downto 0)  := (others => '0');
    signal s_reg3_addr              : std_logic_vector(4 downto 0)  := (others => '0');
    signal s_immediate              : std_logic_vector(7 downto 0)  := (others => '0');
    signal s_sram_address           : std_logic_vector(15 downto 0) := (others => '0');
    signal s_branch_address         : std_logic_vector(15 downto 0) := (others => '0');

    type lut_array_t is array(natural range 0 to 7) of std_logic_vector(7 downto 0);
    constant ONE_HOT_LUT : lut_array_t := ("00000001", "00000010", "00000100", "00001000",
                                           "00010000", "00100000", "01000000", "10000000");

begin

    ----------------------------------------
    -- DECODE CURRENT INSTRUCTION
    ----------------------------------------
    DECODE: process(s_main_instruction, s_instruction_completion) begin
        if    std_match(s_main_instruction, "000011----------") then
            -- ADD - Add without Carry
            --     Operation: Rd <-- Rd + Rr
            --     Opcode:    0000 11rd dddd rrrr
            s_instruction_type <= INSTR_TYPE_ADD;
            s_reg1_addr        <= s_main_instruction(8 downto 4);
            s_reg2_addr        <= s_main_instruction(9) & s_main_instruction(3 downto 0);
            s_reg3_addr        <= s_main_instruction(8 downto 4);
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "001000----------") then
            -- AND - Logical AND
            --     Operation: Rd <-- Rd * Rr
            --     Opcode:    0010 00rd dddd rrrr
            s_instruction_type <= INSTR_TYPE_AND;
            s_reg1_addr        <= s_main_instruction(8 downto 4);
            s_reg2_addr        <= s_main_instruction(9) & s_main_instruction(3 downto 0);
            s_reg3_addr        <= s_main_instruction(8 downto 4);
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "0111------------") then
            -- ANDI - Logical AND with Immediate
            --     Operation: Rd <-- Rd * K
            --     Opcode:    0111 KKKK dddd KKKK
            s_instruction_type <= INSTR_TYPE_ANDI;
            s_reg1_addr        <= '1' & s_main_instruction(7 downto 4);
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= '1' & s_main_instruction(7 downto 4);
            s_immediate        <= s_main_instruction(11 downto 8) & s_main_instruction(3 downto 0);
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "111101-------000") then
            -- BRCC - Branch if Carry Cleared
            --     Operation: If C = 0 then PC <-- PC + k + 1, else PC <-- PC + 1
            --     Opcode:    1111 01kk kkkk k000
            s_instruction_type <= INSTR_TYPE_BRCC;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            -- binary number in U2, convert 7-bit number to 16-bit number by adding MSBs
            s_branch_address   <= s_main_instruction(9) & s_main_instruction(9) & s_main_instruction(9)
                                  & s_main_instruction(9) & s_main_instruction(9) & s_main_instruction(9)
                                  & s_main_instruction(9) & s_main_instruction(9) & s_main_instruction(9)
                                  & s_main_instruction(9 downto 3);
        elsif std_match(s_main_instruction, "111100-------000") then
            -- BRCS - Branch if Carry Set
            --     Operation: If C = 1 then PC <-- PC + k + 1, else PC <-- PC + 1
            --     Opcode:    1111 00kk kkkk k000
            s_instruction_type <= INSTR_TYPE_BRCS;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            -- binary number in U2, convert 7-bit number to 16-bit number by adding MSBs
            s_branch_address   <= s_main_instruction(9) & s_main_instruction(9) & s_main_instruction(9)
                                  & s_main_instruction(9) & s_main_instruction(9) & s_main_instruction(9)
                                  & s_main_instruction(9) & s_main_instruction(9) & s_main_instruction(9)
                                  & s_main_instruction(9 downto 3);
        elsif std_match(s_main_instruction, "111100-------001") then
            -- BREQ - Branch if Equal
            --     Operation: If Rd = Rr (Z = 1) then PC <-- PC + k + 1, else PC <-- PC + 1
            --     Opcode:    1111 00kk kkkk k001
            s_instruction_type <= INSTR_TYPE_BREQ;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            -- binary number in U2, convert 7-bit number to 16-bit number by adding MSBs
            s_branch_address   <= s_main_instruction(9) & s_main_instruction(9) & s_main_instruction(9)
                                  & s_main_instruction(9) & s_main_instruction(9) & s_main_instruction(9)
                                  & s_main_instruction(9) & s_main_instruction(9) & s_main_instruction(9)
                                  & s_main_instruction(9 downto 3);
        elsif std_match(s_main_instruction, "111101-------001") then
            -- BRNE - Branch if Not Equal
            --     Operation: If Rd != Rr (Z = 0) then PC <-- PC + k + 1, else PC <-- PC + 1
            --     Opcode:    1111 01kk kkkk k001
            s_instruction_type <= INSTR_TYPE_BRNE;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            -- binary number in U2, convert 7-bit number to 16-bit number by adding MSBs
            s_branch_address   <= s_main_instruction(9) & s_main_instruction(9) & s_main_instruction(9)
                                  & s_main_instruction(9) & s_main_instruction(9) & s_main_instruction(9)
                                  & s_main_instruction(9) & s_main_instruction(9) & s_main_instruction(9)
                                  & s_main_instruction(9 downto 3);
        elsif std_match(s_main_instruction, "10011000--------") then
            -- CBI - Clear Bit in I/O Register
            --     Operation: I/O(A,b) <-- 0, This instruction operates on the lower 32 I/O registers - addresses 0-31.
            --     Opcode:    1001 1000 AAAA Abbb
            s_instruction_type <= INSTR_TYPE_CBI;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= ONE_HOT_LUT(to_integer(unsigned(s_main_instruction(2 downto 0))));
            s_sram_address     <= "00000000000" & s_main_instruction(7 downto 3) + GPIO_LOWEST_ADDRESS;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010010001000") then
            -- CLC - Clear Carry Flag
            --     Operation: C <-- 0
            --     Opcode:    1001 0100 1000 1000
            s_instruction_type <= INSTR_TYPE_CLC;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010011011000") then
            -- CLH - Clear Half Carry Flag
            --     Operation: H <-- 0
            --     Opcode:    1001 0100 1101 1000
            s_instruction_type <= INSTR_TYPE_CLH;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010011111000") then
            -- CLI - Clear Global Interrupt Flag
            --     Operation: I <-- 0
            --     Opcode:    1001 0100 1111 1000
            s_instruction_type <= INSTR_TYPE_CLI;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010010101000") then
            -- CLN - Clear Negative Flag
            --     Operation: N <-- 0
            --     Opcode:    1001 0100 1010 1000
            s_instruction_type <= INSTR_TYPE_CLN;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010011001000") then
            -- CLS - Clear Signed Flag
            --     Operation: S <-- 0
            --     Opcode:    1001 0100 1100 1000
            s_instruction_type <= INSTR_TYPE_CLS;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010011101000") then
            -- CLT - Clear T Flag
            --     Operation: T <-- 0
            --     Opcode:    1001 0100 1110 1000
            s_instruction_type <= INSTR_TYPE_CLT;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010010111000") then
            -- CLV - Clear Overflow Flag
            --     Operation: V <-- 0
            --     Opcode:    1001 0100 1011 1000
            s_instruction_type <= INSTR_TYPE_CLV;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010010011000") then
            -- CLZ - Clear Zero Flag
            --     Operation: Z <-- 0
            --     Opcode:    1001 0100 1001 1000
            s_instruction_type <= INSTR_TYPE_CLZ;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010-----0000") then
            -- COM - One's Complement
            --     Operation: Rd <-- $FF - Rd (here: $FF xor Rd)
            --     Opcode:    1001 010d dddd 0000
            s_instruction_type <= INSTR_TYPE_COM; -- MAKE IT $FF xor RD
            s_reg1_addr        <= s_main_instruction(8 downto 4);
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_main_instruction(8 downto 4);
            s_immediate        <= x"ff";
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "000101----------") then
            -- CP - Compare
            --     Operation: Rd - Rr
            --     Opcode:    0001 01rd dddd rrrr
            s_instruction_type <= INSTR_TYPE_CP;
            s_reg1_addr        <= s_main_instruction(8 downto 4);
            s_reg2_addr        <= s_main_instruction(9) & s_main_instruction(3 downto 0);
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "0011------------") then
            -- CPI - Compare with Immediate
            --     Operation: Rd - K
            --     Opcode:    0011 KKKK dddd KKKK
            s_instruction_type <= INSTR_TYPE_CPI;
            s_reg1_addr        <= '1' & s_main_instruction(7 downto 4);
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_main_instruction(11 downto 8) & s_main_instruction(3 downto 0);
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010-----1010") then
            -- DEC - Decrement
            --     Operation: Rd <-- Rd - 1
            --     Opcode:    1001 010d dddd 1010
            s_instruction_type <= INSTR_TYPE_DEC;
            s_reg1_addr        <= s_main_instruction(8 downto 4);
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_main_instruction(8 downto 4);
            s_immediate        <= "00000001";
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "001001----------") then
            -- EOR - Exclusive OR
            --     Operation: Rd <-- Rd exor Rr
            --     Opcode:    0010 01rd dddd rrrr
            s_instruction_type <= INSTR_TYPE_EOR;
            s_reg1_addr        <= s_main_instruction(8 downto 4);
            s_reg2_addr        <= s_main_instruction(9) & s_main_instruction(3 downto 0);
            s_reg3_addr        <= s_main_instruction(8 downto 4);
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "10110-----------") then
            -- IN - Load an I/O Location to Register
            --     Operation: Rd <-- I/O(A)
            --     Opcode:    1011 0AAd dddd AAAA
            s_instruction_type <= INSTR_TYPE_IN;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_main_instruction(8 downto 4);
            s_immediate        <= s_immediate;
            s_sram_address     <= ("0000000000" & s_main_instruction(10 downto 9) & s_main_instruction(3 downto 0))
                                  + GPIO_LOWEST_ADDRESS;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010-----0011") then
            -- INC - Increment
            --     Operation: Rd <-- Rd + 1
            --     Opcode:    1001 010d dddd 0011
            s_instruction_type <= INSTR_TYPE_INC;
            s_reg1_addr        <= s_main_instruction(8 downto 4);
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_main_instruction(8 downto 4);
            s_immediate        <= "00000001";
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010-----110-") then
            -- JMP - Jump
            --     Operation: PC <-- k
            --     Opcode:    1001 010k kkkk 110k kkkk kkkk kkkk kkkk
            s_instruction_type <= INSTR_TYPE_JMP;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= s_instruction_completion(15 downto 0);
        elsif std_match(s_main_instruction, "1110------------") then
            -- LDI - Load Immediate
            --     Operation: Rd <-- K
            --     Opcode:    1110 KKKK dddd KKKK
            s_instruction_type <= INSTR_TYPE_LDI;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= '1' & s_main_instruction(7 downto 4);
            s_immediate        <= s_main_instruction(11 downto 8) & s_main_instruction(3 downto 0);
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001000-----0000") then
            -- LDS - Load Direct from Data Space
            --     Operation: Rd <-- (k)
            --     Opcode:    1001 000d dddd 0000 kkkk kkkk kkkk kkkk
            if to_integer(unsigned(s_instruction_completion)) < GPIO_LOWEST_ADDRESS  then
                -- range 0x00 - 0x1f
                -- simply copy one register to another
                s_instruction_type <= INSTR_TYPE_MOV;
                s_reg1_addr        <= s_reg1_addr;
                s_reg2_addr        <= s_instruction_completion(4 downto 0);
                s_reg3_addr        <= s_main_instruction(8 downto 4);
                s_immediate        <= s_immediate;
                s_sram_address     <= s_sram_address;
                s_branch_address   <= "0000000000000001";
            elsif to_integer(unsigned(s_instruction_completion)) <= GPIO_HIGHEST_ADDRESS then
                -- range 0x20 - 0x5f
                -- load value from GPIO to register
                s_instruction_type <= INSTR_TYPE_IN;
                s_reg1_addr        <= s_reg1_addr;
                s_reg2_addr        <= s_reg2_addr;
                s_reg3_addr        <= s_main_instruction(8 downto 4);
                s_immediate        <= s_immediate;
                s_sram_address     <= s_instruction_completion(15 downto 0);
                s_branch_address   <= "0000000000000001";
            elsif to_integer(unsigned(s_instruction_completion)) <= MMIO_HIGHEST_ADDRESS then
                -- range 0x60 - 0xff
                -- load value from external I/O registers (e.g. I2C, UART) (to be implemented)
                s_instruction_type <= INSTR_TYPE_LDS_MMIO;
                s_reg1_addr        <= s_reg1_addr;
                s_reg2_addr        <= s_reg2_addr;
                s_reg3_addr        <= s_reg3_addr;
                s_immediate        <= s_immediate;
                s_sram_address     <= s_sram_address;
                s_branch_address   <= "0000000000000001";
            else
                -- range 0x100 - 0x8ff
                -- load value from the main SRAM
                s_instruction_type <= INSTR_TYPE_LDS_SRAM;
                s_reg1_addr        <= s_reg1_addr;
                s_reg2_addr        <= s_reg2_addr;
                s_reg3_addr        <= s_main_instruction(8 downto 4);
                s_immediate        <= s_immediate;
                s_sram_address     <= s_instruction_completion(15 downto 0);
                s_branch_address   <= "0000000000000001";
            end if;
        elsif std_match(s_main_instruction, "000011----------") then
            -- LSL - Logical Shift Left
            --     Operation: C <-- b7 ...  b0 <-- 0
            --     Opcode:    0000 11dd dddd dddd
            s_instruction_type <= INSTR_TYPE_LSL;
            s_reg1_addr        <= s_main_instruction(4 downto 0);
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_main_instruction(4 downto 0);
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010-----0110") then
            -- LSR - Logical Shift Right
            --     Operation: 0 --> b7 ...  b0 --> C
            --     Opcode:    1001 010d dddd 0110
            s_instruction_type <= INSTR_TYPE_LSR;
            s_reg1_addr        <= s_main_instruction(8 downto 4);
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_main_instruction(8 downto 4);
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "001011----------") then
            -- MOV - Copy Register
            --     Operation: Rd <-- Rr
            --     Opcode:    0010 11rd dddd rrrr
            s_instruction_type <= INSTR_TYPE_MOV;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_main_instruction(9) & s_main_instruction(3 downto 0);
            s_reg3_addr        <= s_main_instruction(8 downto 4);
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "0000000000000000") then
            -- NOP - No Operation
            --     Operation: No
            --     Opcode:    0000 0000 0000 0000
            s_instruction_type <= INSTR_TYPE_NOP;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "001010----------") then
            -- OR - Logical OR
            --     Operation: Rd <-- Rd v Rr
            --     Opcode:    0010 10rd dddd rrrr
            s_instruction_type <= INSTR_TYPE_OR;
            s_reg1_addr        <= s_main_instruction(8 downto 4);
            s_reg2_addr        <= s_main_instruction(9) & s_main_instruction(3 downto 0);
            s_reg3_addr        <= s_main_instruction(8 downto 4);
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "0110------------") then
            -- ORI - Logical OR with Immediate
            --     Operation: Rd <-- Rd v K
            --     Opcode:    0110 KKKK dddd KKKK
            s_instruction_type <= INSTR_TYPE_ORI;
            s_reg1_addr        <= '1' & s_main_instruction(7 downto 4);
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= '1' & s_main_instruction(7 downto 4);
            s_immediate        <= s_main_instruction(11 downto 8) & s_main_instruction(3 downto 0);
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "10111-----------") then
            -- OUT - Store Register to I/O Location
            --     Operation: I/O(A) <-- Rr
            --     Opcode:    1011 1AAr rrrr AAAA
            s_instruction_type <= INSTR_TYPE_OUT;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_main_instruction(8 downto 4);
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= ("0000000000" & s_main_instruction(10 downto 9) & s_main_instruction(3 downto 0))
                                  + GPIO_LOWEST_ADDRESS;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001000---------") then
            -- POP - Pop Register from Stack
            --     Operation: Rd <-- STACK
            --     Opcode:    1001 000d dddd 1111
            s_instruction_type <= INSTR_TYPE_POP;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_main_instruction(8 downto 4);
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001001-----1111") then
            -- PUSH - Push Register on Stack
            --     Operation: STACK <-- Rr
            --     Opcode:    1001 001d dddd 1111
            s_instruction_type <= INSTR_TYPE_PUSH;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_main_instruction(8 downto 4);
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1100------------") then
            -- RJMP - Relative Jump
            --     Operation: PC <-- PC + k + 1
            --     Opcode:    1100 kkkk kkkk kkkk
            s_instruction_type <= INSTR_TYPE_RJMP;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= s_main_instruction(11) & s_main_instruction(11) & s_main_instruction(11)
                                  & s_main_instruction(11) & s_main_instruction(11 downto 0);
        elsif std_match(s_main_instruction, "10011010--------") then
            -- SBI - Set Bit in I/O Register
            --     Operation: I/O(A,b) <-- 1
            --     Opcode:    1001 1010 AAAA Abbb
            s_instruction_type <= INSTR_TYPE_SBI;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= ONE_HOT_LUT(to_integer(unsigned(s_main_instruction(2 downto 0))));
            s_sram_address     <= "00000000000" & s_main_instruction(7 downto 3);
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "0110------------") then
            -- SBR - Set Bits in Register
            --     Operation: Rd <-- Rd v K
            --     Opcode:    0110 KKKK dddd KKKK
            s_instruction_type <= INSTR_TYPE_SBR;
            s_reg1_addr        <= '1' & s_main_instruction(7 downto 4);
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= '1' & s_main_instruction(7 downto 4);
            s_immediate        <= s_main_instruction(11 downto 8) & s_main_instruction(3 downto 0);
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010000001000") then
            -- SEC - Set Carry Flag
            --     Operation: C <-- 1
            --     Opcode:    1001 0100 0000 1000
            s_instruction_type <= INSTR_TYPE_SEC;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010001011000") then
            -- SEH - Set Half Carry Flag
            --     Operation: H <-- 1
            --     Opcode:    1001 0100 0101 1000
            s_instruction_type <= INSTR_TYPE_SEH;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010001111000") then
            -- SEI - Set Global Interrupt Flag
            --     Operation: I <-- 1
            --     Opcode:    1001 0100 0111 1000
            s_instruction_type <= INSTR_TYPE_SEI;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010000101000") then
            -- SEN - Set Negative Flag
            --     Operation: N <-- 1
            --     Opcode:    1001 0100 0010 1000
            s_instruction_type <= INSTR_TYPE_SEN;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010001001000") then
            -- SES - Set Signed Flag
            --     Operation: S <-- 1
            --     Opcode:    1001 0100 0100 1000
            s_instruction_type <= INSTR_TYPE_SES;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010001101000") then
            -- SET - Set T Flag
            --     Operation: T <-- 1
            --     Opcode:    1001 0100 0110 1000
            s_instruction_type <= INSTR_TYPE_SET;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010000111000") then
            -- SEV - Set Overflow Flag
            --     Operation: V <-- 1
            --     Opcode:    1001 0100 0011 1000
            s_instruction_type <= INSTR_TYPE_SEV;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001010000011000") then
            -- SEZ - Set Zero Flag
            --     Operation: Z <-- 1
            --     Opcode:    1001 0100 0001 1000
            s_instruction_type <= INSTR_TYPE_SEZ;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "1001001-----0000") then
            -- STS - Store Direct to Data Space
            --     Operation: (k) <-- Rd (Stores one byte from a Register to the data space)
            --     Opcode:    1001 001d dddd 0000 kkkk kkkk kkkk kkkk
            if to_integer(unsigned(s_instruction_completion)) < GPIO_LOWEST_ADDRESS then
                -- range 0x00 - 0x1f
                -- simply copying one register to another
                s_instruction_type <= INSTR_TYPE_MOV;
                s_reg1_addr        <= s_reg1_addr;
                s_reg2_addr        <= s_main_instruction(8 downto 4);
                s_reg3_addr        <= s_instruction_completion(4 downto 0);
                s_immediate        <= s_immediate;
                s_sram_address     <= s_sram_address;
                s_branch_address   <= "0000000000000001";
            elsif to_integer(unsigned(s_instruction_completion)) <= GPIO_HIGHEST_ADDRESS then
                -- range 0x20 - 0x5f
                -- write value to GPIO
                s_instruction_type <= INSTR_TYPE_OUT;
                s_reg1_addr        <= s_reg1_addr;
                s_reg2_addr        <= s_main_instruction(8 downto 4);
                s_reg3_addr        <= s_reg3_addr;
                s_immediate        <= s_immediate;
                s_sram_address     <= s_instruction_completion(15 downto 0);
                s_branch_address   <= "0000000000000001";
            elsif to_integer(unsigned(s_instruction_completion)) <= MMIO_HIGHEST_ADDRESS then
                -- range 0x60 - 0xff
                -- write value to the external I/O registers (e.g. I2C, UART) (to be implemented)
                s_instruction_type <= INSTR_TYPE_STS_MMIO;
                s_reg1_addr        <= s_reg1_addr;
                s_reg2_addr        <= s_reg2_addr;
                s_reg3_addr        <= s_reg3_addr;
                s_immediate        <= s_immediate;
                s_sram_address     <= s_sram_address;
                s_branch_address   <= "0000000000000001";
            else
                -- range 0x100 - 0x8ff
                -- write value to the main SRAM
                s_instruction_type <= INSTR_TYPE_STS_SRAM;
                s_reg1_addr        <= s_reg1_addr;
                s_reg2_addr        <= s_main_instruction(8 downto 4);
                s_reg3_addr        <= s_reg3_addr;
                s_immediate        <= s_immediate;
                s_sram_address     <= s_instruction_completion(15 downto 0);
                s_branch_address   <= "0000000000000001";
            end if;
        elsif std_match(s_main_instruction, "000110----------") then
            -- SUB - Subtract Without Carry
            --     Operation: Rd <-- Rd - Rr
            --     Opcode:    0001 10rd dddd rrrr
            s_instruction_type <= INSTR_TYPE_SUB;
            s_reg1_addr        <= s_main_instruction(8 downto 4);
            s_reg2_addr        <= s_main_instruction(9) & s_main_instruction(3 downto 0);
            s_reg3_addr        <= s_main_instruction(8 downto 4);
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        elsif std_match(s_main_instruction, "0101------------") then
            -- SUBI - Subtract Immediate
            --     Operation: Rd <-- Rd - K
            --     Opcode:    0101 KKKK dddd KKKK
            s_instruction_type <= INSTR_TYPE_SUBI;
            s_reg1_addr        <= '1' & s_main_instruction(7 downto 4);
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= '1' & s_main_instruction(7 downto 4);
            s_immediate        <= s_main_instruction(11 downto 8) & s_main_instruction(3 downto 0);
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        else
            -- NOP - No Operation (here: unknown instruction)
            s_instruction_type <= INSTR_TYPE_NOP;
            s_reg1_addr        <= s_reg1_addr;
            s_reg2_addr        <= s_reg2_addr;
            s_reg3_addr        <= s_reg3_addr;
            s_immediate        <= s_immediate;
            s_sram_address     <= s_sram_address;
            s_branch_address   <= "0000000000000000";
        end if;
    end process;

    s_main_instruction       <= in_instruction(31 downto 16);
    s_instruction_completion <= in_instruction(15 downto 0);

    out_instruction_type <= s_instruction_type;
    out_reg1_addr        <= s_reg1_addr;
    out_reg2_addr        <= s_reg2_addr;
    out_reg3_addr        <= s_reg3_addr;
    out_immediate        <= s_immediate;
    out_sram_address     <= s_sram_address;
    out_branch_address   <= s_branch_address;

end Instruction_decoder;


-- Instructions implemented:

-- ADD - Add without Carry
--     Operation: Rd <-- Rd + Rr
--     Opcode:    0000 11rd dddd rrrr
-- AND - Logical AND
--     Operation: Rd <-- Rd * Rr
--     Opcode:    0010 00rd dddd rrrr
-- ANDI - Logical AND with Immediate
--     Operation: Rd <-- Rd * K
--     Opcode:    0111 KKKK dddd KKKK
-- BRCC - Branch if Carry Cleared
--     Operation: If C = 0 then PC <-- PC + k + 1, else PC <-- PC + 1
--     Opcode:    1111 01kk kkkk k000
-- BRCS - Branch if Carry Set
--     Operation: If C = 1 then PC <-- PC + k + 1, else PC <-- PC + 1
--     Opcode:    1111 00kk kkkk k000
-- BREQ - Branch if Equal
--     Operation: If Rd = Rr (Z = 1) then PC <-- PC + k + 1, else PC <-- PC + 1
--     Opcode:    1111 00kk kkkk k001
-- BRNE - Branch if Not Equal
--     Operation: If Rd != Rr (Z = 0) then PC <-- PC + k + 1, else PC <-- PC + 1
--     Opcode:    1111 01kk kkkk k001
-- CBI - Clear Bit in I/O Register
--     Operation: I/O(A,b) <-- 0, This instruction operates on the lower 32 I/O registers - addresses 0-31.
--     Opcode:    1001 1000 AAAA Abbb
-- CLC - Clear Carry Flag
--     Operation: C <-- 0
--     Opcode:    1001 0100 1000 1000
-- CLH - Clear Half Carry Flag
--     Operation: H <-- 0
--     Opcode:    1001 0100 1101 1000
-- CLI - Clear Global Interrupt Flag
--     Operation: I <-- 0
--     Opcode:    1001 0100 1111 1000
-- CLN - Clear Negative Flag
--     Operation: N <-- 0
--     Opcode:    1001 0100 1010 1000
-- CLS - Clear Signed Flag
--     Operation: S <-- 0
--     Opcode:    1001 0100 1100 1000
-- CLT - Clear T Flag
--     Operation: T <-- 0
--     Opcode:    1001 0100 1110 1000
-- CLV - Clear Overflow Flag
--     Operation: V <-- 0
--     Opcode:    1001 0100 1011 1000
-- CLZ - Clear Zero Flag
--     Operation: Z <-- 0
--     Opcode:    1001 0100 1001 1000
-- COM - One's Complement
--     Operation: Rd <-- $FF - Rd
--     Opcode:    1001 010d dddd 0000
-- CP - Compare
--     Operation: Rd - Rr
--     Opcode:    0001 01rd dddd rrrr
-- CPI - Compare with Immediate
--     Operation: Rd - K
--     Opcode:    0011 KKKK dddd KKKK
-- DEC - Decrement
--     Operation: Rd <-- Rd - 1
--     Opcode:    1001 010d dddd 1010
-- EOR - Exclusive OR
--     Operation: Rd <-- Rd exor Rr
--     Opcode:    0010 01rd dddd rrrr
-- IN - Load an I/O Location to Register
--     Operation: Rd <-- I/O(A)
--     Opcode:    1011 0AAd dddd AAAA
-- INC - Increment
--     Operation: Rd <-- Rd + 1
--     Opcode:    1001 010d dddd 0011
-- JMP - Jump
--     Operation: PC <-- k
--     Opcode:    1001 010k kkkk 110k kkkk kkkk kkkk kkkk
-- LDI - Load Immediate
--     Operation: Rd <-- K
--     Opcode:    1110 KKKK dddd KKKK
-- LDS - Load Direct from Data Space
--     Operation: Rd <-- (k)
--     Opcode:    1001 000d dddd 0000 kkkk kkkk kkkk kkkk
-- LSL - Logical Shift Left
--     Operation: C <-- b7 ...  b0 <-- 0
--     Opcode:    0000 11dd dddd dddd
-- LSR - Logical Shift Right
--     Operation: 0 --> b7 ...  b0 --> C
--     Opcode:    1001 010d dddd 0110
-- MOV - Copy Register
--     Operation: Rd <-- Rr
--     Opcode:    0010 11rd dddd rrrr
-- NOP - No Operation
--     Operation: No
--     Opcode:    0000 0000 0000 0000
-- OR - Logical OR
--     Operation: Rd <-- Rd v Rr
--     Opcode:    0010 10rd dddd rrrr
-- ORI - Logical OR with Immediate
--     Operation: Rd <-- Rd v K
--     Opcode:    0110 KKKK dddd KKKK
-- OUT - Store Register to I/O Location
--     Operation: I/O(A) <-- Rr
--     Opcode:    1011 1AAr rrrr AAAA
-- POP - Pop Register from Stack
--     Operation: Rd <-- STACK
--     Opcode:    1001 000d dddd 1111
-- PUSH - Push Register on Stack
--     Operation: STACK <-- Rr
--     Opcode:    1001 001d dddd 1111
-- RJMP - Relative Jump
--     Operation: PC <-- PC + k + 1
--     Opcode:    1100 kkkk kkkk kkkk
-- SBI - Set Bit in I/O Register
--     Operation: I/O(A,b) <-- 1
--     Opcode:    1001 1010 AAAA Abbb
-- SBR - Set Bits in Register
--     Operation: Rd <-- Rd v K
--     Opcode:    0110 KKKK dddd KKKK
-- SEC - Set Carry Flag
--     Operation: C <-- 1
--     Opcode:    1001 0100 0000 1000
-- SEH - Set Half Carry Flag
--     Operation: H <-- 1
--     Opcode:    1001 0100 0101 1000
-- SEI - Set Global Interrupt Flag
--     Operation: I <-- 1
--     Opcode:    1001 0100 0111 1000
-- SEN - Set Negative Flag
--     Operation: N <-- 1
--     Opcode:    1001 0100 0010 1000
-- SES - Set Signed Flag
--     Operation: S <-- 1
--     Opcode:    1001 0100 0100 1000
-- SET - Set T Flag
--     Operation: T <-- 1
--     Opcode:    1001 0100 0110 1000
-- SEV - Set Overflow Flag
--     Operation: V <-- 1
--     Opcode:    1001 0100 0011 1000
-- SEZ - Set Zero Flag
--     Operation: Z <-- 1
--     Opcode:    1001 0100 0001 1000
-- STS - Store Direct to Data Space
--     Operation: (k) <-- Rr (Stores one byte from a Register to the data space)
--     Opcode:    1001 001d dddd 0000 kkkk kkkk kkkk kkkk
-- SUB - Subtract Without Carry
--     Operation: Rd <-- Rd - Rr
--     Opcode:    0001 10rd dddd rrrr
-- SUBI - Subtract Immediate
--     Operation: Rd <-- Rd - K
--     Opcode:    0101 KKKK dddd KKKK
