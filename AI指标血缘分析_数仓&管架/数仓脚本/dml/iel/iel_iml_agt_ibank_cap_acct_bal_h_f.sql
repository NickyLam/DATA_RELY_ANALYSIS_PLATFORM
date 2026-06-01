: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_ibank_cap_acct_bal_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_ibank_cap_acct_bal_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.task_id,chr(13),''),chr(10),'') as task_id
,stl_dt
,replace(replace(t1.ext_cap_acct_id,chr(13),''),chr(10),'') as ext_cap_acct_id
,replace(replace(t1.intnal_cap_acct_id,chr(13),''),chr(10),'') as intnal_cap_acct_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.bal_type_cd,chr(13),''),chr(10),'') as bal_type_cd
,bal
,froz_bal
,aval_bal
,open_dt

from ${iml_schema}.agt_ibank_cap_acct_bal_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ibank_cap_acct_bal_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
