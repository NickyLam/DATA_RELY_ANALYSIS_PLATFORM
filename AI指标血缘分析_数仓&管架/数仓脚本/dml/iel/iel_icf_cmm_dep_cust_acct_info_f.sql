: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_dep_cust_acct_info_f
CreateDate: 20241031
FileName:   ${iel_data_path}/cmm_dep_cust_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
,replace(replace(t1.cust_acct_name,chr(13),''),chr(10),'') as cust_acct_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.max_sub_acct_num,chr(13),''),chr(10),'') as max_sub_acct_num
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.drawdown_way_cd,chr(13),''),chr(10),'') as drawdown_way_cd
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.acct_drawdown_way_status,chr(13),''),chr(10),'') as acct_drawdown_way_status
,replace(replace(t1.froz_status_cd,chr(13),''),chr(10),'') as froz_status_cd
,replace(replace(t1.stop_pay_status_cd,chr(13),''),chr(10),'') as stop_pay_status_cd
,replace(replace(t1.acpt_pay_status_cd,chr(13),''),chr(10),'') as acpt_pay_status_cd
,replace(replace(t1.acct_usage_cd,chr(13),''),chr(10),'') as acct_usage_cd
,replace(replace(t1.vouch_kind_cd,chr(13),''),chr(10),'') as vouch_kind_cd
,replace(replace(t1.vouch_char_cd,chr(13),''),chr(10),'') as vouch_char_cd
,replace(replace(t1.vouch_form_cd,chr(13),''),chr(10),'') as vouch_form_cd
,replace(replace(t1.sleep_acct_flg,chr(13),''),chr(10),'') as sleep_acct_flg
,replace(replace(t1.dormt_acct_flg,chr(13),''),chr(10),'') as dormt_acct_flg
,replace(replace(t1.privavy_acct_flg,chr(13),''),chr(10),'') as privavy_acct_flg
,replace(replace(t1.acct_belong_org_id,chr(13),''),chr(10),'') as acct_belong_org_id
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id
,replace(replace(t1.open_acct_chn_cd,chr(13),''),chr(10),'') as open_acct_chn_cd
,replace(replace(t1.open_acct_flow_num,chr(13),''),chr(10),'') as open_acct_flow_num
,open_acct_dt
,open_acct_tm
,replace(replace(t1.close_acct_org_id,chr(13),''),chr(10),'') as close_acct_org_id
,replace(replace(t1.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id
,replace(replace(t1.clos_acct_flow_num,chr(13),''),chr(10),'') as clos_acct_flow_num
,clos_acct_dt
,clos_acct_tm
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.e_acct_type_cd,chr(13),''),chr(10),'') as e_acct_type_cd
,replace(replace(t1.e_acct_status_cd,chr(13),''),chr(10),'') as e_acct_status_cd
,replace(replace(t1.netw_vrfction_rest_cd,chr(13),''),chr(10),'') as netw_vrfction_rest_cd
,replace(replace(t1.vrif_status_cd,chr(13),''),chr(10),'') as vrif_status_cd
,replace(replace(t1.unvrif_rs_descb,chr(13),''),chr(10),'') as unvrif_rs_descb
,replace(replace(t1.disp_method_descb,chr(13),''),chr(10),'') as disp_method_descb
,replace(replace(t1.tran_chn_status_cd,chr(13),''),chr(10),'') as tran_chn_status_cd
,replace(replace(t1.corp_acct_flg,chr(13),''),chr(10),'') as corp_acct_flg
,replace(replace(t1.bind_acct_flg,chr(13),''),chr(10),'') as bind_acct_flg
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd
,replace(replace(t1.fiscal_dep_flg,chr(13),''),chr(10),'') as fiscal_dep_flg
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.cust_acct_card_no,chr(13),''),chr(10),'') as cust_acct_card_no
,replace(replace(t1.acct_attr_cd,chr(13),''),chr(10),'') as acct_attr_cd
,replace(replace(t1.reg_acct_type_cd,chr(13),''),chr(10),'') as reg_acct_type_cd
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.general_exch_flg,chr(13),''),chr(10),'') as general_exch_flg
,replace(replace(t1.general_exch_org_id,chr(13),''),chr(10),'') as general_exch_org_id
,replace(replace(t1.travel_card_acct_flg,chr(13),''),chr(10),'') as travel_card_acct_flg

from ${icl_schema}.cmm_dep_cust_acct_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_dep_cust_acct_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
