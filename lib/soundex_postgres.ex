defmodule SoundexPostgres do
  @moduledoc """
  Compute Soundex codes for strings.

  Soundex is an algorithm for representing (mainly English) names as short phonetic codes.
  A Soundex code begins with the first letter of the name, followed by three digits.
  They are typically used to match like-sounding names.

  For more information, see [the Postgres entry](https://www.postgresql.org/docs/current/fuzzystrmatch.html#FUZZYSTRMATCH-SOUNDEX).

  ## Examples:

      iex> SoundexPostgres.soundex("Morris")
      "M620"

      iex> SoundexPostgres.soundex("Harris")
      "H620"

      iex> SoundexPostgres.soundex("Morrison")
      "M625"

      iex> SoundexPostgres.soundex("Smith")
      "S530"

      iex> SoundexPostgres.soundex("Smithie")
      "S530"
  """

  @soundex_table %{
    0 => "0",
    1 => "1",
    2 => "2",
    3 => "3",
    4 => "0",
    5 => "1",
    6 => "2",
    7 => "0",
    8 => "0",
    9 => "2",
    10 => "2",
    11 => "4",
    12 => "5",
    13 => "5",
    14 => "0",
    15 => "1",
    16 => "2",
    17 => "6",
    18 => "2",
    19 => "3",
    20 => "0",
    21 => "1",
    22 => "0",
    23 => "2",
    24 => "0",
    25 => "2"
  }

  @vowels ~w(A E I O U W Y H)

  @empty_ascii_code "	"

  @allowed_regex_graphemes ~r/[a-zA-Z0-9.\- ]/
  @allowed_regex_letter ~r/[a-zA-Z]/

  defstruct graphemes: [], lastest_graphemes: []

  @doc """
  Compute the Soundex code of a string.

  For details, see (http://en.wikipedia.org/wiki/soundex)[the Wikipedia entry].
  The Soundex algorithm is only defined for strings with ASCII characters.

  Returns a string.

  ## Examples:

      iex> SoundexPostgres.soundex("Jackson")
      "J250"
  """
  @spec soundex(name :: binary(), opts :: keyword()) :: binary()
  def soundex(name, opts \\ []) do
    name
    |> String.graphemes()
    |> Enum.map(&String.upcase/1)
    |> Enum.filter(&String.match?(&1, @allowed_regex_graphemes))
    |> do_soundex(opts)
  end

  defp do_soundex(graphemes, opts) do
    debug = Keyword.get(opts, :debug, false)

    first_grapheme = get_first_letter_from_graphemes(graphemes)

    graphemes
    |> Enum.reduce(%__MODULE__{}, &handle_reduce_soundex(&1, &2, debug))
    |> then(fn result -> result.graphemes end)
    |> Enum.reverse()
    |> Enum.map(fn {_letter, code} -> code end)
    |> then(fn graphemes ->
      if is_vowel?(first_grapheme) do
        [first_grapheme | graphemes]
      else
        [first_grapheme | List.delete_at(graphemes, 0)]
      end
    end)
    |> Enum.slice(0..3)
    |> Enum.join()
    |> format_result()
  end

  defp handle_reduce_soundex(letter, acc, debug) do
    latest_letter = get_letter_valid_from_list(acc.lastest_graphemes)

    out = soundex_code(letter)

    if debug, do: debug_output(latest_letter, letter, out)

    if is_allowed_letter?(letter) and is_different_soundex_code?(letter, latest_letter) do
      if out != "0" do
        struct(acc,
          graphemes: [{letter, out} | acc.graphemes],
          lastest_graphemes: [letter | acc.lastest_graphemes]
        )
      else
        struct(acc, lastest_graphemes: [letter | acc.lastest_graphemes])
      end
    else
      struct(acc, lastest_graphemes: [letter | acc.lastest_graphemes])
    end
  end

  defp soundex_code(letter) do
    charlist = :binary.first(letter)

    if charlist >= ?A and charlist <= ?Z do
      charlist_index = charlist - :binary.first("A")

      Map.get(@soundex_table, charlist_index)
    else
      letter
    end
  end

  defp get_first_letter_from_graphemes(graphemes) do
    graphemes
    |> Enum.filter(&String.match?(&1, @allowed_regex_letter))
    |> List.first("")
  end

  defp is_vowel?(letter), do: letter in @vowels

  defp is_allowed_letter?(letter) do
    String.match?(letter, @allowed_regex_letter)
  end

  defp is_different_soundex_code?(letter1, letter2) do
    soundex_code(letter1) != soundex_code(letter2)
  end

  defp get_letter_valid_from_list(graphemes) do
    case graphemes do
      [letter | _] -> letter
      _ -> @empty_ascii_code
    end
  end

  defp format_result(""), do: ""
  defp format_result(result), do: String.pad_trailing(result, 4, "0")

  # coveralls-ignore-start
  defp debug_output(latest, letter, out) do
    require Logger

    out_minus = if latest, do: soundex_code(latest), else: ""

    out_plus = :binary.first(out) + 1
    out_plus = List.to_string([out_plus])

    Logger.debug("#{letter} => #{out} => #{out_plus} => #{latest} => #{out_minus}")
  end
end
