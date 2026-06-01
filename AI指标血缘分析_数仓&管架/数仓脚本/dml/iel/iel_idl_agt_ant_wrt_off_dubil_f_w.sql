: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_ant_wrt_off_dubil_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_ant_wrt_off_dubil_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.agt_id as agt_id
,t.lp_id as lp_id
,t.dubil_id as dubil_id
,t.cust_id as cust_id
,t.dubil_amt as dubil_amt
,t.curr_bal as curr_bal
,t.exp_dt as exp_dt
,t.exec_int_rat as exec_int_rat
,t.ovdue_days as ovdue_days
,t.int as int
,t.pnlt as pnlt
,t.repay_way_cd as repay_way_cd
,t.tenor as tenor
,t.acct_instit_id as acct_instit_id
,t.wrt_off_status_cd as wrt_off_status_cd
,t.bus_type_cd as bus_type_cd
,t.distr_dt as distr_dt
,t.ovdue_dt as ovdue_dt
,t.coll_cnt as coll_cnt
,t.insto_dt as insto_dt
,t.fir_wrt_off_dt as fir_wrt_off_dt
,t.recvbl_pric as recvbl_pric
,t.recvbl_off_bs_int as recvbl_off_bs_int
,t.remark as remark
,t.level5_cls_cd as level5_cls_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark
,t.job_cd 
from ${idl_schema}.agt_ant_wrt_off_dubil t 
where t.etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ant_wrt_off_dubil_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes