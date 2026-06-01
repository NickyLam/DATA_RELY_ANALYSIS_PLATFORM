: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_t00_tbps_txn_num_tab_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_t00_tbps_txn_num_tab.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.txn_num,chr(13),''),chr(10),'') as txn_num
,replace(replace(t1.txn_name,chr(13),''),chr(10),'') as txn_name
,replace(replace(t1.fin_txn_flg,chr(13),''),chr(10),'') as fin_txn_flg
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.last_update_dt as last_update_dt
,t1.etl_task_name as etl_task_name
from ${idl_schema}.hdws_dul_d_rpts_t00_tbps_txn_num_tab t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_t00_tbps_txn_num_tab.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes