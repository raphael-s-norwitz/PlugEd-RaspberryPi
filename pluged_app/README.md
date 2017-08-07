# Code for the PlugED application

# Purpose of the application
Right now it's just a wrapper around KA-lite, but in the future we see this as a gateway into all kinds of applications and services we as PlugED can provide.

# Structure
The flask applicaiton itself is in `pluged_app.py`. Inside the `templates` and `static` folders are the templates and static files like any flask application has.
The `scripts` folder has two scripts. The first, `setup_nginx.py` adds and modifies configuration files so that nginx runs, handles things like static content 
and passes the rest on to our python application. The other, `setup_app.py` configures supervisor and launches the application.

# How to use
To setup the application, navigate to `scripts` and just run `sudo setup_nginx.sh` and once it finishes run `sudo setup_app.sh`
