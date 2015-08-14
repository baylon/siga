<%@ page language="java" contentType="text/html; charset=UTF-8"buffer="128kb"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://localhost/customtag" prefix="tags"%>
<%@ taglib uri="http://localhost/jeetags" prefix="siga"%>
<%@ taglib uri="http://localhost/functiontag" prefix="f"%>

<siga:pagina titulo="Novo Documento">
<script type="text/javascript" src="/ckeditor/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="../../../javascript/exDocumentoEdita.js"></script>
<script type="text/javascript" src="/siga/javascript/jquery.blockUI.js"></script>
<div class="gt-bd clearfix">
	<div class="gt-content clearfix">
	
		<h2>
			<c:choose>
				<c:when test='${empty exDocumentoDTO.doc}'>
					Novo Documento
				</c:when>
				<c:otherwise>
					<span id="codigoDoc">${exDocumentoDTO.doc.codigo}</span>
					<!-- de: <span id="dataDoc">${exDocumentoDTO.doc.dtRegDocDDMMYY}</span>-->
				</c:otherwise>
			</c:choose>
		</h2>
				
		<div class="gt-content-box gt-for-table">
			<form id="frm" name="frm" theme="simple" method="post" enctype="multipart/form-data">
				<input type="hidden" id="idTamanhoMaximoDescricao" name="exDocumentoDTO.tamanhoMaximoDescricao" value="${exDocumentoDTO.tamanhoMaximoDescricao}" />
				<input type="hidden" id="alterouModelo" name="alterouModelo" />
				<input type="hidden" name="postback" value="1" />
				<input type="hidden" id="sigla" name="exDocumentoDTO.sigla" value="${exDocumentoDTO.sigla}" />
				<input type="hidden" name="exDocumentoDTO.nomePreenchimento" value="" />
				<input type="hidden" name="campos" value="despachando" />
				<input type="hidden" name="exDocumentoDTO.despachando" value="${exDocumentoDTO.despachando}" />
				<input type="hidden" name="campos" value="criandoAnexo" />
				<input type="hidden" name="campos" value="autuando" />
				<input type="hidden" name="exDocumentoDTO.autuando" value="${exDocumentoDTO.autuando}" />
				<input type="hidden" name="exDocumentoDTO.criandoAnexo" value="${exDocumentoDTO.criandoAnexo}" />
				<input type="hidden" name="campos" value="idMobilAutuado" />
				<input type="hidden" name="exDocumentoDTO.idMobilAutuado" value="${exDocumentoDTO.idMobilAutuado}" />

				<table class="gt-form-table">
					<tr class="header">
						<c:choose>
							<c:when test='${empty exDocumentoDTO.doc}'>
								<td colspan="4">Novo Documento</td>
							</c:when>
							<c:otherwise>
								<td colspan="4">Dados básicos:</td>
							</c:otherwise>
						</c:choose>
					</tr>

					<c:choose>
						<c:when test="${(exDocumentoDTO.doc.eletronico) && (exDocumentoDTO.doc.numExpediente != null)}">
							<c:set var="estiloTipo" value="display: none" />
							<c:set var="estiloTipoSpan" value="" />
						</c:when>
						<c:otherwise>
							<c:set var="estiloTipo" value="" />
							<c:set var="estiloTipoSpan" value="display: none" />
						</c:otherwise>
					</c:choose>

					<input type="hidden" name="campos" value="idTpDoc" />
					<tr>


						<td width="10%">Origem:</td>
						<td width="10%">
						
							<select  name="exDocumentoDTO.idTpDoc" onchange="javascript:document.getElementById('alterouModelo').value='true';sbmt();" cssStyle="${estiloTipo}">
								<c:forEach items="${exDocumentoDTO.tiposDocumento}" var="item">
									<option value="${item.idTpDoc}" ${item.idTpDoc == exDocumentoDTO.idTpDoc ? 'selected' : ''}>
										${item.descrTipoDocumento}
									</option>  
								</c:forEach>
							</select>&nbsp;												
								 
							<span style="${estiloTipoSpan}">${exDocumentoDTO.doc.exTipoDocumento.descrTipoDocumento}</span>
						</td>
						<td width="5%" align="right">Data:</td>
						<input type="hidden" name="campos" value="dtDocString" />
						<td>
							<input type="text" name="exDocumentoDTO.dtDocString" size="10" onblur="javascript:verifica_data(this, true);" value="${exDocumentoDTO.dtDocString}" /> &nbsp;&nbsp; 
						
							<input type="hidden" name="campos" value="nivelAcesso" />
							
							Acesso 
							<select  name="exDocumentoDTO.nivelAcesso" >
								<c:forEach items="${exDocumentoDTO.listaNivelAcesso}" var="item">
									<option value="${item.idNivelAcesso}" ${item.idNivelAcesso == exDocumentoDTO.nivelAcesso ? 'selected' : ''}>
										${item.nmNivelAcesso}
									</option>  
								</c:forEach>
							</select>								 
							
							<input type="hidden" name="campos" value="eletronico" /> 
								
							<c:choose>
								<c:when test="${exDocumentoDTO.eletronicoFixo}">
									<input type="hidden" name="exDocumentoDTO.eletronico" id="eletronicoHidden" value="${exDocumentoDTO.eletronico}" />
									${exDocumentoDTO.eletronicoString}
									<c:if test="${exDocumentoDTO.eletronico == 2}">
										<script type="text/javascript">
											$("html").addClass("fisico");
										</script>
									</c:if>
								</c:when>
								<c:otherwise>
								    <input type="radio" name="exDocumentoDTO.eletronico" id="eletronicoCheck1" value="1" 
								    	onchange="javascript:setFisico();" 
								    	<c:if test="${exDocumentoDTO.eletronicoFixo}">disabled</c:if>
								    	<c:if test="${exDocumentoDTO.eletronico == 1}">checked</c:if>	
								    />
								    <label for="eletronicoCheck1">Digital</label>
								    
								    <input type="radio" name="exDocumentoDTO.eletronico" id="eletronicoCheck2" value="2" 
								    	onchange="javascript:setFisico();" 
								    	<c:if test="${exDocumentoDTO.eletronicoFixo}">disabled</c:if>
								    	<c:if test="${exDocumentoDTO.eletronico == 2}">checked</c:if>
								    />
								    <label for="eletronicoCheck2">Físico</label>
								    
									<script type="text/javascript">
										function setFisico() {
											if ($('input[name=exDocumentoDTO\\.eletronico]:checked').val() == 2)
												$('html').addClass('fisico'); 
											else 
												$('html').removeClass('fisico');
										}; 
										setFisico();
									</script>									
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<c:if test='${exDocumentoDTO.tipoDocumento == "antigo"}'>
						<tr>
							<td>Nº original:</td>
							<input type="hidden" name="campos" value="numExtDoc" />
							<td colspan="3">
								<input type="text" name="exDocumentoDTO.numExtDoc" size="16" maxLength="32" value="${exDocumentoDTO.numExtDoc}"/>
							</td>
						</tr>
						<tr style="font-weight: bold">
							<td>Nº antigo:</td>
							<input type="hidden" name="campos" value="numAntigoDoc" />
							<td colspan="3">
								<input type="text" name="exDocumentoDTO.numAntigoDoc" size="16" maxLength="32" value="${exDocumentoDTO.numAntigoDoc}"/> 
								(informar o número do documento no antigo sistema de controle de expedientes ou de processos administrativos [SISAPA] ou [PROT])
							</td>
						</tr>
					</c:if>
					<c:if test='${exDocumentoDTO.tipoDocumento == "externo"}'>
						<tr>
							<td>Data original do documento:</td>
							<input type="hidden" name="campos" value="dtDocOriginalString" />
							<td colspan="3">
								<input type="text" name="exDocumentoDTO.dtDocOriginalString" size="10" onblur="javascript:verifica_data(this, true);" value="${exDocumentoDTO.dtDocOriginalString}"/>
							</td>
						</tr>
						<tr>
							<td>Nº original:</td>
							<input type="hidden" name="campos" value="numExtDoc" />
							<td>
								<input type="text" name="exDocumentoDTO.numExtDoc" size="32" maxLength="32" value="${exDocumentoDTO.numExtDoc}"/>
							</td>
							<td align="right">Órgão:</td>
							<input type="hidden" name="campos" value="cpOrgaoSel.id" />
							<td>
								<siga:selecao propriedade="cpOrgao" inputName="exDocumentoDTO.cpOrgao" tema="simple" modulo="siga"/>
							</td>
						</tr>
						<tr>
							<td>Obs. sobre o Órgão Externo:</td>
							<input type="hidden" name="campos" value="obsOrgao" />
							<td colspan="3">
								<input type="text" size="120" name="exDocumentoDTO.obsOrgao" maxLength="256" value="${exDocumentoDTO.obsOrgao}"/>
							</td>
						</tr>
						<tr>
							<td>Nº antigo:</td>
							<input type="hidden" name="campos" value="numAntigoDoc" />
							<td colspan="3">
								<input type="text" name="exDocumentoDTO.numAntigoDoc" size="32" maxLength="34" value="${exDocumentoDTO.numAntigoDoc}" /> 
								(informar o número do documento no antigo sistema de controle de expedientes, caso tenha sido cadastrado)
							</td>
						</tr>
					</c:if>
					<input type="hidden" name="exDocumentoDTO.desativarDocPai" value="${exDocumentoDTO.desativarDocPai}" />
					<tr style="display: none;">
						<td>Documento Pai:</td>
						<td colspan="3">
							<siga:selecao titulo="Documento Pai:" propriedade="mobilPai" inputName="exDocumentoDTO.mobilPai" tema="simple" modulo="sigaex" desativar="${exDocumentoDTO.desativarDocPai}" reler="sim" />
						</td>
					</tr>
<c:if test='${exDocumentoDTO.tipoDocumento != "capturado" }'>
					<tr>
						<c:choose>
							<c:when test='${exDocumentoDTO.tipoDocumento == "externo" or exDocumentoDTO.tipoDocumento == "capturado"}'>
								<td>Subscritor:</td>
								<input type="hidden" name="campos" value="nmSubscritorExt" />
								<td colspan="3">
									<input type="text" name="exDocumentoDTO.nmSubscritorExt" size="80" maxLength="256" value="${exDocumentoDTO.nmSubscritorExt}"/>
								</td>
							</c:when>
							<c:otherwise>
								<td>Subscritor:</td>
								<input type="hidden" name="campos" value="subscritorSel.id" />
								<input type="hidden" name="campos" value="substituicao" />
								<td colspan="3">
									<siga:selecao propriedade="subscritor" inputName="exDocumentoDTO.subscritor" modulo="siga" tema="simple" />&nbsp;&nbsp;
									<input type="checkbox" name="exDocumentoDTO.substituicao" onclick="javascript:displayTitular(this);"
										<c:if test="${exDocumentoDTO.substituicao}">checked</c:if>/>
									Substituto
								</td>
							</c:otherwise>
						</c:choose>
					</tr>
					<c:choose>
						<c:when test="${!exDocumentoDTO.substituicao}">
							<tr id="tr_titular" style="display: none">
						</c:when>
						<c:otherwise>
							<tr id="tr_titular" style="">
						</c:otherwise>
					</c:choose>

					<td>Titular:</td>
					<input type="hidden" name="campos" value="titularSel.id" />
					<td colspan="3">
						<siga:selecao propriedade="titular" inputName="exDocumentoDTO.titular" tema="simple" modulo="siga"/>
					</td>
					</tr>
					<tr>
						<td>Função;<br/>Lotação;<br/>Localidade:</td>
						<td colspan="3">
							<input type="hidden" name="campos" value="nmFuncaoSubscritor" />
							<input type="text" name="exDocumentoDTO.nmFuncaoSubscritor" size="50" maxlength="128" id="frm_nmFuncaoSubscritor" value="${exDocumentoDTO.nmFuncaoSubscritor}">							
							(Opcionalmente informe a função e a lotação na forma:
						Função;Lotação;Localidade)
						</td>
					</tr>
					
					<tr>
						<td>Destinatário:</td>
						<input type="hidden" name="campos" value="tipoDestinatario" />
						<td colspan="3">
							
							<select  name="exDocumentoDTO.tipoDestinatario" onchange="javascript:sbmt();">
								<c:forEach items="${exDocumentoDTO.listaTipoDest}" var="item">
									<option value="${item.key}" ${item.key == exDocumentoDTO.tipoDestinatario ? 'selected' : ''}>
										${item.value}
									</option>  
								</c:forEach>
							</select>			
							
							<siga:span id="destinatario" depende="tipoDestinatario">
								<c:choose>
									<c:when test='${exDocumentoDTO.tipoDestinatario == 1}'>
										<input type="hidden" name="campos" value="destinatarioSel.id" />
										<siga:selecao propriedade="destinatario" inputName="exDocumentoDTO.destinatario" tema="simple" reler="sim" modulo="siga" />
										<!--  idAjax="destinatario"  -->										    
									</c:when>
									<c:when test='${exDocumentoDTO.tipoDestinatario == 2}'>
										<input type="hidden" name="campos" value="lotacaoDestinatarioSel.id" />
										<siga:selecao propriedade="lotacaoDestinatario" inputName="exDocumentoDTO.lotacaoDestinatario" tema="simple" reler="sim" modulo="siga" />
										</td>			
										<!--  idAjax="destinatario" -->				   
									</c:when>
									<c:when test='${exDocumentoDTO.tipoDestinatario == 3}'>
										<input type="hidden" name="campos" value="orgaoExternoDestinatarioSel.id" />
										<siga:selecao propriedade="orgaoExternoDestinatario" inputName="exDocumentoDTO.orgaoExternoDestinatario" tema="simple" reler="sim" modulo="siga" />
										<!--  idAjax="destinatario" -->
										<br>
										<input type="text" name="exDocumentoDTO.nmOrgaoExterno" size="120" maxLength="256" value="${exDocumentoDTO.nmOrgaoExterno}"/>
										<input type="hidden" name="campos" value="nmOrgaoExterno" />
										</td>	
									</c:when>
									<c:otherwise>
										<input type="text" name="exDocumentoDTO.nmDestinatario" size="80" maxLength="256" value="${exDocumentoDTO.nmDestinatario}"/>
										<input type="hidden" name="campos" value="nmDestinatario" />
										</td>
									</c:otherwise>
								</c:choose>
							</siga:span>
					</tr>
</c:if>
					<%--</c:if>--%>


					<c:if test='${ exDocumentoDTO.tipoDocumento != "externo"}'>
						<tr>
							<td>Espécie:</td>
							<td colspan="3">
								<select  name="exDocumentoDTO.idFormaDoc" onchange="javascript:document.getElementById('alterouModelo').value='true';sbmt();" cssStyle="${estiloTipo}">
									<c:forEach items="${exDocumentoDTO.formasDoc}" var="item">
										<option value="${item.idFormaDoc}" ${item.idFormaDoc == exDocumentoDTO.idFormaDoc ? 'selected' : ''}>
											${item.descrFormaDoc}
										</option>  
									</c:forEach>
								</select>	
							<c:if test="${not empty exDocumentoDTO.doc.exFormaDocumento}">
								<span style="${estiloTipoSpan}">${exDocumentoDTO.doc.exFormaDocumento.descrFormaDoc}</span>
							</c:if></td>
						</tr>

						<c:choose>
							<c:when test="${possuiMaisQueUmModelo}">
								<tr>
									<td>Modelo:</td>
									<td colspan="3">
										<siga:div id="modelo" depende="forma">
											
											<select  name="exDocumentoDTO.idMod" onchange="document.getElementById('alterouModelo').value='true';sbmt();" cssStyle="${estiloTipo}">
												<c:forEach items="${exDocumentoDTO.modelos}" var="item">
													<option value="${item.idMod}" ${item.idMod == exDocumentoDTO.idMod ? 'selected' : ''}>
														${item.nmMod}
													</option>  
												</c:forEach>
											</select>											
											
											<c:if test="${not empty exDocumentoDTO.doc.exModelo}">
												<span style="${estiloTipoSpan}">${exDocumentoDTO.doc.exModelo.nmMod}</span>
											</c:if>
											<!-- sbmt('modelo') -->
											<c:if test='${exDocumentoDTO.tipoDocumento!="interno"}'>(opcional)</c:if>
										</siga:div>
									</td>
								</tr>
							</c:when>
							<c:otherwise>
								<input type="hidden" name="exDocumentoDTO.idMod" value="${exDocumentoDTO.modelo.idMod}" />
							</c:otherwise>
						</c:choose>
						
						<c:if test='${exDocumentoDTO.tipoDocumento != "capturado" }'>
						<tr>
							<td>Preenchimento Automático:</td>
							<input type="hidden" name="campos" value="preenchimento" />
							<td colspan="3">
								
								<select  id="preenchimento" name="exDocumentoDTO.preenchimento" onchange="javascript:carregaPreench()">
									<c:forEach items="${exDocumentoDTO.preenchimentos}" var="item">
										<option value="${item.idPreenchimento}" ${item.idPreenchimento == exDocumentoDTO.preenchimento ? 'selected' : ''}>
											${item.nomePreenchimento}
										</option>  
									</c:forEach>
								</select>&nbsp;								
									 
								<c:if test="${exDocumentoDTO.preenchimento==0}">
									<c:set var="desabilitaBtn"> disabled="disabled" </c:set>
								</c:if>
								 
								<input type="button" name="btnAlterar" value="Alterar" onclick="javascript:alteraPreench()"${desabilitaBtn}>&nbsp;								
								<input type="button" name="btnRemover" value="Remover" onclick="javascript:removePreench()"${desabilitaBtn} >&nbsp;								
								<input type="button" value="Adicionar" name="btnAdicionar" onclick="javascript:adicionaPreench()">
							</td>
						</tr>
					</c:if>

						
					</c:if>
					<c:if test='${exDocumentoDTO.tipoDocumento == "externo" }'>
						<input type="hidden" name="exDocumentoDTO.idFormaDoc" value="${exDocumentoDTO.formaDocPorTipo.idFormaDoc}" />
						<input type="hidden" name="exDocumentoDTO.idMod" value="${exDocumentoDTO.idMod}"/>
					</c:if>
				

						
					<tr style="display:<c:choose><c:when test="${exDocumentoDTO.modelo.exClassificacao!=null}">none</c:when><c:otherwise>visible</c:otherwise></c:choose>">
						<td>Classificação:</td>
						<c:if test="${exDocumentoDTO.modelo.exClassificacao!=null}">
							<c:set var="desativarClassif" value="sim" />
						</c:if>
						<td colspan="3">
						    <input type="hidden" name="campos" value="classificacaoSel.id" />
							<siga:span id="classificacao" depende="forma;modelo">
							<siga:selecao desativar="${desativarClassif}" modulo="sigaex" propriedade="classificacao"  inputName="exDocumentoDTO.classificacao" urlAcao="buscar" urlSelecionar="selecionar" tema="simple" />
							<!--  idAjax="classificacao" -->
						</siga:span></td>
					</tr>
					<c:if
						test="${exDocumentoDTO.classificacaoSel.id!=null && exDocumentoDTO.classificacaoIntermediaria}">
						<tr>
							<td>Descrição da Classificação:</td>
							<td colspan="3">
								<siga:span id="descrClassifNovo" depende="forma;modelo;classificacao">
								<input type="text" name="exDocumentoDTO.descrClassifNovo" size="80" value="${exDocumentoDTO.descrClassifNovo}" maxLength="4000" />
							</siga:span></td>
						</tr>
					</c:if>
					<c:choose>
						<c:when test='${exDocumentoDTO.modelo.descricaoAutomatica}'>
    					   <c:set var="displayDescricao" value="none" />
						</c:when>
						<c:otherwise>
            				<c:set var="displayDescricao" value="visible" />
						</c:otherwise>
					</c:choose>
					<tr style="display:${displayDescricao}">
					    <c:if test="${exDocumentoDTO.modelo.descricaoAutomatica}">
							<input type="hidden" id="descricaoAutomatica" value="sim" />
						</c:if>
						<input type="hidden" name="campos" value="descrDocumento" />
						<td>Descrição:</td>
						<td colspan="3">
							<textarea name="exDocumentoDTO.descrDocumento" cols="80" rows="2" id="descrDocumento" cssClass="gt-form-textarea" value="${exDocumentoDTO.descrDocumento}" >${exDocumentoDTO.descrDocumento}</textarea> <br>
							<span><b>(preencher o campo acima com palavras-chave, sempre usando substantivos, gênero masculino e singular)</b></span>
						</td>
					</tr>
					
					<c:if test='${exDocumentoDTO.tipoDocumento == "capturado"}'>
						<tr>
							<input type="hidden" name="campos" value="descrDocumento" />
							<td>Arquivo PDF:</td>
							<td colspan="3">
								<input type="file" name="arquivo" accept="application/pdf" onchange="testpdf(this.form)" />
							</td>
						</tr>
					</c:if>
				
					<c:if test='${exDocumentoDTO.tipoDocumento == "interno" or exDocumentoDTO.tipoDocumento == "capturado"}'>
						<c:if test="${exDocumentoDTO.modelo.conteudoTpBlob == 'template/freemarker' or not empty exDocumentoDTO.modelo.nmArqMod}">
							<tr class="header">
								<td colspan="4">Dados complementares</td>
							</tr>
							<tr>
								<td colspan="4">
									<siga:span id="spanEntrevista" depende="tipoDestinatario;destinatario;forma;modelo">
										<c:if test="${exDocumentoDTO.modelo.conteudoTpBlob == 'template/freemarker'}">
											${f:processarModelo(exDocumentoDTO.doc, 'entrevista', par, exDocumentoDTO.preenchRedirect)}
										</c:if>
										<c:if test="${exDocumentoDTO.modelo.conteudoTpBlob != 'template/freemarker'}">
											<c:import url="/paginas/expediente/modelos/${exDocumentoDTO.modelo.nmArqMod}?entrevista=1" />
										</c:if>
									</siga:span>
								</td>
							</tr>
						</c:if>
					</c:if>
					<tr>
						<td colspan="4">
							<input type="button" onclick="javascript: gravarDoc();" name="gravar" value="Ok" class="gt-btn-small gt-btn-left"/>
						 	<c:if test='${exDocumentoDTO.tipoDocumento == "interno"}'>
							<c:if test="${not empty exDocumentoDTO.modelo.nmArqMod or exDocumentoDTO.modelo.conteudoTpBlob == 'template/freemarker'}">
								<input type="button" name="ver_doc" value="Visualizar o Documento" onclick="javascript: popitup_documento(false);" class="gt-btn-large gt-btn-left"/>
								<input type="button" name="ver_doc_pdf" onclick="javascript: popitup_documento(true);" value="Visualizar a Impressão" class="gt-btn-large gt-btn-left"/>
							</c:if>
						</c:if></td>
					</tr>
				</table>
			</form>

		</div>	
	</div>
</div>

	<!--  tabela do rodapé -->
</siga:pagina>

<script type="text/javascript">
// window.customOnsubmit = function() {return true;};
// {
//	var frm = document.getElementById('frm');
//	if (typeof(frm.submitsave) == "undefined")
//		frm.submitsave = frm.submit;
// }
</script>
