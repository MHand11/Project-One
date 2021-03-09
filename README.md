## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

https://github.com/MHand11/Project-One/blob/main/Diagrams/Network%20Diagram%20with%20ELK%20Mitchell%20Hand.png

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. These files allow for installation of:

  - ELK: install-elk.yml
  - Filebeat: filebeat-playbook.yml
  - Metricbeat: metricbeat-playbook.yml

This document contains the following details:

- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting external access to the network.

Load balancers protect against a DDoS attack, by attempting to assure that not all traffic goes to one system but instead it is balanced between the entire system.

What is the advantage of a jump box? 
It allows A system administrator to maintain the system from a single point, 
Meaning that only a single system can be updated when required then filter downstream to the other Machines.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the system logs via filebeat and fetches metrics from the configured docker containers via Metricbeat.

Filebeat is a lightweight shipper for forwarding and centralizing log data. 
Installed as an agent on your servers, Filebeat monitors the log files or locations that you specify, collects log events, and forwards them either to Elasticsearch or Logstash for indexing.
source: https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-overview.html#:~:text=Filebeat%20is%20a%20lightweight%20shipper,Elasticsearch%20or%20Logstash%20for%20indexing.

-: What does Metricbeat record?
Metricbeat is a lightweight shipper that you can install on your servers to periodically collect metrics from the operating system and from services running on the server. 
Metricbeat takes the metrics and statistics that it collects and ships them to the output that you specify, such as Elasticsearch or Logstash.
Source:https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-overview.html#:~:text=Metricbeat%20is%20a%20lightweight%20shipper,such%20as%20Elasticsearch%20or%20Logstash.

The configuration details of each machine may be found below.
| Name          | Function | IP address(public) | IP address (private) | operating system     |
|---------------|----------|--------------------|----------------------|----------------------|
| Jump-Box2     | gateway  | 104.210.84.100     | 10.2.0.4             | Linux (ubuntu 18.04) |
| Web 1.1       | VM       | --                 | 10.2.0.5             | Linux (ubuntu 18.04) |
| Web 2.1       | VM       | --                 | 10.2.0.6             | Linux (ubuntu 18.04) |
| Web 3.1       | VM       | --                 | 10.2.0.8             | Linux (ubuntu 18.04) |
| ELK-VM        | VM       | 137.116.137.173    | 10.0.0.4             | Linux (ubuntu 18.04) |
| Load-Balancer | --       | 52.187.243.213     | --                   | --                   |
### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the Jump-Box2 machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- <203.221.62.25> 
specifically ports 22(ssh) for the jumpbox and port 80 HTTP for the ELK server and load balancer


Machines within the network can only be accessed by SSH (port 22) from the jumpbox2 machine 10.2.0.4

A summary of the access policies in place can be found in the table below.

| Name          | publicly Accessible | allowed IP addresses                      |
|---------------|---------------------|-------------------------------------------|
| Jumpbox2      | Yes                 | 203.221.62.25 (port 22)                   |
| Web Servers   | No                  | 10.2.0.4 (port 22)                        |
| Elk Server    | Yes                 | 203.221.62.25 (port 80) 10.2.0.4 (port22) |
| Load Balancer | Yes                 | 203.221.62.25 (port 80)                   |


### Elk Configuration

Ansible was used to automate configuration of the ELK machine. 
No configuration was performed manually, which is advantageous because it allows the user to easily replicate and update the setup as needed.

The playbook implements the following tasks:
- Install the docker.io and python3-pip modules via apt
- Install the docker module via pip3
- Increase virtual memory, setting vm.max_map_count to at least 262144, to allow ELK to run
- Download the docker ELK container and set up to run on ports 5601, 9200 and 5044
- Set ELK service to start on boot

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

https://github.com/MHand11/Project-One/blob/main/Diagrams/docker_ps_output.png

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- the web server is hosting DVWA, at 10.2.0.5, 10.2.0.6 and 10.2.0.8

We have installed the following Beats on these machines:
- filebeat 7.6.1 
- metricbeat 7.6.1

These Beats allow us to collect the following information from each machine:

- filebeat will collect specific log events from the webservers and index them. in this case Filebeat has been setup to collect system logs and will return entries from syslog and auth.log

- metricbeat will collect metrics on specified services on the websevers. metricbeat has been set up to collect metrics on Docker. it will allow us to monitor memory useage and cpu useage for the DWVA containers running on the websevers. 


### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
the install-elk.yml from the ansible section

 Copy the following from the ansible repository:
 - install-elk.yml to etc/ansible./
 - filebeat-playbook.yml to /etc/ansible/roles/filebeat-playbook.yml
 - metricbeat-playbook.yml to /etc/ansible/roles/metricbeat-playbook.yml
 - filebeat-config.yml to /etc/ansible/files/filebeat.yml
 - metricbeat-config.ymlto /etc/ansible/files/metricbeat.yml
 
Use nano Update the etc/ansible/hosts file to include
- add groups for [websevers] and [elk] if not already done.
- each of your webservers IP address' under the [webservers] section
- add the ELK sever ip address to the [elk] section
- this ensures each of the playbooks will execute in the correct location.
- Each time you enter an IP address make sure that ansible_python_interpreter=/usr/bin/python3 is specified 
- save file by pressing control-x and then pressing "y" to save the changes you have made.

Run the playbook using:

- ansible-playbook /etcansible-playbook /etc/ansible/install-elk.yml
- ansible-playbook /etc/ansible/roles/filebeat-playbook.yml
- ansible-playbook /etc/ansible/roles/metricbeat-playbook.yml

SSH in to the ELK-VM and check ELK is running with :sudo docker ps 
navigate to http://137.116.137.173:5601 to check installation has worked as expected and kibana is running successfully.

