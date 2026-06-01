: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_cmm_intnal_org_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_cmm_intnal_org_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,lp_id
,org_id
,org_name
,org_abbr
,princ_emply_id
,cbrc_fin_inst_id
,unionpay_fin_inst_id
,fin_inst_idf_code
,bus_lics_num
,fin_lics_num
,pbc_pay_bank_no
,fin_inst_code
,hq_org_id
,hq_org_name
,brch_id
,brch_name
,subrch_id
,subrch_name
,org_type_cd
,org_lev_cd
,org_status_cd
,bus_status_cd
,bus_org_flg
,enty_org_flg
,accti_org_flg
,admin_org_flg
,acct_instit_flg
,vtual_accti_org_flg
,admin_super_org_id
,acct_super_org_id
,accti_super_org_id
,func_org_id
,func_dept_id
,cty_rg_cd
,prov_cd
,city_cd
,county_cd
,phys_addr
,ddd_area_cd
,phone
,zip_cd
,org_found_dt
,org_revo_dt
,org_start_bus_tm
,org_end_bus_tm from ${idl_schema}.crms_cmm_intnal_org_info where etl_dt =to_date('${batch_date}','yyyymmdd'); " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crms_cmm_intnal_org_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes