%% This a sample example of a Main file to invoke simulator D2DSS
% Using Q-Learning x Rules with A* search techniques
%
% One main for use D2DSS Simulator needs:
%
	% - Define enviromental variables:
	% 	int:{n}
	%	double:{total,nIterShow}
	%	boolean:{stepbystep,shows,plotPartial,saveAgent}
	%	String:{scoreStorage,agentStorage,tempFile} 
%
	% - Implement methods:
	%	CreateAgentA(), CreateAgentB(), ChooseActionA(), ChooseActionB()
%	
	% - Call for simulatorCore() is needed and save on-demand coding processes is optionally used here 
%%

function TempMain11x11_StarVsStar50x25
n=30;
total=1e5;

stepbystep=false;
shows = true;

plotPartial = false;
nIterShow = 1e4;

M = setSimulator(50,25,3,3,true);


scoreStorage = 'Data/ScoreStarVsStar.mat';


saveAgent = true;
agentStorage = 'Data/agentStarVsStar.mat'

tempFile = 'Data/temp.mat';

if fileattrib(scoreStorage)
   load(scoreStorage);
   if saveAgent
        load(agentStorage);
   end
   pInit = p+1;
else
   pInit = 1;
end

simulatorCore

end

function agent = CreateAgentA(M)
    agent = agentAstar(5,M);
end

function agent = CreateAgentB(M)
    agent = agentAstar(5,M);
end

function action = ChooseActionA(nPlayer,agent,sOld,aOld,reward,sNew,notFirst,timegame)
    action = agent.action(sNew);
end

function action = ChooseActionB(nPlayer,agent,sOld,aOld,reward,sNew,notFirst,timegame)
    action = agent.action(sNew);
end



