: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_org_organization_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_org_organization_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.org_cn_full_name,chr(13),''),chr(10),'') as org_cn_full_name
,replace(replace(t1.org_cn_short_name,chr(13),''),chr(10),'') as org_cn_short_name
,replace(replace(t1.org_en_full_name,chr(13),''),chr(10),'') as org_en_full_name
,replace(replace(t1.org_en_short_name,chr(13),''),chr(10),'') as org_en_short_name
,replace(replace(t1.org_lvl_cd,chr(13),''),chr(10),'') as org_lvl_cd
,replace(replace(t1.mgmt_super_org_id,chr(13),''),chr(10),'') as mgmt_super_org_id
,replace(replace(t1.stl_super_org_id,chr(13),''),chr(10),'') as stl_super_org_id
,replace(replace(t1.virtual_org_flg,chr(13),''),chr(10),'') as virtual_org_flg
,replace(replace(t1.org_typ_cd,chr(13),''),chr(10),'') as org_typ_cd
,replace(replace(t1.small_subbranch_flg,chr(13),''),chr(10),'') as small_subbranch_flg
,replace(replace(t1.org_status_cd,chr(13),''),chr(10),'') as org_status_cd
,t1.org_estab_dt as org_estab_dt
,t1.org_close_dt as org_close_dt
,t1.org_person_qty as org_person_qty
,replace(replace(t1.ln_flg,chr(13),''),chr(10),'') as ln_flg
,replace(replace(t1.zipcode,chr(13),''),chr(10),'') as zipcode
,replace(replace(t1.cty_cd,chr(13),''),chr(10),'') as cty_cd
,replace(replace(t1.blng_provin_cd,chr(13),''),chr(10),'') as blng_provin_cd
,replace(replace(t1.blng_city_cd,chr(13),''),chr(10),'') as blng_city_cd
,replace(replace(t1.blng_county_cd,chr(13),''),chr(10),'') as blng_county_cd
,replace(replace(t1.physical_address,chr(13),''),chr(10),'') as physical_address
,replace(replace(t1.lnkm_emply_id,chr(13),''),chr(10),'') as lnkm_emply_id
,replace(replace(t1.head_emply_id,chr(13),''),chr(10),'') as head_emply_id
,replace(replace(t1.e_mail,chr(13),''),chr(10),'') as e_mail
,replace(replace(t1.web_addr,chr(13),''),chr(10),'') as web_addr
,replace(replace(t1.tel_cnr_cod,chr(13),''),chr(10),'') as tel_cnr_cod
,replace(replace(t1.tel_area_cod,chr(13),''),chr(10),'') as tel_area_cod
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t1.ext,chr(13),''),chr(10),'') as ext
,replace(replace(t1.srv_tel,chr(13),''),chr(10),'') as srv_tel
,replace(replace(t1.fin_lice_num,chr(13),''),chr(10),'') as fin_lice_num
,replace(replace(t1.fin_org_ind_num,chr(13),''),chr(10),'') as fin_org_ind_num
,replace(replace(t1.pbc_fin_org_id,chr(13),''),chr(10),'') as pbc_fin_org_id
,replace(replace(t1.cbrc_fin_instt_id,chr(13),''),chr(10),'') as cbrc_fin_instt_id
,replace(replace(t1.swift_num,chr(13),''),chr(10),'') as swift_num
,replace(replace(t1.pay_sys_bank_num,chr(13),''),chr(10),'') as pay_sys_bank_num
,replace(replace(t1.oper_licence_num,chr(13),''),chr(10),'') as oper_licence_num
,t1.oper_licence_reg_dt as oper_licence_reg_dt
,t1.oper_licence_due_dt as oper_licence_due_dt
,replace(replace(t1.org_cd,chr(13),''),chr(10),'') as org_cd
,replace(replace(t1.tax_reg_cert_num,chr(13),''),chr(10),'') as tax_reg_cert_num
,replace(replace(t1.stl_org_flg,chr(13),''),chr(10),'') as stl_org_flg
,replace(replace(t1.biz_org_flg,chr(13),''),chr(10),'') as biz_org_flg
,replace(replace(t1.admn_org_flg,chr(13),''),chr(10),'') as admn_org_flg
,replace(replace(t1.acct_org_flg,chr(13),''),chr(10),'') as acct_org_flg
,replace(replace(t1.work_start_tm,chr(13),''),chr(10),'') as work_start_tm
,replace(replace(t1.work_end_tm,chr(13),''),chr(10),'') as work_end_tm
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'ORG_ORGANIZATION_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'ORG_ORGANIZATION_H') as etl_task_name 
,replace(replace(t1.city_cd_pbc,chr(13),''),chr(10),'') as city_cd_pbc
,replace(replace(t1.blng_city_pbc,chr(13),''),chr(10),'') as blng_city_pbc
from ${idl_schema}.hdws_iml_org_organization_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_org_organization_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes