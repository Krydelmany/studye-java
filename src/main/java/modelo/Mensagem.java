package modelo;

import java.time.LocalDateTime;

public class Mensagem {
    private Integer idMensagem;
    private Integer remetenteId;
    private Integer destinatarioId;
    private String conteudo;
    private LocalDateTime dataEnvio;
    private Boolean lida;

    // Getters e Setters
    public Integer getIdMensagem() { return idMensagem; }
    public void setIdMensagem(Integer idMensagem) { this.idMensagem = idMensagem; }

    public Integer getRemetenteId() { return remetenteId; }
    public void setRemetenteId(Integer remetenteId) { this.remetenteId = remetenteId; }

    public Integer getDestinatarioId() { return destinatarioId; }
    public void setDestinatarioId(Integer destinatarioId) { this.destinatarioId = destinatarioId; }

    public String getConteudo() { return conteudo; }
    public void setConteudo(String conteudo) { this.conteudo = conteudo; }

    public LocalDateTime getDataEnvio() { return dataEnvio; }
    public void setDataEnvio(LocalDateTime dataEnvio) { this.dataEnvio = dataEnvio; }

    public Boolean getLida() { return lida; }
    public void setLida(Boolean lida) { this.lida = lida; }
}