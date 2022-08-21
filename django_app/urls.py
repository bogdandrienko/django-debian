from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path, include
from django_app import views

urlpatterns = [
    path('', views.index, name=''),
]
