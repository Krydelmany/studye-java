<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.dao.UsuarioDAO" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.sql.*" %>
<%@ page import="modelo.jdbc.ConnectionFactory" %>

<%!
// Implementação dos métodos de verificação diretamente nesta página
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

<% 
// Configurando a codificação
request.setCharacterEncoding("UTF-8");

// Obter parâmetros do formulário
String username = request.getParameter("username");
String email = request.getParameter("email");
String senha = request.getParameter("senha");
String confirmarSenha = request.getParameter("confirmarSenha");

// Validação básica
if (!senha.equals(confirmarSenha)) {
    response.sendRedirect("cadastro.jsp?erro=senhas_diferentes");
    return;
}

try {
    UsuarioDAO usuarioDAO = new UsuarioDAO();
    
    // Verificar se usuário já existe usando a implementação alternativa
    if (usernameExisteCheck(username)) {
        response.sendRedirect("cadastro.jsp?erro=usuario_existente");
        return;
    }
    
    // Verificar se email já existe usando a implementação alternativa
    if (emailExisteCheck(email)) {
        response.sendRedirect("cadastro.jsp?erro=email_existente");
        return;
    }
    
    // Criar objeto de usuário
    Usuario usuario = new Usuario();
    usuario.setUsername(username);
    usuario.setNome(username); // Usando o username como nome por padrão
    usuario.setEmail(email);
    usuario.setSenha(senha);
    usuario.setBio(""); // Bio vazia por padrão
    usuario.setDataCriacao(LocalDateTime.now()); // Data atual
    
    // Salvar usuário no banco de dados
    usuarioDAO.inserir(usuario);
    
    // Redirecionar para página de login com mensagem de sucesso
    response.sendRedirect("login.jsp?sucesso=cadastro_completo");
} catch (Exception e) {
    // Registrar erro e redirecionar
    e.printStackTrace();
    response.sendRedirect("cadastro.jsp?erro=conexao_bd");
}
%>
