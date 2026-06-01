: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_vouch_loss_rgst_b_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_vouch_loss_rgst_b.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.loss_idf,chr(13),''),chr(10),'') as loss_idf
,replace(replace(t1.loss_id,chr(13),''),chr(10),'') as loss_id
,t1.tran_dt as tran_dt
,t1.tran_tm as tran_tm
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.acct_curr_cd,chr(13),''),chr(10),'') as acct_curr_cd
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.dep_vouch_cate_cd,chr(13),''),chr(10),'') as dep_vouch_cate_cd
,replace(replace(t1.vouch_no,chr(13),''),chr(10),'') as vouch_no
,replace(replace(t1.vouch_loss_cate_cd,chr(13),''),chr(10),'') as vouch_loss_cate_cd
,replace(replace(t1.vouch_loss_status_cd,chr(13),''),chr(10),'') as vouch_loss_status_cd
,replace(replace(t1.froz_start_seq_num,chr(13),''),chr(10),'') as froz_start_seq_num
,replace(replace(t1.vouch_tran_froz_flg,chr(13),''),chr(10),'') as vouch_tran_froz_flg
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.loss_unloss_rs,chr(13),''),chr(10),'') as loss_unloss_rs
,replace(replace(t1.unloss_type_cd,chr(13),''),chr(10),'') as unloss_type_cd
,t1.unloss_dt as unloss_dt
,replace(replace(t1.unloss_org_id,chr(13),''),chr(10),'') as unloss_org_id
,replace(replace(t1.unloss_auth_teller_id,chr(13),''),chr(10),'') as unloss_auth_teller_id
,replace(replace(t1.unloss_teller_id,chr(13),''),chr(10),'') as unloss_teller_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.rest_descb,chr(13),''),chr(10),'') as rest_descb
from ${iml_schema}.evt_vouch_loss_rgst_b t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_vouch_loss_rgst_b.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes