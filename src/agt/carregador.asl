{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }

/* application domain goals */

+meuCaminhaoEh(NomeCaminhao, IdCaminhao)
	: .my_name(NomeAgent)
	<-	
	//Entrando no mesmo ambiente
	joinWorkspace("peixaria",NomeWorkspace);
	//Focando no Caminhão
	.concat("caminhao_0", IdCaminhao, NomeCaminhao);
	lookupArtifact(NomeCaminhao, ArtCaminhaoId)[wid(NomeWorkspace)];
	focus(ArtCaminhaoId);
	incrementaEquipe(IdCaminhao, NomeAgent);
	.print("Eu sou o: ", NomeAgent, " do: ", NomeCaminhao);
	//Adiciona à sua base de crença o nome de seus companheiros de equipe
	.concat("motoristaAg", IdCaminhao, NomeMotorista);
	+nomeMotorista(NomeMotorista);
	//Focando no Distribuidor
	lookupArtifact(distribuidor, ArtDistribuidorId)[wid(NomeWorkspace)];
	focus(ArtDistribuidorId);
	//Focando no Porto
	lookupArtifact(porto, ArtPortoId)[wid(NomeWorkspace)];
	focus(ArtPortoId);
.

+!buscar_peixes_porto 
	: meuCaminhaoEh(_,IdCaminhao)
	<-
	?nomeMotorista(NomeMotorista);
	.print("CARREGADOR responde ao MOTORISTA que está pronto para iniciar o Carregamento...");
	.wait(100);
	.send(NomeMotorista, achieve, carregadorPronto);
.

/* Plans */

+!localizar_carregamento 
	<- 
	.print("...localizando o carregamento de peixes no Porto...")
	.wait(100);
	localizando_carregamento; //funcao do artefato Caminhao
	!carregar_caminhao;
.

+!carregar_caminhao 
	: quantMaxCarga(CapaMaxArm) & qtPeixesCarregados(QuantPeixes) & capacCarregador(Capac) & (Capac+QuantPeixes) > CapaMaxArm
	<-
	?nomeMotorista(NomeMotorista)
	.print("...01_preparando o Caminhao para ir em direção ao Distribuidor...");
	.print("CARREGADOR pede ao MOTORISTA para irem em direção ao Distribuidor descarregar, pois o Caminhão já está carregado...");
	.wait(100);
	.send(NomeMotorista, achieve, ligar_caminhao);
.
	
+!carregar_caminhao
	: quantMaxCarga(CapaMaxArm) & qtPeixesCarregados(QuantPeixes) & qtPeixesArmazenado(QtRestante) & QtRestante<=0
	<-
	?nomeMotorista(NomeMotorista)
	.print("...02_preparando o Caminhao para ir em direção ao Distribuidor...");
	.print("CARREGADOR pede ao MOTORISTA para irem em direção ao Distribuidor descarregar, pois o Caminhão já está carregado...");
	.wait(100);
	.send(NomeMotorista, achieve, ligar_caminhao);
.	
	
+!carregar_caminhao 
	: quantMaxCarga(CapaMaxArm) & qtPeixesCarregados(QuantPeixes) & qtPeixesArmazenado(QtRestante) & QtRestante>=0
	<- 
	.print("...03_carregando o caminhao com o carregamento de peixes...")
	lookupArtifact(porto, ArtId); //busca o identificador do artefato Porto
	.wait(100);
	carregar_caminhao(ArtId); //função do artefato Caminhao
	//consuta na base de crenças do agente
	?qtPeixesCarregados(QuantTotalPeixes);
	.print("Quantidade de peixes retirados do Porto e recolhidos para este Caminhao: ", QuantTotalPeixes); //-QuantPeixes
	!carregar_caminhao ;
.
	
/* other plans */