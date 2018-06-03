// CArtAgO artifact code for project peixaria

package peixaria;

import java.util.Random;
import java.util.logging.Logger;

import cartago.Artifact;
import cartago.OPERATION;
import cartago.OpFeedbackParam;

public class Oceano extends Artifact {
	
		
	private Logger logger = Logger.getLogger("oceano."+Oceano.class.getName());
	
	void init(int qtPeixesDisponivel) {
		defineObsProperty("qtPeixesDisponivel", qtPeixesDisponivel);
	}
	
	//Pede aos Deuses por mais peixes no Oceano
	@OPERATION
	void precisamosPeixesOceano() {
		try {
			Thread.sleep(5000);
		} catch (Exception e) {
			e.printStackTrace();
		}
		Random valorAleatorio = new Random();
		//Gera uma nova quantidade de peixes para o Oceano entre 1000 e 10000 peixes
		int novaQuant = valorAleatorio.nextInt(10001) + 1000;
		logger.info("Nova Quantidade de Peixes no Oceano: "+ novaQuant);
		updateObsProperty("qtPeixesDisponivel", novaQuant);
		signal("novosPeixesOceano");
	}
	
	//peixes � a quantidade de peixes retirados do Oceano para o Barco
	@OPERATION
	void pescar_cardume(int idBarco, int capacidadeRede, OpFeedbackParam<Integer> peixes){
		logger.info("Barco "+ idBarco +" - Achou Cardume!");
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
		    	
		logger.info("Peixes dispon�veis no mar: "+novaCapacidade);
//		if((Integer) getObsProperty("qtPeixesDisponivel").getValue()==0) {
//			novosPeixesOceano();
//		}
	}
	
	
}

