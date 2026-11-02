function [RE,IM,NP,NB,NT,HDR] = updateFIDfile(name,newdata,blocks,traces)
%----------------------------------------

% format input name
fullname = sprintf('%s%cfid',name,'/'); %something funky with the backslash going on...

fid = fopen(fullname,'r+','ieee-be');
if fid == -1
    str = sprintf('Can not open file %s',fullname);
    error(str);
end

% Read datafileheader
nblocks   = fread(fid,1,'int32');
ntraces   = fread(fid,1,'int32');
np        = fread(fid,1,'int32');
ebytes    = fread(fid,1,'int32');
tbytes    = fread(fid,1,'int32');
bbytes    = fread(fid,1,'int32');
vers_id   = fread(fid,1,'int16');
status    = fread(fid,1,'int16');
nbheaders = fread(fid,1,'int32');


s_data    = bitget(status,1);
s_spec    = bitget(status,2);
s_32      = bitget(status,3);
s_float   = bitget(status,4);
s_complex = bitget(status,5);
s_hyper   = bitget(status,6);

% reset output structures
RE = real(newdata);
IM = imag(newdata);

data(1:2:np)= RE;
data(2:2:np)= IM;

                    
if exist('blocks') == 0
    blocks = 1:nblocks;
end
outblocks = max(size(blocks));

if exist('traces') == 0
    traces = 1:ntraces;
end
outtraces = max(size(traces));


inx = 1;
B = 1;
%for b = 1:nblocks
   % sprintf('read block %d\n',b);
    sprintf('read block %d\n',blocks);
    % Read a block header
    scale     = fread(fid,1,'int16');
    bstatus   = fread(fid,1,'int16');
    index     = fread(fid,1,'int16');
    mode      = fread(fid,1,'int16');
    ctcount   = fread(fid,1,'int32');
    lpval     = fread(fid,1,'float32');
    rpval     = fread(fid,1,'float32');
    lvl       = fread(fid,1,'float32');
    tlt       = fread(fid,1,'float32');
    
    T = 1;
    update_B = 0;
    
    for t = 1:ntraces
        %We have to read data every time in order to increment file
        %pointerl
        if s_float == 1
            status=fseek(fid,(blocks-1)*(np*4+28),0);
            fwrite(fid,data,'float32');
            str='writing floats';
        elseif s_32 == 1
            status=fseek(fid,(blocks-1)*(np*4+28),0);
            data = fread(fid,np,'int32');
            str='reading 32bit';l
        else
            status=fseek(fid,(blocks-1)*(np*2+28),0);
            data = fread(fid,np,'int16');
            str='reading 16bit';
        end

            inx = inx + 1;
            T = T + 1;
            update_B = 1;

    if update_B, B = B + 1; end
    
    if B > outblocks
        break
    end
end  % done reading one block


if nargout > 2
    NP = np/2;
end
if nargout > 3
    NB = nblocks;
end
if nargout > 4
    NT = ntraces;
end
if nargout > 5
    HDR = [nblocks, ntraces, np, ebytes, tbytes, bbytes, vers_id, status, nbheaders];
    HDR = [HDR, scale, bstatus, index, mode, ctcount, lpval, rpval, lvl, tlt];
end
fclose(fid);


