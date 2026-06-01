: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_myloan_provi_dtl_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_myloan_provi_dtl_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,t.int_accr_dt as int_accr_dt
,replace(replace(t.acru_non_acru_flg,chr(13),''),chr(10),'') as acru_non_acru_flg
,t.ovdue_int_bal as ovdue_int_bal
,t.loan_pnlt_day_int_rat as loan_pnlt_day_int_rat
,t.nomal_int as nomal_int
,t.ovdue_pric_pnlt as ovdue_pric_pnlt
,t.ovdue_int_pnlt as ovdue_int_pnlt
,t.nomal_pric_bal as nomal_pric_bal
,t.ovdue_pric_bal as ovdue_pric_bal
,t.loan_actl_day_int_rat as loan_actl_day_int_rat
from ${iml_schema}.agt_myloan_provi_dtl t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_myloan_provi_dtl_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes