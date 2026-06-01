: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_dep_acct_int_rat_seg_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_dep_acct_int_rat_seg_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.int_cls_cd,chr(13),''),chr(10),'') as int_cls_cd
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,bus_start_dt
,bus_end_dt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.int_rat_seg_flg,chr(13),''),chr(10),'') as int_rat_seg_flg
,sub_acct_fix_int_rat
,sub_acct_int_rat_float_ratio
,sub_acct_int_rat_float_point
,int_accr_begin_dt
,provi_begin_dt
,provi_end_dt
,last_provi_dt
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,agt_prefr_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,int_amt
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,bank_int_int_rat
,term_end_acm_provi_amt
,term_end_acm_provi_bal
,term_end_acm_adj_amt
,term_end_acm_int_tax
,replace(replace(t1.agt_chg_way_cd,chr(13),''),chr(10),'') as agt_chg_way_cd
,agt_fix_int_rat
,agt_float_point
,agt_float_ratio
,replace(replace(t1.tax_category_cd,chr(13),''),chr(10),'') as tax_category_cd
,float_int_rat
,bank_int_exec_int_rat
,tax_rat
,replace(replace(t1.mon_int_accr_base_cd,chr(13),''),chr(10),'') as mon_int_accr_base_cd
,replace(replace(t1.year_int_accr_base_cd,chr(13),''),chr(10),'') as year_int_accr_base_cd
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,currt_acm_provi_amt
,currt_acm_adj_amt
,currt_acm_int_accr_days
,currt_acm_int_tax
,tm_bg_acm_provi_amt
,tm_bg_acm_provi_bal
,tm_bg_acm_adj_amt
,tm_bg_acm_int_tax

from ${iml_schema}.agt_dep_acct_int_rat_seg_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dep_acct_int_rat_seg_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
