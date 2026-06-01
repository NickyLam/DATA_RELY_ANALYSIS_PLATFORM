: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_nostro_acct_info_f
CreateDate: 20260126
FileName:   ${iel_data_path}/cmm_nostro_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
,replace(replace(t1.cust_sub_acct_id,chr(13),''),chr(10),'') as cust_sub_acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,open_dt
,replace(replace(t1.open_flow_num,chr(13),''),chr(10),'') as open_flow_num
,clos_acct_dt
,replace(replace(t1.clos_acct_flow_num,chr(13),''),chr(10),'') as clos_acct_flow_num
,replace(replace(t1.acct_cls_cd,chr(13),''),chr(10),'') as acct_cls_cd
,replace(replace(t1.acct_char_cd,chr(13),''),chr(10),'') as acct_char_cd
,replace(replace(t1.obank_open_org_dist,chr(13),''),chr(10),'') as obank_open_org_dist
,replace(replace(t1.obank_nation,chr(13),''),chr(10),'') as obank_nation
,replace(replace(t1.obank_cntpty_cls,chr(13),''),chr(10),'') as obank_cntpty_cls
,replace(replace(t1.obank_open_org_lp_name,chr(13),''),chr(10),'') as obank_open_org_lp_name
,replace(replace(t1.obank_open_org_id,chr(13),''),chr(10),'') as obank_open_org_id
,replace(replace(t1.obank_bank_no,chr(13),''),chr(10),'') as obank_bank_no
,replace(replace(t1.obank_swift_id,chr(13),''),chr(10),'') as obank_swift_id
,replace(replace(t1.obank_acct_id,chr(13),''),chr(10),'') as obank_acct_id
,replace(replace(t1.obank_acct_name,chr(13),''),chr(10),'') as obank_acct_name
,obank_curr_bal
,obank_open_dt
,obank_clos_acct_dt
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.use_range_cd,chr(13),''),chr(10),'') as use_range_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,base_rat
,replace(replace(t1.int_rat_float_way_cd,chr(13),''),chr(10),'') as int_rat_float_way_cd
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,int_rat_flo_val
,exec_int_rat
,currt_acru_int
,td_acru_int
,currt_bal
,cl_curr_currt_bal
,exp_dt
,replace(replace(t1.ibank_obj_id,chr(13),''),chr(10),'') as ibank_obj_id
,replace(replace(t1.int_recvbl_subj_id,chr(13),''),chr(10),'') as int_recvbl_subj_id
,replace(replace(t1.open_bank_name,chr(13),''),chr(10),'') as open_bank_name
,replace(replace(t1.open_bank_lp_org_cust_id,chr(13),''),chr(10),'') as open_bank_lp_org_cust_id
,replace(replace(t1.open_bank_lp_name,chr(13),''),chr(10),'') as open_bank_lp_name
,replace(replace(t1.acct_char_descb,chr(13),''),chr(10),'') as acct_char_descb
,replace(replace(t1.acct_attr_descb,chr(13),''),chr(10),'') as acct_attr_descb
,int_start_dt
,int_end_dt
,replace(replace(t1.pay_int_freq,chr(13),''),chr(10),'') as pay_int_freq
,int_recvbl
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.cap_char_cd,chr(13),''),chr(10),'') as cap_char_cd
,td_int_income
,replace(replace(t1.asset_uniq_idf_id,chr(13),''),chr(10),'') as asset_uniq_idf_id
,replace(replace(t1.onl_bus_flg,chr(13),''),chr(10),'') as onl_bus_flg
,replace(replace(t1.acct_usage_cd,chr(13),''),chr(10),'') as acct_usage_cd
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id

from ${icl_schema}.cmm_nostro_acct_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_nostro_acct_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
