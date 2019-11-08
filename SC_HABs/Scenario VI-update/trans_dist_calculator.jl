## Supply Chain Optimization Model for transportation routing and technology placement
## Add time dimension
## Coded by Yicheng Hu 2018-07

## Reading data
node_matrix       = readdlm("ag_node_matrix.csv",',');
supply_matrix     = readdlm("supply_matrix.csv",',');
demand_matrix     = readdlm("ag_demand_matrix.csv",',');
inventory_matrix  = readdlm("inventory_matrix.csv",',');
technology_matrix = readdlm("technology_matrix.csv",',');
product_matrix    = readdlm("product_matrix.csv",',');
alpha_matrix      = readdlm("alpha_matrix.csv",',');
Plimit_matrix     = readdlm("ag_Plimit_matrix.csv",',');
Nlimit_matrix     = readdlm("ag_Nlimit_matrix.csv",',');


## Define sets
NODES = node_matrix[:,1];
arg1 = 270;

SUPS  = supply_matrix[:,1];
DEMS  = demand_matrix[:,1];
TECHS = technology_matrix[:,1];
PRODS = product_matrix[:,1];
INVS   = inventory_matrix[:,1];
TIME  = 1:15 # From April to October
NODES_N = NODES[1:arg1]     # nodes that cannot be candidates for technologies
NODES_C = NODES[arg1+1:end] # nodes that can be candidates for technologies


## Define dictionaries
node_lat   = Dict(zip(NODES, node_matrix[:,2]));           # latitude of each node
node_long  = Dict(zip(NODES, node_matrix[:,3]));           # longitude of each node


prod_trans = Dict(zip(PRODS, product_matrix[:,3]));        # transportation cost of each product $/km/tonne
prod_P     = Dict(zip(PRODS, product_matrix[:,4]));        # phsphorus release coefficient of each product kg/kg
prod_N     = Dict(zip(PRODS, product_matrix[:,5]));        # nitrogen release coefficient of each product kg/kg

tech_ref   = Dict(zip(TECHS, technology_matrix[:,2]));     # reference product of each technology (with alpha = -1)
tech_cap   = Dict(zip(TECHS, 2*technology_matrix[:,3]));     # technlogy capacity (tonne/week)
tech_op    = Dict(zip(TECHS, technology_matrix[:,4]));     # operational cost of each technology $/tonne ref prod
tech_inv   = Dict(zip(TECHS, technology_matrix[:,5]));     # investment cost of each technology $

inv_node   = Dict(zip(INVS, inventory_matrix[:,2]));        # node for the storage system
inv_prod   = Dict(zip(INVS, inventory_matrix[:,3]));        # product type for the storage system
inv_cap    = Dict(zip(INVS, 1.5*inventory_matrix[:,4]/1000));   # inventory capacity tonne

sup_node   = Dict(zip(SUPS, supply_matrix[:,2]));          # node for the supply source
sup_prod   = Dict(zip(SUPS, supply_matrix[:,3]));          # product type of the supply source
sup_time   = Dict(zip(SUPS, supply_matrix[:,5]));          # supply time
sup_value  = Dict(zip(SUPS, 2*1.5*supply_matrix[:,4]/1000));          # amount of the supplied product tonne, 1.5 consider water used for washing
sup_price  = Dict(zip(SUPS, supply_matrix[:,6]));          # price of the supplied product $/tonne

dem_node   = Dict(zip(DEMS, demand_matrix[:,2]));          # node for the demand sink
dem_prod   = Dict(zip(DEMS, demand_matrix[:,3]));          # product type of demanded product
dem_time   = Dict(zip(DEMS, demand_matrix[:,5]));          # demand time
dem_cap    = Dict(zip(DEMS, 2*demand_matrix[:,4]));          # maximum capacity of the required product tonne
dem_price  = Dict(zip(DEMS, demand_matrix[:,6]));          # price of the demanded product $/tonne

R = 6335.439

# stoichiometric coefficient
α = Dict(("tA1","p1") => 0.5);         #Just used as an initiator to set up the dictionary with two keys
for t in 1:length(TECHS)
    for pr in 1: length(PRODS)
        α[(TECHS[t], PRODS[pr])] = alpha_matrix[t,pr];
    end
end

# distance between nodes
D = Dict(("n1", "n2") => 1.1);
for i in NODES
  for j in NODES
    D[(i, j)] = 2*R*asin(sqrt(sin((node_lat[j] - node_lat[i])*pi/2/180)^2 + cos(node_lat[j]*pi/180)*cos(node_lat[i]*pi/180)*sin((node_long[j] - node_long[i])*pi/2/180)^2)); ## Using the Haversine formula
  end
end

Plimit = Dict(("n1",1) => 0.1);
Nlimit = Dict(("n1",1) => 0.1);
for i in 1:length(NODES)
    for τ in TIME
        Plimit[(NODES[i],τ)] = Plimit_matrix[i,τ+1];
        Nlimit[(NODES[i],τ)] = Nlimit_matrix[i,τ+1];
    end
end

transport_distance = []

p1_flow_matrix = readdlm("flow_results_p1.csv",',');
p2_flow_matrix = readdlm("flow_results_p2.csv",',');
p3_flow_matrix = readdlm("flow_results_p3.csv",',');

for i in 1:length(NODES)
    for j in 1:length(NODES)
        if p1_flow_matrix[i+1,j+1] >= 0.1
            append!(transport_distance, D[NODES[i],NODES[j]])
        end
        if p2_flow_matrix[i+1,j+1] >= 0.1
            append!(transport_distance, D[NODES[i],NODES[j]])
        end
        if p3_flow_matrix[i+1,j+1] >= 0.1
            append!(transport_distance, D[NODES[i],NODES[j]])
        end

    end
end

println("Average Transport Distance: ", mean(transport_distance))
println("Active Routes ", length(transport_distance))
