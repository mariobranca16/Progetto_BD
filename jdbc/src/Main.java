import java.sql.*;
import java.time.LocalDate;
import java.util.Scanner;

public class Main {
    private static Connection connection;
    private static Statement statement;
    private static final Scanner scanner = new Scanner(System.in);

    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/CreazioneDatabase";
        String user = "root";
        String password = "[PASSWORD]";

        try {
            connection = DriverManager.getConnection(url, user, password);
            System.out.println("Connessione al database riuscita");

            printMenu();

            int scelta;
            do {
                System.out.print("Quale operazione si vuole effettuare? : ");
                scelta = Integer.parseInt(scanner.nextLine());
                switch (scelta) {
                    case 1:
                        inserimento();
                        break;
                    case 2:
                        modifica();
                        break;
                    case 3:
                        cancellazione();
                        break;
                    case 4:
                        query();
                        break;
                    case 5:
                        break;
                    default:
                        System.out.println("\nScelta non valida, reinserire un numero: ");
                }
            } while(scelta != 5);
            connection.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private static void printMenu(){
        System.out.println("1. Inserimento\n" +
                "2. Modifica\n" +
                "3. Cancellazione\n" +
                "4. Visualizzazione della tabella\n" +
                "5. Uscita dal programma\n");
    }


    private static void inserimento(){
        System.out.println("\n----Inserimento tabella Utente----\n");

        System.out.print("Inserire il nome utente: ");
        String nomeUtente = scanner.nextLine();

        System.out.print("Inserire l'email: ");
        String email = scanner.nextLine();

        System.out.print("Inserire il nome: ");
        String nome = scanner.nextLine();

        System.out.print("Inserire il cognome: ");
        String cognome = scanner.nextLine();

        System.out.print("Inserire la data di nascita (AAAA-MM-GG): ");
        LocalDate dataDiNascita = LocalDate.parse(scanner.nextLine());

        System.out.print("Inserire la via: ");
        String via = scanner.nextLine();

        System.out.print("Inserire il civico: ");
        int civico = Integer.parseInt(scanner.nextLine());

        System.out.print("Inserire il CAP: ");
        String cap = scanner.nextLine();

        System.out.print("Inserire la città: ");
        String citta = scanner.nextLine();

        System.out.print("Inserire la provincia: ");
        String provincia = scanner.nextLine();

        String inserimento = "INSERT INTO Utente (NomeUtente, Email, Nome, Cognome, DataDiNascita, Via, Civico, CAP, Citta, Provincia) VALUES ("
                + "'" + nomeUtente + "', "
                + "'" + email + "', "
                + "'" + nome + "', "
                + "'" + cognome + "', "
                + "'" + dataDiNascita + "', "
                + "'" + via + "', "
                + civico + ", "
                + "'" + cap + "', "
                + "'" + citta + "', "
                + "'" + provincia + "')";

        try {
            statement = connection.createStatement();
            statement.execute(inserimento);
            System.out.println("Inserimento effettuato correttamente\n");
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            try {
                if (statement != null)
                    statement.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private static void modifica(){
        System.out.println("\n----Modifica tabella Utente----\n");

        System.out.print("Inserire il nome utente del record da modificare: ");
        String nomeUtente = scanner.nextLine();

        System.out.print("Inserire la nuova email: ");
        String email = scanner.nextLine();

        System.out.print("Inserire il nuovo nome: ");
        String nome = scanner.nextLine();

        System.out.print("Inserire il nuovo cognome: ");
        String cognome = scanner.nextLine();

        System.out.print("Inserire la nuova data di nascita (AAAA-MM-GG): ");
        LocalDate dataDiNascita = LocalDate.parse(scanner.nextLine());

        System.out.print("Inserire la nuova via: ");
        String via = scanner.nextLine();

        System.out.print("Inserire il nuovo civico: ");
        int civico = Integer.parseInt(scanner.nextLine());

        System.out.print("Inserire il nuovo CAP: ");
        String cap = scanner.nextLine();

        System.out.print("Inserire la nuova città: ");
        String citta = scanner.nextLine();

        System.out.print("Inserire la nuova provincia: ");
        String provincia = scanner.nextLine();

        String modifica = "UPDATE Utente SET " +
                "Email = '" + email + "', " +
                "Nome = '" + nome + "', " +
                "Cognome = '" + cognome + "', " +
                "DataDiNascita = '" + dataDiNascita + "', " +
                "Via = '" + via + "', " +
                "Civico = " + civico + ", " +
                "CAP = '" + cap + "', " +
                "Citta = '" + citta + "', " +
                "Provincia = '" + provincia + "' " +
                "WHERE NomeUtente = '" + nomeUtente + "'";

        try {
            statement = connection.createStatement();
            int righeModificate = statement.executeUpdate(modifica);
            if (righeModificate == 0) {
                System.out.println("\nNessun record trovato con nome utente: " + nomeUtente + "\n");
            } else {
                System.out.println("\nModifica effettuata correttamente\n");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            try {
                if (statement != null)
                    statement.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private static void cancellazione(){
        System.out.println("\n----Cancellazione di un utente----\n");

        System.out.print("Inserire il nome utente da cancellare: ");
        String nomeUtente = scanner.nextLine();

        String cancellazione = "DELETE FROM Utente WHERE NomeUtente = '" + nomeUtente + "'";

        try {
            statement = connection.createStatement();
            statement.execute(cancellazione);
            System.out.println("Cancellazione effettuata correttamente\n");
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            try {
                if (statement != null)
                    statement.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private static void query(){
        System.out.println("\n----Esecuzione della query----\n");
        String query = "SELECT * FROM Utente";

        try{
            statement = connection.createStatement();
            ResultSet rs = statement.executeQuery(query);
            while(rs.next()){
                System.out.println("Nome Utente = " + rs.getString(1) +
                        ", Email = " + rs.getString(2) +
                        ", Nome = " + rs.getString(3) +
                        ", Cognome = " + rs.getString(4) +
                        ", Data di nascita = " + rs.getString(5) +
                        ", Via = " + rs.getString(6) +
                        ", Civico = " + rs.getString(7) +
                        ", CAP = " + rs.getString(8) +
                        ", Città = " + rs.getString(9) +
                        ", Provincia = " + rs.getString(10));
            }
            rs.close();
            statement.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            try {
                if(statement != null)
                    statement.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}