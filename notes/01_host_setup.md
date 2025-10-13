# Host setup

## Add user

```bash
groupadd ubuntu
useradd -m -c "Ubuntu user" ubuntu -g ubuntu -s /bin/bash
sudo visudo
```

Add lines,
```bash
# Allow ubuntu user to perform sudo functions  
ubuntu ALL=NOPASSWD: ALL
```

## Switch to new user

```bash
su ubuntu
```

## SSH

Get public key from .pem file on your localhost,
```bash
ssh-keygen -y -f /path/to/key.pem
```

Create .ssh directory and .ssh/authorized_keys on remote host,
```bash
ssh-keygen -t rsa -b 4096 -C "your_name host_name"
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

Add public key of localhost to remote host,
```bash
cd ~/.ssh
vi authorized_keys
```

Change SSH port,
```bash
sudo vi /etc/ssh/sshd_config 
Port 18001
```

Disable Password Authentication,
```bash
sudo vi /etc/ssh/sshd_config
PasswordAuthentication no
```

Disable Root Login,
```bash
sudo vi /etc/ssh/sshd_config
PermitRootLogin no
```

Restart sshd
```bash
sudo /etc/init.d/ssh restart
```

Check if SSH is running,
```bash
sudo lsof -i:18001
```

## Disable Root

```bash
sudo passwd -l root
```
## Additional tools

### jq

Lightweight command-line tool for working with JSON data

```bash
sudo apt install jq
```
