[Unit]
Description=mbsync service
ConditionPathExistsGlob=/tmp/pass-user-pws*

[Service]
Type=oneshot
ExecStart=%h/passwrap $USER 'mbsync -a' $PASSWORD_FILES
