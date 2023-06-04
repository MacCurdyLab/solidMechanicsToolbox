function [ind] = intensity2ind(raw,X)

    ind = zeros(size(raw));
    
    for i = 1:length(X)-1
        ind(raw>=X(i) & raw<=X(i+1)) = i;
    end

end

