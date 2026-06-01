: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_act_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_act_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
PRI,
CUR,
EXTKEY,
SERACC,
SERNAM,
SERPTYTYP,
SERPTYINR,
HOLACC,
HOLNAM,
HOLPTYTYP,
HOLPTYINR,
CVRFLG,
RMBFLG,
DELFLG,
VER,
DIRFLG,
OTHBNKFLG,
OTHPTYNAM,
OTHOWNFLG,
OTHBIC6,
IBAN,
ETGEXTKEY,
NAM,
EXTTYP,
TYP,
EXTACT,
TRMTYP,
ACCTYP,
BCHKEYINR,
OTHBIC,
CSHFLG,
NAM1,
WGZHXZ,
BANKTYP from ${idl_schema}.odss_act where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_act_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes