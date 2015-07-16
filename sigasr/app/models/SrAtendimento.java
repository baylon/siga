package models;

import java.text.SimpleDateFormat;
import java.util.Date;

import br.gov.jfrj.siga.dp.CpOrgaoUsuario;
import br.gov.jfrj.siga.dp.DpLotacao;
import br.gov.jfrj.siga.dp.DpPessoa;


public class SrAtendimento implements Comparable<SrAtendimento> {

	private SrSolicitacao solicitacao;
	private Date dataInicio;
	private Date dataFinal;
	private SrValor tempoAtendimento;
	private SrFaixa faixa;
	private DpLotacao lotacaoAtendente;
	private DpLotacao lotacaoAtendenteDestino;
	private DpPessoa pessoaAtendente;
	private String tipoAtendimento;
	private String itemConfiguracao;
	private String acao;
	
	public SrAtendimento(SrSolicitacao solicitacao, Date dataInicio,
			Date dataFinal, SrValor tempoAtendimento,
			DpLotacao lotacaoAtendente, DpPessoa pessoaAtendente,
			String tipoAtendimento) {
		this.solicitacao = solicitacao;
		this.dataInicio = dataInicio;
		this.dataFinal = dataFinal;
		this.tempoAtendimento = tempoAtendimento;
		this.lotacaoAtendente = lotacaoAtendente;
		this.pessoaAtendente = pessoaAtendente;
		this.tipoAtendimento = tipoAtendimento;
	}
	
	public SrAtendimento() {
		
	}

	public SrSolicitacao getSolicitacao() {
		return solicitacao;
	}

	public Date getDataInicio() {
		return dataInicio;
	}

	public Date getDataFinal() {
		return dataFinal;
	}

	public SrValor getTempoAtendimento() {
		return tempoAtendimento;
	}

	public SrFaixa getFaixa() {
		return faixa;
	}

	public DpLotacao getLotacaoAtendente() {
		return lotacaoAtendente;
	}	
	
	public DpPessoa getPessoaAtendente() {
		return pessoaAtendente;
	}
	
	public String getItemConfiguracao() {
		return itemConfiguracao;
	}

	public void setItemConfiguracao(String itemConfiguracao) {
		this.itemConfiguracao = itemConfiguracao;
	}

	public void setSolicitacao(SrSolicitacao solicitacao) {
		this.solicitacao = solicitacao;
	}

	public void setDataInicio(Date dataInicio) {
		this.dataInicio = dataInicio;
	}

	public void setDataFinal(Date dataFinal) {
		this.dataFinal = dataFinal;
	}

	public void setTempoAtendimento(SrValor tempoAtendimento) {
		this.tempoAtendimento = tempoAtendimento;
	}

	public void setFaixa(SrFaixa faixa) {
		this.faixa = faixa;
	}

	public void setLotacaoAtendente(DpLotacao lotacaoAtendente) {
		this.lotacaoAtendente = lotacaoAtendente;
	}
	
	public void setPessoaAtendente(DpPessoa pessoaAtendente) {
		this.pessoaAtendente = pessoaAtendente;
	}
	
	public DpLotacao getLotacaoAtendenteDestino() {
		return lotacaoAtendenteDestino;
	}

	public void setLotacaoAtendenteDestino(DpLotacao lotacaoAtendenteDestino) {
		this.lotacaoAtendenteDestino = lotacaoAtendenteDestino;
	}
	
	public String getTipoAtendimento() {
		return tipoAtendimento;
	}

	public void setTipoAtendimento(String tipoAtendimento) {
		this.tipoAtendimento = tipoAtendimento;
	}
	
	public String getAcao() {
		return acao;
	}

	public void setAcao(String acao) {
		this.acao = acao;
	}

	public String getDataInicioDDMMYYYYHHMMSS() {
		if (dataInicio != null) {
			final SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			return df.format(dataInicio);
		}
		return "";
	}
	
	public String getDataFinalDDMMYYYYHHMMSS() {
		if (dataFinal != null) {
			final SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			return df.format(dataFinal);
		}
		return "";
	}
	
	public enum SrFaixa {		
		ATE_1(1, "Ate 1 horas"), ATE_2(2, "Ate 2 horas"), ATE_4(3, "Ate 4 horas"), 
		ATE_8(4, "Ate 8 horas"), ATE_12(5, "Ate 12 horas"),ATE_16(6, "Ate 16 horas"), 
		ATE_24(7, "Ate 24 horas"), ACIMA_24(8, "Acima de 24 horas"), ATE_15MIN(9, "Ate 15 minutos"),
		ATE_3(10, "Ate 3 horas"), ATE_15(11, "Ate 15 horas"), ACIMA_15(12, "Acima de 15 horas");
		
		public int idFaixa;
		public String descricao;
		
		private SrFaixa(int idFaixa, String descricao) {
			this.idFaixa = idFaixa;
			this.descricao = descricao;
		}
	}
	
	public SrFaixa definirFaixaDeHoras(CpOrgaoUsuario orgao) {
		if (tempoAtendimento != null) {
			if (orgao.getAcronimoOrgaoUsu().equals("JFRJ"))	
				return definirFaixaJFRJ(tempoAtendimento.getValorEmHora());
			else
				return definirFaixaTRF(tempoAtendimento.getValorEmHora());
		}
		return null;
	}
	
	private SrFaixa definirFaixaTRF(float horas) {
		if (horas <= 0.25)
			return SrFaixa.ATE_15MIN;
		else if (horas > 0.25 && horas <= 1)
			return SrFaixa.ATE_1;
		else if (horas > 1 && horas <= 3)
			return SrFaixa.ATE_3;
		else if (horas > 3 && horas <= 8)
			return SrFaixa.ATE_8;
		else if (horas > 8 && horas <= 15)
			return SrFaixa.ATE_15;
		else
			return SrFaixa.ACIMA_15;
	}
	
	private SrFaixa definirFaixaJFRJ(float horas) {
		if (horas <= 1)
			return SrFaixa.ATE_1;
		else if (horas > 1 && horas <= 2)
			return SrFaixa.ATE_2;
		else if (horas > 2 && horas <= 4)
			return SrFaixa.ATE_4;
		else if (horas > 4 && horas <= 8)
			return SrFaixa.ATE_8;
		else if (horas > 8 && horas <= 12)
			return SrFaixa.ATE_12;
		else if (horas > 12 && horas <= 16)
			return SrFaixa.ATE_16;
		else if (horas > 16 && horas <= 24)
			return SrFaixa.ATE_24;
		else
			return SrFaixa.ACIMA_24;
	}
	@Override
	public int compareTo(SrAtendimento o) {
		if (this != null && o != null) {
			if (this.getTempoAtendimento() == null || o.getTempoAtendimento() == null || 
					this.getTempoAtendimento().toString().equals(o.getTempoAtendimento().toString())) {
				if (this.getSolicitacao().codigo.equals(o.getSolicitacao().codigo))
					return this.getDataInicio().compareTo(o.getDataInicio());
				else
					return this.getSolicitacao().codigo.compareTo(o.getSolicitacao().codigo);
			} 
			return this.getTempoAtendimento().compareTo(o.getTempoAtendimento());
		}
		return 0;
	}
	
}