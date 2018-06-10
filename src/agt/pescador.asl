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
	//Adiciona � sua base de cren�a o nome de seus companheiros de tripulacao
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
.

+!iniciar_pescaria 
	: quantMaxCarga(CapaMaxArm) & qtPeixesCarregados(QuantPeixes) & QuantPeixes < CapaMaxArm
	<-
	.print("PESCADOR verifica se tem capacidade dispon�vel no Barco para iniciar uma pescaria...");
	?nomeCapitao(NomeCapitao);
	.wait(100);
	.print("PESCADOR responde ao CAPIT�O que est� pronto para iniciar a Pescaria...");
	.send(NomeCapitao, achieve, pescadorPronto);
.

+!jogar_redes : quantMaxCarga(QtMax) & qtPeixesCarregados(QtCarregados) & QtCarregados < QtMax
	<-
	.print("...jogando as redes nos cardumes...");
	.wait(100);
	jogar_redes; //fun��o do artefato Barco
	!recolher_redes;
.

+!jogar_redes : quantMaxCarga(QtMax) & qtPeixesCarregados(QtCarregados) & QtCarregados >= QtMax
	<-
	!recolher_redes;
.

//Se a capacidadade de armazenamento das redes + a quantidade de peixes j� carregados no Barco 
//for > que a capacidade m�xima de armazenamento do Barco, entra aqui (encerra a Pescaria)	
+!recolher_redes
	: quantMaxCarga(CapaMaxArm) & qtPeixesCarregados(QuantPeixes) & capacRede(Capac) & (Capac+QuantPeixes)>CapaMaxArm
	<-
	?nomeCapitao(NomeCapitao);
	.print("Quantidade atual de Peixes no Barco: ", QuantPeixes);
	.print("...01_recolhendo as redes para ir em dire��o ao Porto...");
	.print("PESCADOR pede ao CAPIT�O para irem ao Porto descarregar os peixes no Barco...");
	.wait(100);
	.send(NomeCapitao, achieve, nav_porto);
.

+!recolher_redes
	: quantMaxCarga(CapaMaxArm) & qtPeixesCarregados(QuantPeixes) & qtPeixesDisponivel(QtRestante) & QtRestante<=0
	<-
	?nomeCapitao(NomeCapitao);
	.print("Quantidade atual de Peixes no Barco: ", QuantPeixes);
	.print("...02_recolhendo as redes para ir em dire��o ao Porto..."); 	
	.print("PESCADOR pede ao CAPIT�O para irem ao Porto descarregar os peixes no Barco...");
	.wait(100);
	.send(NomeCapitao, achieve, nav_porto);
.	

+!recolher_redes 
	: quantMaxCarga(CapaMaxArm) & qtPeixesCarregados(QuantPeixes) & qtPeixesDisponivel(QtRestante) & QtRestante>=0
	<- 
	.print("...03_recolhendo as redes com os peixes pescados...");
	lookupArtifact(oceano, ArtOceanoId); //busca o identificador do artefato Oceano
	recolher_redes(ArtOceanoId); //fun��o do artefato Barco
	//consuta na base de cren�as do agente
	?qtPeixesCarregados(QuantAtualPeixes);
	!jogar_redes;
.
	
/* other plans */