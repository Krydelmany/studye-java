package dev.studye.model.dao;

import dev.studye.model.Usuario;
import dev.studye.model.jdbc.ConnectionFactory;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    // INSERIR USUÁRIO (COM ID GERADO AUTOMATICAMENTE)
    public void inserir(Usuario usuario) {
        String sql = "INSERT INTO usuario (username, nome, email, senha, bio) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, usuario.getUsername());
            pstmt.setString(2, usuario.getNome());
            pstmt.setString(3, usuario.getEmail());
            pstmt.setString(4, usuario.getSenha());
            pstmt.setString(5, usuario.getBio());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        usuario.setIdUsuario(rs.getInt(1));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ATUALIZAR USUÁRIO (COM TRIGGER DE DATA_ATUALIZACAO)
    public void atualizar(Usuario usuario) {
        String sql = "UPDATE usuario SET username = ?, nome = ?, email = ?, senha = ?, bio = ? WHERE id_usuario = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, usuario.getUsername());
            pstmt.setString(2, usuario.getNome());
            pstmt.setString(3, usuario.getEmail());
            pstmt.setString(4, usuario.getSenha());
            pstmt.setString(5, usuario.getBio());
            pstmt.setInt(6, usuario.getIdUsuario());

            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // EXCLUIR USUÁRIO
    public void excluir(int idUsuario) {
        String sql = "DELETE FROM usuario WHERE id_usuario = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idUsuario);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // BUSCAR POR ID
    public Usuario buscarPorId(int idUsuario) {
        Usuario usuario = null;
        String sql = "SELECT * FROM usuario WHERE id_usuario = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idUsuario);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    usuario = mapearUsuario(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usuario;
    }

    // BUSCAR TODOS OS USUÁRIOS
    public List<Usuario> buscarTodos() {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT * FROM usuario";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                usuarios.add(mapearUsuario(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usuarios;
    }

    // BUSCAR POR USERNAME (ÚNICO)
    public Usuario buscarPorUsername(String username) {
        Usuario usuario = null;
        String sql = "SELECT * FROM usuario WHERE username = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    usuario = mapearUsuario(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usuario;
    }

    // MAPEAMENTO DO RESULTSET PARA OBJETO
    private Usuario mapearUsuario(ResultSet rs) throws SQLException {
        Usuario usuario = new Usuario();
        usuario.setIdUsuario(rs.getInt("id_usuario"));
        usuario.setUsername(rs.getString("username"));
        usuario.setNome(rs.getString("nome"));
        usuario.setEmail(rs.getString("email"));
        usuario.setSenha(rs.getString("senha"));
        usuario.setDataCriacao(rs.getTimestamp("data_criacao").toLocalDateTime());

        Timestamp dataAtualizacao = rs.getTimestamp("data_atualizacao");
        if (dataAtualizacao != null) {
            usuario.setDataAtualizacao(dataAtualizacao.toLocalDateTime());
        }

        usuario.setBio(rs.getString("bio"));
        return usuario;
    }
}