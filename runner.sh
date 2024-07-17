#!/bin/sh      

echo "Masukan Username VPS: "                                                                                                                                                                     
read USERNAME

echo "Masukan Email Mu: "
read EMAIL                                                                                                                                
                                                                                                                                                                     
if id "$USERNAME" &>/dev/null; then                                                                                                                                  
    echo "User $USERNAME found."                                                                                                                                     
else                                                                                                                                                                 
    echo "User $USERNAME does not exist. Please create the user first."                                                                                              
    exit 1                                                                                                                                                           
fi                                                                                                                                                                   
                                                                                                                                                                     
if ! command -v sudo &>/dev/null; then                                                                                                                               
    echo "Installing sudo..."                                                                                                                                        
    apk update                                                                                                                                                       
    apk add sudo                                                                                                                                                     
else                                                                                                                                                                 
    echo "Sudo is already installed."                                                                                                                                
fi                                                                                                                                                                   
                                                                                                                                                                     
echo "Adding $USERNAME to the wheel group..."                                                                                                                        
adduser "$USERNAME" wheel                                                                                                                                            
                                                                                                                                                                     
# Konfigurasi sudoers file                                                                                                                                           
echo "Configuring sudoers file..."                                                                                                                                   
if grep -q "^%wheel ALL=(ALL) ALL" /etc/sudoers; then                                                                                                                
    echo "Wheel group already has sudo privileges."                                                                                                                  
else                                                                                                                                                                 
    echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers                                                                                                                      
    echo "Sudo privileges granted to wheel group."   
fi                                                                                                                                                                   
                                                                                                                                                                     
echo "Done. User $USERNAME has been added to the wheel group and granted sudo privileges."                                                                           
                                                                                                                                                                     
echo "Verifying sudo access for $USERNAME..."                                                                                                                        
sudo -l -U "$USERNAME"   

echo "Installing Nano...."
sudo apk add nano

echo "Installing nodejs and npm..."
sudo apk add --no-cache nodejs npm

echo "installing python3, pip"
sudo apk add --no-cache python3 py3-pip

if [ -z "$EMAIL" ]; then
    echo "Email belum diatur. Silakan atur variabel EMAIL dengan email GitHub Anda."
    exit 1
fi

echo "Generating SSH key pair..."
ssh-keygen -t rsa -b 4096 -C "$EMAIL"

echo "Masukkan alamat workdir SSH: "
read workdirssh

# Menyalin kunci publik ke clipboard (gunakan xclip untuk Alpine Linux)
cat $workdirssh/.ssh/id_rsa.pub | xclip -selection clipboard

if ! command -v ssh &>/dev/null; then
    echo "Installing openssh..."
    apk update
    apk add openssh
else
    echo "Openssh sudah terinstal."
fi

echo "Setup SSH completed."
