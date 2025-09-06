# 🐳 Webmin on Ubuntu 24.04 (Dockerized)

This project provides a **Dockerized Ubuntu 24.04 server** running [Webmin](https://www.webmin.com/) for full system administration via a web interface.  
It comes pre-installed with common server packages (Apache, Nginx, MariaDB, Postfix, Dovecot, BIND, FTP, SpamAssassin, ClamAV, etc.) so that **all Webmin modules** are available.

---

## ✨ Features
- Ubuntu **24.04 (Server, headless)** base image
- Latest **Webmin (2.500)** installed from `.deb`
- Preinstalled system tools:
  - `ifconfig` (net-tools), `ip` (iproute2), etc.
- Preinstalled servers:
  - Apache2, Nginx
  - MariaDB
  - Postfix, Dovecot (IMAP/POP3)
  - BIND9 (DNS)
  - vsftpd (FTP)
  - SpamAssassin, ClamAV
- Webmin **user accounts** created automatically:
  - `adminuser / adminpass` → full administrator (`*`)
  - `limiteduser / limitedpass` → access to `System` + `File`
  - `readonly / readonlypass` → access to `File` only
- Ports exposed:
  - **10000** → Webmin
  - **80 / 443** → Apache & Nginx
  - **21** → FTP

---

## 📂 Project Structure
```

.
├── Dockerfile
├── docker-compose.yaml
├── webmin_2.500_all.deb   # Webmin .deb (place it here)
└── create-webmin-users.sh # Creates initial Webmin accounts

````

---

## 🚀 Usage

### 1. Clone this repo & add Webmin `.deb`
Download the latest Webmin `.deb` from [Webmin GitHub Releases](https://github.com/webmin/webmin/releases)  
and place it in the project directory (named `webmin_2.500_all.deb`).

### 2. Build the image
```bash
sudo docker compose build --no-cache
````

### 3. Run the container

```bash
sudo docker compose up -d
```

### 4. Access Webmin

Open your browser and go to:

```
https://<your-docker-host>:10000
```

* **Username:** `adminuser`
* **Password:** `adminpass`

(also available: `limiteduser / limitedpass`, `readonly / readonlypass`)

⚠️ Change these credentials immediately after first login!

---

## 🔧 Configuration

* Webmin config files are stored in `/etc/webmin`
* Logs are in `/var/log/webmin`
* Both are mounted as **Docker volumes** (see `docker-compose.yaml`), so they persist across rebuilds.
* To add/change Webmin accounts, edit [`create-webmin-users.sh`](./create-webmin-users.sh) and rebuild.

---

## 📦 Installed Packages

| Category    | Packages                                                               |
| ----------- | ---------------------------------------------------------------------- |
| Networking  | `net-tools`, `iproute2`, `curl`, `wget`                                |
| Web Servers | `apache2`, `nginx`                                                     |
| Database    | `mariadb-server`                                                       |
| Mail        | `postfix`, `dovecot-core`, `dovecot-imapd`, `dovecot-pop3d`            |
| DNS         | `bind9`                                                                |
| FTP         | `vsftpd`                                                               |
| Security    | `openssl`, `spamassassin`, `clamav`                                    |
| Utilities   | `perl`, `git`, `vim`, `unzip`, `shared-mime-info`, `apt-show-versions` |

---

## ⚠️ Notes

* This image is **not production-ready** out of the box. It’s intended as a sandbox / learning environment.
* Services like **Postfix, Dovecot, Apache, MariaDB** are installed but may not autostart inside Docker.

  * Webmin will detect their configs/binaries so modules show up.
  * If you want daemons to run alongside Webmin, consider adding `supervisord` or `systemd` to manage multiple processes.
* Default credentials are weak and only for testing — **change them immediately**.

---

## 🛠️ Next Steps

* Configure TLS/SSL for Webmin
* Set up real domains for Apache/Nginx
* Enable MariaDB/Postfix/Dovecot inside the container (with `supervisord`)
* Or run them as **separate dedicated containers** and let Webmin manage them remotely.

---

## 📜 License

MIT — do whatever you want, but don’t forget to secure your server 😉

