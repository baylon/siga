package br.gov.jfrj.siga.ex.ext;

import java.util.Date;

import br.gov.jfrj.siga.ex.ExDocumento;
import br.gov.jfrj.siga.ex.bl.ExCompetenciaBL;
import br.gov.jfrj.siga.hibernate.ExDao;

public class ExNumeradorDefault implements ExNumerador {

	@Override
	public ExDocumento numerar(ExDocumento doc, ExDao dao, ExCompetenciaBL comp)
			throws Exception {
		doc.setAnoEmissao(Long.valueOf(new Date().getYear()) + 1900);

		Long num = dao.obterProximoNumero(doc, doc.getAnoEmissao());

		if (num == null) {
			// Verifica se reiniciar a numeração ou continua com a numeração
			// anterior
			if (comp.podeReiniciarNumeracao(doc)) {
				num = 1L;
			} else {
				// Obtém o próximo número considerando os anos anteriores até
				// 2006
				Long anoEmissao = doc.getAnoEmissao();
				while (num == null && anoEmissao > 2005) {
					anoEmissao = anoEmissao - 1;
					num = dao.obterProximoNumero(doc, anoEmissao);
				}
				// Se continuar null é porque nunca foi criado documento para
				// este formato.
				if (num == null)
					num = 1L;
			}
		}

		if (doc.getNumExpediente() == null)
			doc.setNumExpediente(num);

		if (doc.getExMobilPai() != null) {
			if (doc.getExMobilPai().doc().isProcesso() && doc.isProcesso()) {
				int n = dao.obterProximoNumeroSubdocumento(doc.getExMobilPai());
				doc.setNumSequencia(n);
			}
		}

		return doc;
	}

	@Override
	public String compactarNumero(String numeroExpandido) {
		if (numeroExpandido == null)
			return null;
		return numeroExpandido.replace("-", "").replace("/", "");
	}

	@Override
	public String expandirNumero(String numeroCompactado) {
		// TODO Auto-generated method stub
		return null;
	}

}
