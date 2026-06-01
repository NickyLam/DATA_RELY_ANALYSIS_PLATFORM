: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_int_set_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_int_set_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,int_set_dt
,replace(replace(t1.int_cls_cd,chr(13),''),chr(10),'') as int_cls_cd
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,int_set_amt
,int_set_day_int_amt
,acm_int_adj_amt
,acm_provi_int
,int_set_day_int_tax
,int_tax_acm_amt
,replace(replace(t1.tran_intior_type_cd,chr(13),''),chr(10),'') as tran_intior_type_cd
,replace(replace(t1.tax_category_cd,chr(13),''),chr(10),'') as tax_category_cd
,tax_rat
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,bank_int_int_rat
,float_int_rat
,exec_int_rat
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd
,replace(replace(t1.sob_type_cd,chr(13),''),chr(10),'') as sob_type_cd
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.revs_flg,chr(13),''),chr(10),'') as revs_flg
,replace(replace(t1.accti_status_cd,chr(13),''),chr(10),'') as accti_status_cd
,replace(replace(t1.post_flg,chr(13),''),chr(10),'') as post_flg
,replace(replace(t1.bus_proc_status_cd,chr(13),''),chr(10),'') as bus_proc_status_cd
,sub_acct_int_rat_float_point
,sub_acct_int_rat_float_ratio
,sub_acct_fix_int_rat
,replace(replace(t1.agt_chg_way_cd,chr(13),''),chr(10),'') as agt_chg_way_cd
,agt_fix_int_rat
,agt_float_ratio
,agt_float_point
,replace(replace(t1.year_int_accr_base_cd,chr(13),''),chr(10),'') as year_int_accr_base_cd
,value_dt
,int_amt

from ${iml_schema}.agt_loan_int_set_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_int_set_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
