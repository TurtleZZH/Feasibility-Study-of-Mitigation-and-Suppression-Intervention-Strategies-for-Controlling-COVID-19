%--------------------------------------------------------------------------
%   初始化 initialization
%--------------------------------------------------------------------------
clear;clc;
%---------------------------UK Mitigation Intervention---------------------
%--------------------------------------------------------------------------
%   参数设置 Parameter settings
%--------------------------------------------------------------------------
N = 66490000;                                                              %人口总数 Total population 
E = 0;                                                                     %潜伏者 Exposed
I = 3;                                                                     %传染者 Infected
S = N - I;                                                                 %易感者 Susceptible
R = 0;                                                                     %康复者 Recovered
Z = 3;                                                                     %累积的感染人数 Infected cases 
M = 3;                                                                     %轻症感染人数 mild cases
C = 0;                                                                     %中重症感染人数 serious cases
D = 0;                                                                     %死亡人数 death
Q = 0;                                                                     %总感染人数 total infected cases

r = 3;                                                                     %感染者接触易感者的人数 the number of persons infected who have been exposed to susceptible persons
B = 0.05249;                                                               %传染概率 infection probability
a = 1/6;                                                                   %潜伏者转化为感染者概率 probability of exposed to become infected 
r2 = 12;                                                                   %潜伏者接触易感者的人数 the number of exposed to susceptible
B2 = 0.05249;                                                              %潜伏者传染正常人的概率 probability of infected susceptible
y = 0.283;                                                                 %潜伏者自愈率 probability of recovered exposed
mild = 0.8;                                                                %轻症比例 proportion of mild critical cases 
severe_critical = 0.199;                                                   %中重症比例 proportion of severe critical cases 
critical = 0.061;                                                          %危重比例 proportion of critical critical cases 
ym = 1/7;                                                                  %轻症康复时间 mild recovery time for mild cases
yc = 1/14;                                                                 %中重症康复时间 Severe and critical case recovery time for mild cases
ac = 1/7;                                                                  %发现症状到重症一周时间 Symptoms were detected up to a week after serious illness
dc = 1/28;                                                                 %中重症死亡中位数28天 Severe and critical case number of death in hospital is 28
i = 0.924;                                                                 %隔离率 Isolation rate 


T = 1:350;
T1 = 1:96;
for idx = 1:length(T)-1
    r2(idx+1) = r2(idx);
    if idx>=35                                                             %以二月七日为起准，35日后即三月一十二日进行限制流通措施 Based on February 7th, 35 days later on March 12th to restrict circulation measures
        if r2(idx) ~= 8                                                    %强干预下，流通限制强从12到8，采取限制后每天减少两个人 Under strong intervention, the circulation limit is strong from 12 to 8, and two persons are reduced every day after taking the limit
            r2(idx+1) = r2(idx)-2;
        end
    end
    %易感者 susceptible
    S(idx+1) = S(idx) - r*B*S(idx)*(M(idx)+C(idx))/N(1) - i*r2(idx)*B2*S(idx)*E(idx)/N;                         
    %潜伏者 exposed
    E(idx+1) = E(idx) + r*B*S(idx)*(M(idx)+C(idx))/N(1)-a*E(idx) + i*r2(idx)*B2*S(idx)*E(idx)/N-y(idx)*E(idx);
    %轻症人数 mild cases
    M(idx+1) = M(idx) + a*E(idx) - ym*M(idx) - M(idx)*(severe_critical/mild)*ac;                                            
    %中重症患者人数 number of patients with serious illness
    C(idx+1) = C(idx) + M(idx)*(severe_critical/mild)*ac - yc*C(idx) - dc*C(idx)*(critical/severe_critical);                 
    %累计感染人数   Cumulative infected cases     
    Z(idx+1) = Z(idx) + a*E(idx);                                        
    %感染者 infected cases
    I(idx+1) = M(idx+1) + C(idx+1);                                       
    %累计死亡人数 cumulative death toll
    D(idx+1) = D(idx) + dc*C(idx)*(critical/severe_critical);            
    %累计治愈人数 cumulative recovered cases
    R(idx+1) = R(idx) + y(idx)*E(idx) + ym*M(idx) + yc*C(idx);                 
    %总感染人数是将总治愈人数加上总死亡人数 The total number of infections is the total number of people cured plus the total number of deaths
    Q(idx+1) = R(idx) + D(idx);                                  
    y(idx+1) = y(idx);
end

xlabel('Number of Days from 6th Feburary');ylabel('Number of People')
plot(T,E,T,I);grid on;
legend('Daily expoesd population','Daily infectious population')

hold on;
title('UK Mitigation Intervention SEIR model')