package dev.studye.model.dao;

import dev.studye.model.Comentario;
import dev.studye.model.jdbc.ConnectionFactory;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ComentarioDAO {

    // INSERIR COMENTÁRIO
    public void inserir(Comentario comentario) {
        String sql = "INSERT INTO comentario (id_postagem, id_usuario, conteudo) VALUES (?, ?, ?)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, comentario.getIdPostagem());
            pstmt.setInt(2, comentario.getIdUsuario());
            pstmt.setString(3, comentario.getConteudo());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        comentario.setIdComentario(rs.getInt(1));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ATUALIZAR COMENTÁRIO
    public void atualizar(Comentario comentario) {
        String sql = "UPDATE comentario SET conteudo = ? WHERE id_comentario = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, comentario.getConteudo());
            pstmt.setInt(2, comentario.getIdComentario());

            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // EXCLUIR COMENTÁRIO
    public void excluir(int idComentario) {
        String sql = "DELETE FROM comentario WHERE id_comentario = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idComentario);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // BUSCAR POR ID
    public Comentario buscarPorId(int idComentario) {
        Comentario comentario = null;
        String sql = "SELECT * FROM comentario WHERE id_comentario = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idComentario);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    comentario = mapearComentario(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comentario;
    }

    // BUSCAR TODOS OS COMENTÁRIOS DE UMA POSTAGEM
    public List<Comentario> buscarPorPostagem(int idPostagem) {
        List<Comentario> comentarios = new ArrayList<>();
        String sql = "SELECT * FROM comentario WHERE id_postagem = ? ORDER BY data_criacao DESC";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idPostagem);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    comentarios.add(mapearComentario(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comentarios;
    }

    // MAPEAR RESULT SET → OBJETO COMENTARIO
    private Comentario mapearComentario(ResultSet rs) throws SQLException {
        Comentario comentario = new Comentario();
        comentario.setIdComentario(rs.getInt("id_comentario"));
        comentario.setIdPostagem(rs.getInt("id_postagem"));
        comentario.setIdUsuario(rs.getInt("id_usuario"));
        comentario.setConteudo(rs.getString("conteudo"));
        comentario.setDataCriacao(rs.getTimestamp("data_criacao").toLocalDateTime());
        return comentario;
    }
}