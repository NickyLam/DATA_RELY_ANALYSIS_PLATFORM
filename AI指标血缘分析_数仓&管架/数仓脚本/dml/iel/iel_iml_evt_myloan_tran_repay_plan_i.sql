: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_myloan_tran_repay_plan_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_myloan_tran_repay_plan.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.pd_num,chr(13),''),chr(10),'') as pd_num
,t1.asset_tran_bus_dt as asset_tran_bus_dt
,t1.asset_tran_tran_tm as asset_tran_tran_tm
,replace(replace(t1.asset_tran_bus_flow_num,chr(13),''),chr(10),'') as asset_tran_bus_flow_num
,replace(replace(t1.cap_flow_num,chr(13),''),chr(10),'') as cap_flow_num
,t1.inst_start_dt as inst_start_dt
,t1.inst_end_dt as inst_end_dt
,t1.pric_bal as pric_bal
,t1.int_bal as int_bal
,t1.ovdue_pric_pnlt_bal as ovdue_pric_pnlt_bal
,t1.ovdue_int_pnlt_bal as ovdue_int_pnlt_bal
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.tran_way_cd,chr(13),''),chr(10),'') as tran_way_cd
,t1.tran_amt as tran_amt
,t1.asset_bal_diff_amt as asset_bal_diff_amt
,replace(replace(t1.inst_status_cd,chr(13),''),chr(10),'') as inst_status_cd
,replace(replace(t1.acru_non_idf_cd,chr(13),''),chr(10),'') as acru_non_idf_cd
,replace(replace(t1.wrt_off_flg,chr(13),''),chr(10),'') as wrt_off_flg
,replace(replace(t1.asset_tran_cntpty_org_id,chr(13),''),chr(10),'') as asset_tran_cntpty_org_id
,replace(replace(t1.dist_cd,chr(13),''),chr(10),'') as dist_cd
from ${iml_schema}.evt_myloan_tran_repay_plan t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_myloan_tran_repay_plan.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes