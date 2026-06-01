: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_loan_provi_flow_i
CreateDate: 20221109
FileName:   ${iel_data_path}/evt_loan_provi_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.provi_flow_num,chr(13),''),chr(10),'') as provi_flow_num
,provi_dt
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.int_cls_cd,chr(13),''),chr(10),'') as int_cls_cd
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,acm_provi_amt
,td_provi_int
,td_provi_actl_amt
,provi_amt_bal
,int_tax_acm_amt
,td_int_tax
,td_int_tax_init_amt
,int_tax_bal
,replace(replace(t1.tax_category_cd,chr(13),''),chr(10),'') as tax_category_cd
,provi_tax_rat
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.tran_intior_type_cd,chr(13),''),chr(10),'') as tran_intior_type_cd
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd
,replace(replace(t1.sob_cate_cd,chr(13),''),chr(10),'') as sob_cate_cd
,provi_accum
,int_amt
,replace(replace(t1.mon_int_accr_base_cd,chr(13),''),chr(10),'') as mon_int_accr_base_cd
,replace(replace(t1.year_int_accr_base_cd,chr(13),''),chr(10),'') as year_int_accr_base_cd
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.revs_flg,chr(13),''),chr(10),'') as revs_flg
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
,replace(replace(t1.post_flg,chr(13),''),chr(10),'') as post_flg
,replace(replace(t1.cntpty_tran_ref_no,chr(13),''),chr(10),'') as cntpty_tran_ref_no
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,bank_int_int_rat
,float_int_rat
,exec_int_rat
,sub_acct_int_rat_float_point
,sub_acct_int_rat_float_ratio
,sub_acct_fix_int_rat
,replace(replace(t1.agt_chg_way_cd,chr(13),''),chr(10),'') as agt_chg_way_cd
,agt_fix_int_rat
,agt_float_ratio
,agt_float_point
,replace(replace(t1.merge_flg,chr(13),''),chr(10),'') as merge_flg
,tran_tm

from ${iml_schema}.evt_loan_provi_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_loan_provi_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
