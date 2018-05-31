{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }

/* application domain goals */

!iniciarSimulacao.

+!iniciarSimulacao
	: .my_name(NomeAgent) & identificador(IdBarco)
	<-	
	.concat("barco_0", IdBarco, NomeBarco);
	.print("Nome do Barco Capitao: ", NomeBarco);
	
	lookupArtifact(NomeBarco, ArtId);
	.print("ArtId do Barco Capitao: ", ArtId);
	
	focus(ArtId);
	incrementaTripulacao;
	
	.print("Eu sou o: ", NomeAgent, " do: ", NomeBarco);
	+meuBarcoEh(NomeBarco, IdBarco);
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
	!g1t1_ligar_motor;
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
	
	.send(NomeAuxPesca, achieve, iniciar_pescaria);
.

+auxPescaPronto
 	: nomePescador(NomePescador)
 	<-
	.send(NomePescador, achieve, iniciar_pescaria);
.

+pescadorPronto <-
	!verificarPeixesOceano;
.

+!g1t1_ligar_motor <- 
	.print("ligando os motores para iniciar a navegacao em mar aberto...");
	ligar_motores; //função do artefato Barco
	!g1t1_localizar_cardume;
	.

+!g1t1_localizar_cardume 
	: nomePescador(NomePescador)
	<- 
	.print("se preparando para localizar os cardumes no mar...");
	piloto_automatico;	//função do artefato Barco
	.wait(1000);
	.print("cardume encontrado...");
	
	//Pede para o Pescador iniciar a pescaria em alto mar
	.send(NomePescador, achieve, g1t2_jogar_redes);	
.
	
+!g1t3_nav_porto <- 
	.print("navegando em direção ao Porto para descarregar...");
	.wait(1000);
	navegando_para_porto; //função do artefato Barco
	!g1t3_desligar_motores;
.
	
+!g1t3_desligar_motores 
	: nomeAuxPesca(NomeAuxPesca)
	<- 
	.print("desligando os motores...");
	.wait(1000);
	desligar_motores; //função do artefato Barco
	
	.send(NomeAuxPesca, achieve, g1t3_soltar_ancora);
.

/* other plans */