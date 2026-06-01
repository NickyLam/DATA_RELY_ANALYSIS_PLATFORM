: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_teller_info_f
CreateDate: 20230104
FileName:   ${iel_data_path}/cmm_teller_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.teller_id,chr(13),''),chr(10),'') as teller_id
,replace(replace(t1.teller_name,chr(13),''),chr(10),'') as teller_name
,replace(replace(t1.teller_type_cd,chr(13),''),chr(10),'') as teller_type_cd
,replace(replace(t1.teller_status_cd,chr(13),''),chr(10),'') as teller_status_cd
,replace(replace(t1.teller_user_lev_cd,chr(13),''),chr(10),'') as teller_user_lev_cd
,replace(replace(t1.teller_prvlg_lev_cd,chr(13),''),chr(10),'') as teller_prvlg_lev_cd
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.jobs_cd,chr(13),''),chr(10),'') as jobs_cd
,replace(replace(t1.jobs_cate,chr(13),''),chr(10),'') as jobs_cate
,replace(replace(t1.jobs_name,chr(13),''),chr(10),'') as jobs_name
,empyt_dt
,replace(replace(t1.cust_mgr_flg,chr(13),''),chr(10),'') as cust_mgr_flg
,replace(replace(t1.enty_teller_flg,chr(13),''),chr(10),'') as enty_teller_flg
,replace(replace(t1.syn_teller_flg,chr(13),''),chr(10),'') as syn_teller_flg
,replace(replace(t1.super_teller_flg,chr(13),''),chr(10),'') as super_teller_flg
,replace(replace(t1.acct_teller_flg,chr(13),''),chr(10),'') as acct_teller_flg
,replace(replace(t1.prvlg_mgmt_flg,chr(13),''),chr(10),'') as prvlg_mgmt_flg
,replace(replace(t1.director_mgmt_flg,chr(13),''),chr(10),'') as director_mgmt_flg
,replace(replace(t1.crdt_cust_mgr_flg,chr(13),''),chr(10),'') as crdt_cust_mgr_flg
,replace(replace(t1.wah_kepr_flg,chr(13),''),chr(10),'') as wah_kepr_flg
,replace(replace(t1.auth_flg,chr(13),''),chr(10),'') as auth_flg
,replace(replace(t1.auth_range,chr(13),''),chr(10),'') as auth_range
,replace(replace(t1.cors_moy_box_id,chr(13),''),chr(10),'') as cors_moy_box_id
,replace(replace(t1.teller_type_subclass_cd,chr(13),''),chr(10),'') as teller_type_subclass_cd

from ${icl_schema}.cmm_teller_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_teller_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
