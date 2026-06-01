: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cpms_t_account_quanyi_point_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cpms_t_account_quanyi_point.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.branch_no,chr(13),''),chr(10),'') as branch_no
    ,replace(replace(t.branch_no_name,chr(13),''),chr(10),'') as branch_no_name
    ,replace(replace(t.org_no,chr(13),''),chr(10),'') as org_no
    ,replace(replace(t.org_no_name,chr(13),''),chr(10),'') as org_no_name
    ,replace(replace(t.pty_id,chr(13),''),chr(10),'') as pty_id
    ,replace(replace(t.pty_name,chr(13),''),chr(10),'') as pty_name
    ,t.equity_count as equity_count
    ,replace(replace(t.val_end_dt,chr(13),''),chr(10),'') as val_end_dt
    ,replace(replace(t.is_valid,chr(13),''),chr(10),'') as is_valid
    ,replace(replace(t.last_ope_time,chr(13),''),chr(10),'') as last_ope_time
    ,replace(replace(t.final_oper_pers,chr(13),''),chr(10),'') as final_oper_pers
from iol.cpms_t_account_quanyi_point t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cpms_t_account_quanyi_point.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes