%%
function [Tonset,Toffset,Tpos] = twavefind(x,findmark,fs)

ii = findmark +0.16*fs;
maxflue = 0;
maxflueI = ii;
while ii < findmark+0.42*fs
    tmp = x(ii:ii+0.06*fs);
    if maxflue < max(tmp)-min(tmp);
        maxflue = max(tmp)-min(tmp);
        maxflueI = ii;
    end;
    ii = ii +1 ;
end
% ����󲨶���������Ѱ��ƽ̹�ĵط�
ii = maxflueI+0.06*fs;
while ii < findmark+0.5*fs &&  isocheck(x,ii,0.08*fs,0.05)==0
    ii = ii+1;
end;
Toffset = ii;
% ���û���ҵ�ƽ̹�ĵط�����������������
if ii == findmark+0.5*fs
    ii = maxflueI+0.06*fs;
    while ii < findmark+0.5*fs &&  isocheck(x,ii,0.08*fs,0.1)==0
        ii = ii+1;
    end;
    Toffset = ii;
end

% ��ǰ��ƽ̹�ĵط���
ii = maxflueI-0.06*fs;
while ii > findmark+0.1*fs &&  isocheck(x,ii,0.08*fs,0.05)==0
    ii = ii-1;
end;
Tonset = ii;
%��������������
if ii == findmark+0.1*fs
    ii = maxflueI-0.06*fs;
    while ii > findmark+0.1*fs &&  isocheck(x,ii,0.04*fs,0.05)==0
        ii = ii-1;
    end;
    Tonset = ii;
end


z = (x(Toffset)+x(Tonset))/2;
[a ,b ] = max(abs(x(Tonset:Toffset)-z));
Tpos = Tonset+b-1;

% figure;plot(x); hold on;plot([Tpos,Toffset],x([Tpos,Toffset]),'.r');