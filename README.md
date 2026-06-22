# Progetto di Basi di Dati - Gestione di un Hotel

Progetto realizzato per l'esame di Basi di Dati.
Consiste nella creazione di un database di un hotel che gestisce online i clienti, le loro prenotazioni, i soggiorni, le camere, i servizi e le recensioni. Comprende la progettazione (schema E-R e schema logico), il database in MySQL con i dati di esempio, le query richieste e una piccola applicazione Java che accede al database tramite JDBC.

## Tecnologie usate

- MySQL per il database
- SQL per la creazione delle tabelle, il popolamento e le query
- Java con i driver JDBC per l'applicazione

## Struttura del progetto

├── sql/

│   ├── CreazioneDatabase.sql      creazione tabelle e dati di esempio

│   └── Queries.sql                le query del progetto

├── jdbc/

│   ├── src/Main.java              applicazione Java con JDBC

│   └── lib/                       driver MySQL Connector/J

└── docs/                          schemi E-R e presentazione

## Query

Il file `sql/Queries.sql` contiene una query per ognuna delle tipologie richieste dal corso: selezione ordinata con AND e OR, selezione su più tabelle, selezioni aggregate (su tutti i valori, con raggruppamenti, con condizioni e con funzione annidata), operazione insiemistica con UNION e divisione.

## Come avviare il progetto

1. Aprire MySQL Workbench ed eseguire lo script `sql/CreazioneDatabase.sql` per creare e popolare il database.
2. Eseguire le query in `sql/Queries.sql`.
3. Per l'applicazione Java, inserire le proprie credenziali MySQL all'inizio di `Main.java` (`user` e `password`), poi compilare ed eseguire includendo il driver della cartella `lib` nel classpath.

L'applicazione mostra un menù da cui si può inserire, modificare, cancellare e visualizzare i dati della tabella Utente.

## Autore

Mario Branca
