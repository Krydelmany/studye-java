package dev.studye;

import dev.studye.model.*;
import dev.studye.model.dao.*;

import java.time.LocalDateTime;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        MensagemDAO mensagemDAO = new MensagemDAO();

        // Criar uma nova mensagem
        Mensagem novaMensagem = new Mensagem();
        novaMensagem.setRemetenteId(10); // ID (João)
        novaMensagem.setDestinatarioId(11); // ID (Maria)
        novaMensagem.setConteudo("Olá Maria, como você está?");
        novaMensagem.setDataEnvio(LocalDateTime.now());
        novaMensagem.setLida(false);

        // Inserir a mensagem no banco de dados
        mensagemDAO.inserir(novaMensagem);
        System.out.println("Mensagem enviada com ID: " + novaMensagem.getIdMensagem());

        // Buscar mensagens entre João e Maria
        List<Mensagem> conversa = mensagemDAO.buscarConversa(10, 11);
        System.out.println("\nConversa entre João e Maria:");
        conversa.forEach(m -> System.out.println(
                "De: " + m.getRemetenteId() +
                        ", Para: " + m.getDestinatarioId() +
                        ", Mensagem: " + m.getConteudo()
        ));

        // Marcar a mensagem como lida
        mensagemDAO.marcarComoLida(novaMensagem.getIdMensagem());
        System.out.println("\nMensagem marcada como lida.");
    }
}