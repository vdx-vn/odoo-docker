FROM odoo:14.0

USER root

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
COPY ./odoo.conf /etc/odoo/

RUN chown odoo /etc/odoo/odoo.conf \
    && mkdir -p /mnt/et-addons /mnt/custom-addons \
    && chown -R odoo /mnt/et-addons  /mnt/custom-addons
VOLUME ["/var/lib/odoo", "/mnt/custom-addons", "/mnt/et-addons"]

# Expose Odoo services
EXPOSE 8069 8071 8072

# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf

COPY wait-for-psql.py /usr/local/bin/wait-for-psql.py

COPY ./requirements.txt /etc/odoo/requirements.txt
RUN pip3 install -r /etc/odoo/requirements.txt

RUN apt-get update && \
    apt-get install -y --no-install-recommends zip unzip

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]