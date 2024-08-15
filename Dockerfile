FROM ubuntu:latest

# Install Dependancies
RUN apt-get update
RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y build-essential python-pip python-dev python-lxml libffi-dev libssl-dev libjpeg-dev libpng-dev uuid-dev python-dbus python-augeas python-apt ntpdate git
RUN rm /usr/lib/python2.7/dist-packages/setuptools.egg-info || true
RUN easy_install -U pip
RUN pip install -U pip wheel setuptools distribute

# Install Ajenti 2
RUN pip install ajenti-panel ajenti.plugin.dashboard

# Update Font-Awesome
RUN rm -r /usr/local/lib/python2.7/dist-packages/ajenti_plugin_core/resources/vendor/fontawesome
RUN git clone https://github.com/FortAwesome/Font-Awesome.git
RUN mv /Font-Awesome /usr/local/lib/python2.7/dist-packages/ajenti_plugin_core/resources/vendor/fontawesome

# Install basic Ajenti 2 Plugins
RUN cd /usr/local/lib/python2.7/dist-packages && rm -r ajenti_plugin_settings && git clone https://github.com/ggpwnkthx/ajenti_plugin_settings.git

# Install COACH dependancies
RUN cd /usr/local/lib/python2.7/dist-packages && git clone https://github.com/ggpwnkthx/ajenti_plugin_coach.git
RUN pip install pyroute2

# Rebrand to COACH
RUN sed -i "s/{{customization.plugins.core.title || 'Ajenti'}}/{{customization.plugins.core.title || 'COACH'}}"/g /usr/local/lib/python2.7/dist-packages/ajenti_plugin_core/content/pages/index.html

# Add Docker EntryPoint Script
COPY /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh", "/usr/local/bin/ajenti-panel"]
