: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_crps_evt_myloan_tran_repay_plan_i
CreateDate: 20230608
FileName:   ${iel_data_path}/crps_evt_myloan_tran_repay_plan.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.evt_id as evt_id
,t1.lp_id as lp_id
,t1.cont_id as cont_id
,t1.pd_num as pd_num
,t1.asset_tran_bus_dt as asset_tran_bus_dt
,t1.asset_tran_tran_tm as asset_tran_tran_tm
,t1.asset_tran_bus_flow_num as asset_tran_bus_flow_num
,t1.cap_flow_num as cap_flow_num
,t1.inst_start_dt as inst_start_dt
,t1.inst_end_dt as inst_end_dt
,t1.pric_bal as pric_bal
,t1.int_bal as int_bal
,t1.ovdue_pric_pnlt_bal as ovdue_pric_pnlt_bal
,t1.ovdue_int_pnlt_bal as ovdue_int_pnlt_bal
,t1.tran_type_cd as tran_type_cd
,t1.tran_way_cd as tran_way_cd
,t1.tran_amt as tran_amt
,t1.asset_bal_diff_amt as asset_bal_diff_amt
,t1.inst_status_cd as inst_status_cd
,t1.acru_non_idf_cd as acru_non_idf_cd
,t1.wrt_off_flg as wrt_off_flg
,t1.asset_tran_cntpty_org_id as asset_tran_cntpty_org_id
,t1.dist_cd as dist_cd

from ${idl_schema}.crps_evt_myloan_tran_repay_plan t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_evt_myloan_tran_repay_plan.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
