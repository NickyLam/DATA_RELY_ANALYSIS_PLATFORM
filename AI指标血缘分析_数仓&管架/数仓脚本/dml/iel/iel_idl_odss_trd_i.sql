: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_trd_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_trd_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
OWNREF,
NAM,
CREDAT,
PNTTYP,
PNTINR,
PNTNAM,
PNTREF,
ISSDAT,
MATDAT,
LSTINTDAT,
STTTENDAT,
SPDDAT,
OPNDAT,
CLSDAT,
TENDAY,
ACTFINDAY,
INTRAT,
OWNUSR,
VER,
IRTCOD,
EXTNMB,
FINTYP,
PCTFIN,
STAGOD,
STACTY,
ETYEXTKEY,
MARRAT,
GRARAT,
ACTRAT,
BCHKEYINR,
BRANCHINR,
FINCOD,
FINACT,
FINBLK,
ITFBLK,
OVDDAT,
OVDFLG,
FEETYP,
FEEAMT,
ACTYLD,
GUAFLG,
RESTCUR,
RESTAMT,
DELFLG,
DFRATE,
DFTYPE from ${idl_schema}.odss_TRD where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_trd_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes