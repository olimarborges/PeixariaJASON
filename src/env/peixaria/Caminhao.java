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
	
	void init(int capacCarregador, int quantMaxCarga) {
		defineObsProperty("qtPeixesCarregados", 0);
        defineObsProperty("quantMaxCarga", quantMaxCarga, 0);
        defineObsProperty("motor",         "desligado");
        defineObsProperty("capacCarregador", capacCarregador);
	}

	@OPERATION
	void dirigindo_ate_porto(){
		try {
			Thread.sleep(2000);
		} catch (Exception e) {
			e.printStackTrace();
		}
		logger.info("Caminhão indo em direção ao Porto!");
	}
	
	@OPERATION
	void dirigindo_ate_distribuidor(){
		try {
			Thread.sleep(2000);
		} catch (Exception e) {
			e.printStackTrace();
		}
		logger.info("Caminhão indo em direção ao Distribuidor!");
	}
	
	@OPERATION
	void verificando_rota_gps(){
		try {
			Thread.sleep(2000);
		} catch (Exception e) {
			e.printStackTrace();
		}
		logger.info("Verificando rota no GPS até o Distribuidor!");
	}
	
	@OPERATION
	void localizando_carregamento(){
		try {
			Thread.sleep(2000);
		} catch (Exception e) {
			e.printStackTrace();
		}
		logger.info("Carregadores localizando carregamento disponível no Porto!");
	}
	
	@OPERATION
	void ligar_motores(){
		ObsProperty prop = getObsProperty("motor");
		prop.updateValue("ligado");
		logger.info("Motor caminhão ligado!");	
	}
	
	@OPERATION
	void desligar_motores(){
		ObsProperty prop = getObsProperty("motor");
		prop.updateValue("desligado");
		logger.info("Motor caminhão desligado!");
	}
	
	@OPERATION
	//Recebe o artefato Porto por parâmetro
	void carregar_caminhao(ArtifactId idArtefato){
		int qtPeixesCarreg = (Integer) getObsProperty("qtPeixesCarregados").getValue();
		
		int capacCarregador = (Integer) getObsProperty("capacCarregador").getValue();

		ObsProperty prop2 = getObsProperty("qtPeixesCarregados");
		ObsProperty prop3 = getObsProperty("quantMaxCarga");
		
		OpFeedbackParam<Integer> peixes = new OpFeedbackParam<Integer>();

		try {
			execLinkedOp(idArtefato, "carregar_peixes_caminhao", capacCarregador, peixes);
		} catch (OperationException e) {
			e.printStackTrace();
		}
		
		logger.info("Peixes retirados do Porto: "+peixes.get());
		
		prop2.updateValue(qtPeixesCarreg + peixes.get());
		prop3.updateValue(1, (Integer) prop2.getValue());		
		
		logger.info("Caminhão carregado!");
	}
	
	@OPERATION
	//Recebe o artefato Distribuidor por parâmetro
	void descarregar_peixes_distribuidor(ArtifactId idArtefato){
		int qtCarga = (Integer) getObsProperty("quantMaxCarga").getValue();
		
		ObsProperty prop = getObsProperty("quantMaxCarga");
		ObsProperty prop2 = getObsProperty("qtPeixesCarregados");
		
		if(qtCarga>0) {
			try {
				execLinkedOp(idArtefato, "receber_carregamento_peixes", qtCarga);
			} catch (OperationException e) {
				e.printStackTrace();
			}

			prop2.updateValue(0);			
			prop.updateValue(1, (Integer) prop2.getValue());	
			
			logger.info("Peixes descarregados no Distribuidor!");
		}	
	}
	
}

