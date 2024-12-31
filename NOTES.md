## Oracle Data Pump Export and Import

- Network-based full transportable imports require use of the FULL=YES, TRANSPORTABLE=ALWAYS, and TRANSPORT_DATAFILES=datafile_name parameters. When the source database is Oracle Database 11g Release 11.2.0.3 or later, but earlier than Oracle Database 12c Release 1 (12.1), the VERSION=12 parameter is also required.

# 1.2.6 Using a Parameter File (Parfile) with Oracle Data Pump

To help to simplify Oracle Data Pump exports and imports, you can create a parameter file, also known as a parfile.

Instead of typing in Oracle Data Pump parameters at the command line, when you run an export or import operation, you can prepare a parameter text file (also known as a parfile, after the parameter name) that provides the command-line parameters to the Oracle Data Pump client. You specify that Oracle Data Pump obtains parameters for the command by entering the PARFILE parameter, and then specifying the parameter name:

PARFILE=[directory_path]file_name

When the Oracle Data Pump Export or Import operation starts, the parameter file is opened and read by the client. The default location of the parameter file is the user's current directory.

For example:

expdp hr PARFILE=hr.par

When you create a parameter file, it makes it easier for you to reuse that file for multiple export or import operations, which can simplify these operations, particularly if you perform them regularly. Creating a parameter file also helps you to avoid typographical errors that can occur from typing long Oracle Data Pump commands on the command line, especially if you use parameters whose values require quotation marks that must be placed precisely. On some systems, if you use a parameter file and the parameter value being specified does not have quotation marks as the first character in the string (for example, TABLES=scott."Emp"), then the use of escape characters may not be necessary.

There is no required file name extension, but Oracle examples use .par as the extension. Oracle recommends that you also use this file extension convention. Using a consistent parameter file extension makes it easier to identify and use these files.

Note:The PARFILE parameter cannot be specified within a parameter file.

For more information and examples, see the PARFILE parameters for Oracle Data Pump Import and Export.

---

So we need to create a PDB on the target, and then use the expdp from the source machine using transportable=ALWAYS to faciliate the transfer
