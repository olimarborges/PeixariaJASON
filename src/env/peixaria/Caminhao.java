// CArtAgO artifact code for project peixaria

package peixaria;

import java.util.logging.Logger;

import cartago.Artifact;
import cartago.ArtifactId;
import cartago.OPERATION;
import cartago.ObsProperty;
import cartago.OpFeedbackParam;
import cartago.OperationException;

public class Caminhao extends Artifact {
	
	private Logger logger = Logger.getLogger("caminhao."+Caminhao.class.getName());
	
	void init(int identificador, int capacCarregador, int quantMaxCarga) {
		defineObsProperty("qtEquipe",0);
		defineObsProperty("identificador",identificador);
		defineObsProperty("qtPeixesCarregados", 0);
		defineObsProperty("histPeixesCarregados", 0);
        defineObsProperty("quantMaxCarga", quantMaxCarga);
        defineObsProperty("motor",         "desligado");
        defineObsProperty("capacCarregador", capacCarregador);
	}
	
	@OPERATION 
	void incrementaEquipe(int idCaminhao, String nomeAgent){
		int qtEquipe = (Integer) getObsProperty("qtEquipe").getValue();
	    ObsProperty prop = getObsProperty("qtEquipe");
	    
	    if(qtEquipe<=2){
	    	prop.updateValue(prop.intValue()+1);
		  	logger.info((Integer) getObsProperty("identificador").getValue()+": Novo membro:"+ nomeAgent +" da Equipe do Caminh�o "+ idCaminhao +" adicionado");
	    }else{
	    	logger.info((Integer) getObsProperty("identificador").getValue()+": Equipe para o Caminh�o esgotada!");
	    }
	}
	
	@OPERATION
	void dirigindo_ate_porto(){
		try {
			//Thread.sleep(2000);
			logger.info((Integer) getObsProperty("identificador").getValue()+": Caminh�o indo em dire��o ao Porto!");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@OPERATION
	void dirigindo_ate_distribuidor(){
		try {
			//Thread.sleep(2000);
			logger.info((Integer) getObsProperty("identificador").getValue()+": Caminh�o indo em dire��o ao Distribuidor!");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@OPERATION
	void verificando_rota_gps(){
		try {
			//Thread.sleep(2000);
			logger.info((Integer) getObsProperty("identificador").getValue()+": Verificando rota no GPS at� o Distribuidor!");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@OPERATION
	void localizando_carregamento(){
		try {
			//Thread.sleep(2000);
			logger.info((Integer) getObsProperty("identificador").getValue()+": Carregador localizando carregamento dispon�vel no Porto!");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@OPERATION
	void ligar_motores(){
		ObsProperty prop = getObsProperty("motor");
		prop.updateValue("ligado");
		logger.info((Integer) getObsProperty("identificador").getValue()+": Motor caminh�o ligado!");
	}
	
	@OPERATION
	void desligar_motores(){
		ObsProperty prop = getObsProperty("motor");
		prop.updateValue("desligado");
		logger.info((Integer) getObsProperty("identificador").getValue()+": Motor caminh�o desligado!");
	}
	
	@OPERATION
	//Recebe o artefato Porto por par�metro
	void carregar_caminhao(ArtifactId idArtefato){
		int idCaminhao = (Integer) getObsProperty("identificador").getValue();
		int qtPeixesCarreg = (Integer) getObsProperty("qtPeixesCarregados").getValue();
		int capacCarregador = (Integer) getObsProperty("capacCarregador").getValue();
		int histPeixesCarregados = (Integer) getObsProperty("histPeixesCarregados").getValue();
		
		ObsProperty prop2 = getObsProperty("qtPeixesCarregados");
		ObsProperty prop3 = getObsProperty("histPeixesCarregados");
		
		
		OpFeedbackParam<Integer> peixes = new OpFeedbackParam<Integer>();
		
		try {
			execLinkedOp(idArtefato, "carregar_peixes_caminhao", idCaminhao, capacCarregador, peixes);
		} catch (OperationException e) {
			e.printStackTrace();
		}
		
		logger.info((Integer) getObsProperty("identificador").getValue()+": Peixes retirados do Porto: "+peixes.get());
		
		prop2.updateValue(qtPeixesCarreg + peixes.get());
		prop3.updateValue(histPeixesCarregados + peixes.get());
		
		logger.info((Integer) getObsProperty("identificador").getValue()+": Caminh�o sendo carregado!");
	}
	
	@OPERATION
	//Recebe o artefato Distribuidor por par�metro
	void descarregar_peixes_distribuidor(ArtifactId idArtefato){
		int qtCarga = (Integer) getObsProperty("qtPeixesCarregados").getValue();
		int histPeixesCarregados = (Integer) getObsProperty("histPeixesCarregados").getValue();
		
		ObsProperty prop2 = getObsProperty("qtPeixesCarregados");
		
		if(qtCarga>0) {
			try {
				execLinkedOp(idArtefato, "receber_carregamento_peixes", qtCarga);
			} catch (OperationException e) {
				e.printStackTrace();
			}
			
			prop2.updateValue(0);
			
			logger.info((Integer) getObsProperty("identificador").getValue()+": Peixes descarregados no Distribuidor!");
			logger.info((Integer) getObsProperty("identificador").getValue()+": HIST�RICO de Peixes Carregados por este CAMINH�O: " + histPeixesCarregados);
		}	
	}
	
}

