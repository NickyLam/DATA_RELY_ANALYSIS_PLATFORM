: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_m6_noth_tran_list_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_m6_noth_tran_list_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.tran_batch_no,chr(13),''),chr(10),'') as tran_batch_no
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.doubt_acct_vrif_status_cd,chr(13),''),chr(10),'') as doubt_acct_vrif_status_cd
,t1.sync_dt as sync_dt
,t1.effect_dt as effect_dt
,replace(replace(t1.input_org_id,chr(13),''),chr(10),'') as input_org_id
,replace(replace(t1.blklist_id,chr(13),''),chr(10),'') as blklist_id
,t1.blklist_check_tm as blklist_check_tm
,replace(replace(t1.blklist_cust_flg,chr(13),''),chr(10),'') as blklist_cust_flg
,replace(replace(t1.teller_id,chr(13),''),chr(10),'') as teller_id
,replace(replace(t1.list_src_cd,chr(13),''),chr(10),'') as list_src_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_m6_noth_tran_list_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_m6_noth_tran_list_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes