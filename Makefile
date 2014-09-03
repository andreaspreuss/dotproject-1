
DOTPROJECT_DIR		= dotproject
DOTPROJECT_INSTALL	= /service/dotproject

CHOWN		= /bin/chown
CP		= /bin/cp
FIND		= /usr/bin/find
MKDIR		= /bin/mkdir
RM		= /bin/rm
RSYNC		= /usr/bin/rsync
TOUCH		= /bin/touch
WHOAMI		= /usr/bin/whoami

distclean:
	@if [ 'root' != `${WHOAMI}` ]; then \
		echo "Error: you must be root to deploy."; \
		false; \
	fi

	@if [ -d "${DOTPROJECT_INSTALL}" ]; then \
		${RM} -rf "${DOTPROJECT_INSTALL}"; \
	fi

deploy:
	@if [ 'root' != `${WHOAMI}` ]; then \
		echo "Error: you must be root to deploy."; \
		false; \
	fi

	@${MKDIR} -p ${DOTPROJECT_INSTALL}/webroot
	@${RSYNC} -av --exclude '*~' ${DOTPROJECT_DIR}/* ${DOTPROJECT_INSTALL}/webroot

	@${RM} ${DOTPROJECT_INSTALL}/webroot/ChangeLog
	@${RM} ${DOTPROJECT_INSTALL}/webroot/COPYING
	@${RM} ${DOTPROJECT_INSTALL}/webroot/LICENSE
	@${RM} ${DOTPROJECT_INSTALL}/webroot/README
	@${FIND} ${DOTPROJECT_INSTALL} -name '.cvsignore' -delete
	@${TOUCH} ${DOTPROJECT_INSTALL}/webroot/misc/debug.php

	@if [ ! -f "${DOTPROJECT_INSTALL}/webroot/.htaccess" ]; then \
	    ${CP} etc/.htaccess ${DOTPROJECT_INSTALL}/webroot/; \
	fi

	@if [ ! -f "${DOTPROJECT_INSTALL}/.htpasswd" ]; then \
	    ${CP} etc/.htpasswd ${DOTPROJECT_INSTALL}/; \
	fi

	@${CHOWN} -R nobody:nogroup "${DOTPROJECT_INSTALL}"
