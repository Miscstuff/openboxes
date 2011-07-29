<div>							
	
	<h2 class="fade">Pending Transaction Log</h2>
	<div style="text-align: center;">
		<g:form method="GET" action="showStockCard">
			<g:hiddenField name="product.id" value="${commandInstance?.productInstance?.id }"/>

			<div class="list">
				<table>
					<thead>
						<tr class="odd prop">
							<th>
								${message(code: 'transaction.transactionDate.label', default: 'Date')}
							</th>
							<th>
								${message(code: 'transaction.transactionType.label', default: 'Type')}
							</th>
							<th>
								${message(code: 'transaction.source.label', default: 'Source')}
							</th>
							<th>
								${message(code: 'transaction.destination.label', default: 'Destination')}
							</th>
							<th style="text-align: center">
								${message(code: 'transaction.quantityChange.label', default: 'Qty In/Out')}
							</th>
						</tr>

					</thead>
					<!--  Transaction Log -->
					<tbody>			
						<g:if test="${!shipmentMap }">
							<tr>
								<td colspan="5" class="even center" style="min-height: 100px;">		
									<div class="fade">
										None
									</div>
								</td>
							</tr>
						</g:if>
						<g:else>
							<g:set var="totalQuantityChange" value="${0 }"/>							
							<g:each var="entry" in="${shipmentMap}" status="status">
								<g:set var="shipment" value="${entry.key }"/>
								<tr class="${(status%2==0)?'even':'odd' } prop">
									<td style="width: 10%;" nowrap="nowrap">	
									
									
										<g:if test="${shipment?.expectedShippingDate }">
											<g:formatDate date="${shipment.expectedShippingDate }" format="dd/MMM/yyyy"/><br/>
											<span class="fade">${prettyDateFormat(date: shipment.expectedShippingDate)}</span> 
										</g:if>
									</td>
									<td>
										<g:link controller="shipment" action="showDetails" id="${shipment?.id }">
											${shipment?.name }
										</g:link>
									</td>
									<td>	
										${shipment?.origin?.name }
									</td>
									<td>
										${shipment?.destination?.name }
									</td>
									<td style="text-align: center">
										${shipmentMap[shipment] }
									</td>
								</tr>
							</g:each>
						</g:else>
					</tbody>
				</table>
			</div>
		</g:form>
	</div>
</div>