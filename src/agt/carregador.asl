{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }

/* application domain goals */

!start.

/* Plans */

+!start : message(X) <- printMsg(X).
+!start : true <- .print("Eu sou o Carregador!").

+play(Name,_,ArtGrup) 
	: .my_name(Name)
	<-	
	lookupArtifact(ArtGrup, ArtId);
	focus(ArtId);
	.print("Focando no Caminhão: ", ArtGrup ,"...");
	.

+!g2t1_localizar_carregamento 
	<- 
	.print("localizando o carregamento de peixes no porto...")
	localizando_carregamento; //funcao do artefato Caminhao
	.

+!g2t1_carregar_caminhao 
	: quantMaxCarga(CapaMaxArm,QuantPeixes) & capacCarregador(Capac) & (Capac+QuantPeixes) > CapaMaxArm & play(_,_,ArtGrup)
	<-
	.print("preparando o Caminhao para ir em direção ao Distribuidor..."); 		
	//Instanciando esquema 02 da equipe de Transporte
	.concat("levarPeixesDistribuidor",ArtGrup, SchemeName);
	addScheme(SchemeName);
	.
	
+!g2t1_carregar_caminhao
	: quantMaxCarga(CapaMaxArm,QuantPeixes) & qtPeixesArmazenado(QtRestante) & QtRestante<=0 & play(_,_,ArtGrup) 
	<-
	.print("preparando o Caminhao para ir em direção ao Distribuidor..."); 		
	//Instanciando esquema 03 da equipe de Transporte
	//.nth(0,Grupo,ArtGrup);
	.concat("levarPeixesDistribuidor",ArtGrup, SchemeName);
	addScheme(SchemeName);
	.	
	
+!g2t1_carregar_caminhao 
	: quantMaxCarga(_,QuantPeixes) & groups(Grupo)
	<- 
	.print("carregando o caminhao com o carregamento de peixes...")
	lookupArtifact(porto, ArtId); //busca o identificador do artefato Porto
	carregar_caminhao(ArtId); //função do artefato Caminhao
	
	//consuta na base de crenças do agente
	?quantMaxCarga(_,QuantTotalPeixes);
	
	.print("Quantidade de peixes retirados do Porto e recolhidos para este Caminhao: ", QuantTotalPeixes-QuantPeixes);
	!g2t1_carregar_caminhao ;
	.
	
/* other plans */