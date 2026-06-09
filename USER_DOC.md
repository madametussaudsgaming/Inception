# USER_DOC.md — User Documentation
_This project has been created as part of the 42 curriculum by rpadasia [@madametussaudsgaming]_

---

## What services does this stack provide?

This project runs three services, each in its own isolated Docker container, all connected through a private Docker network called `inception`:

**NGINX** — the web server and sole entry point into the infrastructure. All traffic goes through NGINX on port 443 (HTTPS) using TLSv1.3 encryption. It forwards PHP requests to WordPress behind the scenes. You never interact with WordPress or MariaDB directly from the outside.

**WordPress** — the website itself. A full content management system running PHP. This is what you see when you visit the site in a browser. It handles all page rendering, user logins, and content management.

**MariaDB** — the database running silently in the background. Stores all WordPress content, users, settings and posts. You do not interact with it directly under normal usage.

```
You (browser)
      ↓ HTTPS port 443
    NGINX  →  WordPress  →  MariaDB
```

---

## Starting the project

From the root of the project directory:

```bash
make
```

This will:
- Create the data directories at `/home/rpadasia/data/`
- Build all three Docker images from their Dockerfiles
- Start all three containers in the correct order (MariaDB first, then WordPress, then NGINX)

Wait a few seconds after running `make` for all services to fully initialize before opening the browser.

---

## Stopping the project

To stop all containers without removing data:

```bash
make down
```

Your WordPress content and database are stored in volumes and will persist — nothing is lost when you stop.

To stop and remove everything including volumes and images (full reset):

```bash
make clean
```

---

## Accessing the website

Open a browser **inside the VM** and navigate to:

```
https://rpadasia.42.fr
```

You will see a **certificate warning** — this is expected because the SSL certificate is self-signed (not issued by an official authority). Click through it:
- Chrome/Chromium: click "Advanced" → "Proceed to rpadasia.42.fr"
- Firefox: click "Advanced" → "Accept the Risk and Continue"

You should then see the WordPress website.

---

## Accessing the administration panel

The WordPress admin panel is at:

```
https://rpadasia.42.fr/wp-admin
```

Log in with the administrator credentials found in your `.env` file (see below). From here you can manage posts, pages, users, themes and plugins.

---

## Locating and managing credentials

All credentials are stored in `srcs/.env` at:

```
/path/to/project/srcs/.env
```

This file contains:

```bash
# WordPress admin account
WP_ADMIN_USR=rpadasia_super      ← admin username
WP_ADMIN_PWD=yourpassword        ← admin password
WP_ADMIN_EMAIL=you@student.42.fr

# WordPress regular user
WP_USR=rpadasia_user
WP_PWD=yourpassword

# MariaDB database
db1_name=wordpressdb
db1_user=rpadasia
db1_pwd=yourpassword
```

**Important:** This file must never be committed to git. It is listed in `.gitignore` for this reason.

To change a password, edit the `.env` file and rebuild:

```bash
make clean
make
```

---

## Checking that services are running correctly

**Check all containers are up:**
```bash
docker ps
```

You should see three containers all showing `Up` status:
```
CONTAINER ID   IMAGE          STATUS
xxxxxxxxxxxx   nginx:1.0      Up X seconds
xxxxxxxxxxxx   wordpress:1.0  Up X seconds
xxxxxxxxxxxx   mariadb:1.0    Up X seconds
```

**Check logs for a specific container:**
```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

**Check that the website responds:**

Open `https://rpadasia.42.fr` in the browser inside the VM. If the WordPress site loads, all three services are communicating correctly.

**Check that the database is running:**
```bash
docker exec -it mariadb mysql -u root -p
```

Enter the root password when prompted. If you get a MariaDB prompt, the database is healthy.
