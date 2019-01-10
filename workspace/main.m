mapSize = 1250;
numTarget = 100;
sensorDist = 100;
convUtility =[];

k = 26*sensorDist;
gamma = 1/100;

lambda =0;
targets = mapSize*rand(2,numTarget);

tx = [0:sensorDist:mapSize];
nSensorRow = length(tx);
sensors =[];
for i = 0:sensorDist:mapSize
    ty = i*ones([1,nSensorRow]);
    ts = vertcat(ty,tx);
    sensors = [sensors ts];
end
length(sensors)
dists =[];
strategy = true(1,length(sensors));


ltUtility =[];
timeLength = 20;
timeL =[]
energy = ones(length(sensors));
for time =1:timeLength
%energy = [ones(1,round(length(sensors)/2)) ones(1,round(length(sensors)/2))];
%energy=energy(randperm(length(energy)));
tUtility = 0;
targets = targets + 5*randn(size(targets));

for i = 1:length(sensors)
    d1 = sensors(:,i);
    tdist = [];
    for j = 1:numTarget
        d2 = targets(:,j);
        dist = 1/sqrt(sum((d2-d1).^2));
        tdist = [tdist dist];
    end
    dists = vertcat(dists,tdist);
end
tstrategy = strategy;
for i = 1:length(sensors)
  if energy(i) >0
    tDi =[];
    energyStack = [];
    for j = 1:length(sensors)   
        if sum(abs(sensors(:,i)-sensors(:,j))) <= k && tstrategy(j) ==1 && energy(j)>=1
            tDi = [tDi ; dists(j,:)];
            energyStack = [energyStack;energy(j)+sum(abs(sensors(:,i)-sensors(:,j)))*lambda]; 
        end
    end
    utility =sum(max(tDi,[],1)) - sum(energyStack)*gamma ;
    tUtility = tUtility +utility;
    %% utility prime
    tDi =[];
    energyStack = [];
    tempStrategy = tstrategy;
    tempStrategy(i) = ~tstrategy(i);
    for j = 1:length(sensors)   
        if sum(abs(sensors(:,i)-sensors(:,j))) <= k && tempStrategy(j) ==1 && energy(j)>=1
            tDi = [tDi ; dists(j,:)];
            energyStack = [energyStack;energy(j)+sum(abs(sensors(:,i)-sensors(:,j)))*lambda]; 
        end
    end
    
    utilityPrime =sum(max(tDi,[],1)) - sum(energyStack)*gamma ;
    regret = utilityPrime -utility;
    prob = max(regret,0);
    if prob >0
        strategy(i) =~strategy(i);
    end
      
  end
end
timeL =[timeL tUtility];

end
%convUtility =[convUtility;timeL]



x = sensors(1,:);
y = sensors(2,:);
x = x(strategy);
y = y(strategy);

plot(x,y,'ro')
hold on
%plot(targets(1,:),targets(2,:),'g.')
%end
plot(targets(1,:),targets(2,:),'b^')
drawnow
fig =figure()
x = 1:timeLength
plot(x,timeL)
drawnow
%xlabel('k-Neighbour')
%ylabel('Converged total network utiliy')

%drawnow

