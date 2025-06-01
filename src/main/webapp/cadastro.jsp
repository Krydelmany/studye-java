<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.dao.UsuarioDAO" %>

<!DOCTYPE html>
<html>
<head>
    <title>Studye - Cadastro de Usuário</title>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        @import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&display=swap');
        
        /* Reset and base styles */
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
        
        /* Background animations */
        .bg-animation {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            overflow: hidden;
            pointer-events: none;
        }
        
        .particle {
            position: absolute;
            width: 4px;
            height: 4px;
            background: linear-gradient(45deg, #6366f1, #a855f7);
            border-radius: 50%;
            animation: float 15s infinite linear;
            opacity: 0;
        }
        
        @keyframes float {
            0% { transform: translateY(100vh) translateX(0) rotate(0deg); opacity: 0; }
            10% { opacity: 1; }
            90% { opacity: 1; }
            100% { transform: translateY(-100vh) translateX(50px) rotate(360deg); opacity: 0; }
        }
        
        /* Layout */
        .main-container {
            padding: 2rem 20px 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            justify-content: center;
        }
        
        .signup-card {
            background: rgba(26, 27, 38, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 3rem 2.5rem;
            width: 100%;
            max-width: 500px;
            box-shadow: 
                0 20px 60px rgba(0, 0, 0, 0.5),
                0 0 0 1px rgba(99, 102, 241, 0.1),
                inset 0 1px 0 rgba(255, 255, 255, 0.1);
            animation: slideUp 0.8s ease-out;
            position: relative;
            overflow: hidden;
            margin-bottom: 2rem;
        }
        
        .signup-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(99, 102, 241, 0.1), transparent);
            animation: shimmer 3s infinite;
        }
        
        /* Animations */
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(50px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes shimmer {
            0% { left: -100%; }
            100% { left: 100%; }
        }
        
        @keyframes slideInFade {
            0% { opacity: 0; transform: translateX(-20px); filter: blur(2px); }
            100% { opacity: 1; transform: translateX(0); filter: blur(0); }
        }
        
        @keyframes rotateFloat {
            0% { opacity: 0; transform: rotate(25deg) translateY(-10px) scale(0.9); filter: blur(1px); }
            60% { transform: rotate(-12deg) translateY(2px) scale(1.02); }
            100% { opacity: 1; transform: rotate(-8deg) translateY(0) scale(1); filter: blur(0); }
        }
        
        @keyframes popIn {
            0% { opacity: 0; transform: scale(0) rotate(180deg); }
            70% { transform: scale(1.15) rotate(-10deg); }
            100% { opacity: 1; transform: scale(1) rotate(0deg); }
        }
        
        @keyframes pulse-glow {
            0%, 100% { text-shadow: 0 0 15px rgba(139, 92, 246, 0.8), 0 0 25px rgba(139, 92, 246, 0.4); }
            50% { text-shadow: 0 0 20px rgba(139, 92, 246, 1), 0 0 35px rgba(139, 92, 246, 0.6), 0 0 50px rgba(139, 92, 246, 0.2); }
        }
        
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* Header and Logo */
        .signup-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }
        
        .custom-logo {
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            cursor: pointer;
            user-select: none;
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
        
        .custom-logo:hover .logo-text {
            transform: translateX(-3px) translateY(-1px);
            color: #f8fafc;
            text-shadow: 0 2px 8px rgba(255, 255, 255, 0.1);
        }
        
        .custom-logo:hover .logo-e {
            transform: rotate(-20deg) scale(1.15) translateY(-3px);
            color: #a78bfa;
            text-shadow: 0 0 20px rgba(139, 92, 246, 0.6), 0 0 40px rgba(139, 92, 246, 0.3), 0 0 60px rgba(139, 92, 246, 0.1);
            filter: drop-shadow(0 4px 8px rgba(139, 92, 246, 0.3));
        }
        
        .custom-logo:hover .logo-dot {
            transform: scale(1.3) translateY(-2px);
            color: #8b5cf6;
            text-shadow: 0 0 15px rgba(139, 92, 246, 0.8), 0 0 25px rgba(139, 92, 246, 0.4);
            animation: pulse-glow 1.5s ease-in-out infinite;
        }
        
        .signup-separator {
            width: 40px;
            height: 1px;
            background: rgba(99, 102, 241, 0.3);
            margin: 1.2rem auto;
        }
        
        .welcome-text {
            background: linear-gradient(135deg, #ffffff, #a5b4fc);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: 700;
            font-size: 1.5rem;
            margin: 1rem 0;
            font-family: 'Inter', sans-serif;
            animation: slideDown 0.8s ease-out 0.3s backwards;
            text-align: center;
        }
        
        .welcome-logo {
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
            font-size: 1.6rem;
            display: inline-flex;
            align-items: baseline;
            background: none;
            -webkit-text-fill-color: initial;
        }
        
        .welcome-logo .logo-text {
            color: #ffffff;
            font-weight: 700;
            background: none;
            -webkit-text-fill-color: initial;
        }
        
        .welcome-logo .logo-e {
            color: #8b5cf6;
            font-weight: 700;
            transform: rotate(-8deg);
            transform-origin: center;
            display: inline-block;
            margin: 0 0.02em;
            background: none;
            -webkit-text-fill-color: initial;
        }
        
        .welcome-logo .logo-dot {
            color: #ffffff;
            margin-left: 0.02em;
            background: none;
            -webkit-text-fill-color: initial;
        }
        
        .signup-subtitle {
            color: rgba(255, 255, 255, 0.8);
            font-weight: 400;
        }
        
        /* Form styles */
        .form-group {
            position: relative;
            margin-bottom: 0.5rem;
        }
        
        .form-group.compact {
            margin-bottom: 0.2rem;
        }
        
        .form-control {
            background: rgba(255, 255, 255, 0.05);
            border: 2px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            color: #f1f5f9;
            font-size: 1rem;
            padding: 1rem 1rem 1rem 3rem;
            transition: all 0.3s ease;
            width: 100%;
        }
        
        .form-control:focus {
            background: rgba(255, 255, 255, 0.1);
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
            outline: none;
            color: #ffffff;
        }
        
        .form-control.valid { border-color: #22c55e; }
        .form-control.invalid { border-color: #ef4444; }
        
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.5);
            transition: all 0.3s ease;
        }
        
        .form-control:focus::placeholder {
            color: rgba(255, 255, 255, 0.3);
        }
        
        /* Icon styles */
        .input-icon {
            position: absolute;
            top: 1.1rem;
            left: 1rem;
            transform: translateY(0);
            color: rgba(255, 255, 255, 0.5);
            z-index: 1;
            transition: all 0.3s ease;
            line-height: 1.5rem;
            height: 1.5rem;
            display: flex;
            align-items: center;
        }
        
        .form-control:focus + .input-icon {
            color: #6366f1;
        }
        
        .password-toggle {
            position: absolute;
            top: 1.1rem;
            right: 1rem;
            transform: translateY(0);
            color: rgba(255, 255, 255, 0.39);
            cursor: pointer;
            z-index: 3;
            transition: all 0.3s ease;
            line-height: 1.5rem;
            height: 1.5rem;
            display: flex;
            align-items: center;
            font-size: 1rem;
        }
        
        .password-toggle:hover {
            color: #6366f1;
            transform: translateY(0) scale(1.1);
        }
        
        .validation-icon {
            position: absolute;
            top: 1rem;
            right: 1rem;
            transform: translateY(0);
            font-size: 1rem;
            opacity: 0;
            transition: all 0.3s ease;
            z-index: 2;
            pointer-events: none;
            line-height: 1.5rem;
            height: 1.5rem;
            display: flex;
            align-items: center;
        }
        
        /* Help text and password strength */
        .input-help {
            font-size: 0.85rem;
            color: rgba(255, 255, 255, 0.7);
            margin-top: 0.2rem;
            margin-bottom: 0rem;
            opacity: 0;
            transition: all 0.3s ease;
            padding-left: 0.2rem;
        }
        
        .input-help.show { opacity: 1; }
        .input-help.error { color: #fca5a5; }
        .input-help.success { color: #86efac; }
        
        .password-strength {
            margin-top: 0.2rem;
            margin-bottom: 0rem;
            height: 4px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 2px;
            overflow: hidden;
            opacity: 0;
            transition: all 0.3s ease;
        }
        
        .password-strength.show { opacity: 1; }
        
        .strength-bar {
            height: 100%;
            width: 0;
            transition: all 0.3s ease;
            border-radius: 2px;
        }
        
        .strength-weak { background: #ef4444; width: 25%; }
        .strength-fair { background: #f59e0b; width: 50%; }
        .strength-good { background: #3b82f6; width: 75%; }
        .strength-strong { background: #22c55e; width: 100%; }
        
        /* Button styles */
        .btn-signup {
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
            margin-top: 1rem;
        }
        
        .btn-signup:hover:not(:disabled) {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(99, 102, 241, 0.4);
        }
        
        .btn-signup:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
            background: rgba(255, 255, 255, 0.1);
        }
        
        .btn-signup.loading { pointer-events: none; }
        
        .btn-signup .spinner {
            display: none;
            width: 20px;
            height: 20px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-top: 2px solid #ffffff;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-right: 10px;
        }
        
        .btn-signup.loading .spinner { display: inline-block; }
        
        /* Alert styles */
        .alert {
            border: none;
            border-radius: 12px;
            font-weight: 500;
            animation: slideDown 0.5s ease-out;
            position: relative;
            overflow: hidden;
            margin-bottom: 2rem;
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
        
        /* Responsive */
        @media (max-width: 768px) {
            .main-container { padding: 2rem 15px; }
            .signup-card { padding: 2rem 1.5rem; }
            .custom-logo .logo { font-size: 2rem; }
        }
    </style>
</head>
<body>
    <!-- Animated background -->
    <div class="bg-animation" id="bg-animation"></div>

    <!-- Main Container -->
    <div class="main-container">
        <!-- Signup Card -->
        <div class="signup-card">
            <% 
            // Verifica se há mensagem de erro
            String erro = request.getParameter("erro");
            if (erro != null) {
                if (erro.equals("senhas_diferentes")) {
                    out.println("<div class='alert alert-danger'><i class='fas fa-exclamation-triangle me-2'></i>As senhas informadas não coincidem.</div>");
                } else if (erro.equals("conexao_bd")) {
                    out.println("<div class='alert alert-danger'><i class='fas fa-database me-2'></i>Não foi possível conectar ao banco de dados. Tente novamente mais tarde.</div>");
                } else if (erro.equals("usuario_existente")) {
                    out.println("<div class='alert alert-danger'><i class='fas fa-user-times me-2'></i>Nome de usuário já existe. Escolha outro nome.</div>");
                } else if (erro.equals("email_existente")) {
                    out.println("<div class='alert alert-danger'><i class='fas fa-envelope-open me-2'></i>Email já cadastrado. Use outro email.</div>");
                }
            }
            %>
            
            <div class="signup-header">
                <h3 class="welcome-text">
                    Faça parte do <span class="welcome-logo">
                        <span class="logo-text">Study</span><span class="logo-e">e</span><span class="logo-dot">.</span>
                    </span>
                </h3>
                <div class="signup-separator"></div>
                <p class="signup-subtitle">Descubra uma nova forma de aprender</p>
            </div>
            
            <form action="processar-cadastro.jsp" method="POST" id="signupForm" novalidate>
                <div class="form-group">
                    <input type="text" class="form-control" id="username" name="username" placeholder="Nome de usuário" required>
                    <i class="fas fa-user input-icon"></i>
                    <i class="fas fa-check validation-icon success" id="usernameValid"></i>
                    <i class="fas fa-times validation-icon error" id="usernameInvalid"></i>
                    <div class="input-help" id="usernameHelp">Você pode usar letras, números e sublinhados</div>
                </div>
                
                <div class="form-group">
                    <input type="email" class="form-control" id="email" name="email" placeholder="Endereço de e-mail" required>
                    <i class="fas fa-envelope input-icon"></i>
                    <i class="fas fa-check validation-icon success" id="emailValid"></i>
                    <i class="fas fa-times validation-icon error" id="emailInvalid"></i>
                    <div class="input-help" id="emailHelp">Digite um email válido</div>
                </div>
                
                <div class="form-group">
                    <input type="password" class="form-control" id="senha" name="senha" placeholder="Senha" required>
                    <i class="fas fa-lock input-icon"></i>
                    <i class="fas fa-eye password-toggle" id="toggleSenha"></i>
                    <i class="fas fa-check validation-icon success" id="senhaValid"></i>
                    <i class="fas fa-times validation-icon error" id="senhaInvalid"></i>
                    <div class="password-strength" id="passwordStrength">
                        <div class="strength-bar" id="strengthBar"></div>
                    </div>
                    <div class="input-help" id="senhaHelp">Mínimo 6 caracteres</div>
                </div>
                
                <div class="form-group">
                    <input type="password" class="form-control" id="confirmarSenha" name="confirmarSenha" placeholder="Confirmar senha" required>
                    <i class="fas fa-lock input-icon"></i>
                    <i class="fas fa-eye password-toggle" id="toggleConfirmarSenha"></i>
                    <i class="fas fa-check validation-icon success" id="confirmValid"></i>
                    <i class="fas fa-times validation-icon error" id="confirmInvalid"></i>
                    <div class="input-help" id="confirmHelp">As senhas devem ser iguais</div>
                </div>
        
                <button type="submit" class="btn btn-signup" id="signupBtn" disabled>
                    <div class="spinner" id="spinner"></div>
                    <span id="btnText">Criar Conta</span>
                </button>
            </form>

            <div class="footer-link">
                <p>Já tem uma conta? <a href="login.jsp">Faça login</a></p>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Configuration and state
        const CONFIG = {
            particles: {
                max: 25,
                maxOnSubmit: 100,
                interval: 600,
                intervalOnSubmit: 80,
                lifetime: 20000,
                lifetimeOnSubmit: 12000
            },
            validation: {
                username: {
                    minLength: 3,
                    pattern: /^[a-zA-Z0-9_]+$/
                },
                email: {
                    pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/
                },
                password: {
                    minLength: 6
                }
            }
        };

        let particleInterval;
        let particleCount = 0;
        let isSubmitting = false;
        let burstInterval;
        let speedInterval;

        // DOM elements
        const elements = {
            form: document.getElementById('signupForm'),
            inputs: {
                username: document.getElementById('username'),
                email: document.getElementById('email'),
                senha: document.getElementById('senha'),
                confirmarSenha: document.getElementById('confirmarSenha')
            },
            buttons: {
                signup: document.getElementById('signupBtn'),
                btnText: document.getElementById('btnText')
            },
            validationIcons: {
                usernameValid: document.getElementById('usernameValid'),
                usernameInvalid: document.getElementById('usernameInvalid'),
                emailValid: document.getElementById('emailValid'),
                emailInvalid: document.getElementById('emailInvalid'),
                senhaValid: document.getElementById('senhaValid'),
                senhaInvalid: document.getElementById('senhaInvalid'),
                confirmValid: document.getElementById('confirmValid'),
                confirmInvalid: document.getElementById('confirmInvalid')
            },
            helpTexts: {
                username: document.getElementById('usernameHelp'),
                email: document.getElementById('emailHelp'),
                senha: document.getElementById('senhaHelp'),
                confirm: document.getElementById('confirmHelp')
            },
            passwordStrength: {
                container: document.getElementById('passwordStrength'),
                bar: document.getElementById('strengthBar')
            }
        };

        // Particle animation management
        function createParticle() {
            const bgAnimation = document.getElementById('bg-animation');
            const maxParticles = isSubmitting ? CONFIG.particles.maxOnSubmit : CONFIG.particles.max;
            
            if (!bgAnimation || particleCount >= maxParticles) return;

            const particle = document.createElement('div');
            particle.className = 'particle';
            particle.style.left = Math.random() * 100 + '%';
            particle.style.animationDelay = '0s';
            
            // Enhanced particles when submitting
            if (isSubmitting) {
                const size = Math.random() * 6 + 5; // 5-11px (larger)
                particle.style.width = size + 'px';
                particle.style.height = size + 'px';
                particle.style.opacity = Math.random() * 0.9 + 0.3; // More visible
                particle.style.animationDuration = (Math.random() * 4 + 3) + 's'; // Much faster
                
                // Dramatic glow effect with multiple colors
                const glowIntensity = size * 4;
                particle.style.boxShadow = `
                    0 0 ${glowIntensity}px rgba(99, 102, 241, 0.9),
                    0 0 ${glowIntensity * 2}px rgba(139, 92, 246, 0.5),
                    0 0 ${glowIntensity * 3}px rgba(168, 85, 247, 0.3)
                `;
                
                // Random vibrant colors for variety
                const colors = [
                    'linear-gradient(45deg, #6366f1, #a855f7)',
                    'linear-gradient(45deg, #8b5cf6, #ec4899)',
                    'linear-gradient(45deg, #3b82f6, #06b6d4)',
                    'linear-gradient(45deg, #10b981, #059669)',
                    'linear-gradient(45deg, #f59e0b, #f97316)'
                ];
                particle.style.background = colors[Math.floor(Math.random() * colors.length)];
            } else {
                particle.style.animationDuration = (Math.random() * 10 + 12) + 's';
            }
            
            bgAnimation.appendChild(particle);
            particleCount++;
            
            const lifetime = isSubmitting ? CONFIG.particles.lifetimeOnSubmit : CONFIG.particles.lifetime;
            setTimeout(() => {
                if (particle && particle.parentNode) {
                    particle.parentNode.removeChild(particle);
                    particleCount--;
                }
            }, lifetime);
        }

        function createParticleBurst() {
            // Create multiple particles at once for burst effect
            for (let i = 0; i < 8; i++) {
                setTimeout(() => createParticle(), i * 30);
            }
        }

        function initParticles() {
            if (particleInterval) clearInterval(particleInterval);
            if (burstInterval) clearInterval(burstInterval);
            if (speedInterval) clearInterval(speedInterval);
            
            const interval = isSubmitting ? CONFIG.particles.intervalOnSubmit : CONFIG.particles.interval;
            particleInterval = setInterval(createParticle, interval);
        }

        function enhanceParticles() {
            isSubmitting = true;
            
            // Initial dramatic burst
            createParticleBurst();
            setTimeout(() => createParticleBurst(), 200);
            
            // Start enhanced particle generation
            initParticles();
            
            // Progressive speed increase
            let currentSpeed = CONFIG.particles.intervalOnSubmit;
            speedInterval = setInterval(() => {
                if (currentSpeed > 30) { // Minimum interval of 30ms
                    currentSpeed -= 10;
                    if (particleInterval) clearInterval(particleInterval);
                    particleInterval = setInterval(() => {
                        createParticle();
                        // 40% chance of creating an extra particle for intensity
                        if (Math.random() > 0.6) createParticle();
                    }, currentSpeed);
                }
            }, 300);
            
            // Add periodic intense bursts
            burstInterval = setInterval(() => {
                createParticleBurst();
                // Extra burst for dramatic effect
                setTimeout(() => createParticleBurst(), 100);
            }, 600);
        }

        function resetParticles() {
            isSubmitting = false;
            if (burstInterval) clearInterval(burstInterval);
            if (speedInterval) clearInterval(speedInterval);
            initParticles();
        }

        function cleanupParticles() {
            if (particleInterval) clearInterval(particleInterval);
            if (burstInterval) clearInterval(burstInterval);
            if (speedInterval) clearInterval(speedInterval);
            const bgAnimation = document.getElementById('bg-animation');
            if (bgAnimation) bgAnimation.innerHTML = '';
            particleCount = 0;
        }

        // Validation utilities
        function getFieldElements(field) {
            const fieldName = field === 'confirm' ? 'confirmarSenha' : field;
            const iconSuffix = field === 'confirm' ? 'confirm' : field;
            
            return {
                input: elements.inputs[fieldName] || document.getElementById(fieldName),
                validIcon: elements.validationIcons[iconSuffix + 'Valid'],
                invalidIcon: elements.validationIcons[iconSuffix + 'Invalid'],
                helpText: elements.helpTexts[field]
            };
        }

        function updateValidationUI(field, isValid, message) {
            const { input, validIcon, invalidIcon, helpText } = getFieldElements(field);
            
            if (!input) return;

            input.classList.toggle('valid', isValid);
            input.classList.toggle('invalid', !isValid);
            
            if (validIcon) validIcon.classList.toggle('show', isValid);
            if (invalidIcon) invalidIcon.classList.toggle('show', !isValid);
            
            if (helpText) {
                helpText.textContent = message;
                helpText.classList.add('show');
                helpText.classList.toggle('success', isValid);
                helpText.classList.toggle('error', !isValid);
            }
        }

        function resetValidation(field) {
            const { input, validIcon, invalidIcon, helpText } = getFieldElements(field);
            
            if (input) input.classList.remove('valid', 'invalid');
            if (validIcon) validIcon.classList.remove('show');
            if (invalidIcon) invalidIcon.classList.remove('show');
            if (helpText) helpText.classList.remove('show', 'success', 'error');
        }

        // Individual validation functions
        function validateUsername() {
            const value = elements.inputs.username?.value.trim() || '';
            if (!value) {
                resetValidation('username');
                return false;
            }

            const isValid = value.length >= CONFIG.validation.username.minLength && 
                           CONFIG.validation.username.pattern.test(value);
            
            updateValidationUI('username', isValid, 
                isValid ? 'Nome de usuário válido' : 'Mínimo 3 caracteres, apenas letras, números e _');
            
            return isValid;
        }

        function validateEmail() {
            const value = elements.inputs.email?.value.trim() || '';
            if (!value) {
                resetValidation('email');
                return false;
            }

            const isValid = CONFIG.validation.email.pattern.test(value);
            updateValidationUI('email', isValid, 
                isValid ? 'Email válido' : 'Digite um email válido');
            
            return isValid;
        }

        function validatePassword() {
            const value = elements.inputs.senha?.value || '';
            if (!value) {
                resetValidation('senha');
                document.getElementById('passwordStrength')?.classList.remove('show');
                return false;
            }

            const strength = calculatePasswordStrength(value);
            
            // Show the password strength indicator
            const passwordStrength = document.getElementById('passwordStrength');
            if (passwordStrength) {
                passwordStrength.classList.add('show');
            }
            
            updatePasswordStrength(strength);

            const isValid = value.length >= CONFIG.validation.password.minLength;
            updateValidationUI('senha', isValid, 
                isValid ? 'Senha válida' : 'Mínimo 6 caracteres');
            
            return isValid;
        }

        function validateConfirmPassword() {
            const senha = elements.inputs.senha?.value || '';
            const confirmSenha = elements.inputs.confirmarSenha?.value || '';
            
            if (!confirmSenha) {
                resetValidation('confirm');
                return false;
            }

            const isValid = senha === confirmSenha && senha.length >= CONFIG.validation.password.minLength;
            updateValidationUI('confirm', isValid, 
                isValid ? 'Senhas coincidem' : 'As senhas devem ser iguais');
            
            return isValid;
        }

        // Password strength utilities
        function calculatePasswordStrength(password) {
            let score = 0;
            if (password.length >= 8) score++;
            if (/[a-z]/.test(password)) score++;
            if (/[A-Z]/.test(password)) score++;
            if (/[0-9]/.test(password)) score++;
            if (/[^A-Za-z0-9]/.test(password)) score++;

            const levels = [
                { level: 'weak', text: 'Fraca', cssClass: 'strength-weak' },
                { level: 'weak', text: 'Fraca', cssClass: 'strength-weak' },
                { level: 'fair', text: 'Regular', cssClass: 'strength-fair' },
                { level: 'good', text: 'Boa', cssClass: 'strength-good' },
                { level: 'good', text: 'Boa', cssClass: 'strength-good' },
                { level: 'strong', text: 'Forte', cssClass: 'strength-strong' }
            ];

            return levels[score] || levels[0];
        }

        function updatePasswordStrength(strength) {
            const strengthBar = document.getElementById('strengthBar');
            if (strengthBar) {
                // Remove all existing strength classes
                strengthBar.className = 'strength-bar';
                
                // Add the appropriate strength class
                strengthBar.classList.add(strength.cssClass);
                
                // Force a reflow to ensure the animation works
                strengthBar.offsetHeight;
            }
        }

        // Form validation orchestration
        function validateForm() {
            const validations = [
                validateUsername(),
                validateEmail(),
                validatePassword(),
                validateConfirmPassword()
            ];

            const isValid = validations.every(Boolean);
            if (elements.buttons.signup) {
                elements.buttons.signup.disabled = !isValid;
            }

            return isValid;
        }

        // Event handlers
        function setupEventListeners() {
            // Password toggle functionality
            document.getElementById('toggleSenha')?.addEventListener('click', function() {
                const senhaInput = document.getElementById('senha');
                const isPassword = senhaInput.type === 'password';
                senhaInput.type = isPassword ? 'text' : 'password';
                this.classList.toggle('fa-eye');
                this.classList.toggle('fa-eye-slash');
            });
            
            document.getElementById('toggleConfirmarSenha')?.addEventListener('click', function() {
                const confirmInput = document.getElementById('confirmarSenha');
                const isPassword = confirmInput.type === 'password';
                confirmInput.type = isPassword ? 'text' : 'password';
                this.classList.toggle('fa-eye');
                this.classList.toggle('fa-eye-slash');
            });
            
            // Input validation
            Object.entries({
                username: validateUsername,
                email: validateEmail,
                senha: () => {
                    validatePassword();
                    if (elements.inputs.confirmarSenha?.value) validateConfirmPassword();
                },
                confirmarSenha: validateConfirmPassword
            }).forEach(([field, validator]) => {
                const input = elements.inputs[field];
                if (input) {
                    input.addEventListener('input', () => {
                        validator();
                        validateForm();
                    });
                    input.addEventListener('blur', validator);
                }
            });

            // Form submission
            if (elements.form) {
                elements.form.addEventListener('submit', function(e) {
                    e.preventDefault();
                    
                    if (!validateForm()) return;

                    const btn = elements.buttons.signup;
                    const btnText = elements.buttons.btnText;
                    
                    if (btn && btnText) {
                        // Start dramatic particle enhancement
                        enhanceParticles();
                        
                        btn.classList.add('loading');
                        btn.disabled = true;
                        btnText.textContent = 'Criando conta...';
                        
                        // Add visual feedback to the card with pulsing effect
                        const card = document.querySelector('.signup-card');
                        if (card) {
                            card.style.boxShadow = `
                                0 20px 60px rgba(0, 0, 0, 0.5),
                                0 0 0 1px rgba(99, 102, 241, 0.4),
                                inset 0 1px 0 rgba(255, 255, 255, 0.1),
                                0 0 50px rgba(99, 102, 241, 0.3),
                                0 0 100px rgba(139, 92, 246, 0.2)
                            `;
                            card.style.transform = 'scale(1.02)';
                            card.style.transition = 'all 0.3s ease';
                        }
                        
                        setTimeout(() => this.submit(), 2000);
                    } else {
                        this.submit();
                    }
                });
            }
        }

        // Initialization
        function init() {
            setupEventListeners();
            setTimeout(initParticles, 100);
        }

        // Cleanup
        function cleanup() {
            cleanupParticles();
        }

        // Event listeners for lifecycle
        document.addEventListener('DOMContentLoaded', init);
        window.addEventListener('beforeunload', cleanup);
        window.addEventListener('unload', cleanup);
    </script>
</body>
</html>