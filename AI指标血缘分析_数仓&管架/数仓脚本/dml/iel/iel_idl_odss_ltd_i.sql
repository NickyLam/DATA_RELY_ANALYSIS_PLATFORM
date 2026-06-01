: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_ltd_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_ltd_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
OWNREF,
NAM,
CREDAT,
ADLFLG,
AMEDAT,
AMENBR,
AVBBY,
AVBWTH,
CHATO,
CLSDAT,
CNFINS,
EXPDAT,
EXPPLC,
LCRTYP,
NOMSPC,
NOMTOP,
NOMTON,
OPNDAT,
OWNUSR,
RMBACT,
RMBCHA,
RMBFLG,
SHPDAT,
SHPFRO,
SHPPAR,
SHPTO,
SHPTRS,
STACTY,
UTLNBR,
ADVNBR,
REDCLSFLG,
VER,
LEDINR,
DOCSUBFLG,
PORLOA,
PORDIS,
APPRUL,
APPRULTXT,
APPRULRMB,
AUTDAT,
ETYEXTKEY,
TENMAXDAY,
BRANCHINR,
BCHKEYINR from ${idl_schema}.odss_LTD where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_ltd_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes