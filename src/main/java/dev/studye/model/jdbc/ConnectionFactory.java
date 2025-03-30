package dev.studye.model.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {
    public static Connection getConnection() {
        String stringJDBC = "jdbc:postgresql://localhost:5432/studye?currentSchema=public";
        String usuario = "regulatorio";
        String senha = "regulatorio";

        Connection conexao = null;

        try {
            conexao = DriverManager.getConnection(stringJDBC, usuario, senha);
            System.out.println("Conexão com PostgreSQL estabelecida com sucesso!");
        } catch (SQLException e) {
            System.err.println("Erro ao conectar ao PostgreSQL: " + e.getMessage());
            e.printStackTrace();
        }

        return conexao;
    }
}