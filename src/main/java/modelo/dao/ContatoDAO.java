package modelo.dao;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import modelo.Contato;
import modelo.Grupo;
import modelo.jdbc.ConnectionFactory;

public class ContatoDAO {
	public void inserir(Contato contato) {
		Connection conexao = ConnectionFactory.getConnection();
		
		String sql = "INSERT INTO contato("
										+ "codigo, "
										+ "nome, "
										+ "telefone, "
										+ "grupo_codigo) "
									+ "VALUES(?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conexao.prepareStatement(sql);
			
			pstmt.setInt(1, contato.getCodigo());
			pstmt.setString(2, contato.getNome());
			pstmt.setString(3, contato.getTelefone());
			pstmt.setInt(4, contato.getGrupo().getCodigo());
			
			pstmt.execute();
			
			pstmt.close();
			
			conexao.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void alterar(Contato contato) {
		Connection conexao = ConnectionFactory.getConnection();
		
		String sql = "UPDATE contato SET "
										+ "nome = ?, "
										+ "telefone = ?, "
										+ "grupo_codigo = ? "
									+ "WHERE "
										+ "codigo = ?";
		
		try {
			PreparedStatement pstmt = conexao.prepareStatement(sql);
			
			pstmt.setString(1, contato.getNome());
			pstmt.setString(2, contato.getTelefone());
			pstmt.setInt(3, contato.getGrupo().getCodigo());
			pstmt.setInt(4, contato.getCodigo());
			
			pstmt.execute();
			
			pstmt.close();
			
			conexao.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void excluir(int codigo) {
		Connection conexao = ConnectionFactory.getConnection();
		
		String sql = "DELETE FROM contato WHERE codigo = ?";
		
		try {
			PreparedStatement pstmt = conexao.prepareStatement(sql);
			
			pstmt.setInt(1, codigo);
			
			pstmt.close();
			
			conexao.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
	public Contato pesquisarPorCodigo(int codigo) {
		Contato contato = null;
		
		Connection conexao = ConnectionFactory.getConnection();
		
		String sql = "SELECT "
							+ "codigo, "
							+ "nome, "
							+ "telefone, "
							+ "grupo_codigo "
						+ "FROM "
							+ "contato "
						+ "WHERE "
							+ "codigo = ?";
		
		try {
			PreparedStatement pstmt = conexao.prepareStatement(sql);
			
			pstmt.setInt(1, codigo);
			
			ResultSet rs = pstmt.executeQuery();
			
			while(rs.next()) {
				contato = new Contato();
				contato.setCodigo(rs.getInt("codigo"));
				contato.setNome(rs.getString(2));
				contato.setTelefone(rs.getString(3));
				Grupo grupo = new GrupoDAO().pesquisarPorCodigo(rs.getInt(4));
				contato.setGrupo(grupo);
			}
			
			rs.close();
			
			pstmt.close();
			
			conexao.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
		
		return contato;
	}
	
	public ArrayList<Contato> pesquisarTodos() {
		ArrayList<Contato> contatos = new ArrayList<Contato>();
		
		Connection conexao = ConnectionFactory.getConnection();
		
		String sql = "SELECT "
							+ "codigo, "
							+ "nome, "
							+ "telefone, "
							+ "grupo_codigo "
						+ "FROM "
							+ "contato";
		
		//System.out.println("SQL = " + sql);
		
		try {
			PreparedStatement pstmt = conexao.prepareStatement(sql);
			
			ResultSet rs = pstmt.executeQuery();
			
			//System.out.println("RS = " + rs);
			
			while(rs.next()) {
				//System.out.println("Test!");
				
				Contato contato = new Contato();
				contato.setCodigo(rs.getInt("codigo"));
				contato.setNome(rs.getString(2));
				contato.setTelefone(rs.getString(3));
				Grupo grupo = new GrupoDAO().pesquisarPorCodigo(rs.getInt(4));
				contato.setGrupo(grupo);
			
				//System.out.println("Iaaaaa!");
				
				contatos.add(contato);
			}
			
			rs.close();
			
			pstmt.close();
			
			conexao.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
		
		return contatos;
	}
}
