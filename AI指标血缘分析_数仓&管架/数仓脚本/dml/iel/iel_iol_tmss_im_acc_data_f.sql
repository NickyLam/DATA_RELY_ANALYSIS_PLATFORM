: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tmss_im_acc_data_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tmss_im_acc_data.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,t.acc_id as acc_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.accountname,chr(13),''),chr(10),'') as accountname
,replace(replace(t.bankacc,chr(13),''),chr(10),'') as bankacc
,replace(replace(t.checkeds,chr(13),''),chr(10),'') as checkeds
,replace(replace(t.bank_cust_id,chr(13),''),chr(10),'') as bank_cust_id
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.tmss_im_acc_data t 
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tmss_im_acc_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes