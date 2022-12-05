%% magnitude threshold for starset
function [newHipp] = applyMagThreshold(Hipp,lowerbound,upperbound)
k=1;
for i=1:size(Hipp,1)
    if Hipp(i,4) > lowerbound && Hipp(i,4) < upperbound
        newHipp(k,:) = Hipp(i,:);
        k = k+1;
    end
end

end