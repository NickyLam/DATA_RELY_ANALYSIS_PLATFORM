: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crps_evt_wld_bank_coll_comm_flow_i
CreateDate: 20230608
FileName:   ${iel_data_path}/crps_evt_wld_bank_coll_comm_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.evt_id as evt_id
,t1.lp_id as lp_id
,t1.ser_num as ser_num
,t1.comm_dt as comm_dt
,t1.logic_card_no as logic_card_no
,t1.dubil_id as dubil_id
,t1.ovdue_days as ovdue_days
,t1.repay_dt as repay_dt
,t1.repay_amt as repay_amt
,t1.syn_id as syn_id
,t1.bank_id as bank_id
,t1.bank_contri_ratio as bank_contri_ratio
,t1.outsourc_fee_rat as outsourc_fee_rat
,t1.outsourc_fee as outsourc_fee

from ${idl_schema}.crps_evt_wld_bank_coll_comm_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_evt_wld_bank_coll_comm_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
