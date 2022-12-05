%% extract a single FOV region and obtain feature vector
function [testFeat,timeFeat] = extractTestFeat(FOV,maglow,magup,partial,rotationangle,...
flag_noise_pos,flag_noise_mag,flag_falsestar,flag_missingstar,noise_pos,noise_mag,falsestar,missingstar,Hipp)
% noise_pos = [mura,mudec,stdra,stddec], noise_mag = [mumag,stdevmag]
% falsestar = number, missingstar = number

magshift=abs(min(Hipp.data(:,4))); % to shift mags upward
magHipp = applyMagThreshold(Hipp.data,maglow,magup);
stars = pickStarsfromDatabase(FOV,magHipp,partial);
skypatch = struct('starset',{stars});
for i=1:size(skypatch,2)
    for j=1:size(skypatch(i).starset,1)
        x_shift = skypatch(i).starset(j,2) - (FOV(1,1)+FOV(1,3)/2);
        y_shift = skypatch(i).starset(j,3) - (FOV(1,2)+FOV(1,4)/2);
        x_rot = x_shift*cosd(rotationangle) - y_shift*sind(rotationangle);
        y_rot = x_shift*sind(rotationangle) + y_shift*cosd(rotationangle);
        skypatch(i).starset(j,2) = x_rot + (FOV(1,1)+FOV(1,3)/2);
        skypatch(i).starset(j,3) = y_rot + (FOV(1,2)+FOV(1,4)/2);
        if flag_noise_pos == true
            dra = normrnd(noise_pos(1,1),noise_pos(1,3)); % shift along ra axis normal distribution
            ddec = normrnd(noise_pos(1,2),noise_pos(1,4)); % shift along dec axis
            skypatch(i).starset(j,2) = skypatch(i).starset(j,2) + dra;
            skypatch(i).starset(j,3) = skypatch(i).starset(j,3) + ddec;
        end
        if flag_noise_mag == true
            a = normrnd(noise_mag(1,1),noise_mag(1,2)); % add magnitude normal distribution
            skypatch(i).starset(j,3) = skypatch(i).starset(j,3) + a;
        end
    end
    if flag_falsestar == true
        fra=zeros(falsestar,1);fdec=zeros(falsestar,1);fmag=zeros(falsestar,1);
        for k=1:falsestar
            fra(k,1) = unifrnd(FOV(1,1),FOV(1,1)+FOV(1,3)); % add false star unifor distribution within FoV
            fdec(k,1) = unifrnd(FOV(1,2),FOV(1,2)+FOV(1,4));
            fmag(k,1) = unifrnd(maglow,magup); % add false star magnitude
            skypatch(i).starset(size(skypatch(i).starset,1)+1,1) = -k;
            skypatch(i).starset(size(skypatch(i).starset,1),2) = fra(k);
            skypatch(i).starset(size(skypatch(i).starset,1),3) = fdec(k);            
            skypatch(i).starset(size(skypatch(i).starset,1),4) = fmag(k);
        end
    end
    if flag_missingstar == true
        missingindex=zeros(missingstar,1);
        for k=1:missingstar
            missingindex(k,1) = unifrnd(1,size(skypatch(i).starset,1));
            if size(skypatch(i).starset,1) > 1
                skypatch(i).starset(k,:) = [];
            end
        end
    end
end
tic
testFeat = extractFeat(skypatch.starset,FOV,magshift);
timeFeat = toc;
end