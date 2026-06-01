: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_intnal_acct_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_intnal_acct_w.f.${batch_date}.dat
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
,t1.curr_cd
,t1.belong_org_id
,t1.accti_cd
,t1.bal_dir_cd
,t1.acct_status_cd
,t1.open_acct_dt
,t1.open_acct_flow_num
,t1.clos_acct_dt
,t1.clos_acct_flow_num
,t1.in_out_tab_flg
,t1.bus_code_ser_num
,t1.gl_acct_flg
,t1.create_dt 
,t1.update_dt
,t1.id_mark 
,t1.job_cd
from ${idl_schema}.agt_intnal_acct t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_intnal_acct_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes