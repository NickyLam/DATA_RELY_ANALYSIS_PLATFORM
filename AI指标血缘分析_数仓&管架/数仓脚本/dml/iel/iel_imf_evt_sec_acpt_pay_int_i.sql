: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_sec_acpt_pay_int_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_sec_acpt_pay_int.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.src_evt_id,chr(13),''),chr(10),'') as src_evt_id
,replace(replace(t1.quote_table_name,chr(13),''),chr(10),'') as quote_table_name
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.quote_tab_2_id,chr(13),''),chr(10),'') as quote_tab_2_id
,t1.rpp_int_dt as rpp_int_dt
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.asset_cate_name,chr(13),''),chr(10),'') as asset_cate_name
,replace(replace(t1.bond_cd,chr(13),''),chr(10),'') as bond_cd
,replace(replace(t1.pric_int_type_cd,chr(13),''),chr(10),'') as pric_int_type_cd
,t1.rpp_amt as rpp_amt
,t1.pay_int_amt as pay_int_amt
,replace(replace(t1.init_tran_id,chr(13),''),chr(10),'') as init_tran_id
,t1.actl_pay_dt as actl_pay_dt
,t1.actl_rp_cfm_tm as actl_rp_cfm_tm
from ${iml_schema}.evt_sec_acpt_pay_int t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_sec_acpt_pay_int.i.${batch_date}.dat" \
        charset=utf8
        safe=yes