classdef QLearning < handle
    properties
        A
        epsilon
        gamma
        alpha
        Q
        limits
        M
    end
    methods      
        function G = QLearning(A,epsilon,gamma,alpha,M)
            s = state(M);
            G.A = A;
            G.epsilon = epsilon;
            G.gamma = gamma;
            G.alpha = alpha;
            G.M=M;
            G.limits = s.limits;
            G.Q=zeros(prod(s.limits),A);
        end
        
        function [a Qcmac] = action(G,s)
            state = G.enumerate(s);
            if rand > G.epsilon
                V = max(G.Q(state,:));
                as = find(G.Q(state,:)==V);
                a = as(randi(length(as)));
            else
                a = randi(G.A);
            end
        end
                  
        function state = enumerate(G,s)
            prodFactor = [1 cumprod(G.limits(1:end-1),2)];
            state = sum((s-1).*prodFactor,2) + 1;
        end
        
       function update(G,s,a,r,sNext)
            nextState = G.enumerate(sNext);
            qNext = max(G.Q(nextState,:));
         
            state = G.enumerate(s);
            qOld = G.Q(state,a);
            
            delta = r+G.gamma*qNext - qOld;
            G.Q(state,a) = G.Q(state,a) + G.alpha*delta;
       end        
    end
end