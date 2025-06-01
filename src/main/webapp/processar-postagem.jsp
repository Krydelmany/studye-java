<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modelo.Postagem" %>
<%@ page import="modelo.dao.PostagemDAO" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.stream.Collectors" %>

<% 
// Verificar se o usuário está autenticado
Boolean usuarioAutenticado = (Boolean) session.getAttribute("usuarioAutenticado");
if (usuarioAutenticado == null || !usuarioAutenticado) {
    response.sendRedirect("feed.jsp?erro=acesso_negado");
    return;
}

// Configurando a codificação
request.setCharacterEncoding("UTF-8");

// Obter a ação a ser realizada
String acao = request.getParameter("acao");

try {
    PostagemDAO postagemDAO = new PostagemDAO();
    
    // Criar nova postagem
    if ("criar".equals(acao)) {
        String titulo = request.getParameter("titulo");
        String conteudo = request.getParameter("conteudo");
        String tagsInput = request.getParameter("tags");
        
        // Processar tags
        List<String> tags = new ArrayList<>();
        if (tagsInput != null && !tagsInput.trim().isEmpty()) {
            tags = Arrays.stream(tagsInput.split(","))
                        .map(String::trim)
                        .filter(tag -> !tag.isEmpty())
                        .collect(Collectors.toList());
        }
        
        // Obter ID do usuário da sessão
        Integer idUsuario = (Integer) session.getAttribute("idUsuario");
        
        // Criar e salvar nova postagem
        Postagem novaPostagem = new Postagem();
        novaPostagem.setTitulo(titulo);
        novaPostagem.setConteudo(conteudo);
        novaPostagem.setIdUsuario(idUsuario);
        novaPostagem.setTags(tags);
        
        postagemDAO.inserir(novaPostagem);
        
        response.sendRedirect("feed.jsp?sucesso=postagem_criada");
        return;
    }
    
    // Editar postagem existente
    else if ("editar".equals(acao)) {
        int id = Integer.parseInt(request.getParameter("id"));
        String titulo = request.getParameter("titulo");
        String conteudo = request.getParameter("conteudo");
        String tagsInput = request.getParameter("tags");
        
        // Buscar a postagem existente
        Postagem postagem = postagemDAO.buscarPorId(id);
        
        if (postagem == null) {
            response.sendRedirect("feed.jsp?erro=postagem_nao_encontrada");
            return;
        }
        
        // Verificar se o usuário é o autor da postagem
        Integer idUsuarioLogado = (Integer) session.getAttribute("idUsuario");
        if (!postagem.getIdUsuario().equals(idUsuarioLogado)) {
            response.sendRedirect("feed.jsp?erro=acesso_negado");
            return;
        }
        
        // Processar tags
        List<String> tags = new ArrayList<>();
        if (tagsInput != null && !tagsInput.trim().isEmpty()) {
            tags = Arrays.stream(tagsInput.split(","))
                        .map(String::trim)
                        .filter(tag -> !tag.isEmpty())
                        .collect(Collectors.toList());
        }
        
        // Atualizar postagem
        postagem.setTitulo(titulo);
        postagem.setConteudo(conteudo);
        postagem.setTags(tags);
        
        postagemDAO.atualizar(postagem);
        
        response.sendRedirect("feed.jsp?sucesso=postagem_editada");
        return;
    }
    
    // Excluir postagem
    else if ("excluir".equals(acao)) {
        int id = Integer.parseInt(request.getParameter("id"));
        
        // Buscar a postagem existente
        Postagem postagem = postagemDAO.buscarPorId(id);
        
        if (postagem == null) {
            response.sendRedirect("feed.jsp?erro=postagem_nao_encontrada");
            return;
        }
        
        // Verificar se o usuário é o autor da postagem
        Integer idUsuarioLogado = (Integer) session.getAttribute("idUsuario");
        if (!postagem.getIdUsuario().equals(idUsuarioLogado)) {
            response.sendRedirect("feed.jsp?erro=acesso_negado");
            return;
        }
        
        // Excluir postagem
        postagemDAO.excluir(id);
        
        response.sendRedirect("feed.jsp?sucesso=postagem_excluida");
        return;
    }
    
    // Ação desconhecida
    else {
        response.sendRedirect("feed.jsp?erro=acao_invalida");
        return;
    }
    
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("feed.jsp?erro=falha_postagem");
}
%>
