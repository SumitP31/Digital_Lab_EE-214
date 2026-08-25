library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_beh is
    port (
        S : in  std_logic_vector(1 downto 0);
        A : in  std_logic_vector(3 downto 0);
        B : in  std_logic_vector(3 downto 0);
        Y : out std_logic_vector(7 downto 0)
    );
end entity alu_beh;


architecture arch of alu_beh is

    ----------------------------------------------------------------
    -- 00 : Circular rotation of A by B
    -- B(3) = 0 -> left rotation
    -- B(3) = 1 -> right rotation
    -- B(2 downto 0) = number of positions
    ----------------------------------------------------------------
    function Shift(
        A : std_logic_vector(3 downto 0);
        B : std_logic_vector(3 downto 0)
    ) return std_logic_vector is

        variable A_extended : std_logic_vector(7 downto 0)
            := (others => '0');

        variable result : std_logic_vector(7 downto 0);
        variable shift_amount : integer;

    begin
        -- Zero extend A to 8 bits
        A_extended(3 downto 0) := A;

        -- Number of positions to rotate
        shift_amount := to_integer(unsigned(B(2 downto 0)));

        if B(3) = '0' then
            -- Left rotation
            result := std_logic_vector(
                rotate_left(unsigned(A_extended), shift_amount)
            );
        else
            -- Right rotation
            result := std_logic_vector(
                rotate_right(unsigned(A_extended), shift_amount)
            );
        end if;

        return result;
    end function;


    ----------------------------------------------------------------
    -- 01 : Gray code of concatenation A & B
    -- X = A & B (8 bits)
    -- Gray(X) = X XOR (X shifted right by 1)
    ----------------------------------------------------------------
    function Gray_Code(
        A : std_logic_vector(3 downto 0);
        B : std_logic_vector(3 downto 0)
    ) return std_logic_vector is

        variable X : std_logic_vector(7 downto 0);
        variable G : std_logic_vector(7 downto 0);

    begin
        X := A & B;

        G(7) := X(7);

        for i in 6 downto 0 loop
            G(i) := X(i + 1) xor X(i);
        end loop;

        return G;
    end function;


    ----------------------------------------------------------------
    -- 10 : Hamming distance between A and B
    -- Returns number of differing bits
    ----------------------------------------------------------------
    function Hamming(
        A : std_logic_vector(3 downto 0);
        B : std_logic_vector(3 downto 0)
    ) return std_logic_vector is

        variable count : integer := 0;
        variable result : std_logic_vector(7 downto 0)
            := (others => '0');

    begin

        for i in 0 to 3 loop
            if A(i) /= B(i) then
                count := count + 1;
            end if;
        end loop;

        result := std_logic_vector(
            to_unsigned(count, 8)
        );

        return result;
    end function;


    ----------------------------------------------------------------
    -- 11 : A * B using Shift and Add
    ----------------------------------------------------------------
    function Mul_Shift_Add(
        A : std_logic_vector(3 downto 0);
        B : std_logic_vector(3 downto 0)
    ) return std_logic_vector is

        variable multiplicand : unsigned(7 downto 0);
        variable multiplier   : unsigned(3 downto 0);
        variable result       : unsigned(7 downto 0)
            := (others => '0');

    begin

        -- Zero extend A
        multiplicand := resize(unsigned(A), 8);
        multiplier := unsigned(B);

        -- Shift and Add multiplication
        for i in 0 to 3 loop

            if multiplier(i) = '1' then
                result := result +
                          shift_left(multiplicand, i);
            end if;

        end loop;

        return std_logic_vector(result);

    end function;


begin

    ----------------------------------------------------------------
    -- ALU operation selection
    ----------------------------------------------------------------
    process(A, B, S)

    begin

        if S = "00" then

            -- Circular rotation
            Y <= Shift(A, B);

        elsif S = "01" then

            -- Gray code of A concatenated with B
            Y <= Gray_Code(A, B);

        elsif S = "10" then

            -- Hamming distance
            Y <= Hamming(A, B);

        else

            -- Multiplication using Shift and Add
            Y <= Mul_Shift_Add(A, B);

        end if;

    end process;

end architecture;