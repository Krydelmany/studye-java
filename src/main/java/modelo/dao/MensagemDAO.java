package modelo.dao;

import modelo.Mensagem;
import modelo.jdbc.ConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MensagemDAO {

    // --- INSERIR MENSAGEM ---
    public void inserir(Mensagem mensagem) {
        String sql = "INSERT INTO mensagem (remetente_id, destinatario_id, conteudo, data_envio, lida) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, mensagem.getRemetenteId());
            pstmt.setInt(2, mensagem.getDestinatarioId());
            pstmt.setString(3, mensagem.getConteudo());
            pstmt.setTimestamp(4, Timestamp.valueOf(mensagem.getDataEnvio()));
            pstmt.setBoolean(5, mensagem.getLida());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        mensagem.setIdMensagem(rs.getInt(1)); // Define o ID gerado
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // --- BUSCAR MENSAGEM POR ID ---
    public Mensagem buscarPorId(int idMensagem) {
        Mensagem mensagem = null;
        String sql = "SELECT * FROM mensagem WHERE id_mensagem = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idMensagem);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    mensagem = mapearMensagem(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return mensagem;
    }

    // --- BUSCAR MENSAGENS ENTRE DOIS USUÁRIOS ---
    public List<Mensagem> buscarConversa(int remetenteId, int destinatarioId) {
        List<Mensagem> mensagens = new ArrayList<>();
        String sql = "SELECT * FROM mensagem WHERE (remetente_id = ? AND destinatario_id = ?) OR (remetente_id = ? AND destinatario_id = ?) ORDER BY data_envio";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, remetenteId);
            pstmt.setInt(2, destinatarioId);
            pstmt.setInt(3, destinatarioId);
            pstmt.setInt(4, remetenteId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    mensagens.add(mapearMensagem(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return mensagens;
    }

    // --- MARCAR MENSAGEM COMO LIDA ---
    public void marcarComoLida(int idMensagem) {
        String sql = "UPDATE mensagem SET lida = true WHERE id_mensagem = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idMensagem);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // --- EXCLUIR MENSAGEM ---
    public void excluir(int idMensagem) {
        String sql = "DELETE FROM mensagem WHERE id_mensagem = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idMensagem);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // --- MAPEAR RESULT SET → OBJETO MENSAGEM ---
    private Mensagem mapearMensagem(ResultSet rs) throws SQLException {
        Mensagem mensagem = new Mensagem();
        mensagem.setIdMensagem(rs.getInt("id_mensagem"));
        mensagem.setRemetenteId(rs.getInt("remetente_id"));
        mensagem.setDestinatarioId(rs.getInt("destinatario_id"));
        mensagem.setConteudo(rs.getString("conteudo"));
        mensagem.setDataEnvio(rs.getTimestamp("data_envio").toLocalDateTime());
        mensagem.setLida(rs.getBoolean("lida"));
        return mensagem;
    }
}