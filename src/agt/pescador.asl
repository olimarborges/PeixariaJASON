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
	incrementaTripulacao;
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
.

+!iniciar_pescaria 
	: quantMaxCarga(CapaMaxArm,QuantPeixes) & QuantPeixes < CapaMaxArm & nomeCapitao(NomeCapitao)
	<-
	.send(NomeCapitao, tell, pescadorPronto);
.

+!g1t2_jogar_redes 
	<-
	.print("jogando as redes nos cardumes...");
	jogar_redes; //função do artefato Barco
	.wait(1000);
	!g1t2_recolher_redes;
	.
	
+!g1t2_recolher_redes
	: quantMaxCarga(CapaMaxArm,QuantPeixes) & capacRede(Capac) & (Capac+QuantPeixes)>CapaMaxArm & nomeCapitao(NomeCapitao) 
	<-
	.print("Quantidade atual de Peixes no Barco: ", QuantPeixes);
	.print("recolhendo as redes para ir em direção ao Porto...");
	.wait(1000);	

	.send(NomeCapitao, achieve, g1t3_nav_porto);
.

+!g1t2_recolher_redes
	: quantMaxCarga(CapaMaxArm,QuantPeixes) & qtPeixesDisponivel(QtRestante) & QtRestante<=0 & nomeCapitao(NomeCapitao)
	<-
	.print("Quantidade atual de Peixes no Barco: ", QuantPeixes);
	.print("recolhendo as redes para ir em direção ao Porto..."); 	
	.wait(1000);	
	
	.send(NomeCapitao, achieve, g1t3_nav_porto);
.	
	
+!g1t2_recolher_redes 
	: quantMaxCarga(_,QuantPeixes)
	<- 
	.print("recolhendo as redes com os peixes pescados...");
	.wait(1000);
	lookupArtifact(oceano, ArtOceanoId); //busca o identificador do artefato Oceano
	recolher_redes(ArtOceanoId); //função do artefato Barco
	
	//consulta na base de crenças do agente
	?quantMaxCarga(_,QuantTotalPeixes);
	
	//.print("Quantidade de peixes pescados neste lançamento de redes: ", QuantTotalPeixes-QuantPeixes);
	.print("Quantidade atual de Peixes no Barco: ", QuantPeixes);
	!g1t2_recolher_redes;
	.
	
/* other plans */