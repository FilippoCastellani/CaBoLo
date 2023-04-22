# Definition

AFEv Stands for *"Atrial Fibrillation Evidence"*. This feature is computed starting from $RR$ series and reflects the irregularity of RR intervals. Specifically it accounts for the sparsity of RR data points positioning withing the Lorenz Plot.

The distribution of points around the origin is indicative of the presence or absence of clinically significant Heart Rate Variability. 
A denser clustering of points around the center signifies that there are only minor differences between consecutive RR intervals, and hence, no significant variability. Conversely, a sparser distribution of points indicates significant changes in the instantaneous heart rate over time, which is a measurable expression of the irregular ventricular response observed during Atrial Fibrillation.

In order to compute this feature is necessary to first compute the Lorenz Plot. 
A necessary measure in order to realize such plot is the $\delta RR$ interval, defined as $\delta RR(i) = RR(i) - RR(i+1)$. The Lorenz plot of $\delta RR$ interval, is a scatter plot of $\delta RR(i+1)$ versus $\delta RR(i)$. Such plot is then subdivided into bins (visualized as a superimposed grid) and in 13 segments (visualized with different gray levels).

![[Pasted image 20230420155637.png|400]]

During normal sinus rhytm, bins within segment 0 are the most populated, whereas during AF all segments are populated.

$AFEvidence \coloneqq IrregularityEvidence - OriginCount -2*PACEvidence$

Where $OriginCount$ is the count of the number of values in the bin containing the origin.

Where $PACEvidence$ is defined as follow
![[Pasted image 20230420162754.png|150]]
and $IrregularityEvidence$ is defined as
![[Pasted image 20230420162946.png|150]]

Where $PointCount_n$ counted the number times bins in segment n were populated. 
$BinCount_n$ counted the number of bins in segment n that were populated at least once.


## Radius sub-feature

### Definition

This is a feature computed from the Lorenz plot and is defined as the radius of the smallest circle that encloses at least 60% of the points in the Lorenz plot.

# Examples
## EXAMPLE 1
Here is how the Lorenz Plot looks like when computed on Atrial Fibrillation (upper images) and on atrial tachycardia (lower images).
![[Pasted image 20230420155929.png|400]]

## EXAMPLE 2
Here is how the Lorenz Plot looks like in different situations.
![[Pasted image 20230420162249.png|400]]
# Source 

![[A_Detector_for_a_Chronic_Implantable_Atrial_Tachyarrhythmia_Monitor.pdf]]