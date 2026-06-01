: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_wld_coll_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_wld_coll_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.batch_doc_name,chr(13),''),chr(10),'') as batch_doc_name
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.coll_flow_num,chr(13),''),chr(10),'') as coll_flow_num
,replace(replace(t1.case_id,chr(13),''),chr(10),'') as case_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.way_cd,chr(13),''),chr(10),'') as way_cd
,replace(replace(t1.coll_act_type_cd,chr(13),''),chr(10),'') as coll_act_type_cd
,t1.coll_dt as coll_dt
,replace(replace(t1.coll_rest_type_cd,chr(13),''),chr(10),'') as coll_rest_type_cd
,t1.promis_repay_amt as promis_repay_amt
,t1.promis_repay_dt as promis_repay_dt
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,t1.create_tm as create_tm
,t1.final_modif_tm as final_modif_tm
from ${iml_schema}.evt_wld_coll_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_wld_coll_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes