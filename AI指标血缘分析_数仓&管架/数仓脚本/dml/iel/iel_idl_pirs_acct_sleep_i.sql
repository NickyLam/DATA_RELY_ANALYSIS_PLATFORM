: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_acct_sleep_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_acct_sleep_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select date_id
,branch_code
,cust_tp
,acct_no
,smh_flag from  idl.pirs_acct_sleep where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_acct_sleep_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes