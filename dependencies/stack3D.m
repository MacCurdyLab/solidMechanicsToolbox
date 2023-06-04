%support function for reading abaqus results
function [out,idV] = stack3D(U)

    %Reshape Displacements into 3D array
    ind = find(U(:,1) == U(1,1)); 

    idV = U(1:ind(2)-1,1);
    
    if length(ind)==1
        out = U(:,2:4);
    else
        out = [];
        for i = 1:length(ind)-1
            out(:,:,i) = U(ind(i):ind(i+1)-1,2:4);
        end
        out(:,:,i+1) = U(ind(i+1):end,2:4);
    end
end