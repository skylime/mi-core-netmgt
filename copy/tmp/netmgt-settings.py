import os
BASE_DIR = os.path.dirname(os.path.dirname(__file__))

DEBUG = False
TEMPLATE_DEBUG = False

INSTALLED_APPS = (
	'django_admin_bootstrapped.bootstrap3',
	'django_admin_bootstrapped',
	'django.contrib.admin',
	'django.contrib.auth',
	'django.contrib.contenttypes',
	'django.contrib.sessions',
	'django.contrib.messages',
	'django.contrib.staticfiles',
	'netmgt',
)

MIDDLEWARE_CLASSES = (
	'django.contrib.sessions.middleware.SessionMiddleware',
	'django.middleware.common.CommonMiddleware',
	'django.middleware.csrf.CsrfViewMiddleware',
	'django.contrib.auth.middleware.AuthenticationMiddleware',
	'django.contrib.auth.middleware.SessionAuthenticationMiddleware',
	'django.contrib.messages.middleware.MessageMiddleware',
	'django.middleware.clickjacking.XFrameOptionsMiddleware',
)

ROOT_URLCONF = 'netmgt_web.urls'
WSGI_APPLICATION = 'netmgt_web.wsgi.application'

DATABASES = {
	'default': {
		'ENGINE': 'django.db.backends.sqlite3',
		'NAME': '/var/db/netmgt.sqlite3',
	}
}

CACHES = {
	'default': {
		'BACKEND': 'django.core.cache.backends.db.DatabaseCache',
		'LOCATION': 'core_cache',
	}
}

LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_L10N = True
USE_TZ = True

STATIC_URL = '/static/'

