function tickLocs = tickLocations(ymax)

scale = 10^floor(log10(ymax))

if (ymax/scale)<1.5
	jump = scale/4;
elseif (ymax/scale)<2
  	jump = scale/2;
elseif (ymax/scale)<5
    jump = scale;
else
    jump = scale * 2.5;
end

tickLocs = 0:jump:ymax;
