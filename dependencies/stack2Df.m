%support function for reading abaqus results
function out = stack3Df(U)
    %Reshape Displacements into 3D array
    ind = find(U(:,1) == U(1,1)); 
    
    if length(ind)==1
        out = U(:,2:7);
    else
        out = [];
        for i = 1:length(ind)-1
            out(:,:,i) = U(ind(i):ind(i+1)-1,2:7);
        end
        out(:,:,i+1) = U(ind(i+1):end,2:7);
    end
end