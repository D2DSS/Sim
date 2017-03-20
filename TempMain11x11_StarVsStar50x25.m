%% This a sample example of a Main file to invoke simulator D2DSS
% Using Rules with A* search techniques x Rules with A* search techniques
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
n=30; %number of game simulations (rounds)
total=1e5; %total of interations of a game (time)

stepbystep=false; %wait for a click for execute each state update  (depuration mode)
shows = true; %enable plotting embed graphical interface

plotPartial = false; %determines if partinally plot is maded
nIterShow = 1e4; %number for update graphical scheme

%M is instance of simulator.
%Sets values for simulator configuration
%(Nx max value, Ny max value, Number of Team A player, Number of Team B player, boolean)
%bool defines if is a rand start position distribution
M = setSimulator(50,25,3,3,true);

scoreStorage = 'Data/ScoreStarVsStar.mat'; %local for storage sparse matrix of score of games simulated

saveAgent = true; %bool for define if agent instances will be storage after each game simulated
agentStorage = 'Data/agentStarVsStar.mat'

tempFile = 'Data/temp.mat'; %local for storage instance for agents simulated (could be reused in a new execution)

if fileattrib(scoreStorage) %temporary file for storage memory of files while recording (for reduce losses of simulation datas in recording processes)
   load(scoreStorage); %save on-demand score and agent in EOF (End of file) in local defined while partinally execution of simulation is not finished yet
   if saveAgent
        load(agentStorage);
   end
   pInit = p+1; %increment counter for next storage
else
   pInit = 1; %start counter in there is no data before
end

simulatorCore %call for simulator core

end

function agent = CreateAgentA(M) %defines Team A agents
    nA = 13; %number of actions (starts in 0, but doesn't counts 0 case)
    agent = agentAstar(5,M); %vinculates instance for agent with this strategy
end

function agent = CreateAgentB(M) %defines Team B agents
    nA = 13; %number of actions (starts in 0, but doesn't counts 0 case)
    agent = agentAstar(5,M); %vinculates instance for agent with this strategy
end

%Method used by agents of team A to choose action to be taken in a state
function action = ChooseActionA(nPlayer,agent,sOld,aOld,reward,sNew,notFirst,timegame)
    action = agent.action(sNew);
end

%Method used by agents of team B to choose action to be taken in a state
function action = ChooseActionB(nPlayer,agent,sOld,aOld,reward,sNew,notFirst,timegame)
    action = agent.action(sNew);
end
