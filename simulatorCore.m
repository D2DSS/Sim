% isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
aOrder = [0,1,2,4,3,5,6,8,7,11,12,9,10,13];

rewarded = sparse(n, total);
agents = cell(1,n);

for p=pInit:n
    agentA = CreateAgentA(M);
    Mb = M;
    Mb.Ta = M.Ta;
    Mb.Tb = M.Tb;
    agentB = CreateAgentB(Mb);

    J = setGame(total);
    
    S=state(M);
    reward = rand-0.5;
    
    %Posicao inicial dos jogadores
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

    %Loop principal
    
    horizon = M.horizon;
    
    while J.timer>0
        timegame = timegame+1;

        % De tempos em tempos escolhe uma posicao aleatoria para iniciar
        if horizon == 0
            S.startPositionRand(M);
            notFirst = false;
            horizon = M.horizon;
            if (shows)
                showGame(S, M, J);
            end
        end
        
        horizon = horizon-1;
        
        % escolhe acao para cada jogador
        aOld = aNew;
        sOldA = sNewA;
        sOldB = sNewB;
        
        sNewA = S.factoringA();
        sNewB = S.factoringB();

        aNew(1:M.Ta) = ChooseActionA(M.Ta,agentA,sOldA,aOld(1:M.Ta),reward,sNewA,notFirst,timegame/total);
        aNew(M.Ta+1:end) = aOrder(ChooseActionB(M.Tb,agentB,sOldB,aOld(M.Ta+1:end),reward,sNewB,notFirst,timegame/total)+1);

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
    
    if saveAgent
        agents{p} = agentA;
        save(tempArq,'agents','M');
        movefile(tempArq,nmarqagent);
    end
    
    save(tempArq,'rewarded','p');
    movefile(tempArq,nmarqGoals);
    J.timer = total;
    
end
