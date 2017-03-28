%%Script for core of execution in simulator D2DSS
% It is responsable for resquest and wait action decision to be taken by an agent
% Schemed as a wait-for scheduler, there is no time limit to turn exceed for waiting for an action be choosen
% 	so any techniques could be used
%%

% isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0; %used in Octave compatibility of simulator D2DSS
aOrder = [0,1,2,4,3,5,6,8,7,11,12,9,10,13]; %order of actions in structure implemented

rewarded = sparse(n, total); %sparse matrix used to store value of game by iteration (-1 opponent goal, +1 team goal, 0 no goal is not literally represented by this structure) 
agents = cell(1,n); %store agents of team in memory

for p=pInit:n
 
    Mb = M;
    Mb.Ta = M.Ta;
    Mb.Tb = M.Tb;
    
    if Mb.Ta > 0   
    agentA = CreateAgentA(M);
    end
    
    if Mb.Tb > 0
    agentB = CreateAgentB(Mb);
    end
    J = setGame(total);
    
    S=state(M);
    reward = rand-0.5;
    
% Start position of players (could be random or regular distribution) 
if M.randAfterGoal
        S.startPositionRand(M);
    else
        S.startPositionGoal(M,reward<0);
    end
    timegame = 0;
    notFirst = false;
    
    aNew = zeros(1,M.Ta+M.Tb);
    sNewA= [];
    sNewB= [];
    reward =0;
    
    %Main loop
    
    horizon = M.horizon;
    
    while J.timer>0
        timegame = timegame+1;

        % In each horizon sets start positions for all players
        if horizon == 0
            S.startPositionRand(M);
            notFirst = false;
            horizon = M.horizon;
            if (shows)
                showGame(S, M, J);
            end
        end
        
        horizon = horizon-1;
        
        % request an action for each player
        aOld = aNew;
        sOldA = sNewA;
        sOldB = sNewB;
        
        sNewA = S.factoringA();
        sNewB = S.factoringB();

        if M.Ta > 0
        aNew(1:M.Ta) = ChooseActionA(M.Ta,agentA,sOldA,aOld(1:M.Ta),reward,sNewA,notFirst,timegame/total);
        end
        if M.Tb > 0
        aNew(M.Ta+1:end) = aOrder(ChooseActionB(M.Tb,agentB,sOldB,aOld(M.Ta+1:end),reward,sNewB,notFirst,timegame/total)+1);
        end
        notFirst = true;

        reward = S.move(aNew);
        rewarded(p,timegame) = reward;
        
        if abs(reward)
            if (shows)
                showGame(S, M, J);
            end   
            if M.randAfterGoal
                S.startPositionRand(M);
                 else
                S.startPositionGoal(M,reward<0);
            end
        end
        
        J.scoreA=J.scoreA+max(reward,0);
        J.scoreB=J.scoreB+max(-reward,0);
        J.timer=J.timer-1;
        
        if (shows)
          showGame(S, M, J);
            if (stepbystep)
                pause;
            end

       
        end   
        
        if mod(J.timer,nIterShow) == 0
            [p J.timer/J.total]
            full([sum(J.scoreA) sum(J.scoreB)])'
            
            if plotPartial
               if p > 1
                    plot(nIterShow*[1:(total-J.timer)/nIterShow],mean(reshape(rewarded(p,1:(total-J.timer)),nIterShow,(total-J.timer)/nIterShow),1),...
                        nIterShow*[1:(total-0)/nIterShow],mean(reshape(rewarded(1:(p-1),1:(total-0)),(p-1)*nIterShow,(total-0)/nIterShow),1));
                else
                    plot(nIterShow*[1:(total-J.timer)/nIterShow],mean(reshape(rewarded(p,1:(total-J.timer)),nIterShow,(total-J.timer)/nIterShow),1));
                end
                drawnow
            end
            
%             if isOctave
%                 fflush(stdout);
%             end
        end       
    end
    % This part made save of files of memory of agents and rewarded that is also score of game simulated    
    if saveAgent
        agents{p} = agentA;
        save(tempFile,'agents','M');
        movefile(tempFile,agentStorage);
    end
    
    save(tempFile,'rewarded','p');
    movefile(tempFile,scoreStorage);
    J.timer = total;
    
end
