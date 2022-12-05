%% scan whole sky to extract ergions of FOVs
function [FOVs] = extractRegionsfromSky(xFov,yFov,overlapRatio,overflow)
rem = 1;c=0;
while rem > 0 % to find y0
    rem = rem - (1-overlapRatio);
    c = c+1;
end
FOVs = zeros(1,4);
x0=0;y0=-90-(c-1)*(1-overlapRatio)*yFov;k=1;
xf=360;yf=90;
for i=y0:yFov*(1-overlapRatio):yf
    for j=x0:xFov*(1-overlapRatio):xf
        if i~=yf && j~=xf
            FOVs(k,:)=[j,i,xFov,yFov]; % x(ra),y(dec),xfov,yfov
            k=k+1;
        end
    end
end

if overflow == false
    indices = [];
    for i=1:size(FOVs,1)
        if FOVs(i,2) < -90 || FOVs(i,2)+yFov > 90
            indices = [indices,i];
        end
    end
    FOVs(indices',:)=[];
end

end