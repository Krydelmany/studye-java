<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="modelo.Contato" %>
<%@ page import="modelo.Grupo" %>
<%@ page import="modelo.dao.ContatoDAO" %>
<%@ page import="modelo.dao.GrupoDAO" %>

<!DOCTYPE html>
<html>
<head>
    <title>AgendaServlet - Contatos</title>
    <meta charset="UTF-8"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-SgOJa3DmI69IUzQ2PVdRZhwQ+dy64/BUtbMJw1MZ8t5HZApcHrRKUc4W0kG879m7" crossorigin="anonymous">
</head>
<body class="container">
    <h1>Cadastro de Usuario</h1>
    
    <% 
    // Verifica se há mensagens
    String mensagem = request.getParameter("mensagem");
    if (mensagem != null) {
        if (mensagem.equals("sucesso")) {
            out.println("<div class='alert alert-success'>Contato salvo com sucesso!</div>");
        } else if (mensagem.equals("erro")) {
            out.println("<div class='alert alert-danger'>Erro ao salvar o contato. Tente novamente.</div>");
        }
    }
    %>
    
    <form action="processar-contato.jsp" method="POST">
        <fieldset>
            <label for="codigo" class="form-label">Código</label>
            <input type="number" id="codigo" name="codigo" required class="form-control" />
        </fieldset>
        <fieldset>
            <label for="nome" class="form-label">Nome</label>
            <input type="text" id="nome" name="nome" required class="form-control" />
        </fieldset>
        <fieldset>
            <label for="telefone" class="form-label">Telefone</label>
            <input type="phone" id="telefone" name="telefone" required class="form-control" />
        </fieldset>
        <fieldset>
            <label for="grupo" class="form-label">Grupo</label>
            <select id="grupo" name="grupo" required class="form-control">
                <% 
                GrupoDAO grupoDAO = new GrupoDAO();
                ArrayList<Grupo> grupos = grupoDAO.pesquisarTodos();
                for(Grupo grupo : grupos) {
                %>
                    <option value="<%=grupo.getCodigo()%>">
                        <%=grupo.getCodigo() + " - " + grupo.getNome()%>
                    </option>
                <% } %>
            </select>
        </fieldset>
        <br/>
        <button type="submit" class="btn btn-primary">Salvar</button>
        &nbsp;
        <button type="reset" class="btn btn-secondary">Limpar</button>
    </form>
    
    <hr/>
    <h2>Listagem de Contatos</h2>
    <table class="table table-striped table-hover">
        <thead>
            <tr>
                <th>Código</th>
                <th>Nome</th>
                <th>Telefone</th>
                <th>Grupo</th>
            </tr>
        </thead>
        <tbody>
            <% 
            ContatoDAO contatoDAO = new ContatoDAO();
            ArrayList<Contato> contatos = contatoDAO.pesquisarTodos();
            for(Contato contato : contatos) {
            %>
                <tr>
                    <td><%=contato.getCodigo()%></td>
                    <td><%=contato.getNome()%></td>
                    <td><%=contato.getTelefone()%></td>
                    <td><%=contato.getGrupo().getNome()%></td>
                </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
