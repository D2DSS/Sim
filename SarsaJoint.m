classdef SarsaJoint < handle
    properties
        A
        epsilon
        gamma
        alpha
        Q
        limites
        pairsJoint
        nFactor
        M
        selFactor
        nComb
    end
    methods      
        function G = SarsaJoint(A,epsilon,gamma,alpha,M,nComb)
            s = state(M);
            G.A = A;
            G.epsilon = epsilon;
            G.gamma = gamma;
            G.alpha = alpha;
            G.M=M;
            
            
            G.limites = s.limites;
            G.nComb = nComb;
            

            G.pairsJoint = combinations(nComb,length(s.limites));

            G.nFactor = size(G.pairsJoint,1);
            G.Q = cell(M.Ta,G.nFactor);
            
            for k=1:size(G.pairsJoint,1)
               for ag=1:M.Ta
                   G.Q{ag,k}=zeros(prod(s.limites(G.pairsJoint(k,:))),A);
               end
            end
            
            
        end
            

        
        function [a Qcmac] = action(G,s)
            factorState = G.refatora(s);
            
            orderAgent = randperm(G.M.Ta);
            Qcmac=0;
            for ag=orderAgent

                for i=1:G.nFactor 
                     Qcmac = G.Q{ag,i}(factorState(i),:) + Qcmac;
                end
                if rand > G.epsilon
                    V = max(Qcmac(:));
                    as = find(Qcmac(:)==V);
                    a(ag) = as(randi(length(as)));
                else
                    a(ag) = randi(G.A);
                end
                Qcmac = Qcmac(a(ag));
            end
%             disp(Qcmac);
        end
                  
        function factorState = refatora(G,s)
            prodFactor = G.limites(G.pairsJoint);
            prodFactor = [ones(G.nFactor,1) cumprod(prodFactor(:,1:end-1),2)];
            
            factorState = sum((s(G.pairsJoint)-1).*prodFactor,2) + 1;
        end
        
       function update(G,s,a,r,sNext,aNext)
            
            factorState = G.refatora(sNext);
            qNext=0;
            
            for ag=1:G.M.Ta
                qAgente = 0;
                for i=1:G.nFactor
                      qAgente = G.Q{ag,i}(factorState(i),:) + qAgente;
%                     qNext  = G.Q{ag,i}(factorState(i),aNext(ag)) + qNext;
                end
                qNext = (1-G.epsilon)*max(qAgente) + G.epsilon*mean(qAgente) + qNext;
            end
         
            factorState = G.refatora(s);
            qOld=0;
            
            for ag=1:G.M.Ta
            for i=1:G.nFactor 
                qOld  = G.Q{ag,i}(factorState(i),a(ag)) + qOld;
            end
            end
            
            delta = r+G.gamma*qNext - qOld;
            
            for ag=1:G.M.Ta
            for i=1:G.nFactor
                G.Q{ag,i}(factorState(i),a(ag)) = G.Q{ag,i}(factorState(i),a(ag)) + (G.alpha/G.nFactor)*delta;
            end 
            end
        end
    end        
end