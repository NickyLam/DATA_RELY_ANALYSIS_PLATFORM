: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uxds_corp_basic_info_f
CreateDate: 20250605
FileName:   ${iel_data_path}/uxds_corp_basic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,seq
,ctime
,mtime
,rtime
,replace(replace(t1.corp_nature,chr(13),''),chr(10),'') as corp_nature
,replace(replace(t1.org_cn_introduction,chr(13),''),chr(10),'') as org_cn_introduction
,replace(replace(t1.domestic_listing_identifier,chr(13),''),chr(10),'') as domestic_listing_identifier
,replace(replace(t1.currency_encode,chr(13),''),chr(10),'') as currency_encode
,replace(replace(t1.accounting_firm_id,chr(13),''),chr(10),'') as accounting_firm_id
,replace(replace(t1.law_firm_id,chr(13),''),chr(10),'') as law_firm_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.org_name_cn,chr(13),''),chr(10),'') as org_name_cn
,replace(replace(t1.org_website,chr(13),''),chr(10),'') as org_website
,replace(replace(t1.org_short_name_cn,chr(13),''),chr(10),'') as org_short_name_cn
,staff_num
,replace(replace(t1.legal_representative,chr(13),''),chr(10),'') as legal_representative
,replace(replace(t1.reg_address_cn,chr(13),''),chr(10),'') as reg_address_cn
,replace(replace(t1.accounting_firm_name,chr(13),''),chr(10),'') as accounting_firm_name
,replace(replace(t1.law_firm_name,chr(13),''),chr(10),'') as law_firm_name
,replace(replace(t1.charged_accountant,chr(13),''),chr(10),'') as charged_accountant
,replace(replace(t1.charged_lawyer,chr(13),''),chr(10),'') as charged_lawyer
,replace(replace(t1.district_encode,chr(13),''),chr(10),'') as district_encode
,cn_regional_identifier
,replace(replace(t1.org_code,chr(13),''),chr(10),'') as org_code
,replace(replace(t1.unified_social_credit_code,chr(13),''),chr(10),'') as unified_social_credit_code
,replace(replace(t1.office_address_cn,chr(13),''),chr(10),'') as office_address_cn
,replace(replace(t1.postcode,chr(13),''),chr(10),'') as postcode
,reg_asset
,replace(replace(t1.currency_name,chr(13),''),chr(10),'') as currency_name
,established_date
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.telephone,chr(13),''),chr(10),'') as telephone
,replace(replace(t1.fax,chr(13),''),chr(10),'') as fax
,replace(replace(t1.main_operation_business,chr(13),''),chr(10),'') as main_operation_business
,replace(replace(t1.operating_scope,chr(13),''),chr(10),'') as operating_scope
,replace(replace(t1.org_name_en,chr(13),''),chr(10),'') as org_name_en
,replace(replace(t1.general_manager,chr(13),''),chr(10),'') as general_manager
,replace(replace(t1.org_short_name_en,chr(13),''),chr(10),'') as org_short_name_en
,corp_ed
,announcement_date
,replace(replace(t1.business_reg_num,chr(13),''),chr(10),'') as business_reg_num
,replace(replace(t1.tax_reg_num,chr(13),''),chr(10),'') as tax_reg_num
,replace(replace(t1.secretary,chr(13),''),chr(10),'') as secretary
,replace(replace(t1.sec_representative,chr(13),''),chr(10),'') as sec_representative
,replace(replace(t1.org_type,chr(13),''),chr(10),'') as org_type
,replace(replace(t1.reg_address_en,chr(13),''),chr(10),'') as reg_address_en
,replace(replace(t1.office_address_en,chr(13),''),chr(10),'') as office_address_en
,replace(replace(t1.board_manage_analysis,chr(13),''),chr(10),'') as board_manage_analysis
,replace(replace(t1.establishment_history,chr(13),''),chr(10),'') as establishment_history
,isvalid

from ${iol_schema}.uxds_corp_basic_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_corp_basic_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
