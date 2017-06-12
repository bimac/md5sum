function out = md5sum(in)
% MD5SUM  Obtain a file's MD5 hash value using system calls.
%   OUT = MD5SUM(FILENAME) calculates the MD5 hash value (1) of file IN
%   using calls to system functions. For performance reasons, MD5SUM will
%   hand over to Jan Simon's GETMD5 (2) if the latter is accessible as a
%   compiled MEX file.
%
%   Example: out = md5sum('directory/file.ext')
%
%   (1) https://en.wikipedia.org/wiki/MD5
%   (2) https://de.mathworks.com/matlabcentral/fileexchange/25921-getmd5
%
%   See also GETMD5

% Revision history:
% 2017-06-17 initial release

% Try to pass the input to Jan Simon's GetMD5 ...
if regexpi(which('GetMD5'),[mexext '$'])
    out = GetMD5(in,'file');
    return
end

% Check input argument
validateattributes(in,{'char'},{'nonempty'});
if ~exist(in,'file')
	error('File not found:\n%s',in)
end

% Get the MD5 sum via system calls
switch computer
    case 'GLNXA64'
        [~,tmp] = system(['md5sum ' in]);
        out     = regexpi(tmp,'\w{32}','match','once');
    case 'MACI64'
        [~,tmp] = system(['md5 ' in]);
        out     = regexpi(tmp,'(?<= \= )\w{32}','match','once');
    case 'PCWIN64'
        [~,tmp] = system(['CertUtil -hashfile ' in ' MD5']);
        out     = regexpi(tmp,'(?<=\n)\w{32}','match','once');
    otherwise
        error('%s does not support %s',mfilename,computer)
end