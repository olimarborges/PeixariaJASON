{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }

/* application domain goals */

!iniciarSimulacao.

//+!buscaIdBarco: true
//	<- 
//	incrementaIdBarco;
//	!iniciarSimulacao
//.	

+!iniciarSimulacao
	: .my_name(NomeAgent) & identificador(IdBarco)
	<-	
	.concat("barco_0", IdBarco, NomeBarco);
	lookupArtifact(NomeBarco, ArtBarcoId);
	focus(ArtBarcoId);
	.print("NomeBarco e ArtId do Barco - Criador: ", NomeBarco, "ArtId: ", ArtBarcoId);
	
	//-identificador(IdBarco);
	!criarTripulacao(IdBarco, NomeBarco);	
	.

+!criarTripulacao(IdBarco, NomeBarco)
	<- 
	.print("entrou no criarTripulacoes");
	
	.concat("capitaoAg", IdBarco, NomeCapitao);
	//.concat("pescadorAg", IdBarco, NomePescador);
	//.concat("auxPescaAg", IdBarco, NomeAuxPesca);
	
	.create_agent(NomeCapitao, "capitao.asl");
	lookupArtifact(NomeBarco, ArtBarcoId);
	focus(ArtBarcoId);
	
	//.create_agent(NomePescador, "pescador.asl");
	//.create_agent(NomeAuxPesca, "aux_pesca.asl");
	
	.print("criou o agente: ", NomeCapitao);
	//.print("criou o agente: ", NomePescador);
	//.print("criou o agente: ", NomeAuxPesca);
	
	//.send(NomeCapitao, tell, meuBarcoEh(NomeBarco, IdBarco));
	//.send(NomePescador, achieve, meuBarcoEh(NomeBarco, IdBarco, ArtId));
	//.send(NomeAuxPesca, tell, meuBarcoEh(NomeBarco, IdBarco, ArtId));
	
//	.send(NomePescador, achieve, vamosPescar);
//	.send(NomeAuxPesca, achieve, vamosPescar);
.

+!criarOceanoEPorto
	: .my_name(NomeAgent)
	<-	
	lookupArtifact(oceano, ArtOceanoId);
	//focus(ArtOceanoId);
	.print("ArtId do Oceano - Criador: ", ArtOceanoId);
	
	lookupArtifact(porto, ArtPortoId);
	//focus(ArtPortoId);
	.print("ArtId do Oceano - Criador: ", ArtPortoId);
	
	!criarTripulacoes;
	.


