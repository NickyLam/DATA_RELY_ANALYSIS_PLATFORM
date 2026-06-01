: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_loan_apv_basic_info_h_f
CreateDate: 20221109
FileName:   ${iel_data_path}/agt_loan_apv_basic_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.apv_flow_num,chr(13),''),chr(10),'') as apv_flow_num
,replace(replace(t1.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.appl_way_cd,chr(13),''),chr(10),'') as appl_way_cd
,replace(replace(t1.lmt_cont_flg,chr(13),''),chr(10),'') as lmt_cont_flg
,replace(replace(t1.loan_distr_type_cd,chr(13),''),chr(10),'') as loan_distr_type_cd
,happ_dt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,apv_amt
,replace(replace(t1.base_prod_id,chr(13),''),chr(10),'') as base_prod_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,mon_tenor
,day_tenor
,begin_dt
,exp_dt
,replace(replace(t1.remote_bus_flg,chr(13),''),chr(10),'') as remote_bus_flg
,replace(replace(t1.lmt_circl_flg,chr(13),''),chr(10),'') as lmt_circl_flg
,replace(replace(t1.risk_type_cd,chr(13),''),chr(10),'') as risk_type_cd
,replace(replace(t1.low_risk_bus_flg,chr(13),''),chr(10),'') as low_risk_bus_flg
,replace(replace(t1.crdt_dir_cd,chr(13),''),chr(10),'') as crdt_dir_cd
,replace(replace(t1.nat_std_indus_dir_cd,chr(13),''),chr(10),'') as nat_std_indus_dir_cd
,replace(replace(t1.bank_int_indus_dir_cd,chr(13),''),chr(10),'') as bank_int_indus_dir_cd
,replace(replace(t1.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd
,replace(replace(t1.usage_descb,chr(13),''),chr(10),'') as usage_descb
,replace(replace(t1.int_rat_mode_cd,chr(13),''),chr(10),'') as int_rat_mode_cd
,fix_int_rat
,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd
,base_rat
,replace(replace(t1.int_rat_float_type_cd,chr(13),''),chr(10),'') as int_rat_float_type_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,int_rat_flo_val
,exec_int_rat
,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd
,replace(replace(t1.guar_way_cd_two,chr(13),''),chr(10),'') as guar_way_cd_two
,replace(replace(t1.guar_way_cd_three,chr(13),''),chr(10),'') as guar_way_cd_three
,replace(replace(t1.other_guar_way_cd,chr(13),''),chr(10),'') as other_guar_way_cd
,replace(replace(t1.supp_guar_way_flg,chr(13),''),chr(10),'') as supp_guar_way_flg
,replace(replace(t1.other_cond_descb,chr(13),''),chr(10),'') as other_cond_descb
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
,replace(replace(t1.repay_ped,chr(13),''),chr(10),'') as repay_ped
,replace(replace(t1.repay_ped_cd,chr(13),''),chr(10),'') as repay_ped_cd
,replace(replace(t1.deflt_repay_day,chr(13),''),chr(10),'') as deflt_repay_day
,rsrv_amt
,replace(replace(t1.rela_old_cont_id,chr(13),''),chr(10),'') as rela_old_cont_id
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id
,replace(replace(t1.create_cont_flg,chr(13),''),chr(10),'') as create_cont_flg
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,replace(replace(t1.reply_type_cd,chr(13),''),chr(10),'') as reply_type_cd
,replace(replace(t1.final_apv_opinion_descb,chr(13),''),chr(10),'') as final_apv_opinion_descb
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
,oper_dt
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,modif_dt
,replace(replace(t1.belong_strip_line_cd,chr(13),''),chr(10),'') as belong_strip_line_cd
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.spec_ped_corp_cd,chr(13),''),chr(10),'') as spec_ped_corp_cd
,replace(replace(t1.spec_ped_cd,chr(13),''),chr(10),'') as spec_ped_cd
,b_renew_exp_dt
,b_renew_amt
,b_renew_exec_year_int_rat
,replace(replace(t1.crdt_org_way_cd,chr(13),''),chr(10),'') as crdt_org_way_cd
,lmt_open_amt
,file_dt
,replace(replace(t1.level11_cls_cd,chr(13),''),chr(10),'') as level11_cls_cd
,replace(replace(t1.attach_rgst_flg,chr(13),''),chr(10),'') as attach_rgst_flg
,replace(replace(t1.effect_flg,chr(13),''),chr(10),'') as effect_flg
,replace(replace(t1.margin_acct_id,chr(13),''),chr(10),'') as margin_acct_id
,replace(replace(t1.margin_tran_out_acct_id,chr(13),''),chr(10),'') as margin_tran_out_acct_id
,replace(replace(t1.margin_curr_cd,chr(13),''),chr(10),'') as margin_curr_cd
,margin_ratio
,margin_amt
,replace(replace(t1.int_rat_adj_ped_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_cd
,ovdue_exec_int_rat
,replace(replace(t1.ovdue_int_rat_float_way_cd,chr(13),''),chr(10),'') as ovdue_int_rat_float_way_cd
,ovdue_int_rat_flo_val
,replace(replace(t1.stl_acct_name,chr(13),''),chr(10),'') as stl_acct_name
,replace(replace(t1.enter_id,chr(13),''),chr(10),'') as enter_id
,replace(replace(t1.stl_acct_id,chr(13),''),chr(10),'') as stl_acct_id
,replace(replace(t1.move_remark,chr(13),''),chr(10),'') as move_remark
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.agt_loan_apv_basic_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_apv_basic_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
