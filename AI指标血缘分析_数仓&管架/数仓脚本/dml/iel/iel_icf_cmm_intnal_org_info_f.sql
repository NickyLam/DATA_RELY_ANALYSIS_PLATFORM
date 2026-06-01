: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_intnal_org_info_f
CreateDate: 20260119
FileName:   ${iel_data_path}/cmm_intnal_org_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,replace(replace(t1.org_abbr,chr(13),''),chr(10),'') as org_abbr
,replace(replace(t1.princ_emply_id,chr(13),''),chr(10),'') as princ_emply_id
,replace(replace(t1.cbrc_fin_inst_id,chr(13),''),chr(10),'') as cbrc_fin_inst_id
,replace(replace(t1.unionpay_fin_inst_id,chr(13),''),chr(10),'') as unionpay_fin_inst_id
,replace(replace(t1.fin_inst_idf_code,chr(13),''),chr(10),'') as fin_inst_idf_code
,replace(replace(t1.bus_lics_num,chr(13),''),chr(10),'') as bus_lics_num
,replace(replace(t1.fin_lics_num,chr(13),''),chr(10),'') as fin_lics_num
,replace(replace(t1.pbc_pay_bank_no,chr(13),''),chr(10),'') as pbc_pay_bank_no
,replace(replace(t1.fin_inst_code,chr(13),''),chr(10),'') as fin_inst_code
,replace(replace(t1.hq_org_id,chr(13),''),chr(10),'') as hq_org_id
,replace(replace(t1.hq_org_name,chr(13),''),chr(10),'') as hq_org_name
,replace(replace(t1.brch_id,chr(13),''),chr(10),'') as brch_id
,replace(replace(t1.brch_name,chr(13),''),chr(10),'') as brch_name
,replace(replace(t1.subrch_id,chr(13),''),chr(10),'') as subrch_id
,replace(replace(t1.subrch_name,chr(13),''),chr(10),'') as subrch_name
,replace(replace(t1.org_type_cd,chr(13),''),chr(10),'') as org_type_cd
,replace(replace(t1.org_lev_cd,chr(13),''),chr(10),'') as org_lev_cd
,replace(replace(t1.org_status_cd,chr(13),''),chr(10),'') as org_status_cd
,replace(replace(t1.bus_status_cd,chr(13),''),chr(10),'') as bus_status_cd
,replace(replace(t1.bus_org_flg,chr(13),''),chr(10),'') as bus_org_flg
,replace(replace(t1.enty_org_flg,chr(13),''),chr(10),'') as enty_org_flg
,replace(replace(t1.accti_org_flg,chr(13),''),chr(10),'') as accti_org_flg
,replace(replace(t1.admin_org_flg,chr(13),''),chr(10),'') as admin_org_flg
,replace(replace(t1.acct_instit_flg,chr(13),''),chr(10),'') as acct_instit_flg
,replace(replace(t1.vtual_accti_org_flg,chr(13),''),chr(10),'') as vtual_accti_org_flg
,replace(replace(t1.admin_super_org_id,chr(13),''),chr(10),'') as admin_super_org_id
,replace(replace(t1.acct_super_org_id,chr(13),''),chr(10),'') as acct_super_org_id
,replace(replace(t1.accti_super_org_id,chr(13),''),chr(10),'') as accti_super_org_id
,replace(replace(t1.func_org_id,chr(13),''),chr(10),'') as func_org_id
,replace(replace(t1.func_dept_id,chr(13),''),chr(10),'') as func_dept_id
,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd
,replace(replace(t1.prov_cd,chr(13),''),chr(10),'') as prov_cd
,replace(replace(t1.city_cd,chr(13),''),chr(10),'') as city_cd
,replace(replace(t1.county_cd,chr(13),''),chr(10),'') as county_cd
,replace(replace(t1.phys_addr,chr(13),''),chr(10),'') as phys_addr
,replace(replace(t1.ddd_area_cd,chr(13),''),chr(10),'') as ddd_area_cd
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.zip_cd,chr(13),''),chr(10),'') as zip_cd
,org_found_dt
,org_revo_dt
,replace(replace(t1.org_start_bus_tm,chr(13),''),chr(10),'') as org_start_bus_tm
,replace(replace(t1.org_end_bus_tm,chr(13),''),chr(10),'') as org_end_bus_tm
,replace(replace(t1.org_hibchy_cd,chr(13),''),chr(10),'') as org_hibchy_cd
,replace(replace(t1.org_en_name,chr(13),''),chr(10),'') as org_en_name
,replace(replace(t1.org_en_abbr,chr(13),''),chr(10),'') as org_en_abbr
,replace(replace(t1.tax_regi_cert_num,chr(13),''),chr(10),'') as tax_regi_cert_num
,replace(replace(t1.pay_sys_bank_no,chr(13),''),chr(10),'') as pay_sys_bank_no
,replace(replace(t1.orgnz_cd,chr(13),''),chr(10),'') as orgnz_cd
,replace(replace(t1.dtl_org_flg,chr(13),''),chr(10),'') as dtl_org_flg
,replace(replace(t1.swiftcode,chr(13),''),chr(10),'') as swiftcode
,replace(replace(t1.idd_area_cd,chr(13),''),chr(10),'') as idd_area_cd
,replace(replace(t1.ext_num,chr(13),''),chr(10),'') as ext_num
,replace(replace(t1.serv_tel,chr(13),''),chr(10),'') as serv_tel
,replace(replace(t1.e_mail,chr(13),''),chr(10),'') as e_mail
,replace(replace(t1.url,chr(13),''),chr(10),'') as url
,replace(replace(t1.pbc_belong_city_cd,chr(13),''),chr(10),'') as pbc_belong_city_cd
,replace(replace(t1.pbc_belong_city,chr(13),''),chr(10),'') as pbc_belong_city
,replace(replace(t1.rept_super_org_id,chr(13),''),chr(10),'') as rept_super_org_id
,replace(replace(t1.free_trade_rg_flg,chr(13),''),chr(10),'') as free_trade_rg_flg
,replace(replace(t1.retl_execu_org_flg,chr(13),''),chr(10),'') as retl_execu_org_flg

from ${icl_schema}.cmm_intnal_org_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_intnal_org_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
