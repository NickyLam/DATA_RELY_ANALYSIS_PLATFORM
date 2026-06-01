: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_ir_indv_se_cr_card_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_ir_indv_se_cr_card_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.key_id,chr(13),''),chr(10),'') as key_id
    ,replace(replace(t.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
    ,replace(replace(t.data_time,chr(13),''),chr(10),'') as data_time
    ,replace(replace(t.indv_se_cr_card_info_seq_num,chr(13),''),chr(10),'') as indv_se_cr_card_info_seq_num
    ,replace(replace(t.se_cr_card_desc,chr(13),''),chr(10),'') as se_cr_card_desc
    ,replace(replace(t.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
    ,replace(replace(t.mon_repay_amt,chr(13),''),chr(10),'') as mon_repay_amt
    ,replace(replace(t.od_bal,chr(13),''),chr(10),'') as od_bal
    ,replace(replace(t.shr_crdt_lmt,chr(13),''),chr(10),'') as shr_crdt_lmt
    ,replace(replace(t.se_cr_card_issue_dt,chr(13),''),chr(10),'') as se_cr_card_issue_dt
    ,replace(replace(t.last_two_year_repay_rec,chr(13),''),chr(10),'') as last_two_year_repay_rec
    ,replace(replace(t.crdt_lmt,chr(13),''),chr(10),'') as crdt_lmt
    ,replace(replace(t.last_two_year_repay_rec_align,chr(13),''),chr(10),'') as last_two_year_repay_rec_align
    ,replace(replace(t.end_date,chr(13),''),chr(10),'') as end_date
    ,replace(replace(t.od180_day_above_unpaid_bal,chr(13),''),chr(10),'') as od180_day_above_unpaid_bal
    ,replace(replace(t.mon_payable_amt,chr(13),''),chr(10),'') as mon_payable_amt
    ,replace(replace(t.last_6_mon_avg_od_lmt,chr(13),''),chr(10),'') as last_6_mon_avg_od_lmt
    ,replace(replace(t.last_five_year_repay_rec,chr(13),''),chr(10),'') as last_five_year_repay_rec
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcds_ir_indv_se_cr_card_info t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_ir_indv_se_cr_card_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes