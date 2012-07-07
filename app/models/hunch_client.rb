class HunchClient
  attr_reader :app_secret

  @@app_secret = "0f9e7e9b3e2ed7dae6d8d4a3fb246e1964723d91"

  def self.signed_get_json url
    auth_sig = get_auth_sig url, @@app_secret
    url = "#{url}&auth_sig=#{auth_sig}"
    send_get_request url
  end

  def self.get_json url
    send_get_request url
  end

  def self.send_get_request url
    begin
      response = RestClient.get url
      hash = JSON.parse(response).symbolize_keys
    rescue => e
      raise "#{e.response}"
    end
    hash
  end

  def self.enc(string)
    return string.gsub(/%20/,'+').gsub(/[+\/@]/,'+' => '%2B', '/' => '%2F', '@' => '%4O')
  end

  def self.get_auth_sig(url, app_secret)
    params = {}
    URI.parse(url).query.split('&').each do |part|
      if name = part.split('=')[0] and val = part.split('=')[1]
        params[name] = val
      else
        params[name] = ''
      end
    end

    canonical = ''
    params.sort.each do |key,val|
      canonical += key + '=' + enc(val.encode('utf-8')) + '&'
    end

    #this removes the trailing &
    canonical = canonical[0,canonical.size-1]

    string_to_sign = enc(canonical) + app_secret
    return Digest::SHA1.hexdigest(string_to_sign)
  end
  
  
end