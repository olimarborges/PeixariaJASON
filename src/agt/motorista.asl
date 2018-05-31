{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }

/* application domain goals */

!start.

/* Plans */

+!start : message(X) <- printMsg(X).
+!start : true <- .print("Eu sou o Motorista!").

+play(Name,_,ArtGrup) 
	: .my_name(Name)
	<-	
	lookupArtifact(ArtGrup, ArtId);
	focus(ArtId);
	.print("Focando no Caminhao: ", ArtGrup ,"...");
	!criarEsquema(ArtGrup);
	.

+!criarEsquema(ArtGrup)
	<-  
	.concat("recolherPeixesPorto",ArtGrup, Scheme1Name);
	createScheme(Scheme1Name, g2t1RecolherPeixesSch, Sch1ArtId);
	
	.concat("levarPeixesDistribuidor",ArtGrup, Scheme2Name);
	createScheme(Scheme2Name, g2t2LevarPeixDistribuidorSch, Sch2ArtId);
	
	//Instanciando esquema 01 da equipe de Transporte
	addScheme(Scheme1Name);
	.	

+!g2t1_dirigir_ate_porto 
	<- 
	.print("dirigindo ate o porto para buscar carregamento de peixes...")
	dirigindo_ate_porto; //função do artefato Caminhao
	.

+!g2t1_desligar_caminhao 
	<- 
	.print("desligando o caminhao...")
	desligar_motores; //função do artefato Caminhao
	.

+!g2t2_ligar_caminhao 
	<- 
	.print("ligando o motor do caminhao...")
	ligar_motores; //função do artefato Caminhao
	.

+!g2t2_verificar_rota_gps 
	<- 
	.print("verificando o melhor caminho ate o distribuidor...")
	verificando_rota_gps; //função do artefato Caminhao
	//!g2t2_dirigir_ate_distribuidor; 
	.

+!g2t2_dirigir_ate_distribuidor 
	<- 
	.print("dirigindo ate o distribuidor...")
	dirigindo_ate_distribuidor; //função do artefato Caminhao
	.

+!g2t2_descarr_peixes <- 
	.print("retirando peixes do Camiinhão e descarregando no Distribuidor...");
	lookupArtifact(distribuidor, ArtId); //busca o identificador do artefato Distribuidor
	descarregar_peixes_distribuidor(ArtId); //função do artefato Caminhão	
	.
/* other plans */