function ForcedAlign(align_py,wavpath,txtpath,textgridpath)

% Input
% align_py: full path of align.py e.g. '/Users/jaegukang/Documents/p2fa/align.py'
% wavpath: full path of wav e.g. '/Users/jaegukang/Documents/p2fa/test/ploppy.wav'
% txtpath: full path of txt e.g. '/Users/jaegukang/Documents/p2fa/test/ploppy.txt'
% textgridpath: full path of textgrid e.g. '/Users/jaegukang/Documents/p2fa/test/ploppy.TextGrid'
%
% When FA is excuted, current directory will be changed to p2fa folder
%
% updated 2015-4-23
%
% 2nd updates 2015-9-2 resampling is not needed
%
% 3rd updates 2016-1-27 check audio file corruption
% (if corrupted, it gives you warning)
%
% N.B. 
% - Please avoid the path including space or parenthesis ().
% - Make sure you installed both HTK and sox, and they work well on
% terminal at first.
% - Check permission on P2FA folder. If 'Permission denied' occurs, right
%   click P2FA folder --> Get info --> (from the bottom) Change permission
%   settings to Read & Write (everyone) by unlocking the setting first, 
%   then choose Apply to enclosed items... bottom left corner.
% - Highly recommended to use a shell script when it comes to multiple
% audio files, rather than use this function within for loops.

% help
if nargin < 1,
    eval('help ForcedAlign');
    return;
end;


% check if the audio file is corrupted
try
    [y,Fs] = audioread (wavpath);
    % resample to 11025Hz
    ynew = resample(y, 11025,Fs);
    [path,fname,ext] = fileparts(wavpath);
    RSPwavpath = [path '/tmp' ext];
    audiowrite(RSPwavpath,ynew,11025);


    % run FA
    cd(align_py(1:regexp(align_py,'align.py')-1)); % you'd better not change here
                                                   % If deleted, 'tmp' will be created in the current directory
    cmd = [align_py ' ' RSPwavpath ' ' txtpath ' ' textgridpath];
    PATH = getenv('PATH');
    setenv('PATH', [PATH ':/usr/local/bin']); % make sure this path includes HVite, HCopy and sox
    unix(cmd);

    eval(['delete(''' RSPwavpath ''')'])

catch
    % if the audio file is corrupted
    warning('%s is corrupted!!', wavpath);
end

end