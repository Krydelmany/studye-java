<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.dao.UsuarioDAO" %>

<% 
// Verificar se o usuário está autenticado
Boolean usuarioAutenticado = (Boolean) session.getAttribute("usuarioAutenticado");
if (usuarioAutenticado == null || !usuarioAutenticado) {
    response.sendRedirect("login.jsp?erro=acesso_negado");
    return;
}

// Configurando a codificação
request.setCharacterEncoding("UTF-8");

// Obter parâmetros do formulário
String nome = request.getParameter("nome");
String email = request.getParameter("email");
String bio = request.getParameter("bio");

// Obter ID do usuário da sessão
Integer idUsuario = (Integer) session.getAttribute("idUsuario");

try {
    UsuarioDAO usuarioDAO = new UsuarioDAO();
    
    // Buscar o usuário atual
    Usuario usuario = usuarioDAO.buscarPorId(idUsuario);
    
    if (usuario == null) {
        response.sendRedirect("perfil.jsp?erro=usuario_nao_encontrado");
        return;
    }
    
    // Atualizar os dados do usuário
    usuario.setNome(nome);
    usuario.setEmail(email);
    usuario.setBio(bio);
    
    // Salvar no banco de dados
    usuarioDAO.atualizar(usuario);
    
    // Atualizar a sessão com o novo nome
    session.setAttribute("nomeUsuario", nome);
    
    // Redirecionar para o perfil com mensagem de sucesso
    response.sendRedirect("perfil.jsp?sucesso=perfil_atualizado");
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("perfil.jsp?erro=perfil_nao_atualizado");
}
%>
