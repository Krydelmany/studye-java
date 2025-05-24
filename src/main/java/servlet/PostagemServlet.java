package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Postagem;
import modelo.Usuario;
import modelo.dao.PostagemDAO;
import modelo.dao.UsuarioDAO;

@WebServlet("/postagens")
public class PostagemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest requisicao, HttpServletResponse resposta) 
            throws ServletException, IOException {
        resposta.setCharacterEncoding("UTF-8");
        resposta.setContentType("text/html; charset=UTF-8");
        
        // Verificar mensagens de erro ou sucesso
        String erro = requisicao.getParameter("erro");
        String sucesso = requisicao.getParameter("sucesso");
        String mensagem = "";
        
        if (erro != null) {
            if (erro.equals("dados_invalidos")) {
                mensagem = "<div class='alert alert-danger'>Dados inválidos. Verifique os campos e tente novamente.</div>";
            } else if (erro.equals("conexao_bd")) {
                mensagem = "<div class='alert alert-danger'>Não foi possível conectar ao banco de dados. Tente novamente mais tarde.</div>";
            } else if (erro.equals("postagem_nao_encontrada")) {
                mensagem = "<div class='alert alert-danger'>Postagem não encontrada.</div>";
            }
        } else if (sucesso != null) {
            if (sucesso.equals("postagem_criada")) {
                mensagem = "<div class='alert alert-success'>Postagem criada com sucesso!</div>";
            } else if (sucesso.equals("postagem_atualizada")) {
                mensagem = "<div class='alert alert-success'>Postagem atualizada com sucesso!</div>";
            }
        }
        
        // Verificar se estamos editando uma postagem
        String editId = requisicao.getParameter("edit");
        Postagem postagemParaEditar = null;
        
        if (editId != null && !editId.isEmpty()) {
            try {
                int idPostagem = Integer.parseInt(editId);
                PostagemDAO postagemDAO = new PostagemDAO();
                
                // Buscar todas as postagens e filtrar pela que queremos editar
                List<Postagem> todasPostagens = postagemDAO.buscarTodas();
                for (Postagem p : todasPostagens) {
                    if (p.getIdPostagem() == idPostagem) {
                        postagemParaEditar = p;
                        break;
                    }
                }
                
                if (postagemParaEditar == null) {
                    resposta.sendRedirect("postagens?erro=postagem_nao_encontrada");
                    return;
                }
                
                System.out.println("Editando postagem: " + postagemParaEditar.getTitulo());
                
            } catch (NumberFormatException e) {
                resposta.sendRedirect("postagens?erro=dados_invalidos");
                return;
            }
        }
        
        PrintWriter saida = resposta.getWriter();
        saida.append("<html>");
            saida.append("<head>");
                saida.append("<title>Studye - Feed de Postagens</title>");
                saida.append("<meta charset='UTF-8'/>");
                saida.append("<meta name='viewport' content='width=device-width, initial-scale=1'>");
                saida.append("<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css\" rel=\"stylesheet\">");
                saida.append("<link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css\">");
                saida.append("<style>");
                    saida.append("body { background-color: #1e1e2e; color: #ffffff; }");
                    saida.append(".form-control { background-color: rgba(255,255,255,0.1); color: #ffffff; border: none; }");
                    saida.append(".form-control:focus { background-color: rgba(255,255,255,0.15); color: #ffffff; }");
                    saida.append(".form-control::placeholder { color: rgba(255,255,255,0.7); }");
                    saida.append(".btn-primary { background-color: #6366f1; border: none; }");
                    saida.append(".card { background-color: #1a1b26 !important; border: none; }");
                    saida.append(".text-muted { color: rgba(255,255,255,0.8) !important; }");
                    saida.append(".post-card { margin-bottom: 20px; transition: transform 0.2s; border-radius: 10px; }");
                    saida.append(".post-card:hover { transform: translateY(-3px); }");
                    saida.append(".post-header { border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px; margin-bottom: 15px; }");
                    saida.append(".post-content { white-space: pre-line; color: #ffffff; }");
                    saida.append(".post-tag { display: inline-block; background-color: #2d2d3f; color: #a5b4fc; padding: 0.2rem 0.6rem; border-radius: 15px; font-size: 0.8rem; margin-right: 5px; margin-bottom: 5px; }");
                    saida.append(".post-tags { margin-top: 15px; }");
                    saida.append(".post-date { font-size: 0.85rem; color: #ffffff; }");
                    saida.append(".feed-container { max-width: 800px; margin: 0 auto; }");
                    saida.append(".post-form { position: sticky; top: 20px; }");
                    saida.append(".navbar { background-color: #1a1b26 !important; box-shadow: 0 2px 10px rgba(0,0,0,0.2); }");
                    saida.append(".navbar-brand { color: #6366f1 !important; font-weight: 600; }");
                    saida.append(".nav-link { color: #ffffff !important; }");
                    saida.append(".nav-link:hover, .nav-link:focus { color: #ffffff !important; }");
                    saida.append(".active > .nav-link, .nav-link.active { color: #6366f1 !important; }");
                    saida.append("h3, h4, h5, label { color: #ffffff !important; }");
                    saida.append("p { color: #ffffff !important; }");
                saida.append("</style>");
            saida.append("</head>");
            saida.append("<body>");
                // Barra de navegação
                saida.append("<nav class='navbar navbar-expand-lg navbar-dark mb-4'>");
                    saida.append("<div class='container'>");
                        saida.append("<a class='navbar-brand' href='#'>Studye</a>");
                        saida.append("<button class='navbar-toggler' type='button' data-bs-toggle='collapse' data-bs-target='#navbarNav'>");
                            saida.append("<span class='navbar-toggler-icon'></span>");
                        saida.append("</button>");
                        saida.append("<div class='collapse navbar-collapse' id='navbarNav'>");
                            saida.append("<ul class='navbar-nav ms-auto'>");
                                saida.append("<li class='nav-item'>");
                                    saida.append("<a class='nav-link active' href='postagens'>Feed</a>");
                                saida.append("</li>");
                                saida.append("<li class='nav-item'>");
                                    saida.append("<a class='nav-link' href='cadastro'>Cadastro</a>");
                                saida.append("</li>");
                                saida.append("<li class='nav-item'>");
                                    saida.append("<a class='nav-link' href='login'>Login</a>");
                                saida.append("</li>");
                            saida.append("</ul>");
                        saida.append("</div>");
                    saida.append("</div>");
                saida.append("</nav>");
                
                saida.append("<div class='container'>");
                    saida.append(mensagem); // Exibir mensagens de erro ou sucesso
                    
                    saida.append("<div class='row'>");
                        // Coluna para formulário de criação/edição de postagens
                        saida.append("<div class='col-md-4 mb-4'>");
                            saida.append("<div class='card p-3 post-form'>");
                                if (postagemParaEditar != null) {
                                    saida.append("<h4 class='mb-3'>Editar Postagem</h4>");
                                    saida.append("<form action='postagens' method='POST'>");
                                        saida.append("<input type='hidden' name='acao' value='editar'>");
                                        saida.append("<input type='hidden' name='idPostagem' value='" + postagemParaEditar.getIdPostagem() + "'>");
                                        saida.append("<div class='mb-3'>");
                                            saida.append("<label for='idUsuario' class='form-label'>ID do Usuário</label>");
                                            saida.append("<input type='number' class='form-control' id='idUsuario' name='idUsuario' value='" + postagemParaEditar.getIdUsuario() + "' readonly>");
                                        saida.append("</div>");
                                        saida.append("<div class='mb-3'>");
                                            saida.append("<label for='titulo' class='form-label'>Título</label>");
                                            saida.append("<input type='text' class='form-control' id='titulo' name='titulo' value='" + postagemParaEditar.getTitulo() + "' required>");
                                        saida.append("</div>");
                                        saida.append("<div class='mb-3'>");
                                            saida.append("<label for='conteudo' class='form-label'>Conteúdo</label>");
                                            saida.append("<textarea class='form-control' id='conteudo' name='conteudo' rows='5' required>" + postagemParaEditar.getConteudo() + "</textarea>");
                                        saida.append("</div>");
                                        saida.append("<div class='mb-3'>");
                                            saida.append("<label for='tags' class='form-label'>Tags (separadas por vírgula)</label>");
                                            // Converter a lista de tags para uma string separada por vírgulas
                                            String tagsString = postagemParaEditar.getTags() != null ? 
                                                String.join(", ", postagemParaEditar.getTags()) : "";
                                            saida.append("<input type='text' class='form-control' id='tags' name='tags' value='" + tagsString + "' placeholder='java, programação, estudo'>");
                                        saida.append("</div>");
                                        saida.append("<div class='d-flex gap-2'>");
                                            saida.append("<button type='submit' class='btn btn-primary flex-grow-1'>Atualizar</button>");
                                            saida.append("<a href='postagens' class='btn btn-secondary'>Cancelar</a>");
                                        saida.append("</div>");
                                    saida.append("</form>");
                                } else {
                                    saida.append("<h4 class='mb-3'>Nova Postagem</h4>");
                                    saida.append("<form action='postagens' method='POST'>");
                                        saida.append("<input type='hidden' name='acao' value='criar'>");
                                        saida.append("<div class='mb-3'>");
                                            saida.append("<label for='idUsuario' class='form-label'>Seu ID de Usuário</label>");
                                            saida.append("<input type='number' class='form-control' id='idUsuario' name='idUsuario' required>");
                                        saida.append("</div>");
                                        saida.append("<div class='mb-3'>");
                                            saida.append("<label for='titulo' class='form-label'>Título</label>");
                                            saida.append("<input type='text' class='form-control' id='titulo' name='titulo' placeholder='Título da sua postagem' required>");
                                        saida.append("</div>");
                                        saida.append("<div class='mb-3'>");
                                            saida.append("<label for='conteudo' class='form-label'>Conteúdo</label>");
                                            saida.append("<textarea class='form-control' id='conteudo' name='conteudo' rows='5' placeholder='Compartilhe seus pensamentos...' required></textarea>");
                                        saida.append("</div>");
                                        saida.append("<div class='mb-3'>");
                                            saida.append("<label for='tags' class='form-label'>Tags (separadas por vírgula)</label>");
                                            saida.append("<input type='text' class='form-control' id='tags' name='tags' placeholder='java, programação, estudo'>");
                                        saida.append("</div>");
                                        saida.append("<button type='submit' class='btn btn-primary w-100'>Publicar</button>");
                                    saida.append("</form>");
                                }
                            saida.append("</div>");
                        saida.append("</div>");
                        
                        // Coluna para feed de postagens
                        saida.append("<div class='col-md-8'>");
                            saida.append("<div class='feed-container'>");
                                saida.append("<h3 class='mb-4'>Feed de Postagens</h3>");
                                
                                // Buscar todas as postagens
                                PostagemDAO postagemDAO = new PostagemDAO();
                                List<Postagem> postagens = postagemDAO.buscarTodas();
                                UsuarioDAO usuarioDAO = new UsuarioDAO();
                                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                                
                                if (postagens.isEmpty()) {
                                    saida.append("<div class='card p-4 text-center'>");
                                        saida.append("<p>Nenhuma postagem encontrada. Seja o primeiro a postar!</p>");
                                    saida.append("</div>");
                                } else {
                                    for (Postagem postagem : postagens) {
                                        Usuario autor = usuarioDAO.buscarPorId(postagem.getIdUsuario());
                                        String nomeAutor = autor != null ? autor.getNome() : "Usuário #" + postagem.getIdUsuario();
                                        
                                        saida.append("<div class='card post-card p-4 mb-4'>");
                                            saida.append("<div class='post-header d-flex justify-content-between align-items-center'>");
                                                saida.append("<div>");
                                                    saida.append("<h5 class='mb-0'>" + postagem.getTitulo() + "</h5>");
                                                    saida.append("<div class='text-white'>Por " + nomeAutor + "</div>");
                                                saida.append("</div>");
                                                saida.append("<div class='d-flex align-items-center'>");
                                                    saida.append("<div class='post-date me-3'>" + postagem.getDataCriacao().format(formatter) + "</div>");
                                                    // Use um formulário para garantir que o parâmetro seja enviado corretamente
                                                    saida.append("<form method='GET' action='postagens' style='margin:0; display:inline;'>");
                                                        saida.append("<input type='hidden' name='edit' value='" + postagem.getIdPostagem() + "'>");
                                                        saida.append("<button type='submit' class='btn btn-sm btn-outline-light'><i class='bi bi-pencil'></i> Editar</button>");
                                                    saida.append("</form>");
                                                saida.append("</div>");
                                            saida.append("</div>");
                                            saida.append("<div class='post-content my-3'>");
                                                saida.append(postagem.getConteudo());
                                            saida.append("</div>");
                                            
                                            // Exibir tags
                                            if (postagem.getTags() != null && !postagem.getTags().isEmpty()) {
                                                saida.append("<div class='post-tags'>");
                                                for (String tag : postagem.getTags()) {
                                                    saida.append("<span class='post-tag'>#" + tag + "</span>");
                                                }
                                                saida.append("</div>");
                                            }
                                        saida.append("</div>");
                                    }
                                }
                            saida.append("</div>");
                        saida.append("</div>");
                    saida.append("</div>");
                saida.append("</div>");
                
                saida.append("<script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js\"></script>");
            saida.append("</body>");
        saida.append("</html>");
        
        // Adicione log no console para depuração
        System.out.println("Modo de edição: " + (postagemParaEditar != null ? "SIM" : "NÃO"));
    }
    
    @Override
    protected void doPost(HttpServletRequest requisicao, HttpServletResponse resposta) 
            throws ServletException, IOException {
        requisicao.setCharacterEncoding("UTF-8");
        
        try {
            String acao = requisicao.getParameter("acao");
            
            if ("editar".equals(acao)) {
                // Processar edição de postagem
                int idPostagem = Integer.parseInt(requisicao.getParameter("idPostagem"));
                int idUsuario = Integer.parseInt(requisicao.getParameter("idUsuario"));
                String titulo = requisicao.getParameter("titulo");
                String conteudo = requisicao.getParameter("conteudo");
                String tagsInput = requisicao.getParameter("tags");
                
                // Processar tags
                List<String> tags = new ArrayList<>();
                if (tagsInput != null && !tagsInput.isEmpty()) {
                    String[] tagsArray = tagsInput.split(",");
                    for (String tag : tagsArray) {
                        tag = tag.trim();
                        if (!tag.isEmpty()) {
                            tags.add(tag);
                        }
                    }
                }
                
                // Buscar a postagem existente usando o mesmo método de filtro
                PostagemDAO postagemDAO = new PostagemDAO();
                List<Postagem> todasPostagens = postagemDAO.buscarTodas();
                Postagem postagem = null;
                
                for (Postagem p : todasPostagens) {
                    if (p.getIdPostagem() == idPostagem) {
                        postagem = p;
                        break;
                    }
                }
                
                if (postagem != null) {
                    postagem.setTitulo(titulo);
                    postagem.setConteudo(conteudo);
                    postagem.setTags(tags);
                    
                    // Atualizar postagem
                    postagemDAO.atualizar(postagem);
                    
                    resposta.sendRedirect("postagens?sucesso=postagem_atualizada");
                } else {
                    resposta.sendRedirect("postagens?erro=postagem_nao_encontrada");
                }
            } else {
                // Processar criação de nova postagem
                // Obter parâmetros do formulário
                int idUsuario = Integer.parseInt(requisicao.getParameter("idUsuario"));
                String titulo = requisicao.getParameter("titulo");
                String conteudo = requisicao.getParameter("conteudo");
                String tagsInput = requisicao.getParameter("tags");
                
                // Processar tags (separadas por vírgula)
                List<String> tags = new ArrayList<>();
                if (tagsInput != null && !tagsInput.isEmpty()) {
                    String[] tagsArray = tagsInput.split(",");
                    for (String tag : tagsArray) {
                        tag = tag.trim();
                        if (!tag.isEmpty()) {
                            tags.add(tag);
                        }
                    }
                }
                
                // Criar objeto de postagem
                Postagem postagem = new Postagem();
                postagem.setIdUsuario(idUsuario);
                postagem.setTitulo(titulo);
                postagem.setConteudo(conteudo);
                postagem.setTags(tags);
                
                // Salvar postagem no banco de dados
                PostagemDAO postagemDAO = new PostagemDAO();
                postagemDAO.inserir(postagem);
                
                // Redirecionar para feed com mensagem de sucesso
                resposta.sendRedirect("postagens?sucesso=postagem_criada");
            }
        } catch (NumberFormatException e) {
            resposta.sendRedirect("postagens?erro=dados_invalidos");
        } catch (IllegalArgumentException e) {
            resposta.sendRedirect("postagens?erro=dados_invalidos");
        } catch (Exception e) {
            e.printStackTrace();
            resposta.sendRedirect("postagens?erro=conexao_bd");
        }
    }
}
