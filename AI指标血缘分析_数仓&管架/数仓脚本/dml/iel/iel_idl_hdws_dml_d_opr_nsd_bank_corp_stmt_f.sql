: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dml_d_opr_nsd_bank_corp_stmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dml_d_opr_nsd_bank_corp_stmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.seq_num as seq_num 
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd 
,replace(replace(t1.bal_status_cd,chr(13),''),chr(10),'') as bal_status_cd 
,replace(replace(t1.final_bal_status_cd,chr(13),''),chr(10),'') as final_bal_status_cd 
,replace(replace(t1.snd_mth_cd,chr(13),''),chr(10),'') as snd_mth_cd 
,replace(replace(t1.cple_acct_freq,chr(13),''),chr(10),'') as cple_acct_freq 
,replace(replace(t1.sign_mrk,chr(13),''),chr(10),'') as sign_mrk 
,replace(replace(t1.check_signt_acct,chr(13),''),chr(10),'') as check_signt_acct 
,replace(replace(t1.acct_typ_cd,chr(13),''),chr(10),'') as acct_typ_cd 
,replace(replace(t1.coa_num,chr(13),''),chr(10),'') as coa_num 
,replace(replace(t1.imp_acct_mrk,chr(13),''),chr(10),'') as imp_acct_mrk 
,replace(replace(t1.open_dt,chr(13),''),chr(10),'') as open_dt 
,replace(replace(t1.dpst_cr_mrk,chr(13),''),chr(10),'') as dpst_cr_mrk 
,replace(replace(t1.prd_num,chr(13),''),chr(10),'') as prd_num 
,replace(replace(t1.descr,chr(13),''),chr(10),'') as descr 
,replace(replace(t1.face_to_face_flg,chr(13),''),chr(10),'') as face_to_face_flg 
,replace(replace(t1.cple_acct_dt,chr(13),''),chr(10),'') as cple_acct_dt 
,replace(replace(t1.sing_acct_num,chr(13),''),chr(10),'') as sing_acct_num 
,replace(replace(t1.ccy_typ,chr(13),''),chr(10),'') as ccy_typ 
,t1.non_arri_mrk as non_arri_mrk 
,replace(replace(t1.bank_num,chr(13),''),chr(10),'') as bank_num 
,replace(replace(t1.super_mgmt_row,chr(13),''),chr(10),'') as super_mgmt_row 
,replace(replace(t1.cple_acct_cent,chr(13),''),chr(10),'') as cple_acct_cent 
,replace(replace(t1.brch_name,chr(13),''),chr(10),'') as brch_name 
,replace(replace(t1.stmt_id,chr(13),''),chr(10),'') as stmt_id 
,replace(replace(t1.acct_num,chr(13),''),chr(10),'') as acct_num 
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num 
,replace(replace(t1.acct_num_name,chr(13),''),chr(10),'') as acct_num_name 
,replace(replace(t1.print_ord_nbr,chr(13),''),chr(10),'') as print_ord_nbr 
,t1.me_bal as me_bal 
,t1.mon_aggr_amt as mon_aggr_amt 
,t1.mon_max_amt as mon_max_amt 
,t1.mavg_bal as mavg_bal 
,replace(replace(t1.hy_rcvry,chr(13),''),chr(10),'') as hy_rcvry 
,replace(replace(t1.cbrc_flg,chr(13),''),chr(10),'') as cbrc_flg 
,replace(replace(t1.reg_loc,chr(13),''),chr(10),'') as reg_loc 
,replace(replace(t1.wthr_cple_acct_succ,chr(13),''),chr(10),'') as wthr_cple_acct_succ 
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd 
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg 
,replace(replace(t1.etl_task_name,chr(13),''),chr(10),'') as etl_task_name 
from ${idl_schema}.hdws_dml_d_opr_nsd_bank_corp_stmt t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dml_d_opr_nsd_bank_corp_stmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes