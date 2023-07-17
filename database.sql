PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE creazione_esame (
	"idD" INTEGER NOT NULL, 
	"idE" INTEGER NOT NULL, ruolo_docente VARCHAR(100), 
	PRIMARY KEY ("idD", "idE"), 
	FOREIGN KEY("idD") REFERENCES docente ("idD"), 
	FOREIGN KEY("idE") REFERENCES esame ("idE")
);
INSERT INTO creazione_esame VALUES('95d00cda-997b-40b1-aea4-035a8b287dd0','CT-0006','Presidente');
INSERT INTO creazione_esame VALUES('95d00cda-997b-40b1-aea4-035a8b287dd0','CT-0374','Presidente');
INSERT INTO creazione_esame VALUES('e3b6fe9b-17e4-4329-90fb-23d0fbf750e2','CT-0006','Membro');
CREATE TABLE registrazione_esame (
	"idS" INTEGER NOT NULL, 
	"idE" INTEGER NOT NULL, 
	voto INTEGER, 
	data_superamento DATE, 
	PRIMARY KEY ("idS", "idE"), 
	FOREIGN KEY("idE") REFERENCES esame ("idE"), 
	FOREIGN KEY("idS") REFERENCES studente ("idS")
);
CREATE TABLE alembic_version (
	version_num VARCHAR(32) NOT NULL, 
	CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
);
INSERT INTO alembic_version VALUES('4deddb51d465');
CREATE TABLE IF NOT EXISTS "docente" (
	"idD" VARCHAR(100) NOT NULL, 
	nome VARCHAR(100), 
	cognome VARCHAR(100), 
	email VARCHAR(100), 
	password VARCHAR(100), 
	PRIMARY KEY ("idD"), 
	UNIQUE (email), 
	UNIQUE ("idD")
);
INSERT INTO docente VALUES('e3b6fe9b-17e4-4329-90fb-23d0fbf750e2','Stefano','Calzavara','scalzavara@unive.it','pbkdf2:sha256:260000$EdIRAEJTBYKv58rH$98fe4d565b9ab7ba3eceff074ea3e3e20085894e4b705ae367d74520ad4f0156');
INSERT INTO docente VALUES('95d00cda-997b-40b1-aea4-035a8b287dd0','Alessandra','Raffaet├á','alessandraraffaeta@unive.it','pbkdf2:sha256:260000$vcPjCmfvWB2I76Pb$6ce63b5be25cf205230e432e0e7ee581fae65b46cb2df9b96b3548f556e516fd');
INSERT INTO docente VALUES('23daacd9-39f7-498a-b992-99ef23eb1762','Andrea','Marin','andreamarin@unive.it','pbkdf2:sha256:260000$iZAh4j4fYKe7ip8o$f39f746959b6b1973fbd1ef25f08c66c70a61617845a2834442a3ecea62e1dde');
CREATE TABLE IF NOT EXISTS "prova" (
	"idP" VARCHAR(100) NOT NULL, 
	tipo_voto VARCHAR(100), 
	"idE" VARCHAR(100), 
	tipo_prova VARCHAR(8), 
	nome_prova VARCHAR(100), 
	"idD" INTEGER, 
	data DATE, 
	data_scadenza DATE, 
	ora_prova VARCHAR(100), percentuale INTEGER, 
	PRIMARY KEY ("idP"), 
	FOREIGN KEY("idD") REFERENCES docente ("idD"), 
	FOREIGN KEY("idE") REFERENCES esame ("idE")
);
INSERT INTO prova VALUES('CT-0006 1P','Media','CT-0006','scritto','Prima Prova Parziale','e3b6fe9b-17e4-4329-90fb-23d0fbf750e2','2023-06-10','2024-06-10','15:00',50);
INSERT INTO prova VALUES('CT-0006 2P','Media','CT-0006','scritto','Seconda Prova Intermedia','95d00cda-997b-40b1-aea4-035a8b287dd0','2023-06-15','2023-09-29','17:57',30);
INSERT INTO prova VALUES('CT-0006 COMPLETO','Trentesimi','CT-0006','scritto','BASI DI DATI ESAME COMPLETO','95d00cda-997b-40b1-aea4-035a8b287dd0','2023-07-07','2023-11-30','20:00',80);
INSERT INTO prova VALUES('CT-0006 PROGETTO','Media','CT-0006','orale','Presentazione Progetto','95d00cda-997b-40b1-aea4-035a8b287dd0','2023-06-27','2023-11-23','20:00',20);
CREATE TABLE IF NOT EXISTS "esame" (
	"idE" VARCHAR(100) NOT NULL, 
	nome VARCHAR(100), 
	anno_accademico VARCHAR(100), 
	cfu INTEGER, 
	PRIMARY KEY ("idE"), 
	UNIQUE ("idE")
);
INSERT INTO esame VALUES('CT-0006','BASI DI DATI','2022/2023',12);
INSERT INTO esame VALUES('CT-0374','ALGORITMI E STRUTTURE DATI','2022/2023',12);
CREATE TABLE IF NOT EXISTS "studente" (
	"idS" INTEGER NOT NULL, 
	nome VARCHAR(100), 
	cognome VARCHAR(100), 
	PRIMARY KEY ("idS"), 
	UNIQUE ("idS")
);
INSERT INTO studente VALUES(874035,'Giulia','Zammaraci');
INSERT INTO studente VALUES(885113,'Martina','Ragusa');
INSERT INTO studente VALUES(885771,'Rebecca','Frisoni');
INSERT INTO studente VALUES(886234,'Giovanni','Muchacha');
INSERT INTO studente VALUES(886744,'Luca Vincenzo','Biscotti');
INSERT INTO studente VALUES(886854,'Jinpeng','Zhang');
CREATE TABLE IF NOT EXISTS "_alembic_tmp_Appelli" (
	"idS" INTEGER NOT NULL, 
	"idE" VARCHAR(100) NOT NULL, 
	voto INTEGER, 
	stato_superamento BOOLEAN, 
	CONSTRAINT "fk_appelli_idE_esame" FOREIGN KEY("idE") REFERENCES esame ("idE"), 
	CONSTRAINT "fk_appelli_idS_studente" FOREIGN KEY("idS") REFERENCES studente ("idS")
);
CREATE TABLE IF NOT EXISTS "Appelli" (
	"idS"	INTEGER NOT NULL,
	"voto"	INTEGER,
	"stato_superamento"	BOOLEAN,
	"idP"	VARCHAR(100),
	FOREIGN KEY("idS") REFERENCES "studente"("idS"),
	FOREIGN KEY("idP") REFERENCES "prova"("idP")
);
INSERT INTO Appelli VALUES(886854,15,0,'CT-0006 1P');
INSERT INTO Appelli VALUES(886744,19,1,'CT-0006 2P');
INSERT INTO Appelli VALUES(886234,22,1,'CT-0006 COMPLETO');
INSERT INTO Appelli VALUES(886234,28,1,'CT-0006 PROGETTO');
INSERT INTO Appelli VALUES(886744,20,1,'CT-0006 1P');
INSERT INTO Appelli VALUES(886744,25,1,'CT-0006 PROGETTO');
COMMIT;
