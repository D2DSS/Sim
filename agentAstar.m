%% Rules with A* search implemented in simulator D2DSS
% Responsible for make a good static policy in game soccer
% Based in using ifs for defining rules and making a search A* to find and include more rules 
%       function G = agentAstar(limit,M)
%%

classdef agentAstar < handle
    properties
        M % problem settings
        coord %array of positions of players and ball
        limit %limit max for A* search treee
    end
    methods
    
%Constructor of agent of type agentAstar            
        function G = agentAstar(limit,M)
            G.M = M;

            G.limit = limit;
            G.coord = cell(1,M.Ta-1);
            for i=1:(M.Ta-1)
                G.coord{i} = floor(G.M.Nx*(1:i)/(i+1));
            end
        end       

%Function responsible for choose next best state based on rules strategy
        function sNext = nextState(G,s,a,Map)
            switch a
                case 1 %Move north
                    sNext = s+[0, -1];
                case 2 %Move south
                    sNext = s+[0, 1];
                case 3 %Move east
                    sNext = s+[1, 0];
                case 4 %Move west
                    sNext = s+[-1, 0];
            end
            sNext = min(sNext,[G.M.Nx, G.M.Ny]);
            sNext = max(sNext,[1, 1]);
            
            if Map(sNext(1),sNext(2))
                sNext = s;
            end
        end

%Function with an additional planning using search A* concepts
        function [d a] = planning(G,pos,goal,Map,depth)
            border = zeros(G.M.Nx,G.M.Ny);
            analyzed = zeros(G.M.Nx,G.M.Ny);
            h = inf(G.M.Nx,G.M.Ny);
            f = zeros(G.M.Nx,G.M.Ny);
            actions = zeros(G.M.Nx,G.M.Ny);
              
            border(pos(1),pos(2)) = 1;
            h(pos(1),pos(2)) = norm(pos-goal,1);
            f(pos(1),pos(2)) = 0;
            
            nSearch = 0;
            
            while any(border(:))
                nSearch = nSearch+1;
                
                [a b] = min(h(:)+f(:));
                
                if (a == inf)
                    d = inf;
                    a = 0;
                    return;
                end
                
                aux = find(h(:)+f(:)==a);
                b = aux(randi(length(aux)));
                
                [I,J] = ind2sub(size(h),b);
                
                previousA = actions(I,J);
                previousF = f(I,J);
                previousH = h(I,J);
                
                h(I,J) = inf;
                border(I,J) = 0;
                analyzed(I,J) = 1;

                if previousH == 0 || nSearch > depth
                    d = previousF + previousH;
                    a = previousA;
                    return;
                end

                if previousA
                    for i=1:4
                        sNext = G.nextState([I J],i,Map);
                        if ~analyzed(sNext(1),sNext(2))
                            border(sNext(1),sNext(2)) = 1;
                            h(sNext(1),sNext(2)) = norm(sNext-goal,1);
                            f(sNext(1),sNext(2)) = previousF+1;
                            actions(sNext(1),sNext(2)) = previousA;
                            
                        end
                    end
                else
                    for i=1:4
                        sNext = G.nextState([I J],i,Map);
                        if ~analyzed(sNext(1),sNext(2))
                            border(sNext(1),sNext(2)) = 1;
                            h(sNext(1),sNext(2)) = norm(sNext-goal,1);
                            f(sNext(1),sNext(2)) = previousF+1;
                            actions(sNext(1),sNext(2)) = i;
                        end
                    end
                end
            end
            d = inf;
            a = randi(4);
        end
        
%Pre planning for more a set of rules extended more actions than 4 basics of moves        
        function aa = prePlanning(G, dist, positions,aa,goal,Map,BallorPos)
            [d a] = min(dist);
            pos = positions(a,:);
            undecided = true;
            if d == 0
                if ~BallorPos
                    aa(a)=13; %tackle for recovery ball
                    undecided = false;
                else
                    positions(a,:) = 0;
                    if pos(2)<(ceil(G.M.Ny/2)-G.M.goalWidth) && max(abs(pos-[G.M.Nx (ceil(G.M.Ny/2)-G.M.goalWidth)])) <= G.M.ProbBallMoveDiagonal*G.M.KickRange 
                        aa(a) = 10; %kick Southeast
                        undecided = false;
                    elseif pos(2)>(ceil(G.M.Ny/2)+G.M.goalWidth) && max(abs(pos-[G.M.Nx (ceil(G.M.Ny/2)+G.M.goalWidth)])) <= G.M.ProbBallMoveDiagonal*G.M.KickRange 
                        aa(a) = 9; %kick Northeast
                        undecided = false;
                    elseif  pos(2)>=(ceil(G.M.Ny/2)-G.M.goalWidth) && pos(2)<=(ceil(G.M.Ny/2)+G.M.goalWidth) && (G.M.Nx-pos(1)) <= G.M.ProbBallWithPlayer*G.M.KickRange || any(positions(1:G.M.Ta,1)>pos(1))
                        aa(a) = 7; %ball pass or kick East
                        undecided = false;
                    elseif pos(2)>=(ceil(G.M.Ny/2)-G.M.goalWidth) && pos(2)<=(ceil(G.M.Ny/2)+G.M.goalWidth)
                        goal = [min(pos(1)+G.limit,G.M.Nx) pos(2)]; %go East
                    elseif pos(2)<(ceil(G.M.Ny/2)-G.M.goalWidth)
                        goal = [min(pos(1)+G.limit,G.M.Nx) (ceil(G.M.Ny/2)-G.M.goalWidth)];%go Southeast
                    elseif pos(2)>(ceil(G.M.Ny/2)+G.M.goalWidth)
                        goal = [min(pos(1)+G.limit,G.M.Nx) (ceil(G.M.Ny/2)+G.M.goalWidth)];%go Northeast
                    end
                end
            end    
            %if not could decide, keep with next rules    
            if undecided
                if goal(1) < pos(1)
                    intX = max(goal(1),pos(1)-G.limit):pos(1);
                else
                    intX = pos(1):min(goal(1),pos(1)+G.limit);
                end

                if goal(2) < pos(2)
                    intY = max(goal(2),pos(2)-G.limit):pos(2);
                else
                    intY = pos(2):min(goal(2),pos(2)+G.limit);
                end

                if (sum(sum(Map(intX,intY))) == 1) && ~BallorPos || (sum(sum(Map(intX,intY))) == 0) && BallorPos;
                    d = abs(goal-pos);
                    if d(1)>d(2)
                        if goal(1)>pos(1) %East
                            aa(a) = 3;
                        else %West
                            aa(a) = 4;
                        end
                    elseif d(1)<d(2)
                        if goal(2)>pos(2) %South
                            aa(a) = 2;
                        else %North
                            aa(a) = 1;
                        end
                    else
                        if rand > 0.5
                            if goal(1)>pos(1) %East
                                aa(a) = 3;
                            else %West
                                aa(a) = 4;
                            end
                        else
                            if goal(2)>pos(2) %South
                                aa(a) = 2;
                            else %North
                                aa(a) = 1;
                            end
                        end
                    end
                else
                    [d act] = G.planning(pos,goal,Map,5); % A* call for find new rules for take in decision for actual position in state
                    if act > 0
                        aa(a) = act;
                    else
                        aa(a) = 4 + randi(7);
                    end
                end
            end
            
        end
        
%Mapping state in action
        function aa = action(G,s)
            ball = s(1:2);
            Map = zeros(G.M.Nx,G.M.Ny);
            positions = reshape(s(5:end),2,(G.M.Ta+G.M.Tb));
            positions = positions';
            for i=1:(G.M.Ta+G.M.Tb)
                Map(positions(i,1),positions(i,2)) = 1;
            end
            
            Map(ball(1),ball(2)) = 0;
            
            aa = zeros(1,G.M.Ta);

            dist = sum(abs(positions(1:G.M.Ta,:) - ones(G.M.Ta,1)*ball),2);
            
            if any(sum(abs(positions((G.M.Ta+1):(G.M.Ta+G.M.Tb),:) - ones(G.M.Tb,1)*ball),2)==0) && any(dist==1)
                for a=find(dist==1)
                    aa(a) = 13;
                end
            else
                 
                %Decides who will go to ball?

                dist = sum(abs(positions(1:G.M.Ta,:) - ones(G.M.Ta,1)*ball),2);
                dist(aa~=0) = inf;

                aa = prePlanning(G, dist, positions,aa,ball,Map,true);
                
                
            end
            
            %Decides who will keep in each direction?
            
            for j=randperm(G.M.Ta-1)

                if sum(aa==0)==0
                    break;
                end

                ball(1) = G.coord{G.M.Ta-1}(j);
                ball(2) = round((1-max(s(1)-ball(1),0)/G.M.Nx)*s(2)+max(s(1)-ball(1),0)/G.M.Nx*G.M.Ny/2);
                
                dist = sum(abs(positions(1:G.M.Ta,:) - ones(G.M.Ta,1)*ball),2);
                dist(aa~=0) = inf;
                
                aa = prePlanning(G, dist, positions,aa,ball,Map,false); %call for a pre planning step for using all first static rules


            end
            
        end

    end
end
