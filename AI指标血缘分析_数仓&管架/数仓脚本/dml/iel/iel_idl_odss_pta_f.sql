: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_pta_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_pta_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
PTYINR,
NAM,
PRI,
ENO,
OBJTYP,
OBJINR,
OBJKEY,
USG,
VER,
BIC,
ADRSTA,
PTYTYP,
PTYEXTKEY,
TID,
ETGEXTKEY,
BRANCHINR,
BCHKEYINR,
NAM1,
ISSBCHINF from ${idl_schema}.odss_PTA where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_pta_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes