
#!/usr/bin/python
import urllib
import platform
import subprocess
import os

findos = (platform.linux_distribution()[0])

if findos == "Ubuntu" or findos=="debian":
        url = "https://raw.githubusercontent.com/sk00t3r/PaycoinAutoNode/1-step-install/PaycoinAutoNodeDeb.sh"
        file_name = "PaycoinAutoNodeDeb.sh"
        urllib.urlretrieve(url, file_name)
        os.chmod("/opt/PaycoinAutoNodeDeb.sh", 755)
        subprocess.call("./PaycoinAutoNodeDeb.sh")

elif findos == "CentOS Linux":
        url = "https://raw.githubusercontent.com/sk00t3r/PaycoinAutoNode/1-step-install/PaycoinAutoNodeRehl.sh"
        file_name = "PaycoinAutoNodeRehl.sh"
        urllib.urlretrieve(url, file_name)
        os.chmod("/opt/PaycoinAutoNodeRehl.sh", 755)
        subprocess.call("./PaycoinAutoNodeRehl.sh")

else:
        print "Operating System Not Supported, Please Install Manually"













