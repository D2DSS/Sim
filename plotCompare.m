colors = ['b- '; 'g- '; 'r- '; 'c- '; 'k- '; 'm-.'; 'g--'; 'r--'; 'c--'; 'k--'; 'b-.'; 'g-.'; 'r-.'; 'c-.'; 'k-.']; % define colors indexes
index = 0;

nY = 1000; % Graphical plot precision, less is more precision

label = cell(0,0);

figure 
hold on

load 'Data/ScoreQLearningVsStar.mat' %File for plotting #1
index=index+1; label{index} = ['Q-Learning X Rules *'];
nX = length(rewarded)/nY;plot(nY:nY:nY*nX,mean(reshape(rewarded(1:p,:),p*nY,nX)),colors(mod(index-1,length(colors))+1,:),'linewidth',2);

load 'Data/ScoreSarsaVsStar.mat' %File for plotting #2
index=index+1; label{index} = ['Sarsa X Regras'];
nX = length(rewarded)/nY;plot(nY:nY:nY*nX,mean(reshape(rewarded(1:p,:),p*nY,nX)),colors(mod(index-1,length(colors))+1,:),'linewidth',2);

load 'Data/ScoreStarVsStar.mat' %File for plotting #3
index=index+1; label{index} = ['Rules * X Rules *'];
nX = length(rewarded)/nY;plot(nY:nY:nY*nX,mean(reshape(rewarded(1:p,:),p*nY,nX)),colors(mod(index-1,length(colors))+1,:),'linewidth',2);

load 'Data/ScoreRandVsStar.mat' %File for plotting #4
index=index+1; label{index} = ['Random X Random'];
nX = length(rewarded)/nY;plot(nY:nY:nY*nX,mean(reshape(rewarded(1:p,:),p*nY,nX)),colors(mod(index-1,length(colors))+1,:),'linewidth',2);

title('Plot comparing differents strategy scores in Simulator D2DSS') %title of plot
ylabel('Goals Difference') %y label
xlabel('Iterations') %x label
legend(label,'Location','northwest')
lh=findall(gcf,'tag','legend');
set(lh,'location','northeastoutside');
hold off
