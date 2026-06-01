: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ups_refund_flow_i
CreateDate: 20230810
FileName:   ${iel_data_path}/evt_ups_refund_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.batch_no,chr(13),''),chr(10),'') as batch_no
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,tran_amt
,tran_dt
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.acpt_pay_instr_cd,chr(13),''),chr(10),'') as acpt_pay_instr_cd
,replace(replace(t1.recver_acct_org_id,chr(13),''),chr(10),'') as recver_acct_org_id
,replace(replace(t1.recver_acct_id,chr(13),''),chr(10),'') as recver_acct_id
,replace(replace(t1.recver_acct_name,chr(13),''),chr(10),'') as recver_acct_name
,replace(replace(t1.recver_acct_type_cd,chr(13),''),chr(10),'') as recver_acct_type_cd
,replace(replace(t1.send_org_id,chr(13),''),chr(10),'') as send_org_id
,replace(replace(t1.refund_acct_org_id,chr(13),''),chr(10),'') as refund_acct_org_id
,replace(replace(t1.refund_acct_id,chr(13),''),chr(10),'') as refund_acct_id
,replace(replace(t1.refund_acct_type_cd,chr(13),''),chr(10),'') as refund_acct_type_cd
,replace(replace(t1.sign_agt_id,chr(13),''),chr(10),'') as sign_agt_id
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t1.mercht_cate_cd,chr(13),''),chr(10),'') as mercht_cate_cd
,replace(replace(t1.mercht_name,chr(13),''),chr(10),'') as mercht_name
,replace(replace(t1.level2_mercht_id,chr(13),''),chr(10),'') as level2_mercht_id
,replace(replace(t1.level2_mercht_cate_cd,chr(13),''),chr(10),'') as level2_mercht_cate_cd
,replace(replace(t1.level2_mercht_name,chr(13),''),chr(10),'') as level2_mercht_name
,replace(replace(t1.init_tran_flow_num,chr(13),''),chr(10),'') as init_tran_flow_num
,replace(replace(t1.init_indent_id,chr(13),''),chr(10),'') as init_indent_id
,init_tran_amt
,init_tran_tm
,replace(replace(t1.sys_flow_num,chr(13),''),chr(10),'') as sys_flow_num
,replace(replace(t1.sys_type_cd,chr(13),''),chr(10),'') as sys_type_cd
,sys_tran_dt
,replace(replace(t1.sys_return_code,chr(13),''),chr(10),'') as sys_return_code
,replace(replace(t1.sys_return_comnt,chr(13),''),chr(10),'') as sys_return_comnt
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,core_tran_dt
,replace(replace(t1.core_tran_status_cd,chr(13),''),chr(10),'') as core_tran_status_cd
,replace(replace(t1.aldy_tran_flg,chr(13),''),chr(10),'') as aldy_tran_flg
,replace(replace(t1.aldy_adj_entry_flg,chr(13),''),chr(10),'') as aldy_adj_entry_flg
,replace(replace(t1.aldy_clear_flg,chr(13),''),chr(10),'') as aldy_clear_flg
,replace(replace(t1.check_entry_status_cd,chr(13),''),chr(10),'') as check_entry_status_cd
,replace(replace(t1.clear_batch_no,chr(13),''),chr(10),'') as clear_batch_no
,clear_dt
,replace(replace(t1.plat_tran_flow_num,chr(13),''),chr(10),'') as plat_tran_flow_num
,plat_tran_dt
,plat_tran_tm
,replace(replace(t1.out_plat_flow_num,chr(13),''),chr(10),'') as out_plat_flow_num
,replace(replace(t1.out_ova_plat_flow_num,chr(13),''),chr(10),'') as out_ova_plat_flow_num
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.teller_id,chr(13),''),chr(10),'') as teller_id
,create_tm
,final_update_tm

from ${iml_schema}.evt_ups_refund_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt > to_date('${batch_date}','yyyymmdd')-15" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ups_refund_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
