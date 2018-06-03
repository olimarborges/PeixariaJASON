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
//	.print("ArtId do Barco Capitao: ", ArtId);
	
	focus(ArtId);
	incrementaTripulacao(IdBarco, NomeAgent);
	
	.print("Eu sou o: ", NomeAgent, " do: ", NomeBarco);
	+meuBarcoEh(NomeBarco, IdBarco);
	!verificarPeixesOceano;
.

+novosPeixesOceano
	: qtPeixesDisponivel(QuantPeixesDisp) & QuantPeixesDisp> 0 & ancora("noMar")
	<-
	.print("NOVOS PEIXES ADICIONADOS NO OCEANO! - BORA PESCAR DE NOVO!");
	!verificarPeixesOceano;
.

/* Plans */
+!verificarPeixesOceano 
	: qtPeixesDisponivel(QuantPeixesDisp) & QuantPeixesDisp > 0 & qtTripulacao(QuantTripbarco) & QuantTripbarco < 3
	<-
	!montarTripulacao;
.

+!verificarPeixesOceano 
	: qtPeixesDisponivel(QuantPeixesDisp) & QuantPeixesDisp > 0 & qtTripulacao(QuantTripbarco) & QuantTripbarco == 3
	<-
	?nomeAuxPesca(NomeAuxPesca);
	.print("CAPITÃO verifica com o AUX_PESCA se ele está pronto para iniciar a Pescaria...");
	.send(NomeAuxPesca, achieve, iniciar_pescaria);
.

+!verificarPeixesOceano 
	: qtPeixesDisponivel(QuantPeixesDisp) & QuantPeixesDisp == 0 & qtTripulacao(QuantTripbarco) & QuantTripbarco == 3
	<-
	.print("PEDE AOS DEUSES POR MAIS PEIXES NO OCEANO..............");
	precisamosPeixesOceano;
.
	
+!montarTripulacao
	: meuBarcoEh(NomeBarco, IdBarco)
	<- 
	.concat("pescadorAg", IdBarco, NomePescador);
	.concat("auxPescaAg", IdBarco, NomeAuxPesca);
	
	.create_agent(NomePescador, "pescador.asl");
	.create_agent(NomeAuxPesca, "aux_pesca.asl");
	
	//Adiciona à sua base de crença o nome de seus companheiros de tripulacao
	+nomePescador(NomePescador);
	+nomeAuxPesca(NomeAuxPesca);
	
	.print("criou o agente: ", NomePescador);
	.print("criou o agente: ", NomeAuxPesca);
	
	.send(NomePescador, tell, meuBarcoEh(NomeBarco, IdBarco));
	.send(NomeAuxPesca, tell, meuBarcoEh(NomeBarco, IdBarco));

	.wait(1000);
	!verificarPeixesOceano;
.

+!auxPescaPronto <-
 	?nomePescador(NomePescador);
 	?nomeAuxPesca(NomeAuxPesca);
 	.print("CAPITÃO verifica com o PESCADOR se ele está pronto para iniciar a Pescaria...");
	.send(NomePescador, achieve, iniciar_pescaria);
.

+!pescadorPronto <-
	?nomePescador(NomePescador);
	!ligar_motor;
.

+!ligar_motor <- 
	.print("...ligando os motores para iniciar a navegacao em mar aberto...");
	ligar_motores; //função do artefato Barco
	!localizar_cardume;
.

+!localizar_cardume <- 
	?nomePescador(NomePescador);
	.print("...se preparando para localizar os cardumes no mar...");
	piloto_automatico;	//função do artefato Barco
	.wait(1000);
	.print("cardume encontrado...");
	
	.print("CAPITÃO pede para o PESCADOR jogar as redes no Oceano...");
	.send(NomePescador, achieve, jogar_redes);	
.
	
+!nav_porto <- 
	.print("...navegando em direção ao Porto para descarregar...");
	.wait(1000);
	navegando_para_porto; //função do artefato Barco
	!desligar_motores;
.
	
+!desligar_motores <-
	?nomeAuxPesca(NomeAuxPesca); 
	.print("...desligando os motores...");
	.wait(1000);
	desligar_motores; //função do artefato Barco
	
	.print("CAPITÃO pede para o AUX_PESCA soltar as ancoras no Oceano...");
	.send(NomeAuxPesca, achieve, soltar_ancora);
.

/* other plans */