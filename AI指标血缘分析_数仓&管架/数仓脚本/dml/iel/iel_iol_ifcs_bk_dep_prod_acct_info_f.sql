: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifcs_bk_dep_prod_acct_info_f
CreateDate: 20231024
FileName:   ${iel_data_path}/ifcs_bk_dep_prod_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.part_id,chr(13),''),chr(10),'') as part_id
,replace(replace(t1.dep_prod_sub_acct_id,chr(13),''),chr(10),'') as dep_prod_sub_acct_id
,replace(replace(t1.dep_acct_id,chr(13),''),chr(10),'') as dep_acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.ext_prod_id,chr(13),''),chr(10),'') as ext_prod_id
,replace(replace(t1.dep_acct_status_cd,chr(13),''),chr(10),'') as dep_acct_status_cd
,replace(replace(t1.acpt_pay_status,chr(13),''),chr(10),'') as acpt_pay_status
,replace(replace(t1.froz_status,chr(13),''),chr(10),'') as froz_status
,replace(replace(t1.stpay_status_cd,chr(13),''),chr(10),'') as stpay_status_cd
,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg
,replace(replace(t1.open_acct_dt,chr(13),''),chr(10),'') as open_acct_dt
,replace(replace(t1.value_dt,chr(13),''),chr(10),'') as value_dt
,replace(replace(t1.exp_dt,chr(13),''),chr(10),'') as exp_dt
,bal
,froz_amt
,stpaybl
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.open_acct_chn_id,chr(13),''),chr(10),'') as open_acct_chn_id
,replace(replace(t1.open_acct_flow_num,chr(13),''),chr(10),'') as open_acct_flow_num
,replace(replace(t1.last_activ_acct_dt,chr(13),''),chr(10),'') as last_activ_acct_dt
,exec_int_rat
,base_rat
,spread_val
,replace(replace(t1.close_acct_dt,chr(13),''),chr(10),'') as close_acct_dt
,replace(replace(t1.close_acct_flow_num,chr(13),''),chr(10),'') as close_acct_flow_num
,pa_ext_cnt
,replace(replace(t1.dep_term_cd,chr(13),''),chr(10),'') as dep_term_cd
,replace(replace(t1.ext_acct_dt,chr(13),''),chr(10),'') as ext_acct_dt
,replace(replace(t1.open_acct_ti,chr(13),''),chr(10),'') as open_acct_ti
,replace(replace(t1.close_acct_ti,chr(13),''),chr(10),'') as close_acct_ti
,replace(replace(t1.fee_dt,chr(13),''),chr(10),'') as fee_dt
,replace(replace(t1.bind_acct_id,chr(13),''),chr(10),'') as bind_acct_id
,replace(replace(t1.dps_type_cd,chr(13),''),chr(10),'') as dps_type_cd

from ${iol_schema}.ifcs_bk_dep_prod_acct_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifcs_bk_dep_prod_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
