package modelo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import modelo.Grupo;
import modelo.jdbc.ConnectionFactory;

public class GrupoDAO {
	// apenas para consulta/histórico
	public void inserirUtilizandoStatement(Grupo grupo) {
		// insert v1
		
		// obtendo conexão
		Connection conexao = ConnectionFactory.getConnection();
		
		// definindo SQL
		String sql = "INSERT INTO grupo("
									+ "codigo, "
									+ "nome, "
									+ "descricao) "
								+ "VALUES("
									+ grupo.getCodigo() + ", '"
									+ grupo.getNome() + "', '"
									+ grupo.getDescricao() + "')";
		
		try {
			// criando Statement
			Statement stmt = conexao.createStatement();
			
			// executando operação
			stmt.execute(sql);
			
			// fechando Statement
			stmt.close();
			
			// fechando conexão
			conexao.close();
			
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void inserir(Grupo grupo) {
		// insert v2
		
		// obtendo conexão
		Connection conexao = ConnectionFactory.getConnection();
		
		// defindo SQL
		String sql = "INSERT INTO grupo("
									+ "codigo, "
									+ "nome, "
									+ "descricao) "
								+ "VALUES(?, ?, ?)";
		
		try {
			// criando PreparedStatement
			PreparedStatement pstmt = conexao.prepareStatement(sql);
			
			// configurando parâmetros
			pstmt.setInt(1, grupo.getCodigo());
			pstmt.setString(2, grupo.getNome());
			pstmt.setString(3, grupo.getDescricao());
			
			// executando operação
			pstmt.execute();
			
			// fechando PreparedStatement
			pstmt.close();
			
			// fechando conexão
			conexao.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void alterar(Grupo grupo) {
		// update
		
		// obtendo conexão
		Connection conexao = ConnectionFactory.getConnection();
		
		// definindo SQL
		String sql = "UPDATE grupo SET "
									+ "nome = ?, "
									+ "descricao = ? "
								+ "WHERE "
									+ "codigo = ?";
		
		try {
			// criando PreparedStatement
			PreparedStatement pstmt = conexao.prepareStatement(sql);
			
			// configurando parâmetros
			pstmt.setString(1, grupo.getNome());
			pstmt.setString(2, grupo.getDescricao());
			pstmt.setInt(3, grupo.getCodigo());
			
			// executando operação
			pstmt.execute();
			
			// fechando PreparedStatement
			pstmt.close();
			
			// fechando conexão
			conexao.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void excluir(int codigo) {
		// delete
		
		// obtendo conexão
		Connection conexao = ConnectionFactory.getConnection();
		
		// definindo SQL
		String sql = "DELETE FROM grupo WHERE codigo = ?";
		
		try {
			// criando PreparedStatement
			PreparedStatement pstmt = conexao.prepareStatement(sql);
			
			// configurando parâmetros
			pstmt.setInt(1, codigo);
			
			// executando operação
			pstmt.execute();
			
			// fechando PreparedStatement
			pstmt.close();
			
			// fechando conexão
			conexao.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
	public Grupo pesquisarPorCodigo(int codigo) {
		// select com retorno (máximo) único
		
		// criando objeto para retorno
		Grupo grupo = null;
		
		// obtendo conexão
		Connection conexao = ConnectionFactory.getConnection();
		
		// definindo SQL
		String sql = "SELECT "
							+ "codigo, "
							+ "nome, "
							+ "descricao "
						+ "FROM "
							+ "grupo "
						+ "WHERE "
							+ "codigo = ?";
		
		try {
			// criando PreparedStatement
			PreparedStatement pstmt = conexao.prepareStatement(sql);
			
			// configurando parâmetros
			pstmt.setInt(1, codigo);
			
			// executando operação e armazenando retorno
			ResultSet rs = pstmt.executeQuery();
			
			// tratando retorno
			while(rs.next()) {
				grupo = new Grupo();
				// pode-se recuperar a coluna pelo nome ou indice
				grupo.setCodigo(rs.getInt("codigo"));
				grupo.setNome(rs.getString(2));
				grupo.setDescricao(rs.getString(3));
			}
			
			// fechando PreparedStatement
			pstmt.close();
			
			// fechando conexão
			conexao.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
		
		// retornando resultado
		return grupo;
	}
	
	public ArrayList<Grupo> pesquisarTodos() {
		// select com retorno (máximo) múltiplo

		// criando objeto para retorno
		ArrayList<Grupo> grupos = new ArrayList<Grupo>();
		
		// obtendo conexão
		Connection conexao = ConnectionFactory.getConnection();
		
		// definindo SQL
		String sql = "SELECT "
							+ "codigo, "
							+ "nome, "
							+ "descricao "
						+ "FROM "
							+ "grupo";
		
		try {
			// criando PreparedStatement
			PreparedStatement pstmt = conexao.prepareStatement(sql);
			
			// configurando parâmetros
			// não há parâmetros neste caso
			
			// executando operação e armazenando retorno
			ResultSet rs = pstmt.executeQuery();
			
			// tratando retorno
			while(rs.next()) {
				Grupo grupo = new Grupo();
				// pode-se recuperar a coluna pelo nome ou indice
				grupo.setCodigo(rs.getInt("codigo"));
				grupo.setNome(rs.getString(2));
				grupo.setDescricao(rs.getString(3));
				
				grupos.add(grupo);
			}
			
			// fechando PreparedStatement
			pstmt.close();
			
			// fechando conexão
			conexao.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}

		// retornando resultado
		return grupos;
	}
}
