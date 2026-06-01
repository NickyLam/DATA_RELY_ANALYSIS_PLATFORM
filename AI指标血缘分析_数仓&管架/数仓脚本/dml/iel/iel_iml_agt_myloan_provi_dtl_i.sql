: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_myloan_provi_dtl_i
CreateDate: 20230423
FileName:   ${iel_data_path}/agt_myloan_provi_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,int_accr_dt
,replace(replace(t1.acru_non_acru_flg,chr(13),''),chr(10),'') as acru_non_acru_flg
,ovdue_int_bal
,loan_pnlt_day_int_rat
,nomal_int
,ovdue_pric_pnlt
,ovdue_int_pnlt
,nomal_pric_bal
,ovdue_pric_bal
,loan_actl_day_int_rat

from ${iml_schema}.agt_myloan_provi_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')-1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_myloan_provi_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
