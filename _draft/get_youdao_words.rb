require 'net/http'
require 'nokogiri'
require 'cgi'
require 'oj'

def get_words(cookies)
  site = nil
  File.open("words.md", "w") do |file|
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
cookies = "OUTFOX_SEARCH_USER_ID=-1453803055@211.144.203.114; YOUDAO_EAD_UUID=da96e80d-5bf0-4b95-9077-0ead50e1712b; _ntes_nnid=515e9d18cf35ff63142fedd3a182f13d,1427698839154; YOUDAO_MOBILE_ACCESS_TYPE=1; webDict_HdAD=%7B%22req%22%3A%22http%3A//dict.youdao.com%22%2C%22width%22%3A960%2C%22height%22%3A240%2C%22showtime%22%3A5000%2C%22fadetime%22%3A500%2C%22notShowInterval%22%3A3%2C%22notShowInDays%22%3Afalse%2C%22lastShowDate%22%3A%22Mon%20Nov%2008%202010%22%7D; ___rl__test__cookies=1427850757387; DICT_UGC=6975176f3726e5ed1ae304a5c9cd3cfd|ffhmusashi@163.com; JSESSIONID=abc4r7g40CSBmaNL3EPXu; DICT_SESS=v2|URSM|DICT||ffhmusashi@163.com||urstoken||mtbXi_fgzLXstEjrO0KCL8WoxC_Bt_vKFkv28arBMPAqybvYyrnuZzIRO5yzPKJP0mN5C8zZM9vSXigSCRcBfbR62v8NKw78Qt.f6v8vhuwhzfOmbO328vMibAiqwnjxObuDtqiqcQozOff_5JjEJTQWvuBEpENhmME5.lKOqotiKhCk4_W6RBOiu||604800000||ll0HeShLYY0zW6LwS0Lez0gyhLOEOLlGRqynM640flG0z56L6z0Mp4R64kfTzhMJyRwLhMPSOfY50YMRLqBRfYA0; DICT_LOGIN=3||1427700973812"
#get_words(site, cookies.to_a.map{|c| c.join('=')}.join(';'))
# get_words(cookies)

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

login_youdao 