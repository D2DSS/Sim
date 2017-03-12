function TempMain1x1_QLearning5x3
addpath('Strategies/');
n=30;
total=1e5;

stepbystep=false;
shows = true;

plotPartial = false;
nIterShow = 1e4;

M = setSimulator(5,3,1,1,true);


scoreStorage = 'Data/ScoreQLearningVsStar.mat';


saveAgent = true;
agentStorage = 'Data/agentQLearningVsStar.mat'

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
    agent = QLearning(nA,epsilon,gamma,alpha,M); 
end

function agent = CreateAgentB(M)
    agent = agentAstar(5,M);
end

function action = ChooseActionA(nPlayer,agent,sOld,aOld,reward,sNew,notFirst,timegame)
  action = agent.action(sNew);

    if notFirst
        agent.update(sOld,aOld,reward,sNew);
    end
end

function action = ChooseActionB(nPlayer,agent,sOld,aOld,reward,sNew,notFirst,timegame)
    action = agent.action(sNew);
end