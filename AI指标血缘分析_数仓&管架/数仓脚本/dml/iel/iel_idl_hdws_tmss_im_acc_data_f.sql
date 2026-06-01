: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_tmss_im_acc_data_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_tmss_im_acc_data.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.acc_id
,t1.cust_id
,t1.accountname
,t1.bankacc
,t1.checkeds
,t1.bank_cust_id
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_tmss_im_acc_data t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_tmss_im_acc_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes