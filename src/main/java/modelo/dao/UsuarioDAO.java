package modelo.dao;

import modelo.Usuario;
import modelo.jdbc.ConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    // Método de compatibilidade para a assinatura antiga (void)
    public void inserir(Usuario usuario) {
        // Chama o novo método boolean e ignora o retorno
        this.inserirComRetorno(usuario);
    }

    // INSERIR USUÁRIO (COM ID GERADO AUTOMATICAMENTE)
    public boolean inserirComRetorno(Usuario usuario) {
        String sql = "INSERT INTO usuario (username, nome, email, senha, bio) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        
        try {
            conn = ConnectionFactory.getConnection();
            if (conn == null) {
                System.err.println("ERRO: Não foi possível obter conexão com o banco de dados.");
                return false;
            }
            
            try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
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
                return true;
            }
        } catch (SQLException e) {
            System.err.println("ERRO SQL ao inserir usuário: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
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
    }    // MAPEAMENTO DO RESULTSET PARA OBJETO
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
    
    // AUTENTICAÇÃO DE USUÁRIOS
    public Usuario autenticar(String username, String senha) {
        String sql = "SELECT * FROM usuario WHERE username = ? AND senha = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, senha);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapearUsuario(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // VERIFICAR SE USERNAME JÁ EXISTE
    public boolean usernameExiste(String username) {
        String sql = "SELECT COUNT(*) FROM usuario WHERE username = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // VERIFICAR SE EMAIL JÁ EXISTE
    public boolean emailExiste(String email) {
        String sql = "SELECT COUNT(*) FROM usuario WHERE email = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}