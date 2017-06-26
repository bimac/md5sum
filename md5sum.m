function out = md5sum(in)
% MD5SUM  Obtain a file's MD5 hash value using system calls.
%   OUT = MD5SUM(FILENAME) calculates the MD5 hash value (1) of file IN
%   using calls to system functions. For performance reasons, MD5SUM will
%   hand over to Jan Simon's GETMD5 (2) if the latter is accessible as a
%   compiled MEX file. The result: reliable calculation of MD5 sums on all
%   modern platforms (GLNXA64, MACI64, PCWIN64) plus the speed of MEX files
%   on supported systems (via GETMD5, with small overhead).
%
%   Example: out = md5sum('directory/file.ext')
%
%   (1) https://en.wikipedia.org/wiki/MD5
%   (2) https://de.mathworks.com/matlabcentral/fileexchange/25921-getmd5
%
%   See also GETMD5

% Revision history:
% 2017-06-26 speed improvements + documentation
% 2017-06-14 small speed improvements
% 2017-06-12 initial release

% Check if GetMD5 is available
persistent GetMD5available
if isempty(GetMD5available)
    GetMD5available = endsWith(which('GetMD5'),mexext);
end

% Pass input to GetMD5
if GetMD5available
    out = GetMD5(in,'file');
    return
end

% Check input argument
validateattributes(in,{'char'},{'nonempty','row'});
if ~java.io.File(in).exists
    error('File not found: %s',in)
end

% Get the MD5 sum via system calls
switch computer
    case 'GLNXA64'
        [~,tmp] = system(['md5sum ' in]);
    case 'MACI64'
        [~,tmp] = system(['md5 -r ' in]);
    case 'PCWIN64'
        [~,tmp] = system(['CertUtil -hashfile ' in ' MD5']);
    otherwise
        error('%s does not support %s',mfilename,computer)
end
out = regexp(tmp,'^\w{32}','match','once','lineanchors');