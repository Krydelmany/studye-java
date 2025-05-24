package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Contato;
import modelo.Grupo;
import modelo.dao.ContatoDAO;
import modelo.dao.GrupoDAO;

@WebServlet("/usuario")
public class ContatoServlet extends HttpServlet {
	// gera o formulário
	public void doGet(HttpServletRequest requisicao,
						HttpServletResponse resposta)
									throws IOException {
		resposta.setCharacterEncoding("UTF-8");
		
		PrintWriter saida = resposta.getWriter();
		saida.append("<html>");
			saida.append("<head>");
				saida.append("<title> AgendaServet - Contatos</title>");
				saida.append("<meta charset='UTF-8'/>");
				saida.append("<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css\" rel=\"stylesheet\" integrity=\"sha384-SgOJa3DmI69IUzQ2PVdRZhwQ+dy64/BUtbMJw1MZ8t5HZApcHrRKUc4W0kG879m7\" crossorigin=\"anonymous\">");
			saida.append("</head>");
			saida.append("<body class='container'>");
				saida.append("<h1>Cadastro de Usuario</h1>");
				saida.append("<form action='contato' method='POST'>");
					saida.append("<fieldset>");
						saida.append("<label for='codigo' class='form-label'>Código</label>");
						saida.append("<input type='number' id='codigo' name='codigo' required class='form-control' />");
					saida.append("</fieldset>");
					saida.append("<fieldset>");
						saida.append("<label for='nome' class='form-label'>Nome</label>");
						saida.append("<input type='text' id='nome' name='nome' required class='form-control' />");
					saida.append("</fieldset>");
						saida.append("<fieldset>");
						saida.append("<label for='telefone' class='form-label'>Telefone</label>");
						saida.append("<input type='phone' id='telefone' name='telefone' required class='form-control' />");
					saida.append("</fieldset>");
					saida.append("<fieldset>");
						saida.append("<label for='grupo' class='form-label'>Grupo</label>");
						saida.append("<select id='grupo' name='grupo' required class='form-control'>");
							GrupoDAO grupoDAO = new GrupoDAO();
							ArrayList<Grupo> grupos = grupoDAO.pesquisarTodos();
							for(Grupo grupo : grupos) {
								saida.append("<option value='" + grupo.getCodigo() +"'>");
									saida.append(grupo.getCodigo() + " - " + grupo.getNome());
								saida.append("</option>");
							}
						saida.append("</select>");
					saida.append("</fieldset>");
					saida.append("<br/>");
					saida.append("<button type='submit' class='btn btn-primary'>Salvar</button>");
					saida.append("&nbsp;");
					saida.append("<button type='reset' class='btn btn-secondary'>Limpar</button>");
				saida.append("</form>");
				saida.append("<hr/>");
				saida.append("<h2>Listagem de Contatos</h2>");
				saida.append("<table class='table table-striped table-hover'>");
					saida.append("<thead>");
						saida.append("<th>Código</th>");
						saida.append("<th>Nome</th>");
						saida.append("<th>Telefone</th>");
						saida.append("<th>Grupo</th>");
					saida.append("</thead>");
					saida.append("<tbody>");
						ContatoDAO contatoDAO = new ContatoDAO();
						ArrayList<Contato> contatos = contatoDAO.pesquisarTodos();
						//System.out.println("Qtd = " + contatos.size());
						for(Contato contato : contatos) {
							saida.append("<tr>");
								saida.append("<td>" + contato.getCodigo() + "</td>");
								saida.append("<td>" + contato.getNome() + "</td>");
								saida.append("<td>" + contato.getTelefone() + "</td>");
								saida.append("<td>" + contato.getGrupo().getNome() + "</td>");
							saida.append("</tr>");
						}
					saida.append("</tbody>");
				saida.append("</table>");
			saida.append("</body>");
		saida.append("</html>");
	}
	
	// recebe os dados do formulário e insere no BD
	public void doPost(HttpServletRequest requisicao,
						HttpServletResponse resposta)
									throws IOException {
		// recebendo parametros
		int codigo = Integer.valueOf(requisicao.getParameter("codigo"));
		String nome = requisicao.getParameter("nome");
		String descricao = requisicao.getParameter("descricao");
		
		// montando objeto com os parametros
		Grupo grupo = new Grupo();
		grupo.setCodigo(codigo);
		grupo.setNome(nome);
		grupo.setDescricao(descricao);
		
		// utilizando o DAO para inserir o objeto no BD
		GrupoDAO grupoDAO = new GrupoDAO();
		grupoDAO.inserir(grupo);
		
		// atualiza a página
		doGet(requisicao, resposta);
}
}
