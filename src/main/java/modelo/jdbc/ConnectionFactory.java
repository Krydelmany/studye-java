package modelo.jdbc;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Enumeration;

public class ConnectionFactory {
	public static Connection getConnection() {
		String stringJDBC = "jdbc:postgresql://localhost:5432/studye?currentSchema=public";
		String usuario = "regulatorio";
		String senha = "regulatorio";
		
		Connection conexao = null;
		
		try {
			// Verificar se o driver está disponível
			try {
				Class.forName("org.postgresql.Driver");
				System.out.println("Driver PostgreSQL encontrado com sucesso!");
			} catch (ClassNotFoundException e) {
				System.err.println("ERRO: Driver PostgreSQL não encontrado.");
				System.err.println("Por favor, adicione o arquivo postgresql-42.x.x.jar à pasta WEB-INF/lib");
				e.printStackTrace();
				return null;
			}
			
			// Conectar ao banco de dados
			conexao = DriverManager.getConnection(
									stringJDBC,
									usuario,
									senha);
			System.out.println("Conexão com PostgreSQL estabelecida com sucesso!");
		} catch(Exception e) {
			System.err.println("ERRO ao conectar com o banco de dados: " + e.getMessage());
			e.printStackTrace();
		}
		
		return conexao;
	}
}
