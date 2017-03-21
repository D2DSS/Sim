colors = ['b- '; 'g- '; 'r- '; 'c- '; 'k- '; 'b--'; 'g--'; 'r--'; 'c--'; 'k--'; 'b-.'; 'g-.'; 'r-.'; 'c-.'; 'k-.']; % define colors indexes
index = 0;

nY = 5000; % Graphical plot precision, less is more precision

label = cell(0,0);

figure
hold on

load 'Data/ScoreQLearningVsStar.mat' %File for plotting

index=index+1; label{index} = ['(' int2str(sum(rewarded(:)>0)/p) '-' int2str(sum(rewarded(:)<0)/p) '=' int2str(sum(rewarded(:))/p) ') - Q-Learning 5x3 (mean)'];
nX = length(rewarded)/nY;plot(nY:nY:nY*nX,mean(reshape(rewarded(1:p,:),p*nY,nX)),colors(mod(index-1,length(colors))+1,:),'linewidth',3);
for i=1:p
    index=index+1; label{index} = ['(' int2str(sum(rewarded(i,:)>0)) '-' int2str(sum(rewarded(i,:)<0)) '=' int2str(sum(rewarded(i,:))) ') - (execucao ' int2str(i) ')'];
    plot(nY:nY:nY*nX,mean(reshape(rewarded(i,:),nY,nX)),colors(mod(index-1,length(colors))+1,:));
end

legend(label)
title('Plot comparing differents strategy scolors in Simulator D2DSS') %title of plot
ylabel('Goals Difference') %y label
xlabel('Iterations') %x label
legend(label,'Location','northwest')
lh=findall(gcf,'tag','legend');
set(lh,'location','northeastoutside');
hold off