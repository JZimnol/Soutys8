------------------------------------------------------------------------------------------------------------------------
--
-- Title   : ALU
-- Design  : Soutys8
-- Author  : J.Zimnol
-- Company : AGH Krakow
--
------------------------------------------------------------------------------------------------------------------------
--
-- Description:
--     8bit ALU with SREG register.
--
------------------------------------------------------------------------------------------------------------------------

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.softprocessor_constants.all;

--------------------------------------------------------------------------------
-- ENTITY ALU
--------------------------------------------------------------------------------
entity ALU is
    port(
        in_src1        : in  std_logic_vector(7 downto 0);
        in_src2        : in  std_logic_vector(7 downto 0);
        out_result     : out std_logic_vector(7 downto 0);

        in_SREG_clk    : in  std_logic;
        in_reset       : in  std_logic;

        in_control     : in  std_logic_vector(CONTROL_BUS_WIDTH-1 downto 0);
        out_SREG_flags : out std_logic_vector(7 downto 0)
    );
end ALU;

--------------------------------------------------------------------------------
-- ARCHITECTURE OF ALU
--------------------------------------------------------------------------------
architecture ALU of ALU is
    signal s_operation_type : std_logic_vector(4 downto 0) := (others => '0');
    signal s_result         : std_logic_vector(7 downto 0) := (others => '0');
    signal s_SREG_flags     : std_logic_vector(7 downto 0) := (others => '0');
    signal s_write_enable   : std_logic := '0';

    signal s_flag_c_add     : std_logic := '0';
    signal s_flag_z_add     : std_logic := '0';
    signal s_flag_n_add     : std_logic := '0';
    signal s_flag_v_add     : std_logic := '0';
    signal s_flag_s_add     : std_logic := '0';
    signal s_flag_h_add     : std_logic := '0';

    signal s_flag_z_and     : std_logic := '0';
    signal s_flag_n_and     : std_logic := '0';
    signal s_flag_v_and     : std_logic := '0';
    signal s_flag_s_and     : std_logic := '0';

    signal s_flag_c_neg     : std_logic := '0';
    signal s_flag_z_neg     : std_logic := '0';
    signal s_flag_n_neg     : std_logic := '0';
    signal s_flag_v_neg     : std_logic := '0';
    signal s_flag_s_neg     : std_logic := '0';

    signal s_flag_c_sub     : std_logic := '0';
    signal s_flag_z_sub     : std_logic := '0';
    signal s_flag_n_sub     : std_logic := '0';
    signal s_flag_v_sub     : std_logic := '0';
    signal s_flag_s_sub     : std_logic := '0';
    signal s_flag_h_sub     : std_logic := '0';

    signal s_flag_z_xor     : std_logic := '0';
    signal s_flag_n_xor     : std_logic := '0';
    signal s_flag_v_xor     : std_logic := '0';
    signal s_flag_s_xor     : std_logic := '0';

    signal s_flag_z_or      : std_logic := '0';
    signal s_flag_n_or      : std_logic := '0';
    signal s_flag_v_or      : std_logic := '0';
    signal s_flag_s_or      : std_logic := '0';

    signal s_flag_z_dec     : std_logic := '0';
    signal s_flag_n_dec     : std_logic := '0';
    signal s_flag_v_dec     : std_logic := '0';
    signal s_flag_s_dec     : std_logic := '0';

    signal s_flag_z_inc     : std_logic := '0';
    signal s_flag_n_inc     : std_logic := '0';
    signal s_flag_v_inc     : std_logic := '0';
    signal s_flag_s_inc     : std_logic := '0';

    signal s_flag_c_lsl     : std_logic := '0';
    signal s_flag_z_lsl     : std_logic := '0';
    signal s_flag_n_lsl     : std_logic := '0';
    signal s_flag_v_lsl     : std_logic := '0';
    signal s_flag_s_lsl     : std_logic := '0';
    signal s_flag_h_lsl     : std_logic := '0';

    signal s_flag_c_lsr     : std_logic := '0';
    signal s_flag_z_lsr     : std_logic := '0';
    signal s_flag_n_lsr     : std_logic := '0';
    signal s_flag_v_lsr     : std_logic := '0';
    signal s_flag_s_lsr     : std_logic := '0';

begin

    ----------------------------------------
    -- UPDATE SREG FLAGS
    ----------------------------------------
    UPDATE_SREG_FLAGS: process(in_SREG_clk) begin
        if in_SREG_clk'event and in_SREG_clk = '1' then
            if in_reset = '1' then
                s_SREG_flags <= (others => '0');
            elsif s_write_enable = '1' then
                case s_operation_type is
                    when ALU_OP_ADD =>
                        s_SREG_flags(ALU_FLAG_C) <= s_flag_c_add;
                        s_SREG_flags(ALU_FLAG_Z) <= s_flag_z_add;
                        s_SREG_flags(ALU_FLAG_N) <= s_flag_n_add;
                        s_SREG_flags(ALU_FLAG_V) <= s_flag_v_add;
                        s_SREG_flags(ALU_FLAG_S) <= s_flag_s_add;
                        s_SREG_flags(ALU_FLAG_H) <= s_flag_h_add;
                    when ALU_OP_AND =>
                        s_SREG_flags(ALU_FLAG_Z) <= s_flag_z_and;
                        s_SREG_flags(ALU_FLAG_N) <= s_flag_n_and;
                        s_SREG_flags(ALU_FLAG_V) <= s_flag_v_and;
                        s_SREG_flags(ALU_FLAG_S) <= s_flag_s_and;
                    when ALU_OP_NEG =>
                        s_SREG_flags(ALU_FLAG_C) <= s_flag_c_neg;
                        s_SREG_flags(ALU_FLAG_Z) <= s_flag_z_neg;
                        s_SREG_flags(ALU_FLAG_N) <= s_flag_n_neg;
                        s_SREG_flags(ALU_FLAG_V) <= s_flag_v_neg;
                        s_SREG_flags(ALU_FLAG_S) <= s_flag_s_neg;
                    when ALU_OP_SUB =>
                        s_SREG_flags(ALU_FLAG_C) <= s_flag_c_sub;
                        s_SREG_flags(ALU_FLAG_Z) <= s_flag_z_sub;
                        s_SREG_flags(ALU_FLAG_N) <= s_flag_n_sub;
                        s_SREG_flags(ALU_FLAG_V) <= s_flag_v_sub;
                        s_SREG_flags(ALU_FLAG_S) <= s_flag_s_sub;
                        s_SREG_flags(ALU_FLAG_H) <= s_flag_h_sub;
                    when ALU_OP_XOR =>
                        s_SREG_flags(ALU_FLAG_Z) <= s_flag_z_xor;
                        s_SREG_flags(ALU_FLAG_N) <= s_flag_n_xor;
                        s_SREG_flags(ALU_FLAG_V) <= s_flag_v_xor;
                        s_SREG_flags(ALU_FLAG_S) <= s_flag_s_xor;
                    when ALU_OP_OR =>
                        s_SREG_flags(ALU_FLAG_Z) <= s_flag_z_or;
                        s_SREG_flags(ALU_FLAG_N) <= s_flag_n_or;
                        s_SREG_flags(ALU_FLAG_V) <= s_flag_v_or;
                        s_SREG_flags(ALU_FLAG_S) <= s_flag_s_or;
                    when ALU_OP_DEC =>
                        s_SREG_flags(ALU_FLAG_Z) <= s_flag_z_dec;
                        s_SREG_flags(ALU_FLAG_N) <= s_flag_n_dec;
                        s_SREG_flags(ALU_FLAG_V) <= s_flag_v_dec;
                        s_SREG_flags(ALU_FLAG_S) <= s_flag_s_dec;
                    when ALU_OP_INC =>
                        s_SREG_flags(ALU_FLAG_Z) <= s_flag_z_inc;
                        s_SREG_flags(ALU_FLAG_N) <= s_flag_n_inc;
                        s_SREG_flags(ALU_FLAG_V) <= s_flag_v_inc;
                        s_SREG_flags(ALU_FLAG_S) <= s_flag_s_inc;
                    when ALU_OP_LSL =>
                        s_SREG_flags(ALU_FLAG_C) <= s_flag_c_lsl;
                        s_SREG_flags(ALU_FLAG_Z) <= s_flag_z_lsl;
                        s_SREG_flags(ALU_FLAG_N) <= s_flag_n_lsl;
                        s_SREG_flags(ALU_FLAG_H) <= s_flag_h_lsl;
                        s_SREG_flags(ALU_FLAG_V) <= s_flag_v_lsl;
                        s_SREG_flags(ALU_FLAG_S) <= s_flag_s_lsl;
                    when ALU_OP_LSR =>
                        s_SREG_flags(ALU_FLAG_C) <= s_flag_c_lsr;
                        s_SREG_flags(ALU_FLAG_Z) <= s_flag_z_lsr;
                        s_SREG_flags(ALU_FLAG_N) <= s_flag_n_lsr;
                        s_SREG_flags(ALU_FLAG_V) <= s_flag_v_lsr;
                        s_SREG_flags(ALU_FLAG_S) <= s_flag_s_lsr;
                    when ALU_OP_SET_C   => s_SREG_flags(ALU_FLAG_C) <= '1';
                    when ALU_OP_SET_Z   => s_SREG_flags(ALU_FLAG_Z) <= '1';
                    when ALU_OP_SET_N   => s_SREG_flags(ALU_FLAG_N) <= '1';
                    when ALU_OP_SET_V   => s_SREG_flags(ALU_FLAG_V) <= '1';
                    when ALU_OP_SET_S   => s_SREG_flags(ALU_FLAG_S) <= '1';
                    when ALU_OP_SET_H   => s_SREG_flags(ALU_FLAG_H) <= '1';
                    when ALU_OP_SET_T   => s_SREG_flags(ALU_FLAG_T) <= '1';
                    when ALU_OP_SET_I   => s_SREG_flags(ALU_FLAG_I) <= '1';
                    when ALU_OP_CLEAR_C => s_SREG_flags(ALU_FLAG_C) <= '0';
                    when ALU_OP_CLEAR_Z => s_SREG_flags(ALU_FLAG_Z) <= '0';
                    when ALU_OP_CLEAR_N => s_SREG_flags(ALU_FLAG_N) <= '0';
                    when ALU_OP_CLEAR_V => s_SREG_flags(ALU_FLAG_V) <= '0';
                    when ALU_OP_CLEAR_S => s_SREG_flags(ALU_FLAG_S) <= '0';
                    when ALU_OP_CLEAR_H => s_SREG_flags(ALU_FLAG_H) <= '0';
                    when ALU_OP_CLEAR_T => s_SREG_flags(ALU_FLAG_T) <= '0';
                    when ALU_OP_CLEAR_I => s_SREG_flags(ALU_FLAG_I) <= '0';
                    when others =>
                end case;
            end if;
        end if;
    end process UPDATE_SREG_FLAGS;

    ----------------------------------------
    -- CALCULATE RESULT
    ----------------------------------------
    s_result <= in_src1  +  in_src2         when s_operation_type = ALU_OP_ADD else
                in_src1 and in_src2         when s_operation_type = ALU_OP_AND else
                in_src1 xor in_src2         when s_operation_type = ALU_OP_NEG else
                in_src1  -  in_src2         when s_operation_type = ALU_OP_SUB else
                in_src1 xor in_src2         when s_operation_type = ALU_OP_XOR else
                in_src1  or in_src2         when s_operation_type = ALU_OP_OR  else
                in_src1  -  in_src2         when s_operation_type = ALU_OP_DEC else
                in_src1  +  in_src2         when s_operation_type = ALU_OP_INC else
                in_src1(6 downto 0) & '0'   when s_operation_type = ALU_OP_LSL else
                '0' & in_src1(7 downto 1)   when s_operation_type = ALU_OP_LSR else
                in_src1  and  (not in_src2) when s_operation_type = ALU_OP_CBI else
                in_src1  or  in_src2        when s_operation_type = ALU_OP_SBI else
                s_result;


    ----------------------------------------------------------------------------
    -- ALU_OP_ADD
    ----------------------------------------------------------------------------
    s_flag_c_add <= (in_src1(7) and in_src2(7)) xor (in_src2(7) and (not s_result(7))) xor ((not s_result(7))
                    and in_src1(7));
    s_flag_z_add <= (not s_result(7)) and (not s_result(6)) and (not s_result(5)) and (not s_result(4))
                    and (not s_result(3)) and (not s_result(2)) and (not s_result(1)) and (not s_result(0));
    s_flag_n_add <= s_result(7);
    s_flag_v_add <= (in_src1(7) and in_src2(7) and (not s_result(7))) xor ((not in_src1(7)) and (not in_src2(7))
                    and s_result(7));
    s_flag_s_add <= s_flag_n_add xor s_flag_v_add;
    s_flag_h_add <= (in_src1(3) and in_src2(3)) xor (in_src2(3) and (not s_result(3))) xor ((not s_result(3))
                    and in_src1(3));
    ----------------------------------------------------------------------------
    -- ALU_OP_AND
    ----------------------------------------------------------------------------
    s_flag_z_and <= (not s_result(7)) and (not s_result(6)) and (not s_result(5)) and (not s_result(4))
                    and (not s_result(3)) and (not s_result(2)) and (not s_result(1)) and (not s_result(0));
    s_flag_n_and <= s_result(7);
    s_flag_v_and <= '0';
    s_flag_s_and <= s_flag_n_and xor s_flag_v_and;
    ----------------------------------------------------------------------------
    -- ALU_OP_NEG
    ----------------------------------------------------------------------------
    s_flag_c_neg <= '1';
    s_flag_z_neg <= (not s_result(7)) and (not s_result(6)) and (not s_result(5)) and (not s_result(4))
                    and (not s_result(3)) and (not s_result(2)) and (not s_result(1)) and (not s_result(0));
    s_flag_n_neg <= s_result(7);
    s_flag_v_neg <= '0';
    s_flag_s_neg <= s_flag_n_neg xor s_flag_v_neg;
    ----------------------------------------------------------------------------
    -- ALU_OP_SUB
    ----------------------------------------------------------------------------
    s_flag_c_sub <= ((not in_src1(7)) and in_src2(7)) xor (in_src2(7) and s_result(7)) xor (s_result(7)
                    and (not in_src1(7)));
    s_flag_z_sub <= (not s_result(7)) and (not s_result(6)) and (not s_result(5)) and (not s_result(4))
                    and (not s_result(3)) and (not s_result(2)) and (not s_result(1)) and (not s_result(0));
    s_flag_n_sub <= s_result(7);
    s_flag_v_sub <= (in_src1(7) and (not in_src2(7)) and (not s_result(7))) xor ((not in_src1(7)) and in_src2(7)
                    and s_result(7));
    s_flag_s_sub <= s_flag_n_sub xor s_flag_v_sub;
    s_flag_h_sub <= ((not in_src1(3)) and in_src2(3)) xor (in_src2(3) and s_result(3)) xor (s_result(3)
                    and (not in_src1(3)));
    ----------------------------------------------------------------------------
    -- ALU_OP_XOR
    ----------------------------------------------------------------------------
    s_flag_z_xor <= (not s_result(7)) and (not s_result(6)) and (not s_result(5)) and (not s_result(4))
                    and (not s_result(3)) and (not s_result(2)) and (not s_result(1)) and (not s_result(0));
    s_flag_n_xor <= s_result(7);
    s_flag_v_xor <= '0';
    s_flag_s_xor <= s_flag_n_xor xor s_flag_v_xor;
    ----------------------------------------------------------------------------
    -- ALU_OP_OR
    ----------------------------------------------------------------------------
    s_flag_z_or <= (not s_result(7)) and (not s_result(6)) and (not s_result(5)) and (not s_result(4))
                   and (not s_result(3)) and (not s_result(2)) and (not s_result(1)) and (not s_result(0));
    s_flag_n_or <= s_result(7);
    s_flag_v_or <= '0';
    s_flag_s_or <= s_flag_n_or xor s_flag_v_or;
    ----------------------------------------------------------------------------
    -- ALU_OP_DEC
    ----------------------------------------------------------------------------
    s_flag_z_dec <= (not s_result(7)) and (not s_result(6)) and (not s_result(5)) and (not s_result(4))
                    and (not s_result(3)) and (not s_result(2)) and (not s_result(1)) and (not s_result(0));
    s_flag_n_dec <= s_result(7);
    s_flag_v_dec <= (not s_result(7)) and s_result(6) and s_result(5) and s_result(4) and s_result(3) and s_result(2)
                    and s_result(1) and s_result(0);
    s_flag_s_dec <= s_flag_n_dec xor s_flag_v_dec;
    ----------------------------------------------------------------------------
    -- ALU_OP_INC
    ----------------------------------------------------------------------------
    s_flag_z_inc <= (not s_result(7)) and (not s_result(6)) and (not s_result(5)) and (not s_result(4))
                    and (not s_result(3)) and (not s_result(2)) and (not s_result(1)) and (not s_result(0));
    s_flag_n_inc <= s_result(7);
    s_flag_v_inc <= s_result(7) and (not s_result(6)) and (not s_result(5)) and (not s_result(4)) and (not s_result(3))
                    and (not s_result(2)) and (not s_result(1)) and (not s_result(0));
    s_flag_s_inc <= s_flag_n_inc xor s_flag_v_inc;
    ----------------------------------------------------------------------------
    -- ALU_OP_LSL
    ----------------------------------------------------------------------------
    s_flag_c_lsl <= in_src1(7);
    s_flag_z_lsl <= (not s_result(7)) and (not s_result(6)) and (not s_result(5)) and (not s_result(4))
                    and (not s_result(3)) and (not s_result(2)) and (not s_result(1)) and (not s_result(0));
    s_flag_n_lsl <= s_result(7);
    s_flag_h_lsl <= in_src1(3);
    s_flag_v_lsl <= s_flag_n_lsl xor s_flag_c_lsl;
    s_flag_s_lsl <= s_flag_n_lsl xor s_flag_v_lsl;
    ----------------------------------------------------------------------------
    -- ALU_OP_LSR
    ----------------------------------------------------------------------------
    s_flag_c_lsr <= in_src1(0);
    s_flag_z_lsr <= (not s_result(7)) and (not s_result(6)) and (not s_result(5)) and (not s_result(4))
                    and (not s_result(3)) and (not s_result(2)) and (not s_result(1)) and (not s_result(0));
    s_flag_n_lsr <= '0';
    s_flag_v_lsr <= s_flag_n_lsr xor s_flag_c_lsr;
    s_flag_s_lsr <= s_flag_n_lsr xor s_flag_v_lsr;
    ----------------------------------------------------------------------------

    s_write_enable   <= in_control(CONTROL_ALU_MODIFY_FLAG_ENABLE);
    s_operation_type <= in_control(CONTROL_ALU_OP_TYPE_UPPER downto CONTROL_ALU_OP_TYPE_LOWER);

    out_result       <= s_result;
    out_SREG_flags   <= s_SREG_flags;

end ALU;
