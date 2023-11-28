#!/usr/bin/env bash
os_name=$(grep '^PRETTY_NAME=' /etc/os-release);
echo "[START] configure your ${os_name/PRETTY_NAME=/}";

echo "Set your full name";
read full_name;
echo "Set your email";
read email;

echo "[UPDATING] system...";
sudo apt update -y && sudo apt upgrade -y

echo "[START] --> Installing base libs...";
sudo apt install software-properties-common \
		 silversearcher-ag \
		 ack \
		 fontconfig \
		 build-essential \
		 default-jdk \
		 libssl-dev \
		 exuberant-ctags \
		 ncurses-term \
		 ubuntu-restricted-extras \
		 squashfs-tools -y
echo "[DONE] --> Installing base libs...";

echo "[START] Install base softwares...";

echo "[INSTALLING] TMUX...";
type -p tmux >/dev/null || (sudo apt install tmux -y)

echo "[INSTALLING] CURL...";
type -p curl >/dev/null || (sudo apt install curl -y)

echo "[INSTALLING] GITHUB CLI...";
type -p gh >/dev/null || (curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y)

echo "[INSTALLING] GIT...";
type -p git >/dev/null || (sudo apt install git -y)

echo "[CONFIGURING] GIT...";
git config --global user.name "$full_name"
git config --global user.email "$email"
git config --global init.defaultBranch main

echo "[INSTALLING] ASDF...";
which asdf >/dev/null || (git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0
echo "[CONFIGURING] ASDF...";
# backup .bashrc
cp "$HOME/.bashrc" "$HOME/.bashrc_bkp"
echo ". $HOME/.asdf/asdf.sh" >> "$HOME/.bashrc"
echo ". $HOME/.asdf/completions/asdf.bash" >> "$HOME/.bashrc")

echo "[INSTALLING] ASDF Nodejs(latest)...";
type -p node >/dev/null || (sudo apt install dirmngr gpg curl gawk -y
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest)

echo "[INSTALLING] ASDF Java(zulu:latest)...";
type -p java >/dev/null || (asdf plugin-add java https://github.com/halcyon/asdf-java.git
asdf install javal latest:zulu
asdf global java latest:zulu)

echo "[INSTALLING] .NET Core(latest)";
type -p dotnet >/dev/null || (asdf plugin add dotnet https://github.com/hensou/asdf-dotnet.git
asdf install dotnet latest
asdf global dotnet latest)

echo "[INSTALLING] Docker...";
#type -p docker >/dev/null && (for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done;)

type -p docker >/dev/null || (sudo apt install ca-certificates gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y)

echo "[INSTALLING] Vscode...";
sudo snap install code --classic

echo "[INSTALLING] IntelliJ...";
sudo snap install intellij-idea-community --classic

echo "[INSTALLING] Obsidian...";
sudo snap install obsidian --classic

echo "[INSTALLING] Postman...";
sudo snap install postman

echo "[INSTALLING] Flatpak...";
sudo apt install flatpak -y
sudo add-apt-repository ppa:flatpak/stable
sudo apt update -y
sudo apt install flatpak -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "[INSTALLING] Gparted...";
sudo apt install gparted -y

echo "[FINISH] All set!";
echo "System should be restarted in 10 seconds. To CANCEL [CRTL+C]...";
sleep 15s
reboot
