: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_finc_redem_cost_info_h_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_finc_redem_cost_info_h.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
    ,t.cfm_dt as cfm_dt
    ,replace(replace(t.cfm_flow_num,chr(13),''),chr(10),'') as cfm_flow_num
    ,t.init_tot_lot as init_tot_lot
    ,t.acm_flow_contri_gold_cors_cost as acm_flow_contri_gold_cors_cost
    ,t.acm_put_into_cost as acm_put_into_cost
    ,t.redem_or_exp_cost as redem_or_exp_cost
from iml.evt_finc_redem_cost_info_h t
where t.cfm_dt=to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_finc_redem_cost_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes