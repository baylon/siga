/*******************************************************************************
 * Copyright (c) 2006 - 2011 SJRJ.
 * 
 *     This file is part of SIGA.
 * 
 *     SIGA is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 * 
 *     SIGA is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 * 
 *     You should have received a copy of the GNU General Public License
 *     along with SIGA.  If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/
package br.gov.jfrj.siga.gc.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.jws.WebService;
import javax.persistence.EntityManagerFactory;
import javax.persistence.TypedQuery;

import br.gov.jfrj.siga.gc.model.GcInformacao;
import br.gov.jfrj.siga.gc.model.GcTag;
import br.gov.jfrj.siga.gc.service.GcService;
import br.gov.jfrj.siga.model.ContextoPersistencia;

/**
 * Classe que representa o webservice do workflow. O SIGA-DOC faz a chamada
 * remota dos métodos dessa classe para atualizar o workflow automaticamente,
 * baseando-se nas operações sobre documentos.
 * 
 * @author kpf
 * 
 */
@WebService(serviceName = "GcService", endpointInterface = "br.gov.jfrj.siga.gc.service.GcService", targetNamespace = "http://impl.service.gc.siga.jfrj.gov.br/")
public class GcServiceImpl implements GcService {
	private EntityManagerFactory factory;

	@PostConstruct
	public void init() {

	}

	@PreDestroy
	public void destroy() {

	}

	@Override
	/**
	 * O padrão para tags atualizaveis segue o seguinte exemplo:
	 * @sr-item-1-123:sistemas
	 * @sr-item-2-213:siga
	 * @sr-item-3-241:siga-doc
	 * 
	 * categoria: sr-item
	 * id: 123
	 * titulos: sistemas,siga,siga-doc
	 */
	public Integer atualizarTag(String tags) throws Exception {
		String atags[] = tags.split(",\\s*");

		Matcher matcher = GcTag.tagPattern.matcher(atags[atags.length - 1]);
		if (!matcher.find()) {
			throw new Exception("Tag inválido. Deve seguir o padrão: "
					+ GcTag.tagPattern.toString());
		}
		String grupo = matcher.group(1);
		Integer indice = (matcher.group(2) != null) ? Integer.parseInt(matcher
				.group(2)) : null;
		String id = matcher.group(3);
		String titulo = matcher.group(4);

		int count = 0;
		TypedQuery<GcInformacao> q = ContextoPersistencia.em().createQuery(
				"select distinct inf from GcInformacao as inf join inf.tags tag"
						+ " where tag.categoria like :categoria",
				GcInformacao.class);
		q.setParameter("categoria", grupo + "-%-" + id);
		List<GcInformacao> infs = q.getResultList();

		count = atualizarTagAlg(grupo, indice, id, titulo,
				Arrays.copyOf(atags, atags.length - 1), infs);

		return count;
	}

	protected int atualizarTagAlg(String grupo, Integer indice, String id,
			String titulo, String[] anteriores, List<GcInformacao> infs)
			throws Exception {

		int count;
		count = infs.size();

		for (GcInformacao inf : infs) {
			GcTag tagAtualizar = null;
			for (GcTag t : inf.getTags()) {
				if (grupo.equals(t.getHierarquiaGrupo())
						&& id.equals(t.getHierarquiaId()))
					tagAtualizar = t;
			}
			if (tagAtualizar != null) {
				Integer indiceOriginal = tagAtualizar.getIndice();

				// Alteração de título
				if (!tagAtualizar.getTitulo().equals(titulo))
					tagAtualizar.setTitulo(titulo);

				// Alteração de índice
				if (!indiceOriginal.equals(indice)) {
					// Remover anteriores
					List<GcTag> remover = new ArrayList<>();
					for (GcTag t : inf.getTags()) {
						if (grupo.equals(t.getHierarquiaGrupo())
								&& indiceOriginal.compareTo(t.getIndice()) > 0)
							remover.add(t);
					}
					inf.getTags().removeAll(remover);

					// Reindexar posteriores

					// Atualizar o tag
					tagAtualizar.setIndice(indice);

					// Inserir tags anteriores informados
					//
					for (String s : anteriores) {
						GcTag ta = GcTag.getInstance(s, remover, true);
						inf.getTags().add(ta);
					}

				}
			}
		}
		return count;
	}

}