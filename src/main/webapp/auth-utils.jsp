<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.dao.UsuarioDAO" %>
<%@ page import="java.sql.*" %>
<%@ page import="modelo.jdbc.ConnectionFactory" %>

<%!
// Implementação alternativa dos métodos diretamente no JSP
public Usuario autenticarUsuario(String username, String senha) {
    String sql = "SELECT * FROM usuario WHERE username = ? AND senha = ?";
    
    try (Connection conn = ConnectionFactory.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        
        pstmt.setString(1, username);
        pstmt.setString(2, senha);
        
        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setUsername(rs.getString("username"));
                usuario.setNome(rs.getString("nome"));
                usuario.setEmail(rs.getString("email"));
                usuario.setSenha(rs.getString("senha"));
                usuario.setDataCriacao(rs.getTimestamp("data_criacao").toLocalDateTime());

                Timestamp dataAtualizacao = rs.getTimestamp("data_atualizacao");
                if (dataAtualizacao != null) {
                    usuario.setDataAtualizacao(dataAtualizacao.toLocalDateTime());
                }
                usuario.setBio(rs.getString("bio"));
                return usuario;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}

public boolean usernameExisteCheck(String username) {
    String sql = "SELECT COUNT(*) FROM usuario WHERE username = ?";
    
    try (Connection conn = ConnectionFactory.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        
        pstmt.setString(1, username);
        
        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

public boolean emailExisteCheck(String email) {
    String sql = "SELECT COUNT(*) FROM usuario WHERE email = ?";
    
    try (Connection conn = ConnectionFactory.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        
        pstmt.setString(1, email);
        
        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
%>
