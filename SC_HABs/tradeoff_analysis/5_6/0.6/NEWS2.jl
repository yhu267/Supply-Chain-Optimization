## NEWS2 Nutrient Fate and Transport Model (dissolved part)
##Coded by Yicheng Hu 2018-07


## Point source part
RSpnt_E = Dict(zip(E, zeros(length(E),1))); # point source emission of nutrient E (kg/2week)
for e in E
    RSpnt_E[e] = (1-hw_frem[e])*I*WShw_E[e];
end

FE_pntF = Dict(("DI","N") => 0.485 + 0.255*(hw_frem["N"]/ maxhw_frem_N), ("DO","N") => 0.14, ("DI","P") => 1, ("DO","P") => 0.01);
RSpnt_F = Dict((F[1],E[1]) => 0.1);         # point source emission of nutrient form F (kg/2week)
for f in F
    for e in E
        RSpnt_F[(f,e)] = FE_pntF[f,e]*RSpnt_E[e];
    end
end

## Non-point source part
# rainfall and runoff
# input data, define variables
R_day   = rainfall[(t-1)*14+1:(t-1)*14+14,2];  # rainfall data in each day [mmH2O]
S       = zeros(14,1);                       # rainfall retention parameter [mmH2O]
CN      = 70*ones(14,1);                     # curve number for the day
Qp_surf = zeros(14,1);                       # generated runoff in each day [mmH2O]
Q_surf  = zeros(14,1);                       # runoff that reached river in each day [mmH2O]
Q_stor  = zeros(14,1);                       # runoff store in each day [mmH2O]
surlag  = 3.64                              # surface runoff lag coefficient (using global average) [day]
tc      = zeros(14,1);                       # time of concentration [hr]
l       = 109361;                           # we use 1/3 of the Yahara river  [ft]
Y       = (318-236)/55.66/10                # average slope of Yahara river [%]
for i in 1:14
    S[i]        = 25.4*(1000/CN[i] - 10);
    tc[i]       = l^0.8*(S[i]/25.4+1)^0.7/(1140*Y^0.5)/24;          # convert to [day]
    Qp_surf[i]  = (R_day[i] - 0.2*S[i])^2/(R_day[i] + 0.8*S[i]);
    if i == 1
        Q_surf[i] = (Qp_surf[i] + Q_stor0)*(1-exp(-surlag/tc[i]));
        Q_stor[i] = Q_stor0 + Qp_surf[i] - Q_surf[i];
    else
        Q_surf[i] = (Qp_surf[i] + Q_stor[i-1])*(1-exp(-surlag/tc[i]));
        Q_stor[i] = Q_stor[i-1] + Qp_surf[i] - Q_surf[i];
    end
end
Q_stor0 = Q_stor[end];
Rnat    = sum(Q_surf)*52.1/1000/2           # annualize the runoff [mH2O]

# the inexplicit non-point source
f_F = Dict(("DI","N") => Rnat^1, ("DO","N") => Rnat^0.95, ("DI","P") => (1+(Rnat/0.85)^(-2))^-1, ("DO","P") => Rnat^0.95);
EC_F = Dict(("DI","N") => 0, ("DO","N") => 280, ("DI","P") => 26, ("DO","P") => 15);
RSdif_ecF = Dict((F[1],E[1]) => 0.1);      # emission to rivers from inexplicit non-point sources (kg/year)
for e in E
    for f in F
        RSdif_ecF[(f,e)] = A*f_F[f,e]*EC_F[f,e]/52.1*2;  # (kg/2week)
    end
end


# the explicit non-point source
# human activity part
WSdif_feE = Dict((NODES[1], E[1]) => 0);          # non point source due to fertilizers in each node
WSdif_maE = Dict((NODES[1], E[1]) => 0.1);          # non point source due to animal manure
WSdif_fixantE = Dict((NODES[1], E[1]) => 0.1);      # non point source due to fixation by crops
WSdif_depantE = Dict((NODES[1], E[1]) => 0.1);      # non point source due to deposition by crops
WSdif_exE = Dict((NODES[1], E[1]) => 0);          # withdraw of E in crops and animal grazing [kg E/week]
for i in 1:length(NODES)
    for e in 1:length(E)
        WSdif_feE[(NODES[i],E[e])] = 0;
        WSdif_maE[(NODES[i],E[e])] = (E[e] == "P")*Presult[i,t+1]*1000 + (E[e] == "N")*Nresult[i,t+1]*1000;
        WSdif_fixantE[(NODES[i],E[e])] = (E[e] == "P")*0 + (E[e] == "N")*area[NODES[i]]*((crop[NODES[i] == 5])*25/20.71*2/2.471054 + (crop[NODES[i] == 1])*5/24.14*2/2.471054 +(crop[NODES[i] == 36])*5/17.43*2/2.471054 +(crop[NODES[i] == 176])*5/16.14*2/2.471054 +(crop[NODES[i] == 24])*5/17.57*2/2.471054*0.7) ;  # 25kg/ha/year, 20.71 week, double week, 1 ha = 2.47 ac
        WSdif_depantE[(NODES[i],E[e])] = (E[e] == "P")*0 + (E[e] == "N")*area[NODES[i]]*0.04795*14/2.471054;
        WSdif_exE[(NODES[i],E[e])] = 0;
    end
end

WSdif_antE = Dict(zip(E, zeros(2,1)));      # diffuse source due to human activities [kg/2week]
for e in E
    WSdif_antE[e] = 52.1/2*sum(max(WSdif_feE[n,e] + WSdif_maE[n,e] + WSdif_fixantE[n,e] + WSdif_depantE[n,e] - WSdif_exE[n,e], 0) for n in NODES); #annualize
end


e_F = Dict(("DI","N") => 0.94, ("DO","N") => 0.01, ("DI","P") => 0.29, ("DO","P") => 0.01);
FE_wsF = Dict((F[1],E[1]) => 0.1);
for f in F
    for e in E
        FE_wsF[(f,e)] =  f_F[f,e]* e_F[f,e];
    end
end

# natural activity part
WSdif_natE = Dict(zip(E,zeros(2,1)));       # diffuse source due to natural activities [kg/2week]
for e in E
    WSdif_natE[e] = 1/6*WSdif_antE[e];      # assume the natural nutrient release is 1/6 of the anthropogenic part (cite report)
end
e_natF = Dict(("DI","N") => 0.1, ("DO","N") => 0.01, ("DI","P") => 0.29, ("DO","P") => 0.01);
FE_wsnatF = Dict((F[1],E[1]) => 0.1);
for f in F
    for e in E
        FE_wsnatF[(f,e)] =  f_F[f,e]* e_natF[f,e];
    end
end

RSdif_explF = Dict((F[1],E[1]) => 0.1);    # emission to rivers from explicit non-point sources (kg/week)
for e in E
    for f in F
        RSdif_explF[(f,e)] = (FE_wsnatF[(f,e)]*WSdif_natE[e] + FE_wsF[(f,e)]*WSdif_antE[e])/52.1*2;
    end
end

Yield = Dict((F[1],E[1]) => 0.1);           # total emission to rivers (kg/2week)
for e in E
    for f in F
        Yield[f,e] = RSdif_explF[(f,e)] + RSpnt_F[(f,e)];
    end
end
