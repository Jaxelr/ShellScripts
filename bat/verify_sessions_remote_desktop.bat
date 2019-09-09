REM verify the server is up.
net use /user:{domainuser} \\127.0.0.1

REM verify the sesions that 
query session /server:127.0.0.1

rwinsta /server:127.0.0.1