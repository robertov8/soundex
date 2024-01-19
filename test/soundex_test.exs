defmodule SoundexTest do
  use ExUnit.Case

  describe "soundex/1 Second Letter" do
    test "should return M532 when first_code equal code and latest is unknown" do
      assert Soundex.soundex("Mehmet KAYA") == "M532"
    end
  end

  describe "soundex/1 Fourth Letter" do
    test "should return S522 when third_code equal code and latest is unknown" do
      assert Soundex.soundex("SHENG CORE TECHNOLOGY CO LIMITED") == "S522"
    end
  end

  describe "soundex/1" do
    test "double key letters" do
      assert Soundex.soundex("Gutierrez") == "G362"
    end

    test "side-by-side letters with the same code number [Campbell]" do
      assert Soundex.soundex("Campbell") == "C514"
    end

    test "side-by-side letters with the same code number [Jackson]" do
      assert Soundex.soundex("Jackson") == "J250"
    end

    test "side-by-side letters with the same code number [Pfister]" do
      assert Soundex.soundex("Pfister") == "P236"
    end

    test "vowel key letter seperators" do
      assert Soundex.soundex("Tomzak") == "T522"
      assert Soundex.soundex("Roses") == "R220"
    end

    test "H or W key letter seperators" do
      assert Soundex.soundex("Ashcroft") == "A226"
      assert Soundex.soundex("Carwruth") == "C663"
    end

    test "more soundex examples [Heimbach]" do
      assert Soundex.soundex("Heimbach") == "H512"
    end

    test "more soundex examples [AZIA SHIPPING COMPANY]" do
      assert Soundex.soundex("AZIA SHIPPING COMPANY") == "A221"
    end

    test "more soundex examples [82 ELM REALTY LLC]" do
      assert Soundex.soundex("82 ELM REALTY LLC") == "E456"
    end

    test "more soundex examples [CROWLANDS, S.A. DE C.V.]" do
      assert Soundex.soundex("CROWLANDS, S.A. DE C.V.") == "C645"
    end

    test "more soundex examples [7-28]" do
      assert Soundex.soundex("7-28") == ""
    end

    test "more soundex examples [WARGOS INDUSTRY LIMITED]" do
      assert Soundex.soundex("WARGOS INDUSTRY LIMITED") == "W622"
    end

    test "more soundex examples [Khaled QADDOUM]" do
      assert Soundex.soundex("Khaled QADDOUM") == "K432"
    end

    test "more soundex examples [STANMIX HOLDING LIMITED]" do
      assert Soundex.soundex("STANMIX HOLDING LIMITED") == "S352"
    end

    test "more soundex examples" do
      assert Soundex.soundex("Allricht") == "A462"
      assert Soundex.soundex("Eberhard") == "E166"
      assert Soundex.soundex("McGee") == "M200"
    end
  end
end
