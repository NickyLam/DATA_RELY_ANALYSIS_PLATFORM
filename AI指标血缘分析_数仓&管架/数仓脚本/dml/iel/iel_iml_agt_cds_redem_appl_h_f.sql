: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cds_redem_appl_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cds_redem_appl_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.seq_num,chr(13),''),chr(10),'') as seq_num
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
    ,t.actl_proc_redem_dt as actl_proc_redem_dt
    ,replace(replace(t.redem_proc_status_cd,chr(13),''),chr(10),'') as redem_proc_status_cd
    ,replace(replace(t.redem_appl_oa_apv_form_num,chr(13),''),chr(10),'') as redem_appl_oa_apv_form_num
    ,t.actl_redem_pric as actl_redem_pric
    ,t.actl_redem_int as actl_redem_int
    ,t.actl_redem_int_accr_days as actl_redem_int_accr_days
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_cds_redem_appl_h t 
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cds_redem_appl_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes