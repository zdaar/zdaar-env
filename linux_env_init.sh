
# Install Nerdfont system wide
sudo chmod 644 envFonts/JetBrainsMonoNerd.ttf
sudo cp envFonts/JetBrainsMonoNerd.ttf /usr/local/share/fonts
fc-cache -fv

# Install starship prompt

curl -sS https://starship.rs/install.sh | sh

echo 'eval "$(starship init bash)"' >> ~/.bashrc

mkdir -p ~/.config
cp terminal/starship/starship.toml ~/.config/starship.toml

echo "Done. type source ~/.bashrc to reload your shell."
