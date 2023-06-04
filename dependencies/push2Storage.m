function [status] = push2Storage(dir2move,moveLocation)

timeout = 1000;

tic

exit = false;

status = movefile(dir2move,moveLocation,'f');

while toc < 10

end

% 
% while ~exit
% 
%     if ~exist(dir2move, 'dir') || toc>timeout
%         exit = true;
%     end
% end

end