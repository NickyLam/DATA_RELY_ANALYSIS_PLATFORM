: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_finc_acct_f
CreateDate: 20250619
FileName:   ${iel_data_path}/agt_finc_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.intnal_cust_acct,chr(13),''),chr(10),'') as intnal_cust_acct
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.open_acct_way_cd,chr(13),''),chr(10),'') as open_acct_way_cd
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.bus_cate_cd,chr(13),''),chr(10),'') as bus_cate_cd
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,open_dt
,replace(replace(t1.sign_acct_id,chr(13),''),chr(10),'') as sign_acct_id

from ${iml_schema}.agt_finc_acct t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_finc_acct.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
