function [OriginCount,IrrEv,PACEv,AnisotropyEv,DensityEv,RegularityEv] = get_AFEv_metrics( dRR, XYedges, debug , visuals)

%  This function:

%  1) Takes the dRR intervals series and build a 2D
%     histogram of {dRR(i),dRR(i-1)};
%  2) The histogram is marked with 13 segments;
%  3) The number of non empty bins ( BinCountX=BPX ) and the
%     number of {dRR(i),dRR(i-1)} ( PointCountX=PCX ) are computed, 
%     for each segment;
%  4) BPX and PCX are used to extract the metrics: IrregularityEvidence(IrrEv)
%     and PACEvidence (PACEv)
%
%  Detailed explanation
%  INPUTS
%  dRR:  Delta RR series (column vector)
%
%  OUTPUTS
%  OriginCount:  Number of points in the bin containing the Origin
%  IrrEv:        Irregularity Evidence
%  PACEv:        PAC Evidence
%
%  The 2D histogram of the {dRR(i),dRR(i-1)} values is built using 30*30
%  bins corresponding to a binSize=0.04 s:
%       x axis variable -> actual dRR interval
%       y axis variable -> previous dRR interval
%
%  The histogram is marked with 13 segments (0,..,12).
%  For each segment:
%
%      BinCountX=  number of non empty bins in the Xth segment
%      PointCountX= number of {dRR(i),dRR(i-1)} in the Xth segment
%
%  are computed.


% dRR={dRR(i),dRR(i-1)}
dRR=[dRR(2:length(dRR),1) dRR(1:length(dRR)-1,1)];
% COMPUTE OriginCount
OCmask=0.02;
os=sum(abs(dRR)<=OCmask,2);
OriginCount=sum(os==2);

% DELETE OUTLIERS |dRR|>=1.5
OLmask=1.5;
dRRnew=[];
j=1;
for i=1:size(dRR,1)
    if sum(abs(dRR(i,:))>=OLmask)==0
        dRRnew(j,:)=dRR(i,:);
        j=j+1;
    end
end
if size(dRRnew)==0
    dRRnew = [0 0];
end


% BUILD HISTOGRAM


% Three dimensional histogram of bivariate data 
if(visuals)
% Specify bin centers of the histogram
bin_c=-0.58:0.04:0.58;
    hist3(dRRnew,'Edges', {bin_c, bin_c}, 'CDataMode','auto','FaceColor','interp');
end

[N] = histcounts2(dRRnew(:,1),dRRnew(:,2),XYedges,XYedges);
Z=N;                
if debug>0
    figure(debug);
    clf;
    hist3(dRRnew,'Edges', {XYedges,XYedges},'CDataMode','auto','FaceColor','interp');
    grid on;
end

N_length = length(N);
N1 = N_length/2;
N0 = N1-1;
N2 = N1+1;
N3 = N1+2;
Nend = N_length;

% COMPUTE POINT COUNT ZERO
%O1=sum(sum(Z(14,15:16)));
%O2=sum(sum(Z(15:16,14:17)));
%O3=sum(sum(Z(17,15:16)));
%PC0=O1+O2+O3;

% Clear SegmentZero
Z(N0,N1:N2)=0;
Z(N1:N2,N0:N3)=0;
Z(N3,N1:N2)=0;

 [X,Y]=meshgrid(XYedges(1:end-1), XYedges(1:end-1));
 surf(X,Y, Z);
 axis tight
 xlabel('dRR(i-1)')
 ylabel('dRR(i)')

%COMPUTE BinCount12 
%COMPUTE PointCount12 

% Z2 contains all the bins belonging to the II quadrant of Z
Z2=Z(N2:Nend,N2:Nend);
[BC12,PC12,sZ2] = BPcount( Z2 );
Z(N2:Nend,N2:Nend)=sZ2;

%COMPUTE BinCount11 
%COMPUTE PointCount11 

%Z3 cointains points belonging to the III quadrant of Z
Z3=Z(N2:Nend,1:N1);
Z3=fliplr(Z3);
[BC11,PC11,sZ3] = BPcount( Z3 ); 
Z(N2:Nend,1:N1)=fliplr(sZ3);

%COMPUTE BinCount10 
%COMPUTE PointCount10  

%Z4 cointains points belonging to the IV quadrant of Z
Z4=Z(1:N1,1:N1);
[BC10,PC10,sZ4] = BPcount( Z4 ); 
Z(1:N1,1:N1)=sZ4;

%COMPUTE BinCount9
%COMPUTE PointCount9
 
%Z1 cointains points belonging to the I quadrant of Z
Z1=Z(1:N1,N2:Nend);
Z1=fliplr(Z1);
[BC9,PC9,sZ1] = BPcount( Z1 );
Z(1:N1,N2:Nend)=fliplr(sZ1);

%COMPUTE BinCount5
BC5=sum(sum(Z(1:N1,N0:N3)~=0));
%COMPUTE PointCount5
PC5=sum(sum(Z(1:N1,N0:N3)));

%COMPUTE BinCount7
BC7=sum(sum(Z(N2:Nend,N0:N3)~=0));
%COMPUTE PointCount7
PC7=sum(sum(Z(N2:Nend,N0:N3)));

%COMPUTE BinCount6
BC6=sum(sum(Z(N0:N3,1:N1)~=0));
%Compute PointCount6
PC6=sum(sum(Z(N0:N3,1:N1)));

%COMPUTE BinCount8
BC8=sum(sum(Z(N0:N3,N2:Nend)~=0));
%COMPUTE PointCount8
PC8=sum(sum(Z(N0:N3,N2:Nend)));

% CLEAR SEGMENTS 5, 6, 7, 8

% Clear segments 6 and 8
Z(N0:N3,:)=0;
%Clear segments 5 and 7
Z(:,N0:N3)=0;

% COMPUTE BinCount2
BC2=sum(sum(Z(1:N0-1,1:N0-1)~=0));
% COMPUTE PointCount2
PC2=sum(sum(Z(1:N0-1,1:N0-1)));

% COMPUTE BinCount1
BC1=sum(sum(Z(1:N0-1,N3+1:Nend)~=0));
% COMPUTE PointCount1
PC1=sum(sum(Z(1:N0-1,N3+1:Nend)));

% COMPUTE BinCount3
BC3=sum(sum(Z(N3+1:Nend,1:N0-1)~=0));
%COMPUTE PointCount3
PC3=sum(sum(Z(N3+1:Nend,1:N0-1)));

% COMPUTE BinCount4
BC4=sum(sum(Z(N3+1:Nend,N3+1:Nend)~=0));
% COMPUTE PointCount4
PC4=sum(sum(Z(N3+1:Nend,N3+1:Nend)));


% COMPUTE IrregularityEvidence
IrrEv=BC1+BC2+BC3+BC4+...
           BC5+BC6+BC7+BC8+...
                BC9+BC10+BC11+BC12;

% COMPUTE PACEvidence
PACEv=(PC1-BC1)+(PC2-BC2)+(PC3-BC3)+(PC4-BC4)+...
                     (PC5-BC5)+(PC6-BC6)+(PC10-BC10)-...
                         (PC7-BC7)-(PC8-BC8)-(PC12-BC12);
                     
% COMPUTE AnisotropyEv
AnisotropyEv = abs((PC9+PC11) - (PC10+PC12))+...
                abs((PC6+PC7) - (PC5+PC8));
            
% COMPUTE  DensityEv       
DensityEv = (PC5-BC5)+(PC6-BC6)+(PC7-BC7)+(PC8-BC8)+...
            (PC9-BC9)+(PC10-BC10)+(PC11-BC11)+(PC12-BC12);

% COMPUTE RegularityEv
RegularityEv = 0;

end