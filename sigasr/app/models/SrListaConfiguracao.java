package models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import br.gov.jfrj.siga.model.Objeto;

@Entity
@Table(name = "SR_LISTA_CONFIGURACAO", schema = "SIGASR")
public class SrListaConfiguracao extends Objeto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4294951006856174150L;

	@Id
	@SequenceGenerator(sequenceName = "SIGASR.SR_LISTA_CONFIGURACAO_SEQ", name = "srListaConfiguracaoSeq")
	@GeneratedValue(generator = "srListaConfiguracaoSeq")
	@Column(name = "ID_LISTA_CONFIGURACAO")
	public Long idListaConfiguracao;
	
	@ManyToOne
	@JoinColumn(name = "ID_CONFIGURACAO")
	public SrConfiguracao configuracao;
	
	@ManyToOne
	@JoinColumn(name = "ID_LISTA")
	public SrLista lista;
	
	public Long getId() {
		return this.idListaConfiguracao;
	}

	public void setId(Long id) {
		idListaConfiguracao = id;
	}
	
	/**
	 * Classe que representa um V.O. de {@link SrListaConfiguracao}.
	 */
	public class SrListaConfiguracaoVO {
		
		public Long idLista;
		public String nomeLista;
		public Long idListaConfiguracao;
		
		public SrListaConfiguracaoVO(Long idLista, String nomeLista, Long idListaConfiguracao) {
			this.idLista = idLista;
			this.nomeLista = nomeLista;
			this.idListaConfiguracao = idListaConfiguracao;
		}
	}
	
	public SrListaConfiguracaoVO toVO() {
		if (this.lista != null)
			return new SrListaConfiguracaoVO(this.lista.idLista, this.lista.nomeLista, this.idListaConfiguracao);
		else
			return null;
	}

}