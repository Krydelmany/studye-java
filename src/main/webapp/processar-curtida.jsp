<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modelo.Curtida" %>
<%@ page import="modelo.dao.CurtidaDAO" %>

<%
// Verificar autenticação
Boolean usuarioAutenticado = (Boolean) session.getAttribute("usuarioAutenticado");
if (usuarioAutenticado == null || !usuarioAutenticado) {
    response.sendRedirect("login.jsp?erro=acesso_negado");
    return;
}

request.setCharacterEncoding("UTF-8");

String acao = request.getParameter("acao");
String idPostagemStr = request.getParameter("id_postagem");
Integer idUsuario = (Integer) session.getAttribute("idUsuario");

try {
    if (idPostagemStr == null || idPostagemStr.trim().isEmpty()) {
        response.sendRedirect("feed.jsp?erro=dados_invalidos");
        return;
    }
    
    if (acao == null || acao.trim().isEmpty()) {
        response.sendRedirect("feed.jsp?erro=acao_invalida");
        return;
    }
    
    int idPostagem = Integer.parseInt(idPostagemStr);
    CurtidaDAO curtidaDAO = new CurtidaDAO();
    
    if ("curtir".equals(acao)) {
        // Verificar se já curtiu
        if (!curtidaDAO.usuarioJaCurtiu(idPostagem, idUsuario)) {
            Curtida curtida = new Curtida(idPostagem, idUsuario);
            curtidaDAO.curtir(curtida);
        }
    } 
    else if ("descurtir".equals(acao)) {
        curtidaDAO.descurtir(idPostagem, idUsuario);
    }
    
    // Redirecionar de volta para o feed
    response.sendRedirect("feed.jsp");
    
} catch (NumberFormatException e) {
    response.sendRedirect("feed.jsp?erro=dados_invalidos");
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("feed.jsp?erro=falha_curtida");
}
%>
