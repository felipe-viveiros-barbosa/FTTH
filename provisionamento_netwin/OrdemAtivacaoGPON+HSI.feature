@REQ_NETWIN-0002
Feature: Ordem de Ativacao GPON + HSI
	Nessa feature e criada uma ordem de ativacao para o aprovisionamento 
	de servicos. E verificada a disponibilidade do cliente receber os servicos 
	em seu endereco, verificando se o endereço possui viabilidade, ou seja, 
	se tem os recursos (rede) necessarios para realizar o aprovisionamento.  
    Com a viabilidade, e possivel criar a ordem de ativacao para o cliente, 
    no caso dessa feature, com os servicos logicos: iptv, hsi, rftv e voip.
    O serviço ACESSOGPON está relacionado com as características físicas da rede.
    No xml, esse serviço é o que deve levar as informações do endereço onde o os 
    serviços serão usados. Os demais serviços são chamados de serviços lógicos.
    Passo a passo da operação de Ativacao:
    - Encontrar um endereço válido
	- Enviar xml de ativação
	- Enviar xml da consulta fisica da rede (consulta de facilidades Fisica)
	- Enviar xml da consulta aos Logicos 1 (consulta de facilidades Logica 1)
	- Enviar xml da consulta aos Logicos 2 (consulta de facilidades Logica 2)
	- Enviar xml de Update de CPE
	- Enviar xml de Update de Cabo Riser/CDOIA
	- Enviar xml de fechamento da ordem
	- Enviar xml de consulta ao inventario


	@TEST_NETWIN-7_2_7
	Scenario Outline: Criacao da Ordem
		#Given the address of client with id "<addressId>" in station "<station>" its valid
		Given Eu valido se o idEndereco e valido
		And I set bundle name for each service
			| CFS.HSI |
			|<BND.HSI>|
		Then I create one activation order with the services
			| CFS.HSI | 
			|<CFS.HSI>|
		And I make a service GPON query teste

		And I validate "NETQ" data from "CFS.ACESSOGPON" query at "om"
		#And I validate "NETQ" data from "CFS.IPTV" query at "om"
		And I validate "NETQ" data from "CFS.HSI" query at "om"
		#And I validate "NETQ" data from "CFS.VOIP" query at "om"
		And I validate "OM" data from "CFS.ACESSOGPON" query at "om"
		#And I validate "OM" data from "CFS.IPTV" query at "om"
		And I validate "OM" data from "CFS.HSI" query at "om"
		#And I validate "OM" data from "CFS.VOIP" query at "om"

		#And I validade data from "CFS.IPTV" query
		And I validade data from "CFS.HSI" query
		#And I validade data from "CFS.VOIP" query 
		#And I validade data from "CFS.RFTV" query

		And I make the order update CPE
		And I make the order update CR
		And I finish the order
 
		And I validate physical inventory

		And I validate "NETQ" data from "CFS.ACESSOGPON" query at "inventory"
		#And I validate "NETQ" data from "CFS.IPTV" query at "inventory"
		And I validate "NETQ" data from "CFS.HSI" query at "inventory"
		#And I validate "NETQ" data from "CFS.VOIP" query at "inventory"
		And I validate "OM" data from "CFS.ACESSOGPON" query at "inventory"
		#And I validate "OM" data from "CFS.IPTV" query at "inventory"
		And I validate "OM" data from "CFS.HSI" query at "inventory"
		#And I validate "OM" data from "CFS.VOIP" query at "inventory"

		#And I validate inventory data from "CFS.IPTV" query
		And I validate inventory data from "CFS.HSI" query
		#And I validate inventory data from "CFS.VOIP" query
		#And I validate inventory data from "CFS.RFTV" query

	Examples:
		| addressId | station | CFS.IPTV | CFS.HSI | CFS.RFTV | CFS.VOIP |   BND.HSI    |    BND.IPTV    |     BND.RFTV    |    BND.VOIP      |
		|           |         |    X     |    X    |     X    |    X     | VELOC_5MBPS | PCT_CANAL_IPTV | PCT_CANeu tenhAL_RF_RF | OIVOIP_ILIMITADO |
	#	|           |          |    X     |    X    |     X    |    X     | VELOC_50MBPS | PCT_CANAL_IPTV | PCT_CANAL_RF_RF | OIVOIP_ILIMITADO |
 	#	|     311819      |         |    X     |    X    |     X    |    X     | VELOC_50MBPS | PCT_CANAL_IPTV | PCT_CANAL_RF_RF | OIVOIP_ILIMITADO |
