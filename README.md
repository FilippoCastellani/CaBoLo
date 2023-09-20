#Project 

# What is it ?
This is a project concerning the use of Machine Learning in the context of Atrial Fibrillation (AF) detection. 
It covers the process performed to properly preprocess raw ECG signals, extract pertinent AF-related features, and leverage 
these features using Machine Learning models to discern whether the ECG recording shows Normal Sinus Rhythm or Atrial Fibrillation.

## The purpose 
Our purpose is to reproduce the results obtained by a group of researchers from the Beijing University of Technology.
The aforementioned team participated in the 2017 PhysioNet CinC Challenge.

### Main aspects
The 2017 PhysioNet/CinC Challenge aims to encourage the development of algorithms to classify, from a single short ECG lead recording (between 30 s and 60 s in length),
whether the recording shows

normal sinus rhythm,
atrial fibrillation (AF),
an alternative rhythm,
or is too noisy to be classified.

#### Challenge Data
ECG recordings, collected using the AliveCor device.
The training set contains

8,528 single lead ECG recordings lasting from 9 s to just over 60 s
*- test set contains 3,658 ECG recordings of similar lengths
The test set is unavailable to the public and will remain private for the purpose of scoring for the duration of the Challenge and for some period afterwards.

ECG recordings were sampled as 300 Hz. They have been band pass filtered by the AliveCor device.

All data are provided in MATLAB V4 WFDB-compliant format (each including a .mat file containing the ECG and a .hea file containing the waveform information).

### Main Reference
[Detection of Atrial Fibrillation using Decision Tree Ensamble](https://pubmed.ncbi.nlm.nih.gov/30187894/)

# Authors
Filippo Castellani
Chiara Boscarino
Antonella Lombardi
