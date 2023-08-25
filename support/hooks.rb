# -*- encoding : utf-8 -*-

$sshcons={}
$testsran={}
$path = ""


Before do |scenario|
end

After do |scenario|
  #test_key=scenario.source_tag_names.to_s.match(/TEST_(\w*-\d+)/).captures[0].to_s
  testtags=scenario.source_tag_names.to_s.match(/TEST_(\w*-\w+)/)
  test_key=nil
  if !testtags.nil?
    test_key=testtags.captures[0].to_s
  end
  reqs=scenario.source_tag_names.to_s.match(/REQ_(\w*-\d+)/)
  req_keys=nil
  if !reqs.nil?
    req_keys=reqs.captures * ","
  end
  case scenario.status
    when :failed
      test_status = 'fail'
    when :passed
      test_status = 'pass'
    else
      test_status='skip'
  end

  $stdout.puts "\nTMAP:#{test_key}:#{req_keys}:#{test_status}\n"
  # guardar issue key do teste para evitar executa-lo mais do que uma vez
  # $testsran[test_key]=1

  $VERSION = TestC::Config.tmap["version"]
  $REVISION = TestC::Config.tmap["svn_revision"]

  target = testtags.to_s.split("-")
  $SUMMARY = "#{target[0]}#{target[1]}"
  $DATE = generate_today_date

  if TestC::saved_values["tmap_file"].nil? or TestC::saved_values["test_key"].to_s != test_key.to_s
    TestC::saved_values["test_key"] = test_key.to_s
    TestC::saved_values["tmap_file"] = "texec-#{$VERSION}-r#{$REVISION}-#{$SUMMARY}-#{$DATE}.result.log"
    path = "./public/#{TestC::saved_values["tmap_file"]}"
    out_file = File.new(path, "w+")
    out_file.write("TMAP:#{test_key}:#{req_keys}:#{test_status}")
    out_file.close
  else
    path = "./public/#{TestC::saved_values["tmap_file"]}"
    data = File.read(path)
    out_file = File.open(path, "w+")
    out_file.write("#{data}\nTMAP:#{test_key}:#{req_keys}:#{test_status}")
    out_file.close
  end

  log.info "Ambiente de execucao: #{ENV['ENV']}"
  #Insere na tabela de teste
  #hash = {}; 
  #hash['test_key']= test_key
  #hash['req_key']= req_keys
  #hash['testplan_key']= ENV['TESTPLAN_KEY'] 
  #hash['test_status']= test_status
  #hash['environment']=ENV['ENV']
  #sso_testexec_auto hash
end


# AfterStep do |step|
#
# end

# at_exit do
#
# end