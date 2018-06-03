{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }

/* application domain goals */

+meuCaminhaoEh(NomeCaminhao, IdCaminhao)
	: .my_name(NomeAgent)
	<-	
	//Entrando no mesmo ambiente
	joinWorkspace("peixaria",NomeWorkspace);
	
	//Focando no Caminh�o
	.concat("caminhao_0", IdCaminhao, NomeCaminhao);
	lookupArtifact(NomeCaminhao, ArtCaminhaoId)[wid(NomeWorkspace)];
	focus(ArtCaminhaoId);
	incrementaEquipe(IdCaminhao, NomeAgent);
	.print("Eu sou o: ", NomeAgent, " do: ", NomeCaminhao);
	
	//Adiciona � sua base de cren�a o nome de seus companheiros de equipe
	.concat("motoristaAg", IdCaminhao, NomeMotorista);
	+nomeMotorista(NomeMotorista);
	
	//Focando no Distribuidor
	lookupArtifact(distribuidor, ArtDistribuidorId)[wid(NomeWorkspace)];
	focus(ArtDistribuidorId);
	
	//Focando no Porto
	lookupArtifact(porto, ArtPortoId)[wid(NomeWorkspace)];
	focus(ArtPortoId);
	
//	.send(NomeMotorista, achieve, verificarPeixesPorto);
.

+!buscar_peixes_porto 
	: meuCaminhaoEh(_,IdCaminhao)
	<-
	?nomeMotorista(NomeMotorista);
	.print("CARREGADOR responde ao MOTORISTA que est� pronto para iniciar o Carregamento...");
	.send(NomeMotorista, achieve, carregadorPronto);
.

/* Plans */

+!localizar_carregamento 
	<- 
	.print("...localizando o carregamento de peixes no Porto...")
	localizando_carregamento; //funcao do artefato Caminhao
	!carregar_caminhao;
.

+!carregar_caminhao 
	: quantMaxCarga(CapaMaxArm) & qtPeixesCarregados(QuantPeixes) & capacCarregador(Capac) & (Capac+QuantPeixes) > CapaMaxArm
	<-
	?nomeMotorista(NomeMotorista)
	.print("...01_preparando o Caminhao para ir em dire��o ao Distribuidor...");
	
	.wait(1000);
	
	.print("CARREGADOR pede ao MOTORISTA para irem em dire��o ao Distribuidor descarregar, pois o Caminh�o j� est� carregado...");
	.send(NomeMotorista, achieve, ligar_caminhao);
.
	
+!carregar_caminhao
	: quantMaxCarga(CapaMaxArm) & qtPeixesCarregados(QuantPeixes) & qtPeixesArmazenado(QtRestante) & QtRestante<=0
	<-
	?nomeMotorista(NomeMotorista)
	.print("...02_preparando o Caminhao para ir em dire��o ao Distribuidor...");
	
	.wait(1000);
	
	.print("CARREGADOR pede ao MOTORISTA para irem em dire��o ao Distribuidor descarregar, pois o Caminh�o j� est� carregado...");
	.send(NomeMotorista, achieve, ligar_caminhao);
.	
	
+!carregar_caminhao 
	: quantMaxCarga(CapaMaxArm) & qtPeixesCarregados(QuantPeixes) & qtPeixesArmazenado(QtRestante) & QtRestante>=0
	<- 
	.print("...03_carregando o caminhao com o carregamento de peixes...")
	lookupArtifact(porto, ArtId); //busca o identificador do artefato Porto
	carregar_caminhao(ArtId); //fun��o do artefato Caminhao
	
	//consuta na base de cren�as do agente
	?qtPeixesCarregados(QuantTotalPeixes);
	.wait(1000);
	.print("Quantidade de peixes retirados do Porto e recolhidos para este Caminhao: ", QuantTotalPeixes); //-QuantPeixes
	!carregar_caminhao ;
.
	
/* other plans */