#Project 

# What is it ?
This is a project concerning the use of Machine Learning in the context of Atrial Fibrillation (AF) detection. 
It covers the process performed to properly preprocess raw ECG signals, extract pertinent AF-related features, and leverage 
these features using Machine Learning models to discern whether the ECG recording shows Normal Sinus Rhythm or Atrial Fibrillation.

# The purpose 
Our purpose is to reproduce the results obtained by a group of researchers from the Beijing University of Technology.
The aforementioned team participated in the 2017 PhysioNet CinC Challenge.

### Main References
- [Detection of AF using Decision Tree Ensamble (F. Castellani, C. Boscarino, A. Lombardi)]()
- [Reference paper (Shao et al. from Beijing University of Technology)](https://pubmed.ncbi.nlm.nih.gov/30187894/)
- [2017 PhysioNet CinC Challenge](https://physionet.org/content/challenge-2017/1.0.0/)

### Main aspects
The 2017 PhysioNet/CinC Challenge aims to encourage the development of algorithms to classify, from a single short ECG lead recording (between 30 s and 60 s in length),
whether the recording shows

- normal sinus rhythm,
- atrial fibrillation (AF),
- an alternative rhythm,
- or is too noisy to be classified.

#### Challenge Data
ECG recordings, collected using the AliveCor device.
The training set contains 8,528 single lead ECG recordings lasting from 9 s to 60 s. 
The test set contains 3,658 ECG recordings of similar length. 

ECG recordings were sampled as 300 Hz and band pass filtered by the AliveCor device.

All data are provided in MATLAB V4 WFDB-compliant format (each including a .mat file containing the ECG and a .hea file containing the waveform information).


# Authors
Filippo Castellani
Chiara Boscarino
Antonella Lombardi
