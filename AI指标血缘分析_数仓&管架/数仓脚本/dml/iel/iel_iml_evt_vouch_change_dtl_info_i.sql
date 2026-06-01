: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_vouch_change_dtl_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_vouch_change_dtl_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.vouch_change_id,chr(13),''),chr(10),'') as vouch_change_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.new_card_num,chr(13),''),chr(10),'') as new_card_num
,t1.tran_dt as tran_dt
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.init_vouch_type_cd,chr(13),''),chr(10),'') as init_vouch_type_cd
,replace(replace(t1.new_vouch_type_cd,chr(13),''),chr(10),'') as new_vouch_type_cd
,replace(replace(t1.new_vouch_no,chr(13),''),chr(10),'') as new_vouch_no
,replace(replace(t1.loss_id,chr(13),''),chr(10),'') as loss_id
,replace(replace(t1.vouch_no,chr(13),''),chr(10),'') as vouch_no
,replace(replace(t1.vouch_modif_type_cd,chr(13),''),chr(10),'') as vouch_modif_type_cd
,replace(replace(t1.change_rs,chr(13),''),chr(10),'') as change_rs
,replace(replace(t1.ba_auth_teller_id,chr(13),''),chr(10),'') as ba_auth_teller_id
,t1.tran_tm as tran_tm
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id
from ${iml_schema}.evt_vouch_change_dtl_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_vouch_change_dtl_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes