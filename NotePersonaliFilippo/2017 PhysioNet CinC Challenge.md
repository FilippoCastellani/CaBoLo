## Introduction and corpus

### Main aspects
The 2017 PhysioNet/CinC Challenge aims to encourage the development of **algorithms to classify, from a single short ECG lead recording (between 30 s and 60 s in length)**, 
whether the recording shows  
 - normal sinus rhythm, 
 - atrial fibrillation (AF), 
 - an alternative rhythm, 
 - or is too noisy to be classified.

### Literature knowledge

There are various types of cardiac arrhythmias that may be classified by:

-   Origin: atrial arrhythmia, junctional arrhythmia, or ventricular arrhythmia.
-   Rate: tachycardia ( > 100 beats per minute (bpm) in adults) or bradycardia ( < 60 bpm in adults).
-   Mechanism: automaticity, re-entry, triggered.
-   AV Conduction: normal, delayed, blocked.
-   Duration: non-sustained (less than 30 s) or sustained (30 s or longer).

AF is defined as a “tachyarrhythmia characterized by predominantly uncoordinated atrial activation with consequent deterioration of atrial mechanical function” by the American College of Cardiology (ACC), the American Heart Association (AHA) and the European Society of Cardiology (ESC) [[1](https://physionet.org/challenge/2017/#ref1)]. AF is the most common sustained cardiac arrhythmia, occurring in 1-2% of the general population [[2](https://physionet.org/challenge/2017/#ref2); [3](https://physionet.org/challenge/2017/#ref3)] and is associated with significant mortality and morbidity through association of risk of death, stroke, hospitalization, heart failure and coronary artery disease, etc. [[3](https://physionet.org/challenge/2017/#ref3); [4](https://physionet.org/challenge/2017/#ref4)]. More than 12 million Europeans and North Americans are estimated to suffer from AF, and its prevalence will likely triple in the next 30-50 years [[5](https://physionet.org/challenge/2017/#ref5)]. More importantly, the incidence of AF increases with age, from less than 0.5% at 40-50 years of age, to 5-15% for 80 year olds [[6](https://physionet.org/challenge/2017/#ref6)].

### Exhisting types of analysis
Despite the enormity of this problem, AF detection remains problematic, because it may be episodic. 
AF detectors can be thought of belonging to one of two categories: 
 - atrial activity analysis-based **(A)**
 - or ventricular response analysis-based methods. **(B)**

#### **(A)** Atrial activity analysis-based ...
...AF detectors are **based on the analysis of the absence of P waves** or the **presence of fibrillatory _f waves_ in the TQ interval**. 
Published methods to do this include: 
- an echo state neural network [[7](https://physionet.org/challenge/2017/#ref7)], 
- P-wave absence (PWA) based detection [[8](https://physionet.org/challenge/2017/#ref8)], 
- analysis of the average number of f waves [[9](https://physionet.org/challenge/2017/#ref9)], 
- P-wave-based insertable cardiac monitor application [[10](https://physionet.org/challenge/2017/#ref10)], 
- wavelet entropy [[11](https://physionet.org/challenge/2017/#ref11)] [[12](https://physionet.org/challenge/2017/#ref12)] and 
- wavelet energy [[13](https://physionet.org/challenge/2017/#ref13)]. 

Atrial activity analysis-based AF detectors can achieve high accuracy if the recorded ECG signals have little noise contamination and high resolution, but tend to suffer disproportionately from noise contamination [[4](https://physionet.org/challenge/2017/#ref4)]. 

#### **(B)** Ventricular response analysis-based ...
... In contrast, ventricular response analysis is based on the **predictability of the inter-beat timing (‘RR intervals’) of the QRS complexes** in the ECG. 

RR intervals are derived from the most obvious large amplitude feature in the ECG, the R-peak, the detection of which can be far more noise resistant. 
This approach may therefore be more suitable for automatic, real-time AF detection [[14](https://physionet.org/challenge/2017/#ref14)]. 

Published methods include: 
 - Poincaré plot analysis [[15](https://physionet.org/challenge/2017/#ref15)], 
 - Lorenz plot analysis [[16](https://physionet.org/challenge/2017/#ref16)], 
 - analysis of cumulative distribution functions [[17](https://physionet.org/challenge/2017/#ref17)], 
 - thresholding on the median absolute deviation (MAD) of RR intervals [[18](https://physionet.org/challenge/2017/#ref18)],
 - histogram of the first difference of RR intervals [[19](https://physionet.org/challenge/2017/#ref19)], 
 - minimum of the corrected conditional entropy of RR interval sequence [[20](https://physionet.org/challenge/2017/#ref20)], 
 - 8-beat sliding window RR interval irregularity detector [[21](https://physionet.org/challenge/2017/#ref21)],
 - symbolic dynamics and Shannon entropy [[22](https://physionet.org/challenge/2017/#ref22)], 
 - sample entropy of RR intervals [[23](https://physionet.org/challenge/2017/#ref23); [24](https://physionet.org/challenge/2017/#ref24); [25](https://physionet.org/challenge/2017/#ref25)], and normalized fuzzy entropy of RR intervals [[26](https://physionet.org/challenge/2017/#ref26)].

#### Combining both types of analysis
It is worth noting that AF detectors that combine both atrial activity and ventricular response could provide an enhanced performance by combining independent data from each part of the cardiac cycle. Such detection approaches have included: RR interval Markov modeling combined with PR interval variability and a P wave morphology similarity measure [[27](https://physionet.org/challenge/2017/#ref27)] and a fuzzy logic classification method which uses the combination of RR interval irregularity, P-wave absence, f-wave presence, and noise level [[28](https://physionet.org/challenge/2017/#ref28)]. It is also worth noting that multivariate approaches based on machine learning that combines several of the above single features can also provide enhanced AF detection [[29](https://physionet.org/challenge/2017/#ref29); [30](https://physionet.org/challenge/2017/#ref30); [31](https://physionet.org/challenge/2017/#ref31)].

Previous studies concerning AF classification are generally limited in applicability because 
1) only classification of normal and AF rhythms were performed, 
2) good performance was shown on carefully-selected often clean data, 
3) a separate out of sample test dataset was not used, or 
4) only a small number of patients were used. 

It is challenging to reliably detect AF from a single short lead of ECG, and the broad taxonomy of rhythms makes this particularly difficult. In particular, many non-AF rhythms exhibit irregular RR intervals that may be similar to AF.

#### In this challenge we ask to... 
In this Challenge, we treat all non-AF abnormal rhythms as a single class and require the Challenge entrant to classify the rhythms as 
1) Normal sinus rhythm,
2) AF, 
3) Other rhythm, or 
4) Too noisy to classify.


### Quick Start

1. Download the training set: `training2017.zip` and the sample MATLAB entry: `sample2017.zip`.
2.  Develop your entry by making the following edits to `sample2017.zip`:
    -   Modify the sample entry source code file `challenge.m` with your changes and improvements. 
    -   Modify the `AUTHORS.txt` file to include the names of all the team members.
    -   Unzip `training2017.zip` and move all its files to the top directory of your entry directory (where `challenge.m` is located).
    -   Run your modified source code file on the validation records in the training set by executing the script `generateValidationSet.m`. This will also build a file called `entry.zip`.
    -   Optional: Include a file named `DRYRUN` in the top directory of your entry (where the `AUTHORS.txt` file is located) if you do not wish your entry to be scored and counted against your limit. This is useful in cases where you wish to make sure that the changes made do not result in any error.
3.  Submit your `entry.zip` for scoring through the PhysioNet/CinC Challenge 2017 project (Update: submissions are now closed). The contents of `entry.zip` must be laid out exactly as in the sample entry. **Improperly-formatted entries will not be scored.**


### Challenge Data

ECG recordings, collected using the AliveCor device. 
The **training set contains**
 - **8,528 single lead ECG recordings** lasting from 9 s to just over 60 s 
 
 *- test set contains 3,658 ECG recordings of similar lengths
The test set is unavailable to the public and will remain private for the purpose of scoring for the duration of the Challenge and for some period afterwards.

ECG recordings were **sampled as 300 Hz and they have been band pass filtered** by the AliveCor device. 

All data are provided in MATLAB V4 WFDB-compliant format (each including a .mat file containing the ECG and a .hea file containing the waveform information). 

![[Pasted image 20230322141326.png|400]]

### Sample Figure
The Figure shows the examples of the ECG waveforms (lasting for 20 s) for the four classes in this Challenge. From top to bottom, they are ECG waveforms of normal rhythm, AF rhythm, other rhythm and noisy recordings.

![ExampleSignal|400](https://physionet.org/files/challenge-2017/1.0.0/example_waveforms.svg)

# Scoring

![Classification_Scoring|500](https://physionet.org/files/challenge-2017/1.0.0/table3.png)


