: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_vouch_acct_rela_h_f
CreateDate: 20240919
FileName:   ${iel_data_path}/agt_vouch_acct_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.dep_vouch_cate_cd,chr(13),''),chr(10),'') as dep_vouch_cate_cd
,replace(replace(t1.vouch_no,chr(13),''),chr(10),'') as vouch_no
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.vouch_kind_cd,chr(13),''),chr(10),'') as vouch_kind_cd
,replace(replace(t1.vouch_status_cd,chr(13),''),chr(10),'') as vouch_status_cd
,replace(replace(t1.vouch_orig_status_cd,chr(13),''),chr(10),'') as vouch_orig_status_cd
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.pm_flg,chr(13),''),chr(10),'') as pm_flg
,replace(replace(t1.pm_id,chr(13),''),chr(10),'') as pm_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.tran_memo_descb,chr(13),''),chr(10),'') as tran_memo_descb
,tran_dt
,replace(replace(t1.cancel_rs_cd,chr(13),''),chr(10),'') as cancel_rs_cd
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,tran_timestamp

from ${iml_schema}.agt_vouch_acct_rela_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_vouch_acct_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
