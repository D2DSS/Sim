function TempMain11x11_RandVsStar50x25
n=30;
total=1e5;

stepbystep=false;
shows = true;

plotPartial = false;
nIterShow = 1e4;

M = setSimulator(50,25,11,11,true);


scoreStorage = 'Data/ScoreRandVsStar.mat';


saveAgent = true;
agentStorage = 'Data/agentRandVsStar.mat'

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
    agent= randomAgent(nA);
end

function agent = CreateAgentB(M)
    agent = agentAstar(5,M);
end

function action = ChooseActionA(nPlayer,agent,sOld,aOld,reward,sNew,notFirst,timegame)
    aOrder = [1,2,4,3,5,6,8,7,11,12,9,10,13];
    action = zeros(1,nPlayer);
    for i=1:nPlayer
        action(i) = aOrder(agent.action());
    end
end

function action = ChooseActionB(nPlayer,agent,sOld,aOld,reward,sNew,notFirst,timegame)
    action = agent.action(sNew);
end



