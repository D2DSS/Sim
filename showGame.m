function showGame( S, M, J )

       	pause(M.delay);
        clf;

   

    %PARTE DO CAMPO
    subplot(10,5,[6,50]);
    
    
    
    
    axis on;grid on;
    xlim([0 M.Nx*M.cellWidth]);
    ylim([0 M.Ny*M.cellWidth]);
%     set(gca,'XTick',3.5:3:Nx*M.cellWidth);
%     set(gca,'YTick',3.35:3.05:Ny*M.cellWidth);

    set(gca,'XTick',M.cellWidth:M.cellWidth:M.Nx*M.cellWidth);
    set(gca,'YTick',M.cellWidth:M.cellWidth:M.Ny*M.cellWidth);
    set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
    set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);


    % AREA DO CAMPO    
    field=rectangle('position',[(0)*M.cellWidth+.0 (0)*M.cellWidth+.0 (M.cellWidth*M.Nx) (M.cellWidth*M.Ny)],'LineWidth',.1);
    set(field,'FaceColor',[0.0,1.0,0.0]); %VALDINEI

    %AREAS DOS GOLS
%    rectangle('position',[0.51 floor(Ny+Ny/3-1.15) 6 9],'LineWidth',2);
    golA=rectangle('position',[0 (floor(M.Ny/2)*M.cellWidth-M.cellWidth*M.goalWidth) M.cellWidth M.cellWidth*(M.goalWidth*2+1)],'LineWidth',2);
    set(golA,'FaceColor',[0.8,0.8,0.8]); %VALDINEI
%    rectangle('position',[size(rgbImage,2)-5.5 floor(Ny+Ny/3-1.15) 6 9],'LineWidth',2);
    golB=rectangle('position',[M.Nx*M.cellWidth-M.cellWidth (floor(M.Ny/2)*M.cellWidth-M.cellWidth*M.goalWidth) M.cellWidth M.cellWidth*(M.goalWidth*2+1)],'LineWidth',2);
    set(golB,'FaceColor',[0.4,0.4,0.4]); %VALDINEI
    
    
    if(M.Ta>0)
        for i=1:M.Ta
            player=rectangle('position',[(S.P{i}.x-1)*M.cellWidth+.5 (S.P{i}.y-1)*M.cellWidth+.5 (M.cellWidth-1) (M.cellWidth-1)],'LineWidth',.1);
            set(player,'FaceColor',[0.7,0.7,0.7]); %VALDINEI
            text((S.P{i}.x-1)*M.cellWidth+1,(S.P{i}.y-1)*M.cellWidth+1,num2str(i));
        end
    end
    %trio de jogadores timeB
    if (M.Tb>0)
        for i=M.Ta+1:M.Ta+M.Tb
            player=rectangle('position',[(S.P{i}.x-1)*M.cellWidth+.5 (S.P{i}.y-1)*M.cellWidth+.5 (M.cellWidth-1) (M.cellWidth-1)],'LineWidth',.1);
            set(player,'FaceColor',[0.3,0.3,0.3]); %VALDINEI
            text((S.P{i}.x-1)*M.cellWidth+1,(S.P{i}.y-1)*M.cellWidth+1,num2str(i));
        end
    end

    ball=rectangle('position',[(S.B.x-1)*M.cellWidth+1 (S.B.y-1)*M.cellWidth+1 (M.cellWidth-2) (M.cellWidth-2)],'LineWidth',.1);
    set(ball,'FaceColor',[1,1,1]); %VALDINEI


    %CIRCULO CENTRAL
    hold on;
    numPoints=100;
    radius=M.cellWidth*1;
    theta=linspace(0,5*pi,numPoints);
    rho=ones(1,numPoints)*radius;
    [X,Y] = pol2cart(theta,rho); %funcao circular
    plot(X+M.Nx/2*M.cellWidth,Y+M.Ny/2*M.cellWidth,'k-','linewidth',2);

    %LINHA CENTRAL   
    line([M.Nx/2*M.cellWidth,M.Nx/2*M.cellWidth],[0,M.Ny*M.cellWidth],'Color','k');    
    
    subplot(10,5,[1,5]);
    axis off;
    titulo='D2DSS - Discrete 2D Soccer Simulator';
    placar = ['Score: \color[rgb]{0.7,0.7,0.7}{\bullet}Ta \color{black}',num2str(J.scoreA),'X', num2str(J.scoreB) , '\color[rgb]{0.3,0.3,0.3}{\bullet}Tb\color{black}',' | ',num2str(J.timer),' Iteration'];
    text(0,1,titulo,'FontSize',15);
    text(0,0,placar,'FontSize',14);

    set(gcf, 'color', [1 1 1]) 
    
    hold off;    

end
