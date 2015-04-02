require 'net/http'
require 'nokogiri'
require 'cgi'
require 'oj'

def get_words(cookies)
  site = nil
  File.open("words.md", "w") do |file|
  	str = <<-EOF
---
layout: document
title: Words
---
# Words
| word | pronounce | meaning |
| ---- | --- | --- |
EOF
  	file.puts str
    57.times do |i|
      site = "http://dict.youdao.com/wordbook/wordlist?keyfrom=dict.result?p=#{i}&tags="
    
      uri = URI.parse(site)
      http = Net::HTTP.new(uri.host, 80)
      request = Net::HTTP::Get.new(uri.request_uri)
      request['Cookie'] = cookies
      r = http.request(request)
      #p r.body

      doc = Nokogiri::HTML(r.body)

      doc.at_css("#wordlist table").css('tr').each do |tr|
        temp = tr.css('td')
        word = temp[1].text
        pronounce = temp[2].text
        meaning = temp[3].text.gsub(" ", '').gsub("\n", '')

        file.puts "| #{word} | #{pronounce} | #{meaning} |"
      end
    end
  end
end

cookies = {}
cookies["DICT_LOGIN"] = ""
cookies = "user-from=web.index; from-page=http://www.youdao.com/; JSESSIONID=abc2iKxz3G4tbgAo8faSu; webDict_HdAD=%7B%22req%22%3A%22http%3A//dict.youdao.com%22%2C%22width%22%3A960%2C%22height%22%3A240%2C%22showtime%22%3A5000%2C%22fadetime%22%3A500%2C%22notShowInterval%22%3A3%2C%22notShowInDays%22%3Afalse%2C%22lastShowDate%22%3A%22Mon%20Nov%2008%202010%22%7D; _ntes_nnid=03441b8fdd8729a7dee733616324e6a3,1421635733027; YOUDAO_EAD_UUID=e8ad4457-c1cf-4f5d-9adb-7309dc42f48d; pgv_pvi=5587955712; pgv_si=s4889699328; OUTFOX_SEARCH_USER_ID=-1725961088@211.144.203.114; DICT_FORCE=true; DICT_SESS=v2|URSM|DICT||ffhmusashi@163.com||urstoken||dMROKsLUZRPGz9vS9r4Ary4NWXYhteSmpAQfb.ZR9nEaUGQvUZBPoCLF2sUCnmpnWdMs7bCo9rQIT5tI7FjRNGFyfQbMmD6bi4eNyQbQqPDqCN2dG21fbQ95GE5aDBul2GPK4a5ajigC2NNxspuHpSi_QPRHVHMqd9Hsecm2ag45mq7Akx_yFR25P||604800000||Yf0LJukMQL0wy64qynfQL0gBkMQ4nMJS0Y5646ShHJuRTBn4JykLUMRwu64gS0MTZ0qZOMOm0MzG06Bh4OGPMqFR; DICT_PERS=v2|urstoken||DICT||web||-1||1427961480806||211.144.203.114||ffhmusashi@163.com||pZ0fUEkfYm0UYOLUYhMzE0e4OMzfhHQy0zG6MeF0Hg4RUWRH6LRHTu0e4OM6L0HqB0QuOMTukfJZ0wyOfTuPLzMR; DICT_LOGIN=7||1427961480822; DICT_UGC=6975176f3726e5ed1ae304a5c9cd3cfd|ffhmusashi@163.com; PICUGC_FLASH=; PICUGC_SESSION=90fbe28fda40b5ff04f343a261160ce83d3439fc-%00_TS%3Asession%00; ___rl__test__cookies=1427962694896"
#get_words(site, cookies.to_a.map{|c| c.join('=')}.join(';'))
 get_words(cookies)

def login_youdao
  site = "https://reg.163.com/logins.jsp"
  params = {}
  params["url"] = "http://account.youdao.com/login?success=1"
  params["product"] = "search"
  params["type"] = "1"
  params["username"] = ''
  params["password"] = ''
  uri = URI.parse(site)
  respond = Net::HTTP.post_form(uri, params)

  puts respond.body
  
 
end

#login_youdao 
