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
			 - [ ] Ipotesi: probabilmente (2-50 Hz)
				 - [x] Stiamo tranquilli per la muscular noise e anche per il power line noise
				 - [x] Perche Butterworh e di che ordine ? 
				 - [ ] Ce ne freghiamo della fase non lineare e facciamo filt filt !
		 - [x] Baseline Correction (*movmean removal*)
			 - [x] Ipoteticamente potrebbe già essere compresa nello step di Band-Passing (CONFERMATO)
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
			 - [x] [[AFEv]] 
				 - [ ] DOUBT: ma nel nostro caso come facciamo ad identificare il raggio del bin centrale ?
			 - [x] Radius [[AFEv#Radius sub-feature]]
			 - [x] [[Shannon Entropy]] 
			 - [ ] [[Kolmogorov-Smirnov Test Value]]
		 - [ ] RR intervals Features
			 - [x] Median RR Interval
			 - [x] [[Index for Arrhythmia]]
				 - [ ] DOUBT: vedi all'interno della nota
		 - [ ] [[Similarity Indexes Between Beats|Similarity index between beats Features]]
			 - [x] [[Similarity Indexes Between Beats#Similarity index of QRS (F40)|Similarity index of QRS]]
			 - [x] [[Similarity Indexes Between Beats#Similarity index of R amplitude (F41)|Similarity index of R amplitude]]
			 - [ ] Ratio of high similarity beats
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
