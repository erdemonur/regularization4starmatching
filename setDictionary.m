%% generate dictionary
function [dictionary,idx] = setDictionary(feats,FOV,overlap,index)
% first element at top left, ninth element at bottom right, most 
% significant in the middle (5th)
% FOV = [ra,dec] of camera, index = closest feat
dictionary = zeros(9,size(feats,2));
idx = zeros(9,1);
linera = ceil(360/(FOV(1,1)*(1-overlap))); % a full row along ra
linedec = ceil(180/(FOV(1,2)*(1-overlap))); % a full row along dec
if (mod(index,linera)~=1 && mod(index,linera)~=0) && ...
        (index-linera>0 && index+linera<=size(feats,1)) % if index not at edge
    dictionary(1,:) = feats(index -1 -linera,:); % top left
    dictionary(2,:) = feats(index -linera,:); % top
    dictionary(3,:) = feats(index +1 -linera,:); % top right
    dictionary(4,:) = feats(index -1,:); % left middle
    dictionary(5,:) = feats(index,:); % middle
    dictionary(6,:) = feats(index +1,:); % right middle
    dictionary(7,:) = feats(index -1 +linera,:); % left bottom
    dictionary(8,:) = feats(index +linera,:); % bottom
    dictionary(9,:) = feats(index +1 +linera,:); % right bottom
    idx(1,1) = index -1 -linera;
	idx(2,1) = index -linera;
    idx(3,1) = index +1 -linera;	
	idx(4,1) = index -1;	
    idx(5,1) = index;	
	idx(6,1) = index +1;	
    idx(7,1) = index -1 +linera;	
	idx(8,1) = index +linera;	
    idx(9,1) = index +1 +linera;		
elseif (mod(index,linera)==1 && mod(index,linera)~=0) && ...
        (index-linera<=0 && index+linera<=size(feats,1)) % if index at left top
    dictionary(1,:) = feats(index -1+linera -linera+size(feats,1),:); % top left on edge
    dictionary(2,:) = feats(index -linera+size(feats,1),:); % top on edge
    dictionary(3,:) = feats(index +1 -linera+size(feats,1),:); % top right on edge
    dictionary(4,:) = feats(index-1+linera,:); % middle left on edge
    dictionary(5,:) = feats(index,:); % middle
    dictionary(6,:) = feats(index+1,:); % middle right
    dictionary(7,:) = feats(index-1+linera+linera,:); % left bottom on edge
    dictionary(8,:) = feats(index+linera,:); % bottom 
    dictionary(9,:) = feats(index+1+linera,:); % bottom right
    idx(1,1) = index -1+linera -linera+size(feats,1);	
	idx(2,1) = index -linera+size(feats,1); 
    idx(3,1) = index +1 -linera+size(feats,1);
	idx(4,1) = index-1+linera;
    idx(5,1) = index;
	idx(6,1) = index+1;
    idx(7,1) = index-1+linera+linera;	
	idx(8,1) = index+linera; 	
    idx(9,1) = index+1+linera;	
elseif (mod(index,linera)~=1 && mod(index,linera)~=0) && ...
        (index-linera<=0 && index+linera<=size(feats,1)) % if index at top
    dictionary(1,:) = feats(index -1 -linera+size(feats,1),:); % top left on edge
    dictionary(2,:) = feats(index -linera+size(feats,1),:); % top on edge
    dictionary(3,:) = feats(index +1 -linera+size(feats,1),:); % top right on edge
    dictionary(4,:) = feats(index -1,:); % left middle
    dictionary(5,:) = feats(index,:); % middle
    dictionary(6,:) = feats(index +1,:); % right middle
    dictionary(7,:) = feats(index -1 +linera,:); % left bottom
    dictionary(8,:) = feats(index +linera,:); % bottom
    dictionary(9,:) = feats(index +1 +linera,:); % right bottom
    idx(1,1) = index -1 -linera+size(feats,1);
	idx(2,1) = index -linera+size(feats,1);  
    idx(3,1) = index +1 -linera+size(feats,1);
	idx(4,1) = index -1;
    idx(5,1) = index;
	idx(6,1) = index +1;
    idx(7,1) = index -1 +linera;
	idx(8,1) = index +linera;
    idx(9,1) = index +1 +linera;
elseif (mod(index,linera)~=1 && mod(index,linera)==0) && ...
        (index-linera<=0 && index+linera<=size(feats,1)) % if index at top right
    dictionary(1,:) = feats(index -1 -linera+size(feats,1),:); % top left on edge
    dictionary(2,:) = feats(index -linera+size(feats,1),:); % top on edge
    dictionary(3,:) = feats(index +1 -linera+size(feats,1)-linera,:); % top right on edge
    dictionary(4,:) = feats(index -1,:); % left middle
    dictionary(5,:) = feats(index,:); % middle
    dictionary(6,:) = feats(index +1-linera,:); % right middle on edge
    dictionary(7,:) = feats(index -1 +linera,:); % left bottom
    dictionary(8,:) = feats(index +linera,:); % bottom
    dictionary(9,:) = feats(index +1-linera +linera,:); % right bottom on edge
    idx(1,1) = 	index -1 -linera+size(feats,1);
	idx(2,1) = 	index -linera+size(feats,1); 
    idx(3,1) = 	index +1 -linera+size(feats,1)-linera;
	idx(4,1) = 	index -1;
    idx(5,1) = 	index;
	idx(6,1) = 	index +1-linera;
    idx(7,1) = 	index -1 +linera;
	idx(8,1) = 	index +linera;
    idx(9,1) = 	index +1-linera +linera;
elseif (mod(index,linera)==1 && mod(index,linera)~=0) && ...
        (index-linera>0 && index+linera<=size(feats,1)) % if index at left
    dictionary(1,:) = feats(index -1+linera -linera,:); % top left on edge
    dictionary(2,:) = feats(index -linera,:); % top
    dictionary(3,:) = feats(index +1 -linera,:); % top right
    dictionary(4,:) = feats(index -1+linera,:); % left middle on edge
    dictionary(5,:) = feats(index,:); % middle
    dictionary(6,:) = feats(index +1,:); % right middle
    dictionary(7,:) = feats(index -1+linera +linera,:); % left bottom on edge
    dictionary(8,:) = feats(index +linera,:); % bottom
    dictionary(9,:) = feats(index +1 +linera,:); % right bottom
    idx(1,1) = 	index -1+linera -linera;
	idx(2,1) = 	index -linera;
    idx(3,1) = 	index +1 -linera;
	idx(4,1) = 	index -1+linera;
    idx(5,1) = 	index;
	idx(6,1) = 	index +1;
    idx(7,1) = 	index -1+linera +linera;
	idx(8,1) = 	index +linera;
    idx(9,1) = 	index +1 +linera;
elseif (mod(index,linera)~=1 && mod(index,linera)==0) && ...
        (index-linera>0 && index+linera<=size(feats,1)) % if index at right
    dictionary(1,:) = feats(index -1 -linera,:); % top left
    dictionary(2,:) = feats(index -linera,:); % top
    dictionary(3,:) = feats(index +1-linera -linera,:); % top right on edge
    dictionary(4,:) = feats(index -1,:); % left middle
    dictionary(5,:) = feats(index,:); % middle
    dictionary(6,:) = feats(index +1-linera,:); % right middle on edge
    dictionary(7,:) = feats(index -1 +linera,:); % left bottom
    dictionary(8,:) = feats(index +linera,:); % bottom
    dictionary(9,:) = feats(index +1-linera +linera,:); % right bottom on edge
    idx(1,1) = 	index -1 -linera; 
	idx(2,1) = 	index -linera;
    idx(3,1) = 	index +1-linera -linera;
	idx(4,1) = 	index -1;
    idx(5,1) = 	index;
	idx(6,1) = 	index +1-linera;
    idx(7,1) = 	index -1 +linera;
	idx(8,1) = 	index +linera;
    idx(9,1) = 	index +1-linera +linera;
elseif (mod(index,linera)==1 && mod(index,linera)~=0) && ...
        (index-linera>0 && index+linera>size(feats,1)) % if index at left bottom
    dictionary(1,:) = feats(index -1+linera -linera,:); % top left on edge
    dictionary(2,:) = feats(index -linera,:); % top
    dictionary(3,:) = feats(index +1 -linera,:); % top right
    dictionary(4,:) = feats(index -1+linera,:); % left middle on edge
    dictionary(5,:) = feats(index,:); % middle
    dictionary(6,:) = feats(index +1,:); % right middle
    dictionary(7,:) = feats(index -1+linera +linera-size(feats,1),:); % left bottom on edge
    dictionary(8,:) = feats(index +linera-size(feats,1),:); % bottom on edge
    dictionary(9,:) = feats(index +1 +linera-size(feats,1),:); % right bottom on edge
    idx(1,1) = 	index -1+linera -linera; 
	idx(2,1) = 	index -linera;
    idx(3,1) = 	index +1 -linera;
	idx(4,1) = 	index -1+linera;
    idx(5,1) = 	index;
	idx(6,1) = 	index +1;
    idx(7,1) = 	index -1+linera +linera-size(feats,1);
	idx(8,1) = 	index +linera-size(feats,1);
    idx(9,1) = 	index +1 +linera-size(feats,1);
elseif (mod(index,linera)~=1 && mod(index,linera)~=0) && ...
        (index-linera>0 && index+linera>size(feats,1)) % if index at bottom
    dictionary(1,:) = feats(index -1 -linera,:); % top left
    dictionary(2,:) = feats(index -linera,:); % top
    dictionary(3,:) = feats(index +1 -linera,:); % top right
    dictionary(4,:) = feats(index -1,:); % left middle
    dictionary(5,:) = feats(index,:); % middle
    dictionary(6,:) = feats(index +1,:); % right middle
    dictionary(7,:) = feats(index -1 +linera-size(feats,1),:); % left bottom on edge
    dictionary(8,:) = feats(index +linera-size(feats,1),:); % bottom on edge
    dictionary(9,:) = feats(index +1 +linera-size(feats,1),:); % right bottom on edge
    idx(1,1) = 	index -1 -linera;
	idx(2,1) = 	index -linera;
    idx(3,1) = 	index +1 -linera;
	idx(4,1) = 	index -1;
    idx(5,1) = 	index;
	idx(6,1) = 	index +1;
    idx(7,1) = 	index -1 +linera-size(feats,1);
	idx(8,1) = 	index +linera-size(feats,1);
    idx(9,1) = 	index +1 +linera-size(feats,1);
elseif (mod(index,linera)~=1 && mod(index,linera)==0) && ...
        (index-linera>0 && index+linera>size(feats,1)) % if index at right bottom
    dictionary(1,:) = feats(index -1 -linera,:); % top left
    dictionary(2,:) = feats(index -linera,:); % top
    dictionary(3,:) = feats(index +1-linera -linera,:); % top right on edge
    dictionary(4,:) = feats(index -1,:); % left middle
    dictionary(5,:) = feats(index,:); % middle
    dictionary(6,:) = feats(index +1-linera,:); % right middle on edge
    dictionary(7,:) = feats(index -1 +linera-size(feats,1),:); % left bottom on edge
    dictionary(8,:) = feats(index +linera-size(feats,1),:); % bottom on edge
    dictionary(9,:) = feats(index +1 +linera-size(feats,1)+linera,:); % right bottom on edge
    idx(1,1) = 	index -1 -linera;
	idx(2,1) = 	index -linera;
    idx(3,1) = 	index +1-linera -linera;
	idx(4,1) = 	index -1;
    idx(5,1) = 	index;
	idx(6,1) = 	index +1-linera;
    idx(7,1) = 	index -1 +linera-size(feats,1);
	idx(8,1) = 	index +linera-size(feats,1);
    idx(9,1) = 	index +1 +linera-size(feats,1)+linera;
end

end