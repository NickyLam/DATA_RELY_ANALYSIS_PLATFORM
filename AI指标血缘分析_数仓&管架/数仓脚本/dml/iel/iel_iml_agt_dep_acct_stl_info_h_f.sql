: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_dep_acct_stl_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_dep_acct_stl_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.stl_id,chr(13),''),chr(10),'') as stl_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id
,replace(replace(t1.evt_cate_id,chr(13),''),chr(10),'') as evt_cate_id
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.stl_acct_cls_cd,chr(13),''),chr(10),'') as stl_acct_cls_cd
,replace(replace(t1.stl_method_cd,chr(13),''),chr(10),'') as stl_method_cd
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t1.acpt_pay_idf_cd,chr(13),''),chr(10),'') as acpt_pay_idf_cd
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd
,replace(replace(t1.stl_cust_id,chr(13),''),chr(10),'') as stl_cust_id
,replace(replace(t1.out_line_flg,chr(13),''),chr(10),'') as out_line_flg
,replace(replace(t1.hxb_stl_flg,chr(13),''),chr(10),'') as hxb_stl_flg
,replace(replace(t1.recv_bank_no,chr(13),''),chr(10),'') as recv_bank_no
,replace(replace(t1.recv_bank_name,chr(13),''),chr(10),'') as recv_bank_name
,replace(replace(t1.stl_bk_bank_no,chr(13),''),chr(10),'') as stl_bk_bank_no
,replace(replace(t1.stl_acct_id,chr(13),''),chr(10),'') as stl_acct_id
,replace(replace(t1.stl_cust_acct_num,chr(13),''),chr(10),'') as stl_cust_acct_num
,replace(replace(t1.stl_acct_prod_id,chr(13),''),chr(10),'') as stl_acct_prod_id
,replace(replace(t1.stl_acct_curr_cd,chr(13),''),chr(10),'') as stl_acct_curr_cd
,replace(replace(t1.stl_acct_sub_acct_num,chr(13),''),chr(10),'') as stl_acct_sub_acct_num
,replace(replace(t1.stl_acct_name,chr(13),''),chr(10),'') as stl_acct_name
,replace(replace(t1.stl_acct_bind_mobile_no,chr(13),''),chr(10),'') as stl_acct_bind_mobile_no
,replace(replace(t1.stl_org_id,chr(13),''),chr(10),'') as stl_org_id
,replace(replace(t1.auto_lock_flg,chr(13),''),chr(10),'') as auto_lock_flg
,replace(replace(t1.entr_pay_id,chr(13),''),chr(10),'') as entr_pay_id
,t1.stl_wt as stl_wt
,replace(replace(t1.stl_curr_cd,chr(13),''),chr(10),'') as stl_curr_cd
,t1.stl_amt as stl_amt
,t1.stl_exch_rat as stl_exch_rat
,replace(replace(t1.entred_ps_acct_froz_way_cd,chr(13),''),chr(10),'') as entred_ps_acct_froz_way_cd
,replace(replace(t1.sel_sup_flg,chr(13),''),chr(10),'') as sel_sup_flg
,replace(replace(t1.prior_level,chr(13),''),chr(10),'') as prior_level
,t1.prft_cut_ratio as prft_cut_ratio
,replace(replace(t1.exch_way_cd,chr(13),''),chr(10),'') as exch_way_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,t1.final_modif_dt as final_modif_dt
,replace(replace(t1.final_modif_teller_id,chr(13),''),chr(10),'') as final_modif_teller_id
,t1.tran_tm as tran_tm
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.open_acct_bank_fin_inst_id,chr(13),''),chr(10),'') as open_acct_bank_fin_inst_id
from ${iml_schema}.agt_dep_acct_stl_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dep_acct_stl_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes