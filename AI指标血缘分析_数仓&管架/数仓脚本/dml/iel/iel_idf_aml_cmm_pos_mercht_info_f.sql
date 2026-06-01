: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_cmm_pos_mercht_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_pos_mercht_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,lp_id
,mercht_order_id
,mercht_id
,agency_id
,mercht_name
,mercht_fname
,work_addr
,open_acct_bank_name
,open_acct_bank_id
,acct_id
,acct_name
,cotas_type_cd
,cotas_name
,cont_num
,cotas_e_mail
,fax_num
,oper_co_corp_name
,agency_abbr
,agency_belong_brch_id
,agency_bus_lics_id
,agency_cotas_name
,agency_cotas_addr
,agency_enter_acct_chn_cd
,agency_status_cd
,recv_bill_bank_id
,mercht_status_cd
,belong_org_id
,cust_mgr_id
,cust_mgr_name
,flow_bank_apv_flow_id
,flow_bank_apv_rest_cd
,h5_flow_flg
,dic_conc_co_status_cd
,dic_conc_mercht_flg as dic_conc_mercht_flg
,jh_mercht_flg as jh_mercht_flg
,mercht_start_use_dt as mercht_start_use_dt
from idl.aml_cmm_pos_mercht_info
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_pos_mercht_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes