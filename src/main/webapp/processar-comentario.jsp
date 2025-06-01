<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modelo.Comentario" %>
<%@ page import="modelo.dao.ComentarioDAO" %>

<%
// Verificar autenticação
Boolean usuarioAutenticado = (Boolean) session.getAttribute("usuarioAutenticado");
if (usuarioAutenticado == null || !usuarioAutenticado) {
    response.sendRedirect("login.jsp?erro=acesso_negado");
    return;
}

request.setCharacterEncoding("UTF-8");

String acao = request.getParameter("acao");
Integer idUsuario = (Integer) session.getAttribute("idUsuario");

try {
    ComentarioDAO comentarioDAO = new ComentarioDAO();
    
    if ("criar".equals(acao)) {
        String conteudo = request.getParameter("conteudo");
        String idPostagemStr = request.getParameter("id_postagem");
        
        if (conteudo != null && !conteudo.trim().isEmpty() && idPostagemStr != null) {
            int idPostagem = Integer.parseInt(idPostagemStr);
            
            Comentario comentario = new Comentario();
            comentario.setIdPostagem(idPostagem);
            comentario.setIdUsuario(idUsuario);
            comentario.setConteudo(conteudo.trim());
            
            comentarioDAO.inserir(comentario);
            response.sendRedirect("feed.jsp?sucesso=comentario_criado");
        } else {
            response.sendRedirect("feed.jsp?erro=dados_invalidos");
        }
    } 
    else if ("excluir".equals(acao)) {
        String idComentarioStr = request.getParameter("id_comentario");
        
        if (idComentarioStr != null) {
            int idComentario = Integer.parseInt(idComentarioStr);
            comentarioDAO.excluir(idComentario);
            response.sendRedirect("feed.jsp?sucesso=comentario_excluido");
        } else {
            response.sendRedirect("feed.jsp?erro=comentario_nao_encontrado");
        }
    }
    else {
        response.sendRedirect("feed.jsp?erro=acao_invalida");
    }
    
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("feed.jsp?erro=falha_comentario");
}
%>
