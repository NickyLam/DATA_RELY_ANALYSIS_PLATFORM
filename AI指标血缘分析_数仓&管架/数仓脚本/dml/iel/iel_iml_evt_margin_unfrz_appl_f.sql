: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_margin_unfrz_appl_f
CreateDate: 20240702
FileName:   ${iel_data_path}/evt_margin_unfrz_appl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.margin_acct_id,chr(13),''),chr(10),'') as margin_acct_id
,replace(replace(t1.margin_acct_attr_cd,chr(13),''),chr(10),'') as margin_acct_attr_cd
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,margin_acct_bal
,agt_rat
,dep_base_rat
,replace(replace(t1.dep_term,chr(13),''),chr(10),'') as dep_term
,replace(replace(t1.tran_out_prod_id,chr(13),''),chr(10),'') as tran_out_prod_id
,replace(replace(t1.tran_in_init_acct_flg,chr(13),''),chr(10),'') as tran_in_init_acct_flg
,replace(replace(t1.margin_tran_in_acct_id,chr(13),''),chr(10),'') as margin_tran_in_acct_id
,replace(replace(t1.margin_type_cd,chr(13),''),chr(10),'') as margin_type_cd
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,bill_exp_dt
,replace(replace(t1.margin_int_rat_level_cd,chr(13),''),chr(10),'') as margin_int_rat_level_cd
,margin_exec_int_rat
,replace(replace(t1.margin_int_rat_type_cd,chr(13),''),chr(10),'') as margin_int_rat_type_cd
,replace(replace(t1.int_rat_float_way_cd,chr(13),''),chr(10),'') as int_rat_float_way_cd
,replace(replace(t1.int_rat_float_type_cd,chr(13),''),chr(10),'') as int_rat_float_type_cd
,flo_val
,aldy_pay_margin_amt
,replace(replace(t1.sub_acct_num_froz_flow_num,chr(13),''),chr(10),'') as sub_acct_num_froz_flow_num
,replace(replace(t1.out_acct_flow_num,chr(13),''),chr(10),'') as out_acct_flow_num
,replace(replace(t1.froz_stop_pay_way_cd,chr(13),''),chr(10),'') as froz_stop_pay_way_cd
,replace(replace(t1.froz_stop_pay_type_cd,chr(13),''),chr(10),'') as froz_stop_pay_type_cd
,replace(replace(t1.froz_stop_pay_rs,chr(13),''),chr(10),'') as froz_stop_pay_rs
,replace(replace(t1.off_bs_acct_id,chr(13),''),chr(10),'') as off_bs_acct_id
,replace(replace(t1.off_bs_acct_name,chr(13),''),chr(10),'') as off_bs_acct_name
,replace(replace(t1.off_bs_entry_dir_cd,chr(13),''),chr(10),'') as off_bs_entry_dir_cd
,replace(replace(t1.off_bs_memo,chr(13),''),chr(10),'') as off_bs_memo
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
,replace(replace(t1.init_agt_type_cd,chr(13),''),chr(10),'') as init_agt_type_cd
,replace(replace(t1.init_agt_id,chr(13),''),chr(10),'') as init_agt_id
,replace(replace(t1.cont_flow_num,chr(13),''),chr(10),'') as cont_flow_num
,bus_begin_dt
,bus_exp_dt
,bus_amt
,bus_bal
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,tran_dt
,tran_amt
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.flow_status_cd,chr(13),''),chr(10),'') as flow_status_cd
,replace(replace(t1.create_src_cd,chr(13),''),chr(10),'') as create_src_cd
,replace(replace(t1.curr_brwer_flg,chr(13),''),chr(10),'') as curr_brwer_flg
,replace(replace(t1.rels_open_flg,chr(13),''),chr(10),'') as rels_open_flg
,replace(replace(t1.aldy_revo_flg,chr(13),''),chr(10),'') as aldy_revo_flg
,replace(replace(t1.batch_flow_num,chr(13),''),chr(10),'') as batch_flow_num
,replace(replace(t1.init_tran_flow_num,chr(13),''),chr(10),'') as init_tran_flow_num
,init_tran_dt
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,final_update_dt
,replace(replace(t1.supp_comnt,chr(13),''),chr(10),'') as supp_comnt

from ${iml_schema}.evt_margin_unfrz_appl t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_margin_unfrz_appl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
