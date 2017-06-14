# md5sum
Obtain a file's MD5 hash value using system calls.

OUT = MD5SUM(FILENAME) calculates the MD5 hash value (1) of file IN using calls to system functions. For performance reasons, MD5SUM will hand over to Jan Simon's GETMD5 (2) if the latter is accessible as a compiled MEX file.

Example: out = md5sum('directory/file.ext')

(1) https://en.wikipedia.org/wiki/MD5
(2) https://de.mathworks.com/matlabcentral/fileexchange/25921-getmd5
