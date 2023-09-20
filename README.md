<!-- Header -->

<p align="center">
    <img src="media/Logo_Politecnico_Milano.png" alt="Polimi logo" width="30%" height="30%">
</p>


--------------

# What is it ?
This is a project concerning the use of Machine Learning in the context of Atrial Fibrillation (AF) detection. 
It covers the process performed to properly preprocess raw ECG signals, extract pertinent AF-related features, and leverage 
these features using Machine Learning models to discern whether the ECG recording shows Normal Sinus Rhythm or Atrial Fibrillation.

# The purpose 
Our purpose is to reproduce the results obtained by a group of researchers from the Beijing University of Technology.
The aforementioned team participated in the 2017 PhysioNet CinC Challenge.

### Main References
- [Detection of AF using Decision Tree Ensamble (F. Castellani, C. Boscarino, A. Lombardi from Politecnico di Milano)](Boscarino_Castellani_Lombardi_ProjectBSPLab\Report_BSP_Lab_Assignment.pdf)
- [Reference paper (Shao et al. from Beijing University of Technology)](https://pubmed.ncbi.nlm.nih.gov/30187894/)
- [2017 PhysioNet CinC Challenge](https://physionet.org/content/challenge-2017/1.0.0/)

### Main aspects
The 2017 PhysioNet/CinC Challenge aims to encourage the development of algorithms to classify, from a single short ECG lead recording (between 30 s and 60 s in length),
whether the recording shows

- normal sinus rhythm,
- atrial fibrillation (AF),
- an alternative rhythm,
- or is too noisy to be classified.

### Challenge Data
ECG recordings, collected using the AliveCor device.
The training set contains 8,528 single lead ECG recordings lasting from 9 s to 60 s. 
The test set contains 3,658 ECG recordings of similar length. 

ECG recordings were sampled as 300 Hz and band pass filtered by the AliveCor device.

All data are provided in MATLAB V4 WFDB-compliant format (each including a .mat file containing the ECG and a .hea file containing the waveform information).

# How to use it?
[User instructions](Boscarino_Castellani_Lombardi_ProjectBSPLab\README.txt) 

## Authors
Filippo Castellani
Chiara Boscarino
Antonella Lombardi


# Installation

 1. Clone the repository `git clone https://github.com/FilippoCastellani/CaBoLo `
 2. Verify your MATLAB version is >= 2021 as this was the version used to develop the project
 3. Open MATLAB and set the current folder to the one you just cloned
 4. You may have to install some additional packages, like the Signal Processing Toolbox, the Statistics and Machine Learning Toolbox. There is no need to re-install the WFDB Toolbox as it is already included in the repository, however you may need to add it to the MATLAB search path. 

 --------------



<!-- Footer -->

<p align="center">
    <b> Ca. Bo. Lo.</b></p>

<p align="right">
    <a href="https://github.com/FilippoCastellani/CaBoLo/blob/main/Boscarino_Castellani_Lombardi_ProjectBSPLab/Report_BSP_Lab_Assignment.pdf"><b>Go to report</b>
</p>
