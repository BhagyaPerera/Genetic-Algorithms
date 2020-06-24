function [] = videoSelection()
clc;
clear;




xx = [1 2 3 4 5 6 7 8 9 10; 800 700 650 750 600 900 950 875 1050 1500;121 95 85 100 78 125 130 128  135 120];
dataMat = xx'
n = 10;
[chromosome] = init_pop(n)
size=zeros([1 20])
bestFitness=zeros([1 20])

PlayTimes=zeros([1 20])
bestchromosomes=zeros([20,10])
time=zeros([1 20])

for epoch=1:20

 tic
 for itr=1:100

 max_fitness=zeros([1 100])
 Size_iteration=zeros([1 100])
 [fitness, cdSize] = evaluateFitness(chromosome,dataMat,n)%Evaluate fitness of chromosomes
 crossedChromo = doCrossover(chromosome,fitness,n)%crossing over
 [mutatedChromo] = doMutation(crossedChromo,n)% doing mutation
 chromosome = mutatedChromo;
 [val,idx]=max(fitness)
 max_fitness(itr)=val
 Size_iteration(itr)=cdSize(idx)
 
 end
 time[epoch]=toc
  
 figure(1)
 plot(max_fitness)
 xlabel('iterations')
 ylabel('best fitness value')
 title('Best fitness values against the iteration for a particular run')


 figure(3)
 plot(Size_iteration)
 xlabel('iterations')
 ylabel('size')
 title('file size of most fitted chromosome against the iterations')
 
 

 [fitness, cdSize] = evaluateFitness(chromosome,dataMat,n);%finding fitness of the final population
 [bestChromoFitness, ind]= max(fitness)% finding maximum fitness
 bestFitness(epoch)=max(fitness)
 size(epoch)=cdSize(ind)
 bestchromosomes(epoch,:)=chromosome(ind,:)
 playTime = dataMat(:,3)
 PlayTimes(epoch)=playTime(ind)
 
 
end

disp(bestchromosomes)
disp(bestFitness)
disp(size)

figure(2)
plot(bestFitness)
xlabel('run')
ylabel('best fitness value')
title('Best fitness values against the runs')


figure(4)
plot(size)
xlabel('epochs')
ylabel('file size')
title('Plot of the file size of most fitted chromosome against the runs')
xlim([0 20])

figure(5)
plot(PlayTimes)
xlabel('run')
ylabel('PlayTime')
title('PlayTime against the runs')

figure(6)
plot(time)
xlabel('run')
ylabel('running time')
title('running time against run')



function [chromosome] = init_pop(n)%creating initial population in the binary format
for i=1:n
chromosome(i,:) = randi([0, 1], 1,10);
end


function [fitness cdSize] = evaluateFitness(chromosome,dataMat,n)
playTime = dataMat(:,3)
fileSize = dataMat(:,2)
lenPlayTimeData = length(playTime)
for j=1:n
    sum = 0;
    sumFilesize = 0;
    for k=1:lenPlayTimeData
        sum = sum +(chromosome(j,k).*playTime(k));%getting the total playtime of a chromosome
        sumFilesize = sumFilesize + (chromosome(j,k).*fileSize(k)); %getting the total filesize of a chromosome
    end
    fitness(j) = sum;
    cdSize(j) = sumFilesize;
   %calculating fitness according to the total file size
    if cdSize(j)<=4500
        fitness(j) = sum;
    else
        fitness(j) = 0.1*sum;
    end
    
end
% rank selection to select a perticular chromosome
function[selectedChromo] = doRankSelection (chromosome,fitness,n)

[fitnessVal indexVal] = sort(fitness);

convertedChromo = chromosome(indexVal,:);

rank =(1:1:10);
sumOfRanks = sum(rank);

randomVal = sumOfRanks*rand();
    sumVal=0;
    for gg=1:n
        sumVal = sumVal + rank(gg);
        if (sumVal >= randomVal)
            selectedChromosomePosition = gg;
            break;
        end
       
    end
selectedChromo = convertedChromo(selectedChromosomePosition,:);



function[crossedChromo] = doCrossover(chromosome,fitness,n)
for i = 1:2:n
parent1  =  doRankSelection (chromosome,fitness,n);
parent2 =  doRankSelection (chromosome,fitness,n);

randProbofCross = 0.75;

if rand()<=randProbofCross %(crossing)
 pointToCross = randi(9);%selecting a position randomly as the crossover point
 C1part1 = parent1(1:pointToCross);
 C1part2 = parent2(pointToCross+1:10);
 child1 = [C1part1 C1part2];
 
 C2part1 = parent2(1:pointToCross);
 C2part2 = parent1(pointToCross+1:10);
 child2 = [C2part1 C2part2];

else%(Cloning)
child1 = parent1;
child2 = parent2;
end

crossedChromo (i,:) = child1;
crossedChromo (i+1,:) = child2;
end

function[mutatedChromo] = doMutation(crossedChromo,n)
muteProb = 0.1;
for i=1:n
    for j = 1:10
        if(rand()<=muteProb)
            if(crossedChromo(i,j)==0)
            crossedChromo(i,j) = 1;
            else
            crossedChromo(i,j) = 0;  
            end
        else
           crossedChromo(i,j) = crossedChromo(i,j); 
        end
    end
    mutatedChromo(i,:) = crossedChromo(i,:);
end