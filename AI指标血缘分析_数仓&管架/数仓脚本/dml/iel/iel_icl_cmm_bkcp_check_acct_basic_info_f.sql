: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_bkcp_check_acct_basic_info_f
CreateDate: 20221122
FileName:   ${iel_data_path}/cmm_bkcp_check_acct_basic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
,replace(replace(t1.cust_sub_acct_num,chr(13),''),chr(10),'') as cust_sub_acct_num
,replace(replace(t1.brch_id,chr(13),''),chr(10),'') as brch_id
,replace(replace(t1.subrch_id,chr(13),''),chr(10),'') as subrch_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.sav_type_cd,chr(13),''),chr(10),'') as sav_type_cd
,replace(replace(t1.espec_acct_flg_cd,chr(13),''),chr(10),'') as espec_acct_flg_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.check_entry_way_cd,chr(13),''),chr(10),'') as check_entry_way_cd
,replace(replace(t1.check_entry_ped_cd,chr(13),''),chr(10),'') as check_entry_ped_cd
,bkcp_open_acct_dt
,last_check_entry_dt
,replace(replace(t1.two_unentry_flg_cd,chr(13),''),chr(10),'') as two_unentry_flg_cd
,replace(replace(t1.seal_acct_id,chr(13),''),chr(10),'') as seal_acct_id
,replace(replace(t1.seal_way_cd,chr(13),''),chr(10),'') as seal_way_cd
,replace(replace(t1.rgst_addr,chr(13),''),chr(10),'') as rgst_addr
,replace(replace(t1.post_addr,chr(13),''),chr(10),'') as post_addr
,replace(replace(t1.zip_cd,chr(13),''),chr(10),'') as zip_cd
,replace(replace(t1.sign_flg,chr(13),''),chr(10),'') as sign_flg
,sign_dt
,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
,replace(replace(t1.sign_teller_id,chr(13),''),chr(10),'') as sign_teller_id
,replace(replace(t1.sign_cont_id,chr(13),''),chr(10),'') as sign_cont_id
,replace(replace(t1.cotas_name,chr(13),''),chr(10),'') as cotas_name
,replace(replace(t1.phone_num,chr(13),''),chr(10),'') as phone_num
,replace(replace(t1.resv_phone_num,chr(13),''),chr(10),'') as resv_phone_num

from ${icl_schema}.cmm_bkcp_check_acct_basic_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_bkcp_check_acct_basic_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
