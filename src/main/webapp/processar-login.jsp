<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.dao.UsuarioDAO" %>
<%@ page import="java.sql.*" %>
<%@ page import="modelo.jdbc.ConnectionFactory" %>

<%!
// Implementação do método de autenticação diretamente nesta página
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
%>

<% 
// Configurando a codificação
request.setCharacterEncoding("UTF-8");

// Obter parâmetros do formulário
String username = request.getParameter("username");
String senha = request.getParameter("senha");
String lembrar = request.getParameter("lembrar");

// Validar usuário através da implementação alternativa
try {
    Usuario usuario = autenticarUsuario(username, senha);
    
    if (usuario != null) {
        // Criar sessão para o usuário
        session.setAttribute("usuario", usuario);
        session.setAttribute("usuarioAutenticado", true);
        session.setAttribute("idUsuario", usuario.getIdUsuario());
        session.setAttribute("nomeUsuario", usuario.getNome());
        
        // Se a opção "Lembrar de mim" estiver marcada
        if (lembrar != null && lembrar.equals("on")) {
            // Tempo máximo da sessão (em segundos) - 30 dias
            session.setMaxInactiveInterval(30 * 24 * 60 * 60);
        } else {
            // Tempo padrão da sessão (em segundos) - 30 minutos
            session.setMaxInactiveInterval(30 * 60);
        }
        
        // Redirecionar para a página inicial após login
        response.sendRedirect("postagens.jsp");
    } else {
        // Usuário ou senha inválidos
        response.sendRedirect("login.jsp?erro=credenciais_invalidas");
    }
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("login.jsp?erro=conexao_bd");
}
%>
