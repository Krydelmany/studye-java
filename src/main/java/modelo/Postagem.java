package modelo;

import java.time.LocalDateTime;
import java.util.List;

public class Postagem {
    private Integer idPostagem;
    private Integer idUsuario;
    private String titulo;
    private String conteudo;
    private List<String> tags;
    private LocalDateTime dataCriacao;

    public Postagem() {}

    public Postagem(Integer idUsuario, String titulo, String conteudo) {
        this.idUsuario = idUsuario;
        this.setTitulo(titulo); // Usa setter para validação
        this.setConteudo(conteudo);
    }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) {
        if (titulo == null || titulo.trim().isEmpty()) {
            throw new IllegalArgumentException("Título não pode ser vazio");
        }
        this.titulo = titulo;
    }

    public String getConteudo() { return conteudo; }
    public void setConteudo(String conteudo) {
        if (conteudo == null || conteudo.trim().isEmpty()) {
            throw new IllegalArgumentException("Conteúdo não pode ser vazio");
        }
        this.conteudo = conteudo;
    }

    public Integer getIdPostagem() { return idPostagem; }
    public void setIdPostagem(Integer idPostagem) { this.idPostagem = idPostagem; }

    public Integer getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Integer idUsuario) { this.idUsuario = idUsuario; }

    public List<String> getTags() { return tags; }
    public void setTags(List<String> tags) { this.tags = tags; }

    public LocalDateTime getDataCriacao() { return dataCriacao; }
    public void setDataCriacao(LocalDateTime dataCriacao) { this.dataCriacao = dataCriacao; }


}

