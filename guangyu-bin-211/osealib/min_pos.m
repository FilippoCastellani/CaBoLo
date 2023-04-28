function [val, pos ] = min_pos(x,istart,iend)
[a ,b ] = min(x(istart:iend));
val = a;
pos = istart +b -1;