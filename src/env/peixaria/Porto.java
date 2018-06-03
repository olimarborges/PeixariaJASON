// CArtAgO artifact code for project peixaria

package peixaria;

import java.util.logging.Logger;

import cartago.*;

public class Porto extends Artifact {
	
	private Logger logger = Logger.getLogger("porto."+Porto.class.getName());
	
	void init() {
		defineObsProperty("qtPeixesArmazenado", 100);
	}
	
	@OPERATION
	void receber_peixes_barco(int idBarco, int qtCarga){//, OpFeedbackParam<Integer> peixes){
		logger.info("Recebendo carregamento de peixes do Barco "+idBarco);
		int novaCapacidade = 0;
		int qtPeixesArmazenado = (Integer) getObsProperty("qtPeixesArmazenado").getValue();
		
		novaCapacidade = qtPeixesArmazenado + qtCarga;
		updateObsProperty("qtPeixesArmazenado", novaCapacidade); //adiciona a qtCarga de peixes que um barco descarregou
		    	
		logger.info("Quantidade total de peixes no Porto: "+novaCapacidade);
		signal("novosPeixesPorto");
	}
	
	//peixes é a quantidade de peixes retirados do Porto para o Caminhão
	@OPERATION
	void carregar_peixes_caminhao(int idCaminhao, int capacidadeCarregador, OpFeedbackParam<Integer> peixes){
		logger.info("Achou carregamento de peixes para o Caminhão "+idCaminhao);
		int novaCapacidade = 0;
		int qtPeixesArmazenado = (Integer) getObsProperty("qtPeixesArmazenado").getValue();
		
		if(qtPeixesArmazenado<capacidadeCarregador) {
			updateObsProperty("qtPeixesArmazenado", 0); //retira tudo
			peixes.set(qtPeixesArmazenado);
		}else {
			novaCapacidade = qtPeixesArmazenado - capacidadeCarregador;
			updateObsProperty("qtPeixesArmazenado", novaCapacidade);
			peixes.set(capacidadeCarregador);
		}
		    	
		logger.info("Peixes disponíveis ainda no Porto: "+novaCapacidade);
	}
	
}

