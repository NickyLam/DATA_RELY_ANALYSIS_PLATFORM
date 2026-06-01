: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_seal_acct_basic_info_f
CreateDate: 20230602
FileName:   ${iel_data_path}/cmm_seal_acct_basic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,open_acct_dt
,acct_start_use_dt
,acct_wrtoff_dt
,replace(replace(t1.seal_kind_cd,chr(13),''),chr(10),'') as seal_kind_cd
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.warn_flg_cd,chr(13),''),chr(10),'') as warn_flg_cd
,replace(replace(t1.pt_type_cd,chr(13),''),chr(10),'') as pt_type_cd
,replace(replace(t1.acct_kind_cd,chr(13),''),chr(10),'') as acct_kind_cd
,replace(replace(t1.tran_kind_cd,chr(13),''),chr(10),'') as tran_kind_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.unite_acct_flg,chr(13),''),chr(10),'') as unite_acct_flg
,replace(replace(t1.sleep_acct_flg,chr(13),''),chr(10),'') as sleep_acct_flg
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.cotas_name,chr(13),''),chr(10),'') as cotas_name
,replace(replace(t1.cont_addr,chr(13),''),chr(10),'') as cont_addr
,replace(replace(t1.phone_num,chr(13),''),chr(10),'') as phone_num

from ${icl_schema}.cmm_seal_acct_basic_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_seal_acct_basic_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
