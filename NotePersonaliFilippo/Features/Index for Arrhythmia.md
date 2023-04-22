
Index for arrhythmia (IfA)

$$IfA \in {0,1,2,3,4}$$
The feature value represents a measure of the presence of arrhythmia in the input RR intervals, specifically it considers a sequence of consecutive RR intervals.
This feature is based on 4 rules and its value is incremented for each rule compliant. 

Such rules consist on comparing three consecutive RR intervals to each other, but also to the mean RR interval of the five nearest beats (MRR). 

> [!WARNING] Doubt
> Ma quali sono sti five ? quelli che vengono prima o dopo ? In teoria per calcolare 3RR intervals bastano 4 battiti quindi il 5 da dove esce ??

Those rules are:
 - Rule 1: 
	 - 1.2 ∗ 𝑅𝑅2 < 𝑅𝑅1 
	 - 𝑎𝑛𝑑 1.3 ∗ 𝑅𝑅2 < 𝑅𝑅3 
 - Rule 2: 
	 - |𝑅𝑅1 − 𝑅𝑅2| < 0.3 ∗ 𝑀𝑅𝑅 
	 - 𝑎𝑛𝑑(𝑅𝑅1 < 0.8 ∗ 𝑀𝑅𝑅 𝑜𝑟 𝑅𝑅2 < 0.8 ∗ 𝑀𝑅𝑅) 
	 - 𝑎𝑛𝑑 𝑅𝑅3 > 0.6 ∗ (𝑅𝑅1 + 𝑅𝑅2) 
 - Rule 3: 
	 - |𝑅𝑅3 − 𝑅𝑅2| < 0.3 ∗ 𝑀𝑅𝑅 
	 - 𝑎𝑛𝑑 (𝑅𝑅2 < 0.8 ∗ 𝑀𝑅𝑅 𝑜𝑟 𝑅𝑅3 < 0.8 ∗ 𝑀𝑅𝑅) 
	 - 𝑎𝑛𝑑 𝑅𝑅1 > 0.6 ∗ (𝑅𝑅2 + 𝑅𝑅3) 
 - Rule 4: 
	 - 𝑅𝑅2 > 1.5 ∗ 𝑀𝑅𝑅 
	 - 𝑎𝑛𝑑 1.5 ∗ 𝑅𝑅2 < 3 ∗ 𝑀𝑅𝑅

Where 

 - $RR1$, $RR2$ and $RR3$ represent three consecutive RR intervals, 
 - $MRR$ is the average of the five nearest beats. 

![[Pasted image 20230421180235.png|400]]

# Original inspiration

https://www.sciencedirect.com/science/article/pii/S0933365704000806?via%3Dihub
