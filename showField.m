function showField(placarA,placarB,Nx,Ny,tempo,rgbImage)
    %% Carregamento de imagens e texto do HEADER
    
    % [A1, map1, alpha1];
%     txtplacar = vision.TextInserter(strcat('Placar: ',num2str(placarA),'X',num2str(placarB))); %VALDINEI
%     txtplacar.Color = [255, 255, 255];
%     txtplacar.FontSize = 36;
%     txtplacar.Location = [75 10];
%     combplacar = step(textplacar, A1);      %VALDINEI
    
    
   % [A2, map2, alpha2];
    
   % [A3, map3, alpha3];
%     txtcount = vision.TextInserter(strcat(num2str(tempo),' intera��es')); %VALDINEI
%     txtcount.Color = [255, 255, 255];
%     txtcount.FontSize = 36;
%     txtcount.Location = [20 10];
%    combtempo = step(txtcount, A3); %VALDINEI

    %% Secoes do HEADER
    
    %PARTE IMPROVISADA
    gcf
%    delete(findall(gcf,'Tag','somethingUnique'));
    annotation('textbox',...
    [0 0 1 1],...
    'String',{strcat('Placar: ',num2str(placarA),'X',num2str(placarB)),[strcat(num2str(tempo),' interacoes')]},...
    'FontSize',14,...
    'FontName','Arial',...
    'Tag' , 'somethingUnique',...
    'Color',[1 1 1]); %PEDRO 
    
    %PARTE DO PLACAR
%     subplot(6,5,[1,2]);
%     r=imshow(combplacar); %VALDINEI
%     set(r, 'AlphaData', alpha1); %VALDINEI
    
    %PARTE DA BOLA (LOGO)
    subplot(6,5,3);
    s=imshow(A2);
    set(s, 'AlphaData', alpha2); %VALDINEI
    
    %PARTE DO TEMPO
%     subplot(6,5,[4,5]);
%     h=imshow(A3); %VALDINEI
%     set(h, 'AlphaData', alpha3); %VALDINEI

    %PARTE DO CAMPO
    subplot(6,5,[6,30]);
    imshow(rgbImage,'XData',[0+.15 3*Nx],'YData',[0+.35 3*Ny]);
    axis on;grid on;
    xlim([0 Nx*3]);
    ylim([0 Ny*3]);
%     set(gca,'XTick',3.5:3:Nx*3);
%     set(gca,'YTick',3.35:3.05:Ny*3);
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
%    plot(X+ceil(Nx/2*3),Y+ceil(Ny/2*3),'k-','linewidth',2);
    plot(X+Nx/2*3,Y+Ny/2*3,'k-','linewidth',2);

    %LINHA CENTRAL   
    line([Nx/2*3,Nx/2*3],[-1,size(rgbImage,1)]+1,'Color','k');

    %AREAS DOS GOLS
%    rectangle('position',[0.51 floor(Ny+Ny/3-1.15) 6 9],'LineWidth',2);
    golA=rectangle('position',[0 (floor(Ny/2)*3-3) 3 9],'LineWidth',2);
    set(golA,'FaceColor',[0.7,0.7,0.7]); %VALDINEI
%    rectangle('position',[size(rgbImage,2)-5.5 floor(Ny+Ny/3-1.15) 6 9],'LineWidth',2);
    golB=rectangle('position',[Nx*3-3 (floor(Ny/2)*3-3) 3 9],'LineWidth',2);
    set(golB,'FaceColor',[0.3,0.3,0.3]); %VALDINEI
    hold off;    
end