%% State is a class that encapsulates all data of current state in an enviromental soccer simulation in simulator D2DSS
%
%Properties for class state:
%    B				      Ball coordinate B.x, B.y
%    P				      Array of coordinates for all players, starting with team A and after with team B .. P(i).x, P(i).y
%    nP                 Value of players in current simulation
%    B_direct		      Ball direction: 0->Null (Nop), 1->North, 2->South, 3->East, 4->West, 5->Northeastern, 6->Southeastern, 7->Northwestern, 8->Southwest
%    B_speed		      Defines ball velocity
%    limits             Deliminates max value retorned by method for factoring()
%    M				      Structure to store definied literals about current simulation
%
%Uses of states methods:c
%>> S.factor() 			% retorn factors for next state respectively for B.x, B.y, B_direct+1, B_speed+1, P{1}.x, P{1}.y, P{2}.x, P{2}.y
%
%ans =
%
%     8     5     1     1     4     1    10     7
%
%>> S.limits % show max limita for each factor
%
%ans =
%
%    11     7     9     3    11     7    11     7
%
%>> S.startPositionGoal(M,true) 	% sets start position in a specificied M stuctured, also could reorganize team distribution in start position
%>> S.factor() 			% this example ball is stopped in same position of player 1
%
%ans =
%
%     6     4     1     1     6     4     9     4  
%
%>>
%%
classdef state < handle
   
        properties 
        B;
        P;
        nP;
        B_direct;
        B_speed;
        limits;
        M
        end
methods   
    
function obj = state(M)
    obj.M = M;
    obj.nP = M.Ta+M.Tb;
    obj.P = cell(1,obj.nP);
    
    obj.limits = [M.Nx M.Ny 9 (M.MaxBallVelocity+1)];
    for i=1:obj.nP
        obj.limits = [obj.limits M.Nx];
        obj.limits = [obj.limits M.Ny];
    end
    
    obj.startPositionRand(M);
end

function factorState = factoringA(G)
    factorState = [G.B.x G.B.y G.B_direct+1 G.B_speed+1];
    for i=1:G.nP
        factorState = [factorState G.P{i}.x];
        factorState = [factorState G.P{i}.y];
    end
end


function factorState = factoringB(G)
    order = [0 1 2 4 3 7 8 5 6];
    factorState = [G.M.Nx-G.B.x+1 G.B.y order(G.B_direct+1)+1 G.B_speed+1];
    for i=1:G.M.Tb
        factorState = [factorState G.M.Nx-G.P{G.M.Ta+i}.x+1];
        factorState = [factorState G.P{G.M.Ta+i}.y];
    end
    for i=1:G.M.Ta
        factorState = [factorState G.M.Nx-G.P{i}.x+1];
        factorState = [factorState G.P{i}.y];
    end
end


function setFatorado(G,factorState)
    G.B.x = factorState(1);
    G.B.y = factorState(2);
    G.B_direct = factorState(3)-1;
    G.B_speed = factorState(4)-1;
    k = 4;
    for i=1:G.nP
        k=k+1;
        G.P{i}.x = factorState(k);
        k=k+1;
        G.P{i}.y = factorState(k);
    end
end


function setFatoradoB(G,factorState)
    order = [0 1 2 4 3 7 8 5 6];
    G.B.x = G.M.Nx-factorState(1)+1;
    G.B.y = factorState(2);
    G.B_direct = order(factorState(3));
    G.B_speed = factorState(4)-1;
    k = 4;
    for i=1:G.M.Tb
        k=k+1;
        G.P{G.M.Ta+i}.x = G.M.Nx-factorState(k)+1;
        k=k+1;
        G.P{G.M.Ta+i}.y = factorState(k);
    end
    for i=1:G.M.Ta
        k=k+1;
        G.P{i}.x = G.M.Nx-factorState(k)+1;
        k=k+1;
        G.P{i}.y = factorState(k);
    end
end

%Function for uniform distribution of start position for both teams
function espalhamentoGoal(S,M,left)
    
    posicao = randperm(M.Ny*floor(M.Nx/2));

    %Start position for team A
    for i=1:M.Ta
        S.P{i}.y = mod(posicao(i)-1,M.Ny)+1;
        S.P{i}.x = floor((posicao(i)-1)/M.Ny)+1;
    end
    
    posicao = randperm(M.Ny*floor(M.Nx/2));

    %Start position for team B
    for i=1:M.Tb
        S.P{i+M.Ta}.y = mod(posicao(i)-1,M.Ny)+1;
        S.P{i+M.Ta}.x = M.Nx - floor((posicao(i)-1)/M.Ny);
    end

    %Start ball position
    S.B.x=round(M.Nx/2);
    S.B.y=round(M.Ny/2);
    S.B_speed=0;
    S.B_direct=0;
    
    if left
        if (M.Ta>0)
            S.P{1}.x=S.B.x;
            S.P{1}.y=S.B.y;
        end
    else
        if (M.Tb>0)
            S.P{M.Ta+1}.x=S.B.x;
            S.P{M.Ta+1}.y=S.B.y;
        end
    end

%Function for randomize start position for both teams
function startPositionRand(S,M)
    
    posicao = randperm(M.Ny*M.Nx);
    
    for i=1:M.Ta+M.Tb
        S.P{i}.y = mod(posicao(i)-1,M.Ny)+1;
        S.P{i}.x = floor((posicao(i)-1)/M.Ny)+1;
    end
    
    

    %Start ball position
    i=randi(M.Ny*M.Nx);
    S.B.y=mod(i-1,M.Ny)+1;
    S.B.x=floor((i-1)/M.Ny)+1;
    S.B_speed=0;
    S.B_direct=0;

end

%reward of take an action in a specific state S
function reward = move(S,aNew)

        reward = 0;

        
        for i=randperm(S.M.Ta+S.M.Tb)
            S.moveAgent(i,aNew(i));
        end
        
        S.moveBall();
        
        %Simulator verify if a goals was maded by any team
        if  S.B.y>=(ceil(S.M.Ny/2)-S.M.goalWidth) && S.B.y<=(ceil(S.M.Ny/2)+S.M.goalWidth) && S.B.x==S.M.Nx
            reward = 1;
        elseif S.B.y>=(ceil(S.M.Ny/2)-S.M.goalWidth) && S.B.y<=(ceil(S.M.Ny/2)+S.M.goalWidth) && S.B.x==1
            reward = -1;
        end

end

%moveAgent(S,i,a) move agent in a specific state with an action, i is id for player
function moveAgent(S,i,a)

    xBall=S.B.x;
    yBall=S.B.y;
    xNext=S.P{i}.x;
    yNext=S.P{i}.y;      
    if a==0 %action null, be stopped no operation (Nop)
        xNext=S.P{i}.x;
        yNext=S.P{i}.y;
    elseif a==1 %move north
        if rand < S.M.ProbPlayerMove
            xNext = S.P{i}.x;
            yNext = max(S.P{i}.y-1,1);
        else
            xNext=S.P{i}.x;
            yNext = S.P{i}.y;
        end
    elseif a==2 %move south
        if rand < S.M.ProbPlayerMove
            xNext=S.P{i}.x;
            yNext = min(S.P{i}.y+1,S.M.Ny);
        else
            xNext=S.P{i}.x;
            yNext = S.P{i}.y;
        end
    elseif a==3 %move east
        if rand < S.M.ProbPlayerMove
            xNext = min(S.P{i}.x+1,S.M.Nx);
            yNext = S.P{i}.y;
        else
            xNext=S.P{i}.x;
            yNext = S.P{i}.y;
        end
    elseif a==4  %move west
        if rand < S.M.ProbPlayerMove
            xNext = max(S.P{i}.x-1,1);
            yNext = S.P{i}.y;
        else
            xNext=S.P{i}.x;
            yNext = S.P{i}.y;
        end
        
    elseif a>=5 && a<=12 %Kick in 8 directions (5->North, 6->South, 7->East, 8->West, 9->Northeastern, 10->Southeastern, 11->Northwestern, 12->Southwest)
        if(S.P{i}.x==S.B.x && S.P{i}.y==S.B.y)
            S.B_direct = a-4;
            S.B_speed=S.M.MaxBallVelocity;
        end
    elseif a==13 %Tackle for recovery ball if in 4-neighborhood from ball actual position        
        if(S.P{i}.x~=S.B.x || S.P{i}.y~=S.B.y)
            if(sum(abs([S.P{i}.x - S.B.x,  S.P{i}.y - S.B.y]))<=1)
                if rand < S.M.ProbTackle %probability to take a ball in a tackle
                    xBall=S.P{i}.x;
                    yBall=S.P{i}.y;
                    S.B_direct = 0; %after a take a ball kicked is stopped
                    S.B_speed=0;
                end
            end
        end
    end


    for j=1:S.M.Ta+S.M.Tb
        if i==j 
            continue;
        end

        if (xNext == S.P{j}.x && yNext == S.P{j}.y) %restrict positions of players, so no more than 1 player is possible for one same position x,y (discrete concept)
            xNext = S.P{i}.x;
            yNext = S.P{i}.y;
            break;
        end
    end
    if S.P{i}.x==S.B.x && S.P{i}.y==S.B.y %if ball is with player, there is also a probability to carry on ball to next position
        if rand<=S.M.ProbBallWithPlayer
            xBall = xNext;
            yBall = yNext;
        end        
    end
    S.P{i}.x=xNext;
    S.P{i}.y=yNext;
    S.B.x=xBall;
    S.B.y=yBall;    
end

function moveBall(S)

    if S.B_speed > 0


        if rand > (1-S.M.ProbBallDecay)
            S.B_speed=max(S.B_speed-1,0);
        end
            
        if S.B_direct==1                     %N
            S.B.y=max(1,S.B.y-S.B_speed);     
        elseif S.B_direct==2                 %S
            S.B.y=min(S.M.Ny,S.B.y+S.B_speed);
        elseif S.B_direct==3                 %E
            S.B.x=min(S.B.x+S.B_speed,S.M.Nx);
        elseif S.B_direct==4                 %W
            S.B.x=max(S.B.x-S.B_speed,1);
        elseif S.B_direct==5                 %NE
            if rand(1)<=S.M.ProbBallMoveDiagonal
                S.B.x=min(S.B.x+S.B_speed,S.M.Nx);
            end
            if rand(1)<=S.M.ProbBallMoveDiagonal 
                S.B.y=max(S.B.y-S.B_speed,1);           
            end
        elseif S.B_direct==6              %SE
            if rand(1)<=S.M.ProbBallMoveDiagonal
                S.B.x=min(S.B.x+S.B_speed,S.M.Nx);
            end
            if rand(1)<=S.M.ProbBallMoveDiagonal
                S.B.y=min(S.B.y+S.B_speed,S.M.Ny);           
            end
        elseif S.B_direct==7              %NW
            if rand(1)<=S.M.ProbBallMoveDiagonal
                S.B.x=max(S.B.x-S.B_speed,1);
            end
            if rand(1)<=S.M.ProbBallMoveDiagonal
                S.B.y=max(S.B.y-S.B_speed,1);
            end
        elseif S.B_direct==8              %SW
            if rand(1)<=S.M.ProbBallMoveDiagonal
                S.B.x=max(S.B.x-S.B_speed,1);
            end
            if rand(1)<=S.M.ProbBallMoveDiagonal
                S.B.y=min(S.B.y+S.B_speed,S.M.Ny);  
            end
        end

        
        S.B_speed=max(S.B_speed-1,0); %ball velocity decrement
        if(S.B_speed==0)
            S.B_direct=0;
        end

        if rand < S.M.ProbTackle
            for l=1:S.M.Ta+S.M.Tb
                if(S.B.x==S.P{l}.x && S.B.y == S.P{l}.y)
                    S.B_speed=0;
                    S.B_direct=0;   
                end        
            end
        end    
        
    end

end
end
end
