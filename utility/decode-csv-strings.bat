:: encode the strings from the csv file in /strings and creates all the
:: w3strings files

call variables.cmd

cd "%modpath%\Strings"

"%modkitpath%\w3strings\w3strings" -d en.w3strings
