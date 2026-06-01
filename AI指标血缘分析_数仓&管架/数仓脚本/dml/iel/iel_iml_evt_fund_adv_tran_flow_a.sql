: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_fund_adv_tran_flow_a
CreateDate: 20231030
FileName:   ${iel_data_path}/evt_fund_adv_tran_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.intnal_brch_id,chr(13),''),chr(10),'') as intnal_brch_id
,tran_dt
,replace(replace(t1.recv_org_id,chr(13),''),chr(10),'') as recv_org_id
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.agt_corp_id,chr(13),''),chr(10),'') as agt_corp_id
,replace(replace(t1.clear_acct_id,chr(13),''),chr(10),'') as clear_acct_id
,replace(replace(t1.clear_intnal_acct_id,chr(13),''),chr(10),'') as clear_intnal_acct_id
,replace(replace(t1.clear_intnal_acct_name,chr(13),''),chr(10),'') as clear_intnal_acct_name
,clear_dt
,replace(replace(t1.stl_mode_descb,chr(13),''),chr(10),'') as stl_mode_descb
,tot_e_amt
,used_lmt
,comm_fee_amt
,unionpay_sucs_amt
,tot
,tot_amt
,sucs_cnt
,sucs_tot_amt
,fail_cnt
,fail_amt
,not_tran_cnt
,not_tran_amt
,payfan_repay_amt
,bus_cfm_amt
,replace(replace(t1.cfm_ps_id,chr(13),''),chr(10),'') as cfm_ps_id
,replace(replace(t1.cfm_status_cd,chr(13),''),chr(10),'') as cfm_status_cd
,actl_remit_acct_amt
,replace(replace(t1.aldy_remit_acct_flg,chr(13),''),chr(10),'') as aldy_remit_acct_flg
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,replace(replace(t1.err_descb,chr(13),''),chr(10),'') as err_descb

from ${iml_schema}.evt_fund_adv_tran_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_fund_adv_tran_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
