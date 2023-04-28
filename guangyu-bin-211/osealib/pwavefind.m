%%
function [Ponset,Poffset,Ppos] = pwavefind(x,findmark,fs)
dx = diff(x);
ii = findmark - 0.25*fs;
if ii < 1
    ii = 1;
end
maxflue = 0;
maxflueI = ii;
while ii < findmark-0.1*fs
    tmp = (dx(ii:ii+0.05*fs));
    if maxflue < max(tmp)-min(tmp);
        maxflue = max(tmp)-min(tmp);
        maxflueI = ii;
    end;
    ii = ii +1 ;
end

% 从最大波动处，往后寻找平坦的地方
ii = maxflueI;
maxflue = max(x(ii:ii+0.05*fs))-min(x(ii:ii+0.05*fs));
while ii < maxflueI+0.05*fs &&  isocheck(x,ii,0.05*fs,maxflue/2)==0
    ii = ii+1;
end;
Poffset = ii+0.05*fs;

% 如果没有找到平坦的地方，放松条件继续找
if ii == maxflueI+0.05*fs
    ii = maxflueI;
    while ii < maxflueI+0.05*fs  &&  isocheck(x,ii,0.03*fs,maxflue/2)==0
        ii = ii+1;
    end;
    Poffset = ii+0.03*fs;
end

% 往前找平坦的地方，
ii = maxflueI;
while ii > maxflueI- 0.1*fs && ii > 0  &&  isocheck(x,ii,0.05*fs,maxflue/2)==0
    ii = ii-1;
end;
Ponset = ii;
%放松条件继续找
if ii == maxflueI- 0.1*fs 
    ii = maxflueI;
    while ii > maxflueI- 0.1*fs && ii>0&& isocheck(x,ii,0.03*fs,maxflue/2)==0
        ii = ii-1;
    end;
    Ponset = ii;
end

if Ponset < 1 Ponset = 1; end;

z = (x(Ponset)+x(Poffset))/2;
[a ,b ] = max(abs(x(Ponset:Poffset)-z));
Ppos = Ponset+b-1;

% figure;plot(x); hold on;plot([Tpos,Toffset],x([Tpos,Toffset]),'.r');