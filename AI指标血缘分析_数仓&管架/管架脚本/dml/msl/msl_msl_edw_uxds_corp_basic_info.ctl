-- SQL* Unloader: Fast Oracle TetUnloader (Gzip),Release 3.0.1
-- (@) Copyright Lou Fangxin (AnySQL.net) 2004 -2010, all rigths reserved.
-- Purpose:    Sqlldr Control File
-- Author:     Sunline
-- CreateDate: 20190705
-- FileType:   Control-File
-- Logs:
--     luzd 2019-07-05 create template

options(bindsize=2097152,readsize=2097152,errors=0,rows=5000)
load data
infile '${data_path}/uxds_corp_basic_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_uxds_corp_basic_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,seq char(4000) nullif seq=blanks 
    ,ctime date "yyyy-mm-dd hh24:mi:ss" nullif ctime=blanks 
    ,mtime date "yyyy-mm-dd hh24:mi:ss" nullif mtime=blanks 
    ,rtime date "yyyy-mm-dd hh24:mi:ss" nullif rtime=blanks 
    ,corp_nature char(4000) nullif corp_nature=blanks 
    ,org_cn_introduction char(4000) nullif org_cn_introduction=blanks 
    ,domestic_listing_identifier char(4000) nullif domestic_listing_identifier=blanks 
    ,currency_encode char(4000) nullif currency_encode=blanks 
    ,accounting_firm_id char(4000) nullif accounting_firm_id=blanks 
    ,law_firm_id char(4000) nullif law_firm_id=blanks 
    ,org_id char(4000) nullif org_id=blanks 
    ,org_name_cn char(4000) nullif org_name_cn=blanks 
    ,org_website char(4000) nullif org_website=blanks 
    ,org_short_name_cn char(4000) nullif org_short_name_cn=blanks 
    ,staff_num char(4000) nullif staff_num=blanks 
    ,legal_representative char(4000) nullif legal_representative=blanks 
    ,reg_address_cn char(4000) nullif reg_address_cn=blanks 
    ,accounting_firm_name char(4000) nullif accounting_firm_name=blanks 
    ,law_firm_name char(4000) nullif law_firm_name=blanks 
    ,charged_accountant char(4000) nullif charged_accountant=blanks 
    ,charged_lawyer char(4000) nullif charged_lawyer=blanks 
    ,district_encode char(4000) nullif district_encode=blanks 
    ,cn_regional_identifier char(4000) nullif cn_regional_identifier=blanks 
    ,org_code char(4000) nullif org_code=blanks 
    ,unified_social_credit_code char(4000) nullif unified_social_credit_code=blanks 
    ,office_address_cn char(4000) nullif office_address_cn=blanks 
    ,postcode char(4000) nullif postcode=blanks 
    ,reg_asset char(4000) nullif reg_asset=blanks 
    ,currency_name char(4000) nullif currency_name=blanks 
    ,established_date date "yyyy-mm-dd hh24:mi:ss" nullif established_date=blanks 
    ,email char(4000) nullif email=blanks 
    ,telephone char(4000) nullif telephone=blanks 
    ,fax char(4000) nullif fax=blanks 
    ,main_operation_business char(4000) nullif main_operation_business=blanks 
    ,operating_scope char(4000) nullif operating_scope=blanks 
    ,org_name_en char(4000) nullif org_name_en=blanks 
    ,general_manager char(4000) nullif general_manager=blanks 
    ,org_short_name_en char(4000) nullif org_short_name_en=blanks 
    ,corp_ed date "yyyy-mm-dd hh24:mi:ss" nullif corp_ed=blanks 
    ,announcement_date date "yyyy-mm-dd hh24:mi:ss" nullif announcement_date=blanks 
    ,business_reg_num char(4000) nullif business_reg_num=blanks 
    ,tax_reg_num char(4000) nullif tax_reg_num=blanks 
    ,secretary char(4000) nullif secretary=blanks 
    ,sec_representative char(4000) nullif sec_representative=blanks 
    ,org_type char(4000) nullif org_type=blanks 
    ,reg_address_en char(4000) nullif reg_address_en=blanks 
    ,office_address_en char(4000) nullif office_address_en=blanks 
    ,board_manage_analysis char(4000) nullif board_manage_analysis=blanks 
    ,establishment_history char(4000) nullif establishment_history=blanks 
    ,isvalid char(4000) nullif isvalid=blanks 
)