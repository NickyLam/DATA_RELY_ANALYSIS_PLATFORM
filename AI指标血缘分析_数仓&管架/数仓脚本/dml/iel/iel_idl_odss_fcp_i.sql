: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_fcp_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_fcp_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select INR,
SEPINR,
OBJTYP,
OBJINR,
MODFLG,
CUR,
AMT,
XRFCUR,
XRFAMT,
DAT1,
DAT2,
PAYROL,
PAYPTYINR,
PAYTXT,
DBTROL,
DBTPTYINR,
DBTTXT,
ADVTRNINR,
ADVDAT,
SRCTRNINR,
SRCDAT,
RPLTRNINR,
RPLDAT,
DONTRNINR,
DONDAT from ${idl_schema}.odss_FCP where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_fcp_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes