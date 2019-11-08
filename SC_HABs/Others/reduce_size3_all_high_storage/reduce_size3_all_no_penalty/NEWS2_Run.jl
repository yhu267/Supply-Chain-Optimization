## Reading data

# Set of nutrients and nutrient forms
E = ["P";"N"];
F = ["DI";"DO"];


# data needed
TIME = 1:15;
A = 529.81;                                 # watershed area (km2)
hw_frem = Dict(zip(E, [0.95;0.85]));        # fraction of E that is removed by WWTP
I = 370000/170000*130917;                   # population in the study area
WShw_E = Dict(zip(E, [0.0105;0.0875]));     # nutrients in human waste (kg/cap/week)
maxhw_frem_N = 0.9                          # maximum hw_frem["N"] that is observed in the country

rainfall = readdlm("rainfall.csv",',');     # rainfall matrix [mmH2O]
Q_stor0 = 0;                                # runof  stored in last week [mmH2O]

node_matrix = readdlm("ag_node_matrix.csv",',');    # read node matrix
crop_area   = readdlm("ag_node_area_crop",',');
NODES = node_matrix[:,1];                           # nodes
area  = Dict(zip(NODES, crop_area[:,2]));           # in acre;
crop  = Dict(zip(NODES, crop_area[:,3]));


Presult     = readdlm("P_results.csv");
Nresult     = readdlm("N_results.csv");

open("NEWS2_results.csv","w") do pr
    println(pr,"#TIME",",","N(kg)",",","P(kg)",",","Rnat(mH2O)",",","DIN (P)",",","DIN (NP)",",","DON (P)",",","DON (P)",",","DIP (P)",",","DIP (NP)",",","DOP (P)",",","DOP (P)");
for t in TIME
    include("NEWS2.jl");
    println(pr, t,",", Yield["DI","N"]+Yield["DO","N"],",",Yield["DI","P"]+Yield["DO","P"],",",Rnat,",",RSpnt_F["DI","N"],",",RSdif_explF["DI","N"],",",RSpnt_F["DO","N"],",",RSdif_explF["DO","N"],",",RSpnt_F["DI","P"],",",RSdif_explF["DI","P"],",",RSpnt_F["DO","P"],",",RSdif_explF["DO","P"]);
end
end 
