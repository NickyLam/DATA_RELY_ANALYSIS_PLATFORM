: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_cmm_bond_basic_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_cmm_bond_basic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,lp_id
,bond_id
,bond_name
,bond_abbr
,bond_type_cd
,issuer_name
,curr_cd
,issue_corp
,issue_price
,issue_int_rat
,issue_size
,fac_val_int_rat
,int_rat_adj_way_cd
,base_rat_id
,int_rat_float_point
,int_rat_float_dir_cd
,int_rat_float_uplmi
,int_rat_float_lolmi
,int_accr_base_cd
,int_accr_curr_cd
,int_accr_ped_cd
,pay_int_ped_cd
,comp_int_ped_cd
,reval_ped_cd
,fir_reval_dt
,reval_way_cd
,last_reval_dt
,next_reval_dt
,reval_start_dt
,reval_end_dt
,reval_int_rat
,exp_yld_rat
,issue_dt
,value_dt
,exp_dt
,list_dt
,fir_pay_int_dt
,last_pay_int_dt
,next_pay_int_dt
,next_rpp_amt
,next_pay_int_amt
,stop_circlt_dt
,tranbl_bond_flg
,discnt_debt_vch_flg
,acru_int_flg
,ex_choice_type_cd
,bond_market_type_cd
,guar_type_cd
,guartor_name
,inpwned_ratio
,asset_type_id
,bond_cls_name
,issuer_cd
,fac_val
,tenor
,caption_type_cd
,valuation_way_cd
,data_src_sys_idf
,trust_org_id
,mgmt_mode_cd
,issuer_cust_id
,issue_main_belong_cty_rg_cd
,issue_rg_cd
,actl_mang_land_nation_cd
,src_pay_int_ped_cd
,subtn_bond_flg
from idl.icrm_cmm_bond_basic_info
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_cmm_bond_basic_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes