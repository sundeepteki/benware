function tickLocations = tickLocations(ymax)

scale = 10^floor(log10(ymax));

if (ymax/scale)<=2
	jump = scale/2;
elseif (ymax/scale)<5
    jump = scale;
else
    jump = scale * 2;
end

tickLocations = 0:jump:ymax;
