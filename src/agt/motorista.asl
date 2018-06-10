{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }

/* application domain goals */

!iniciarTransporte.

+!iniciarTransporte
	: .my_name(NomeAgent) & identificador(IdCaminhao)
	<-	
	.concat("caminhao_0", IdCaminhao, NomeCaminhao);
	.print("Nome do Caminh�o - Motorista: ", NomeCaminhao);
	lookupArtifact(NomeCaminhao, ArtId);
	.print("ArtId do Caminh�o - Motorista: ", ArtId);
	focus(ArtId);
	incrementaEquipe(IdCaminhao, NomeAgent);
	.print("Eu sou o: ", NomeAgent, " do: ", NomeCaminhao);
	+meuCaminhaoEh(NomeCaminhao, IdCaminhao);
	.wait(100);
	!verificarPeixesPorto;
.

+!verificarPeixesPorto
	: qtPeixesArmazenado(QuantPeixesArm) & QuantPeixesArm > 0 & qtEquipe(QuantEqCaminhao) & QuantEqCaminhao < 2
	<-
	!montarEquipe;
.

+!verificarPeixesPorto 
	: qtPeixesArmazenado(QuantPeixesArm) & QuantPeixesArm > 0 & qtEquipe(QuantEqCaminhao) & QuantEqCaminhao == 2
	<-
	?nomeCarregador(NomeCarregador);
	.print("MOTORISTA verifica com o CARREGADOR se ele est� pronto para iniciar o Carregamento...");
	.wait(100);
	.send(NomeCarregador, achieve, buscar_peixes_porto);
.

+novosPeixesPorto
	: qtPeixesArmazenado(QuantPeixesArm) & QuantPeixesArm > 0
	<-
	.print("NOVOS PEIXES ADICIONADOS NO PORTO! - CARREGAR PEIXES NOVAMENTE!");
	!verificarPeixesPorto;
.
	
+!montarEquipe
	: meuCaminhaoEh(NomeCaminhao, IdCaminhao)
	<- 
	.concat("carregadorAg", IdCaminhao, NomeCarregador);
	.create_agent(NomeCarregador, "carregador.asl");
	//Adiciona � sua base de cren�a o nome de seus companheiros de equipe
	+nomeCarregador(NomeCarregador);
	.print("criou o agente: ", NomeCarregador);
	.send(NomeCarregador, tell, meuCaminhaoEh(NomeCaminhao, IdCaminhao));
	.wait(100);
	!verificarPeixesPorto;
.

+!carregadorPronto <-
 	?nomeCarregador(NomeCarregador);
	!dirigir_ate_porto;
.

+!dirigir_ate_porto 
	<- 
	.print("...dirigindo ate o porto para buscar carregamento de peixes...")
	.wait(100);
	dirigindo_ate_porto; //fun��o do artefato Caminhao
	!desligar_caminhao;
.

+!desligar_caminhao 
	<- 
	?nomeCarregador(NomeCarregador);
	.print("...desligando o caminhao...")
	desligar_motores; //fun��o do artefato Caminhao
	.print("MOTORISTA pede ao CARREGADOR que localize o carregamento de peixes no Porto...");
	.wait(100);
	.send(NomeCarregador, achieve, localizar_carregamento);
.

+!ligar_caminhao 
	<- 
	.print("...ligando o motor do caminhao para ir em dire��o ao Distribuidor...");
	.wait(100);
	ligar_motores; //fun��o do artefato Caminhao
	!verificar_rota_gps;
.
+!verificar_rota_gps 
	<- 
	.print("...verificando o melhor caminho at� o distribuidor...");
	.wait(100);
	verificando_rota_gps; //fun��o do artefato Caminhao
	!dirigir_ate_distribuidor;
.

+!dirigir_ate_distribuidor 
	<- 
	.print("...dirigindo ate o distribuidor...");
	dirigindo_ate_distribuidor; //fun��o do artefato Caminhao
	.wait(100);
	!descarr_peixes;
.
+!descarr_peixes <- 
	.print("...retirando peixes do Caminh�o e descarregando no Distribuidor...");
	lookupArtifact(distribuidor, ArtId); //busca o identificador do artefato Distribuidor
	descarregar_peixes_distribuidor(ArtId); //fun��o do artefato Caminh�o	
	!verificando_peixes_porto;
.
+!verificando_peixes_porto 
	: qtPeixesArmazenado(QuantPeixesArm) & QuantPeixesArm > 0 
	<- 
	.print("...ainda existem peixes a serem carregados no Porto...");
	!dirigir_ate_porto;
.
+!verificando_peixes_porto 
	: qtPeixesArmazenado(QuantPeixesArm) & QuantPeixesArm <= 0 
	<- 
	.print("...neste momento n�o exitem peixes a serem carregados no Porto... aguardando sinal do Porto...");
.
/* other plans */