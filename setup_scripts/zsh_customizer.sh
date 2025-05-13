

echo -e "[*] Installing Oh My Zsh and Powerlevel10k for user $user...\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo -e "\n[*] Installing Oh My Zsh and Powerlevel10k for user root...\n"
sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k

if [[ -d "$fdir" ]]; then
    cp -rv $dir/fonts/* $fdir
else
    mkdir -p $fdir
    cp -rv $dir/fonts/* $fdir
fi

echo -e "\n[*] Configuring the .zshrc and .p10k.zsh files...\n"
cp -v $dir/.zshrc ~/.zshrc
sudo ln -sfv ~/.zshrc /root/.zshrc
cp -v $dir/.p10k.zsh ~/.p10k.zsh
sudo ln -sfv ~/.p10k.zsh /root/.p10k.zsh

sudo chmod +x /usr/local/share/zsh/site-functions/_bspc
sudo chown root:root /usr/local/share/zsh/site-functions/_bspc


