classdef randomAgent < handle
    properties
        A
    end
    methods      
        function G = randomAgent(A)
            G.A = A;
        end

        function a = action(G)
            a = randi(G.A);
        end
    end
end