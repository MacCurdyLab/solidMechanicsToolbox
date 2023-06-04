function [F] = patchRemoveDuplicateFaces(F)

%sort in 2 direction, store to a new matrix to preserve normals
F2 = sort(F,2);

%figure out if any faces have the same vertex entries
[uF,I,J] = unique(F2, 'rows', 'first');

%keep only the non-duplicate rows
F = F(I,:);

end