%% Q-Learning RL-Algorithm implemented in simulator D2DSS
% Responsible for make policy iteration based on Q-Learning Algorithm
%       function G = QLearning(A,epsilon,gamma,alpha,M)
%%

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

%Constructor of agent of type QLearning            
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

%Epsilon-greedy exploration step        
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

%Method for enumerating of state needed in policy iteration             
        function state = enumerate(G,s)
            prodFactor = [1 cumprod(G.limits(1:end-1),2)];
            state = sum((s-1).*prodFactor,2) + 1;
        end

%Method for update Q values using QLearning Algorithm
       function update(G,s,a,r,sNext)
            nextState = G.enumerate(sNext);
            qNext = max(G.Q(nextState,:));
         
            state = G.enumerate(s);
            qOld = G.Q(state,a);
            
            delta = r+G.gamma*qNext - qOld; %equation of RL-Algorithm
            G.Q(state,a) = G.Q(state,a) + G.alpha*delta; %policy iteration
       end        
    end
end
