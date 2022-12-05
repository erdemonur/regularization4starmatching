%% extract features from a set of stars already obtained within a specific region
function [feat] = extractFeat(stars,fov,magshift) %FOV = [x,y,width,height]
% feat = [n,meanA,meanr,meanTheta,stdA,stdr];
if ~isnan(stars(1,:))
    n = size(stars,1); % number of stars
else
    n=0;
end

mag = zeros(size(stars,1),1);
mag(:,1) = stars(:,4);
mag(:,1)=magshift+mag(:,1); % shift mag upward to make min element zero

meanA = mean(mag)-magshift; % mean of magnitude 
stdA = std(mag); % standard deviation of magnitude

middle = [fov(1,1)+fov(1,3)/2, fov(1,2)+fov(1,4)/2]; % middle point

r = zeros(size(stars,1),1);
theta = zeros(size(stars,1),1);
coors = zeros(size(stars,1),2);
for i=1:size(stars,1)
    if fov(1,1)+fov(1,3) <= 360 && fov(1,2)+fov(1,4) <= 90 && fov(1,2) >= -90
		ra = stars(i,2);
		dec = stars(i,3);
    elseif fov(1,1)+fov(1,3) > 360 && fov(1,2)+fov(1,4) <= 90 && fov(1,2) >= -90
        if stars(i,2) < mod(fov(1,1)+fov(1,3),360)
            ra = stars(i,2)+360;
            dec = stars(i,3);
        else
            ra = stars(i,2);
            dec = stars(i,3);
        end
    elseif fov(1,1)+fov(1,3) <= 360 && fov(1,2) < -90
        if (stars(i,2)>mod(fov(1,1)+180,360) && stars(i,2)<mod(fov(1,1)+180,360)+fov(1,3)) ...
                || stars(i,2)<mod(fov(1,1)+180+fov(1,3),360) %|| (stars(i,2)>mod(fov(1,1)+180,360) 
            ra = mod(stars(i,2)-180,360);
            dec = stars(i,3)-abs(fov(1,2)-(-90));
        else
            ra = stars(i,2);
            dec = stars(i,3);
        end
    elseif fov(1,1)+fov(1,3) <= 360 && fov(1,2)+fov(1,4) > 90
        if (stars(i,2)>mod(fov(1,1)+180,360) && stars(i,2)<mod(fov(1,1)+180,360)+fov(1,3)) ...
				|| stars(i,2)<mod(fov(1,1)+180+fov(1,3),360) %|| (stars(i,2)>mod(fov(1,1)+180,360) 
            ra = mod(stars(i,2)-180,360);
            dec = stars(i,3)+abs(fov(1,2)+fov(1,4)-90);
        else
            ra = stars(i,2);
            dec = stars(i,3);
        end
    elseif fov(1,1)+fov(1,3) > 360 && fov(1,2) < -90
        if stars(i,2) < mod(fov(1,1)+fov(1,3),360)
            ra = stars(i,2)+360;
            dec = stars(i,3);
        elseif (stars(i,2)>mod(fov(1,1)+180,360) && stars(i,2)<mod(fov(1,1)+180,360)+fov(1,3))
            ra = mod(stars(i,2)-180,360);
            dec = stars(i,3)-abs(fov(1,2)-(-90));
        else
            ra = stars(i,2);
            dec = stars(i,3);
        end
	elseif fov(1,1)+fov(1,3) > 360 && fov(1,2)+fov(1,4) > 90
		if stars(i,2) < mod(fov(1,1)+fov(1,3),360)
			ra = stars(i,2)+360;
			dec = stars(i,3);
		elseif (stars(i,2)>mod(fov(1,1)+180,360) && stars(i,2)<mod(fov(1,1)+180,360)+fov(1,3))
            ra = mod(stars(i,2)-180,360);
            dec = stars(i,3)+abs(fov(1,2)+fov(1,4)-90);
		else
			ra = stars(i,2);
			dec = stars(i,3);
		end
    end
    r(i,1) = ( (ra-middle(1,1))^2 + (dec-middle(1,2))^2 )^0.5; % radius of star i
    coors(i,1) = ra; % col of star i
    coors(i,2) = dec; % row of star i
    theta(i,1) = calcArgument([ra,dec],middle); % argument of star i
end

meanra = sum(coors(:,1).*mag(:,1))/sum(mag(:,1)); % ra of weighted mean object
meandec = sum(coors(:,2).*mag(:,1))/sum(mag(:,1)); % dec of weighted mean object
meanr = ( (meanra-middle(1,1))^2 + (meandec-middle(1,2))^2 )^0.5; % r of weighted mean object
meanTheta = calcArgument([meanra,meandec],middle); % theta of weighted mean object
stdr = std(r(:,1)); % std of r
feat = [n,meanA,meanr,meanTheta,stdA,stdr];

end