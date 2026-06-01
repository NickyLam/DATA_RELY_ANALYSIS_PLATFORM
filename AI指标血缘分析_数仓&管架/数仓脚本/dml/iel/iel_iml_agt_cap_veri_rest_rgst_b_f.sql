: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cap_veri_rest_rgst_b_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cap_veri_rest_rgst_b.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id 
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num 
,replace(replace(t1.cap_vrfction_type_cd,chr(13),''),chr(10),'') as cap_vrfction_type_cd 
,t1.cap_vrfction_dt as cap_vrfction_dt 
,replace(replace(t1.cap_vrfction_flow_num,chr(13),''),chr(10),'') as cap_vrfction_flow_num 
,replace(replace(t1.cap_vrfction_rest_cd,chr(13),''),chr(10),'') as cap_vrfction_rest_cd 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_cap_veri_rest_rgst_b t1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cap_veri_rest_rgst_b.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes