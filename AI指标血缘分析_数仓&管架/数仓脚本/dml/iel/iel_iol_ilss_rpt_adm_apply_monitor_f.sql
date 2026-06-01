: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_rpt_adm_apply_monitor_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_rpt_adm_apply_monitor.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.apply_time as apply_time
,t.apply_cnt as apply_cnt
,t.apply_limit as apply_limit
,t.apply_pass as apply_pass
,t.apply_pass_amt as apply_pass_amt
,replace(replace(t.timeh,chr(13),''),chr(10),'') as timeh
,t.apply_reject as apply_reject
,t.pass_rate as pass_rate
,t.reject_rate as reject_rate
,t.data_dt as data_dt
,t.apply_other as apply_other
,replace(replace(t.code,chr(13),''),chr(10),'') as code
from iol.ilss_rpt_adm_apply_monitor t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_rpt_adm_apply_monitor.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes