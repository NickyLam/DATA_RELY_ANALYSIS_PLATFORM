: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_cust_acct_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cust_acct_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.agt_id
,t1.lp_id
,t1.acct_id
,t1.acct_name
,t1.stand_b_type_cd
,t1.open_acct_org_id
,t1.acct_belong_org_id
,t1.prod_id
,t1.max_sub_acct_num
,t1.sub_acct_num_cnt
,t1.open_acct_dt
,t1.open_acct_flow_num
,t1.clos_acct_dt
,t1.clos_acct_flow_num
,t1.acct_status_cd
,t1.acct_draw_way_status_cd
,t1.privavy_acct_flg
,t1.draw_way_cd
,t1.pwd_way_cd
,t1.create_dt 
,t1.update_dt
,t1.id_mark 
,t1.job_cd
from ${idl_schema}.agt_cust_acct t1
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cust_acct_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes