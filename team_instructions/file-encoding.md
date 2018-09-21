File encoding issues
====================

A common problem that arises when working with other languages than English is
that any kind of special characters in the alphabet, like Swedish umlauts 
*å*, *ä*, *ö*, can create problems when you save and open files.

Different operating systems (Windows, Mac, Linux) expect and, by default, use
different encoding conventions. **In our project, we want to stick to "UTF-8" 
encoding**. However, Excel will expect input in Western (Windows 1252) and it
will save files in that format unless told to do otherwise.

To find out the encoding of a specific file:

a) Open the file in Sublime Text.
b) Click on View > Show Console.
c) A small white console shows up at the bottom of the screen.
d) In the lowest row (the one that accepts written input), type in the command
"view.encoding()" and press return.
e) Sublime will tell you the encoding of the file.
f) Use this information when you open the file in Excel, i.e. if the file
encoding is 'Western (Windows 1252)', then use this option when you import the
file as text in Excel; if the encoding is 'UTF-8', then select that option.
g) If you want to change the encoding of a text file (.txt, .csv, .md, etc.),
you can also, in Sublime, go to File > Save with encoding > UTF-8. That will
save the file in UTF-8 format.

NB: For some reason the data files in `pilot_analysis/data_coding/`, which are
created with the R script `pilot_analysis/pilot-data_preprocess.R`, are not
recognized by Sublime as being encoded in UTF-8 format, even though the R-script
does specify that. GMM doesn't understand why, so let us just be pragmatic about
it:

Make sure that the final coded version of the data is in "UTF-8". Follow step g) in the list here above to achieve it.


Saving files on a Mac
---------------------

Using Excel on a Mac seems to lead to yet another series of encoding issues.
GMM has realized this when trying to read into R the coded files from the
norming study, e.g. 
`norming_1809_analysis/data_coding/CODED_804_L2-eng_oral_translation.csv`.

There are two issues to be aware of:

- The encoding for these files is 'UTF-8 with BOM' (found out following step d
above). This is *not* the same as 'UTF-8' (see 
[here](https://stackoverflow.com/questions/2223882/whats-different-between-utf-8-and-utf-8-without-bom)).
To remedy this, follow step g above.
- For some reason, there is a final empty line missing. This creates problems
when reading files, so in general once should make sure that there is an empty
line (see 
[here](https://stackoverflow.com/questions/729692/why-should-text-files-end-with-a-newline)).
However, GMM thinks this issue might be caused by working across different
operative systems (Mac/Windows).
