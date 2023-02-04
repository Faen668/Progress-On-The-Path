:: encode the strings from the csv file in /strings and creates all the
:: w3strings files

call variables.cmd

cd "%modpath%\Strings"
del *.w3strings
"%modkitpath%\w3strings\w3strings" --encode en.csv --force-ignore-id-space-check-i-know-what-i-am-doing

del *.ws
rename en.csv.w3strings en.w3strings

copy en.w3strings ar.w3strings
copy en.w3strings br.w3strings
copy en.w3strings cz.w3strings
copy en.w3strings de.w3strings
copy en.w3strings es.w3strings
copy en.w3strings esmx.w3strings
copy en.w3strings fr.w3strings
copy en.w3strings hu.w3strings
copy en.w3strings it.w3strings
copy en.w3strings jp.w3strings
copy en.w3strings kr.w3strings
copy en.w3strings pl.w3strings
copy en.w3strings ru.w3strings
copy en.w3strings zh.w3strings