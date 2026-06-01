: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_wl_repay_apply_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_wl_repay_apply.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.repay_no,chr(13),''),chr(10),'') as repay_no
,replace(replace(t.product_no,chr(13),''),chr(10),'') as product_no
,replace(replace(t.iou_no,chr(13),''),chr(10),'') as iou_no
,replace(replace(t.contract_no,chr(13),''),chr(10),'') as contract_no
,replace(replace(t.customer_no,chr(13),''),chr(10),'') as customer_no
,t.apply_time as apply_time
,replace(replace(t.repay_type,chr(13),''),chr(10),'') as repay_type
,replace(replace(t.repay_acct_num,chr(13),''),chr(10),'') as repay_acct_num
,t.repay_amt as repay_amt
,t.repay_fine as repay_fine
,t.loan_amt as loan_amt
,t.inst_amt as inst_amt
,t.overdue_amt as overdue_amt
,t.debt_amt as debt_amt
,t.bad_amt as bad_amt
,t.accr_int as accr_int
,t.obs_accr_int as obs_accr_int
,t.rec_arr_int as rec_arr_int
,t.obs_rec_arr_int as obs_rec_arr_int
,t.accr_pnty_int as accr_pnty_int
,t.obs_pnty_int as obs_pnty_int
,t.rec_pnsh_int as rec_pnsh_int
,t.obs_pnsh_int as obs_pnsh_int
,t.accr_comp_int as accr_comp_int
,t.rec_comp_int as rec_comp_int
,t.bal_amt as bal_amt
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.message,chr(13),''),chr(10),'') as message
,replace(replace(t.trans_seq_no,chr(13),''),chr(10),'') as trans_seq_no
,replace(replace(t.trans_status,chr(13),''),chr(10),'') as trans_status
,t.trans_time as trans_time
,replace(replace(t.pay_order_id,chr(13),''),chr(10),'') as pay_order_id
,replace(replace(t.pay_seq_no,chr(13),''),chr(10),'') as pay_seq_no
,replace(replace(t.global_seq_no,chr(13),''),chr(10),'') as global_seq_no
,replace(replace(t.hostcr_seq_no,chr(13),''),chr(10),'') as hostcr_seq_no
,replace(replace(t.hostdr_seq_no,chr(13),''),chr(10),'') as hostdr_seq_no
,t.record_time as record_time
,t.group_id as group_id
,replace(replace(t.create_user,chr(13),''),chr(10),'') as create_user
,t.create_time as create_time
,replace(replace(t.update_user,chr(13),''),chr(10),'') as update_user
,t.update_time as update_time
,t.period_amt as period_amt
,t.remain_amt as remain_amt
,replace(replace(t.serial_no,chr(13),''),chr(10),'') as serial_no
from iol.ilss_wl_repay_apply t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_wl_repay_apply.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes