: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_time_dep_acct_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_time_dep_acct_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.agt_id
,t1.lp_id
,t1.acct_id
,t1.dep_tenor_cd
,t1.exp_dt
,t1.redt_way_type_cd
,t1.redted_cnt
,t1.cap_coll_acct_id
,t1.earliest_drawbl_dt
,t1.cont_id
,t1.int_set_ped_cd
,t1.create_dt 
,t1.update_dt
,t1.id_mark 
,t1.job_cd
from ${idl_schema}.agt_time_dep_acct t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_time_dep_acct_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes