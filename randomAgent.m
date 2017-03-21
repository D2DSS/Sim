%% Random Agent implemented in simulator D2DSS
% Responsible for take a random actions of provided max actions index
%       function G = randomAgent(A)
%%
classdef randomAgent < handle
    properties
        A
    end
    methods

%Constructor of agent of type randomAgent  
        function G = randomAgent(A)
            G.A = A; %receive max value of valid actions for randomize
        end

        function a = action(G)
            a = randi(G.A); %uses rand of integer function for take one of range valid actions
        end
    end
end
