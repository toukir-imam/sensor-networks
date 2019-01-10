function [ utility ] =  caldUtility(targets,sensors,dists,k)

    
for i = 1:length(sensors)
    tDi =[];
    for j = 1:length(sensors)   
        if sum(abs(sensors(:,i)-sensors(:,j))) <= k
            tDi = [tDi ; dists(j,:)];
        end
    end
    
end