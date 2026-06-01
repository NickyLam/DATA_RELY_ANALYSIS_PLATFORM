: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_opr_org_organization_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_opr_org_organization_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
org_id
,etl_dt
,org_cn_full_name
,org_cn_short_name
,org_en_full_name
,org_en_short_name
,org_lvl_cd
,mgmt_super_org_id
,stl_super_org_id
,virtual_org_flg
,org_typ_cd
,small_subbranch_flg
,org_status_cd
,org_estab_dt
,org_close_dt
,org_person_qty
,ln_flg
,zipcode
,cty_cd
,blng_provin_cd
,blng_city_cd
,blng_county_cd
,physical_address
,lnkm_emply_id
,head_emply_id
,e_mail
,web_addr
,tel_cnr_cod
,tel_area_cod
,tel_num
,ext
,srv_tel
,fin_lice_num
,fin_org_ind_num
,pbc_fin_org_id
,swift_num
,pay_sys_bank_num
,oper_licence_num
,oper_licence_reg_dt
,oper_licence_due_dt
,org_cd
,tax_reg_cert_num
,stl_org_flg
,biz_org_flg
,admn_org_flg
,acct_org_flg
,data_src_cd
from ${idl_schema}.hdws_dul_d_opr_org_organization_info
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_opr_org_organization_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes