package modelo.dao;

import modelo.Postagem;
import modelo.jdbc.ConnectionFactory;
import modelo.Comentario;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class PostagemDAO {

    // --- INSERIR POSTAGEM ---
    public void inserir(Postagem postagem) {
        String sql = "INSERT INTO postagem (id_usuario, titulo, conteudo, tags) VALUES (?, ?, ?, ?::jsonb)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, postagem.getIdUsuario());
            pstmt.setString(2, postagem.getTitulo());
            pstmt.setString(3, postagem.getConteudo());
            pstmt.setString(4, listToJson(postagem.getTags()));

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Falha ao inserir postagem.");
            }

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    postagem.setIdPostagem(rs.getInt(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro no banco de dados: " + e.getMessage(), e);
        }
    }

    // --- BUSCAR POSTAGENS POR TAG ---
    public List<Postagem> buscarPorTag(String tag) {
        List<Postagem> postagens = new ArrayList<>();
        String sql = "SELECT * FROM postagem WHERE tags ? ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, tag);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    postagens.add(mapearPostagem(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return postagens;
    }

    // --- BUSCAR TODAS AS POSTAGENS (SEM PAGINAÇÃO) ---
    public List<Postagem> buscarTodas() {
        List<Postagem> postagens = new ArrayList<>();
        String sql = "SELECT * FROM postagem ORDER BY data_criacao DESC";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                postagens.add(mapearPostagem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return postagens;
    }

    // --- BUSCAR TODAS AS POSTAGENS ---
    public List<Postagem> buscarTodas(int limite, int offset) {
        List<Postagem> postagens = new ArrayList<>();
        String sql = "SELECT * FROM postagem ORDER BY data_criacao DESC LIMIT ? OFFSET ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, limite);
            pstmt.setInt(2, offset);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    postagens.add(mapearPostagem(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return postagens;
    }

    // --- BUSCAR POR ID ---
    public Postagem buscarPorId(int idPostagem) {
        String sql = "SELECT * FROM postagem WHERE id_postagem = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idPostagem);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapearPostagem(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // --- MAPEAR POSTAGEM ---
    private Postagem mapearPostagem(ResultSet rs) throws SQLException {
        Postagem post = new Postagem();
        post.setIdPostagem(rs.getInt("id_postagem"));
        post.setIdUsuario(rs.getInt("id_usuario"));
        post.setTitulo(rs.getString("titulo"));
        post.setConteudo(rs.getString("conteudo"));
        post.setDataCriacao(rs.getTimestamp("data_criacao").toLocalDateTime());

        // Converter JSON para List<String> (manual)
        String tagsJson = rs.getString("tags");
        post.setTags(jsonToList(tagsJson));

        return post;
    }

    // --- CONVERSÃO MANUAL: List<String> → JSON ---
    private String listToJson(List<String> tags) {
        if (tags == null || tags.isEmpty()) return "[]";

        return tags.stream()
                .map(tag -> tag
                        .replace("\\", "\\\\") // Escapa barras
                        .replace("\"", "\\\"") // Escapa aspas
                        .replace("\n", "\\n")
                )
                .map(tag -> "\"" + tag + "\"")
                .collect(Collectors.joining(",", "[", "]"));
    }

    // --- CONVERSÃO SEGURA DE JSON → LIST ---
    private List<String> jsonToList(String json) {
        if (json == null || json.isEmpty()) return new ArrayList<>();

        try {
            // Usar expressão regular para extrair tags entre aspas
            Pattern pattern = Pattern.compile("\"([^\"]*)\"");
            Matcher matcher = pattern.matcher(json);
            List<String> tags = new ArrayList<>();

            while (matcher.find()) {
                tags.add(matcher.group(1));
            }
            return tags;
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    // --- ATUALIZAR POSTAGEM ---
    public void atualizar(Postagem postagem) {
        String sql = "UPDATE postagem SET titulo = ?, conteudo = ?, tags = ?::jsonb WHERE id_postagem = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, postagem.getTitulo());
            pstmt.setString(2, postagem.getConteudo());
            pstmt.setString(3, listToJson(postagem.getTags()));
            pstmt.setInt(4, postagem.getIdPostagem());

            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // --- EXCLUIR POSTAGEM ---
    public void excluir(int idPostagem) {
        String sql = "DELETE FROM postagem WHERE id_postagem = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idPostagem);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // --- BUSCAR POSTAGENS POR USUÁRIO ---
    public List<Postagem> buscarPorUsuario(int idUsuario) {
        List<Postagem> postagens = new ArrayList<>();
        String sql = "SELECT * FROM postagem WHERE id_usuario = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idUsuario);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    postagens.add(mapearPostagem(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return postagens;
    }

    // --- LISTAR TODAS AS POSTAGENS ---
    public List<Postagem> listarTodos() {
        List<Postagem> postagens = new ArrayList<>();
        String sql = "SELECT * FROM postagem ORDER BY data_criacao DESC";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                postagens.add(mapearPostagem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return postagens;
    }

    // --- BUSCAR COMENTÁRIOS POR POSTAGEM ---
    public List<Comentario> buscarComentariosPorPostagem(int idPostagem) {
        List<Comentario> comentarios = new ArrayList<>();
        String sql = "SELECT c.*, u.nome FROM comentario c " +
                     "INNER JOIN usuario u ON c.id_usuario = u.id_usuario " +
                     "WHERE c.id_postagem = ? ORDER BY c.data_criacao ASC";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idPostagem);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Comentario comentario = new Comentario();
                    comentario.setIdComentario(rs.getInt("id_comentario"));
                    comentario.setIdPostagem(rs.getInt("id_postagem"));
                    comentario.setIdUsuario(rs.getInt("id_usuario"));
                    comentario.setConteudo(rs.getString("conteudo"));
                    comentario.setDataCriacao(rs.getTimestamp("data_criacao").toLocalDateTime());
                    comentario.setNomeUsuario(rs.getString("nome"));
                    comentarios.add(comentario);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comentarios;
    }
}