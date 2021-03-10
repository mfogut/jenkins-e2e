# maven-project

Simple Maven Project

## Jenkins Installation
1. Spin up EC2 instance
2. sudo su -
3. Change hostname to jenkins --> hostnamectl set-hostname jenkins
4. hostname jenkins-node --> exit and log back in
5. Install Java --> Verify Java is installed or not --> java -version
6. yum install java-1.8* -y
7. find /usr/lib/jvm/java-1.8* | head -n 3
8. ls -l /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.242.b08-0.amzn2.0.1.x86_64/jre/
9. cd ~ --> Go back to home of root user
10. vim .bash_profile
11. vim ~/.bash_profile

## User specific environment and startup programs

JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.242.b08-0.amzn2.0.1.x86_64
PATH=$PATH:$HOME/bin:$JAVA_HOME

export PATH

11. cat /etc/*-release --> Find out linux distro
12. Google for Jenkins Download --> Pick LTS(Long Term Support) --> Rhel,Centos,Fedora -->
13. wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
14. rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
15. yum install jenkins -y
16. systemctl start jenkins
17. systemctl enable jenkins
18. grab publichIP of Jenkins VM and paste to browser and port number 8080 --> XXXXXXXXXX:8080
19. Copy /var/libcat /jenkins/secrets/initialAdminPassword and in Jenkins box --> cat /var/lib/jenkins/secrets/initialAdminPassword
20. Install suggested plugins --> Next --> Add your credentials


## Working with Jenkins
1. Configure JDK in Jenkins GUI --> Manage Jenkins --> Global Tool Configuration --> Add JDK --> Name: JAVA_HOME -->
go to Jenkins Box (Terminal/CMD) and run echo $JAVA_HOME --> Copy the output and paste under JAVA_HOME
2. Build Job --> New Item --> Freestyle Project --> Description --> Build Actions --> Execute Shell --> echo "Welcome to Cloudiar"
--> Build Now.

## Building CI/CD pipeline
1. Install git --> yum install git -y
2. Jenkins GUI --> Manage Jenkins --> Manage Plugins --> Available --> Filter: GitHub Integration --> Install Without Restart
3. Manage Jenkins --> Global Tool Configuration --> Change Default to GitHub and save

## Install Maven  (Build Management Tool)
1. Google for Maven Download
2. Right Click on "apache-maven-3.6.3-bin.tar.gz" and copy link address
3. Jenkins box --> cd /opt --> wget https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
4. tar -xvzf apache-maven-3.6.3-bin.tar.gz
5. mv apache-maven-3.6.3 maven --> Creates user friendly folder name
6. vim ~/.bash_profile

## User specific environment and startup programs

JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.242.b08-0.amzn2.0.1.x86_64
M2_HOME=/opt/maven
M2=$M2_HOME/bin
PATH=$PATH:$HOME/bin:$JAVA_HOME:$M2:$M2_HOME

export PATH

8. exit from Jenkins Box and log back in (sudo su -)
9. echo $M2 and echo $M2_HOME
10. Jenkins GUI --> Manage Jenkins --> Manage Plugins --> Available --> Maven Invoker 
11. Jenkins box --> git clone https://github.com/BakhtyMilan/hello-cloudiar.git
12. cd hello-cloudiar
13. yum install tree -y
14. Build maven job

## Tomcat Server
1. Spin up ec2 instance
2. Change hostname --> hostnamectl set-hostname tomcat
3. Install java-1.8* (LTS) --> yum install java-1.8* -y
4. Create JAVA path in .bash_profile file
	- vim .bash_profile
	- JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.242.b08-0.amzn2.0.1.x86_64
	- PATH=$PATH:$HOME/bin:$JAVA_HOME
5. Downloand tomcat --> wget https://mirrors.gigenet.com/apache/tomcat/tomcat-8/v8.5.63/bin/apache-tomcat-8.5.63.tar.gz
6. Untar tomcat file --> tar -xzvf apache-tomcat-8.5.63.tar.gz
7. Move tomcat file to opt folder --> mv apache-tomcat-8.5.63 /opt/
8. Go to tomcat directory --> cd /opt/apache-tomcat-8.5.63/bin/
8. Start to tomcat server --> ./startup.sh
9. Find and edit context.xml --> find / -name context.xml
10. In order to open tomcat server to public comment out only local host access -->
	- vim /opt/tomcat/webapps/host-manager/META-INF/context.xml
			<!--     <Valve className="org.apache.catalina.valves.RemoteAddrValve"
			allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->
	- vim /opt/tomcat/webapps/manager/META-INF/context.xml
			<!--     <Valve className="org.apache.catalina.valves.RemoteAddrValve"
			allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->
11. Add tomcat users to tomcat-users.xml file --> vim tomcat-users.xml
		<role rolename="manager-gui"/>
  		<role rolename="manager-jmx"/>
  		<role rolename="manager-script"/>
  		<role rolename="manager-status"/>
  		<user username="admin" password="password" roles="manager-gui,manager-jmx,manager-script,manager-status"/>
  		<user username="tomcat" password="password" roles="manager-gui"/>
  		<user username="manager-jmx" password="password" roles="manager-jmx"/>
  		<user username="deployer" password="password" roles="manager-script"/>

## Deploy .war file to tomcat server
1. Create New Jenkins job. Maven Project
2. Source Code Management --> Github link
3. Build Goals and options --> clean install package
4. Install Deploy to container plugin to Jenkins
5. Post-build Actions
	- WAR/EAR files : **/*.war
	- Container add Credentials wiht tomcat "deployer" username and password.
	- Tomcat URL : tomcat server IP address
6. Build Job
7. Hit the tomcat server ip_address:8080/webapp (Exit criteria)