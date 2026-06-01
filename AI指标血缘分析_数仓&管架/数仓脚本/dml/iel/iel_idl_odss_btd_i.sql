: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_btd_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_btd_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
OWNREF,
NAM,
OWNUSR,
CREDAT,
OPNDAT,
CLSDAT,
PNTTYP,
PNTINR,
RCVDATBE1,
SHPDAT,
ADVDAT,
MATDAT,
DOCTYPCOD,
DISDAT,
VER,
APPROVCOD,
FREPAYFLG,
MATTXTFLG,
ORDDATBE2,
DOCPRBROL,
PAYROL,
DSCINSFLG,
ACPNOWFLG,
TOTCUR,
TOTAMT,
TOTDAT,
ADVTYP,
DOCSTA,
RCVDATBE2,
DOCPRBROLBE1,
ORDDATBE1,
PREDAT,
ETYEXTKEY,
RMBROL,
BCHKEYINR,
BRANCHINR,
LESCOM,
NRAFLG from ${idl_schema}.odss_BTD where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_btd_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes