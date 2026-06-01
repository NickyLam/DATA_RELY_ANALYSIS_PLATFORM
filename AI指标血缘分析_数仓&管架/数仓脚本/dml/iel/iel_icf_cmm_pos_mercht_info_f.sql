: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_pos_mercht_info_f
CreateDate: 20240425
FileName:   ${iel_data_path}/cmm_pos_mercht_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.mercht_order_id,chr(13),''),chr(10),'') as mercht_order_id
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t1.agency_id,chr(13),''),chr(10),'') as agency_id
,replace(replace(t1.mercht_name,chr(13),''),chr(10),'') as mercht_name
,replace(replace(t1.mercht_fname,chr(13),''),chr(10),'') as mercht_fname
,replace(replace(t1.work_addr,chr(13),''),chr(10),'') as work_addr
,replace(replace(t1.open_acct_bank_name,chr(13),''),chr(10),'') as open_acct_bank_name
,replace(replace(t1.open_acct_bank_id,chr(13),''),chr(10),'') as open_acct_bank_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.cotas_type_cd,chr(13),''),chr(10),'') as cotas_type_cd
,replace(replace(t1.cotas_name,chr(13),''),chr(10),'') as cotas_name
,replace(replace(t1.cont_num,chr(13),''),chr(10),'') as cont_num
,replace(replace(t1.cotas_e_mail,chr(13),''),chr(10),'') as cotas_e_mail
,replace(replace(t1.fax_num,chr(13),''),chr(10),'') as fax_num
,replace(replace(t1.oper_co_corp_name,chr(13),''),chr(10),'') as oper_co_corp_name
,replace(replace(t1.agency_abbr,chr(13),''),chr(10),'') as agency_abbr
,replace(replace(t1.agency_belong_brch_id,chr(13),''),chr(10),'') as agency_belong_brch_id
,replace(replace(t1.agency_bus_lics_id,chr(13),''),chr(10),'') as agency_bus_lics_id
,replace(replace(t1.agency_cotas_name,chr(13),''),chr(10),'') as agency_cotas_name
,replace(replace(t1.agency_cotas_addr,chr(13),''),chr(10),'') as agency_cotas_addr
,replace(replace(t1.agency_enter_acct_chn_cd,chr(13),''),chr(10),'') as agency_enter_acct_chn_cd
,replace(replace(t1.agency_status_cd,chr(13),''),chr(10),'') as agency_status_cd
,replace(replace(t1.recv_bill_bank_id,chr(13),''),chr(10),'') as recv_bill_bank_id
,replace(replace(t1.mercht_status_cd,chr(13),''),chr(10),'') as mercht_status_cd
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.cust_mgr_name,chr(13),''),chr(10),'') as cust_mgr_name
,replace(replace(t1.flow_bank_apv_flow_id,chr(13),''),chr(10),'') as flow_bank_apv_flow_id
,replace(replace(t1.flow_bank_apv_rest_cd,chr(13),''),chr(10),'') as flow_bank_apv_rest_cd
,replace(replace(t1.h5_flow_flg,chr(13),''),chr(10),'') as h5_flow_flg
,replace(replace(t1.dic_conc_mercht_flg,chr(13),''),chr(10),'') as dic_conc_mercht_flg
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.mercht_belong_rg_cd,chr(13),''),chr(10),'') as mercht_belong_rg_cd
,replace(replace(t1.mercht_mcc_code,chr(13),''),chr(10),'') as mercht_mcc_code
,replace(replace(t1.mercht_mcc_descb,chr(13),''),chr(10),'') as mercht_mcc_descb
,replace(replace(t1.jh_mercht_flg,chr(13),''),chr(10),'') as jh_mercht_flg
,mercht_start_use_dt
,replace(replace(t1.dic_conc_co_status_cd,chr(13),''),chr(10),'') as dic_conc_co_status_cd

from ${icl_schema}.cmm_pos_mercht_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_pos_mercht_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
