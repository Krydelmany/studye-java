package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Grupo;
import modelo.dao.GrupoDAO;

@WebServlet("/grupo")
public class GrupoServlet extends HttpServlet {
	// gera o formulário
	public void doGet(HttpServletRequest requisicao,
						HttpServletResponse resposta)
									throws IOException {
		resposta.setCharacterEncoding("UTF-8");
		
		PrintWriter saida = resposta.getWriter();
		saida.append("<html>");
			saida.append("<head>");
				saida.append("<title> AgendaServet - Grupos</title>");
				saida.append("<meta charset='UTF-8'/>");
				saida.append("<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css\" rel=\"stylesheet\" integrity=\"sha384-SgOJa3DmI69IUzQ2PVdRZhwQ+dy64/BUtbMJw1MZ8t5HZApcHrRKUc4W0kG879m7\" crossorigin=\"anonymous\">");
			saida.append("</head>");
			saida.append("<body class='container'>");
				saida.append("<h1>Cadastro de Grupo</h1>");
				saida.append("<form action='grupo' method='POST'>");
					saida.append("<fieldset>");
						saida.append("<label for='codigo' class='form-label'>Código</label>");
						saida.append("<input type='number' id='codigo' name='codigo' required class='form-control' />");
					saida.append("</fieldset>");
					saida.append("<fieldset>");
						saida.append("<label for='nome' class='form-label'>Nome</label>");
						saida.append("<input type='text' id='nome' name='nome' required class='form-control' />");
					saida.append("</fieldset>");
						saida.append("<fieldset>");
						saida.append("<label for='descricao' class='form-label'>Descrição</label>");
						saida.append("<input type='text' id='descricao' name='descricao' required class='form-control' />");
					saida.append("</fieldset>");
					saida.append("<br/>");
					saida.append("<button type='submit' class='btn btn-primary'>Salvar</button>");
					saida.append("&nbsp;");
					saida.append("<button type='reset' class='btn btn-secondary'>Limpar</button>");
				saida.append("</form>");
				saida.append("<hr/>");
				saida.append("<h2>Listagem de Grupos</h2>");
				saida.append("<table class='table table-striped table-hover'>");
					saida.append("<thead>");
						saida.append("<th>Código</th>");
						saida.append("<th>Nome</th>");
						saida.append("<th>Descrição</th>");
					saida.append("</thead>");
					saida.append("<tbody>");
						GrupoDAO grupoDAO = new GrupoDAO();
						ArrayList<Grupo> grupos = grupoDAO.pesquisarTodos();
						for(Grupo grupo : grupos) {
							saida.append("<tr>");
								saida.append("<td>" + grupo.getCodigo() + "</td>");
								saida.append("<td>" + grupo.getNome() + "</td>");
								saida.append("<td>" + grupo.getDescricao() + "</td>");
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
