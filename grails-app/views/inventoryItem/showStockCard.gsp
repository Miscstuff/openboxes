
<%@ page import="org.pih.warehouse.product.Product"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta name="layout" content="custom" />
		<g:set var="entityName"
			value="${message(code: 'stockCard.label', default: 'Stock Card')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<div class="body">
	
			<div class="nav">
				<g:render template="../inventory/nav"/>
			</div>
			<g:if test="${flash.message}">
				<div class="message">
					${flash.message}
				</div>
			</g:if> 
			<g:hasErrors bean="${itemInstance}">
				<div class="errors"><g:renderErrors bean="${itemInstance}" as="list" /></div>
			</g:hasErrors>
			
				<div style="text-align: right; padding-right: 15px;" >	
					<span style="width: 500px;">
						<label>Actions:</label>
								
						<img src="${resource(dir: 'images/icons/silk', file: 'table_refresh.png')}"/>
						<g:link controller="inventory" action="browse" >
							Back to Inventory
						</g:link>
	
						<img src="${resource(dir: 'images/icons/silk', file: 'pencil.png')}"/>
						<g:link controller="inventoryItem" action="showRecordInventory" params="['product.id':productInstance?.id,'inventory.id':inventoryInstance?.id]">
							Record stock
						</g:link>
						<%-- 
						<img src="${resource(dir: 'images/icons/silk', file: 'magnifier.png')}"/>
						<g:link controller="inventoryItem" action="showTransactions" params="['product.id':productInstance?.id,'inventory.id':inventoryInstance?.id]">
							Show changes
						</g:link>
						--%>
						<img src="${resource(dir: 'images/icons/silk', file: 'add.png')}"/>
						<g:link controller="inventoryItem" action="create" params="['product.id':productInstance?.id,'inventory.id':inventoryInstance?.id]">
							Add item
						</g:link>	
					</span>									
				</div>
			<div class="dialog">		
				<table>
					<tr>
						<td style="width: 250px;">
							<g:render template="productDetails" model="[productInstance:productInstance]"/>											
						</td>
						<td>			
						
							<div> 					
								<fieldset>	
									<legend class="fade">Current Stock</legend>																
									<div id="inventoryView" style="text-align: right;">										
										<table border="0" style="border:1px solid #f5f5f5" width="100%">
											<thead>
												<tr class="odd">
													<th>ID</th>
													<th>Description</th>
													<th>Lot Number</th>
													<th>Expires</th>
													<th style="text-align: center;" >Qty</th>
												</tr>											
											</thead>
											<tbody>
												<g:if test="${!inventoryItemList}">
													<tr class="even">
														<td colspan="4" style="text-align: center">
															<span class="fade">No current stock </span>
														</td>
													</tr>
												</g:if>
											
												<g:each var="itemInstance" in="${inventoryItemList }" status="status">				
													<tr class="${(status%2==0)?'even':'odd' }">
														<td class="fade">${itemInstance?.id}</td>
														<td>${itemInstance?.description}</td>
														<td>${itemInstance?.lotNumber?:'<span class="fade">EMPTY</span>' }</td>
														<td>
															<g:if test="${itemInstance?.inventoryLot?.expirationDate}">
																<g:formatDate date="${itemInstance?.inventoryLot?.expirationDate }" format="dd/MMM/yy" />
															</g:if>
															<g:else>
																<span class="fade">never</span>
															</g:else>
														</td>
														<td style="text-align: center;">${itemInstance?.quantity }</td>												
													</tr>
												</g:each>
											</tbody>
											<tfoot>
												<tr>
													<th>Total</th>
													<th></th>
													<th></th>
													<th></th>
													<th style="text-align: center;">${inventoryItemList*.quantity.sum() }</th>
												</tr>
											</tfoot>
										</table>										
									</div>			
								</fieldset>
							</div>
							<br/>						
							<div>							
								<fieldset>
									<legend><span class="fade">Transaction Log</span></legend>
									<div style="padding: 10px;">
										<g:form method="GET" action="showStockCard">
											<g:hiddenField name="product.id" value="${productInstance?.id }"/>
											<label>Filter transactions: </label>
											<span>
												<g:jqueryDatePicker 
													id="startDate" 
													name="startDate" 
													value="${commandInstance?.startDate }" 
													format="MM/dd/yyyy"
													showTrigger="false" />
											</span>
											<span> - </span>
											<span> 
												<g:jqueryDatePicker 
													id="endDate" 
													name="endDate" 
													value="${commandInstance?.endDate }" 
													format="MM/dd/yyyy"
													showTrigger="false" />
											</span>
											<span>
												<g:select name="transactionType.id" 
													from="${org.pih.warehouse.inventory.TransactionType.list()}" 
													optionKey="id" optionValue="name" value="${commandInstance?.transactionType?.id }" 
													noSelection="['0': '-- All types --']" /> 
											</span>
											<span class="buttons">
												<g:submitButton name="filter" value="Go"/>
											</span>
										</g:form>
									</div>		
									<script>
										jQuery(document).ready(function() {
											jQuery("tr.transactionEntry").hide();

											jQuery(".toggleDetails").click(function() {
												jQuery("tr.transaction" + this.id).toggle();								
											});
										});	
									</script>
									<table width="100%">
										<thead>
											<tr class="odd">
												<th>
													${message(code: 'transaction.id.label', default: 'ID')}
												</th>
												<th>
													${message(code: 'transaction.transactionDate.label', default: 'Date')}
												</th>
												<th>
													${message(code: 'transaction.transactionType.label', default: 'Type')}
												</th>
												<th>
													${message(code: 'transaction.transactionEntries.label', default: 'Entries')}
												</th>
												<th>
													${message(code: 'transaction.quantityChange.label', default: 'Qty +/-')}
												</th>
											</tr>
										</thead>
										<tbody>												
											<g:each var="transaction" in="${transactionEntryMap.keySet().sort {it.transactionDate}.reverse() }" status="status">
												<tr id="${transacton?.id }" class="transaction ${(status%2==0)?'even':'odd' }">
													<td class="fade">
														${transaction?.id }
													</td>
													<td>
														<g:formatDate
															date="${transaction?.transactionDate}" format="MMM dd" />
	
													</td>
													<td>	
														${transaction?.transactionType?.name }
													</td>
													<td>
														There were ${transaction?.transactionEntries?.size() } inventory item(s) involved in this transaction.														
														<a href="#" id="${transaction?.id }" class="toggleDetails">Show details &rsaquo;</a>
													</td>
													<td>
														<g:set var="quantityChange" value="${transaction?.transactionEntries*.quantity?.sum() }"/>
														<g:if test="${quantityChange>0}">
															+${quantityChange }
														</g:if>
														<g:else>
															${quantityChange }
														</g:else>
													</td>
												</tr>
												<g:each var="transactionEntry" in="${transactionEntryMap.get(transaction) }">
													<tr id="transactionEntry?.id" class="transactionEntry transaction${transaction?.id } ${(status%2==0)?'even':'odd' }">
														<td>
														</td>
														<td>
														</td>
														<td>
														</td>												
														<td>
															<span class="fade">
																${transactionEntry?.inventoryItem?.description }
																${transactionEntry?.lotNumber }</span>
														</td>
														<td>
															<span class="fade">
															${transactionEntry?.quantity }</span>
														</td>
														
													</tr>
												</g:each>
											</g:each>
										</tbody>
									</table>
								</fieldset>
							</div>
																	
						</td>
					</tr>
				</table>
			</div>			
		</div>
	</body>
</html>