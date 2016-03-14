package br.gov.jfrj.siga.ex.ext;

import br.gov.jfrj.siga.ex.ExDocumento;
import br.gov.jfrj.siga.ex.bl.ExCompetenciaBL;
import br.gov.jfrj.siga.hibernate.ExDao;

public interface ExNumerador {
	/**
	 * Recebe um documento temporário, calcula o número que ele deve receber
	 * somando 1 ao número do último documento da mesma serie e altera os dados
	 * documento para refletir a numeração.
	 * 
	 * @param ExDocumento
	 *            doc: Documento temporário que será alterado para refletir a
	 *            numeração
	 * @return
	 * @throws Exception
	 */
	public ExDocumento numerar(ExDocumento doc, ExDao dao, ExCompetenciaBL comp)
			throws Exception;

	public String compactarNumero(String numeroExpandido);

	public String expandirNumero(String numeroCompactado);
}
