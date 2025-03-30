package dev.studye.model.dao;

import dev.studye.model.Amizade;
import dev.studye.model.StatusAmizade;
import dev.studye.model.jdbc.ConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AmizadeDAO {
    // INSERT - Cria nova solicitação de amizade
    public void inserir(Amizade amizade) {
        String sql = "INSERT INTO amizade (usuario1_id, usuario2_id, status) VALUES (?, ?, ?::status_amizade)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // Garante ordem correta dos IDs
            int usuario1Id = Math.min(amizade.getUsuario1Id(), amizade.getUsuario2Id());
            int usuario2Id = Math.max(amizade.getUsuario1Id(), amizade.getUsuario2Id());

            pstmt.setInt(1, usuario1Id);
            pstmt.setInt(2, usuario2Id);
            pstmt.setString(3, StatusAmizade.PENDENTE.name().toLowerCase());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Falha ao inserir amizade.");
            }

            // Recupera o ID gerado
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    amizade.setIdAmizade(rs.getInt(1));
                } else {
                    throw new SQLException("Nenhum ID gerado.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // UPDATE - Atualiza status e data de aceitação
    public void atualizarStatus(int idAmizade, StatusAmizade novoStatus) {
        String sql = "UPDATE amizade SET status = ?::status_amizade, data_aceitacao = ? WHERE id_amizade = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {


            pstmt.setString(1, novoStatus.name().toLowerCase());
            pstmt.setTimestamp(2, novoStatus == StatusAmizade.ACEITO ? new Timestamp(System.currentTimeMillis()) : null);
            pstmt.setInt(3, idAmizade);

            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // DELETE - Remove amizade
    public void excluir(int idAmizade) {
        String sql = "DELETE FROM amizade WHERE id_amizade = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idAmizade);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // SELECT - Busca por ID
    public Amizade buscarPorId(int idAmizade) {
        String sql = "SELECT * FROM amizade WHERE id_amizade = ?";
        Amizade amizade = null;

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idAmizade);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                amizade = mapearAmizade(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return amizade;
    }

    // SELECT - Lista todas as amizades
    public List<Amizade> buscarTodos() {
        List<Amizade> amizades = new ArrayList<>();
        String sql = "SELECT * FROM amizade";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                amizades.add(mapearAmizade(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return amizades;
    }

    // SELECT - Amizades pendentes para um usuário
    public List<Amizade> buscarPendentes(int usuarioId) {
        List<Amizade> pendentes = new ArrayList<>();
        String sql = "SELECT * FROM amizade WHERE (usuario1_id = ? OR usuario2_id = ?) AND status = 'pendente'";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, usuarioId);
            pstmt.setInt(2, usuarioId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                pendentes.add(mapearAmizade(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pendentes;
    }

    // SELECT - Verifica se já existe relação entre dois usuários
    public boolean existeAmizade(int usuario1Id, int usuario2Id) {
        String sql = "SELECT 1 FROM amizade WHERE (usuario1_id = ? AND usuario2_id = ?) OR (usuario1_id = ? AND usuario2_id = ?)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            int menorId = Math.min(usuario1Id, usuario2Id);
            int maiorId = Math.max(usuario1Id, usuario2Id);

            pstmt.setInt(1, menorId);
            pstmt.setInt(2, maiorId);
            pstmt.setInt(3, maiorId);
            pstmt.setInt(4, menorId);

            return pstmt.executeQuery().next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Método auxiliar para mapear ResultSet → Amizade
    private Amizade mapearAmizade(ResultSet rs) throws SQLException {
        Amizade amizade = new Amizade();
        amizade.setIdAmizade(rs.getInt("id_amizade"));
        amizade.setUsuario1Id(rs.getInt("usuario1_id"));
        amizade.setUsuario2Id(rs.getInt("usuario2_id"));
        amizade.setStatus(StatusAmizade.valueOf(rs.getString("status").toUpperCase()));
        amizade.setDataSolicitacao(rs.getTimestamp("data_solicitacao").toLocalDateTime());

        Timestamp dataAceitacao = rs.getTimestamp("data_aceitacao");
        if (dataAceitacao != null) {
            amizade.setDataAceitacao(dataAceitacao.toLocalDateTime());
        }
        return amizade;
    }
}