: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_wld_bank_coll_comm_flow_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_wld_bank_coll_comm_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt 
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.ser_num,chr(13),''),chr(10),'') as ser_num 
,t1.comm_dt as comm_dt 
,replace(replace(t1.logic_card_no,chr(13),''),chr(10),'') as logic_card_no 
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id 
,t1.ovdue_days as ovdue_days 
,t1.repay_dt as repay_dt 
,t1.repay_amt as repay_amt 
,replace(replace(t1.syn_id,chr(13),''),chr(10),'') as syn_id 
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id 
,t1.bank_contri_ratio as bank_contri_ratio 
,t1.outsourc_fee_rat as outsourc_fee_rat 
,t1.outsourc_fee as outsourc_fee 
from ${iml_schema}.evt_wld_bank_coll_comm_flow t1 
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('20200101','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_wld_bank_coll_comm_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes