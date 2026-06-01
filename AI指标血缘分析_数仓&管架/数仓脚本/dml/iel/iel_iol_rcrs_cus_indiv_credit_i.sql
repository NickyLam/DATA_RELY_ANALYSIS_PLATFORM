: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_cus_indiv_credit_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_cus_indiv_credit.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t.html_file_path,chr(13),''),chr(10),'') as html_file_path
,replace(replace(t.baddebt_info_sum_cnt,chr(13),''),chr(10),'') as baddebt_info_sum_cnt
,replace(replace(t.baddebt_info_sum_bal,chr(13),''),chr(10),'') as baddebt_info_sum_bal
,replace(replace(t.loan_ovdue_cnt,chr(13),''),chr(10),'') as loan_ovdue_cnt
,replace(replace(t.loan_ovdue_mon_shr,chr(13),''),chr(10),'') as loan_ovdue_mon_shr
,replace(replace(t.loan_ovdue_mon_high_total_amt,chr(13),''),chr(10),'') as loan_ovdue_mon_high_total_amt
,replace(replace(t.loan_ovdue_long_ovdue_months,chr(13),''),chr(10),'') as loan_ovdue_long_ovdue_months
,replace(replace(t.cr_card_ovdue_acct_qty,chr(13),''),chr(10),'') as cr_card_ovdue_acct_qty
,replace(replace(t.cr_card_ovdue_mon_shr,chr(13),''),chr(10),'') as cr_card_ovdue_mon_shr
,replace(replace(t.cr_card_ovdue_mon_higho_amt,chr(13),''),chr(10),'') as cr_card_ovdue_mon_higho_amt
,replace(replace(t.cr_card_ovdue_long_ovdue_month,chr(13),''),chr(10),'') as cr_card_ovdue_long_ovdue_month
,replace(replace(t.non_loan_sum_cnt,chr(13),''),chr(10),'') as non_loan_sum_cnt
,replace(replace(t.non_loan_sum_ctr_total_amt,chr(13),''),chr(10),'') as non_loan_sum_ctr_total_amt
,replace(replace(t.non_loan_sum_bal,chr(13),''),chr(10),'') as non_loan_sum_bal
,replace(replace(t.non_loan_sum_6_mon_avg_pay_amt,chr(13),''),chr(10),'') as non_loan_sum_6_mon_avg_pay_amt
,replace(replace(t.ext_guar_sum_guar_cnt,chr(13),''),chr(10),'') as ext_guar_sum_guar_cnt
,replace(replace(t.ext_guar_sum_guar_amt,chr(13),''),chr(10),'') as ext_guar_sum_guar_amt
,replace(replace(t.ext_guar_sum_guar_bal,chr(13),''),chr(10),'') as ext_guar_sum_guar_bal
,replace(replace(t.input_id,chr(13),''),chr(10),'') as input_id
,replace(replace(t.input_br_id,chr(13),''),chr(10),'') as input_br_id
,replace(replace(t.input_date,chr(13),''),chr(10),'') as input_date
,replace(replace(t.last_upd_id,chr(13),''),chr(10),'') as last_upd_id
,replace(replace(t.last_upd_date,chr(13),''),chr(10),'') as last_upd_date
,replace(replace(t.report_date,chr(13),''),chr(10),'') as report_date
,replace(replace(t.report_id,chr(13),''),chr(10),'') as report_id
,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t.cert_id,chr(13),''),chr(10),'') as cert_id
,replace(replace(t.cus_name,chr(13),''),chr(10),'') as cus_name
,replace(replace(t.tran_seq_no,chr(13),''),chr(10),'') as tran_seq_no
,replace(replace(t.error_msg,chr(13),''),chr(10),'') as error_msg
,replace(replace(t.crc_count,chr(13),''),chr(10),'') as crc_count
,replace(replace(t.query_count,chr(13),''),chr(10),'') as query_count
,replace(replace(t.max_overdue_count,chr(13),''),chr(10),'') as max_overdue_count
,replace(replace(t.total_overdue_count,chr(13),''),chr(10),'') as total_overdue_count
,replace(replace(t.card_count,chr(13),''),chr(10),'') as card_count
,t.card_used_rate as card_used_rate
,replace(replace(t.max_card_overdue_count,chr(13),''),chr(10),'') as max_card_overdue_count
,replace(replace(t.cus_id,chr(13),''),chr(10),'') as cus_id
,replace(replace(t.loan_guar_count,chr(13),''),chr(10),'') as loan_guar_count
,replace(replace(t.loan_guar_amt,chr(13),''),chr(10),'') as loan_guar_amt
,replace(replace(t.loan_att_amt,chr(13),''),chr(10),'') as loan_att_amt
,replace(replace(t.loan_bad_amt,chr(13),''),chr(10),'') as loan_bad_amt
,replace(replace(t.loan_over_amt,chr(13),''),chr(10),'') as loan_over_amt
,replace(replace(t.is_card_overdue,chr(13),''),chr(10),'') as is_card_overdue
,replace(replace(t.procard_count,chr(13),''),chr(10),'') as procard_count
,replace(replace(t.proloan_overdue,chr(13),''),chr(10),'') as proloan_overdue
,replace(replace(t.procard_overdue_count,chr(13),''),chr(10),'') as procard_overdue_count
,replace(replace(t.max_procard_overdue_count,chr(13),''),chr(10),'') as max_procard_overdue_count
,replace(replace(t.procard_use_rate,chr(13),''),chr(10),'') as procard_use_rate
,replace(replace(t.total_card_overdue_count,chr(13),''),chr(10),'') as total_card_overdue_count
,t.mon_repay_amt as mon_repay_amt
,t.non_crdt_total_amt as non_crdt_total_amt
,t.non_crdt_total_max_amt as non_crdt_total_max_amt
,replace(replace(t.card_used_six_rate,chr(13),''),chr(10),'') as card_used_six_rate
,replace(replace(t.loan_amt,chr(13),''),chr(10),'') as loan_amt
,replace(replace(t.model_type,chr(13),''),chr(10),'') as model_type
,replace(replace(t.t_loan_ovdue_cnt,chr(13),''),chr(10),'') as t_loan_ovdue_cnt
,replace(replace(t.t_loan_sin_ovdue_cnt,chr(13),''),chr(10),'') as t_loan_sin_ovdue_cnt
,replace(replace(t.t_loan_ovdue_mon_high,chr(13),''),chr(10),'') as t_loan_ovdue_mon_high
,replace(replace(t.t_loan_ovdue_long_ovdue,chr(13),''),chr(10),'') as t_loan_ovdue_long_ovdue
,replace(replace(t.t_cr_card_ovdue_acct,chr(13),''),chr(10),'') as t_cr_card_ovdue_acct
,replace(replace(t.t_cr_card_ovdue_mon_shr,chr(13),''),chr(10),'') as t_cr_card_ovdue_mon_shr
,replace(replace(t.t_cr_card_ovdue_mon_higho,chr(13),''),chr(10),'') as t_cr_card_ovdue_mon_higho
,replace(replace(t.t_cr_card_ovdue_long,chr(13),''),chr(10),'') as t_cr_card_ovdue_long
,replace(replace(t.t_non_cr_card_sum_issue,chr(13),''),chr(10),'') as t_non_cr_card_sum_issue
,replace(replace(t.t_non_cr_card_sum_acct,chr(13),''),chr(10),'') as t_non_cr_card_sum_acct
,replace(replace(t.t_non_cr_card_sum_crdt,chr(13),''),chr(10),'') as t_non_cr_card_sum_crdt
,replace(replace(t.t_non_cr_card_sum_one_row,chr(13),''),chr(10),'') as t_non_cr_card_sum_one_row
,replace(replace(t.t_non_cr_card_sum_one_low,chr(13),''),chr(10),'') as t_non_cr_card_sum_one_low
,replace(replace(t.t_non_cr_card_sum_used,chr(13),''),chr(10),'') as t_non_cr_card_sum_used
,replace(replace(t.t_non_cr_card_sum_last,chr(13),''),chr(10),'') as t_non_cr_card_sum_last
,replace(replace(t.t_se_cr_card60_day_above_a,chr(13),''),chr(10),'') as t_se_cr_card60_day_above_a
,replace(replace(t.t_scr_card60_above_od_mon_q,chr(13),''),chr(10),'') as t_scr_card60_above_od_mon_q
,replace(replace(t.t_scr_card60_above_od_mon_h,chr(13),''),chr(10),'') as t_scr_card60_above_od_mon_h
,replace(replace(t.t_se_cr_card60_day_above_l,chr(13),''),chr(10),'') as t_se_cr_card60_day_above_l
,replace(replace(t.t_non_scr_card_sum_issue,chr(13),''),chr(10),'') as t_non_scr_card_sum_issue
,replace(replace(t.t_non_scr_card_sum_acct,chr(13),''),chr(10),'') as t_non_scr_card_sum_acct
,replace(replace(t.t_non_scr_card_sum_crdt,chr(13),''),chr(10),'') as t_non_scr_card_sum_crdt
,replace(replace(t.t_non_scr_card_sum_one_h,chr(13),''),chr(10),'') as t_non_scr_card_sum_one_h
,replace(replace(t.t_non_scr_card_sum_one_l,chr(13),''),chr(10),'') as t_non_scr_card_sum_one_l
,replace(replace(t.t_non_scr_card_sum_used,chr(13),''),chr(10),'') as t_non_scr_card_sum_used
,replace(replace(t.t_non_scr_card_sum_6,chr(13),''),chr(10),'') as t_non_scr_card_sum_6
,replace(replace(t.t_ext_guar_sum_guar_cnt,chr(13),''),chr(10),'') as t_ext_guar_sum_guar_cnt
,replace(replace(t.t_ext_guar_sum_guar_amt,chr(13),''),chr(10),'') as t_ext_guar_sum_guar_amt
,replace(replace(t.apply_socre,chr(13),''),chr(10),'') as apply_socre
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcrs_cus_indiv_credit t
where to_date(t.last_upd_date,'yyyy-mm-dd')=to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_cus_indiv_credit.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes