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



