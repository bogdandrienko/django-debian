# INSTALL DEBIAN
# SETUP RESOLUTION

su
sudo usermod -aG sudo bogdan
sudo getent group sudo

sudo nano /etc/apt/sources.list

# <file>
deb http://deb.debian.org/debian bullseye main
deb-src http://deb.debian.org/debian bullseye main
# </file>

# INSTALL SSH

sudo apt update -y
sudo apt install openssh-server -y
sudo systemctl start ssh
sudo systemctl restart ssh
ip a


# INSTALL POSTGRESQL
sudo apt-get install postgresql postgresql-contrib -y
su
su - postgres
psql
CREATE DATABASE django_db;
CREATE USER django_usr WITH PASSWORD '31284bogdan';
ALTER ROLE django_usr SET client_encoding TO 'utf8';
ALTER ROLE django_usr SET default_transaction_isolation TO 'read committed';
ALTER ROLE django_usr SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE django_db TO django_usr;
\q
exit

# INSTALL DJANGO
sudo apt-get install python3-pip python3-dev python3-venv libpq-dev curl nginx -y
pip3 install --upgrade pip
mkdir web
cd web
python3 -m venv env
source env/bin/activate
pip3 install --upgrade pip
pip install django gunicorn psycopg2-binary
django-admin startproject django_settings .
nano ./django_settings/settings.py

# <file>
ALLOWED_HOSTS = ['*']
#DATABASES = {
#    'default': {
#        'ENGINE': 'django.db.backends.sqlite3',
#        'NAME': BASE_DIR / 'db.sqlite3',
#    }
#}

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'django_db',
        'USER': 'django_usr',
        'PASSWORD': '31284bogdan',
        'HOST': '127.0.0.1',
        'PORT': '5432',

    }
}

STATIC_URL = '/static/'
import os
STATIC_ROOT = os.path.join(BASE_DIR, 'static/')
# </file>

python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
python manage.py collectstatic
ip a
gunicorn --bind 0.0.0.0:8000 django_settings.wsgi
