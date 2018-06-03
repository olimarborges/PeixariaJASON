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
	lookupArtifact(NomeBarco, ArtId)[wid(NomeWorkspace)];
	focus(ArtId);
	incrementaTripulacao(IdBarco, NomeAgent);
	.print("Eu sou o: ", NomeAgent, " do: ", NomeBarco);
	
	//Adiciona à sua base de crença o nome de seus companheiros de tripulacao
	.concat("capitaoAg", IdBarco, NomeCapitao);
	.concat("auxPescaAg", IdBarco, NomeAuxPesca);
	+nomeCapitao(NomeCapitao);
	+nomeAuxPesca(NomeAuxPesca);
	
	//Focando no Oceano
	lookupArtifact(oceano, ArtOceanoId)[wid(NomeWorkspace)];
	focus(ArtOceanoId);
	
	//Focando no Porto
	lookupArtifact(porto, ArtPortoId)[wid(NomeWorkspace)];
	focus(ArtPortoId);
	
//	.print("PESCADOR pede ao CAPITÃO para iniciarem a busca por peixes no Oceano, caso a tripulação já esteja completa...");
//	.send(NomeCapitao, achieve, verificarPeixesOceano);
.

+!iniciar_pescaria 
	: quantMaxCarga(CapaMaxArm) & qtPeixesCarregados(QuantPeixes) & QuantPeixes < CapaMaxArm
	<-
	.print("PESCADOR verifica se tem capacidade disponível no Barco para iniciar uma pescaria...");
	.wait(1000);
	?nomeCapitao(NomeCapitao);
	.print("PESCADOR responde ao CAPITÃO que está pronto para iniciar a Pescaria...");
	.send(NomeCapitao, achieve, pescadorPronto);
.

+!jogar_redes 
	<-
	.print("...jogando as redes nos cardumes...");
	jogar_redes; //função do artefato Barco
	.wait(1000);
	!recolher_redes;
.

//Se a capacidadade de armazenamento das redes + a quantidade de peixes já carregados no Barco 
//for > que a capacidade máxima de armazenamento do Barco, entra aqui (encerra a Pescaria)	
+!recolher_redes
	: quantMaxCarga(CapaMaxArm) & qtPeixesCarregados(QuantPeixes) & capacRede(Capac) & (Capac+QuantPeixes)>CapaMaxArm
	<-
	?nomeCapitao(NomeCapitao);
	.print("Quantidade atual de Peixes no Barco: ", QuantPeixes);
	.print("...01_recolhendo as redes para ir em direção ao Porto...");
	.wait(1000);	
	.print("PESCADOR pede ao CAPITÃO para irem ao Porto descarregar os peixes no Barco...");
	.send(NomeCapitao, achieve, nav_porto);
.

//Se a quantidade restante de peixes no Oceano for <= a zero, entra aqui (encerra a Pescaria)
+!recolher_redes
	: quantMaxCarga(CapaMaxArm) & qtPeixesCarregados(QuantPeixes) & qtPeixesDisponivel(QtRestante) & QtRestante<=0
	<-
	?nomeCapitao(NomeCapitao);
	.print("Quantidade atual de Peixes no Barco: ", QuantPeixes);
	.print("...02_recolhendo as redes para ir em direção ao Porto..."); 	
	.wait(1000);
	.print("PESCADOR pede ao CAPITÃO para irem ao Porto descarregar os peixes no Barco...");
	.send(NomeCapitao, achieve, nav_porto);
.	
	
//Se for o diferente dos dois casos acima, entra aqui (continua a Pescaria)
+!recolher_redes 
	: quantMaxCarga(CapaMaxArm) & qtPeixesCarregados(QuantPeixes) & qtPeixesDisponivel(QtRestante) & QtRestante>=0
	<- 
	.print("...03_recolhendo as redes com os peixes pescados...");
	
	lookupArtifact(oceano, ArtOceanoId); //busca o identificador do artefato Oceano
	recolher_redes(ArtOceanoId); //função do artefato Barco
	
	//consuta na base de crenças do agente
	?qtPeixesCarregados(QuantAtualPeixes);
	.wait(1000);
	.print("Quantidade atual de Peixes no Barco: ", QuantAtualPeixes);
	!jogar_redes;
.
	
/* other plans */