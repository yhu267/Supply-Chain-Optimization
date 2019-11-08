
for ii in ["0","5","10","15","20","25","30","35","40","45"]
    node_matrix = readdlm(ii*"/node_matrix.csv",',');
    #prod_matrix = readdlm("product_matrix.csv",',');
    NODES = 1:length(node_matrix[:,1]); # all nodes
    #PRODS = prod_matrix[:,1] # all products

    PRODS = ["p1";"p2";"p3"]

    node_lat = Dict(zip(NODES, node_matrix[:,3])); # node latitude
    node_long  = Dict(zip(NODES, node_matrix[:,4])); # node longtitude

    for pp in PRODS
        open(ii*"/flow_"*"$(pp)"*"_"*ii*".csv", "w") do ff
            print(ff,"To",",","Latitude",",","Longitude");
            println(ff,"");
        flow_matrix = readdlm(ii*"/flow_results_"*"$pp"*".csv",',');
        for j in NODES
            for i in NODES
                if flow_matrix[i+1,j+1] >= 0.1
                    println(ff,"n$j",",",node_lat[j],",",node_long[j]);
                    println(ff,"n$i",",",node_lat[i],",",node_long[i]);
                end
            end
        end
    end
    end
end
