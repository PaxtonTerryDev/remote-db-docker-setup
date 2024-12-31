FROM container-registry.oracle.com/database/enterprise:19.3.0.0

# Set environment variables for Oracle 19
ENV ORACLE_SID=ORCL
ENV ORACLE_PDB=ORCLPDB1
ENV ORACLE_PWD=January2017!!

# Expose necessary ports
EXPOSE 1521 5500

CMD ["/bin/bash", "-c", "/opt/oracle/runOracle.sh"]
