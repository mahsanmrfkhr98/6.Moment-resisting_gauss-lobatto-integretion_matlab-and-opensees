# Clear Previous Data
#length [in ]force [lb]
wipe
######################################################################################################################################################################################################

# Define Model Properties: model  BasicBuilder  -ndm  Number_of_Dimensions  -ndf  Nunber_of_DoFs_in_Each_Node
						   model  BasicBuilder  -ndm         2              -ndf              3
######################################################################################################################################################################################################						   
						   
# Define Nodes 
	# Create the actual nodes: node  node#   x[in]     y[in]
					           node    1       0.00      0.0
					           node    2      85.76    156.0
					           node    3     205.76    156.0
                               node    4     445.76    156.0
                               node    5     445.76     36.0
							   
#####################################################################################################################################################################################################							   
							   
	# Assign actual nodes to a Group: region  Region#  -Type   Target_Nodes 
				   			          region    1      -node    1 2 3 4 5	
									  
#####################################################################################################################################################################################################									  

	# Set Restrained DoFs: fix  Node#  X_Restrained   Y_Restrained  Rotation_Restrained
						   fix    1         1               1                1
					       fix    5         1               1                1
						   
######################################################################################################################################################################################################						   

# Define Elements
	# Create Bilinear Material: uniaxialMaterial  Steel01  Material#  Fy[psi]    E[psi]    alpha[-]  
						        uniaxialMaterial  Steel01     1       36000.0  30000000.0   0.02
								
								
#####################################################################################################################################################################################################						       
								
	# Create Cross-section for Beam-Column Elements:  section  Fiber  section#  {  patch  Type(circ/rect/quad)  Assigned_Material#  Number_of_Fibers_in_Width  Number_of_Fibers_in_Height Y1 X1 Y2  X2  Y3 X3}  Y4  X4 }
                                                      section  Fiber     1      {  patch                 quad           1                       6                          2               -6.0   -15.0    6.0    -15.0    6.0    15.0    -6.0    15.0   }
                                                      section  Fiber     2      {  patch                 quad           1                       6                          2               -7.0   -15.0    7.0    -15.0    7.0    15.0    -7.0    15.0   }
                                                      section  Fiber     3      {  patch                 quad           1                       6                          2               -7.0   -15.0    7.0    -15.0    7.0    15.0    -7.0    15.0   }
                                                      section  Fiber     4      {  patch                 quad           1                       6                          2               -8.0   -12.0    8.0    -12.0    8.0    12.0    -8.0    12.0   }
													  
######################################################################################################################################################################################################													  

	# Create Geometric Transformer :    geomTransf  Type[Linear/PDelta]  Transformer#	
	                                    geomTransf       Linear               1
                                        geomTransf       Linear               2
                                        geomTransf       Linear               3
	                                    geomTransf       Linear               4
										
######################################################################################################################################################################################################										
																
																					
	# Create Beam-Column Elements:                    element  dispBeamColumn  Element#   LNode        RNode       NumberOfIntegrationPoints  section  num.Transformer integration  TYPe of Integration
                                                      element  dispBeamColumn     1          1           2                   4                   1           1        -integration      Lobatto
                                                      element  dispBeamColumn     2          2           3                   4                   2           2        -integration      Lobatto
                                                      element  dispBeamColumn     3          3           4                   4                   3           3        -integration      Lobatto
                                                      element  dispBeamColumn     4          4           5                   4                   4           4        -integration      Lobatto
													  
#######################################################################################################################################################################################################													  
													  													  
	# Assign Elements to a Group:  region  Region#  -Type  Target_Elements 
				   			       region    2      -ele        1 2 3 4
								   
#######################################################################################################################################################################################################								   

# Define Loads
	# Create a Linear Loading TimeSeries: timeSeries  Linear  TimeSeries#
								          timeSeries  Linear      1
									 
	# Create a Plain load pattern associated with the TimeSeries: pattern  Plain  pattern#  Assigned_TimeSeries#  {
																  pattern  Plain     1              1             {
	# Create  loads:         																					     load  Node#  X_Value         Y_Value      Moment_Value
																												     load    2     2100.0          0.0               0.0
																												     load    3        0.0       -300.0               0.0
																												     load    4        0.0          0.0            -100.0
																												  }

# Define Analysis Parameters																							  
							system SparseGeneral
							numberer RCM
							constraints Transformation 	
#                 Reminder: integrator LoadControl  Magnitude_of_Load_Increase_in_Each_Step							
							integrator LoadControl                     1.0					
                            test EnergyIncr 0.00001 5000000 0
							algorithm Newton
							analysis Static
							
# Create Output Files
	# Output File for Nodal     :    recorder  Node     -file  Output_File_Name             -time[?]  -node/Region  Node/Region#     -dof  Target_DoFs  Type
									 recorder  Node     -file  OSFCNodalDisplacements.txt             -region           1            -dof     1 2 3     disp
									 recorder  Node     -file  OSFCNodalReactions.txt                 -region           1            -dof     1 2 3     reaction
																						    
	# Output File for Elements  : recorder  Element  -file  Output_File_Name             -time[?]  -ele/Region   Element/Region#                     Type
                                     recorder  Element  -file  OSFCElementsCurvatures.txt             -region              2                            section deformation
									 
									 
                                     recorder  Element  -file  Element1section1Fiber11stressstrain.txt      -ele  1      section  1      fiber 1 1      stressStrain
                                     recorder  Element  -file  Element1section1Fiber12stressstrain.txt      -ele  1      section  1      fiber 1 2      stressStrain
                                     recorder  Element  -file  Element1section1Fiber21stressstrain.txt      -ele  1      section  1      fiber 2 1      stressStrain
                                     recorder  Element  -file  Element1section1Fiber22stressstrain.txt      -ele  1      section  1      fiber 2 2      stressStrain									 
                                     recorder  Element  -file  Element1section1Fiber31stressstrain.txt      -ele  1      section  1      fiber 3 1      stressStrain
                                     recorder  Element  -file  Element1section1Fiber32stressstrain.txt      -ele  1      section  1      fiber 3 2      stressStrain
                                     recorder  Element  -file  Element1section1Fiber41stressstrain.txt      -ele  1      section  1      fiber 4 1      stressStrain
                                     recorder  Element  -file  Element1section1Fiber42stressstrain.txt      -ele  1      section  1      fiber 4 2      stressStrain
                                     recorder  Element  -file  Element1section1Fiber51stressstrain.txt      -ele  1      section  1      fiber 5 1      stressStrain									 
                                     recorder  Element  -file  Element1section1Fiber52stressstrain.txt      -ele  1      section  1      fiber 5 2      stressStrain
                                     recorder  Element  -file  Element1section1Fiber61stressstrain.txt      -ele  1      section  1      fiber 6 1      stressStrain
                                     recorder  Element  -file  Element1section1Fiber62stressstrain.txt      -ele  1      section  1      fiber 6 2      stressStrain
                                     recorder  Element  -file  Element1section2Fiber11stressstrain.txt      -ele  1      section  2      fiber 1 1      stressStrain
                                     recorder  Element  -file  Element1section2Fiber12stressstrain.txt      -ele  1      section  2      fiber 1 2      stressStrain
                                     recorder  Element  -file  Element1section2Fiber21stressstrain.txt      -ele  1      section  2      fiber 2 1      stressStrain
                                     recorder  Element  -file  Element1section2Fiber22stressstrain.txt      -ele  1      section  2      fiber 2 2      stressStrain									 
                                     recorder  Element  -file  Element1section2Fiber31stressstrain.txt      -ele  1      section  2      fiber 3 1      stressStrain
                                     recorder  Element  -file  Element1section2Fiber32stressstrain.txt      -ele  1      section  2      fiber 3 2      stressStrain
                                     recorder  Element  -file  Element1section2Fiber41stressstrain.txt      -ele  1      section  2      fiber 4 1      stressStrain
                                     recorder  Element  -file  Element1section2Fiber42stressstrain.txt      -ele  1      section  2      fiber 4 2      stressStrain
                                     recorder  Element  -file  Element1section2Fiber51stressstrain.txt      -ele  1      section  2      fiber 5 1      stressStrain									 
                                     recorder  Element  -file  Element1section2Fiber52stressstrain.txt      -ele  1      section  2      fiber 5 2      stressStrain
                                     recorder  Element  -file  Element1section2Fiber61stressstrain.txt      -ele  1      section  2      fiber 6 1      stressStrain
                                     recorder  Element  -file  Element1section2Fiber62stressstrain.txt      -ele  1      section  2      fiber 6 2      stressStrain
                                     recorder  Element  -file  Element1section3Fiber11stressstrain.txt      -ele  1      section  3      fiber 1 1      stressStrain
                                     recorder  Element  -file  Element1section3Fiber12stressstrain.txt      -ele  1      section  3      fiber 1 2      stressStrain
                                     recorder  Element  -file  Element1section3Fiber21stressstrain.txt      -ele  1      section  3      fiber 2 1      stressStrain
                                     recorder  Element  -file  Element1section3Fiber22stressstrain.txt      -ele  1      section  3      fiber 2 2      stressStrain									 
                                     recorder  Element  -file  Element1section3Fiber31stressstrain.txt      -ele  1      section  3      fiber 3 1      stressStrain
                                     recorder  Element  -file  Element1section3Fiber32stressstrain.txt      -ele  1      section  3      fiber 3 2      stressStrain
                                     recorder  Element  -file  Element1section3Fiber41stressstrain.txt      -ele  1      section  3      fiber 4 1      stressStrain
                                     recorder  Element  -file  Element1section3Fiber42stressstrain.txt      -ele  1      section  3      fiber 4 2      stressStrain
                                     recorder  Element  -file  Element1section3Fiber51stressstrain.txt      -ele  1      section  3      fiber 5 1      stressStrain									 
                                     recorder  Element  -file  Element1section3Fiber52stressstrain.txt      -ele  1      section  3      fiber 5 2      stressStrain
                                     recorder  Element  -file  Element1section3Fiber61stressstrain.txt      -ele  1      section  3      fiber 6 1      stressStrain
                                     recorder  Element  -file  Element1section3Fiber62stressstrain.txt      -ele  1      section  3      fiber 6 2      stressStrain
                                     recorder  Element  -file  Element1section4Fiber11stressstrain.txt      -ele  1      section  4      fiber 1 1      stressStrain
                                     recorder  Element  -file  Element1section4Fiber12stressstrain.txt      -ele  1      section  4      fiber 1 2      stressStrain
                                     recorder  Element  -file  Element1section4Fiber21stressstrain.txt      -ele  1      section  4      fiber 2 1      stressStrain
                                     recorder  Element  -file  Element1section4Fiber22stressstrain.txt      -ele  1      section  4      fiber 2 2      stressStrain									 
                                     recorder  Element  -file  Element1section4Fiber31stressstrain.txt      -ele  1      section  4      fiber 3 1      stressStrain
                                     recorder  Element  -file  Element1section4Fiber32stressstrain.txt      -ele  1      section  4      fiber 3 2      stressStrain
                                     recorder  Element  -file  Element1section4Fiber41stressstrain.txt      -ele  1      section  4      fiber 4 1      stressStrain
                                     recorder  Element  -file  Element1section4Fiber42stressstrain.txt      -ele  1      section  4      fiber 4 2      stressStrain
                                     recorder  Element  -file  Element1section4Fiber51stressstrain.txt      -ele  1      section  4      fiber 5 1      stressStrain									 
                                     recorder  Element  -file  Element1section4Fiber52stressstrain.txt      -ele  1      section  4      fiber 5 2      stressStrain
                                     recorder  Element  -file  Element1section4Fiber61stressstrain.txt      -ele  1      section  4      fiber 6 1      stressStrain
                                     recorder  Element  -file  Element1section4Fiber62stressstrain.txt      -ele  1      section  4      fiber 6 2      stressStrain

                                     recorder  Element  -file  Element2section1Fiber11stressstrain.txt      -ele  2      section  1      fiber 1 1      stressStrain
                                     recorder  Element  -file  Element2section1Fiber12stressstrain.txt      -ele  2      section  1      fiber 1 2      stressStrain
                                     recorder  Element  -file  Element2section1Fiber21stressstrain.txt      -ele  2      section  1      fiber 2 1      stressStrain
                                     recorder  Element  -file  Element2section1Fiber22stressstrain.txt      -ele  2      section  1      fiber 2 2      stressStrain									 
                                     recorder  Element  -file  Element2section1Fiber31stressstrain.txt      -ele  2      section  1      fiber 3 1      stressStrain
                                     recorder  Element  -file  Element2section1Fiber32stressstrain.txt      -ele  2      section  1      fiber 3 2      stressStrain
                                     recorder  Element  -file  Element2section1Fiber41stressstrain.txt      -ele  2      section  1      fiber 4 1      stressStrain
                                     recorder  Element  -file  Element2section1Fiber42stressstrain.txt      -ele  2      section  1      fiber 4 2      stressStrain
                                     recorder  Element  -file  Element2section1Fiber51stressstrain.txt      -ele  2      section  1      fiber 5 1      stressStrain									 
                                     recorder  Element  -file  Element2section1Fiber52stressstrain.txt      -ele  2      section  1      fiber 5 2      stressStrain
                                     recorder  Element  -file  Element2section1Fiber61stressstrain.txt      -ele  2      section  1      fiber 6 1      stressStrain
                                     recorder  Element  -file  Element2section1Fiber62stressstrain.txt      -ele  2      section  1      fiber 6 2      stressStrain
                                     recorder  Element  -file  Element2section2Fiber11stressstrain.txt      -ele  2      section  2      fiber 1 1      stressStrain
                                     recorder  Element  -file  Element2section2Fiber12stressstrain.txt      -ele  2      section  2      fiber 1 2      stressStrain
                                     recorder  Element  -file  Element2section2Fiber21stressstrain.txt      -ele  2      section  2      fiber 2 1      stressStrain
                                     recorder  Element  -file  Element2section2Fiber22stressstrain.txt      -ele  2      section  2      fiber 2 2      stressStrain									 
                                     recorder  Element  -file  Element2section2Fiber31stressstrain.txt      -ele  2      section  2      fiber 3 1      stressStrain
                                     recorder  Element  -file  Element2section2Fiber32stressstrain.txt      -ele  2      section  2      fiber 3 2      stressStrain
                                     recorder  Element  -file  Element2section2Fiber41stressstrain.txt      -ele  2      section  2      fiber 4 1      stressStrain
                                     recorder  Element  -file  Element2section2Fiber42stressstrain.txt      -ele  2      section  2      fiber 4 2      stressStrain
                                     recorder  Element  -file  Element2section2Fiber51stressstrain.txt      -ele  2      section  2      fiber 5 1      stressStrain									 
                                     recorder  Element  -file  Element2section2Fiber52stressstrain.txt      -ele  2      section  2      fiber 5 2      stressStrain
                                     recorder  Element  -file  Element2section2Fiber61stressstrain.txt      -ele  2      section  2      fiber 6 1      stressStrain
                                     recorder  Element  -file  Element2section2Fiber62stressstrain.txt      -ele  2      section  2      fiber 6 2      stressStrain
                                     recorder  Element  -file  Element2section3Fiber11stressstrain.txt      -ele  2      section  3      fiber 1 1      stressStrain
                                     recorder  Element  -file  Element2section3Fiber12stressstrain.txt      -ele  2      section  3      fiber 1 2      stressStrain
                                     recorder  Element  -file  Element2section3Fiber21stressstrain.txt      -ele  2      section  3      fiber 2 1      stressStrain
                                     recorder  Element  -file  Element2section3Fiber22stressstrain.txt      -ele  2      section  3      fiber 2 2      stressStrain									 
                                     recorder  Element  -file  Element2section3Fiber31stressstrain.txt      -ele  2      section  3      fiber 3 1      stressStrain
                                     recorder  Element  -file  Element2section3Fiber32stressstrain.txt      -ele  2      section  3      fiber 3 2      stressStrain
                                     recorder  Element  -file  Element2section3Fiber41stressstrain.txt      -ele  2      section  3      fiber 4 1      stressStrain
                                     recorder  Element  -file  Element2section3Fiber42stressstrain.txt      -ele  2      section  3      fiber 4 2      stressStrain
                                     recorder  Element  -file  Element2section3Fiber51stressstrain.txt      -ele  2      section  3      fiber 5 1      stressStrain									 
                                     recorder  Element  -file  Element2section3Fiber52stressstrain.txt      -ele  2      section  3      fiber 5 2      stressStrain
                                     recorder  Element  -file  Element2section3Fiber61stressstrain.txt      -ele  2      section  3      fiber 6 1      stressStrain
                                     recorder  Element  -file  Element2section3Fiber62stressstrain.txt      -ele  2      section  3      fiber 6 2      stressStrain
                                     recorder  Element  -file  Element2section4Fiber11stressstrain.txt      -ele  2      section  4      fiber 1 1      stressStrain
                                     recorder  Element  -file  Element2section4Fiber12stressstrain.txt      -ele  2      section  4      fiber 1 2      stressStrain
                                     recorder  Element  -file  Element2section4Fiber21stressstrain.txt      -ele  2      section  4      fiber 2 1      stressStrain
                                     recorder  Element  -file  Element2section4Fiber22stressstrain.txt      -ele  2      section  4      fiber 2 2      stressStrain									 
                                     recorder  Element  -file  Element2section4Fiber31stressstrain.txt      -ele  2      section  4      fiber 3 1      stressStrain
                                     recorder  Element  -file  Element2section4Fiber32stressstrain.txt      -ele  2      section  4      fiber 3 2      stressStrain
                                     recorder  Element  -file  Element2section4Fiber41stressstrain.txt      -ele  2      section  4      fiber 4 1      stressStrain
                                     recorder  Element  -file  Element2section4Fiber42stressstrain.txt      -ele  2      section  4      fiber 4 2      stressStrain
                                     recorder  Element  -file  Element2section4Fiber51stressstrain.txt      -ele  2      section  4      fiber 5 1      stressStrain									 
                                     recorder  Element  -file  Element2section4Fiber52stressstrain.txt      -ele  2      section  4      fiber 5 2      stressStrain
                                     recorder  Element  -file  Element2section4Fiber61stressstrain.txt      -ele  2      section  4      fiber 6 1      stressStrain
                                     recorder  Element  -file  Element2section4Fiber62stressstrain.txt      -ele  2      section  4      fiber 6 2      stressStrain

                                  #  recorder  Element  -file  Output_File_Name.txt                     -ele  Element_ID  section  Integration_Point_Number  fiber  Number_of_Fiber_in_Height[1:6]  Number_of_Fiber_in_Width[1:2]  stressStrain
                                     recorder  Element  -file  Element3section1Fiber11stressstrain.txt  -ele     3        section              1             fiber                 1                               1               stressStrain
                                     recorder  Element  -file  Element3section1Fiber12stressstrain.txt  -ele     3        section              1             fiber                 1                               2               stressStrain
                                     recorder  Element  -file  Element3section1Fiber21stressstrain.txt  -ele     3        section              1             fiber                 2                               1               stressStrain
                                     recorder  Element  -file  Element3section1Fiber22stressstrain.txt  -ele     3        section              1             fiber                 2                               2               stressStrain									 
                                     recorder  Element  -file  Element3section1Fiber31stressstrain.txt  -ele     3        section              1             fiber                 3                               1               stressStrain
                                     recorder  Element  -file  Element3section1Fiber32stressstrain.txt  -ele     3        section              1             fiber                 3                               2               stressStrain
                                     recorder  Element  -file  Element3section1Fiber41stressstrain.txt  -ele     3        section              1             fiber                 4                               1               stressStrain
                                     recorder  Element  -file  Element3section1Fiber42stressstrain.txt  -ele     3        section              1             fiber                 4                               2               stressStrain
                                     recorder  Element  -file  Element3section1Fiber51stressstrain.txt  -ele     3        section              1             fiber                 5                               1               stressStrain									 
                                     recorder  Element  -file  Element3section1Fiber52stressstrain.txt  -ele     3        section              1             fiber                 5                               2               stressStrain
                                     recorder  Element  -file  Element3section1Fiber61stressstrain.txt  -ele     3        section              1             fiber                 6                               1               stressStrain
                                     recorder  Element  -file  Element3section1Fiber62stressstrain.txt  -ele     3        section              1             fiber                 6                               2               stressStrain
                                     recorder  Element  -file  Element3section2Fiber11stressstrain.txt  -ele     3        section              2             fiber                 1                               1               stressStrain
                                     recorder  Element  -file  Element3section2Fiber12stressstrain.txt  -ele     3        section              2             fiber                 1                               2               stressStrain
                                     recorder  Element  -file  Element3section2Fiber21stressstrain.txt  -ele     3        section              2             fiber                 2                               1               stressStrain
                                     recorder  Element  -file  Element3section2Fiber22stressstrain.txt  -ele     3        section              2             fiber                 2                               2               stressStrain									 
                                     recorder  Element  -file  Element3section2Fiber31stressstrain.txt  -ele     3        section              2             fiber                 3                               1               stressStrain
                                     recorder  Element  -file  Element3section2Fiber32stressstrain.txt  -ele     3        section              2             fiber                 3                               2               stressStrain
                                     recorder  Element  -file  Element3section2Fiber41stressstrain.txt  -ele     3        section              2             fiber                 4                               1               stressStrain
                                     recorder  Element  -file  Element3section2Fiber42stressstrain.txt  -ele     3        section              2             fiber                 4                               2               stressStrain
                                     recorder  Element  -file  Element3section2Fiber51stressstrain.txt  -ele     3        section              2             fiber                 5                               1               stressStrain									 
                                     recorder  Element  -file  Element3section2Fiber52stressstrain.txt  -ele     3        section              2             fiber                 5                               2               stressStrain
                                     recorder  Element  -file  Element3section2Fiber61stressstrain.txt  -ele     3        section              2             fiber                 6                               1               stressStrain
                                     recorder  Element  -file  Element3section2Fiber62stressstrain.txt  -ele     3        section              2             fiber                 6                               2               stressStrain
                                     recorder  Element  -file  Element3section3Fiber11stressstrain.txt  -ele     3        section              3             fiber                 1                               1               stressStrain
                                     recorder  Element  -file  Element3section3Fiber12stressstrain.txt  -ele     3        section              3             fiber                 1                               2               stressStrain
                                     recorder  Element  -file  Element3section3Fiber21stressstrain.txt  -ele     3        section              3             fiber                 2                               1               stressStrain
                                     recorder  Element  -file  Element3section3Fiber22stressstrain.txt  -ele     3        section              3             fiber                 2                               2               stressStrain									 
                                     recorder  Element  -file  Element3section3Fiber31stressstrain.txt  -ele     3        section              3             fiber                 3                               1               stressStrain
                                     recorder  Element  -file  Element3section3Fiber32stressstrain.txt  -ele     3        section              3             fiber                 3                               2               stressStrain
                                     recorder  Element  -file  Element3section3Fiber41stressstrain.txt  -ele     3        section              3             fiber                 4                               1               stressStrain
                                     recorder  Element  -file  Element3section3Fiber42stressstrain.txt  -ele     3        section              3             fiber                 4                               2               stressStrain
                                     recorder  Element  -file  Element3section3Fiber51stressstrain.txt  -ele     3        section              3             fiber                 5                               1               stressStrain									 
                                     recorder  Element  -file  Element3section3Fiber52stressstrain.txt  -ele     3        section              3             fiber                 5                               2               stressStrain
                                     recorder  Element  -file  Element3section3Fiber61stressstrain.txt  -ele     3        section              3             fiber                 6                               1               stressStrain
                                     recorder  Element  -file  Element3section3Fiber62stressstrain.txt  -ele     3        section              3             fiber                 6                               2               stressStrain
                                     recorder  Element  -file  Element3section4Fiber11stressstrain.txt  -ele     3        section              4             fiber                 1                               1               stressStrain
                                     recorder  Element  -file  Element3section4Fiber12stressstrain.txt  -ele     3        section              4             fiber                 1                               2               stressStrain
                                     recorder  Element  -file  Element3section4Fiber21stressstrain.txt  -ele     3        section              4             fiber                 2                               1               stressStrain
                                     recorder  Element  -file  Element3section4Fiber22stressstrain.txt  -ele     3        section              4             fiber                 2                               2               stressStrain									 
                                     recorder  Element  -file  Element3section4Fiber31stressstrain.txt  -ele     3        section              4             fiber                 3                               1               stressStrain
                                     recorder  Element  -file  Element3section4Fiber32stressstrain.txt  -ele     3        section              4             fiber                 3                               2               stressStrain
                                     recorder  Element  -file  Element3section4Fiber41stressstrain.txt  -ele     3        section              4             fiber                 4                               1               stressStrain
                                     recorder  Element  -file  Element3section4Fiber42stressstrain.txt  -ele     3        section              4             fiber                 4                               2               stressStrain
                                     recorder  Element  -file  Element3section4Fiber51stressstrain.txt  -ele     3        section              4             fiber                 5                               1               stressStrain									 
                                     recorder  Element  -file  Element3section4Fiber52stressstrain.txt  -ele     3        section              4             fiber                 5                               2               stressStrain
                                     recorder  Element  -file  Element3section4Fiber61stressstrain.txt  -ele     3        section              4             fiber                 6                               1               stressStrain
                                     recorder  Element  -file  Element3section4Fiber62stressstrain.txt  -ele     3        section              4             fiber                 6                               2               stressStrain


                                     #i=4;j=1;k=1:6
                                     recorder  Element  -file  Element4section1Fiber11stressstrain.txt      -ele  4      section  1      fiber 1 1      stressStrain
                                     recorder  Element  -file  Element4section1Fiber12stressstrain.txt      -ele  4      section  1      fiber 1 2      stressStrain
                                     recorder  Element  -file  Element4section1Fiber21stressstrain.txt      -ele  4      section  1      fiber 2 1      stressStrain
                                     recorder  Element  -file  Element4section1Fiber22stressstrain.txt      -ele  4      section  1      fiber 2 2      stressStrain									 
                                     recorder  Element  -file  Element4section1Fiber31stressstrain.txt      -ele  4      section  1      fiber 3 1      stressStrain
                                     recorder  Element  -file  Element4section1Fiber32stressstrain.txt      -ele  4      section  1      fiber 3 2      stressStrain
                                     recorder  Element  -file  Element4section1Fiber41stressstrain.txt      -ele  4      section  1      fiber 4 1      stressStrain
                                     recorder  Element  -file  Element4section1Fiber42stressstrain.txt      -ele  4      section  1      fiber 4 2      stressStrain
                                     recorder  Element  -file  Element4section1Fiber51stressstrain.txt      -ele  4      section  1      fiber 5 1      stressStrain									 
                                     recorder  Element  -file  Element4section1Fiber52stressstrain.txt      -ele  4      section  1      fiber 5 2      stressStrain
                                     recorder  Element  -file  Element4section1Fiber61stressstrain.txt      -ele  4      section  1      fiber 6 1      stressStrain
                                     recorder  Element  -file  Element4section1Fiber62stressstrain.txt      -ele  4      section  1      fiber 6 2      stressStrain
									 #i=4;j=2;k=1:6
                                     recorder  Element  -file  Element4section2Fiber11stressstrain.txt      -ele  4      section  2      fiber 1 1      stressStrain
                                     recorder  Element  -file  Element4section2Fiber12stressstrain.txt      -ele  4      section  2      fiber 1 2      stressStrain
                                     recorder  Element  -file  Element4section2Fiber21stressstrain.txt      -ele  4      section  2      fiber 2 1      stressStrain
                                     recorder  Element  -file  Element4section2Fiber22stressstrain.txt      -ele  4      section  2      fiber 2 2      stressStrain									 
                                     recorder  Element  -file  Element4section2Fiber31stressstrain.txt      -ele  4      section  2      fiber 3 1      stressStrain
                                     recorder  Element  -file  Element4section2Fiber32stressstrain.txt      -ele  4      section  2      fiber 3 2      stressStrain
                                     recorder  Element  -file  Element4section2Fiber41stressstrain.txt      -ele  4      section  2      fiber 4 1      stressStrain
                                     recorder  Element  -file  Element4section2Fiber42stressstrain.txt      -ele  4      section  2      fiber 4 2      stressStrain
                                     recorder  Element  -file  Element4section2Fiber51stressstrain.txt      -ele  4      section  2      fiber 5 1      stressStrain									 
                                     recorder  Element  -file  Element4section2Fiber52stressstrain.txt      -ele  4      section  2      fiber 5 2      stressStrain
                                     recorder  Element  -file  Element4section2Fiber61stressstrain.txt      -ele  4      section  2      fiber 6 1      stressStrain
                                     recorder  Element  -file  Element4section2Fiber62stressstrain.txt      -ele  4      section  2      fiber 6 2      stressStrain
									 #i=4;j=3;k=1:6
                                     recorder  Element  -file  Element4section3Fiber11stressstrain.txt      -ele  4      section  3      fiber 1 1      stressStrain
                                     recorder  Element  -file  Element4section3Fiber12stressstrain.txt      -ele  4      section  3      fiber 1 2      stressStrain
                                     recorder  Element  -file  Element4section3Fiber21stressstrain.txt      -ele  4      section  3      fiber 2 1      stressStrain
                                     recorder  Element  -file  Element4section3Fiber22stressstrain.txt      -ele  4      section  3      fiber 2 2      stressStrain									 
                                     recorder  Element  -file  Element4section3Fiber31stressstrain.txt      -ele  4      section  3      fiber 3 1      stressStrain
                                     recorder  Element  -file  Element4section3Fiber32stressstrain.txt      -ele  4      section  3      fiber 3 2      stressStrain
                                     recorder  Element  -file  Element4section3Fiber41stressstrain.txt      -ele  4      section  3      fiber 4 1      stressStrain
                                     recorder  Element  -file  Element4section3Fiber42stressstrain.txt      -ele  4      section  3      fiber 4 2      stressStrain
                                     recorder  Element  -file  Element4section3Fiber51stressstrain.txt      -ele  4      section  3      fiber 5 1      stressStrain									 
                                     recorder  Element  -file  Element4section3Fiber52stressstrain.txt      -ele  4      section  3      fiber 5 2      stressStrain
                                     recorder  Element  -file  Element4section3Fiber61stressstrain.txt      -ele  4      section  3      fiber 6 1      stressStrain
                                     recorder  Element  -file  Element4section3Fiber62stressstrain.txt      -ele  4      section  3      fiber 6 2      stressStrain
									 #i=4;j=4;k=1:6
                                     recorder  Element  -file  Element4section4Fiber11stressstrain.txt      -ele  4      section  4      fiber 1 1      stressStrain
                                     recorder  Element  -file  Element4section4Fiber12stressstrain.txt      -ele  4      section  4      fiber 1 2      stressStrain
                                     recorder  Element  -file  Element4section4Fiber21stressstrain.txt      -ele  4      section  4      fiber 2 1      stressStrain
                                     recorder  Element  -file  Element4section4Fiber22stressstrain.txt      -ele  4      section  4      fiber 2 2      stressStrain									 
                                     recorder  Element  -file  Element4section4Fiber31stressstrain.txt      -ele  4      section  4      fiber 3 1      stressStrain
                                     recorder  Element  -file  Element4section4Fiber32stressstrain.txt      -ele  4      section  4      fiber 3 2      stressStrain
                                     recorder  Element  -file  Element4section4Fiber41stressstrain.txt      -ele  4      section  4      fiber 4 1      stressStrain
                                     recorder  Element  -file  Element4section4Fiber42stressstrain.txt      -ele  4      section  4      fiber 4 2      stressStrain
                                     recorder  Element  -file  Element4section4Fiber51stressstrain.txt      -ele  4      section  4      fiber 5 1      stressStrain									 
                                     recorder  Element  -file  Element4section4Fiber52stressstrain.txt      -ele  4      section  4      fiber 5 2      stressStrain
                                     recorder  Element  -file  Element4section4Fiber61stressstrain.txt      -ele  4      section  4      fiber 6 1      stressStrain
                                     recorder  Element  -file  Element4section4Fiber62stressstrain.txt      -ele  4      section  4      fiber 6 2      stressStrain










# Start the Analysis: analyze  Number_of_Steps									 
					  analyze        1000