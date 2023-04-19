#Project 

# What is it ?
This is a project concerning the use of [[Machine Learning]] in the context of Atrial Fibrillation detection.

## The purpose 
Our purpose is to reproduce the results obtained by a group of researchers from the Beijing University of Technology.
The aformentioned team partecipated to the [[2017 PhysioNet CinC Challenge]]

![[2017 PhysioNet CinC Challenge#Main aspects]]

![[2017 PhysioNet CinC Challenge#Challenge Data]]
# Our work

## Pt.1 Schedule

 - [ ] Comprehension of features definition and meaning
	 - [ ] Creation of a small word file with all the theory concerning the features and computation method of each of them
 - [ ] Dowload the dataset ( `training2017.zip` )
	 - [ ] Capire come sono indicizzati i pazienti e quali sono le informazioni presenti per ognuno
	 - [ ] Data exploration è stata già fatta da physionet quando ha pubblicato la challenge (vedi sopra Challenge Data)
 - [ ] Definizione di una pipeline di processing che sia ad hoc per ogni paziente
	 - [ ] Pre-processing:
		 - [ ] Check for possible direction inversion of recording #TO_UNDERSTAND 
		 - [ ] Electronic noise filtering #TO_UNDERSTAND 
		 - [ ] Removal of pneumonic induced noise and muscular activity
			 - [ ] Ipotesi: probabilmente si tratta della baseline correction (fatta con movmean)
		 - [ ] Filtering in physiological band
			 - [ ] Ipotesi: probabilmente (0.4-60 Hz) (0.5 -50 Hz)
		 - [ ] Baseline Correction (*movmean removal*)
			 - [ ] Ipoteticamente potrebbe già essere compresa nello step di Band-Passing #TO_UNDERSTAND 
	 - [ ] Feature Extraction
		 - [ ] Morphological Feature
			 - [ ] QRS Duration (Onset-Offset)
			 - [ ] PR Interval
			 - [ ] QT Interval
			 - [ ] QS Interval
			 - [ ] ST Interval
			 - [ ] P Amplitude
			 - [ ] Q Amplitude
			 - [ ] R Amplitude
			 - [ ] S Amplitude
			 - [ ] T Ampliture
		 - [ ] AF Features
			 - [ ] AFEv
			 - [ ] Shannon Entropy
			 - [ ] Radius
			 - [ ] Kolmogorov-Smirnov Test Value
		 - [ ] RR intervals Features
			 - [ ] Median RR Interval
			 - [ ] Index for Arrhythmia
		 - [ ] Similarity index between beats Features
			 - [ ] Similarity index of QRS
			 - [ ] Similarity index of R amplitude
			 - [ ] Ration of high similarity beats
			 - [ ] Signal Qualify index
 - [ ] Costruzione di una funzione che estragga i valori del paziente sulla base del suo "Nome"
 - [ ] Realizzazione della funzione che mette in pratica la pipeline
 - [ ] Costituzione di una matrice che divenga il dataset per il training del modello

![[Pasted image 20230419094805.png|330]] ![[Pasted image 20230419105549.png|330]]
## Pt. 2 Schedule

- [ ] Separazione del training set in 3: Training, Validation e Test
- [ ] Training dei vari modelli
- [ ] Confrontiamo con i risultati del paper dei cinesi (Random Forest)
- [ ] FESTEGGIARE ! ✨🍾🎉


> [!Warning] Dubbi:
>  - Poincarè / Lorenz plot
> 	 - ![[Pasted image 20230419110839.png|800]]
>  - 
>  - 
> 


# Bibliography

![[Detection of Atrial Fibrillation using Decision Tree Ensamble.pdf]]
# Context


### Who is working on it ?
[[Filippo Castellani]]
[[Chiara Boscarino]]
[[Antonella Lombardi]]
