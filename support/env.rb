# -*- encoding : utf-8 -*-
#needed for TestC formatter in Jenkins
require 'testc/formatter/html'
require 'testc'
require 'testc/utils'
require 'testc/db/oracle'

require 'nokogiri'

require 'testc/tmap'
require 'active_support/all'
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lib_require')

TestC.saved_exceptions.push "sapRequestCode"
TestC.saved_exceptions.push "tmap_file"
TestC.saved_exceptions.push "test_key"
TestC.saved_exceptions.push "test_key"
TestC.saved_exceptions.push "internal_partner_publicId"

ENV['LANG']='en_US.UTF-8'
ENV['NLS_LANG']='AMERICAN_AMERICA.WE8MSWIN1252'
