: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_abs_base_asset_info_f
CreateDate: 20230919
FileName:   ${iel_data_path}/cmm_abs_base_asset_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.base_asset_id,chr(13),''),chr(10),'') as base_asset_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.loan_cont_id,chr(13),''),chr(10),'') as loan_cont_id
,replace(replace(t1.asset_pool_id,chr(13),''),chr(10),'') as asset_pool_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,loan_amt
,bad_debt_amt
,ovdue_amt
,loan_bal
,idle_amt
,replace(replace(t1.asset_status_cd,chr(13),''),chr(10),'') as asset_status_cd
,tran_cosdetn
,pkg_belong_hxb_int
,pkg_pric_bal
,pkg_asset_bal
,pkg_belong_hxb_int_rat
,redem_belong_hxb_int
,redem_belong_trust_int
,redem_cosdetn
,redem_belong_trust_pric
,redem_cosdetn_pric
,redem_cosdetn_int
,pkg_bf_int_recvbl_bal
,pkg_post_int_recvbl_tot
,pkg_post_int_recvbl_bal
,rtn_pkg_post_int_recvbl
,tran_loan_int_tot
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name
,replace(replace(t1.recvbl_acct_belong_org_id,chr(13),''),chr(10),'') as recvbl_acct_belong_org_id
,rpbl_int
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id

from ${icl_schema}.cmm_abs_base_asset_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_abs_base_asset_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
