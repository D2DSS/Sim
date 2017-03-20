%% This a sample example of a Main file to invoke simulator D2DSS
% Using Sarsa x Rules with A* search techniques
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

function TempMain1x1_Sarsa5x3
n=30;
total=1e5;

stepbystep=false;
shows = true;

plotPartial = false;
nIterShow = 1e4;

M = setSimulator(5,3,1,1,true);


scoreStorage = 'Data/ScoreSarsaVsStar.mat';


saveAgent = true;
agentStorage = 'Data/agentSarsaVsStar.mat'

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
    nA = 13;
    epsilon = 0.1;
    gamma = 0.99;
    alpha = 0.1;
    agent = Sarsa(nA,epsilon,gamma,alpha,M); 
end

function agent = CreateAgentB(M)
    agent = agentAstar(5,M);
end

function action = ChooseActionA(nPlayer,agent,sOld,aOld,reward,sNew,notFirst,timegame)
    action = agent.action(sNew);

    if notFirst
        agent.update(sOld,aOld,reward,sNew,action);
    end
end

function action = ChooseActionB(nPlayer,agent,sOld,aOld,reward,sNew,notFirst,timegame)
    action = agent.action(sNew);
end
