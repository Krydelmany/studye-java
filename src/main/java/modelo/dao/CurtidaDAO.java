package modelo.dao;

import modelo.Curtida;
import modelo.jdbc.ConnectionFactory;

import java.sql.*;

public class CurtidaDAO {

    // CURTIR UM POST
    public void curtir(Curtida curtida) {
        String sql = "INSERT INTO curtida (id_postagem, id_usuario) VALUES (?, ?)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, curtida.getIdPostagem());
            pstmt.setInt(2, curtida.getIdUsuario());
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            // Se for erro de violação de constraint única, não lançar exceção
            if (e.getSQLState() != null && e.getSQLState().equals("23505")) {
                return;
            }
            throw new RuntimeException("Erro ao curtir postagem: " + e.getMessage(), e);
        }
    }

    // DESCURTIR UM POST
    public void descurtir(int idPostagem, int idUsuario) {
        String sql = "DELETE FROM curtida WHERE id_postagem = ? AND id_usuario = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idPostagem);
            pstmt.setInt(2, idUsuario);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao descurtir postagem: " + e.getMessage(), e);
        }
    }

    // CONTAR CURTIDAS DE UM POST
    public int contarCurtidas(int idPostagem) {
        String sql = "SELECT COUNT(*) FROM curtida WHERE id_postagem = ?";
        int count = 0;

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idPostagem);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    // VERIFICAR SE USUÁRIO JÁ CURTIU
    public boolean usuarioJaCurtiu(int idPostagem, int idUsuario) {
        String sql = "SELECT 1 FROM curtida WHERE id_postagem = ? AND id_usuario = ?";
        boolean curtiu = false;

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idPostagem);
            pstmt.setInt(2, idUsuario);
            try (ResultSet rs = pstmt.executeQuery()) {
                curtiu = rs.next();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return curtiu;
    }
}
