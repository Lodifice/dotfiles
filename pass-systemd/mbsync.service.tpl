[Unit]
Description=mbsync service

[Service]
Type=oneshot
ExecStart=%h/passwrap $USER 'mbsync -a' $PASSWORD_FILES
