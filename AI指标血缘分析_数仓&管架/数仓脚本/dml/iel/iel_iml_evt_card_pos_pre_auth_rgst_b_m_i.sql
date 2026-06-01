: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_card_pos_pre_auth_rgst_b_m_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_card_pos_pre_auth_rgst_b_m.i.${batch_date}.dat
IF_mark:    m_i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,t1.tran_dt as tran_dt
,replace(replace(t1.pre_auth_id,chr(13),''),chr(10),'') as pre_auth_id
,replace(replace(t1.tran_termn_id,chr(13),''),chr(10),'') as tran_termn_id
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,t1.unionpay_dt as unionpay_dt
,replace(replace(t1.send_org_id,chr(13),''),chr(10),'') as send_org_id
,replace(replace(t1.proc_org_id,chr(13),''),chr(10),'') as proc_org_id
,t1.effect_dt as effect_dt
,t1.invalid_dt as invalid_dt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.tran_amt as tran_amt
,t1.cmplt_amt as cmplt_amt
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id
,replace(replace(t1.chn_bus_proc_status,chr(13),''),chr(10),'') as chn_bus_proc_status
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,t1.tran_tm as tran_tm
from ${iml_schema}.evt_card_pos_pre_auth_rgst_b t1
where to_char(etl_dt,'yyyymm') = to_char(to_date('${batch_date}','yyyymmdd'),'yyyymm')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_card_pos_pre_auth_rgst_b_m.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes