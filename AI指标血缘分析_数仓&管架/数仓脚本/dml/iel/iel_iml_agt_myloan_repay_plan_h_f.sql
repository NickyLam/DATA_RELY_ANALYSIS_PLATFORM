: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_myloan_repay_plan_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/agt_myloan_repay_plan_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(agt_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(dubil_id,chr(13),''),chr(10),'')
,replace(replace(pd_num,chr(13),''),chr(10),'')
,rpbl_int
,rpbl_pric
,inst_start_dt
,inst_end_dt
,replace(replace(inst_status_cd,chr(13),''),chr(10),'')
,payoff_dt
,pric_turn_ovdue_dt
,int_turn_ovdue_dt
,pric_ovdue_days
,int_ovdue_days
,pric_bal
,int_bal
,rpbl_ovdue_pric_pnlt
,rpbl_ovdue_int_pnlt
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.agt_myloan_repay_plan_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_myloan_repay_plan_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
