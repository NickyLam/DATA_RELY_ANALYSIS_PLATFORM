: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_tran_bank_multilv_acct_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_tran_bank_multilv_acct_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.acct_b_id,chr(13),''),chr(10),'') as acct_b_id
,replace(replace(t1.level1_acct_b_id,chr(13),''),chr(10),'') as level1_acct_b_id
,replace(replace(t1.level2_acct_b_id,chr(13),''),chr(10),'') as level2_acct_b_id
,replace(replace(t1.level3_acct_b_id,chr(13),''),chr(10),'') as level3_acct_b_id
,replace(replace(t1.acct_b_name,chr(13),''),chr(10),'') as acct_b_name
,replace(replace(t1.acct_b_lev,chr(13),''),chr(10),'') as acct_b_lev
,replace(replace(t1.bind_stl_acct_flg,chr(13),''),chr(10),'') as bind_stl_acct_flg
,replace(replace(t1.stl_card_acct_id,chr(13),''),chr(10),'') as stl_card_acct_id
,replace(replace(t1.super_acct_b_id,chr(13),''),chr(10),'') as super_acct_b_id
,t1.create_tm as create_tm
,replace(replace(t1.acct_b_valid_flg,chr(13),''),chr(10),'') as acct_b_valid_flg
,t1.acct_b_bal as acct_b_bal
,replace(replace(t1.sign_parent_acct_id,chr(13),''),chr(10),'') as sign_parent_acct_id
,replace(replace(t1.stl_card_status_cd,chr(13),''),chr(10),'') as stl_card_status_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_tran_bank_multilv_acct_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_tran_bank_multilv_acct_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes