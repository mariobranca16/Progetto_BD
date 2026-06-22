drop database if exists CreazioneDatabase;
create database CreazioneDatabase;
use CreazioneDatabase;

CREATE TABLE Utente (
	NomeUtente VARCHAR(100) NOT NULL UNIQUE PRIMARY KEY, 
    Email VARCHAR (100) NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Cognome VARCHAR(100) NOT NULL,
    DataDiNascita DATE NOT NULL,
    Via VARCHAR(100) NOT NULL,
    Civico SMALLINT NOT NULL,
    CAP VARCHAR(5) NOT NULL, 
    Citta VARCHAR(100) NOT NULL, 
    Provincia VARCHAR(100) NOT NULL,
    CHECK (CHAR_LENGTH(CAP) = 5)
);

CREATE TABLE Camera (
	CodiceCamera INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Capacita INT NOT NULL,
    Piano INT NOT NULL,
    PrezzoPerNotte DOUBLE NOT NULL,
    StatoCamera ENUM('Disponibile', 'Occupata', 'Da Sistemare') NOT NULL,
    TipoCamera ENUM('Singola', 'Doppia', 'Deluxe') NOT NULL, 
    Vista VARCHAR(50) NULL,
    TipoLetto VARCHAR(50) NULL, 
    Balcone ENUM('Si', 'No') NULL,
    CHECK (StatoCamera IN ('Disponibile', 'Occupata', 'Da Sistemare')),
    CHECK (TipoCamera <> 'Doppia' OR (Vista IS NOT NULL AND TipoLetto IS NOT NULL)),
    CHECK (TipoCamera <> 'Deluxe' OR (Balcone IN ('Si', 'No'))),
    CHECK (TipoCamera IN ('Singola', 'Doppia', 'Deluxe'))
);

CREATE TABLE Servizio (
	CodiceServizio INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Prezzo DOUBLE NOT NULL,
    Descrizione VARCHAR(255),
    Categoria VARCHAR(50),
    CHECK (Prezzo >= 0)
);

CREATE TABLE Telefono (
	Numero VARCHAR(20) NOT NULL PRIMARY KEY,
    Utente VARCHAR (100) NOT NULL UNIQUE,
    FOREIGN KEY (Utente) REFERENCES Utente(NomeUtente) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Prenotazione (
	IDPrenotazione INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    StatoPrenotazione ENUM('Confermata', 'In Attesa', 'Annullata') NOT NULL,
    MetodoPagamento VARCHAR(20) NOT NULL,
    DataPrenotazione DATE NOT NULL,
    AccontoVersato DOUBLE,
    Utente VARCHAR (100) NOT NULL UNIQUE,
    FOREIGN KEY (Utente) REFERENCES Utente(NomeUtente) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (AccontoVersato IS NULL OR AccontoVersato >= 0),
    CHECK (StatoPrenotazione IN ('Confermata', 'In Attesa', 'Annullata'))
);

CREATE TABLE Soggiorno (
	IDSoggiorno INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    NumeroOspiti INT NOT NULL,
    StatoSoggiorno VARCHAR(20) NOT NULL,
    DataCheckIn DATE NOT NULL,
    DataCheckOut DATE NOT NULL,
    TassaDiSoggiorno DOUBLE,
    Prenotazione INT NOT NULL,
    FOREIGN KEY (Prenotazione) REFERENCES Prenotazione(IDPrenotazione) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (DataCheckIn < DataCheckOut),
	CHECK (NumeroOspiti > 0),
	CHECK (TassaDiSoggiorno IS NULL OR TassaDiSoggiorno >= 0),
	CHECK (StatoSoggiorno IN ('Attivo','Concluso','Annullato'))
);

CREATE TABLE Assegnazione (
	Soggiorno INT NOT NULL,
    Camera INT NOT NULL,
    InizioAssegnazione DATE NOT NULL,
    FineAssegnazione DATE,
    PRIMARY KEY (Soggiorno, Camera),
    FOREIGN KEY (Soggiorno) REFERENCES Soggiorno(IDSoggiorno) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Camera) REFERENCES Camera(CodiceCamera) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (FineAssegnazione IS NULL OR InizioAssegnazione < FineAssegnazione)
);

CREATE TABLE Fornitura ( 
	Servizio INT NOT NULL,
    Camera INT NOT NULL,
    PRIMARY KEY (Servizio, Camera),
    FOREIGN KEY (Servizio) REFERENCES Servizio(CodiceServizio) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Camera) REFERENCES Camera(CodiceCamera) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Recensione ( 
	IDRecensione INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Valutazione INT NOT NULL,
    Descrizione VARCHAR(255),
    Utente VARCHAR (100) NOT NULL UNIQUE,
    DataPubblicazione DATE NOT NULL,
    Soggiorno INT NOT NULL,
    FOREIGN KEY (Utente) REFERENCES Utente(NomeUtente) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Soggiorno) REFERENCES Soggiorno(IDSoggiorno) ON DELETE CASCADE ON UPDATE CASCADE,
	CHECK (Valutazione BETWEEN 1.0 AND 10.0)
);

INSERT INTO Utente (NomeUtente, Email, Nome, Cognome, DataDiNascita, Via, Civico, CAP, Citta, Provincia) VALUES 
('mario.rossi75', 'mario.rossi75@email.com', 'Mario', 'Rossi', '1975-06-15', 'Via Dante Alighieri', 12, '00184', 'Roma', 'RM'),
('laura.bianchi82', 'laura.bianchi82@email.com', 'Laura', 'Bianchi', '1982-02-28', 'Viale Europa', 45, '20131', 'Milano', 'MI'),
('gianni.verdi90', 'gianni.verdi90@email.com', 'Gianni', 'Verdi', '1990-03-12', 'Corso Vittorio Emanuele', 7, '80121', 'Napoli', 'NA'),
('luca.cartelli85', 'luca.cartelli85@email.com', 'Luca', 'Cartelli', '1985-11-05', 'Via Garibaldi', 23, '10121', 'Torino', 'TO'),
('maria.fancelli88', 'maria.fancelli88@email.com', 'Maria', 'Fancelli', '1988-04-18', 'Piazza del Duomo', 3, '50122', 'Firenze', 'FI'),
('alessandro.santi80', 'alessandro.santi80@email.com', 'Alessandro', 'Santi', '1980-09-09', 'Via Mazzini', 8, '16121', 'Genova', 'GE'),
('marco.romani79', 'marco.romani79@email.com', 'Marco', 'Romani', '1979-07-21', 'Via Indipendenza', 14, '40121', 'Bologna', 'BO'),
('trina.mangano86', 'trina.mangano86@email.com', 'Trina', 'Mangano', '1986-12-12', 'Via del Mare', 30, '70121', 'Bari', 'BA'),
('stefano.nfr87', 'stefano.nfr87@email.com', 'Stefano', 'Neri', '1987-03-29', 'Corso Italia', 11, '37121', 'Verona', 'VR'),
('elisa.ferrari89', 'elisa.ferrari89@email.com', 'Elisa', 'Ferrari', '1989-10-10', 'Viale dei Mille', 6, '30121', 'Venezia', 'VE'),
('roberto.marin91', 'roberto.marin91@email.com', 'Roberto', 'Marini', '1991-01-20', 'Via Libertà', 19, '90133', 'Palermo', 'PA'),
('chiara.caglieri92', 'chiara.caglieri92@email.com', 'Chiara', 'Caglieri', '1992-05-14', 'Via Vittorio Veneto', 8, '95121', 'Catania', 'CT'),
('simone.salmeri93', 'simone.salmeri93@email.com', 'Simone', 'Salmeri', '1993-06-17', 'Corso Umberto I', 27, '34121', 'Trieste', 'TS'),
('valentina.tondi94', 'valentina.tondi94@email.com', 'Valentina', 'Tondi', '1994-04-22', 'Piazza Matteotti', 5, '33100', 'Udine', 'UD'),
('davide.longo95', 'davide.longo95@email.com', 'Davide', 'Longo', '1995-08-30', 'Via Roma', 36, '06121', 'Perugia', 'PG'),
('federica.corradini96', 'federica.corradini96@email.com', 'Federica', 'Corradini', '1996-11-11', 'Viale Gioberti', 12, '84121', 'Salerno', 'SA'),
('alessio.lessani97', 'alessio.lessani97@email.com', 'Alessio', 'Lessani', '1997-07-19', 'Via Dante', 3, '56121', 'Pisa', 'PI'),
('ilaria.marzotto98', 'ilaria.marzotto98@email.com', 'Ilaria', 'Marzotto', '1998-05-03', 'Corso Italia', 40, '73100', 'Lecce', 'LE'),
('giorgio.messina99', 'giorgio.messina99@email.com', 'Giorgio', 'Messina', '1999-03-14', 'Viale Europa', 17, '42121', 'Reggio Emilia', 'RE'),
('marta.tancredi00', 'marta.tancredi00@email.com', 'Marta', 'Tancredi', '2000-12-25', 'Via Garibaldi', 9, '70100', 'Bari', 'BA');
  
INSERT INTO Camera (Capacita, Piano, PrezzoPerNotte, StatoCamera, TipoCamera, Vista, TipoLetto, Balcone) VALUES
(1, 1, 75.50, 'Disponibile', 'Singola', NULL, NULL, NULL),
(2, 2, 115.00, 'Disponibile', 'Doppia', 'Vista Mare', 'Matrimoniale', NULL),
(3, 3, 220.00, 'Da Sistemare', 'Deluxe', NULL, NULL, 'Si'),
(1, 1, 80.00, 'Disponibile', 'Singola', NULL, NULL, NULL),
(2, 2, 125.00, 'Occupata', 'Doppia', 'Centro Città', 'Matrimoniale', NULL),
(3, 4, 230.00, 'Disponibile', 'Deluxe', NULL, NULL, 'No'),
(1, 1, 85.00, 'Disponibile', 'Singola', NULL, NULL, NULL),
(2, 3, 130.00, 'Disponibile', 'Doppia', 'Vista Collina', 'Matrimoniale', NULL),
(3, 4, 240.00, 'Da Sistemare', 'Deluxe', NULL, NULL, 'Si'),
(1, 1, 90.00, 'Disponibile', 'Singola', NULL, NULL, NULL),
(2, 2, 120.00, 'Occupata', 'Doppia', 'Vista Lago', 'Matrimoniale', NULL),
(3, 3, 250.00, 'Disponibile', 'Deluxe', NULL, NULL, 'No'),
(1, 1, 70.00, 'Disponibile', 'Singola', NULL, NULL, NULL),
(2, 2, 110.00, 'Disponibile', 'Doppia', 'Vista Giardino', 'Matrimoniale', NULL),
(3, 3, 210.00, 'Occupata', 'Deluxe', NULL, NULL, 'Si'),
(1, 1, 95.00, 'Disponibile', 'Singola', NULL, NULL, NULL),	 
(2, 2, 135.00, 'Disponibile', 'Doppia', 'Vista Città', 'Matrimoniale', NULL),
(3, 4, 260.00, 'Da Sistemare', 'Deluxe', NULL, NULL, 'No'),
(1, 1, 100.00, 'Disponibile', 'Singola', NULL, NULL, NULL),
(2, 2, 140.00, 'Occupata', 'Doppia', 'Vista Mare', 'Matrimoniale', NULL);

INSERT INTO Servizio (Nome, Prezzo, Descrizione, Categoria) VALUES 
('WiFi', 0.00, 'Accesso gratuito alla rete wireless in tutte le aree', 'Servizi'),
('Colazione', 12.50, 'Colazione a buffet con opzioni dolci e salate', 'Ristorazione'),
('Parcheggio Custodito', 15.00, 'Parcheggio custodito 24 ore su 24', 'Extra'),
('Navetta Aeroporto', 5.00, 'Servizio navetta da/per l’aeroporto', 'Trasporti'),
('Servizio in Camera', 20.00, 'Consegna di cibo e bevande direttamente in camera', 'Ristorazione'),
('Accesso Spa', 40.00, 'Ingresso e trattamento base in spa', 'Benessere'),
('Centro Fitness', 10.00, 'Accesso gratuito alla palestra e attrezzature', 'Servizi'),
('Piscina Riscaldata', 30.00, 'Accesso alla piscina riscaldata interna ed esterna', 'Servizi'),
('Guida Turistica', 20.00, 'Disponibilità di una guida dedicata per la visita delle attrazioni turistiche', 'Servizi'),
('Frigo minibar', 75.00, 'Presenza in stanza di un frigo minbar con snack e bevande', 'Ristorazione');

INSERT INTO Telefono (Numero, Utente) VALUES 
('+39 347 8123456', 'mario.rossi75'),
('+39 348 9211345', 'laura.bianchi82'),
('+39 349 7361829', 'gianni.verdi90'),
('+39 320 5546789', 'luca.cartelli85'),
('+39 321 1122334', 'maria.fancelli88'),
('+39 327 9988776', 'alessandro.santi80'),
('+39 328 6677889', 'marco.romani79'),
('+39 329 4455667', 'trina.mangano86'),
('+39 330 3344556', 'stefano.nfr87'),
('+39 331 7788990', 'elisa.ferrari89'),
('+39 335 5544332', 'roberto.marin91'),
('+39 336 2211445', 'chiara.caglieri92'),
('+39 337 9988112', 'simone.salmeri93'),
('+39 338 8877665', 'valentina.tondi94'),
('+39 339 7766554', 'davide.longo95'),
('+39 340 6655443', 'federica.corradini96'),
('+39 341 5544332', 'alessio.lessani97'),
('+39 342 4433221', 'ilaria.marzotto98'),
('+39 343 3322110', 'giorgio.messina99'),
('+39 344 2211009', 'marta.tancredi00');

INSERT INTO Prenotazione (StatoPrenotazione, MetodoPagamento, DataPrenotazione, AccontoVersato, Utente) VALUES
('In Attesa', 'Carta di Credito', '2023-01-10', 45.00, 'mario.rossi75'),
('Confermata', 'Contanti', '2021-07-12', 0.00, 'laura.bianchi82'),
('Annullata', 'Carta di Credito', '2023-07-15', 30.00, 'gianni.verdi90'),
('Confermata', 'Bonifico', '2020-04-16', 60.00, 'luca.cartelli85'),
('In Attesa', 'Carta di Credito', '2019-06-18', 25.00, 'maria.fancelli88'),
('Confermata', 'Contanti', '2019-08-19', 0.00, 'alessandro.santi80'),
('Annullata', 'Carta di Credito', '2023-05-15', 40.00, 'marco.romani79'),
('In Attesa', 'Bonifico', '2022-08-01', 15.00, 'trina.mangano86'),
('Confermata', 'Carta di Credito', '2023-12-23', 70.00, 'stefano.nfr87'),
('Confermata', 'Contanti', '2018-11-24', 0.00, 'elisa.ferrari89'),
('In Attesa', 'Carta di Credito', '2023-07-10', 30.00, 'roberto.marin91'),
('Confermata', 'Bonifico', '2021-11-06', 80.00, 'chiara.caglieri92'),
('Annullata', 'Carta di Credito', '2023-07-27', 50.00, 'simone.salmeri93'),
('In Attesa', 'Contanti', '2018-10-13', 20.00, 'valentina.tondi94'),
('Confermata', 'Carta di Credito', '2023-01-29', 0.00, 'davide.longo95'),
('Confermata', 'Bonifico', '2017-06-30', 40.00, 'federica.corradini96'),
('In Attesa', 'Carta di Credito', '2022-07-26', 35.00, 'alessio.lessani97'),
('Confermata', 'Contanti', '2021-04-04', 0.00, 'ilaria.marzotto98'),
('Annullata', 'Carta di Credito', '2023-04-03', 20.00, 'giorgio.messina99'),
('Confermata', 'Bonifico', '2020-05-21', 60.00, 'marta.tancredi00');
  
INSERT INTO Soggiorno (NumeroOspiti, StatoSoggiorno, DataCheckIn, DataCheckOut, TassaDiSoggiorno, Prenotazione) VALUES 
(2, 'Attivo', '2023-05-07', '2023-05-14', 12.00, 1),
(1, 'Concluso', '2022-01-04', '2022-01-11', 6.00, 2),
(1, 'Annullato', '2024-09-02', '2024-09-09', 8.00, 3),
(3, 'Concluso', '2021-09-24', '2021-10-01', 18.00, 4),
(2, 'Attivo', '2020-08-07', '2020-08-14', 10.00, 5),
(1, 'Concluso', '2019-10-08', '2019-10-15', 7.00, 6),	
(2, 'Annullato', '2023-07-09', '2023-07-16', 9.00, 7),
(1, 'Attivo', '2022-11-03', '2022-11-10', 6.00, 8),
(3, 'Concluso', '2024-02-11', '2024-02-18', 14.00, 9),
(2, 'Attivo', '2019-02-26', '2019-03-05', 11.00, 10),
(1, 'Concluso', '2023-08-13', '2023-08-20', 6.00, 11),
(2, 'Attivo', '2022-06-15', '2022-06-22', 12.00, 12),
(1, 'Annullato', '2024-12-11', '2024-12-18', 7.00, 13),
(3, 'Concluso', '2019-02-22', '2019-03-01', 17.00, 14),
(2, 'Attivo', '2023-08-17', '2023-08-24', 10.00, 15),
(1, 'Concluso', '2018-04-18', '2018-04-25', 8.00, 16),
(2, 'Attivo', '2022-07-19', '2022-07-26', 10.00, 17),
(1, 'Concluso', '2022-10-26', '2022-11-02', 6.00, 18),
(2, 'Annullato', '2023-04-02', '2023-04-09', 9.00, 19),
(1, 'Attivo', '2021-05-13', '2021-05-20', 7.00, 20);

INSERT INTO Assegnazione (Soggiorno, Camera, InizioAssegnazione, FineAssegnazione) VALUES 
(1, 2, '2023-05-07', '2023-05-14'),
(2, 5, '2022-01-04', '2022-01-11'),
(3, 4, '2024-09-02', '2024-09-09'),
(4, 7, '2021-09-24', '2021-10-01'),
(5, 8, '2020-08-07', '2020-08-14'),
(6, 9, '2019-10-08', '2019-10-15'),
(7, 10, '2023-07-09', '2023-07-16'),
(8, 11, '2022-11-03', '2022-11-10'),
(9, 12, '2024-02-11', '2024-02-18'),
(10, 13, '2019-02-26', '2019-03-05'),
(11, 14, '2023-08-13', '2023-08-20'),
(12, 15, '2022-06-15', '2022-06-22'),
(13, 16, '2024-12-11', '2024-12-18'),
(14, 17, '2019-02-22', '2019-03-01'),
(15, 18, '2023-08-17', '2023-08-24'),
(16, 19, '2018-04-18', '2018-04-25'),
(17, 20, '2022-07-19', '2022-07-26'),
(18, 1, '2022-10-26', '2022-11-02'),
(19, 3, '2023-04-02', '2023-04-09'),
(20, 2, '2021-05-13', '2021-05-20');
  
INSERT INTO Fornitura (Servizio, Camera) VALUES
(1, 1),
(1, 2),
(2, 1),
(1, 3),          
(2, 2),
(2, 4),
(3, 1),
(3, 2),
(4, 5),
(4, 6),
(4, 1),
(4, 2),
(5, 3),
(5, 7),
(5, 8),
(5, 2),
(5, 1),         
(6, 9),
(6, 10),
(6, 1),
(6, 2),
(7, 2),
(7, 3),
(7, 1),
(8, 1),
(8, 2),
(9, 4),
(9, 1),
(9, 5),
(9, 2),
(10, 6),
(10, 7),
(10, 1),
(10, 3),
(6, 5),
(5, 9),
(8, 3),
(10, 2);

INSERT INTO Recensione (Valutazione, Descrizione, Utente, DataPubblicazione, Soggiorno) VALUES 
(8, 'Il soggiorno è stato piacevole; la camera era spaziosa e pulita.', 'mario.rossi75', '2023-05-15', 1),
(7, 'Buon rapporto qualità-prezzo, servizio cortese.', 'laura.bianchi82', '2022-01-12', 2),
(1, 'Soggiorno annullato a causa di imprevisti; esperienza non avuta modo di valutare.', 'gianni.verdi90', '2024-09-10', 3),
(8, 'La struttura è ben mantenuta e il personale è molto disponibile.', 'luca.cartelli85', '2021-10-02', 4),
(6, 'La camera era rumorosa a causa dei lavori in corso, ma altrimenti soddisfacente.', 'maria.fancelli88', '2020-08-15', 5),
(8, 'Ambiente accogliente e posizione centrale, consigliato per brevi soggiorni.', 'alessandro.santi80', '2019-10-16', 6),
(6, 'Il servizio in camera è stato lento, ma la cortesia del personale ha compensato.', 'marco.romani79', '2023-07-17', 7),
(9, 'Colazione eccellente e camere ben arredate; ottima esperienza complessiva.', 'trina.mangano86', '2022-11-11', 8),
(8, 'Struttura tranquilla, ideale per rilassarsi, anche se l’arredamento è datato.', 'stefano.nfr87', '2024-02-19', 9),
(7, 'La camera era accogliente ma leggermente piccola per il prezzo richiesto.', 'elisa.ferrari89', '2019-03-06', 10),
(6, 'Servizio di reception lento, ma la pulizia era impeccabile.', 'roberto.marin91', '2023-08-21', 11),
(10, 'Esperienza di alto livello, la posizione e la vista dalla camera sono impareggiabili.', 'chiara.caglieri92', '2022-06-23', 12),
(3, 'Non sono rimasto soddisfatto; troppi disservizi durante il soggiorno.', 'simone.salmeri93', '2024-12-19', 13),
(8, 'Ambiente sereno e personale cordiale, consigliato per chi cerca tranquillità.', 'valentina.tondi94', '2019-03-02', 14),
(6, 'La struttura offre buone prestazioni, sebbene la colazione potesse essere migliore.', 'davide.longo95', '2023-08-25', 15),
(9, 'Servizio impeccabile e camere molto confortevoli; tornerò sicuramente.', 'federica.corradini96', '2018-04-26', 16),
(8, 'Ideale per una breve vacanza, ma con margini di miglioramento per il servizio in camera.', 'alessio.lessani97', '2022-07-27', 17),
(7, 'La posizione è ottima, ma il check-in è risultato troppo lungo.', 'ilaria.marzotto98', '2022-11-03', 18),
(6, 'La camera era pulita, ma l’isolamento acustico lascia a desiderare.', 'giorgio.messina99', '2023-04-10', 19),
(10, 'Esperienza fantastica: ottimi servizi, personale gentile e ambiente rilassante.', 'marta.tancredi00', '2021-05-21', 20);
    