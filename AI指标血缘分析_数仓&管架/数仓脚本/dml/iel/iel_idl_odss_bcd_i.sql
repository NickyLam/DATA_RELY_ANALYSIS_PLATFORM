: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_bcd_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_bcd_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
OWNREF,
NAM,
RELGODFLG,
RELGODDAT,
RCVDAT,
PREDAT,
SHPDAT,
CREDAT,
ADVDAT,
CLSDAT,
MATDAT,
OPNDAT,
DOCTYPCOD,
MATPERBEG,
MATPERCNT,
MATPERTYP,
OWNUSR,
VER,
TRPDOCTYP,
TRPDOCNUM,
TRADAT,
TRAMOD,
SHPFRO,
SHPTO,
CHATO,
OTHINS,
STACTY,
STAGOD,
ACCDAT,
AMENBR,
DFTGARFLG,
RELTYP,
EXPDAT,
RTODREFLG,
MATTXTFLG,
FOCFLG,
WAICOLCOD,
WAIRMTCOD,
ORIDRE,
DOCSTA,
RESFLG,
AGTDAT,
ETYEXTKEY,
PROINS,
BRANCHINR,
BCHKEYINR,
NRAFLG,
QSQDBH from ${idl_schema}.odss_BCD where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_bcd_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes