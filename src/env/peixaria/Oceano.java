// CArtAgO artifact code for project peixaria

package peixaria;

import java.util.logging.Logger;

import cartago.Artifact;
import cartago.OPERATION;
import cartago.OpFeedbackParam;

public class Oceano extends Artifact {
	
		
	private Logger logger = Logger.getLogger("oceano."+Oceano.class.getName());
	
	void init(int qtPeixesDisponivel) {
		defineObsProperty("qtPeixesDisponivel", qtPeixesDisponivel);
	}
	
	//peixes é a quantidade de peixes retirados do aceano para o barco
	@OPERATION
	void pescar_cardume(int capacidadeRede, OpFeedbackParam<Integer> peixes){
		logger.info("Achou Cardume!");
		int novaCapacidade = 0;
		int qtPeixesDisponivel = (Integer) getObsProperty("qtPeixesDisponivel").getValue();
		if(qtPeixesDisponivel<capacidadeRede) {
			updateObsProperty("qtPeixesDisponivel", 0); //retira tudo
			peixes.set(qtPeixesDisponivel);
		}else {
			novaCapacidade = qtPeixesDisponivel - capacidadeRede;
			updateObsProperty("qtPeixesDisponivel", novaCapacidade); //retira 25 peixes da qt total
			peixes.set(capacidadeRede);
		}
		    	
		logger.info("Peixes disponíveis no mar: "+novaCapacidade);
	}
	
	
}

