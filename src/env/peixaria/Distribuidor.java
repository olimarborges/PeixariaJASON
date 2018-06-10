// CArtAgO artifact code for project peixaria

package peixaria;

import java.util.logging.Logger;

import cartago.Artifact;
import cartago.OPERATION;

public class Distribuidor extends Artifact {
	
	private Logger logger = Logger.getLogger("distribuidor."+Distribuidor.class.getName());
	
	void init() {
		defineObsProperty("qtPeixesArmazenadoDis", 0);
	}

	@OPERATION
	void receber_carregamento_peixes(int qtCarga){
		logger.info("Recebendo carregamento de peixes do caminhão!");
		int novaCapacidade = 0;
		int qtPeixesArmazenado = (Integer) getObsProperty("qtPeixesArmazenadoDis").getValue();

//		logger.info("qtCarga: "+qtCarga);
//		logger.info("qtPeixesArmazenado: "+qtPeixesArmazenado);
		
		novaCapacidade = qtPeixesArmazenado + qtCarga;
		updateObsProperty("qtPeixesArmazenadoDis", novaCapacidade); //adiciona a qtCarga de peixes que um caminhão descarregou
		
		logger.info("Quantidade total de peixes no Distribuidor "+novaCapacidade);
		    	
		//logger.info("Quantidade total de peixes no Distribuidor: "+novaCapacidade);
		logger.info("HISTÓRICO de Peixes Armazenados no DISTRIBUIDOR:" + novaCapacidade);
	}	
	
}

