: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ppps_ps_agt_pay_flow_i
CreateDate: 20230816
FileName:   ${iel_data_path}/evt_ppps_ps_agt_pay_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.acpt_pay_instr_cd,chr(13),''),chr(10),'') as acpt_pay_instr_cd
,replace(replace(t1.payer_acct_belong_org_id,chr(13),''),chr(10),'') as payer_acct_belong_org_id
,replace(replace(t1.batch_no,chr(13),''),chr(10),'') as batch_no
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,tran_amt
,replace(replace(t1.tran_cate_cd,chr(13),''),chr(10),'') as tran_cate_cd
,tran_dt
,tran_tm
,replace(replace(t1.pay_status_cd,chr(13),''),chr(10),'') as pay_status_cd
,replace(replace(t1.plat_tran_flow_num,chr(13),''),chr(10),'') as plat_tran_flow_num
,plat_tran_dt
,plat_tran_tm
,create_tm
,replace(replace(t1.indent_id,chr(13),''),chr(10),'') as indent_id
,replace(replace(t1.indent_descb,chr(13),''),chr(10),'') as indent_descb
,replace(replace(t1.check_entry_descb,chr(13),''),chr(10),'') as check_entry_descb
,replace(replace(t1.check_entry_status_id,chr(13),''),chr(10),'') as check_entry_status_id
,replace(replace(t1.payer_agt_id,chr(13),''),chr(10),'') as payer_agt_id
,replace(replace(t1.payer_acct_id,chr(13),''),chr(10),'') as payer_acct_id
,replace(replace(t1.payer_acct_type_cd,chr(13),''),chr(10),'') as payer_acct_type_cd
,replace(replace(t1.payer_acct_name,chr(13),''),chr(10),'') as payer_acct_name
,replace(replace(t1.core_revs_flow_num,chr(13),''),chr(10),'') as core_revs_flow_num
,core_revs_dt
,core_tran_dt
,replace(replace(t1.core_tran_status_cd,chr(13),''),chr(10),'') as core_tran_status_cd
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,replace(replace(t1.core_req_flow_num,chr(13),''),chr(10),'') as core_req_flow_num
,replace(replace(t1.core_resp_code,chr(13),''),chr(10),'') as core_resp_code
,replace(replace(t1.core_resp_info,chr(13),''),chr(10),'') as core_resp_info
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.recver_acct_id,chr(13),''),chr(10),'') as recver_acct_id
,replace(replace(t1.recver_acct_type_cd,chr(13),''),chr(10),'') as recver_acct_type_cd
,replace(replace(t1.recver_acct_name,chr(13),''),chr(10),'') as recver_acct_name
,replace(replace(t1.recver_acct_belong_org_id,chr(13),''),chr(10),'') as recver_acct_belong_org_id
,replace(replace(t1.adj_entry_way_cd,chr(13),''),chr(10),'') as adj_entry_way_cd
,replace(replace(t1.sys_return_code,chr(13),''),chr(10),'') as sys_return_code
,replace(replace(t1.sys_return_comnt,chr(13),''),chr(10),'') as sys_return_comnt
,replace(replace(t1.sys_type_cd,chr(13),''),chr(10),'') as sys_type_cd
,replace(replace(t1.sys_flow_num,chr(13),''),chr(10),'') as sys_flow_num
,replace(replace(t1.bus_return_code,chr(13),''),chr(10),'') as bus_return_code
,bus_return_dt
,replace(replace(t1.bus_return_comnt,chr(13),''),chr(10),'') as bus_return_comnt
,replace(replace(t1.aldy_clear_flg,chr(13),''),chr(10),'') as aldy_clear_flg
,replace(replace(t1.aldy_adj_entry_flg,chr(13),''),chr(10),'') as aldy_adj_entry_flg
,aldy_refund_cnt
,aldy_refund_amt
,replace(replace(t1.aldy_tran_flg,chr(13),''),chr(10),'') as aldy_tran_flg
,final_update_tm

from ${iml_schema}.evt_ppps_ps_agt_pay_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt > to_date('${batch_date}','yyyymmdd')-15" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ppps_ps_agt_pay_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
