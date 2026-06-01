: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_ibs_pre_proc_flow_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_ibs_pre_proc_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.pre_proc_id,chr(13),''),chr(10),'') as pre_proc_id
,replace(replace(t1.init_pre_proc_id,chr(13),''),chr(10),'') as init_pre_proc_id
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.pre_proc_status_cd,chr(13),''),chr(10),'') as pre_proc_status_cd
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.init_chn_cd,chr(13),''),chr(10),'') as init_chn_cd
,replace(replace(t1.flow_bank_proc_flow_num,chr(13),''),chr(10),'') as flow_bank_proc_flow_num
,t1.appl_dt as appl_dt
,replace(replace(t1.appl_org_id,chr(13),''),chr(10),'') as appl_org_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.cert_name,chr(13),''),chr(10),'') as cert_name
,replace(replace(t1.agent_flg,chr(13),''),chr(10),'') as agent_flg
,replace(replace(t1.agent_cert_type_cd,chr(13),''),chr(10),'') as agent_cert_type_cd
,replace(replace(t1.agent_cert_no,chr(13),''),chr(10),'') as agent_cert_no
,replace(replace(t1.agent_cert_name,chr(13),''),chr(10),'') as agent_cert_name
,replace(replace(t1.agent_cont_mode_cd,chr(13),''),chr(10),'') as agent_cont_mode_cd
,replace(replace(t1.mobile_no,chr(13),''),chr(10),'') as mobile_no
,replace(replace(t1.precon_id,chr(13),''),chr(10),'') as precon_id
,replace(replace(t1.wdraw_usage_and_reason,chr(13),''),chr(10),'') as wdraw_usage_and_reason
,replace(replace(t1.other_usage,chr(13),''),chr(10),'') as other_usage
,replace(replace(t1.par_type_comb,chr(13),''),chr(10),'') as par_type_comb
,replace(replace(t1.par_type_amt_comb,chr(13),''),chr(10),'') as par_type_amt_comb
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.wdraw_lmt_comb,chr(13),''),chr(10),'') as wdraw_lmt_comb
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.card_status_cd,chr(13),''),chr(10),'') as card_status_cd
,replace(replace(t1.bus_content_descb,chr(13),''),chr(10),'') as bus_content_descb
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,t1.create_tm as create_tm
,replace(replace(t1.create_teller_id,chr(13),''),chr(10),'') as create_teller_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.evt_ibs_pre_proc_flow t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ibs_pre_proc_flow.f.${batch_date}.dat" \
        charset=utf8
        safe=yes