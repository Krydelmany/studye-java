package modelo;

import java.time.LocalDateTime;

public class Comentario {
    private Integer idComentario;
    private Integer idPostagem;
    private Integer idUsuario;
    private String conteudo;
    private LocalDateTime dataCriacao;
    private String nomeUsuario; // Para exibição

    public Comentario() {}

    public Comentario(Integer idPostagem, Integer idUsuario, String conteudo) {
        this.idPostagem = idPostagem;
        this.idUsuario = idUsuario;
        this.conteudo = conteudo;
    }

    // Getters e Setters
    public Integer getIdComentario() { return idComentario; }
    public void setIdComentario(Integer idComentario) { this.idComentario = idComentario; }

    public Integer getIdPostagem() { return idPostagem; }
    public void setIdPostagem(Integer idPostagem) { this.idPostagem = idPostagem; }

    public Integer getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Integer idUsuario) { this.idUsuario = idUsuario; }

    public String getConteudo() { return conteudo; }
    public void setConteudo(String conteudo) { this.conteudo = conteudo; }

    public LocalDateTime getDataCriacao() { return dataCriacao; }
    public void setDataCriacao(LocalDateTime dataCriacao) { this.dataCriacao = dataCriacao; }

    public String getNomeUsuario() { return nomeUsuario; }
    public void setNomeUsuario(String nomeUsuario) { this.nomeUsuario = nomeUsuario; }
}