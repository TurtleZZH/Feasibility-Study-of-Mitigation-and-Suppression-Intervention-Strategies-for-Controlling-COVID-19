%--------------------------------------------------------------------------
%   ��ʼ�� initialization
%--------------------------------------------------------------------------
clear;clc;
%---------------------------UK Multiple Intervention-----------------------
%--------------------------------------------------------------------------
%   �������� Parameter settings
%--------------------------------------------------------------------------
N = 66490000;                                                              %�˿����� Total population 
E = 0;                                                                     %Ǳ���� Exposed
I = 3;                                                                     %��Ⱦ�� Infected
S = N - I;                                                                 %�׸��� Susceptible
R = 0;                                                                     %������ Recovered
Z = 3;                                                                     %�ۻ��ĸ�Ⱦ���� Infected cases 
M = 3;                                                                     %��֢��Ⱦ���� mild cases
C = 0;                                                                     %����֢��Ⱦ���� serious cases
D = 0;                                                                     %�������� death
Q = 0;                                                                     %�ܸ�Ⱦ���� total infected cases

r = 3;                                                                     %��Ⱦ�߽Ӵ��׸��ߵ����� the number of persons infected who have been exposed to susceptible persons
B = 0.05249;                                                               %��Ⱦ���� infection probability
a = 1/6;                                                                   %Ǳ����ת��Ϊ��Ⱦ�߸��� probability of exposed to become infected 
r2 = 12;                                                                   %Ǳ���߽Ӵ��׸��ߵ����� the number of exposed to susceptible
B2 = 0.05249;                                                              %Ǳ���ߴ�Ⱦ�����˵ĸ��� probability of infected susceptible
y = 0.283;                                                                 %Ǳ���������� probability of recovered exposed
mild = 0.8;                                                                %��֢���� proportion of mild critical cases 
severe_critical = 0.199;                                                   %����֢���� proportion of severe critical cases 
critical = 0.061;                                                          %Σ�ر��� proportion of critical critical cases 
ym = 1/7;                                                                  %��֢����ʱ�� mild recovery time for mild cases
yc = 1/14;                                                                 %����֢����ʱ�� Severe and critical case recovery time for mild cases
ac = 1/7;                                                                  %����֢״����֢һ��ʱ�� Symptoms were detected up to a week after serious illness
dc = 1/28;                                                                 %����֢������λ��28�� Severe and critical case number of death in hospital is 28
i = 0.924;                                                                 %������ Isolation rate 
u = 6;%�Ͻ� upper bound
m = 4.5;%��λ median
d = 3;%�½� lower bound

T = 1:500;
T1 = 1:96;
for idx = 1:length(T)-1
    r2(idx+1) = r2(idx);
    %ÿ���ܷ���3-4.5-6-4.5-3 Scaling every two weeks 3-4.5-6-4.5-3
    if idx>=427
        r2(idx+1) = d;
    elseif idx>=413
        r2(idx+1) = m;
    elseif idx>=399
       r2(idx+1) = d;
    elseif idx>=385                                                                                               
        r2(idx+1) = m;
    elseif idx>=371
       r2(idx+1) = u;
    elseif idx>=357
        r2(idx+1) = m;
    elseif idx>=343
        r2(idx+1) = d;
    elseif idx>=329                                                                                               
        r2(idx+1) = m;
    elseif idx>=315                                                                                               
        r2(idx+1) = u;
    elseif idx>=301                                                                                               
        r2(idx+1) = m;
    elseif idx>=287                                                                                               
        r2(idx+1) = d;
    elseif idx>=273                                                                                               
        r2(idx+1) = m;
    elseif idx>=258                                                                                               
        r2(idx+1) = u;
    elseif idx>=245                                                                                               
        r2(idx+1) = m;
    elseif idx>=231                                                                                               
        r2(idx+1) = d;
    elseif idx>=217                                                                                              
        r2(idx+1) = m;
    elseif idx>=203                                                                                              
        r2(idx+1) = u;
    elseif idx>=189                                                                                               
        r2(idx+1) = m;
    elseif idx>=175                                                                                              
        r2(idx+1) = d;
    elseif idx>=161                                                                                             
        r2(idx+1) = m;
    elseif idx>=147                                                                                             
        r2(idx+1) = u;
    elseif idx>=133                                                                                              
        r2(idx+1) = m;
    elseif idx>=119                                                                                              
        r2(idx+1) = d;
    elseif idx>=105                                                                                               
        r2(idx+1) = m;
    elseif idx>=91                                                                                               
        r2(idx+1) = u;
    elseif idx>=77                                                                                               
        r2(idx+1) = m;
    elseif idx>=63                                                                                               
        r2(idx+1) = d;
    elseif idx>=49                                                                                               
        r2(idx+1) = m;    
    elseif idx>=35                                                         %�Զ�������Ϊ��׼��35�պ�����һʮ���ս���������ͨ������ʩ Based on February 7th, 35 days later, March 12th will be implemented to restrict circulation and deflation measures
        if r2(idx) ~= u                                                    %ǿ��Ԥ�£���ͨ����ǿ��12��6����ȡ���ƺ�ÿ����������� Strong intervention, circulation restrictions are strong from 12 to 6, and two people are reduced every day after taking the restrictions
            r2(idx+1) = r2(idx)-2;
        end
    end
   %�׸��� susceptible
    S(idx+1) = S(idx) - r*B*S(idx)*(M(idx)+C(idx))/N(1) - i*r2(idx)*B2*S(idx)*E(idx)/N;                         
    %Ǳ���� exposed
    E(idx+1) = E(idx) + r*B*S(idx)*(M(idx)+C(idx))/N(1)-a*E(idx) + i*r2(idx)*B2*S(idx)*E(idx)/N-y(idx)*E(idx);
    %��֢���� mild cases
    M(idx+1) = M(idx) + a*E(idx) - ym*M(idx) - M(idx)*(severe_critical/mild)*ac;                                            
    %����֢�������� number of patients with serious illness
    C(idx+1) = C(idx) + M(idx)*(severe_critical/mild)*ac - yc*C(idx) - dc*C(idx)*(critical/severe_critical);                 
    %�ۼƸ�Ⱦ����   Cumulative infected cases     
    Z(idx+1) = Z(idx) + a*E(idx);                                        
    %��Ⱦ�� infected cases
    I(idx+1) = M(idx+1) + C(idx+1);                                       
    %�ۼ��������� cumulative death toll
    D(idx+1) = D(idx) + dc*C(idx)*(critical/severe_critical);            
    %�ۼ��������� cumulative recovered cases
    R(idx+1) = R(idx) + y(idx)*E(idx) + ym*M(idx) + yc*C(idx);                 
    %�ܸ�Ⱦ�����ǽ������������������������� The total number of infections is the total number of people cured plus the total number of deaths
    Q(idx+1) = R(idx) + D(idx);                                  
    y(idx+1) = y(idx);
end

xlabel('Number of Days from 6th Feburary');ylabel('Number of People')
plot(T,E,T,I);grid on;
legend('Daily expoesd population','Daily infectious population')

hold on;
title('UK Multiple Intervention SEIR model')