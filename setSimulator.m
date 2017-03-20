%%This class sets up variables for parameters of simulation of games in simulator D2DSS
%	function M = setSimulator(Nx, Ny, Ta, Tb, randAfterGoal)
% Responsable for vinculates main variables of simulation in M structure
%%
function M = setSimulator(Nx, Ny, Ta, Tb, randAfterGoal)

    %Probabilities for simulation
    M.ProbBallWithPlayer = 0.9; %sets probability for sucessfully carry the ball (with ball)
    M.ProbPlayerMove= 0.95; %sets probability for player move (without ball)
    M.ProbTackle= 0.5; %probability for recovery ball in a tackle (player needed to be at 4 neer positions xy where ball is)
    M.ProbBallDecay= 0.1; %probability for reduce ball trajectory after be kicked
    M.ProbBallMoveDiagonal=0.5; %probability of ball disrupts its own direction
    
    %Fuctions denotated and used by simulator
    M.MaxBallVelocity= max(1,floor((-1+sqrt(1+Nx*8*1/3))/2)); %velocity is decremented one in each iteration
    M.KickRange = ((M.MaxBallVelocity*(M.MaxBallVelocity+1))/2); %calculates max range of a kick
    M.goalWidth = floor(Ny/6); %size of goal
    
    %Graphical Configurations
    M.cellWidth = 3; %size of a cell
    M.delay = 0.25; %time for waiting to starting plotting simulation

    %Sets value for Nx, Ny, Ta and Tb. (refers for value x,y of field and number of player by team.
    M.Nx = Nx;
    M.Ny = Ny;
    M.Ta = Ta;
    M.Tb = Tb;
    
	%Boolean that sets if starts positions after goal is random or by a uniform distribution
    M.randAfterGoal = randAfterGoal;
    
	%Defines horizon of simulation
    M.horizon = 3*(Nx+Ny);
end
