: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_dep_provi_flow_i
CreateDate: 20230512
FileName:   ${iel_data_path}/evt_dep_provi_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.fee_rat_id,chr(13),''),chr(10),'') as fee_rat_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,provi_dt
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.int_cls_cd,chr(13),''),chr(10),'') as int_cls_cd
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,replace(replace(t1.year_int_accr_base_cd,chr(13),''),chr(10),'') as year_int_accr_base_cd
,replace(replace(t1.mon_int_accr_base_cd,chr(13),''),chr(10),'') as mon_int_accr_base_cd
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,provi_accum
,agt_float_ratio
,bank_int_int_rat
,agt_fix_int_rat
,agt_float_point
,int_rat_float_ratio
,sub_acct_fix_int_rat
,sub_acct_int_rat_float_ratio
,sub_acct_int_rat_float_point
,replace(replace(t1.agt_chg_way_cd,chr(13),''),chr(10),'') as agt_chg_way_cd
,exec_int_rat
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
,int_amt
,acm_provi_int
,provi_day_provi_actl_amt
,provi_day_provi_int
,provi_amt_bal
,last_provi_dt
,currt_acm_int_accr_days
,replace(replace(t1.tax_category_cd,chr(13),''),chr(10),'') as tax_category_cd
,provi_tax_rat
,int_tax_acm_amt
,provi_day_int_tax_init_amt
,provi_day_int_tax
,int_tax_bal
,replace(replace(t1.merge_flg,chr(13),''),chr(10),'') as merge_flg
,replace(replace(t1.post_flg,chr(13),''),chr(10),'') as post_flg
,replace(replace(t1.tran_aldy_revd_flg,chr(13),''),chr(10),'') as tran_aldy_revd_flg
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.accti_status_cd,chr(13),''),chr(10),'') as accti_status_cd
,replace(replace(t1.sob_cate_cd,chr(13),''),chr(10),'') as sob_cate_cd
,replace(replace(t1.addit_remark,chr(13),''),chr(10),'') as addit_remark
,replace(replace(t1.tran_intior_type_cd,chr(13),''),chr(10),'') as tran_intior_type_cd
,replace(replace(t1.cntpty_tran_ref_no,chr(13),''),chr(10),'') as cntpty_tran_ref_no
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd
,replace(replace(t1.check_entry_cd,chr(13),''),chr(10),'') as check_entry_cd
,tran_tm
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num

from ${iml_schema}.evt_dep_provi_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_dep_provi_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
