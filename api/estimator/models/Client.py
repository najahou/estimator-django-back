from django.db import models

class Client(models.Model):
    firstName = models.CharField(max_length=100, blank=False, null=False)
    lastName = models.CharField(max_length=7, blank=False, null=False)