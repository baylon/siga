<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
	buffer="64kb" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://localhost/jeetags" prefix="siga"%>
<%@ taglib uri="http://localhost/functiontag" prefix="f"%>
<%@ taglib uri="http://localhost/customtag" prefix="tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<siga:pagina titulo="Documento">
	<script type="text/javascript" language="Javascript1.1">
		/*  converte para maiúscula a sigla do estado  */
		function converteUsuario(nomeusuario) {
			re = /^[a-zA-Z]{2}\d{3,6}$/;
			ret2 = /^[a-zA-Z]{1}\d{3,6}$/;
			tmp = nomeusuario.value;
			if (tmp.match(re) || tmp.match(ret2)) {
				nomeusuario.value = tmp.toUpperCase();
			}
		}
	</script>

	<c:if test="${not doc.eletronico}">
		<script type="text/javascript">
			$("html").addClass("fisico");
		</script>
	</c:if>

	<div class="gt-bd" style="padding-bottom: 0px;">
		<div class="gt-content">

			<h2>Confirme os dados do documento abaixo:</h2>

			<div class="gt-content-box" style="padding: 10px;">
				<table class="message" width="100%">
					<tr class="header">
						<td width="50%"><b>Documento
								${doc.exTipoDocumento.descricao}:</b> ${doc.codigo}</td>
						<td><b>Data:</b> ${doc.dtDocDDMMYY}</td>
					</tr>
					<tr class="header">
						<td><b>De:</b> ${doc.subscritorString}</td>
						<td><b>Classificação:</b>
							${doc.exClassificacao.descricaoCompleta}</td>
					</tr>
					<tr class="header">
						<td><b>Para:</b> ${doc.destinatarioString}</td>
						<td><b>Descrição:</b> ${doc.descrDocumento}</td>
					</tr>
					<c:if test="${doc.conteudo != ''}">
						<tr>
							<td colspan="2">
								<div id="conteudo" style="padding-top: 10px;">
									<tags:fixdocumenthtml>
										${doc.conteudoBlobHtmlStringComReferencias}
									</tags:fixdocumenthtml>
								</div>
							</td>
						</tr>
					</c:if>
				</table>

			</div>

			<c:set var="acao" value="assinar_gravar" />
			<div class="gt-form-row gt-width-100" style="padding-top: 10px;">
				<div id="dados-assinatura" style="visible: hidden">
					<input type="hidden" name="ad_url_base" value="${fn:substring(pageContext.request.requestURL.toString(), 0, fn:length(pageContext.request.requestURL.toString()) - fn:length(pageContext.request.requestURI.toString()))}" />
					<input type="hidden" name="ad_url_next" value="/sigaex/app/expediente/doc/exibir?sigla=${sigla}" />
					<input type="hidden" name="ad_descr_0" value="${sigla}" /> 
					<input type="hidden" name="ad_url_pdf_0" value="/sigaex/app/arquivo/exibir?arquivo=${doc.codigoCompacto}.pdf" />
					<input type="hidden" name="ad_url_post_0" value="/sigaex/app/expediente/mov/assinar_gravar" />
					<input type="hidden" name="ad_url_post_password_0" value="/sigaex/app/expediente/mov/assinar_senha_gravar" />
				</div>
				
				<tags:assinatura_botoes
					autenticar="${autenticando}"
					assinarComSenha="${f:podeAssinarComSenha(titular,lotaTitular,doc.mobilGeral)}"/>
			</div>
		</div>
	</div>

	<tags:assinatura_rodape/>
</siga:pagina>