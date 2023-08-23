FROM mcr.microsoft.com/windows:10.0.17763.4737-amd64
EXPOSE 1433

ENV sa_password="" \
    attach_db1_name="" \
    attach_db1_file="" \
    attach_db1_log="" \
    ACCEPT_EULA="Y" \
    sa_password_path="C:\ProgramData\Docker\secrets\sa-password"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Copy powershell script
COPY start.ps1 /

# make install files accessible
COPY sqlexpress.exe /

WORKDIR /

RUN Start-Process -Wait -FilePath .\sqlexpress.exe -ArgumentList /qs, /x:setup
RUN .\setup\setup.exe /q /ACTION=Install /INSTANCENAME=SQLEXPRESS /FEATURES=SQLEngine /UPDATEENABLED=0 /SQLSVCACCOUNT='NT AUTHORITY\System' /SQLSYSADMINACCOUNTS='BUILTIN\ADMINISTRATORS' /TCPENABLED=1 /NPENABLED=0 /IACCEPTSQLSERVERLICENSETERMS
RUN Remove-Item -Recurse -Force sqlexpress.exe, setup

RUN stop-service MSSQL`$SQLEXPRESS ; \
        set-itemproperty -path 'HKLM:\software\microsoft\microsoft sql server\mssql14.SQLEXPRESS\mssqlserver\supersocketnetlib\tcp\ipall' -name tcpdynamicports -value '' ; \
        set-itemproperty -path 'HKLM:\software\microsoft\microsoft sql server\mssql14.SQLEXPRESS\mssqlserver\supersocketnetlib\tcp\ipall' -name tcpport -value 1433 ; \
        set-itemproperty -path 'HKLM:\software\microsoft\microsoft sql server\mssql14.SQLEXPRESS\mssqlserver\' -name LoginMode -value 2 ;

RUN set-ExecutionPolicy RemoteSigned -Scope CurrentUser



CMD powershell .\start \
    -sa_password $env:sa_password \
    -ACCEPT_EULA $env:ACCEPT_EULA \
    -attach_db1_name $env:attach_db1_name \
    -attach_db1_file $env:attach_db1_file \
    -attach_db1_log $env:attach_db1_log \
    -Verbose
