<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// Verifica se o usuário está autenticado
Boolean autenticado = (Boolean) session.getAttribute("usuarioAutenticado");
if (autenticado == null || !autenticado) {
    // Redireciona para a página de login se não estiver autenticado
    response.sendRedirect("login.jsp?erro=acesso_negado");
    return;
}
%>
