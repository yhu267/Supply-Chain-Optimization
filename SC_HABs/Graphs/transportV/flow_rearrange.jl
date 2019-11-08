node_matrix = readdlm("ag_node_matrix.csv",',');
#prod_matrix = readdlm("product_matrix.csv",',');
NODES = 1:length(node_matrix[:,1]); # all nodes
#PRODS = prod_matrix[:,1] # all products

PRODS = ["p2_1";"p2_2";"p2_3";"p2_4";"p2_5";"p2_6";"p2_7";"p2_8";"p2_9";"p2_10";"p2_11";"p2_12";"p2_13";"p2_14";"p2_15"]

node_lat = Dict(zip(NODES, node_matrix[:,2])); # node latitude
node_long  = Dict(zip(NODES, node_matrix[:,3])); # node longtitude

for pp in PRODS
    open("flow_"*"$(pp)"*".csv", "w") do ff
        print(ff,"To",",","Latitude",",","Longtitude",",","From",",","Flow");
        println(ff,"");
    flow_matrix = readdlm("flow_results_"*"$pp"*".csv",',');
    for j in NODES
        for i in NODES
            if flow_matrix[i+1,j+1] >= 0.1
                println(ff,"n$j",",",node_lat[j],",",node_long[j],",","n$i",",",flow_matrix[i+1,j+1]);
                println(ff,"n$i",",",node_lat[i],",",node_long[i],",","","");
            end
        end
    end
end
end
