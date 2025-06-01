<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modelo.Grupo" %>
<%@ page import="modelo.Contato" %>
<%@ page import="modelo.dao.ContatoDAO" %>
<%@ page import="modelo.dao.GrupoDAO" %>

<% 
// Configurando a codificação para receber caracteres especiais
request.setCharacterEncoding("UTF-8");

try {
    // Recebendo parâmetros
    int codigo = Integer.valueOf(request.getParameter("codigo"));
    String nome = request.getParameter("nome");
    String telefone = request.getParameter("telefone");
    int codigoGrupo = Integer.valueOf(request.getParameter("grupo"));
    
    // Buscando o grupo pelo código
    GrupoDAO grupoDAO = new GrupoDAO();
    Grupo grupo = grupoDAO.pesquisarPorCodigo(codigoGrupo);
    
    // Montando objeto com os parametros
    Contato contato = new Contato();
    contato.setCodigo(codigo);
    contato.setNome(nome);
    contato.setTelefone(telefone);
    contato.setGrupo(grupo);
    
    // Utilizando o DAO para inserir o objeto no BD
    ContatoDAO contatoDAO = new ContatoDAO();
    contatoDAO.inserir(contato);
    
    // Redirecionando de volta para a página de contatos
    response.sendRedirect("contato.jsp?mensagem=sucesso");
} catch (Exception e) {
    // Em caso de erro, redireciona com mensagem de erro
    e.printStackTrace();
    response.sendRedirect("contato.jsp?mensagem=erro");
}
%>
