: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_bod_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_bod_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
OWNREF,
NAM,
AGTREF,
AGTACT,
AGTCOM,
SHPDAT,
PREDAT,
RCVDAT,
OPNDAT,
ADVDAT,
MATDAT,
CLSDAT,
DOCTYPCOD,
MATPERBEG,
MATPERCNT,
MATPERTYP,
TRPDOCTYP,
TRPDOCNUM,
TRADAT,
TRAMOD,
SHPFRO,
SHPTO,
WAICOLCOD,
WAIRMTCOD,
CHATO,
STACTY,
STAGOD,
CREDAT,
OWNUSR,
VER,
FOCFLG,
DIRCOLFLG,
CCDPURFLG,
CCDNDRFLG,
ISSDAT,
PAYDOCNUM,
PAYDOCTYP,
MATTXTFLG,
OTHINS,
DOCSTA,
RESFLG,
AMENBR,
MSGROL,
ETYEXTKEY,
LESCOM,
BRANCHINR,
BCHKEYINR,
NRAFLG from ${idl_schema}.odss_BOD where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_bod_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes