function showField(placarA,placarB,Nx,Ny,tempo,rgbImage)
    gcf
    annotation('textbox',...
    [0 0 1 1],...
    'String',{strcat('Placar: ',num2str(placarA),'X',num2str(placarB)),[strcat(num2str(tempo),' interacoes')]},...
    'FontSize',14,...
    'FontName','Arial',...
    'Tag' , 'somethingUnique',...
    'Color',[1 1 1]);

    subplot(6,5,3);
    s=imshow(A2);
    set(s, 'AlphaData', alpha2);

    %PARTE DO CAMPO
    subplot(6,5,[6,30]);
    imshow(rgbImage,'XData',[0+.15 3*Nx],'YData',[0+.35 3*Ny]);
    axis on;grid on;
    xlim([0 Nx*3]);
    ylim([0 Ny*3]);

    set(gca,'XTick',3:3:Nx*3);
    set(gca,'YTick',3:3:Ny*3);
    set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
    set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);

    %% Projeta os graficos em cima da matriz (circulo central, pequena area e gols)
    
    %CIRCULO CENTRAL
    hold on;
    numPoints=100;
    radius=2.5;
    theta=linspace(0,5*pi,numPoints);
    rho=ones(1,numPoints)*radius;
    [X,Y] = pol2cart(theta,rho); %funcao circular

    plot(X+Nx/2*3,Y+Ny/2*3,'k-','linewidth',2);

    %LINHA CENTRAL   
    line([Nx/2*3,Nx/2*3],[-1,size(rgbImage,1)]+1,'Color','k');

    %AREAS DOS GOLS

    golA=rectangle('position',[0 (floor(Ny/2)*3-3) 3 9],'LineWidth',2);
    set(golA,'FaceColor',[0.7,0.7,0.7]);
    golB=rectangle('position',[Nx*3-3 (floor(Ny/2)*3-3) 3 9],'LineWidth',2);
    set(golB,'FaceColor',[0.3,0.3,0.3]);
    hold off;    
end
