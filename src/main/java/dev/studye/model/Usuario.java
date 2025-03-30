package dev.studye.model;

import java.time.LocalDateTime;

public class Usuario {
    private Integer idUsuario;
    private String username;
    private String nome;
    private String email;
    private String senha;
    private LocalDateTime dataCriacao;
    private LocalDateTime dataAtualizacao;
    private String bio;

    public Usuario() {}

    public Usuario(String username, String nome, String email, String senha, String bio) {
        this.username = username;
        this.nome = nome;
        this.email = email;
        this.senha = senha;
        this.bio = bio;
    }

    public Integer getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Integer idUsuario) { this.idUsuario = idUsuario; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSenha() { return senha; }
    public void setSenha(String senha) { this.senha = senha; }

    public LocalDateTime getDataCriacao() { return dataCriacao; }
    public void setDataCriacao(LocalDateTime dataCriacao) { this.dataCriacao = dataCriacao; }

    public LocalDateTime getDataAtualizacao() { return dataAtualizacao; }
    public void setDataAtualizacao(LocalDateTime dataAtualizacao) { this.dataAtualizacao = dataAtualizacao; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
}