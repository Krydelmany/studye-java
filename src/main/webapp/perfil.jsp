<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="modelo.Postagem" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.dao.PostagemDAO" %>
<%@ page import="modelo.dao.UsuarioDAO" %>

<%
// Verificar se o usuário está autenticado
Boolean usuarioAutenticado = (Boolean) session.getAttribute("usuarioAutenticado");
if (usuarioAutenticado == null || !usuarioAutenticado) {
    response.sendRedirect("login.jsp?erro=acesso_negado");
    return;
}

// Obter dados do usuário da sessão
Integer idUsuarioLogado = (Integer) session.getAttribute("idUsuario");
String nomeUsuario = (String) session.getAttribute("nomeUsuario");

// Buscar dados completos do usuário
UsuarioDAO usuarioDAO = new UsuarioDAO();
Usuario usuario = usuarioDAO.buscarPorId(idUsuarioLogado);

if (usuario == null) {
    response.sendRedirect("login.jsp?erro=usuario_nao_encontrado");
    return;
}
%>

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
    <title>Studye - Meu Perfil</title>
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
        
        /* Profile container - match feed width */
        .profile-container {
            max-width: 680px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }
        
        /* Profile header card */
        .profile-header-card {
            background: rgba(26, 27, 38, 0.95);
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: 20px;
            padding: 2.5rem 2rem;
            margin-bottom: 2rem;
            box-shadow: 
                0 20px 60px rgba(0, 0, 0, 0.3),
                0 0 0 1px rgba(99, 102, 241, 0.1);
            backdrop-filter: blur(20px);
            transition: all 0.3s ease;
        }
        
        .profile-header {
            display: block;
            position: relative;
            margin-bottom: 0px;
        }
        
        .profile-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            font-size: 2rem;
            box-shadow: 0 10px 30px rgba(99, 102, 241, 0.3);
            position: absolute;
            top: 0;
            right: 0;
        }
        
        .profile-info {
            padding-right: 100px;
        }
        
        .profile-info h1 {
            color: #ffffff;
            font-weight: 700;
            font-size: 2.2rem;
            margin-bottom: 0.5rem;
            line-height: 1.2;
        }
        
        .profile-username {
            color: #8b5cf6;
            font-weight: 600;
            font-size: 1.2rem;
            margin-bottom: 1.5rem;
        }
        
        .profile-bio {
            color: rgba(255, 255, 255, 0.8);
            font-size: 1.1rem;
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }
        
        .profile-stats {
            display: flex;
            gap: 2rem;
            margin-bottom: 1.5rem;
        }
        
        .stat-item {
            text-align: left;
        }
        
        .stat-number {
            color: #8b5cf6;
            font-weight: 700;
            font-size: 1.8rem;
            display: block;
        }
        
        .stat-label {
            color: rgba(255, 255, 255, 0.7);
            font-size: 0.9rem;
            font-weight: 500;
        }
        
        .stat-item.member-since {
            margin-left: auto;
        }
        
        .stat-item.member-since .stat-number {
            font-size: 1rem;
            font-weight: 600;
        }
        
        .stat-item.member-since .stat-label {
            font-size: 0.8rem;
        }
        
        .profile-actions {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }
        
        /* Edit profile form */
        .edit-profile-card {
            background: rgba(26, 27, 38, 0.95);
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 
                0 20px 60px rgba(0, 0, 0, 0.3),
                0 0 0 1px rgba(99, 102, 241, 0.1);
            backdrop-filter: blur(20px);
            display: none;
        }
        
        /* Modal styles */
        .modal {
            backdrop-filter: blur(10px);
        }
        
        .modal-dialog {
            display: flex;
            align-items: center;
            min-height: calc(100vh - 1rem);
            margin: 0.5rem auto;
        }
        
        .modal-content {
            background: rgba(26, 27, 38, 0.95);
            border: 1px solid rgba(99, 102, 241, 0.15);
            border-radius: 20px;
            box-shadow: 
                0 20px 60px rgba(0, 0, 0, 0.4),
                0 0 0 1px rgba(99, 102, 241, 0.1);
            backdrop-filter: blur(20px);
            width: 100%;
        }
        
        .modal-header {
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            padding: 1.5rem 2rem;
        }
        
        .modal-title {
            color: #ffffff;
            font-weight: 700;
            font-size: 1.3rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .modal-body {
            padding: 2rem;
        }
        
        .modal-footer {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding: 1.5rem 2rem;
        }
        
        .btn-close {
            background: none;
            border: none;
            color: rgba(255, 255, 255, 0.7);
            font-size: 1.5rem;
            padding: 0.5rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        
        .btn-close:hover {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.1);
            transform: scale(1.1);
        }
        
        .btn-close:focus {
            box-shadow: none;
        }
        
        /* Posts section */
        .posts-section h2 {
            color: #ffffff;
            font-weight: 700;
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        /* Post cards - consistent with feed */
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
        
        .btn-outline {
            background: transparent;
            border: 2px solid rgba(139, 92, 246, 0.3);
            border-radius: 12px;
            color: #8b5cf6;
            font-weight: 600;
            padding: 0.8rem 1.5rem;
            transition: all 0.3s ease;
            font-size: 1rem;
        }
        
        .btn-outline:hover {
            background: rgba(139, 92, 246, 0.1);
            border-color: #8b5cf6;
            color: #a78bfa;
            transform: translateY(-1px);
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
        
        .btn-create-first {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border: none;
            border-radius: 12px;
            color: #ffffff;
            font-weight: 600;
            padding: 0.8rem 2rem;
            transition: all 0.3s ease;
            font-size: 1rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
        }
        
        .btn-create-first:hover {
            background: linear-gradient(135deg, #5b5fd8, #7c3aed);
            color: #ffffff;
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
        }
        
        .btn-create-first:active {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.3);
        }
        
        .btn-icon {
            font-size: 0.85rem !important;
            transition: all 0.3s ease;
            line-height: 1;
            display: inline-block;
            vertical-align: middle;
            color: #ffffff !important;
        }
        
        /* Override empty state icon size specifically for button icons */
        .btn-create-first .btn-icon {
            font-size: 0.85rem !important;
            margin-bottom: 0;
            margin-top: 1px;
            color: #ffffff !important;
        }
        
        /* Responsive design */
        @media (max-width: 768px) {
            .profile-container {
                padding: 1rem 0.5rem;
            }
            
            .profile-header-card,
            .edit-profile-card,
            .post-card,
            .empty-state {
                border-radius: 15px;
                margin-left: 0.5rem;
                margin-right: 0.5rem;
            }
            
            .profile-header {
                display: block;
                position: relative;
            }
            
            .profile-avatar {
                position: static;
                width: 80px;
                height: 80px;
                font-size: 2rem;
                margin: 0 auto 1.5rem;
            }
            
            .profile-info {
                padding-right: 0;
                text-align: center;
            }
            
            .profile-info h1 {
                font-size: 1.8rem;
            }
            
            .profile-stats {
                justify-content: center;
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }
            
            .stat-item.member-since {
                margin-left: 0;
            }
            
            .profile-actions {
                justify-content: center;
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
            
            .profile-header-card,
            .edit-profile-card {
                padding: 1.5rem;
            }
            
            .empty-state {
                padding: 3rem 1.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
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
                        <a class="nav-link" href="feed.jsp">
                            <i class="bi bi-house-fill me-1"></i>Feed
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="perfil.jsp">
                            <i class="bi bi-person-fill me-1"></i>Perfil
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="logout.jsp">
                            <i class="bi bi-box-arrow-right me-1"></i>Sair
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container-fluid" style="margin-top: 80px;">
        <!-- Alert Messages -->
        <%
        String erro = request.getParameter("erro");
        String sucesso = request.getParameter("sucesso");
        
        if (erro != null) {
            if (erro.equals("perfil_nao_atualizado")) {
                out.println("<div class='profile-container'><div class='alert alert-danger'><i class='bi bi-exclamation-triangle me-2'></i>Não foi possível atualizar o perfil. Tente novamente.</div></div>");
            }
        }
        
        if (sucesso != null) {
            if (sucesso.equals("perfil_atualizado")) {
                out.println("<div class='profile-container'><div class='alert alert-success'><i class='bi bi-check-circle me-2'></i>Perfil atualizado com sucesso!</div></div>");
            }
        }
        %>
        
        <div class="profile-container">
            <!-- Profile Header -->
            <div class="profile-header-card">
                <div class="profile-header">
                    <div class="profile-avatar">
                        <%=usuario.getNome().substring(0, 1).toUpperCase()%>
                    </div>
                    <div class="profile-info">
                        <h1><%=escapeHtml(usuario.getNome())%></h1>
                        <div class="profile-username">@<%=escapeHtml(usuario.getUsername())%></div>
                        <div class="profile-bio">
                            <%
                            String bio = usuario.getBio();
                            if (bio == null || bio.trim().isEmpty()) {
                                out.println("Ainda não há informações sobre este usuário. Complete seu perfil!");
                            } else {
                                out.println(escapeHtml(bio));
                            }
                            %>
                        </div>
                        <div class="profile-stats">
                            <%
                            // Contar postagens do usuário
                            PostagemDAO postagemDAO = new PostagemDAO();
                            List<Postagem> postagensUsuario = postagemDAO.buscarPorUsuario(idUsuarioLogado);
                            int totalPostagens = postagensUsuario.size();
                            
                            // Calcular data de membro
                            DateTimeFormatter memberFormatter = DateTimeFormatter.ofPattern("MMM yyyy");
                            String membroDesde = usuario.getDataCriacao().format(memberFormatter);
                            %>
                            <div class="stat-item">
                                <span class="stat-number"><%=totalPostagens%></span>
                                <span class="stat-label">Postagens</span>
                            </div>
                            <div class="stat-item member-since">
                                <span class="stat-number"><%=membroDesde%></span>
                                <span class="stat-label">Membro desde</span>
                            </div>
                        </div>
                        <div class="profile-actions">
                            <button class="btn btn-outline" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                <i class="bi bi-pencil me-1"></i>Editar Perfil
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Edit Profile Modal -->
            <div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editProfileModalLabel">
                                <i class="bi bi-person-gear me-2"></i>Editar Perfil
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                <i class="bi bi-x"></i>
                            </button>
                        </div>
                        <div class="modal-body">
                            <form action="processar-perfil.jsp" method="POST" id="editProfileForm">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="nome" class="form-label">Nome Completo</label>
                                        <input type="text" class="form-control" id="nome" name="nome" value="<%=escapeHtml(usuario.getNome())%>" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="email" class="form-label">E-mail</label>
                                        <input type="email" class="form-control" id="email" name="email" value="<%=escapeHtml(usuario.getEmail())%>" required>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="bio" class="form-label">Biografia</label>
                                    <textarea class="form-control" id="bio" name="bio" rows="4" placeholder="Conte um pouco sobre você, seus interesses acadêmicos e objetivos..."><%=(usuario.getBio() != null) ? escapeHtml(usuario.getBio()) : ""%></textarea>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="bi bi-x me-1"></i>Cancelar
                            </button>
                            <button type="submit" form="editProfileForm" class="btn btn-primary">
                                <i class="bi bi-check me-1"></i>Salvar Alterações
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- User Posts Section -->
            <div class="posts-section">
                <h2>
                    <i class="bi bi-journal-text me-2"></i>Minhas Postagens
                </h2>
                
                <%
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                
                if (postagensUsuario.isEmpty()) {
                %>
                    <div class="empty-state">
                        <i class="bi bi-journal-plus"></i>
                        <h5>Você ainda não criou nenhuma postagem</h5>
                        <p>Compartilhe seu conhecimento criando sua primeira postagem!<br>
                        Conecte-se com outros estudantes e ajude a construir uma comunidade de aprendizado.</p>
                        <a href="feed.jsp" class="btn-create-first">
                            <i class="bi bi-plus-circle btn-icon"></i>
                            <span class="btn-text">Crie seu primeiro post</span>
                        </a>
                    </div>
                <%
                } else {
                    for (Postagem postagem : postagensUsuario) {
                        String tituloEscapado = escapeHtml(postagem.getTitulo());
                        String conteudoEscapado = escapeHtml(postagem.getConteudo());
                        String nomeAutorEscapado = escapeHtml(usuario.getNome());
                        String inicialAutor = usuario.getNome().substring(0, 1).toUpperCase();
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
                                <div class="edit-actions">
                                    <button class="edit-btn" onclick="window.location.href='feed.jsp?edit=<%=postagem.getIdPostagem()%>'">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button class="edit-btn delete" onclick="if(confirm('Excluir esta postagem?')) window.location.href='processar-postagem.jsp?acao=excluir&id=<%=postagem.getIdPostagem()%>'">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
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
                                <button class="action-btn">
                                    <i class="bi bi-heart"></i><span>Curtir</span>
                                </button>
                                <button class="action-btn">
                                    <i class="bi bi-chat"></i><span>Comentar</span>
                                </button>
                                <button class="action-btn">
                                    <i class="bi bi-share"></i><span>Compartilhar</span>
                                </button>
                            </div>
                        </div>
                    </div>
                <%
                    }
                }
                %>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
    <script>
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
