%% This a function of embed Graphical engine used optionally in simulator D2DSS
% It is responsable for plotting static graphicals structures of soccer field
% Central circle, goals lines, mid lines of field with aspects defined for parameters
% function showField(placarA,placarB,Nx,Ny,tempo,rgbImage)
%%
function showField(placarA,placarB,Nx,Ny,tempo,rgbImage)
    gcf
    %Drawing field in plot 2d
    subplot(6,5,[6,30]);
    imshow(rgbImage,'XData',[0+.15 3*Nx],'YData',[0+.35 3*Ny]);
    axis on;grid on;
    xlim([0 Nx*3]);
    ylim([0 Ny*3]);

    set(gca,'XTick',3:3:Nx*3);
    set(gca,'YTick',3:3:Ny*3);
    set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
    set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
    
    %Central mid circle plot
    hold on;
    numPoints=100;
    radius=2.5;
    theta=linspace(0,5*pi,numPoints);
    rho=ones(1,numPoints)*radius;
    [X,Y] = pol2cart(theta,rho); %circular function

    plot(X+Nx/2*3,Y+Ny/2*3,'k-','linewidth',2);

    %Central line in mid field
    line([Nx/2*3,Nx/2*3],[-1,size(rgbImage,1)]+1,'Color','k');

    %Goals areas

    golA=rectangle('position',[0 (floor(Ny/2)*3-3) 3 9],'LineWidth',2);
    set(golA,'FaceColor',[0.7,0.7,0.7]);
    golB=rectangle('position',[Nx*3-3 (floor(Ny/2)*3-3) 3 9],'LineWidth',2);
    set(golB,'FaceColor',[0.3,0.3,0.3]);
    hold off;    
end
