: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_abs_cashflow_plan_f
CreateDate: 20230602
FileName:   ${iel_data_path}/cmm_abs_cashflow_plan.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bond_item_id,chr(13),''),chr(10),'') as bond_item_id
,rpbl_dt
,rpbl_pric
,rpbl_int

from ${icl_schema}.cmm_abs_cashflow_plan t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_abs_cashflow_plan.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
