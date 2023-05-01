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
 - [x] Dowload the dataset ( `training2017.zip` )
	 - [ ] Capire come sono indicizzati i pazienti e quali sono le informazioni presenti per ognuno
	 - [x] Data exploration è stata già fatta da physionet quando ha pubblicato la challenge (vedi sopra Challenge Data)
 - [ ] Definizione di una pipeline di processing che sia ad hoc per ogni paziente
	 - [ ] Pre-processing:
		 - [ ] Check for possible direction inversion of recording #TO_UNDERSTAND 
		 - [ ] Electronic noise filtering
			 - [x] Noise was removed by low-pass filtering @ 50 Hz
			 - [ ] Ma a che frequenza era davvero il noise ?
		 - [ ] Removal of pneumonic induced noise and muscular activity
			 - [ ] Ipotesi: probabilmente si tratta della baseline correction (fatta con movmean)
		 - [ ] Filtering in physiological band
			 - [x] Abbiamo deciso (2-50 Hz)
				 - [ ] Ma quale reference citiamo che ha fatto la stessa cosa ?
				 - [x] Stiamo tranquilli per la muscular noise e anche per il power line noise
				 - [x] Perche Butterworh e di che ordine ? 
				 - [x] Ce ne freghiamo della fase non lineare e facciamo filt filt !
		 - [x] Baseline Correction (*movmean removal*)
			 - [x] Ipoteticamente potrebbe già essere compresa nello step di Band-Passing (CONFERMATO)
	 - [ ] Feature Extraction
		 - [ ] Morphological Feature ( * ) = implented on [[ECGPUWAVE Note]]
			 - [ ] Per adesso le estraiamo così però poi capiamo se farlo a mano oppure andare verso l'altra direzione ovvero mettere anche quelle di osealib (CHIEDI A MAINARDI)
			 - [ ] ![QRS1|300](https://upload.wikimedia.org/wikipedia/commons/9/9e/SinusRhythmLabels.svg)
			 - [ ] ( * ) QRS Duration (Onset-Offset) 
			 - [ ] PR Interval
			 - [ ] QT Interval
			 - [ ] QS Interval
			 - [ ] ST Interval
			 - [ ] ( * ) P Amplitude
			 - [ ] ( * ) Q Amplitude
			 - [ ] R Amplitude
			 - [ ] S Amplitude
			 - [ ] T Amplitude
				 - [ ] DOUBT: ma per ognuna di queste forse dovremmo calcolare media e varianza/standard deviation ?
				 - [ ] ![QRS|400](https://litfl.com/wp-content/uploads/2018/10/ECG-waves-segments-and-intervals-LITFL-ECG-library-3.jpg.webp)
		 - [ ] AF Features
			 - [ ] [[AFEv]] 
				 - [ ] DOUBT: ma nel nostro caso come facciamo ad identificare il raggio del bin centrale ?
			 - [ ] Radius [[AFEv#Radius sub-feature]]
			 - [ ] [[Shannon Entropy]] 
				 - [ ] Doubt: vedi nota
			 - [ ] [[Kolmogorov-Smirnov Test Value]]
				 - [ ] Doubt: vedi nota
		 - [ ] RR intervals Features
			 - [ ] Median RR Interval
			 - [ ] [[Index for Arrhythmia]]
				 - [ ] DOUBT: vedi all'interno della nota
		 - [ ] [[Similarity Indexes Between Beats|Similarity index between beats Features]]
			 - [ ] [[Similarity Indexes Between Beats#Similarity index of QRS (F40)|Similarity index of QRS]]
				 - [ ] DOUBT: vedi all'interno della nota
			 - [ ] [[Similarity Indexes Between Beats#Similarity index of R amplitude (F41)|Similarity index of R amplitude]]
				 - [ ] DOUBT: vedi all'interno della nota
			 - [ ] [[Similarity Indexes Between Beats#Ratio of high similarity beats (F42)|Ratio of high similarity beats]]
				 - [ ] DOUBT: vedi all'interno della nota
			 - [ ] [[Similarity Indexes Between Beats#Signal Qualify index (F43)|Signal Qualify index]]
				 - [ ] DOUBT: vedi all'interno della nota
 - [ ] Costruzione di una funzione che estragga i valori del paziente sulla base del suo "Nome"
 - [ ] Realizzazione della funzione che mette in pratica la pipeline
 - [ ] Costituzione di una matrice che divenga il dataset per il training del modello

![[Pasted image 20230419094805.png|300]] ![[Pasted image 20230419105549.png|300]]
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
