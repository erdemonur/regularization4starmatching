%% pick stars from database T given FOV interval (ra,dec)
% partial = true or false, if true --> partial
function [stars] = pickStarsfromDatabase(FOV,T,partial) %FOV(ra,dec,width,height)
stars = zeros(1,4);
k=1;
for i=1:size(T,1)
    if FOV(1,1)+FOV(1,3) <= 360 && FOV(1,2)+FOV(1,4) <= 90 && FOV(1,2) >= -90
        if T(i,2)>FOV(1,1) && T(i,2)<FOV(1,1)+FOV(1,3)
            if T(i,3)>FOV(1,2) && T(i,3)<FOV(1,2)+FOV(1,4)
                if partial == true % check if fall within ellipse
                    x = T(i,2);
                    y = T(i,3);                    
                    if ((x-(FOV(1,1)+FOV(1,3)/2))^2)/((FOV(1,3)/2)^2)...
                            +((y-(FOV(1,2)+FOV(1,4)/2))^2)/((FOV(1,4)/2)^2) < 1
                        stars(k,:) = T(i,:);
                        k=k+1;
                    end
                elseif partial == false
                    stars(k,:) = T(i,:);
                    k=k+1;
                end
            end
        end
    elseif FOV(1,1)+FOV(1,3) > 360 && FOV(1,2)+FOV(1,4) <= 90 && FOV(1,2) >= -90
        if T(i,2)>FOV(1,1) || T(i,2)<FOV(1,1)+FOV(1,3)-360
            if T(i,3)>FOV(1,2) && T(i,3)<FOV(1,2)+FOV(1,4)
                if partial == true
                    y = T(i,3);
                    if T(i,2)<FOV(1,1)+FOV(1,3)-360
                        x = T(i,2)+360;
                    else
                        x = T(i,2);
                    end
                    if ((x-(FOV(1,1)+FOV(1,3)/2))^2)/((FOV(1,3)/2)^2)...
                            +((y-(FOV(1,2)+FOV(1,4)/2))^2)/((FOV(1,4)/2)^2) < 1
                        stars(k,:) = T(i,:);
                        k=k+1;
                    end
                elseif partial == false
                    stars(k,:) = T(i,:);
                    k=k+1;
                end
            end
        end
    elseif FOV(1,1)+FOV(1,3) <= 360 && FOV(1,2) < -90
        if T(i,2)>FOV(1,1) && T(i,2)<FOV(1,1)+FOV(1,3)
            if T(i,3)<FOV(1,2)+FOV(1,4)
                if partial == true
                    x = T(i,2);
                    y = T(i,3);                    
                    if ((x-(FOV(1,1)+FOV(1,3)/2))^2)/((FOV(1,3)/2)^2)...
                            +((y-(FOV(1,2)+FOV(1,4)/2))^2)/((FOV(1,4)/2)^2) < 1
                        stars(k,:) = T(i,:);
                        k=k+1;
                    end
                elseif partial == false
                    stars(k,:) = T(i,:);
                    k=k+1;
                end
            end
        elseif (T(i,2)>mod(FOV(1,1)+180,360) && T(i,2)<mod(FOV(1,1)+180,360)+FOV(1,3)) ...
                || T(i,2)<mod(FOV(1,1)+180+FOV(1,3),360) %{|| (T(i,2)>mod(FOV(1,1)+180,360)
            if T(i,3)<-90+abs(FOV(1,2)-(-90))
                if partial == true
                    x = mod(T(i,2)-180,360); % shift 180 backwards
                    y = T(i,3)-abs(FOV(1,2)-(-90)); % shift by symmetry w.r.t. -90
                    if ((x-(FOV(1,1)+FOV(1,3)/2))^2)/((FOV(1,3)/2)^2)...
                            +((y-(FOV(1,2)+FOV(1,4)/2))^2)/((FOV(1,4)/2)^2) < 1
                        stars(k,:) = T(i,:);
                        k=k+1;
                    end
                elseif partial == false
                    stars(k,:) = T(i,:);
                    k=k+1;
                end
            end
        end
    elseif FOV(1,1)+FOV(1,3) <= 360 && FOV(1,2)+FOV(1,4) > 90
        if T(i,2)>FOV(1,1) && T(i,2)<FOV(1,1)+FOV(1,3)
            if T(i,3)>FOV(1,2)
                if partial == true
                    x = T(i,2);
                    y = T(i,3);                    
                    if ((x-(FOV(1,1)+FOV(1,3)/2))^2)/((FOV(1,3)/2)^2)...
                            +((y-(FOV(1,2)+FOV(1,4)/2))^2)/((FOV(1,4)/2)^2) < 1
                        stars(k,:) = T(i,:);
                        k=k+1;
                    end
                elseif partial == false
                    stars(k,:) = T(i,:);
                    k=k+1;
                end
            end
        elseif (T(i,2)>mod(FOV(1,1)+180,360) && T(i,2)<mod(FOV(1,1)+180,360)+FOV(1,3)) ...
                || T(i,2)<mod(FOV(1,1)+180+FOV(1,3),360) %|| (T(i,2)>mod(FOV(1,1)+180,360)
            if T(i,3)>90-abs(FOV(1,2)+FOV(1,4)-90)
                if partial == true
                    x = mod(T(i,2)-180,360); % shift 180 backwards
                    y = T(i,3)+abs(FOV(1,2)+FOV(1,4)-90); % shift by symmetry w.r.t. 90
                    if ((x-(FOV(1,1)+FOV(1,3)/2))^2)/((FOV(1,3)/2)^2)...
                            +((y-(FOV(1,2)+FOV(1,4)/2))^2)/((FOV(1,4)/2)^2) < 1
                        stars(k,:) = T(i,:);
                        k=k+1;
                    end
                elseif partial == false
                    stars(k,:) = T(i,:);
                    k=k+1;
                end
            end
        end
    elseif FOV(1,1)+FOV(1,3) > 360 && FOV(1,2) < -90
        if T(i,2)>FOV(1,1) || T(i,2)<FOV(1,1)+FOV(1,3)-360
            if T(i,3)<FOV(1,2)+FOV(1,4)
                if partial == true
                    y = T(i,3);
                    if T(i,2)<FOV(1,1)+FOV(1,3)-360
                        x = T(i,2)+360;
                    else
                        x = T(i,2);
                    end
                    if ((x-(FOV(1,1)+FOV(1,3)/2))^2)/((FOV(1,3)/2)^2)...
                            +((y-(FOV(1,2)+FOV(1,4)/2))^2)/((FOV(1,4)/2)^2) < 1
                        stars(k,:) = T(i,:);
                        k=k+1;
                    end
                elseif partial == false
                    stars(k,:) = T(i,:);
                    k=k+1;
                end
            end
        elseif T(i,2)>mod(FOV(1,1)+180,360) && T(i,2)<mod(FOV(1,1)+180+FOV(1,3),360)
            if T(i,3)<-90+abs(FOV(1,2)-(-90))
                if partial == true
                    x = T(i,2)-180 + 360; % shift 180 backwards !!!
                    y = T(i,3)-abs(FOV(1,2)-(-90)); % shift by symmetry w.r.t. -90
                    if ((x-(FOV(1,1)+FOV(1,3)/2))^2)/((FOV(1,3)/2)^2)...
                            +((y-(FOV(1,2)+FOV(1,4)/2))^2)/((FOV(1,4)/2)^2) < 1
                        stars(k,:) = T(i,:);
                        k=k+1;
                    end
                elseif partial == false
                    stars(k,:) = T(i,:);
                    k=k+1;
                end
            end
        end
    elseif FOV(1,1)+FOV(1,3) > 360 && FOV(1,2)+FOV(1,4) > 90
        if T(i,2)>FOV(1,1) || T(i,2)<FOV(1,1)+FOV(1,3)-360
            if T(i,3)>FOV(1,2)
                if partial == true
                    y = T(i,3);
                    if T(i,2)<FOV(1,1)+FOV(1,3)-360
                        x = T(i,2)+360;
                    else
                        x = T(i,2);
                    end
                    if ((x-(FOV(1,1)+FOV(1,3)/2))^2)/((FOV(1,3)/2)^2)...
                            +((y-(FOV(1,2)+FOV(1,4)/2))^2)/((FOV(1,4)/2)^2) < 1
                        stars(k,:) = T(i,:);
                        k=k+1;
                    end
                elseif partial == false
                    stars(k,:) = T(i,:);
                    k=k+1;
                end
            end
        elseif T(i,2)>mod(FOV(1,1)+180,360) && T(i,2)<mod(FOV(1,1)+180+FOV(1,3),360)
            if T(i,3)>90-abs(FOV(1,2)+FOV(1,4)-90)
                if partial == true
                    x = T(i,2)-180 + 360; % shift 180 backwards !!!
                    y = T(i,3)+abs(FOV(1,2)+FOV(1,4)-90); % shift by symmetry w.r.t. 90
                    if ((x-(FOV(1,1)+FOV(1,3)/2))^2)/((FOV(1,3)/2)^2)...
                            +((y-(FOV(1,2)+FOV(1,4)/2))^2)/((FOV(1,4)/2)^2) < 1
                        stars(k,:) = T(i,:);
                        k=k+1;
                    end
                elseif partial == false
                    stars(k,:) = T(i,:);
                    k=k+1;
                end
            end
        end
    end
    if k==1
        stars(k,:) = NaN;
    end        
end
end