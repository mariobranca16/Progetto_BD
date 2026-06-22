use CreazioneDatabase;

-- 1) Selezione ordinata su un attributo di una tabella con condizioni di AND e OR:
-- Elencare in ordine decrescente sul NomeUtente, le Prenotazioni in cui lo stato è "Confermata" e dove il cliente ha pagato in contanti
-- oppure con bonifico.

SELECT u.NomeUtente, u.Email, p.IDPrenotazione, p.DataPrenotazione
FROM Prenotazione p, Utente u
WHERE p.Utente = u.NomeUtente AND 
	  p.StatoPrenotazione = 'Confermata' AND 
      (p.MetodoPagamento = 'Contanti' OR p.MetodoPagamento = 'Bonifico')
ORDER BY u.NomeUtente DESC;


-- 2) Selezione su due o più tabelle con condizioni:
-- Elencare le assegnazioni in cui la camera è situtata al piano 2 ed il relativo soggiorno è concluso.
-- (TipoCamera, DataInizioAssegnazione, DataFineAssegnazione, Piano, StatoSoggiorno).

SELECT c.TipoCamera, a.InizioAssegnazione, a.FineAssegnazione, c.Piano, s.StatoSoggiorno
FROM Assegnazione a, Camera c, Soggiorno s
WHERE a.Camera = c.CodiceCamera AND
	  a.Soggiorno = s.IDSoggiorno AND
      c.Piano = 2 AND 
      s.StatoSoggiorno = 'Concluso';
      
      
-- 3) Selezione aggregata su tutti i valori:
-- Calcolare il totale degli acconti versati nelle prenotazioni del 2023.

SELECT SUM(AccontoVersato) AS TotaleAcconti
FROM Prenotazione
WHERE YEAR(DataPrenotazione) = 2023;


-- 4) Selezione aggregata su raggruppamenti:
-- Elencare, per ogni tipo di Camera, il numero di camere disponibili e la somma totale del PrezzoPerNotte di ciascuna.
-- (TipoCamera, NumeroCamereDisponibili, SommaPrezzoPerNotte).

SELECT TipoCamera, COUNT(*) AS NumeroCamereDisponibili, SUM(PrezzoPerNotte) AS SommaPrezzoPerNotte
FROM Camera
WHERE StatoCamera = 'Disponibile'
GROUP BY TipoCamera;


-- 5) Selezione aggregata su raggruppamenti con condizioni:
-- Elencare, per ogni Servizio, il numero di Camere in cui è incluso, mostrando solo quelli offerti da almeno 3 camere.
-- (CodiceServizio, Nome_Servizio, NumeroCamere).

SELECT s.CodiceServizio, s.Nome AS Nome_Servizio, s.Descrizione, COUNT(f.Camera) AS NumeroCamere
FROM Servizio s
JOIN Fornitura f ON s.CodiceServizio = f.Servizio
GROUP BY s.CodiceServizio
HAVING COUNT(f.Camera) >= 3;


-- 6) Selezione aggregata su raggruppamenti con condizioni che includano un'altra funzione di raggruppamento.
-- Elencare il tipo di camera la cui somma del prezzo per notte è la più alta.

DROP VIEW  if exists VistaTipoCameraPrezzo;

CREATE VIEW VistaTipoCameraPrezzo AS
SELECT TipoCamera, SUM(PrezzoPerNotte) AS TotalePrezzo
FROM Camera
GROUP BY TipoCamera; 

SELECT TipoCamera, TotalePrezzo
FROM VistaTipoCameraPrezzo
WHERE TotalePrezzo = (SELECT MAX(TotalePrezzo) 
					  FROM VistaTipoCameraPrezzo);


-- 7) Selezione con operazioni insiemistiche:
-- Elencare gli utenti che hanno effettuato una prenotazione nel 2022 o che hanno lasciato una recensione nel 2023
-- (Nome, Cognome, NomeUtente).

SELECT u.Nome, u.Cognome, u.NomeUtente 
FROM Utente u, Prenotazione p
WHERE u.NomeUtente = p.Utente AND YEAR(P.DataPrenotazione) = 2022

UNION

SELECT u.Nome, u.Cognome, u.NomeUtente 
FROM Utente u, Recensione r
WHERE u.NomeUtente = r.Utente AND YEAR(r.DataPubblicazione) = 2023;

-- 8) Selezione con l'uso appropriato della divisione: 
-- Elencare le camere che forniscono tutti i servizi garantiti dall'hotel (CodiceCamera, TipoCamera, Piano).

SELECT C.CodiceCamera, C.TipoCamera, C.Piano
FROM Camera C
WHERE NOT EXISTS (
					SELECT *
					FROM Servizio S
					WHERE NOT EXISTS (
										SELECT *
										FROM Fornitura F
										WHERE F.Camera = C.CodiceCamera
										AND F.Servizio = S.CodiceServizio
					)
);


