Soundex
=======

An module for computing the Soundex codes of strings.

Soundex is an algorithm for representing (mainly English) names as short phonetic codes. 
A Soundex code begins with the first letter of the name, followed by three digits.
They are typically used to match like-sounding names.

For more information, see [the Wikipedia entry](http://en.wikipedia.org/wiki/soundex).

## Examples:

    iex> Soundex.soundex("Morris")
    "M620"
    
    iex> Soundex.soundex("Harris")
    "H620"  

    iex> Soundex.soundex("Morrison")
    "M625"

    iex> Soundex.soundex("Smith")
    "S530"

    iex> Soundex.soundex("Smithie")
    "S530"           


## Details

Soundex only encodes letters from the English alphabet. So, for example, 
punctuation in names is ignored:

    iex> Soundex.soundex("O'Brien") == Soundex.soundex("OBrien")
    true

As are spaces:

    iex> Soundex.soundex("Van Dyke") == Soundex.soundex("Vandyke")

Unicode letters are also ignored:

    iex> Soundex.soundex("Piñata") == Soundex.soundex("Pinata")
    false

    iex> Soundex.soundex("Piñata") == Soundex.soundex("Piata")
    true

## TODO
Cases where the algorithm still does not match

```elixir
%{algorithm: "E100", row: %{name: "EW-001PH", soundex_code: "E000"}}
%{algorithm: "E100", row: %{name: "EW-001PA", soundex_code: "E000"}}
%{algorithm: "E120", row: %{name: "EW-301PJ", soundex_code: "E200"}}
%{algorithm: "P223", row: %{name: "PICASO 3D LLC", soundex_code: "P224"}}
%{algorithm: "E100", row: %{name: "EW-001PH", soundex_code: "E000"}}
%{algorithm: "E100", row: %{name: "EW-001PA", soundex_code: "E000"}}
%{algorithm: "E120", row: %{name: "EW-301PJ", soundex_code: "E200"}}
%{algorithm: "P223", row: %{name: "PICASO 3D LLC", soundex_code: "P224"}}
```