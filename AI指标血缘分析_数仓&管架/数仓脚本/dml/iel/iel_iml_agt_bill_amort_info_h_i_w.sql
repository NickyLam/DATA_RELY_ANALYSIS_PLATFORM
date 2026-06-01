: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_amort_info_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bill_amort_info_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.amort_id,chr(13),''),chr(10),'') as amort_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.bill_id,chr(13),''),chr(10),'') as bill_id
,t.flow_tab_curr_seq_num as flow_tab_curr_seq_num
,replace(replace(t.provi_type_cd,chr(13),''),chr(10),'') as provi_type_cd
,replace(replace(t.provi_ped_cd,chr(13),''),chr(10),'') as provi_ped_cd
,t.plan_pd as plan_pd
,t.provi_dt as provi_dt
,t.last_provi_dt as last_provi_dt
,t.next_provi_dt as next_provi_dt
,t.carr_dt as carr_dt
,replace(replace(t.provi_org_id,chr(13),''),chr(10),'') as provi_org_id
,t.provi_int_tot as provi_int_tot
,t.day_amort_lmt as day_amort_lmt
,t.provi_int_bal as provi_int_bal
,replace(replace(t.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t.dr_subj_id,chr(13),''),chr(10),'') as dr_subj_id
,replace(replace(t.cr_subj_id,chr(13),''),chr(10),'') as cr_subj_id
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_bill_amort_info_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_amort_info_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes