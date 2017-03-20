%%This class encapsulates variables that set values for game configuration in simulator D2DSS
%       function J = setGame( timer )
% Responsible for counting variables, timer, total, goalsA, goalsB, scoreA, scoreB
%%
function J = setGame( timer )
    J.timer = timer; %counter for simulation time control
    J.total=timer; %total time for a game
    J.goalsA = sparse(timer,1); %%sparse matrix for store goals in a game, 1 is for team A and B is -1. Note that index is the current time of goal in simulation
    J.goalsB = sparse(timer,1); %sparse matrix for store goals in a game, 1 is for team B and A is -1. Note that index is the current time of goal in simulation
    J.scoreA = 0; %store score of team A 
    J.scoreB = 0; %store score of team B 

end
