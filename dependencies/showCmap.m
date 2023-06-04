function [] = showCmap(C)

figure
for i = 1:size(C,1)
    rectangle('Position',[i 0 1 1],'FaceColor',C(i,:),'EdgeColor','none')
    text(0.5+i,1,sprintf('%s\n %1.3f %d\n %1.3f %d\n %1.3f %d\n',rgb2hex(C(i,:)),[C(i,:); 255*C(i,:)]),...
        'FontSize',12,'fontname','corbel','HorizontalAlignment','center','VerticalAlignment','bottom')
    hold on
end
set(gcf,'position',[15 200 1880 400])
set(gca,'visible','off','Position',[0.02 0.05 0.96 0.9])
axis equal
end