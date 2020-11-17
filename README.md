# pterodactyl-fastdl
## Requirements
- Pterodactyl Wings 1.0
- Web server like nginx/apache
## Installation
1. Add fastdl-include.cfg to /etc/pterodactyl/
    - You can add extensions files that you want to sync to web server folder.

2. Add <span>fastdl.sh</span> to /usr/local/bin/
    - <span>fastdl.sh</span> has configiguration variables in the first line of code that you can edit.

3. Run the command below to give exec permissions
    - chmod +x /usr/local/bin/fastdl.sh

4. Add fastdl.service to /etc/systemd/system/

5. Install rsync dependency
    - apt -y install rsync

6. Run the command below to start fastdl
    - systemctl start fastdl

7. Run the command below to view logs
    - journalctl -f -u fastdl

8. If started correctly and there are sync logs, close logs with
    - ctrl + c

9. Run the following command to automatically start fastdl on system boot
    - systemctl enable fastdl

You should be able to see the synced files in /var/www/pterodactyl-fastdl/ and now we only need to assign this directory to nginx/apache
## nginx
1. See nginx.txt, replace `<domain>` with a domain name of your fastdl
2. Save with the name fastdl.conf in the directory /etc/nginx/sites-available/
3. Run the comand below to enable
    - ln -s /etc/nginx/sites-available/fastdl.conf /etc/nginx/sites-enabled/fastdl.conf
4. Restart nginx
    - systemctl restart nginx
5. Visit website of your domain and you should see something like
    - "FastDownload | Last sync: 17/11/2020 12:34:13 AM"
## FastDl URL
For example in Counter-Strike is:
 - <span>https://<domain>/UUID/cstrike/</span>
 - To know UUID of a server visit admin panel in servers section