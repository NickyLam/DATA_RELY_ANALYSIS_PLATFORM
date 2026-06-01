: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_finc_acct_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_finc_acct_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.intnal_cust_acct,chr(13),''),chr(10),'') as intnal_cust_acct
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,replace(replace(t.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t.open_acct_way_cd,chr(13),''),chr(10),'') as open_acct_way_cd
,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t.bus_cate_cd,chr(13),''),chr(10),'') as bus_cate_cd
,replace(replace(t.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,t.open_dt as open_dt
,replace(replace(t.sign_acct_id,chr(13),''),chr(10),'') as sign_acct_id
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_finc_acct t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_finc_acct_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes