: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_ant_wrt_off_dubil_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_ant_wrt_off_dubil.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.dubil_id as dubil_id
,t1.cust_id as cust_id
,t1.dubil_amt as dubil_amt
,t1.curr_bal as curr_bal
,t1.exp_dt as exp_dt
,t1.exec_int_rat as exec_int_rat
,t1.ovdue_days as ovdue_days
,t1.int as int
,t1.pnlt as pnlt
,t1.repay_way_cd as repay_way_cd
,t1.tenor as tenor
,t1.acct_instit_id as acct_instit_id
,t1.wrt_off_status_cd as wrt_off_status_cd
,t1.bus_type_cd as bus_type_cd
,t1.distr_dt as distr_dt
,t1.ovdue_dt as ovdue_dt
,t1.coll_cnt as coll_cnt
,t1.insto_dt as insto_dt
,t1.fir_wrt_off_dt as fir_wrt_off_dt
,t1.recvbl_pric as recvbl_pric
,t1.recvbl_off_bs_int as recvbl_off_bs_int
,t1.remark as remark
,t1.level5_cls_cd as level5_cls_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.advc_fee as advc_fee
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_ant_wrt_off_dubil t1
where etl_dt = to_date('${batch_date}','yyyymmdd')-1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_ant_wrt_off_dubil.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
