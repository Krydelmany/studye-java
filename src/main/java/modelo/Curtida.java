package modelo;

import java.time.LocalDateTime;

public class Curtida {
    private Integer idCurtida;
    private Integer idPostagem;
    private Integer idUsuario;
    private LocalDateTime dataCurtida;

    public Curtida() {}

    public Curtida(Integer idPostagem, Integer idUsuario) {
        this.idPostagem = idPostagem;
        this.idUsuario = idUsuario;
    }

    // Getters e Setters
    public Integer getIdCurtida() { return idCurtida; }
    public void setIdCurtida(Integer idCurtida) { this.idCurtida = idCurtida; }

    public Integer getIdPostagem() { return idPostagem; }
    public void setIdPostagem(Integer idPostagem) { this.idPostagem = idPostagem; }

    public Integer getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Integer idUsuario) { this.idUsuario = idUsuario; }

    public LocalDateTime getDataCurtida() { return dataCurtida; }
    public void setDataCurtida(LocalDateTime dataCurtida) { this.dataCurtida = dataCurtida; }
}
