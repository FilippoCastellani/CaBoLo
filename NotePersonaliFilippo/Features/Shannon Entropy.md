# Definition 

Shannon entropy **provides a quantitative measure of uncertainty for a random variable**.

Specifically, the SE quantifies the likelihood that runs of patterns exhibiting regularity over some duration of data also exhibit similar regular patterns over the next incremental duration of data. 

The Shannon Entropy is calculated as follows

$${\text{SE}} = - \sum\limits_{i = 1}^{n bins} {p(i){\frac{\log (p(i))}{{\log \left( {{\frac{1}{n bins}}} \right)}}}}$$
where $p(i)$ is defined as:


$$p(i) = {\frac{{N_{{{\text{bin}}(i)}} }}{{l - N_{\text{outliers}} }}}$$

where 
 - $N_{bin(i)}$ is the number of beats in the *i*th bin,
 - *l* is the total number of beats in the segment
 - and $N_{outliers}$ is the number of outliers in that segment

> [!Warning] Doubts: 
>  - How can you define $N_{outliers}$ ?
>- #TO_UNDERSTAND 



For example, a random white noise signal (data are independent) is expected to have the highest SE value (1.0) since it shows maximum uncertainty in predicting the pattern of the signal whereas a simple sinusoidal signal (data are not independent) has a very low SE value approaching 0.

# Meaning in Atrial Fibrillation detection

Thus, the SE of normal sinus rhythm is expected to be significantly lower than in AF. To calculate SE of the RR time series, we first construct a histogram of the segment considered.

The eight longest and eight shortest RR values in the segment are considered outliers and are removed from consideration. The remaining RRs are sorted into equally spaced bins whose limits are defined by the shortest and longest R after removing outliers. To obtain a reasonably accurate measure of the SE, at least 16 such bins are required. The probability distribution is computed for each bin as the number of beats in that bin divided by the total number of beats in the segment (after removing outliers)

> [!important]  
> In this article they use 16 for $N_{bins}$ and use 8 as $N_{outlier}$

## Efficiency (normalized entropy)[[edit](https://en.wikipedia.org/w/index.php?title=Entropy_(information_theory)&action=edit&section=17 "Edit section: Efficiency (normalized entropy)")]

A source alphabet with non-uniform distribution will have less entropy than if those symbols had uniform distribution (i.e. the "optimized alphabet"). This deficiency in entropy can be expressed as a ratio called efficiency
![[Pasted image 20230615153143.png]]
# Source
https://link.springer.com/article/10.1007/s10439-009-9740-z
![[Automatic Real Time Detection of Atrial Fibrillation.pdf]]
