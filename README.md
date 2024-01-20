Soundex
=======

An module for computing the Soundex codes of strings.

Soundex is an algorithm for representing (mainly English) names as short phonetic codes. 
A Soundex code begins with the first letter of the name, followed by three digits.
They are typically used to match like-sounding names.

For more information, see [the Wikipedia entry](http://en.wikipedia.org/wiki/soundex).

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


## Details

Soundex only encodes letters from the English alphabet. So, for example, 
punctuation in names is ignored:

    iex> SoundexPostgres.soundex("O'Brien") == SoundexPostgres.soundex("OBrien")
    true

As are spaces:

    iex> SoundexPostgres.soundex("Van Dyke") == SoundexPostgres.soundex("Vandyke")

Unicode letters are also ignored:

    iex> SoundexPostgres.soundex("Piñata") == SoundexPostgres.soundex("Pinata")
    false

    iex> SoundexPostgres.soundex("Piñata") == SoundexPostgres.soundex("Piata")
    true
