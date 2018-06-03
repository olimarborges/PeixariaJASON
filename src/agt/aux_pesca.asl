{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }

/* application domain goals */

+meuBarcoEh(NomeBarco, IdBarco)
	: .my_name(NomeAgent)
	<-	
	//Entrando no mesmo ambiente
	joinWorkspace("peixaria",NomeWorkspace);
	
	//Focando no Barco
	.concat("barco_0", IdBarco, NomeBarco);
	lookupArtifact(NomeBarco, ArtBarcoId)[wid(NomeWorkspace)];
	focus(ArtBarcoId);
	incrementaTripulacao(IdBarco, NomeAgent);
	.print("Eu sou o: ", NomeAgent, " do: ", NomeBarco);
	
	//Adiciona à sua base de crença o nome de seus companheiros de tripulacao
	.concat("capitaoAg", IdBarco, NomeCapitao);
	.concat("pescadorAg", IdBarco, NomePescador);
	+nomeCapitao(NomeCapitao);
	+nomePescador(NomePescador);
	
	//Focando no Oceano
	lookupArtifact(oceano, ArtOceanoId)[wid(NomeWorkspace)];
	focus(ArtOceanoId);
	
	//Focando no Porto
	lookupArtifact(porto, ArtPortoId)[wid(NomeWorkspace)];
	focus(ArtPortoId);
//	.print("AUX_PESCA pede ao CAPITÃO para iniciarem a busca por peixes no Oceano, caso a tripulação já esteja completa...");
//	.send(NomeCapitao, achieve, verificarPeixesOceano);
.

+!iniciar_pescaria 
	: meuBarcoEh(_,IdBarco)
	<-
	?nomeCapitao(NomeCapitao);
	!puxar_ancora;
	.print("AUX_PESCA responde ao CAPITÃO que está pronto para iniciar a Pescaria...");
	.send(NomeCapitao, achieve, auxPescaPronto);
.

+!puxar_ancora <- 
	.print("...puxando ancora para iniciar a navegacao em mar aberto...");
	.wait(1000);
	puxar_ancora; //função do artefato Barco
.

+!soltar_ancora <- 
	.print("...soltar ancora para iniciar a parada...");
	soltar_ancora; //função do artefato Barco
	!retir_peixes;
.

+!retir_peixes <- 
	?nomeCapitao(NomeCapitao);
	.print("...retirando peixes do Barco...");
	.wait(1000);
	lookupArtifact(porto, ArtId); //busca o identificador do artefato Porto
	colocar_peixes_porto(ArtId); //função do artefato Barco
	
	.print("AUX_PESCA pede ao CAPITÃO para iniciarem a busca por peixes no Oceano novamente, após já terem descarregado sua carga no Porto...");
	.send(NomeCapitao, achieve, verificarPeixesOceano);
.

/* other plans */