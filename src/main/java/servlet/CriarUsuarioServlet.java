package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.format.DateTimeFormatter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Usuario;
import modelo.dao.UsuarioDAO;

@WebServlet("/cadastro")
public class CriarUsuarioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Exibe o formulário de cadastro
    @Override
    protected void doGet(HttpServletRequest requisicao, HttpServletResponse resposta) 
            throws ServletException, IOException {
        resposta.setCharacterEncoding("UTF-8");
        resposta.setContentType("text/html; charset=UTF-8");
        
        // Verifica se há mensagem de erro
        String erro = requisicao.getParameter("erro");
        String mensagemErro = "";
        if (erro != null) {
            if (erro.equals("senhas_diferentes")) {
                mensagemErro = "<div class='alert alert-danger'>As senhas informadas não coincidem.</div>";
            } else if (erro.equals("conexao_bd")) {
                mensagemErro = "<div class='alert alert-danger'>Não foi possível conectar ao banco de dados. Tente novamente mais tarde.</div>";
            }
        }
        
        PrintWriter saida = resposta.getWriter();
        saida.append("<html>");
            saida.append("<head>");
                saida.append("<title>Studye - Cadastro de Usuário</title>");
                saida.append("<meta charset='UTF-8'/>");
                saida.append("<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css\" rel=\"stylesheet\" integrity=\"sha384-SgOJa3DmI69IUzQ2PVdRZhwQ+dy64/BUtbMJw1MZ8t5HZApcHrRKUc4W0kG879m7\" crossorigin=\"anonymous\">");
                saida.append("<style>");
                    saida.append("body { background-color: #1e1e2e; color: #ffffff; }");
                    saida.append(".form-control { background-color: rgba(255,255,255,0.1); color: #d0d0d0; border: none; }");
                    saida.append(".form-control:focus { background-color: rgba(255,255,255,0.15); color: #e6e6e6; }");
                    saida.append(".form-control::placeholder { color: rgba(255,255,255,0.7); }"); // Make placeholders more visible
                    saida.append(".btn-primary { background-color: #6366f1; border: none; }");
                    saida.append(".progress { height: 4px; margin-bottom: 30px; }");
                    saida.append(".progress-bar { background-color: #6366f1; }");
                    saida.append(".progress-step { position: relative; }");
                    saida.append(".progress-step.active .step-circle { background-color: #6366f1; }");
                    saida.append(".progress-step.completed .step-circle { background-color: #6366f1; }");
                    saida.append(".step-circle { width: 24px; height: 24px; border-radius: 50%; background-color: #6c757d; display: flex; align-items: center; justify-content: center; }");
                    saida.append(".step-text { font-size: 12px; color: #ffffff; margin-top: 4px; }"); // Make step text white instead of gray
                    saida.append(".card { background-color: #1a1b26 !important; }");
                    saida.append(".text-muted { color: rgba(255,255,255,0.7) !important; }"); // Make muted text more visible
                    saida.append("small { color: rgba(255,255,255,0.7) !important; }"); // Make all small text more visible
                    saida.append(".form-check-label { color: #ffffff; }"); // Ensure form labels are white
                    saida.append("a.text-primary { color: #a5b4fc !important; }"); // Make links more visible
                    saida.append("h3 { color: #ffffff !important; }"); // Ensure heading is white
                    saida.append(".user-table { margin-top: 40px; }");
                    saida.append(".collapsible { cursor: pointer; padding: 10px; width: 100%; text-align: center; }");
                    saida.append(".table { color: #d0d0d0; }");
                    saida.append(".table thead { color: #ffffff; }");
                    saida.append(".show-users-btn { margin-top: 20px; transition: all 0.3s; }");
                    saida.append(".show-users-btn:hover { transform: translateY(-2px); }");
                saida.append("</style>");
                saida.append("<script>");
                    saida.append("function toggleUserList() {");
                    saida.append("  var content = document.getElementById('userTableContainer');");
                    saida.append("  var btn = document.getElementById('showUsersBtn');");
                    saida.append("  if (content.style.display === 'none' || content.style.display === '') {");
                    saida.append("    content.style.display = 'block';");
                    saida.append("    btn.innerHTML = 'Ocultar lista de usuários';");
                    saida.append("  } else {");
                    saida.append("    content.style.display = 'none';");
                    saida.append("    btn.innerHTML = 'Ver todos usuários';");
                    saida.append("  }");
                    saida.append("}");
                saida.append("</script>");
            saida.append("</head>");
            saida.append("<body class='container d-flex flex-column justify-content-center align-items-center min-vh-100'>");
                saida.append("<div class='card p-4' style='width: 450px; border-radius: 10px;'>");
                    saida.append(mensagemErro); // Exibe mensagem de erro se houver
                    saida.append("<div class='text-center mb-4'>");
                        saida.append("<div class='d-flex justify-content-between mb-4'>");
                            saida.append("<div class='progress-step completed text-center'>");
                                saida.append("<div class='step-circle mx-auto'>✓</div>");
                                saida.append("<div class='step-text'>Aceitar regras</div>"); // Translated to Portuguese
                            saida.append("</div>");
                            saida.append("<div class='progress-step active text-center'>");
                                saida.append("<div class='step-circle mx-auto'>2</div>");
                                saida.append("<div class='step-text'>Seus dados</div>"); // Translated to Portuguese
                            saida.append("</div>");
                            saida.append("<div class='progress-step text-center'>");
                                saida.append("<div class='step-circle mx-auto'>3</div>");
                                saida.append("<div class='step-text'>Confirmar email</div>"); // Translated to Portuguese
                            saida.append("</div>");
                        saida.append("</div>");
                        saida.append("<div class='progress mb-4'>");
                            saida.append("<div class='progress-bar' role='progressbar' style='width: 50%' aria-valuenow='50' aria-valuemin='0' aria-valuemax='100'></div>");
                        saida.append("</div>");
                        saida.append("<h3 class='mb-4 text-white'>Vamos te cadastrar no Studye.</h3>"); // Added text-white class
                    saida.append("</div>");
                    
                    saida.append("<form action='cadastro' method='POST'>");
                        saida.append("<div class='mb-3'>");
                            saida.append("<input type='text' class='form-control' id='username' name='username' placeholder='Nome de usuário' required>"); // Translated to Portuguese
                            saida.append("<small class='text-muted'>Você pode usar letras, números e sublinhados</small>"); // Translated to Portuguese
                        saida.append("</div>");
                        saida.append("<div class='mb-3'>");
                            saida.append("<input type='email' class='form-control' id='email' name='email' placeholder='Endereço de e-mail' required>"); // Translated to Portuguese
                        saida.append("</div>");
                        saida.append("<div class='mb-3'>");
                            saida.append("<input type='password' class='form-control' id='senha' name='senha' placeholder='Senha' required>"); // Translated to Portuguese
                        saida.append("</div>");
                        saida.append("<div class='mb-3'>");
                            saida.append("<input type='password' class='form-control' id='confirmarSenha' name='confirmarSenha' placeholder='Confirmar senha' required>"); // Translated to Portuguese
                        saida.append("</div>");
                        saida.append("<button type='submit' class='btn btn-primary w-100 py-2 mt-3'>Cadastrar</button>"); // Translated to Portuguese
                    saida.append("</form>");
                    saida.append("<div class='text-center'>");
                        saida.append("<button id='showUsersBtn' onclick='toggleUserList()' class='btn btn-secondary show-users-btn'>Ver todos usuários</button>");
                    saida.append("</div>");
                saida.append("</div>");
                
                // Adicionar tabela de usuários (inicialmente oculta)
                saida.append("<div id='userTableContainer' class='card p-4 user-table' style='width: 90%; border-radius: 10px; display: none;'>");
                    saida.append("<h3 class='mb-4 text-white text-center'>Usuários Cadastrados</h3>");
                    saida.append("<div class='table-responsive'>");
                        saida.append("<table class='table table-striped table-hover'>");
                            saida.append("<thead>");
                                saida.append("<tr>");
                                    saida.append("<th>ID</th>");
                                    saida.append("<th>Username</th>");
                                    saida.append("<th>Nome</th>");
                                    saida.append("<th>Email</th>");
                                    saida.append("<th>Data de Criação</th>");
                                    saida.append("<th>Bio</th>");
                                saida.append("</tr>");
                            saida.append("</thead>");
                            saida.append("<tbody>");
                                UsuarioDAO usuarioDAO = new UsuarioDAO();
                                List<Usuario> usuarios = usuarioDAO.buscarTodos();
                                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
                                
                                for(Usuario usuario : usuarios) {
                                    saida.append("<tr>");
                                        saida.append("<td>" + usuario.getIdUsuario() + "</td>");
                                        saida.append("<td>" + usuario.getUsername() + "</td>");
                                        saida.append("<td>" + usuario.getNome() + "</td>");
                                        saida.append("<td>" + usuario.getEmail() + "</td>");
                                        saida.append("<td>" + (usuario.getDataCriacao() != null ? 
                                                    usuario.getDataCriacao().format(formatter) : "-") + "</td>");
                                        saida.append("<td>" + (usuario.getBio() != null && !usuario.getBio().isEmpty() ? 
                                                    usuario.getBio() : "-") + "</td>");
                                    saida.append("</tr>");
                                }
                            saida.append("</tbody>");
                        saida.append("</table>");
                    saida.append("</div>");
                saida.append("</div>");
            saida.append("</body>");
        saida.append("</html>");
    }
    
    // Processa o envio do formulário
    @Override
    protected void doPost(HttpServletRequest requisicao, HttpServletResponse resposta) 
            throws ServletException, IOException {
        requisicao.setCharacterEncoding("UTF-8");
        
        // Obter parâmetros do formulário
        String username = requisicao.getParameter("username");
        String email = requisicao.getParameter("email");
        String senha = requisicao.getParameter("senha");
        String confirmarSenha = requisicao.getParameter("confirmarSenha");
        
        // Validação básica
        if (!senha.equals(confirmarSenha)) {
            resposta.sendRedirect("cadastro?erro=senhas_diferentes");
            return;
        }
        
        // Criar objeto de usuário
        Usuario usuario = new Usuario();
        usuario.setUsername(username);
        usuario.setNome(username); // Usando o username como nome por padrão
        usuario.setEmail(email);
        usuario.setSenha(senha);
        usuario.setBio(""); // Bio vazia por padrão
        
        // Salvar usuário no banco de dados
        try {
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            usuarioDAO.inserir(usuario); // Usando a assinatura original
            
            // Redirecionar para página de sucesso ou login
            resposta.sendRedirect("login?sucesso=cadastro_completo");
        } catch (Exception e) {
            // Registrar erro e redirecionar
            e.printStackTrace();
            resposta.sendRedirect("cadastro?erro=conexao_bd");
        }
    }
}
