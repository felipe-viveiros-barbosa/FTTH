Given(/^the address of client with id "([^"]*)" in station "([^"]*)" its valid$/) do |idEndereco, station|
  fixedStation = true
  used_stations = []
  if station == ""
    fixedStation = false
    station = returnStation ["BOT","CVI","BGU","RDB","ALV","DQX","ARC","BTJ"], used_stations
    used_stations << station
    log.info "Estacoes utilizadas: #{used_stations}"
    log.info "Estacao atual: #{station}"
  end
  if idEndereco == ""
  	#@array_addresses ||= get_available_addresses stationD
    @array_addresses = get_available_addresses station
    log.info @array_addresses
    @idEndereco = consultaViabilidadeEndereco fixedStation, @array_addresses
    if !fixedStation
      while @idEndereco.eql? "viabilidade fail" do
        station = returnStation ["BOT","CVI","BGU","RDB","ALV","DQX","ARC","BTJ"], used_stations
        used_stations << station
        log.info "Estacoes utilizadas: #{used_stations}"
        log.info "Estacao atual: #{station}"
        @array_addresses = get_available_addresses station
        log.info @array_addresses
        @idEndereco = consultaViabilidadeEndereco fixedStation, @array_addresses
      end
    elsif fixedStation
      test_helper_assert_equal "Estacao definida nao possui viabilidade!!", "success", "fail"
    end
    log.info "ID Endereco adquirido: #{@idEndereco}"
  else
    @idEndereco = idEndereco
  end
  log.info "Estacao: #{station}"
end

Given(/^Eu valido se o idGpon retorna viabilidade$/) do    
  viabilidadeIdGpon
  viabilidadeIdEndereco
  viabilidadeEnderecoCompleto
  consultaViabilidadeIdGPON 
end

Given(/^Eu valido se o idEndereco e valido$/) do
   viabilidadeIdEndereco
   log.info "RETORNEI DA VIABILIDADE"
   log.info $id_endereco
   log.info "RETORNEI DA VIABILIDADE"
   @idendereco = $id_endereco
end

Given(/^Eu valido se o idEndereco retorna viabilidade$/) do
  $id_gpon = "AVV3444"
  viabilidadeIdEndereco
  viabilidadeEnderecoCompleto 
  consultaViabilidadeIdEndereco
end

Given(/^Eu valido se a pesquisa de viabilidade nao retorna nenhum resultado$/) do     
   $id_gpon = "AVV3444"
   $id_endereco = 20202020  
   $uF = "RY"
   $cod_localidade = 670707
   $cod_logradouro = 90909
   $num_fachada = 505050 
   consultaViabilidadeInvalidos 
end

Given(/^Eu valido se somente o endereco completo e valido na pesquisa$/) do    
  $id_gpon = "AVV3444"
  $id_endereco = 101010101
  viabilidadeEnderecoCompleto
  consultaViabilidadeValidaEndereco
end

Given(/^Eu valido se a consulta de viabilidade por endereco completo e valida$/) do   
  viabilidadeEnderecoCompleto
  consultaViabEndCompleto
end

Then(/^I set bundle name for each service$/) do |table|
  table.hashes.each do |hash|
    @bundleNames = hash
  end  
end

Then(/^I create one activation order with the services$/) do |table|
  table.hashes.each do |hash| 
  	@services = setNameServices hash
    log.info @services
  end  
  @gpon = returnNameDate + '_GPON'
  @idEndereco = $id_endereco
  activationOrder = createActivationOrder @gpon, @services, @idEndereco, @bundleNames
  log.info activationOrder
  @serviceOrder = get_service_order activationOrder
  log.info "Service Order:"
  log.info @serviceOrder
end

Then(/^Faco uma ativacao nova fibra$/) do |table|
  table.hashes.each do |hash| 
  	@services = setNameServices hash
    log.info @services
  end  
  #@gpon = returnNameDate + '_GPON'
  @idEndereco = $id_endereco
  string_length1 = 8
  @companyId = rand(36**string_length1).to_s(36)
  string_length2 = 8
  @subscriberId = rand(36**string_length2).to_s(36)
  log.info @companyId
  log.info @subscriberId
  log.info @services
  activationOrder = createActivationOrderNovaFibra @companyId, @subscriberId, @services, @idEndereco, @bundleNames
  log.info activationOrder
  @serviceOrder = get_service_order activationOrder
  log.info "Service Order:"
  log.info @serviceOrder
end

When(/^I make a service GPON query$/) do
  log.info "DENTRO DA CONSULTA GPON QUERY"
  log.info @gpon
  sleep(20)
  service_query = consultaServicos @serviceOrder, @gpon, "CFS.ACESSOGPON"
  @service_order_item = get_srv_ord_item service_query
  log.info "Service Order Item:"
  log.info @service_order_item
  @rfs_pon = get_rfs_pon service_query
  log.info "RFS PON:"
  log.info @rfs_pon
end



When(/^I make a service GPON query teste$/) do
  time = Time.new
  time_inicio = (time.min * 60) + time.sec
  log.info "Inicio: " + time.inspect.to_s
  log.info "DENTRO DA QUERY TESTE--------------------------"
  log.info @serviceOrder
  sleep(20)
  service_query = consultaServicos @serviceOrder, @gpon, "CFS.ACESSOGPON"
  test_helper_assert_equal "Testando tag cfsReferenceList", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList'].nil?
  test_helper_assert_equal "Testando tag rfsReferenceList", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['rfsReferenceList'].nil?
  test_helper_assert_equal "Testando tag arrayOfAssociatedRfsResources", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources'].nil?
 # log.info service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['rfs']['describedBy']['item'][4]
  test_helper_assert_equal "Testando tag jumper", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['rfs']['describedBy']['item'][4]['value'].nil?
  @service_order_item = get_srv_ord_item service_query  
  log.info "Service Order Item:"
  log.info @service_order_item
  @rfs_pon = get_rfs_pon service_query
  log.info "RFS PON:"
  log.info @rfs_pon
  time = Time.new
  time_fim = (time.min * 60) + time.sec
  log.info "Fim: " + time.inspect.to_s
  time_stamp = (time_fim - time_inicio)
  log.info "Tempo decorrido: " + time_stamp.to_s + " segundos"
end

When(/^I make a service GPON query teste nova fibra$/) do
  time = Time.new
  time_inicio = (time.min * 60) + time.sec
  log.info "Inicio: " + time.inspect.to_s
  log.info "DENTRO DA QUERY TESTE--------------------------"
  log.info @serviceOrder
  service_query = consultaServicos @serviceOrder, $acesso_gpon, "CFS.ACESSOGPON"
  test_helper_assert_equal "Testando tag cfsReferenceList", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList'].nil?
  test_helper_assert_equal "Testando tag rfsReferenceList", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['rfsReferenceList'].nil?
  test_helper_assert_equal "Testando tag arrayOfAssociatedRfsResources", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources'].nil?
 # log.info service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['rfs']['describedBy']['item'][4]
  test_helper_assert_equal "Testando tag jumper", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['rfs']['describedBy']['item'][4]['value'].nil?
  @service_order_item = get_srv_ord_item service_query  
  log.info "Service Order Item:"
  log.info @service_order_item
  @rfs_pon = get_rfs_pon service_query
  log.info "RFS PON:"
  log.info @rfs_pon
  time = Time.new
  time_fim = (time.min * 60) + time.sec
  log.info "Fim: " + time.inspect.to_s
  time_stamp = (time_fim - time_inicio)
  log.info "Tempo decorrido: " + time_stamp.to_s + " segundos"
end

When(/^Eu faco a consulta para o GPON apos Cessar$/) do
  time = Time.new
  time_inicio = (time.min * 60) + time.sec
  log.info "Inicio: " + time.inspect.to_s
  sleep(30)
  log.info "DLR: verificar variaveis"
  log.info @serviceOrder 
  log.info @gpon
  service_query = consultaServicosCessar @serviceOrder, @gpon, "CFS.ACESSOGPON"
  time = Time.new
  time_fim = (time.min * 60) + time.sec
  log.info "Fim: " + time.inspect.to_s
  time_stamp = (time_fim - time_inicio)
  log.info "Tempo decorrido: " + time_stamp.to_s + " segundos"
end


And(/^I validade data from "([^"]*)" query$/) do |service|
  if @services[service] != nil
    service_query = consultaServicos @serviceOrder, @services[service], service
    if service != "CFS.RFTV"
      test_helper_assert_equal "Testando tag rfsReferenceList", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['rfsReferenceList'].nil?
      test_helper_assert_equal "Testando tag arrayOfAssociatedRfsResources", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources'].nil?
    end  
    num_cfs = cfs_value service, service_query
    num_exp = num_expected service
    bundlename_return = bundlename_value service, service_query
    test_helper_assert_equal "Verificando valor de bundlename do servico #{service}", @bundleNames[service], bundlename_return
    test_helper_assert_equal "Verificando valor de lineid do servico #{service}", num_cfs, num_exp
    if service == "CFS.VOIP" #eh preciso validar o technoclass somente no voip     
      technoclass = technoclass_value service_query
      test_helper_assert_equal "Validando valor do technoclass do servico VOIP", "7001", technoclass
    end
  else
    log.info "Servico nao existente na ordem"
  end  
end

And(/^Eu consulto o GPON criado$/) do
  log.info "ANTES DE FAZER A CONSULTA GPONNNNNNNN "
  log.info @services
  @resultado = obtem_acessogpon_nova_fibra @companyId, @subscriberId
  log.info @resultado
  @services['CFS.ACESSOGPON'] = @resultado[0]
  @services['CFS.HSI'] = @resultado[1]
  @services['CFS.IPTV'] = @resultado[2]
  @services['CFS.RFTV'] = @resultado[3]
  @services['CFS.VOIP'] = @resultado[4]
  log.info "DEPOIS DA CONSULTA GPONNNNNNN ------------"
  log.info @services
  log.info "VOLTEI DA CONSULTA DO BANCOOOOOOOO"
end 

#####################João Serviços Lógicos######
And(/^Eu consulto os servicos criados/) do 
  sleep(25)
  obtem_logicos_nova_fibra @companyId, @subscriberId
  $servicosretornados = @services 
  log.info "VOLTEI DA CONSULTA DO BANCOOOOOOOO"
  log.info $servicosretornados
end 
#####################################################

And(/^I make the order update CPE$/) do
  if !@services['CFS.IPTV'].nil?
    @cpe = returnCPENameDate
    soap_return = updateCPE @serviceOrder, @gpon, @services, @cpe  
    log.info soap_return
    success = successUpdate soap_return
    test_helper_assert_equal "Verificando se ordem de update CPE foi feita com sucesso", "true", success
  else
    log.info "IPTV nao criado na ordem, nao ha como realizar o update cpe"
  end
end

And(/^I make the order update CPE nova fibra$/) do
  if !@services['CFS.IPTV'].nil?
    @cpe = returnCPENameDate
    soap_return = updateCPE @serviceOrder, $acesso_gpon, @services, @cpe  
    log.info soap_return
    success = successUpdate soap_return
    test_helper_assert_equal "Verificando se ordem de update CPE foi feita com sucesso", "true", success
  else
    log.info "IPTV nao criado na ordem, nao ha como realizar o update cpe"
  end
end

And(/^I make the order update CPE after change address$/) do
  if !@services['CFS.IPTV'].nil?
    soap_return = updateCPE @serviceOrder, @gpon, @services, @cpe, true
    log.info soap_return
    success = successUpdate soap_return
    test_helper_assert_equal "Verificando se ordem de update CPE foi feita com sucesso", "true", success
  else
    log.info "IPTV nao criado na ordem, nao ha como realizar o update cpe"
  end
end

And(/^I make the order update CR$/) do
  soap_return = updateCR @serviceOrder, @service_order_item, @rfs_pon 
  success = successUpdate soap_return
  test_helper_assert_equal "Verificando se ordem de update CPE foi feita com sucesso", "true", success
end

Given(/^I create one change order with the services$/) do |table|
  table.hashes.each do |hash| 
    @actions = hash
  end
  @services = setNewServices @services, @actions 
  log.info @services   
  soap_return = createOrderOfChange @actions, @services, @gpon
  log.info soap_return
  @serviceOrder = get_service_order soap_return
  log.info "A Service Order gerada apos a ordem de alteracao e:"
  log.info soap_return
  log.info @serviceOrder
  @bundleNames = updateBundlenames @bundleNames, @actions
  @services = updateServices @services, @actions
  @actions = updateActions @actions
end

And(/^I validade data from "([^"]*)" query after change order$/) do |service|
  if @services[service] != nil
    #service_query = consultaServicosInventario @serviceOrder, @services[service], service
    service_query = consultaServicos @serviceOrder, @services[service], service 
    log.info service_query
    #num_cfs = cfs_value service, service_query
    #num_exp = num_expected service
    bundlename_return = bundlename_value service, service_query
    action_return = action_value service_query
    test_helper_assert_equal "Testando o valor da mudanca", @actions[service], action_return
    test_helper_assert_equal "Verificando valor de bundlename do servico #{service}", @bundleNames[service], bundlename_return
  else
    log.info "Servico nao existente na ordem"
  end  
end

And(/^I create one change address order$/) do  
    changeOrderReturn = createChangeAddressRequest @gpon, @services, @idEndereco, @bundleNames
    @gpon = updateGpon @gpon
    @serviceOrder = get_service_order changeOrderReturn
    log.info "O novo valor Gpon e:"
    log.info @gpon
    log.info "O novo service order:"
    log.info @serviceOrder
end


And(/^I finish the order$/) do
  soap_return = finalizaOrdem @serviceOrder
  log.info soap_return 
  test_helper_assert_equal "Testando o sucesso da ordem de finalizacao", soap_return['Envelope']['Body']['resumeRequestByKeyResponse'], nil
end

And(/^I cease the order$/) do
  soap_return = cessaOrdem @gpon, @services
  log.info soap_return 
  @serviceOrder = get_service_order soap_return
  log.info "O novo service order:"
  log.info @serviceOrder
  log.info "Ordem fechada com suce"
  test_helper_assert_equal "Testing success of order finish", soap_return['Envelope']['Body']['resumeRequestByKeyResponse'], nil
end

And(/^I abort the order$/) do
  soap_return = createAbortOrder @serviceOrder 
  log.info soap_return
  test_helper_assert_equal "Testando o suceso da ordem para abortar", soap_return['Envelope']['Body']['abortRequestByKeyResponse'], nil
end

Then(/^I contract new TV points with the serial number "([^"]*)"/) do |serialAditional|
  serialAditional = nil if serialAditional == ""
  serialAditional ||= returnCPENameDate
  @cpeAditional = serialAditional
  listSerialAditional = serialAditional.split(',')
  @listSerialNumbers = getSerialNumbersList listSerialAditional
  soap_return = createAditionalPoints @services, @listSerialNumbers
  success = successUpdate soap_return
  test_helper_assert_equal "Verificando se ordem de update CPE foi feita com sucesso", "true", success
  log.info soap_return
end

And(/^I cancel the TV points with serial number "([^"]*)"/) do |serialCancel|
  listSerialCancel = @cpeAditional.split(',') if serialCancel == nil or serialCancel == ''
  soap_return = createCancelPoints @services, @listSerialNumbers
  log.info soap_return
#  success = successUpdate soap_return
#  test_helper_assert_equal "Testing success of update CPE order", "true", success
  log.info soap_return
end

And(/^I validate physical inventory$/) do
    #soap_return = consultaInventario @serviceOrder#, @companyId, @subscriberId
	
    sleep(12)
    soap_return = consultaInventario @gpon#, @companyId, @subscriberId
    
    i = 0
    item_qtd = soap_return['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList']['item'].length
    log.info item_qtd

    while i < item_qtd-1 do
      got = soap_return['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList']['item'][i]['entityKey']['primaryKey']['name']
      expected = soap_return['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList']['item'][i]['entityKey']['primaryKey']['type'][1]
      test_helper_assert_equal "Testando valor #{i}", @services[expected], got
      i += 1
    end
      
    test_helper_assert_equal "Testando tag rfsReferenceList", true, !soap_return['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['rfsReferenceList'].nil?
    test_helper_assert_equal "Testando tag arrayOfAssociatedRfsResources", true, !soap_return['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources'].nil?
end

And(/^I validate physical inventory nova fibra$/) do
  soap_return = consultaInventario $acesso_gpon
  
  i = 0
  item_qtd = soap_return['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList']['item'].length
  log.info item_qtd

  while i < item_qtd-1 do
    got = soap_return['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList']['item'][i]['entityKey']['primaryKey']['name']
    expected = soap_return['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList']['item'][i]['entityKey']['primaryKey']['type'][1]
    test_helper_assert_equal "Testando valor #{i}", @services[expected], got
    i += 1
  end
    
  test_helper_assert_equal "Testando tag rfsReferenceList", true, !soap_return['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['rfsReferenceList'].nil?
  test_helper_assert_equal "Testando tag arrayOfAssociatedRfsResources", true, !soap_return['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources'].nil?
end

And(/^I validate inventory data from "([^"]*)" query$/) do |service|
  if @services[service] != nil
    service_query = consultaServicosInventario @services[service], service
    num_cfs = cfs_value service, service_query
    num_exp = num_expected service
    test_helper_assert_equal "Verificando valor de lineid do servico #{service}", num_cfs, num_exp
    if service == "CFS.VOIP" #eh preciso validar o technoclass somente no voip     
      technoclass = technoclass_value service_query
      test_helper_assert_equal "Validando valor do technoclass do servico VOIP", "7001", technoclass
    end
    if service != "CFS.RFTV" 
      test_helper_assert_equal "Testando tag rfsReferenceList", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['rfsReferenceList'].nil?
      test_helper_assert_equal "Testando tag arrayOfAssociatedRfsResources", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources'].nil?
    end  
  else
    log.info "Servico nao existente na ordem"
  end
end

And(/^I validate NETQ data from "([^"]*)" query at "([^"]*)"$/) do |service, endPoint|
  if endPoint == "om"
    endPoint = netwin_api_om
  elsif endPoint == "inventory"
    endPoint = netwin_api_inv
  else
    log.info "Ambito nao especificado corretamente."
  end
  log.info service
  log.info @services[service]
  if service == "CFS.ACESSOGPON"
    service_query = consultaServicosNETQ @gpon, service, endPoint
    #log.info service_query
    test_helper_assert_equal "Testando tag cfsReferenceList", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList'].nil?
    test_helper_assert_equal "Testando tag rfsReferenceList", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['rfsReferenceList'].nil?
    test_helper_assert_equal "Testando tag arrayOfAssociatedRfsResources", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources'].nil?
    test_helper_assert_equal "Testando tag jumper", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['rfs']['describedBy']['item'][4]['value'].nil?


    item_qtd = service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'].length

    #log.info "Verificando tags da CDO:"
    #log.info service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][1]['parentResources']['item']['resource']['describedBy']
    #test_helper_assert_equal "Verificando DATA_ESTADO_OPERACIONAL da CDO", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][1]['parentResources']['item']['resource']['describedBy']['item'][0]['value'].nil?
    #test_helper_assert_equal "Verificando ESTADO_OPERACIONAL da CDO", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][1]['parentResources']['item']['resource']['describedBy']['item'][1]['value'].nil?
    #log.info ""
    log.info "Verificando tags da OLT:"
    #log.info service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']

    
    test_helper_assert_equal "Verificando VERSAO_SOFTWARE da OLT", "VERSAO_SOFTWARE", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][0]['characteristic']

    test_helper_assert_equal "Verificando DATA_ESTADO_CICLO_VIDA da OLT", "DATA_ESTADO_CICLO_VIDA", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][1]['characteristic']
    test_helper_assert_equal "Verificando ESTADO_CICLO_VIDA da OLT", "ESTADO_CICLO_VIDA", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][2]['characteristic']
    test_helper_assert_equal "Verificando SERIAL_NUMBER da OLT", "SERIAL_NUMBER", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][3]['characteristic']
    test_helper_assert_equal "Verificando ENDERECO_IP da OLT", "ENDERECO_IP", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][4]['characteristic']
    test_helper_assert_equal "Verificando MODELO da OLT", "MODELO", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][5]['characteristic']
    test_helper_assert_equal "Verificando MASCARA da OLT", "MASCARA", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][6]['characteristic']
    test_helper_assert_equal "Verificando IGMP_PROXY_IP da OLT", "IGMP_PROXY_IP", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][7]['characteristic']
    test_helper_assert_equal "Verificando GATEWAY da OLT", "GATEWAY", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][8]['characteristic']
    test_helper_assert_equal "Verificando FABRICANTE da OLT", "FABRICANTE", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][9]['characteristic']
    test_helper_assert_equal "Verificando DATA_ESTADO_OPERACIONAL da OLT", "DATA_ESTADO_OPERACIONAL", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][10]['characteristic']
    test_helper_assert_equal "Verificando ESTADO_OPERACIONAL da OLT", "ESTADO_OPERACIONAL", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][11]['characteristic']
    log.info ""
    log.info "Verificando tags obrigatorias da OLT:"
    test_helper_assert_equal "Verificando preenchimento de Fabricante da OLT", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][9]['value'].nil?
    test_helper_assert_equal "Verificando preenchimento de MODELO da OLT", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][5]['characteristic'].nil?
    test_helper_assert_equal "Verificando preenchimento de ESTADO_CICLO_VIDA da OLT", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][2]['characteristic'].nil?
    test_helper_assert_equal "Verificando preenchimento IGMP_PROXY_IP da OLT", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][7]['characteristic'].nil?

  elsif @services[service] != nil
    service_query = consultaServicosNETQ @services[service], service, endPoint
    num_cfs = cfs_value service, service_query
    num_exp = num_expected service
    test_helper_assert_equal "Verificando valor de lineid do servico #{service}", num_cfs, num_exp
    if service == "CFS.VOIP" #eh preciso validar o technoclass somente no voip     
      technoclass = technoclass_value service_query
      test_helper_assert_equal "Validando valor do technoclass do servico VOIP", "7001", technoclass
    end
    i = 0
    while service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources'].nil?
      i+=1
    end
    if service != "CFS.RFTV"
      test_helper_assert_equal "Testando tag rfsReferenceList", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['rfsReferenceList'].nil?
      test_helper_assert_equal "Testando tag arrayOfAssociatedRfsResources", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources'].nil?
    end
    #log.info "netwin_steps"
    log.info "Verificando tags do BNG"
    #log.info service_query
    log.info "Verificando tipo do equipamento"
    String tipoEquip = service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['key']['primaryKey']['type'][1]
    #String tipoEquip = "teste"
    if (tipoEquip.eql? "ME.BNG")
      tipoEquip = "ME.BNG"
      log.info "tipo equip OK: ME.BNG"
    elsif (tipoEquip.eql? "ME.SR")
      tipoEquip = "ME.SR"
      log.info "tipo equip OK: ME.SR"
    else
      test_helper_assert_equal "FAIL", "sucess", "fail", "Tipo do equipamento diferente de ME.BNG ou ME.SR"
    end

    test_helper_assert_equal "Verificando ESTADO_CICLO_VIDA do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][0]['characteristic'], "ESTADO_CICLO_VIDA"
    test_helper_assert_equal "Verificando SERIAL_NUMBER do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][1]['characteristic'], "SERIAL_NUMBER"
    test_helper_assert_equal "Verificando MASCARA do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][2]['characteristic'], "MASCARA"
    test_helper_assert_equal "Verificando GATEWAY do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][3]['characteristic'], "GATEWAY"
    test_helper_assert_equal "Verificando FABRICANTE do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][4]['characteristic'], "FABRICANTE"
    test_helper_assert_equal "Verificando VERSAO_SOFTWARE do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][5]['characteristic'], "VERSAO_SOFTWARE"
    test_helper_assert_equal "Verificando ENDERECO_ESTACAO_PREDIAL do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][6]['characteristic'], "ENDERECO_ESTACAO_PREDIAL"
    test_helper_assert_equal "Verificando DATA_ESTADO_CICLO_VIDA do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][7]['characteristic'], "DATA_ESTADO_CICLO_VIDA"
    test_helper_assert_equal "Verificando MODELO do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][8]['characteristic'], "MODELO"
    test_helper_assert_equal "Verificando ENDERECO_IP do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][9]['characteristic'], "ENDERECO_IP"
    test_helper_assert_equal "Verificando SIGLA_ESTACAO_PREDIAL do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][10]['characteristic'], "SIGLA_ESTACAO_PREDIAL"
    test_helper_assert_equal "Verificando NOME_ESTACAO_PREDIAL do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][11]['characteristic'], "NOME_ESTACAO_PREDIAL"
    test_helper_assert_equal "Verificando DATA_ESTADO_OPERACIONAL do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][12]['characteristic'], "DATA_ESTADO_OPERACIONAL"
    test_helper_assert_equal "Verificando ESTADO_OPERACIONAL do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][13]['characteristic'], "ESTADO_OPERACIONAL"
    log.info ""
    log.info "Verificando tags obrigatorias do BNG:"
    test_helper_assert_equal "Verificando preenchimento do nome do BNG", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['key']['primaryKey']['name'].nil?
    test_helper_assert_equal "Verificando preenchimento de FABRICANTE do BNG", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][4]['value'].nil?
    test_helper_assert_equal "Verificando preenchimento de MODELO do BNG", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][8]['value'].nil?
    test_helper_assert_equal "Verificando preenchimento de ESTADO_CICLO_VIDA do BNG", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][0]['characteristic'].nil?

  else
    log.info "Servico nao existe na ordem"
  end
end

And(/^I validate "([^"]*)" data from "([^"]*)" query at "([^"]*)"$/) do |app, service, endPoint|

  log.info service
  log.info @services

############################# Mapeamento dos endPoints #############################
  if endPoint == "om"
    log.info "ENTREI NO OM"
    log.info "APP:#{app}" 
    endPoint = netwin_api_om
  elsif endPoint == "inventory"
    log.info "ENTREI NO INVENTARIO"
    endPoint = netwin_api_inv
  else
    log.info "Ambito nao especificado corretamente."
  end

############################# Dependendo da combinação de app/service/endpoint uma query diferente é enviada #############################
  if app == "OM"

    log.info "ENTREI NO if do OM"
    
    if endPoint == netwin_api_om
      if service == "CFS.ACESSOGPON"
        service_query = consultaServicos @serviceOrder, @gpon, service
      elsif @services[service] != nil
        service_query = consultaServicos @serviceOrder, @services[service], service
      end
    elsif endPoint == netwin_api_inv
      if service == "CFS.ACESSOGPON"
        service_query = consultaInventario @gpon
      elsif @services[service] != nil
        service_query = consultaServicosInventario @services[service], service
      end
    end

  elsif app == "NETQ"
    log.info "ENTREI NO NETQ"
    if service == "CFS.ACESSOGPON"
      log.info "ACESSOGPON !!!!!!!!!"
      log.info service
      service_query = consultaServicosNETQ @gpon, service, endPoint
      log.info "VOLTEI DA CONSULTASERVICOSNETQ"
      log.info service_query
    elsif @services[service] != nil
      log.info "CONSULTA NETQ !!!!!!!!!!!!"
      service_query = consultaServicosNETQ @services[service], service, endPoint
      log.info "RETORNO DA CONSULTA  !!!!!!!!!!!!"
      log.info service_query
      log.info "RETORNO DA CONSULTA  !!!!!!!!!!!!"
    end
  end
log.info "SAI DO ELSIF DO NETQ"
############ Verificação das tags de Estados operacional e de provisão ############
test_helper_assert_equal "Testando tag state_Service", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['state_Service'].nil?
test_helper_assert_equal "Testando tag operationalState", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['operationalState'].nil?
  
############################# Verificação das tags de acordo com consulta física/lógica #############################
############ Verificações relacionadas ao Acesso GPON ############
log.info service
log.info "CFS_VALUEEEEEEE ------"  
#log.info cfs_value
log.info "CFS_VALUEEEEEEE FIM ------" 
log.info @services
if service == "CFS.ACESSOGPON"

############ Verificando se os serviços lógicos presentes estão de acordo com a ordem ############
    i = 0
    item_qtd = service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList']['item'].length
    # log.info service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList']['item'][3]['entityKey']['primaryKey']['type'][1]
    while i < item_qtd-1 do
      got = service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList']['item'][i]['entityKey']['primaryKey']['name']
      expected = service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList']['item'][i]['entityKey']['primaryKey']['type'][1]
      test_helper_assert_equal "Testando valor #{i}", @services[expected], got
      i += 1
    end

############ Verificando tags ############
    test_helper_assert_equal "Testando tag cfsReferenceList", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList'].nil?
    test_helper_assert_equal "Testando tag rfsReferenceList", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['rfsReferenceList'].nil?
    test_helper_assert_equal "Testando tag arrayOfAssociatedRfsResources", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources'].nil?
    test_helper_assert_equal "Testando tag jumper", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['rfs']['describedBy']['item'][4]['value'].nil?

    #log.info "Verificando tags da CDO:"
    #log.info service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][1]['parentResources']['item']['resource']['describedBy']
    #test_helper_assert_equal "Verificando DATA_ESTADO_OPERACIONAL da CDO", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][1]['parentResources']['item']['resource']['describedBy']['item'][0]['value'].nil?
    #test_helper_assert_equal "Verificando ESTADO_OPERACIONAL da CDO", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][1]['parentResources']['item']['resource']['describedBy']['item'][1]['value'].nil?

    #log.info ""
    log.info "Verificando tags da OLT:"
    item_qtd = service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'].length
    #log.info service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']
    test_helper_assert_equal "Verificando BITSTREAM", "BITSTREAM", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][10]['characteristic']
    test_helper_assert_equal "Verificando DATA_ESTADO_CICLO_VIDA da OLT", "DATA_ESTADO_CICLO_VIDA", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][7]['characteristic']
    test_helper_assert_equal "Verificando ESTADO_CICLO_VIDA da OLT", "ESTADO_CICLO_VIDA", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][0]['characteristic']
    test_helper_assert_equal "Verificando VERSAO_SOFTWARE da OLT", "VERSAO_SOFTWARE", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][6]['characteristic']
    test_helper_assert_equal "Verificando SERIAL_NUMBER da OLT", "SERIAL_NUMBER", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][1]['characteristic']
    test_helper_assert_equal "Verificando ENDERECO_IP da OLT", "ENDERECO_IP", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][9]['characteristic']
    test_helper_assert_equal "Verificando MODELO da OLT", "MODELO", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][8]['characteristic']
    test_helper_assert_equal "Verificando MASCARA da OLT", "MASCARA", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][2]['characteristic']
    test_helper_assert_equal "Verificando IGMP_PROXY_IP da OLT", "IGMP_PROXY_IP", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][4]['characteristic']
    test_helper_assert_equal "Verificando GATEWAY da OLT", "GATEWAY", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][3]['characteristic']
    test_helper_assert_equal "Verificando FABRICANTE da OLT", "FABRICANTE", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][5]['characteristic']
    test_helper_assert_equal "Verificando DATA_ESTADO_OPERACIONAL da OLT", "DATA_ESTADO_OPERACIONAL", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][11]['characteristic']
    test_helper_assert_equal "Verificando ESTADO_OPERACIONAL da OLT", "ESTADO_OPERACIONAL", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][12]['characteristic']
    log.info ""

    ##test_helper_assert_equal "Verificando BITSTREAM", "BITSTREAM", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][0]['characteristic']
    #test_helper_assert_equal "Verificando VERSAO_SOFTWARE da OLT", "VERSAO_SOFTWARE", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][0]['characteristic']
    #test_helper_assert_equal "Verificando DATA_ESTADO_CICLO_VIDA da OLT", "DATA_ESTADO_CICLO_VIDA", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][1]['characteristic']
    #test_helper_assert_equal "Verificando ESTADO_CICLO_VIDA da OLT", "ESTADO_CICLO_VIDA", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][2]['characteristic']
    #test_helper_assert_equal "Verificando SERIAL_NUMBER da OLT", "SERIAL_NUMBER", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][3]['characteristic']
    #test_helper_assert_equal "Verificando ENDERECO_IP da OLT", "ENDERECO_IP", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][4]['characteristic']
    #test_helper_assert_equal "Verificando MODELO da OLT", "MODELO", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][5]['characteristic']
    #test_helper_assert_equal "Verificando MASCARA da OLT", "MASCARA", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][6]['characteristic']
    #test_helper_assert_equal "Verificando IGMP_PROXY_IP da OLT", "IGMP_PROXY_IP", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][7]['characteristic']
    #test_helper_assert_equal "Verificando GATEWAY da OLT", "GATEWAY", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][8]['characteristic']
    #test_helper_assert_equal "Verificando FABRICANTE da OLT", "FABRICANTE", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][9]['characteristic']
    #test_helper_assert_equal "Verificando DATA_ESTADO_OPERACIONAL da OLT", "DATA_ESTADO_OPERACIONAL", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][10]['characteristic']
    #test_helper_assert_equal "Verificando ESTADO_OPERACIONAL da OLT", "ESTADO_OPERACIONAL", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][11]['characteristic']
    log.info ""

    log.info "Verificando tags obrigatorias da OLT:"
    test_helper_assert_equal "Verificando preenchimento de Fabricante da OLT", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][9]['value'].nil?
    test_helper_assert_equal "Verificando preenchimento de MODELO da OLT", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][5]['characteristic'].nil?
    test_helper_assert_equal "Verificando preenchimento de ESTADO_CICLO_VIDA da OLT", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][2]['characteristic'].nil?
    test_helper_assert_equal "Verificando preenchimento IGMP_PROXY_IP da OLT", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][7]['characteristic'].nil?
    #test_helper_assert_equal "Verificando preenchimento IGMP_PROXY_IP da OLT", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd]['parentResources']['item']['resource']['describedBy']['item'][6]['characteristic'].nil?
    test_helper_assert_equal "Verificando preenchimento IGMP_PROXY_IP da OLT", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][6]['characteristic'].nil?

############ Verificações relacionadas aos serviços lógicos ############
  elsif @services[service] != nil
    num_cfs = cfs_value service, service_query
    log.info "RETORNOUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
    log.info num_cfs
    num_exp = num_expected service
    bundlename_return = bundlename_value service, service_query
    test_helper_assert_equal "Verificando valor de bundlename do servico #{service}", @bundleNames[service], bundlename_return
    test_helper_assert_equal "Verificando valor de lineid do servico #{service}", num_cfs, num_exp
    
    if service == "CFS.VOIP" #eh preciso validar o technoclass somente no voip    
      log.info "eh vooooooooooooooooooooooooip   " 
      log.info service_query
      log.info "eh vooooooooooooooooooooooooip" 
      technoclass = technoclass_value service_query
      test_helper_assert_equal "Validando valor do technoclass do servico VOIP", "7001", technoclass
    end
    i = 0
    while service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources'].nil?
      i+=1
    end
    if service != "CFS.RFTV"
      test_helper_assert_equal "Testando tag rfsReferenceList", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['rfsReferenceList'].nil?
      test_helper_assert_equal "Testando tag arrayOfAssociatedRfsResources", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources'].nil?
    end
    #log.info "netwin_steps"
    log.info "Verificando tags do BNG"
    #log.info service_query
    log.info "Verificando tipo do equipamento"
    String tipoEquip = service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['key']['primaryKey']['type'][1]
    #String tipoEquip = "teste"
    if (tipoEquip.eql? "ME.BNG")
      tipoEquip = "ME.BNG"
      log.info "tipo equip OK: ME.BNG"
    elsif (tipoEquip.eql? "ME.SR")
      tipoEquip = "ME.SR"
      log.info "tipo equip OK: ME.SR"
    else
      test_helper_assert_equal "FAIL", "sucess", "fail", "Tipo do equipamento diferente de ME.BNG ou ME.SR"
    end

    test_helper_assert_equal "Verificando ESTADO_CICLO_VIDA do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][0]['characteristic'], "ESTADO_CICLO_VIDA"
    test_helper_assert_equal "Verificando SERIAL_NUMBER do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][1]['characteristic'], "SERIAL_NUMBER"
    test_helper_assert_equal "Verificando MASCARA do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][2]['characteristic'], "MASCARA"
    test_helper_assert_equal "Verificando GATEWAY do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][3]['characteristic'], "GATEWAY"
    test_helper_assert_equal "Verificando FABRICANTE do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][4]['characteristic'], "FABRICANTE"
    test_helper_assert_equal "Verificando VERSAO_SOFTWARE do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][5]['characteristic'], "VERSAO_SOFTWARE"
    test_helper_assert_equal "Verificando ENDERECO_ESTACAO_PREDIAL do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][6]['characteristic'], "ENDERECO_ESTACAO_PREDIAL"
    test_helper_assert_equal "Verificando DATA_ESTADO_CICLO_VIDA do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][7]['characteristic'], "DATA_ESTADO_CICLO_VIDA"
    test_helper_assert_equal "Verificando MODELO do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][8]['characteristic'], "MODELO"
    test_helper_assert_equal "Verificando ENDERECO_IP do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][9]['characteristic'], "ENDERECO_IP"
    test_helper_assert_equal "Verificando SIGLA_ESTACAO_PREDIAL do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][10]['characteristic'], "SIGLA_ESTACAO_PREDIAL"
    test_helper_assert_equal "Verificando NOME_ESTACAO_PREDIAL do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][11]['characteristic'], "NOME_ESTACAO_PREDIAL"
    test_helper_assert_equal "Verificando DATA_ESTADO_OPERACIONAL do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][12]['characteristic'], "DATA_ESTADO_OPERACIONAL"
    test_helper_assert_equal "Verificando ESTADO_OPERACIONAL do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][13]['characteristic'], "ESTADO_OPERACIONAL"
    log.info ""
    log.info "Verificando tags obrigatorias do BNG:"
    test_helper_assert_equal "Verificando preenchimento do nome do BNG", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['key']['primaryKey']['name'].nil?
    test_helper_assert_equal "Verificando preenchimento de FABRICANTE do BNG", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][4]['value'].nil?
    test_helper_assert_equal "Verificando preenchimento de MODELO do BNG", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][8]['value'].nil?
    test_helper_assert_equal "Verificando preenchimento de ESTADO_CICLO_VIDA do BNG", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][0]['characteristic'].nil?
  else
     log.info "Servico nao existe na ordem"
  end
end

And(/^I validate nova fibra "([^"]*)" data from "([^"]*)" query at "([^"]*)"$/) do |app, service, endPoint|

  log.info service
  log.info @services

############################# Mapeamento dos endPoints #############################
  if endPoint == "om"
    log.info "ENTREI NO OM"
    log.info "APP:#{app}" 
    endPoint = netwin_api_om
  elsif endPoint == "inventory"
    log.info "ENTREI NO INVENTARIO"
    endPoint = netwin_api_inv
  else
    log.info "Ambito nao especificado corretamente."
  end

############################# Dependendo da combinação de app/service/endpoint uma query diferente é enviada #############################
  if app == "OM"

    log.info "ENTREI NO if do OM"
    
    if endPoint == netwin_api_om
      if service == "CFS.ACESSOGPON"
        #service_query = consultaServicos @serviceOrder, @gpon, service
        service_query = consultaServicos @serviceOrder, $acesso_gpon, service
      elsif @services[service] != nil
        service_query = consultaServicos @serviceOrder, @services[service], service
      end
    elsif endPoint == netwin_api_inv
      if service == "CFS.ACESSOGPON"
        service_query = consultaInventario $acesso_gpon
      elsif @services[service] != nil
        service_query = consultaServicosInventario @services[service], service
      end
    end

  elsif app == "NETQ"
    log.info "ENTREI NO NETQ"
    if service == "CFS.ACESSOGPON"
      log.info "ACESSOGPON !!!!!!!!!"
      log.info service
      service_query = consultaServicosNETQ $acesso_gpon, service, endPoint
      log.info "VOLTEI DA CONSULTASERVICOSNETQ"
      log.info service_query
    elsif @services[service] != nil
      log.info "CONSULTA NETQ !!!!!!!!!!!!"
      service_query = consultaServicosNETQ @services[service], service, endPoint
      log.info "RETORNO DA CONSULTA  !!!!!!!!!!!!"
      log.info service_query
      log.info "RETORNO DA CONSULTA  !!!!!!!!!!!!"
    end
  end
log.info "SAI DO ELSIF DO NETQ"
############ Verificação das tags de Estados operacional e de provisão ############
test_helper_assert_equal "Testando tag state_Service", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['state_Service'].nil?
test_helper_assert_equal "Testando tag operationalState", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['operationalState'].nil?
  
############################# Verificação das tags de acordo com consulta física/lógica #############################
############ Verificações relacionadas ao Acesso GPON ############
log.info service
log.info "CFS_VALUEEEEEEE ------"  
#log.info cfs_value
log.info "CFS_VALUEEEEEEE FIM ------" 
log.info @services
if service == "CFS.ACESSOGPON"

############ Verificando se os serviços lógicos presentes estão de acordo com a ordem ############
    i = 0
    item_qtd = service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList']['item'].length
 
    while i < item_qtd-1 do
      got = service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList']['item'][i]['entityKey']['primaryKey']['name']
      expected = service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList']['item'][i]['entityKey']['primaryKey']['type'][1]
      test_helper_assert_equal "Testando valor #{i}", @services[expected], got
      i += 1
    end

############ Verificando tags ############
    test_helper_assert_equal "Testando tag cfsReferenceList", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['cfsReferenceList'].nil?
    test_helper_assert_equal "Testando tag rfsReferenceList", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['rfsReferenceList'].nil?
    test_helper_assert_equal "Testando tag arrayOfAssociatedRfsResources", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources'].nil?
    test_helper_assert_equal "Testando tag jumper", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['rfs']['describedBy']['item'][4]['value'].nil?

    #log.info "Verificando tags da CDO:"
    #log.info service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][1]['parentResources']['item']['resource']['describedBy']
    #test_helper_assert_equal "Verificando DATA_ESTADO_OPERACIONAL da CDO", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][1]['parentResources']['item']['resource']['describedBy']['item'][0]['value'].nil?
    #test_helper_assert_equal "Verificando ESTADO_OPERACIONAL da CDO", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][1]['parentResources']['item']['resource']['describedBy']['item'][1]['value'].nil?

    #log.info ""
    log.info "Verificando tags da OLT:"
    item_qtd = service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'].length
    #log.info service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']
    test_helper_assert_equal "Verificando VERSAO_SOFTWARE da OLT", "VERSAO_SOFTWARE", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][0]['characteristic']
    test_helper_assert_equal "Verificando DATA_ESTADO_CICLO_VIDA da OLT", "DATA_ESTADO_CICLO_VIDA", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][1]['characteristic']
    test_helper_assert_equal "Verificando ESTADO_CICLO_VIDA da OLT", "ESTADO_CICLO_VIDA", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][2]['characteristic']
    test_helper_assert_equal "Verificando SERIAL_NUMBER da OLT", "SERIAL_NUMBER", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][3]['characteristic']
    test_helper_assert_equal "Verificando ENDERECO_IP da OLT", "ENDERECO_IP", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][4]['characteristic']
    test_helper_assert_equal "Verificando MODELO da OLT", "MODELO", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][5]['characteristic']
    test_helper_assert_equal "Verificando MASCARA da OLT", "MASCARA", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][6]['characteristic']
    test_helper_assert_equal "Verificando IGMP_PROXY_IP da OLT", "IGMP_PROXY_IP", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][7]['characteristic']
    test_helper_assert_equal "Verificando GATEWAY da OLT", "GATEWAY", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][8]['characteristic']
    test_helper_assert_equal "Verificando FABRICANTE da OLT", "FABRICANTE", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][9]['characteristic']
    test_helper_assert_equal "Verificando DATA_ESTADO_OPERACIONAL da OLT", "DATA_ESTADO_OPERACIONAL", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][10]['characteristic']
    test_helper_assert_equal "Verificando ESTADO_OPERACIONAL da OLT", "ESTADO_OPERACIONAL", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][11]['characteristic']
    log.info ""

    log.info "Verificando tags obrigatorias da OLT:"
    test_helper_assert_equal "Verificando preenchimento de Fabricante da OLT", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][9]['value'].nil?
    test_helper_assert_equal "Verificando preenchimento de MODELO da OLT", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][5]['characteristic'].nil?
    test_helper_assert_equal "Verificando preenchimento de ESTADO_CICLO_VIDA da OLT", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][2]['characteristic'].nil?
    test_helper_assert_equal "Verificando preenchimento IGMP_PROXY_IP da OLT", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][item_qtd-1]['parentResources']['item']['resource']['describedBy']['item'][7]['characteristic'].nil?

############ Verificações relacionadas aos serviços lógicos ############
  elsif @services[service] != nil
    num_cfs = cfs_value service, service_query
    log.info "RETORNOUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
    log.info num_cfs
    num_exp = num_expected service
    bundlename_return = bundlename_value service, service_query
    test_helper_assert_equal "Verificando valor de bundlename do servico #{service}", @bundleNames[service], bundlename_return
    test_helper_assert_equal "Verificando valor de lineid do servico #{service}", num_cfs, num_exp
    if service == "CFS.VOIP" #eh preciso validar o technoclass somente no voip     
      technoclass = technoclass_value service_query
      test_helper_assert_equal "Validando valor do technoclass do servico VOIP", "7001", technoclass
    end
    i = 0
    while service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources'].nil?
      i+=1
    end
    if service != "CFS.RFTV"
      test_helper_assert_equal "Testando tag rfsReferenceList", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['cfs']['rfsReferenceList'].nil?
      test_helper_assert_equal "Testando tag arrayOfAssociatedRfsResources", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources'].nil?
    end
    #log.info "netwin_steps"
    log.info "Verificando tags do BNG"
    #log.info service_query
    log.info "Verificando tipo do equipamento"
    String tipoEquip = service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['key']['primaryKey']['type'][1]
    #String tipoEquip = "teste"
    if (tipoEquip.eql? "ME.BNG")
      tipoEquip = "ME.BNG"
      log.info "tipo equip OK: ME.BNG"
    elsif (tipoEquip.eql? "ME.SR")
      tipoEquip = "ME.SR"
      log.info "tipo equip OK: ME.SR"
    else
      test_helper_assert_equal "FAIL", "sucess", "fail", "Tipo do equipamento diferente de ME.BNG ou ME.SR"
    end

    test_helper_assert_equal "Verificando ESTADO_CICLO_VIDA do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][0]['characteristic'], "ESTADO_CICLO_VIDA"
    test_helper_assert_equal "Verificando SERIAL_NUMBER do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][1]['characteristic'], "SERIAL_NUMBER"
    test_helper_assert_equal "Verificando MASCARA do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][2]['characteristic'], "MASCARA"
    test_helper_assert_equal "Verificando GATEWAY do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][3]['characteristic'], "GATEWAY"
    test_helper_assert_equal "Verificando FABRICANTE do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][4]['characteristic'], "FABRICANTE"
    test_helper_assert_equal "Verificando VERSAO_SOFTWARE do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][5]['characteristic'], "VERSAO_SOFTWARE"
    test_helper_assert_equal "Verificando ENDERECO_ESTACAO_PREDIAL do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][6]['characteristic'], "ENDERECO_ESTACAO_PREDIAL"
    test_helper_assert_equal "Verificando DATA_ESTADO_CICLO_VIDA do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][7]['characteristic'], "DATA_ESTADO_CICLO_VIDA"
    test_helper_assert_equal "Verificando MODELO do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][8]['characteristic'], "MODELO"
    test_helper_assert_equal "Verificando ENDERECO_IP do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][9]['characteristic'], "ENDERECO_IP"
    test_helper_assert_equal "Verificando SIGLA_ESTACAO_PREDIAL do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][10]['characteristic'], "SIGLA_ESTACAO_PREDIAL"
    test_helper_assert_equal "Verificando NOME_ESTACAO_PREDIAL do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][11]['characteristic'], "NOME_ESTACAO_PREDIAL"
    test_helper_assert_equal "Verificando DATA_ESTADO_OPERACIONAL do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][12]['characteristic'], "DATA_ESTADO_OPERACIONAL"
    test_helper_assert_equal "Verificando ESTADO_OPERACIONAL do BNG", service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][13]['characteristic'], "ESTADO_OPERACIONAL"
    log.info ""
    log.info "Verificando tags obrigatorias do BNG:"
    test_helper_assert_equal "Verificando preenchimento do nome do BNG", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['key']['primaryKey']['name'].nil?
    test_helper_assert_equal "Verificando preenchimento de FABRICANTE do BNG", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][4]['value'].nil?
    test_helper_assert_equal "Verificando preenchimento de MODELO do BNG", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][8]['value'].nil?
    test_helper_assert_equal "Verificando preenchimento de ESTADO_CICLO_VIDA do BNG", true, !service_query['Envelope']['Body']['queryResponse']['namedQueryResponse']['arrayOfservicesAndResources']['item']['arrayOfAssociatedRfsResources']['item']['resources']['item'][i]['associatedResources']['item']['describedBy']['item'][0]['characteristic'].nil?
  else
     log.info "Servico nao existe na ordem"
  end
end

