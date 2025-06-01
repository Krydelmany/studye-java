<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Studye - Login</title>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-SgOJa3DmI69IUzQ2PVdRZhwQ+dy64/BUtbMJw1MZ8t5HZApcHrRKUc4W0kG879m7" crossorigin="anonymous">
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
            overflow-x: hidden;
            position: relative;
        }
        
        /* Welcome overlay for smooth background transition */
        .welcome-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #0f1f0f 0%, #1a2e1a 20%, #1e3e1e 40%, #1b5f32 70%, #2d3b2d 100%);
            opacity: 0;
            z-index: -2;
            transition: opacity 3s ease-in-out;
        }
        
        .welcome-overlay.active {
            opacity: 0.6;
        }

        /* Animated background particles */
        .bg-animation {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            overflow: hidden;
        }
        
        .particle {
            position: absolute;
            width: 4px;
            height: 4px;
            background: linear-gradient(45deg, #6366f1, #a855f7);
            border-radius: 50%;
            animation: float 15s infinite linear;
        }
        
        @keyframes float {
            0% {
                transform: translateY(100vh) rotate(0deg);
                opacity: 0;
            }
            10% {
                opacity: 1;
            }
            90% {
                opacity: 1;
            }
            100% {
                transform: translateY(-100vh) rotate(360deg);
                opacity: 0;
            }
        }
        
        /* Navbar improvements */
        .navbar { 
            background: rgba(26, 27, 38, 0.95) !important; 
            backdrop-filter: blur(20px);
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
        }
        
        .navbar-brand { 
            color: #6366f1 !important; 
            font-weight: 700; 
            font-size: 1.5rem;
            text-shadow: 0 0 20px rgba(99, 102, 241, 0.5);
            transition: all 0.3s ease;
        }
        
        .navbar-brand:hover {
            transform: scale(1.05);
            text-shadow: 0 0 30px rgba(99, 102, 241, 0.8);
        }
        
        .nav-link { 
            color: #ffffff !important; 
            font-weight: 500;
            position: relative;
            transition: all 0.3s ease;
        }
        
        .nav-link::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 50%;
            width: 0;
            height: 2px;
            background: linear-gradient(90deg, #6366f1, #a855f7);
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }
        
        .nav-link:hover::after,
        .nav-link.active::after {
            width: 100%;
        }
        
        .nav-link:hover, 
        .nav-link:focus,
        .nav-link.active { 
            color: #6366f1 !important; 
            transform: translateY(-2px);
        }

        /* Custom logo styles */
        .custom-logo {
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            animation: fadeIn 1s ease-out 0.1s both;
            cursor: pointer;
            user-select: none;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
        }
        
        .custom-logo .logo {
            font-size: 2.5rem;
            font-weight: 600;
            letter-spacing: -0.02em;
            display: flex;
            align-items: baseline;
            font-family: 'Montserrat', sans-serif;
            transition: all 0.3s cubic-bezier(0.23, 1, 0.32, 1);
        }
        
        .custom-logo .logo-text {
            color: #ffffff;
            font-weight: 600;
            animation: slideInFade 0.9s cubic-bezier(0.23, 1, 0.32, 1) 0.1s backwards;
            transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
        }
        
        .custom-logo .logo-e {
            color: #8b5cf6;
            position: relative;
            font-weight: 700;
            transform: rotate(-8deg);
            transform-origin: center;
            animation: rotateFloat 1.2s cubic-bezier(0.23, 1, 0.32, 1) 0.4s backwards;
            transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
        }
        
        .custom-logo .logo-dot {
            color: #ffffff;
            margin-left: 0.02em;
            animation: popIn 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.55) 0.8s backwards;
            transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
        }
        
        /* Hover effects */
        .custom-logo:hover .logo-text {
            transform: translateX(-3px) translateY(-1px);
            color: #f8fafc;
            text-shadow: 0 2px 8px rgba(255, 255, 255, 0.1);
        }
        
        .custom-logo:hover .logo-e {
            transform: rotate(-20deg) scale(1.15) translateY(-3px);
            color: #a78bfa;
            text-shadow: 
                0 0 20px rgba(139, 92, 246, 0.6),
                0 0 40px rgba(139, 92, 246, 0.3),
                0 0 60px rgba(139, 92, 246, 0.1);
            filter: drop-shadow(0 4px 8px rgba(139, 92, 246, 0.3));
        }
        
        .custom-logo:hover .logo-dot {
            transform: scale(1.3) translateY(-2px);
            color: #8b5cf6;
            text-shadow: 
                0 0 15px rgba(139, 92, 246, 0.8),
                0 0 25px rgba(139, 92, 246, 0.4);
            animation: pulse-glow 1.5s ease-in-out infinite;
        }
        
        @keyframes pulse-glow {
            0%, 100% {
                text-shadow: 
                    0 0 15px rgba(139, 92, 246, 0.8),
                    0 0 25px rgba(139, 92, 246, 0.4);
            }
            50% {
                text-shadow: 
                    0 0 20px rgba(139, 92, 246, 1),
                    0 0 35px rgba(139, 92, 246, 0.6),
                    0 0 50px rgba(139, 92, 246, 0.2);
            }
        }

        /* Separador decorativo */
        .login-separator {
            width: 40px;
            height: 1px;
            background: rgba(99, 102, 241, 0.3);
            margin: 1.2rem auto;
            animation: fadeIn 1s ease-out 0.2s both;
        }
        
        @keyframes slideInFade {
            0% {
                opacity: 0;
                transform: translateX(-20px);
                filter: blur(2px);
            }
            100% {
                opacity: 1;
                transform: translateX(0);
                filter: blur(0);
            }
        }
        
        @keyframes rotateFloat {
            0% {
                opacity: 0;
                transform: rotate(25deg) translateY(-10px) scale(0.9);
                filter: blur(1px);
            }
            60% {
                transform: rotate(-12deg) translateY(2px) scale(1.02);
            }
            100% {
                opacity: 1;
                transform: rotate(-8deg) translateY(0) scale(1);
                filter: blur(0);
            }
        }
        
        @keyframes popIn {
            0% {
                opacity: 0;
                transform: scale(0) rotate(180deg);
            }
            70% {
                transform: scale(1.15) rotate(-10deg);
            }
            100% {
                opacity: 1;
                transform: scale(1) rotate(0deg);
            }
        }
        
        /* Login card improvements */
        .login-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 2rem 1rem;
        }
        
        .login-card {
            background: rgba(26, 27, 38, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 3rem 2.5rem;
            width: 100%;
            max-width: 450px;
            box-shadow: 
                0 20px 60px rgba(0, 0, 0, 0.5),
                0 0 0 1px rgba(99, 102, 241, 0.1),
                inset 0 1px 0 rgba(255, 255, 255, 0.1);
            animation: slideUp 0.8s ease-out;
            position: relative;
            overflow: hidden;
        }
        
        .login-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(99, 102,241, 0.1), transparent);
            animation: shimmer 3s infinite;
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes shimmer {
            0% { left: -100%; }
            100% { left: 100%; }
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 2.5rem;
            position: relative;
        }
        
        .login-title {
            font-size: 1.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, #ffffff, #a5b4fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
            animation: fadeIn 1s ease-out 0.3s both;
            transition: all 0.5s ease;
            min-height: 2.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-title.welcome-mode {
            background: linear-gradient(135deg, #10b981, #34d399, #6ee7b7);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            transform: scale(1.05);
            text-shadow: 0 0 30px rgba(16, 185, 129, 0.3);
        }
        
        .login-subtitle {
            color: rgba(255, 255, 255, 0.7);
            font-weight: 400;
            animation: fadeIn 1s ease-out 0.5s both;
            transition: all 0.8s cubic-bezier(0.4, 0.0, 0.2, 1);
            min-height: 2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            line-height: 1.4;
        }
        
        .login-subtitle.welcome-mode {
            color: rgba(110, 231, 183, 0.9);
            transform: translateY(-3px);
        }
        
        /* Smooth welcome glow animation */
        @keyframes welcomeGlow {
            0% {
                box-shadow: 
                    0 20px 60px rgba(0, 0, 0, 0.5),
                    0 0 0 1px rgba(99, 102, 241, 0.1),
                    inset 0 1px 0 rgba(255, 255, 255, 0.1);
            }
            50% {
                box-shadow: 
                    0 25px 80px rgba(0, 0, 0, 0.6),
                    0 0 0 1px rgba(16, 185, 129, 0.4),
                    inset 0 1px 0 rgba(255, 255, 255, 0.1),
                    0 0 60px rgba(16, 185, 129, 0.3),
                    0 0 120px rgba(52, 211, 153, 0.15);
            }
            100% {
                box-shadow: 
                    0 20px 60px rgba(0, 0, 0, 0.5),
                    0 0 0 1px rgba(16, 185, 129, 0.2),
                    inset 0 1px 0 rgba(255, 255, 255, 0.1),
                    0 0 40px rgba(16, 185, 129, 0.2),
                    0 0 80px rgba(52, 211, 153, 0.1);
            }
        }
        
        @keyframes welcomeScale {
            0% { transform: scale(1); }
            30% { transform: scale(1.03); }
            70% { transform: scale(1.01); }
            100% { transform: scale(1); }
        }
        
        .login-card.welcome-mode {
            animation: welcomeGlow 3s ease-in-out, welcomeScale 3s ease-in-out;
            transition: all 1s cubic-bezier(0.4, 0.0, 0.2, 1);
        }
        
        /* Smooth background gradient animation */
        body {
            transition: all 0.5s ease-in-out;
        }
        
        /* Welcome state styles */
        .login-title.welcome-success {
            background: linear-gradient(135deg, #34d399, #6ee7b7, #a7f3d0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            animation: welcomePulse 2s ease-in-out infinite alternate;
            transition: all 1s ease-in-out;
        }
        
        .login-subtitle.welcome-success {
            color: rgba(167, 243, 208, 0.9);
            text-shadow: none;
            transition: all 1s ease-in-out;
        }
        
        .login-card.welcome-success {
            box-shadow: 
                0 20px 60px rgba(0, 0, 0, 0.5),
                0 0 0 1px rgba(16, 185, 129, 0.3),
                inset 0 1px 0 rgba(255, 255, 255, 0.1),
                0 0 40px rgba(16, 185, 129, 0.2);
            transition: all 2s ease-in-out;
        }
        
        /* Fade out animation for ending */
        .login-title.fade-out {
            opacity: 0;
            transform: translateY(-20px);
            animation: none;
            transition: all 1s ease-in-out;
        }
        
        .login-subtitle.fade-out {
            opacity: 0;
            transform: translateY(-20px);
            animation: none;
            transition: all 1s ease-in-out;
        }
        
        /* Fixed height for title and subtitle to prevent size changes */
        .login-title {
            min-height: 2.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-subtitle {
            min-height: 2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            line-height: 1.4;
        }
        
        @keyframes welcomePulse {
            0% { transform: scale(1); }
            100% { transform: scale(1.02); }
        }

        /* Form stability during transition */
        .login-form {
            opacity: 1;
            transition: opacity 0.3s ease-in-out;
        }
        
        .login-form.fading {
            opacity: 0.7;
        }

        /* Form improvements */
        .form-group {
            position: relative;
            margin-bottom: 1.5rem;
            animation: fadeIn 1s ease-out both;
        }
        
        .form-group:nth-child(1) { animation-delay: 0.7s; }
        .form-group:nth-child(2) { animation-delay: 0.9s; }
        .form-group:nth-child(3) { animation-delay: 1.1s; }
        
        .form-control {
            background: rgba(255, 255, 255, 0.05);
            border: 2px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            color: #f1f5f9;
            font-size: 1rem;
            padding: 1rem 1rem 1rem 3rem;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .form-control:focus {
            background: rgba(255, 255, 255, 0.1);
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
            outline: none;
            color: #ffffff;
        }
        
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.5);
            transition: all 0.3s ease;
        }
        
        .form-control:focus::placeholder {
            color: rgba(255, 255, 255, 0.3);
        }
        
        .input-icon {
            position: absolute;
            top: 50%;
            left: 1rem;
            transform: translateY(-50%);
            color: rgba(255, 255, 255, 0.5);
            z-index: 1;
            transition: all 0.3s ease;
        }
        
        .form-control:focus + .input-icon {
            color: #6366f1;
        }
        
        .form-check {
            margin: 1.5rem 0;
            animation: fadeIn 1s ease-out 1.3s both;
        }
        
        .form-check-input {
            background-color: rgba(255, 255, 255, 0.1);
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 6px;
            transition: all 0.3s ease;
        }
        
        .form-check-input:checked {
            background-color: #6366f1;
            border-color: #6366f1;
            box-shadow: 0 0 10px rgba(99, 102, 241, 0.5);
        }
        
        .form-check-label {
            color: rgba(255, 255, 255, 0.8);
            font-weight: 500;
            cursor: pointer;
        }
        
        /* Button improvements */
        .btn-login {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border: none;
            border-radius: 12px;
            color: #ffffff;
            font-weight: 600;
            font-size: 1rem;
            padding: 1rem 2rem;
            width: 100%;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            animation: fadeIn 1s ease-out 1.5s both;
        }
        
        .btn-login::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: all 0.5s ease;
        }
        
        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(99, 102, 241, 0.4);
        }
        
        .btn-login:hover::before {
            left: 100%;
        }
        
        .btn-login:active {
            transform: translateY(-1px);
        }
        
        /* Alert improvements */
        .alert {
            border: none;
            border-radius: 12px;
            font-weight: 500;
            animation: slideDown 0.5s ease-out;
            position: relative;
            overflow: hidden;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .alert-danger {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.2), rgba(239, 68, 68, 0.1));
            color: #fca5a5;
            border-left: 4px solid #ef4444;
        }
        
        .alert-success {
            background: linear-gradient(135deg, rgba(34, 197, 94, 0.2), rgba(34, 197, 94, 0.1));
            color: #86efac;
            border-left: 4px solid #22c55e;
        }
        
        /* Footer link */
        .footer-link {
            text-align: center;
            margin-top: 2rem;
            animation: fadeIn 1s ease-out 1.7s both;
        }
        
        .footer-link p {
            color: rgba(255, 255, 255, 0.7);
            margin: 0;
        }
        
        .footer-link a {
            color: #a5b4fc;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .footer-link a::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 2px;
            background: linear-gradient(90deg, #6366f1, #a855f7);
            transition: width 0.3s ease;
        }
        
        .footer-link a:hover {
            color: #6366f1;
            transform: translateY(-1px);
        }
        
        .footer-link a:hover::after {
            width: 100%;
        }
        
        /* Loading animation */
        .btn-login.loading {
            pointer-events: none;
        }
        
        .btn-login.loading::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 20px;
            height: 20px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-top: 2px solid #ffffff;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            transform: translate(-50%, -50%);
        }
        
        @keyframes spin {
            0% { transform: translate(-50%, -50%) rotate(0deg); }
            100% { transform: translate(-50%, -50%) rotate(360deg); }
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .login-card {
                margin: 1rem;
                padding: 2rem 1.5rem;
            }
            
            .login-title {
                font-size: 1.3rem;
            }
        }
    </style>
</head>
<body>
    <!-- Animated background -->
    <div class="bg-animation" id="bg-animation"></div>


    <!-- Login Container -->
    <div class="login-container">
        <div class="login-card">
            <% 
            // Verifica se há mensagem de erro ou sucesso
            String erro = request.getParameter("erro");
            String sucesso = request.getParameter("sucesso");
            
            if (erro != null) {
                if (erro.equals("credenciais_invalidas")) {
                    out.println("<div class='alert alert-danger mb-4'><i class='fas fa-exclamation-triangle me-2'></i>Usuário ou senha inválidos.</div>");
                }
            }
    
            %>
            
            <div class="login-header">
                <div class="custom-logo">
                    <div class="logo">
                        <span class="logo-text">Study</span><span class="logo-e">e</span><span class="logo-dot">.</span>
                    </div>
                </div>
                <div class="login-separator"></div>
                <h3 class="login-title">Bem-vindo de volta</h3>
                <p class="login-subtitle">Entre na sua conta para continuar</p>
            </div>
            
            <form action="processar-login.jsp" method="POST" id="loginForm">
                <div class="form-group">
                    <input type="text" class="form-control" id="username" name="username" placeholder="Nome de usuário" required>
                    <i class="fas fa-user input-icon"></i>
                </div>
                
                <div class="form-group">
                    <input type="password" class="form-control" id="senha" name="senha" placeholder="Senha" required>
                    <i class="fas fa-lock input-icon"></i>
                </div>
                
                <div class="form-check">
                    <input type="checkbox" class="form-check-input" id="lembrar" name="lembrar">
                    <label class="form-check-label" for="lembrar">Lembrar de mim</label>
                </div>
                
                <button type="submit" class="btn btn-login" id="loginBtn">
                    <span id="btnText">Entrar</span>
                </button>
            </form>
            
            <div class="footer-link">
                <p>Não tem uma conta? <a href="cadastro.jsp">Cadastre-se</a></p>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Simple welcome state check
        function checkWelcomeSuccess() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('sucesso') === 'cadastro_completo') {
                const body = document.body;
                const title = document.querySelector('.login-title');
                const subtitle = document.querySelector('.login-subtitle');
                const card = document.querySelector('.login-card');
                
                // Create welcome overlay
                const overlay = document.createElement('div');
                overlay.className = 'welcome-overlay';
                body.appendChild(overlay);
                
                // Fade in welcome state
                setTimeout(() => {
                    overlay.classList.add('active');
                    title.classList.add('welcome-success');
                    subtitle.classList.add('welcome-success');
                    card.classList.add('welcome-success');
                    
                    // Smooth text transition
                    title.style.opacity = '0';
                    subtitle.style.opacity = '0';
                    
                    setTimeout(() => {
                        title.textContent = '🎉 Bem-vindo ao Studye!';
                        subtitle.textContent = 'Sua conta foi criada! Faça login para começar sua jornada.';
                        
                        title.style.opacity = '1';
                        subtitle.style.opacity = '1';
                    }, 300);
                }, 200);
                
                // Start fade out animation after 4 seconds
                setTimeout(() => {
                    // Fade out welcome content
                    title.classList.add('fade-out');
                    subtitle.classList.add('fade-out');
                    overlay.classList.remove('active');
                    
                    setTimeout(() => {
                        // Reset content
                        title.textContent = 'Bem-vindo de volta';
                        subtitle.textContent = 'Entre na sua conta para continuar';
                        
                        // Remove classes and fade back in
                        title.classList.remove('welcome-success', 'fade-out');
                        subtitle.classList.remove('welcome-success', 'fade-out');
                        card.classList.remove('welcome-success');
                        
                        // Reset opacity and transform
                        title.style.opacity = '1';
                        subtitle.style.opacity = '1';
                        title.style.transform = 'translateY(0)';
                        subtitle.style.transform = 'translateY(0)';
                        
                        // Remove overlay after transition completes
                        setTimeout(() => {
                            if (overlay.parentNode) {
                                overlay.parentNode.removeChild(overlay);
                            }
                        }, 3000);
                    }, 1000);
                }, 4000);
            }
        }

        // Create animated background particles
        function createParticles() {
            const bgAnimation = document.getElementById('bg-animation');
            
            // Clear existing particles first
            bgAnimation.innerHTML = '';
            
            for (let i = 0; i < 30; i++) {
                const particle = document.createElement('div');
                particle.className = 'particle';
                particle.style.left = Math.random() * 100 + '%';
                particle.style.animationDelay = Math.random() * 15 + 's';
                particle.style.animationDuration = (Math.random() * 15 + 15) + 's';
                particle.style.opacity = Math.random() * 0.4 + 0.1;
                
                // Ensure particles start from bottom
                particle.style.transform = 'translateY(100vh)';
                
                bgAnimation.appendChild(particle);
            }
        }
        
        // Check for welcome state
        function checkWelcomeState() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('sucesso') === 'cadastro_completo') {
                setTimeout(activateWelcomeMode, 1000);
            }
        }

        // Clear particles on page unload to prevent accumulation
        window.addEventListener('beforeunload', function() {
            const bgAnimation = document.getElementById('bg-animation');
            if (bgAnimation) {
                bgAnimation.innerHTML = '';
            }
        });
        
        // Form validation and loading animation
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const btn = document.getElementById('loginBtn');
            const btnText = document.getElementById('btnText');
            
            // Add loading state with smooth transition
            btn.style.transition = 'all 0.3s ease';
            btn.classList.add('loading');
            btnText.style.transition = 'opacity 0.3s ease';
            btnText.style.opacity = '0';
            
            // Remove loading state after a delay (you can remove this in production)
            setTimeout(() => {
                btn.classList.remove('loading');
                btnText.style.opacity = '1';
            }, 2000);
        });
        
        // Initialize particles when page loads
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(createParticles, 100);
            checkWelcomeSuccess();
        });
        
        // Navbar scroll effect
        window.addEventListener('scroll', () => {
            const navbar = document.querySelector('.navbar');
            if (window.scrollY > 50) {
                navbar.style.background = 'rgba(26, 27, 38, 0.98)';
            } else {
                navbar.style.background = 'rgba(26, 27, 38, 0.95)';
            }
        });
    </script>
</body>
</html>