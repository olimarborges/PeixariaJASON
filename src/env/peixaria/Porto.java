// CArtAgO artifact code for project peixaria

package peixaria;

import java.util.logging.Logger;

import cartago.Artifact;
import cartago.OPERATION;
import cartago.ObsProperty;
import cartago.OpFeedbackParam;

public class Porto extends Artifact {
	
	private Logger logger = Logger.getLogger("porto."+Porto.class.getName());
	
	void init() {
		defineObsProperty("qtPeixesArmazenado", 0);
		defineObsProperty("qtRecebidaPeixes", 0);
		defineObsProperty("qtRecebidaRetirados", 0);
		defineObsProperty("histPeixesArmazenado", 0);
		defineObsProperty("histPeixesRetirados", 0);
	}
	
	@OPERATION
	void contadorPeixesArmazenados(int qtRecebida) {
	    ObsProperty prop = getObsProperty("qtRecebidaPeixes");
	    prop.updateValue(prop.intValue()+qtRecebida);
	    int qtPeixesRecebidaDosBarcos = (Integer) getObsProperty("qtRecebidaPeixes").getValue();
	    logger.info("Total de peixes recebida dos Barcos até o momento: "+qtPeixesRecebidaDosBarcos);
	}
	
	@OPERATION
	void contadorPeixesRetirados(int qtRetirada) {
	    ObsProperty prop = getObsProperty("qtRecebidaRetirados");
	    prop.updateValue(prop.intValue()+qtRetirada);
	    int qtPeixesRetirados = (Integer) getObsProperty("qtRecebidaRetirados").getValue();
	    logger.info("Total de peixes retirados do Porto até o momento: "+qtPeixesRetirados);
	}
	
	@OPERATION
	void receber_peixes_barco(int idBarco, int qtCarga){//, OpFeedbackParam<Integer> peixes){
		logger.info("Recebendo carregamento de peixes do Barco "+idBarco);
		int novaCapacidade = 0;
		int qtPeixesArmazenado = (Integer) getObsProperty("qtPeixesArmazenado").getValue();
		int histPeixesArmazenado = (Integer) getObsProperty("histPeixesArmazenado").getValue();
		int totalHistorico = 0;
		
		novaCapacidade = qtPeixesArmazenado + qtCarga;
		updateObsProperty("qtPeixesArmazenado", novaCapacidade); //adiciona a qtCarga de peixes que um barco descarregou
		
		totalHistorico = histPeixesArmazenado + qtCarga;
		updateObsProperty("histPeixesArmazenado", totalHistorico);     	
		
		logger.info("Quantidade total de peixes no Porto: "+novaCapacidade);
		logger.info("HISTÓRICO de Peixes Carregados no PORTO: "+ totalHistorico);
		
		signal("novosPeixesPorto");
	}
	
	//peixes é a quantidade de peixes retirados do Porto para o Caminhão
	@OPERATION
	void carregar_peixes_caminhao(int idCaminhao, int capacidadeCarregador, OpFeedbackParam<Integer> peixes){
		logger.info("Achou carregamento de peixes para o Caminhão "+idCaminhao);
		int novaCapacidade = 0;
		int qtPeixesArmazenado = (Integer) getObsProperty("qtPeixesArmazenado").getValue();
		int histPeixesRetirados = (Integer) getObsProperty("histPeixesRetirados").getValue();
		int totalHistorico = 0;
		
		if(qtPeixesArmazenado<capacidadeCarregador) {
			updateObsProperty("qtPeixesArmazenado", 0); //retira tudo
			peixes.set(qtPeixesArmazenado);
			totalHistorico = histPeixesRetirados + qtPeixesArmazenado;
			updateObsProperty("histPeixesRetirados", totalHistorico);
		}else {
			novaCapacidade = qtPeixesArmazenado - capacidadeCarregador;
			updateObsProperty("qtPeixesArmazenado", novaCapacidade);
			peixes.set(capacidadeCarregador);
			totalHistorico = histPeixesRetirados + capacidadeCarregador;
			updateObsProperty("histPeixesRetirados", totalHistorico);
		}
		
		
		logger.info("Peixes disponíveis ainda no Porto: "+novaCapacidade);
		logger.info("HISTÓRICO de Peixes Retirados do PORTO: "+ totalHistorico);
		
	}
	
}

