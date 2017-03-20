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

function TempMain1x1_QLearning5x3
n=30; %number of game simulations (rounds)
total=1e5; %total of interations of a game (time) 

stepbystep=false; %wait for a click for execute each state update  (depuration mode)
shows = true; %start plotting embed graphical interface

plotPartial = false; %determines if partinally plot is maded
nIterShow = 1e4; %number for update graphical scheme

%M is instance of simulator.
%Sets values for simulator configuration
%(Nx max value, Ny max value, Number of Team A player, Number of Team B player, boolean)
%bool defines if is a rand start position distribution
M = setSimulator(5,3,1,1,true); 

scoreStorage = 'Data/ScoreQLearningVsStar.mat'; %local for storage sparse matrix of score of games simulated

saveAgent = true; %bool for define if agent instances will be storage after each game simulated
agentStorage = 'Data/agentQLearningVsStar.mat' %local for storage instance for agents simulated (could be reused in a new execution)

tempFile = 'Data/temp.mat'; %temporary file for storage memory of files while recording (for reduce losses of simulation datas in recording processes)

if fileattrib(scoreStorage) %save on-demand score and agent in EOF (End of file) in local defined while partinally execution of simulation is not finished yet
   load(scoreStorage);
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
    epsilon = 0.1; %exploration parameter in RL-Algorithm
    gamma = 0.99; %discount parameter of learning in RL-Algorithm
    alpha = 0.1; %learning factor in RL-Algorithm
    agent = QLearning(nA,epsilon,gamma,alpha,M); %vinculates instance for agent with this strategy
end

function agent = CreateAgentB(M) %defines Team B agents
    agent = agentAstar(5,M);  %vinculates instance for agent with this strategy
end

%method used by agents of team A to choose action to be taken in a state
function action = ChooseActionA(nPlayer,agent,sOld,aOld,reward,sNew,notFirst,timegame)
action = agent.action(sNew);

    if notFirst
        agent.update(sOld,aOld,reward,sNew);
    end
end

% method used by agents of team B to choose action to be taken in a state
function action = ChooseActionB(nPlayer,agent,sOld,aOld,reward,sNew,notFirst,timegame)
    action = agent.action(sNew);
end
