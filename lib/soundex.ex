defmodule Soundex do
  require Logger

  def soundex(name) do
    name
    |> String.graphemes()
    |> remove_invalid_graphemes_from_beginning()
    |> Enum.with_index()
    |> Enum.map(&with_codes(&1))
    |> remove_duplicates_grapheme([], false)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map_join("", &join_grapheme/1)
    |> String.pad_trailing(4, "0")
    |> String.slice(0..3)
    |> remove_invalid_result()
  end

  defp remove_invalid_graphemes_from_beginning(graphemes) do
    graphemes
    |> Enum.filter(&Regex.match?(~r/[a-zA-Z-. ]/, &1))
    |> Enum.join("")
    |> String.replace(~r/[0-9]{1,}/, "")
    |> String.trim()
    |> String.graphemes()
  end

  defp remove_invalid_result("0000"), do: ""
  defp remove_invalid_result(result), do: result

  defp remove_duplicates_grapheme([], processed, _latest), do: processed

  defp remove_duplicates_grapheme([{"H", _code, 0} = grapheme | graphemes], processed, _latest) do
    Logger.debug("second1: #{inspect([grapheme, :unknown, processed])}")
    remove_duplicates_grapheme(graphemes, [grapheme | processed], :unknown)
  end

  defp remove_duplicates_grapheme([{"W", _code, 0} = grapheme | graphemes], processed, _latest) do
    remove_duplicates_grapheme(graphemes, [grapheme | processed], :unknown)
  end

  defp remove_duplicates_grapheme([{_letter, :unknown, 0} | graphemes], processed, _latest) do
    remove_duplicates_grapheme(graphemes, processed, :unknown)
  end

  defp remove_duplicates_grapheme([{_, :vowel, 0} = grapheme | graphemes], processed, _latest) do
    remove_duplicates_grapheme(graphemes, [grapheme | processed], :vowel)
  end

  defp remove_duplicates_grapheme([{_, _code, 0} = grapheme | graphemes], processed, _latest) do
    remove_duplicates_grapheme(graphemes, [grapheme | processed], false)
  end

  defp remove_duplicates_grapheme([{_letter, :unknown, _index} | graphemes], processed, _latest) do
    remove_duplicates_grapheme(graphemes, processed, :unknown)
  end

  defp remove_duplicates_grapheme([{_letter, :vowel, _index} | graphemes], processed, _latest) do
    remove_duplicates_grapheme(graphemes, processed, :vowel)
  end

  defp remove_duplicates_grapheme(
         [{_letter, code, _index} = grapheme | graphemes],
         processed,
         latest
       ) do
    case processed do
      ##########################################################################
      # Second Letter
      ##########################################################################
      [{_, first_code, _}] when first_code == code and latest == :vowel ->
        Logger.debug("second1: #{inspect([grapheme, latest, processed])}")
        remove_duplicates_grapheme(graphemes, [grapheme | processed], :letter)

      [{_, first_code, _}] when first_code == code and latest == :unknown ->
        Logger.debug("second2: #{inspect([grapheme, latest, processed])}")
        remove_duplicates_grapheme(graphemes, [grapheme | processed], :letter)

      [{_, first_code, _}] when first_code == code ->
        Logger.debug("second3: #{inspect([grapheme, latest, processed])}")
        remove_duplicates_grapheme(graphemes, processed, :letter)

      [{_, _, _}] ->
        Logger.debug("second4: #{inspect([grapheme, latest, processed])}")
        remove_duplicates_grapheme(graphemes, [grapheme | processed], :letter)

      ##########################################################################
      # Third Letter
      ##########################################################################
      [{_second_letter, second_code, _}, _] when second_code == code and latest == :vowel ->
        Logger.debug("third1: #{inspect([grapheme, latest, processed])}")
        remove_duplicates_grapheme(graphemes, [grapheme | processed], :letter)

      [{_second_letter, second_code, _}, _] when second_code == code and latest == :unknown ->
        Logger.debug("third2: #{inspect([grapheme, latest, processed])}")
        remove_duplicates_grapheme(graphemes, [grapheme | processed], :letter)

      [{_second_letter, second_code, _}, _] when second_code == code ->
        Logger.debug("third3: #{inspect([grapheme, latest, processed])}")
        remove_duplicates_grapheme(graphemes, processed, :letter)

      [_second, _] ->
        Logger.debug("third4: #{inspect([grapheme, latest, processed])}")
        remove_duplicates_grapheme(graphemes, [grapheme | processed], :letter)

      ##########################################################################
      # Fourth Letter
      ##########################################################################
      [{_, third_code, _}, _, _] when third_code == code and latest == :vowel ->
        Logger.debug("fourth1: #{inspect([grapheme, latest, processed])}")
        remove_duplicates_grapheme(graphemes, [grapheme | processed], :letter)

      [{_, third_code, _}, _, _] when third_code == code and latest == :unknown ->
        Logger.debug("fourth2: #{inspect([grapheme, latest, processed])}")
        remove_duplicates_grapheme(graphemes, [grapheme | processed], :letter)

      [{_, third_code, _}, _, _] when third_code == code ->
        Logger.debug("fourth3: #{inspect([grapheme, latest, processed])}")
        remove_duplicates_grapheme(graphemes, processed, :letter)

      [_third, _, _] ->
        Logger.debug("fourth4: #{inspect([grapheme, latest, processed])}")
        remove_duplicates_grapheme(graphemes, [grapheme | processed], :letter)

      ##########################################################################
      ##########################################################################
      _ ->
        remove_duplicates_grapheme(graphemes, processed, :letter)
    end
  end

  defp join_grapheme({{grapheme, _code, _index}, 0}), do: grapheme
  defp join_grapheme({{_grapheme, code, _index}, _}), do: code

  defp with_codes({grapheme, index}) do
    code =
      grapheme
      |> String.upcase()
      |> code_with_weight()

    {String.upcase(grapheme), code, index}
  end

  defp code_with_weight("B"), do: 1
  defp code_with_weight("F"), do: 1
  defp code_with_weight("P"), do: 1
  defp code_with_weight("V"), do: 1

  defp code_with_weight("C"), do: 2
  defp code_with_weight("S"), do: 2
  defp code_with_weight("K"), do: 2
  defp code_with_weight("G"), do: 2
  defp code_with_weight("J"), do: 2
  defp code_with_weight("Q"), do: 2
  defp code_with_weight("X"), do: 2
  defp code_with_weight("Z"), do: 2

  defp code_with_weight("D"), do: 3
  defp code_with_weight("T"), do: 3

  defp code_with_weight("L"), do: 4

  defp code_with_weight("M"), do: 5
  defp code_with_weight("N"), do: 5

  defp code_with_weight("R"), do: 6

  defp code_with_weight("A"), do: :vowel
  defp code_with_weight("E"), do: :vowel
  defp code_with_weight("I"), do: :vowel
  defp code_with_weight("O"), do: :vowel
  defp code_with_weight("U"), do: :vowel
  defp code_with_weight("Y"), do: :vowel

  defp code_with_weight(_), do: :unknown
end
