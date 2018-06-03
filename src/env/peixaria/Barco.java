// CArtAgO artifact code for project peixaria

package peixaria;

import java.util.logging.Logger;

import cartago.Artifact;
import cartago.ArtifactId;
import cartago.OPERATION;
import cartago.ObsProperty;
import cartago.OpFeedbackParam;
import cartago.OperationException;

public class Barco extends Artifact {
	
	private Logger logger = Logger.getLogger("barco."+Barco.class.getName());
	
	void init(int identificador, int capacRede, int quantMaxCarga) {
		defineObsProperty("qtTripulacao",0);
		defineObsProperty("identificador",identificador);
		defineObsProperty("qtPeixesCarregados", 0);
        defineObsProperty("quantMaxCarga", quantMaxCarga);
        defineObsProperty("motor",         "desligado");
        defineObsProperty("ancora",		   "noBarco");
        defineObsProperty("redes",         "noBarco");
        defineObsProperty("capacRede",      capacRede);
	}

	@OPERATION 
	void incrementaTripulacao(int idBarco, String nomeAgent){
		int qtTripulacao = (Integer) getObsProperty("qtTripulacao").getValue();
	    ObsProperty prop = getObsProperty("qtTripulacao");
	    
	    if(qtTripulacao<=3){
	    	  prop.updateValue(prop.intValue()+1);
	  	    logger.info((Integer) getObsProperty("identificador").getValue()+": Novo membro:"+ nomeAgent +" da Tripulacão do Barco "+ idBarco +" adicionado");
	    }else{
	    	logger.info((Integer) getObsProperty("identificador").getValue()+": Tripulacao para o Barco esgotada!");
	    }
	}
	
	@OPERATION
	void ligar_motores(){
		ObsProperty prop = getObsProperty("motor");
		prop.updateValue("ligado");
		logger.info((Integer) getObsProperty("identificador").getValue()+": Motor barco ligado!");
	}
	
	@OPERATION
	void desligar_motores(){
		ObsProperty prop = getObsProperty("motor");
		prop.updateValue("desligado");
		logger.info((Integer) getObsProperty("identificador").getValue()+": Motor barco desligado!");
	}
	
	@OPERATION
	void soltar_ancora(){
		ObsProperty prop = getObsProperty("ancora");
		prop.updateValue("noMar");
		logger.info((Integer) getObsProperty("identificador").getValue()+": Ancora no mar!");
	}
	
	@OPERATION
	void puxar_ancora(){
		ObsProperty prop = getObsProperty("ancora");
		prop.updateValue("noBarco");
		logger.info((Integer) getObsProperty("identificador").getValue()+": Ancora no barco!");
	}
	
	@OPERATION
	void jogar_redes(){
		ObsProperty prop = getObsProperty("redes");
		prop.updateValue("noMar");
		logger.info((Integer) getObsProperty("identificador").getValue()+": Redes no mar!");
	}
	
	@OPERATION
	//Recebe o artefato Oceano por parâmetro
	void recolher_redes(ArtifactId idArtefato){
		int idBarco = (Integer) getObsProperty("identificador").getValue();
		int capRede = (Integer) getObsProperty("capacRede").getValue();
		int qtPeixesCarreg = (Integer) getObsProperty("qtPeixesCarregados").getValue();
		
		ObsProperty prop = getObsProperty("redes");
		ObsProperty prop2 = getObsProperty("qtPeixesCarregados");
		
		OpFeedbackParam<Integer> peixes = new OpFeedbackParam<Integer>();

		try {
			execLinkedOp(idArtefato, "pescar_cardume", idBarco, capRede, peixes);
		} catch (OperationException e) {
			e.printStackTrace();
		}
		
		logger.info((Integer) getObsProperty("identificador").getValue()+": Peixes retirados do Oceano: "+peixes.get());
		
		prop.updateValue("noBarco");
		prop2.updateValue(qtPeixesCarreg + peixes.get());
		
		logger.info((Integer) getObsProperty("identificador").getValue()+": Redes no barco!");
		
		//logger.info((Integer) getObsProperty("identificador").getValue()+": Quantidade atual de Peixes no Barco: "+prop2.getValue());
	}
	
	@OPERATION
	void piloto_automatico(){
		try {
			Thread.sleep(2000);
		} catch (Exception e) {
			e.printStackTrace();
		}
		logger.info((Integer) getObsProperty("identificador").getValue()+": Piloto automático ligado!");
	}
	
	@OPERATION
	void navegando_para_porto(){
		try {
			Thread.sleep(3000);
		} catch (Exception e) {
			e.printStackTrace();
		}
		logger.info((Integer) getObsProperty("identificador").getValue()+": Navegando para o Porto!");
	}
	
	@OPERATION
	//Recebe o artefato Porto por parâmetro
	void colocar_peixes_porto(ArtifactId idArtefato){
		int idBarco = (Integer) getObsProperty("identificador").getValue();
		int qtCarga = (Integer) getObsProperty("qtPeixesCarregados").getValue();
		
		ObsProperty prop2 = getObsProperty("qtPeixesCarregados");

		if(qtCarga>0) {
			try {
				execLinkedOp(idArtefato, "receber_peixes_barco", idBarco, qtCarga);
			} catch (OperationException e) {
				e.printStackTrace();
			}
			
			prop2.updateValue(0);
			
			logger.info((Integer) getObsProperty("identificador").getValue()+": Peixes descarregados no Porto!");
		}
	}
	
}

