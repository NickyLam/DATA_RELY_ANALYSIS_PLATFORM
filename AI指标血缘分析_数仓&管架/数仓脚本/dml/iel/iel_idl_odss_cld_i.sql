: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_cld_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_cld_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
OWNUSR,
CHKTYP,
COLPTYINR,
COLPTYNAM,
OWNREF,
COLPTYREF,
OPNDAT,
CLSDAT,
VER,
CREDAT,
COLPTAINR,
NAM,
COLFLG,
VALDAT,
COUNT,
COLREF,
CREACT,
ACNO,
REGREF,
BCHKEYINR,
BRANCHINR,
ETYEXTKEY from ${idl_schema}.odss_CLD where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_cld_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes