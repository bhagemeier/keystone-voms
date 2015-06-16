FROM ubuntu:14.04
MAINTAINER BeneDicere
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y build-essential libxslt1-dev libxml2-dev libldap2-dev libsasl2-dev libsqlite3-dev libffi-dev libssl-dev python-dev python-pip git swig libvomsapi1 && apt-get clean autoclean && apt-get autoremove && rm -rf /var/lib/{apt,dpkg,cache,log}
RUN git clone https://github.com/openstack/keystone/ -b stable/kilo /tmp/keystone/ && pip install -r /tmp/keystone/requirements.txt && pip install -r /tmp/keystone/test-requirements.txt
RUN mkdir /repo/
ADD . /repo/
WORKDIR /repo/
RUN pip install -r requirements.txt && pip install -r test-requirements.txt
RUN pip install .
RUN cp tests/*py /tmp/keystone/keystone/tests/unit && cp tests/config_files/* /tmp/keystone/keystone/tests/unit/config_files
RUN pep8 keystone_voms
WORKDIR /tmp/keystone
CMD nosetests keystone.tests.unit.test_middleware_voms_authn