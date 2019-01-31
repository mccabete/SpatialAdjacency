
These are the functions that were used to generate the data files found in the Data folder. The logic for data generation was originally worked our and tested with the get_ratio_dist function. Because of the size of the rasters, this logic was pulled out of the function (and the other three function in this folder) and put into the cluster-tailored script dvm_code_v2.R. The dvm_code_v2.R script is what directly generated the data files. You can find the cluster-tailored scripts in the Remote_submission_script_folder. 

The get_ratio_basic was used for simulation (Found in the Simulation folder), and calls get_outer_edges.R, get_interior_vertices.R, and edge_to_interior.R . It is identical to get_ratio_dist, except that it sequences over disturbance types. 

We decided not to sequence over disturbance type in the analysis of LANDFIRE rasters because it strained our computational resources. However, it would prevent "mixed disturbance" clusters. 

Finally, in the paper we refer to the interior / total ratio. This interior/ total ratio is analogous to the edge-to-interior ratio mentioned in the code.  
