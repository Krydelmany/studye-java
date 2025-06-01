<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="modelo.Postagem" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.Comentario" %>
<%@ page import="modelo.dao.PostagemDAO" %>
<%@ page import="modelo.dao.UsuarioDAO" %>

<%!
    // Method to escape HTML characters to prevent XSS
    public String escapeHtml(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Studye - Feed de Postagens</title>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        @import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&display=swap');
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            background: linear-gradient(135deg, #0f0f23 0%, #1e1e2e 50%, #2d1b69 100%);
            color: #ffffff;
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            position: relative;
        }
        
        /* Modern Navbar */
        .navbar {
            background: rgba(26, 27, 38, 0.95) !important;
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(99, 102, 241, 0.1);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            padding: 0.8rem 0;
            transition: all 0.3s ease;
        }
        
        .navbar-brand {
            display: flex;
            align-items: center;
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
            font-size: 1.8rem;
            letter-spacing: -0.02em;
            transition: all 0.3s ease;
            text-decoration: none !important;
        }
        
        .navbar-brand .logo-text {
            color: #ffffff;
            margin-right: 0.1rem;
        }
        
        .navbar-brand .logo-e {
            color: #8b5cf6;
            transform: rotate(-8deg);
            display: inline-block;
            transition: all 0.3s ease;
        }
        
        .navbar-brand .logo-dot {
            color: #ffffff;
            margin-left: 0.05rem;
        }
        
        .navbar-brand:hover {
            transform: translateY(-2px);
        }
        
        .navbar-brand:hover .logo-e {
            color: #a78bfa;
            transform: rotate(-15deg) scale(1.1);
        }
        
        .nav-link {
            color: rgba(255, 255, 255, 0.8) !important;
            font-weight: 500;
            font-size: 0.95rem;
            padding: 0.5rem 1rem !important;
            border-radius: 8px;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .nav-link:hover,
        .nav-link.active {
            color: #ffffff !important;
            background: rgba(139, 92, 246, 0.15);
            transform: translateY(-1px);
        }
        
        /* Feed container - centralized */
        .feed-container {
            max-width: 680px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }
        
        /* Post creation card */
        .create-post-card {
            background: rgba(26, 27, 38, 0.95);
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 
                0 20px 60px rgba(0, 0, 0, 0.3),
                0 0 0 1px rgba(99, 102, 241, 0.1);
            backdrop-filter: blur(20px);
            transition: all 0.3s ease;
        }
        
        .create-post-card:hover {
            border-color: rgba(99, 102, 241, 0.25);
            box-shadow: 
                0 25px 80px rgba(0, 0, 0, 0.4),
                0 0 0 1px rgba(99, 102, 241, 0.2),
                0 0 40px rgba(99, 102, 241, 0.1);
        }
        
        .create-post-header {
            display: flex;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        
        .user-avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            margin-right: 1rem;
            font-size: 1.1rem;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
        }
        
        .create-post-input {
            background: rgba(255, 255, 255, 0.08);
            border: 2px solid rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            color: #ffffff;
            padding: 1rem 1.5rem;
            width: 100%;
            resize: none;
            transition: all 0.3s ease;
            font-family: 'Inter', sans-serif;
            font-size: 1rem;
        }
        
        .create-post-input:focus {
            background: rgba(255, 255, 255, 0.12);
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
            outline: none;
        }
        
        .create-post-input::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }
        
        .login-prompt-card {
            background: rgba(26, 27, 38, 0.95);
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: 20px;
            padding: 3rem 2rem;
            margin-bottom: 2rem;
            text-align: center;
            box-shadow: 
                0 20px 60px rgba(0, 0, 0, 0.3),
                0 0 0 1px rgba(99, 102, 241, 0.1);
            backdrop-filter: blur(20px);
        }
        
        .login-prompt-card h5 {
            color: #ffffff;
            font-weight: 700;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }
        
        .login-prompt-card p {
            color: rgba(255, 255, 255, 0.8);
            font-size: 1.1rem;
            margin-bottom: 2rem;
        }
        
        /* Post cards */
        .post-card {
            background: rgba(26, 27, 38, 0.95);
            border: 1px solid rgba(99, 102, 241, 0.1);
            border-radius: 20px;
            margin-bottom: 2rem;
            overflow: hidden;
            transition: all 0.3s ease;
            backdrop-filter: blur(20px);
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }
        
        .post-card:hover {
            border-color: rgba(99, 102, 241, 0.2);
            transform: translateY(-4px);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }
        
        .post-header {
            padding: 1.5rem 2rem 1rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }
        
        .post-author {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .author-info {
            display: flex;
            align-items: center;
        }
        
        .author-name {
            color: #ffffff;
            font-weight: 600;
            font-size: 1rem;
            margin-bottom: 0.3rem;
        }
        
        .post-date {
            color: rgba(255, 255, 255, 0.6);
            font-size: 0.9rem;
            font-weight: 500;
        }
        
        .edit-actions {
            display: flex;
            gap: 0.8rem;
        }
        
        .edit-btn {
            background: none;
            border: none;
            color: rgba(255, 255, 255, 0.6);
            padding: 0.6rem;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
            font-size: 1rem;
        }
        
        .edit-btn:hover {
            color: #6366f1;
            background: rgba(99, 102, 241, 0.15);
        }
        
        .edit-btn.delete:hover {
            color: #ef4444;
            background: rgba(239, 68, 68, 0.15);
        }
        
        .post-title {
            color: #ffffff;
            font-weight: 700;
            font-size: 1.3rem;
            margin: 1rem 0 0.8rem;
            line-height: 1.4;
        }
        
        .post-content {
            padding: 0 2rem 1.5rem;
        }
        
        .post-text {
            color: rgba(255, 255, 255, 0.9);
            line-height: 1.7;
            font-size: 1rem;
            white-space: pre-line;
            margin-bottom: 1.5rem;
        }
        
        .post-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 0.8rem;
            margin-bottom: 1.5rem;
        }
        
        .post-tag {
            background: rgba(139, 92, 246, 0.2);
            color: #c4b5fd;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-size: 0.85rem;
            font-weight: 600;
            border: 1px solid rgba(139, 92, 246, 0.3);
            transition: all 0.3s ease;
        }
        
        .post-tag:hover {
            background: rgba(139, 92, 246, 0.3);
            color: #ddd6fe;
        }
        
        .post-actions {
            padding: 1rem 2rem 1.5rem;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .action-buttons {
            display: flex;
            gap: 1.5rem;
        }
        
        .action-btn {
            background: none;
            border: none;
            color: rgba(255, 255, 255, 0.7);
            font-size: 1rem;
            cursor: pointer;
            padding: 0.6rem 1rem;
            border-radius: 10px;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 500;
        }
        
        .action-btn:hover {
            color: #8b5cf6;
            background: rgba(139, 92, 246, 0.15);
            transform: translateY(-1px);
        }
        
        .action-btn.comment-btn:hover {
            color: #3b82f6;
            background: rgba(59, 130, 246, 0.15);
        }
        
        .comments-section {
            padding: 1.5rem 2rem;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            background: rgba(0, 0, 0, 0.1);
            display: none;
        }
        
        .comments-header h6 {
            color: #ffffff;
            font-weight: 600;
            margin-bottom: 1rem;
        }
        
        .comment-form {
            margin-bottom: 1.5rem;
        }
        
        .comment-form .form-control {
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            color: #ffffff;
            padding: 0.75rem 1rem;
        }
        
        .comment-form .form-control:focus {
            background: rgba(255, 255, 255, 0.12);
            border-color: #6366f1;
            box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.2);
            color: #ffffff;
        }
        
        .btn-comment {
            background: #6366f1;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }
        
        .btn-comment:hover {
            background: #5b5fd8;
            color: white;
        }
        
        .user-avatar-small {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 0.8rem;
            flex-shrink: 0;
        }
        
        .comment-item {
            display: flex;
            flex-direction: column;
            margin-bottom: 1rem;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 12px;
        }
        
        .comment-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 0.5rem;
        }
        
        .comment-info {
            flex: 1;
        }
        
        .comment-author {
            color: #ffffff;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .comment-date {
            color: rgba(255, 255, 255, 0.6);
            font-size: 0.8rem;
        }
        
        .comment-delete {
            background: none;
            border: none;
            color: rgba(255, 255, 255, 0.5);
            padding: 0.25rem;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .comment-delete:hover {
            color: #ef4444;
            background: rgba(239, 68, 68, 0.1);
        }
        
        .comment-content {
            color: rgba(255, 255, 255, 0.9);
            line-height: 1.5;
            padding-left: 2.5rem;
        }
        
        .comment-input {
            flex: 1;
        }
        
        /* Form styles */
        .form-control {
            background: rgba(255, 255, 255, 0.08);
            border: 2px solid rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            color: #ffffff;
            padding: 1rem 1.5rem;
            transition: all 0.3s ease;
            font-size: 1rem;
        }
        
        .form-control:focus {
            background: rgba(255, 255, 255, 0.12);
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
            outline: none;
            color: #ffffff;
        }
        
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }
        
        .form-label {
            color: #ffffff;
            font-weight: 600;
            margin-bottom: 0.8rem;
            font-size: 1rem;
        }
        
        /* Button styles */
        .btn-primary {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border: none;
            border-radius: 12px;
            color: #ffffff;
            font-weight: 600;
            padding: 0.8rem 2rem;
            transition: all 0.3s ease;
            font-size: 1rem;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(99, 102, 241, 0.4);
        }
        
        .btn-secondary {
            background: rgba(255, 255, 255, 0.1);
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            color: #ffffff;
            font-weight: 600;
            padding: 0.8rem 2rem;
            transition: all 0.3s ease;
            font-size: 1rem;
        }
        
        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.15);
            color: #ffffff;
            border-color: rgba(255, 255, 255, 0.3);
        }
        
        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: rgba(255, 255, 255, 0.6);
            background: rgba(26, 27, 38, 0.95);
            border: 1px solid rgba(99, 102, 241, 0.1);
            border-radius: 20px;
            backdrop-filter: blur(20px);
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1.5rem;
            color: rgba(139, 92, 246, 0.4);
        }
        
        .empty-state h5 {
            color: #ffffff;
            font-size: 1.5rem;
            margin-bottom: 1rem;
            font-weight: 700;
        }
        
        .empty-state p {
            font-size: 1.1rem;
            margin-bottom: 2rem;
            color: rgba(255, 255, 255, 0.7);
            line-height: 1.6;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .feed-container {
                padding: 1rem 0.5rem;
            }
            
            .create-post-card,
            .post-card,
            .login-prompt-card {
                border-radius: 15px;
                margin-left: 0.5rem;
                margin-right: 0.5rem;
            }
            
            .navbar-brand {
                font-size: 1.5rem;
            }
            
            .post-header,
            .post-content,
            .post-actions {
                padding-left: 1.5rem;
                padding-right: 1.5rem;
            }
            
            .create-post-card {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top">
        <div class="container">
            <a class="navbar-brand" href="feed.jsp">
                <span class="logo-text">Study</span><span class="logo-e">e</span><span class="logo-dot">.</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="feed.jsp">
                            <i class="bi bi-house-fill me-1"></i>Feed
                        </a>
                    </li>
                    <% 
                    // Verificar se o usuário está logado
                    Boolean usuarioAutenticado = (Boolean) session.getAttribute("usuarioAutenticado");
                    String nomeUsuario = null;
                    Integer idUsuarioLogado = null;
                    
                    if (usuarioAutenticado != null && usuarioAutenticado) {
                        nomeUsuario = (String) session.getAttribute("nomeUsuario");
                        idUsuarioLogado = (Integer) session.getAttribute("idUsuario");
                    %>
                        <li class="nav-item">
                            <a class="nav-link" href="perfil.jsp">
                                <i class="bi bi-person-fill me-1"></i>Perfil
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="logout.jsp">
                                <i class="bi bi-box-arrow-right me-1"></i>Sair
                            </a>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a class="nav-link" href="login.jsp">
                                <i class="bi bi-box-arrow-in-right me-1"></i>Login
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="cadastro.jsp">
                                <i class="bi bi-person-plus-fill me-1"></i>Cadastro
                            </a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container-fluid" style="margin-top: 80px;">
        <%
        // Verificar mensagens de erro ou sucesso
        String erro = request.getParameter("erro");
        String sucesso = request.getParameter("sucesso");
        
        if (erro != null) {
            if (erro.equals("acesso_negado")) {
                out.println("<div class='feed-container'><div class='alert alert-danger'><i class='bi bi-exclamation-triangle me-2'></i>Você precisa estar logado para realizar esta ação.</div></div>");
            } else if (erro.equals("falha_postagem")) {
                out.println("<div class='feed-container'><div class='alert alert-danger'><i class='bi bi-exclamation-triangle me-2'></i>Não foi possível salvar a postagem. Tente novamente.</div></div>");
            }
        }
        
        if (sucesso != null) {
            if (sucesso.equals("postagem_criada")) {
                out.println("<div class='feed-container'><div class='alert alert-success'><i class='bi bi-check-circle me-2'></i>Postagem criada com sucesso!</div></div>");
            } else if (sucesso.equals("postagem_editada")) {
                out.println("<div class='feed-container'><div class='alert alert-success'><i class='bi bi-check-circle me-2'></i>Postagem atualizada com sucesso!</div></div>");
            } else if (sucesso.equals("postagem_excluida")) {
                out.println("<div class='feed-container'><div class='alert alert-success'><i class='bi bi-check-circle me-2'></i>Postagem excluída com sucesso!</div></div>");
            }
        }
        
        // Verificar se estamos editando uma postagem
        String editId = request.getParameter("edit");
        Postagem postagemParaEditar = null;
        
        if (editId != null && !editId.isEmpty()) {
            try {
                int idPostagem = Integer.parseInt(editId);
                PostagemDAO postagemDAO = new PostagemDAO();
                postagemParaEditar = postagemDAO.buscarPorId(idPostagem);
                
                if (postagemParaEditar != null && usuarioAutenticado != null && usuarioAutenticado) {
                    if (!postagemParaEditar.getIdUsuario().equals(idUsuarioLogado)) {
                        postagemParaEditar = null;
                    }
                }
            } catch (NumberFormatException e) {
                // ID inválido, ignorar
            }
        }
        %>
        
        <!-- Centralized Feed -->
        <div class="feed-container">
            <!-- Create Post Card or Login Prompt -->
            <% if (usuarioAutenticado != null && usuarioAutenticado) { %>
                <div class="create-post-card">
                    <% if (postagemParaEditar != null) { %>
                        <h5 class="form-label"><i class="bi bi-pencil me-2"></i>Editar Postagem</h5>
                        <form action="processar-postagem.jsp" method="POST">
                            <input type="hidden" name="acao" value="editar">
                            <input type="hidden" name="id" value="<%=postagemParaEditar.getIdPostagem()%>">
                            <div class="mb-3">
                                <label for="titulo" class="form-label">Título</label>
                                <input type="text" class="form-control" id="titulo" name="titulo" value="<%=escapeHtml(postagemParaEditar.getTitulo())%>" required>
                            </div>
                            <div class="mb-3">
                                <label for="conteudo" class="form-label">Conteúdo</label>
                                <textarea class="form-control" id="conteudo" name="conteudo" rows="4" required><%=escapeHtml(postagemParaEditar.getConteudo())%></textarea>
                            </div>
                            <div class="mb-3">
                                <label for="tags" class="form-label">Tags</label>
                                <input type="text" class="form-control" id="tags" name="tags" value="<%=(postagemParaEditar.getTags() != null) ? String.join(", ", postagemParaEditar.getTags()) : ""%>" placeholder="javascript, programação, dicas">
                            </div>
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check me-1"></i>Atualizar
                                </button>
                                <a href="feed.jsp" class="btn btn-secondary">
                                    <i class="bi bi-x me-1"></i>Cancelar
                                </a>
                            </div>
                        </form>
                    <% } else { %>
                        <div class="create-post-header">
                            <div class="user-avatar">
                                <%=((String) session.getAttribute("nomeUsuario")).substring(0, 1).toUpperCase()%>
                            </div>
                            <h6 class="form-label mb-0">Compartilhe seu conhecimento/dúvida!</h6>
                        </div>
                        <form action="processar-postagem.jsp" method="POST">
                            <input type="hidden" name="acao" value="criar">
                            <div class="mb-3">
                                <input type="text" class="form-control" name="titulo" placeholder="Título da sua postagem..." required>
                            </div>
                            <div class="mb-3">
                                <textarea class="create-post-input" name="conteudo" rows="3" placeholder="O que você quer compartilhar hoje?" required></textarea>
                            </div>
                            <div class="mb-3">
                                <input type="text" class="form-control" name="tags" placeholder="Tags: javascript, programação, dicas...">
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-send me-1"></i>Publicar
                            </button>
                        </form>
                    <% } %>
                </div>
            <% } else { %>
                <div class="login-prompt-card">
                    <h5>🚀 Junte-se ao Studye</h5>
                    <p>Compartilhe conhecimento e aprenda com a comunidade</p>
                    <div class="d-flex gap-3 justify-content-center">
                        <a href="login.jsp" class="btn btn-primary">
                            <i class="bi bi-box-arrow-in-right me-1"></i>Entrar
                        </a>
                        <a href="cadastro.jsp" class="btn btn-secondary">
                            <i class="bi bi-person-plus-fill me-1"></i>Criar conta
                        </a>
                    </div>
                </div>
            <% } %>
            
            <!-- Posts -->
            <%
            PostagemDAO postagemDAO = new PostagemDAO();
            List<Postagem> postagens = postagemDAO.buscarTodas();
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            
            if (postagens.isEmpty()) {
            %>
                <div class="empty-state">
                    <i class="bi bi-chat-square-text"></i>
                    <h5>Nenhuma postagem ainda</h5>
                    <p>Seja o primeiro a compartilhar conhecimento!</p>
                </div>
            <%
            } else {
                for (Postagem postagem : postagens) {
                    Usuario autor = usuarioDAO.buscarPorId(postagem.getIdUsuario());
                    String nomeAutor = (autor != null) ? autor.getNome() : "Usuário";
                    
                    String tituloEscapado = escapeHtml(postagem.getTitulo());
                    String conteudoEscapado = escapeHtml(postagem.getConteudo());
                    String nomeAutorEscapado = escapeHtml(nomeAutor);
                    String inicialAutor = nomeAutor.substring(0, 1).toUpperCase();
                    
                    // Buscar comentários da postagem
                    List<Comentario> comentarios = postagemDAO.buscarComentariosPorPostagem(postagem.getIdPostagem());
                    int totalComentarios = comentarios.size();
            %>
                    <div class="post-card">
                        <div class="post-header">
                            <div class="post-author">
                                <div class="author-info">
                                    <div class="user-avatar"><%=inicialAutor%></div>
                                    <div>
                                        <div class="author-name"><%=nomeAutorEscapado%></div>
                                        <div class="post-date"><%=postagem.getDataCriacao().format(formatter)%></div>
                                    </div>
                                </div>
                                <% if (usuarioAutenticado != null && usuarioAutenticado && postagem.getIdUsuario().equals(idUsuarioLogado)) { %>
                                    <div class="edit-actions">
                                        <button class="edit-btn" onclick="window.location.href='feed.jsp?edit=<%=postagem.getIdPostagem()%>'">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button class="edit-btn delete" onclick="if(confirm('Excluir esta postagem?')) window.location.href='processar-postagem.jsp?acao=excluir&id=<%=postagem.getIdPostagem()%>'">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                <% } %>
                            </div>
                            <h6 class="post-title"><%=tituloEscapado%></h6>
                        </div>
                        
                        <div class="post-content">
                            <div class="post-text"><%=conteudoEscapado%></div>
                            
                            <% if (postagem.getTags() != null && !postagem.getTags().isEmpty()) { %>
                                <div class="post-tags">
                                    <% for (String tag : postagem.getTags()) { %>
                                        <span class="post-tag">#<%=escapeHtml(tag)%></span>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                        
                        <div class="post-actions">
                            <div class="action-buttons">
                                <button class="action-btn comment-btn" onclick="toggleComments(<%=postagem.getIdPostagem()%>)">
                                    <i class="bi bi-chat"></i>
                                    <span><%=totalComentarios%></span>
                                </button>
                                <button class="action-btn">
                                    <i class="bi bi-share"></i><span>Compartilhar</span>
                                </button>
                            </div>
                        </div>
                        
                        <!-- Seção de Comentários -->
                        <% if (usuarioAutenticado != null && usuarioAutenticado) { %>
                            <div class="comments-section" id="comments-<%=postagem.getIdPostagem()%>">
                                <div class="comments-header">
                                    <h6>Comentários (<%=totalComentarios%>)</h6>
                                </div>
                                
                                <!-- Form para novo comentário -->
                                <div class="comment-form">
                                    <form action="processar-comentario.jsp" method="POST" class="d-flex gap-2">
                                        <input type="hidden" name="acao" value="criar">
                                        <input type="hidden" name="id_postagem" value="<%=postagem.getIdPostagem()%>">
                                        <div class="user-avatar-small"><%=nomeUsuario.substring(0, 1).toUpperCase()%></div>
                                        <input type="text" class="form-control comment-input" name="conteudo" 
                                               placeholder="Escreva um comentário..." required>
                                        <button type="submit" class="btn btn-comment">
                                            <i class="bi bi-send"></i>
                                        </button>
                                    </form>
                                </div>
                                
                                <!-- Lista de comentários -->
                                <div class="comments-list">
                                    <% for (Comentario comentario : comentarios) { %>
                                        <div class="comment-item">
                                            <div class="comment-header">
                                                <div class="user-avatar-small"><%=comentario.getNomeUsuario().substring(0, 1).toUpperCase()%></div>
                                                <div class="comment-info">
                                                    <div class="comment-author"><%=escapeHtml(comentario.getNomeUsuario())%></div>
                                                    <div class="comment-date"><%=comentario.getDataCriacao().format(formatter)%></div>
                                                </div>
                                                <% if (comentario.getIdUsuario().equals(idUsuarioLogado)) { %>
                                                    <button class="comment-delete" 
                                                            onclick="if(confirm('Excluir comentário?')) window.location.href='processar-comentario.jsp?acao=excluir&id_comentario=<%=comentario.getIdComentario()%>&id_postagem=<%=postagem.getIdPostagem()%>'">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                <% } %>
                                            </div>
                                            <div class="comment-content"><%=escapeHtml(comentario.getConteudo())%></div>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        <% } %>
                    </div>
            <%
                }
            }
            %>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleComments(idPostagem) {
            const commentsSection = document.getElementById('comments-' + idPostagem);
            if (commentsSection.style.display === 'none' || commentsSection.style.display === '') {
                commentsSection.style.display = 'block';
            } else {
                commentsSection.style.display = 'none';
            }
        }
        
        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.transition = 'opacity 0.5s ease';
                    alert.style.opacity = '0';
                    setTimeout(() => {
                        alert.remove();
                    }, 500);
                }, 5000);
            });
        });
    </script>
</body>
</html>
