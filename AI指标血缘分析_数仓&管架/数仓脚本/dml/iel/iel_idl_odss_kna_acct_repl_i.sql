: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_kna_acct_repl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_kna_acct_repl_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select ACCTNO
,NWACNO
,TRANDT
,TRANSQ
,SMSGTG
,BRCHNO
,USERID from IDL.ODSS_KNA_ACCT_REPL where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_kna_acct_repl_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes