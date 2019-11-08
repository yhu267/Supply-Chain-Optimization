# i = "0"
for i in ["0","5","10","15","20","25","30","35","40","45"]
	node_matrix = readdlm(i*"/node_matrix.csv",',')
	P_matrix = readdlm(i*"/P_results.csv", ',');
	node = P_matrix[:,1];
	P_limit = P_matrix[:,2];
	P_amount = P_matrix[:,3];
	latitude = node_matrix[:,3];
	longitude = node_matrix[:,4];
	N = length(node)
	P_limit_m = zeros(N,1);
	P_excess = zeros(N,1);
	DE_compare = zeros(N,1);
	indicator = zeros(N,1);
	log10indicator = zeros(N,1);
	for j in 1:N
		P_limit_m[j] = P_limit[j] + (P_limit[j]==0);	
		P_excess[j] = P_limit[j] - P_amount[j];
		DE_compare[j] = P_amount[j] > P_limit[j];
		indicator[j] = (P_amount[j]/P_limit_m[j])*(DE_compare[j]) + (1-DE_compare[j])*1;
		log10indicator[j] = log10(indicator[j]);
	end
	open(i*"/P_results_"*i*".csv","w") do pr
		print(pr, "#node", ",", "latitude", ",", "longitude", ",", "P amount", ",", "P-limit", ",", "P limit modified", ",", "P excess", ",", "DE compare", ",", "indicator", ",", "log10(indicator)")
		for j in 1:N
			println(pr)
			print(pr, node[j], ",", latitude[j], ",", longitude[j], ",", P_amount[j], ",", P_limit[j], ",", P_limit_m[j], ",", P_excess[j], ",", DE_compare[j], ",", indicator[j], ",", log10indicator[j])
		end
	end
end
