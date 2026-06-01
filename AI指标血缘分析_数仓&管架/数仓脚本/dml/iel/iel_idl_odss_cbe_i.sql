: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_cbe_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_cbe_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
OBJTYP,
OBJINR,
EXTID,
CBT,
TRNTYP,
TRNINR,
DAT,
CUR,
AMT,
RELFLG,
CREDAT,
XRFCUR,
XRFAMT,
NAM,
ACC,
ACC2,
OPTDAT,
GLEDAT,
NOMPCT,
CHKFLG from ${idl_schema}.odss_CBE where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_cbe_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes