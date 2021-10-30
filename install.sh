#! /bin/bash

if ((EUID != 0)); then
	echo "Please run this script with elevated privileges (sudo or root)"
	exit
fi

# get sudo and create dirs

mkdir -p /opt/metasploit
mkdir -p /opt/recon
mkdir -p /opt/webtools
mkdir -p /opt/scripts
mkdir -p /opt/payloads
mkdir -p /opt/wordlists
mkdir -p /opt/windows
mkdir -p /opt/helpers

# yellow text support

cecho() {
	YELLOW="\033[1;33m"
	NC="\033[0m" # No Color
	printf "${!1}${2} ${NC}\n"
}

# installing  tools
apt-get update -y

cecho "Installing golang and python pip"
wget https://golang.org/dl/go1.17.2.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.2.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
apt-get -y install python3-pip

cecho "Installing helpesr and QoL stuff"
go get -u github.com/tomnomnom/gron
echo 'alias norg="gron --ungron' >>~/.zshrc
echo 'alias ungron="gron --ungron"' >>~/.zshrc
cd /opt/helpers && git clone https://github.com/tomnomnom/gf.git && echo 'source /opt/helpers/gf/gf-completion.zsh' >>~/.zshrc

cecho "Installing zsh"
apt-get -y install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed -i 's/robbyrussell/agnoster/' ~/.zshrc
sed -i 's/^plugins=(\(.*\)/plugins=(zsh-autosuggestions zsh-syntax-highlighting \1/' ~/.zshrc

cecho "Installing docker"
apt-get -y install docker.io

cecho "Installing recon"
cd /opt/recon
apt-get -y install nmap
git clone https://github.com/bluecanarybe/SubdomainEnum.git
git clone https://github.com/FortyNorthSecurity/EyeWitness.git
go install github.com/OJ/gobuster/v3@latest
curl -sL https://raw.githubusercontent.com/epi052/feroxbuster/master/install-nix.sh | bash
git clone https://github.com/nyxgeek/o365recon
git clone https://github.com/robertdavidgraham/masscan
git clone https://github.com/dogasantos/masstomap

cecho "webtools"
cd /opt/webtools
git clone https://github.com/D35m0nd142/LFISuite.git
git clone https://github.com/wpscanteam/wpscan.git
git clone https://github.com/droope/droopescan.git
git clone https://github.com/sqlmapproject/sqlmap.git
git clone https://github.com/swisskyrepo/PayloadsAllTheThings
wget http://testssl.sh/testssl.sh
git clone https://github.com/devanshbatham/ParamSpider
git clone https://github.com/Ebryx/S3Rec0n
git clone https://github.com/swisskyrepo/SSRFmap.git
git clone https://github.com/jonaslejon/malicious-pdf.git
git clone https://github.com/edoardottt/cariddi.git && cd cariddi && go get && make linux
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
go get -u github.com/ffuf/ffuf
git clone https://github.com/BuffaloWill/oxml_xxe.git
git clone https://github.com/almandin/fuxploider.git
git clone https://github.com/commixproject/commix.git

cecho "Installing wordlists"
cd /opt/wordlists
git clone https://github.com/danielmiessler/SecLists.git
wget -nc http://downloads.skullsecurity.org/passwords/rockyou.txt.bz2
apt-get -y install hashcat

cecho "Installing windows/linux exploits"
cd /opt/post-exploitation
git clone https://github.com/AlessandroZ/LaZagne.git
git clone https://github.com/CoreSecurity/impacket.git
pip install ldap3
git clone https://github.com/EmpireProject/Empire.git
git clone https://github.com/rebootuser/LinEnum.git
git clone https://github.com/Veil-Framework/Veil-Evasion.git
git clone https://github.com/lgandx/Responder
git clone https://github.com/liamg/traitor.git

cecho "metasploit"
cd /opt/metasploit
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb >msfinstall &&
	chmod 755 msfinstall &&
	./msfinstall
