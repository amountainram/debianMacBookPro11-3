#!/bin/bash
# The PostgreSQL apt repository supports the currently supported stable versions of Debian:
# 
#     Buster (10.x)
#     Stretch (9.x)
#     Jessie (8.x)
#     Bullseye (11.x, testing)
#     Sid (unstable)
# 
# on the following architectures:
# 
#     amd64
#     arm64 (Buster and newer)
#     i386 (Buster and older)
#     ppc64el
#
# link: https://www.postgresql.org/download/linux/debian/
#
repo="deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main"
cp /etc/apt/sources.list /etc/apt/sources.list.old.$(date +%s)
cat /etc/apt/sources.list | grep postgresql
if [[ $? -eq 1 ]]
then 
		add-apt-repository "$repo"
		info "Added '$repo' repo to '/etc/apt/sources.list'"
else
		cat /etc/apt/sources.list | grep "postgresql" | while read -r line ;
		do
				the_type=$( echo $line | awk '{print $1}' )
				the_site=$( echo $line | awk '{print $2}' )
				the_distro=$( echo $line | awk '{print $3}' )
				the_main=$( echo $line | awk '{print $4}' )
				the_extra1=$( echo $line | awk '{print $5}' )
				the_extra2=$( echo $line | awk '{print $6}' )
				if [[ $the_distro == *"buster"* ]] | [[ "$the_main" -eq "main" ]]
				then
						info "Repository '$line' is already sourced."
				else	
						add-apt-repository "$line"
						info "Added '$line contrib non-free' repo from '/etc/apt/sources.list'"
				fi
		done
fi
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update
check_install $un postgresql-12
# 
# notes:
#
#
# User first access
# =================
#
# Both default user and default db are named postgres.
# Administrative privileges are required.
# > sudo -u postgres bash
# then run the client with 
# > psql
#
# New users and dbs
# =================
# Creare un account per utente di sistema regolare usando adduser (saltare questo passaggio per usare un utente esistente):
# > adduser mioutentepg        #dalla shell normale
# Connettersi al database e creare un nuovo utente per il database e un database
# su - postgres
# $ createuser mioutentepg   #dalla shell normale
# $ createdb -O mioutentepg miodatabasepg
# Connettersi al nuovo database come utente
# > su - mioutentepg
# > psql miodatabasepg
# oppure, se il nome utente sul sistema operativo non è lo stesso del nome utente per il database:
# $ psql -d miodatabasepg -h localhost -U mioutentepg
# Si può anche usare un file ~/.pgpass
# Aggiungere la riga per l'autenticazione:
# $ echo 'nomehost:porta:miodatabasepg:mioutentepg:miapasswordpg' >> ~/.pgpass
# Rendere sicuro il file
# chmod 600 ~/.pgpass
# Ora ci si può facilmente connettere con
# $ psql -d miodatabasepg -h localhost -U mioutentepg
# Ulteriori informazioni sulla sintassi possono essere trovate su: https://www.postgresql.org/docs/11/libpq-pgpass.html
