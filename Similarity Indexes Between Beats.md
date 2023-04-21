
## Similarity index of QRS (F40):
For the similarity index of QRS, QRS onsets and offsets were used in order to extract the QRS complex waves from the signal.
Then, cross-correlation between two successive QRSs was computed, we extracted the maximum correlation value for each of the QRS pairs, and we obtained a vector containing these values. 
Finally, by computing the mean of this vector, we obtained the mean value of all the maxima. 
This value is considered the Similarity index for QRS pulses.

> [!Important] Personal opinion
> Before cross-correlation i would do signal normalization

## Similarity index of R amplitude (F41):
Like similarity index of QRS, we computed the similarity index of R amplitude from the correlation between consecutive R amplitudes. As for the QRS, we extracted the maximum correlation value for each of the R amplitude pairs, and then we computed the mean, obtaining the R amplitude similarity index.


> [!Important] Personal opinion
> Before auto-correlation of the RR sequence i would do signal normalization as the real value in Mv is not important by itself


![image|300](https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Comparison_convolution_correlation.svg/400px-Comparison_convolution_correlation.svg.png)

> [!error] ANCORA DA LEGGERE 
	## Ratio of high similarity beats (F42):
	For the computation of this feature, we considered the previous two similarity indexes as follow:
	 - A beat was considered of high similarity if the value of the QRS similarity index and the value of the R amplitude similarity index are high.
		- To consider a high value for any of the indexes, both for QRS and R amplitude, we proposed a threshold. 
		- If the computed similarity index between two beats was higher than the threshold, the beats were considered of high similarity. 
		- This was repeated along the whole signal.
	- To obtain the ratio of high similarity beats, the total amount of high similarity beats was divided by the total number of beats.
	## Signal Qualify index (F43):
	This feature was computed as the difference between the amplitude of the P wave onset of the current beat, and the amplitude of the T wave offset of the previous beat. It quantifies the fluctuation of the isoelectric level.
	