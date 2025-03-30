package dev.studye.model;

import java.time.LocalDateTime;

public class Amizade {
    private Integer idAmizade;
    private Integer usuario1Id;
    private Integer usuario2Id;
    private StatusAmizade status;
    private LocalDateTime dataSolicitacao;
    private LocalDateTime dataAceitacao;

    // Getters e Setters
    public Integer getIdAmizade() { return idAmizade; }
    public void setIdAmizade(Integer idAmizade) { this.idAmizade = idAmizade; }

    public Integer getUsuario1Id() { return usuario1Id; }
    public void setUsuario1Id(Integer usuario1Id) { this.usuario1Id = usuario1Id; }

    public Integer getUsuario2Id() { return usuario2Id; }
    public void setUsuario2Id(Integer usuario2Id) { this.usuario2Id = usuario2Id; }

    public StatusAmizade getStatus() { return status; }
    public void setStatus(StatusAmizade status) { this.status = status; }

    public LocalDateTime getDataSolicitacao() { return dataSolicitacao; }
    public void setDataSolicitacao(LocalDateTime dataSolicitacao) { this.dataSolicitacao = dataSolicitacao; }

    public LocalDateTime getDataAceitacao() { return dataAceitacao; }
    public void setDataAceitacao(LocalDateTime dataAceitacao) { this.dataAceitacao = dataAceitacao; }
}