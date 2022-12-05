%% calculate argument
function theta = calcArgument(coors,origin)

theta = atand( abs(coors(1,2)-origin(1,2))/abs(coors(1,1)-origin(1,1)) );
if coors(1,1)-origin(1,1)>=0 && coors(1,2)-origin(1,2)>=0
    theta = theta;
elseif coors(1,1)-origin(1,1)<=0 && coors(1,2)-origin(1,2)>=0
    theta = 180-theta;
elseif coors(1,1)-origin(1,1)<=0 && coors(1,2)-origin(1,2)<=0
    theta = 180+theta;
elseif coors(1,1)-origin(1,1)>=0 && coors(1,2)-origin(1,2)<=0
    theta = 360-theta;
end

end