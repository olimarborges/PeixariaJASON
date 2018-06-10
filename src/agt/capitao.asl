{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }

/* application domain goals */

!iniciarNavegacao.

+!iniciarNavegacao
	: .my_name(NomeAgent) & identificador(IdBarco)
	<-	
	.concat("barco_0", IdBarco, NomeBarco);
	.print("Nome do Barco - Capitao: ", NomeBarco);
	lookupArtifact(NomeBarco, ArtId);	
	focus(ArtId);
	incrementaTripulacao(IdBarco, NomeAgent);
	.print("Eu sou o: ", NomeAgent, " do: ", NomeBarco);
	+meuBarcoEh(NomeBarco, IdBarco);
	.wait(100);
	!verificarPeixesOceano;
.

+!verificarPeixesOceano 
	: qtPeixesDisponivel(QuantPeixesDisp) & QuantPeixesDisp > 0 
	& qtTripulacao(QuantTripbarco) & QuantTripbarco < 3
	<-
	!montarTripulacao;
.

+!verificarPeixesOceano 
	: qtPeixesDisponivel(QuantPeixesDisp) & QuantPeixesDisp > 0 & qtTripulacao(QuantTripbarco) 
	& QuantTripbarco == 3
	<-
	?nomeAuxPesca(NomeAuxPesca);
	.print("CAPIT�O verifica com o AUX_PESCA se ele est� pronto para iniciar a Pescaria...");
	.send(NomeAuxPesca, achieve, iniciar_pescaria);
.

+!montarTripulacao
	: meuBarcoEh(NomeBarco, IdBarco)
	<- 
	.concat("pescadorAg", IdBarco, NomePescador);
	.concat("auxPescaAg", IdBarco, NomeAuxPesca);
	.create_agent(NomePescador, "pescador.asl");
	.create_agent(NomeAuxPesca, "aux_pesca.asl");
	//Adiciona � sua base de cren�a o nome de seus companheiros de tripulacao
	+nomePescador(NomePescador);
	+nomeAuxPesca(NomeAuxPesca);
	.print("criou o agente: ", NomePescador);
	.print("criou o agente: ", NomeAuxPesca);
	.send(NomePescador, tell, meuBarcoEh(NomeBarco, IdBarco));
	.send(NomeAuxPesca, tell, meuBarcoEh(NomeBarco, IdBarco));
	.wait(100);
	!verificarPeixesOceano;
.

+!auxPescaPronto <-
 	?nomePescador(NomePescador);
 	?nomeAuxPesca(NomeAuxPesca);
 	.print("CAPIT�O verifica com o PESCADOR se ele est� pronto para iniciar a Pescaria...");
 	.wait(100);
	.send(NomePescador, achieve, iniciar_pescaria);
.

+!pescadorPronto <-
	?nomePescador(NomePescador);
	!ligar_motor;
.

+!ligar_motor <- 
	.print("...ligando os motores para iniciar a navegacao em mar aberto...");
	ligar_motores; //fun��o do artefato Barco
	.wait(100);
	!localizar_cardume;
.

+!localizar_cardume <- 
	?nomePescador(NomePescador);
	.print("...se preparando para localizar os cardumes no mar...");
	piloto_automatico;	//fun��o do artefato Barco
	.print("cardume encontrado...");
	.print("CAPIT�O pede para o PESCADOR jogar as redes no Oceano...");
	.wait(100);
	.send(NomePescador, achieve, jogar_redes);	
.
	
+!nav_porto <- 
	.print("...navegando em dire��o ao Porto para descarregar...");
	.wait(100);
	navegando_para_porto; //fun��o do artefato Barco
	!desligar_motores;
.
	
+!desligar_motores <-
	?nomeAuxPesca(NomeAuxPesca); 
	.print("...desligando os motores...");
	desligar_motores; //fun��o do artefato Barco
	.print("CAPIT�O pede para o AUX_PESCA soltar as ancoras no Oceano...");
	.wait(100);
	.send(NomeAuxPesca, achieve, soltar_ancora);
.

/* other plans */