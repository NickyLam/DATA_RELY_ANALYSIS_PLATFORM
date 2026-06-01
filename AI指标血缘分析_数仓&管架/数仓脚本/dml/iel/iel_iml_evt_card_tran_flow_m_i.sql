: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_card_tran_flow_m_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_card_tran_flow_m.i.${batch_date}.dat
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
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,t1.unionpay_dt as unionpay_dt
,t1.host_dt as host_dt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.tran_amt as tran_amt
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id
,replace(replace(t1.card_tran_status_cd,chr(13),''),chr(10),'') as card_tran_status_cd
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.termn_flow_num,chr(13),''),chr(10),'') as termn_flow_num
,replace(replace(t1.tran_termn_id,chr(13),''),chr(10),'') as tran_termn_id
,t1.tran_tm as tran_tm
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
from ${iml_schema}.evt_card_tran_flow t1
where to_char(etl_dt,'yyyymm') = to_char(to_date('${batch_date}','yyyymmdd'),'yyyymm')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_card_tran_flow_m.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes