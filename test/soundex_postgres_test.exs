defmodule SoundexPostgresTest do
  use ExUnit.Case

  alias SoundexPostgres
  alias NimbleCSV.RFC4180, as: CSV

  describe "soundex/1" do
    test "should return valid response when parse ofac list" do
      ofac_list()
      |> File.stream!()
      |> CSV.parse_stream()
      |> Stream.map(fn [name, soundex_code] ->
        assert SoundexPostgres.soundex(name) == soundex_code
      end)
      |> Stream.run()
    end
  end

  defp ofac_list do
    Application.app_dir(:soundex, "/priv/ofac_list.csv")
  end
end
