% //Authors: 	Gari D Clifford - 
% //            Roberta Colloca -
% //			Julien Oster	-

function [BC,PC,sZ] = BPcount( sZ )

% BPcount counts the number of non empty bins (BC) in the matrix Z and
% the number of {dRR(i),dRR(i-1)} in the same region (PC) and deletes
% the counted points from the matrix Z


%bdc is the BIN diagonal count: number of non empty bins contained in
%the i-th diagonal of Z
bdc=0;
BC=0;
%pdc is the POINTS diagonal count: number of {dRR(i),dRR(i-1)} contained in
%the i-th diagonal of Z
pdc=0;
PC=0;

for i=-2:2
     bdc=sum(diag(sZ,i)~=0);
     pdc=sum(diag(sZ,i));
     BC=BC+bdc;
     PC=PC+pdc;
     sZ=sZ-diag(diag(sZ,i),i);
 end


end
