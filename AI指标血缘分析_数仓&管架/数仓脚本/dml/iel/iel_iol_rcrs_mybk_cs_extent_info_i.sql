: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_mybk_cs_extent_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_mybk_cs_extent_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t.apply_no,chr(13),''),chr(10),'') as apply_no
,replace(replace(t.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t.address,chr(13),''),chr(10),'') as address
,replace(replace(t.prov,chr(13),''),chr(10),'') as prov
,replace(replace(t.city,chr(13),''),chr(10),'') as city
,replace(replace(t.area,chr(13),''),chr(10),'') as area
,replace(replace(t.cert_valid_end_date,chr(13),''),chr(10),'') as cert_valid_end_date
,replace(replace(t.busdata_req_date,chr(13),''),chr(10),'') as busdata_req_date
,replace(replace(t.bus_info_exist_flag,chr(13),''),chr(10),'') as bus_info_exist_flag
,replace(replace(t.not_exist_reason,chr(13),''),chr(10),'') as not_exist_reason
,replace(replace(t.company_info_name,chr(13),''),chr(10),'') as company_info_name
,replace(replace(t.company_info_lawer,chr(13),''),chr(10),'') as company_info_lawer
,replace(replace(t.register_no,chr(13),''),chr(10),'') as register_no
,replace(replace(t.register_date,chr(13),''),chr(10),'') as register_date
,replace(replace(t.register_address,chr(13),''),chr(10),'') as register_address
,replace(replace(t.register_address_area_code,chr(13),''),chr(10),'') as register_address_area_code
,replace(replace(t.register_address_area,chr(13),''),chr(10),'') as register_address_area
,t.register_fund as register_fund
,replace(replace(t.fund_currency,chr(13),''),chr(10),'') as fund_currency
,replace(replace(t.trade_code,chr(13),''),chr(10),'') as trade_code
,replace(replace(t.manage_range,chr(13),''),chr(10),'') as manage_range
,replace(replace(t.org_code,chr(13),''),chr(10),'') as org_code
,replace(replace(t.register_department,chr(13),''),chr(10),'') as register_department
,replace(replace(t.status_id,chr(13),''),chr(10),'') as status_id
,replace(replace(t.status_desc,chr(13),''),chr(10),'') as status_desc
,replace(replace(t.last_check_year,chr(13),''),chr(10),'') as last_check_year
,replace(replace(t.manage_begin_date,chr(13),''),chr(10),'') as manage_begin_date
,replace(replace(t.manage_end_date,chr(13),''),chr(10),'') as manage_end_date
,replace(replace(t.open_date,chr(13),''),chr(10),'') as open_date
,replace(replace(t.company_type,chr(13),''),chr(10),'') as company_type
,replace(replace(t.economic_type,chr(13),''),chr(10),'') as economic_type
,replace(replace(t.target_jy_flag_1,chr(13),''),chr(10),'') as target_jy_flag_1
,replace(replace(t.industry_name,chr(13),''),chr(10),'') as industry_name
from ${iol_schema}.RCRS_MYBK_CS_EXTENT_INFO t 
where to_char(to_date(substr(serno,5,8),'yyyy-MM-dd'),'yyyymmdd')='${batch_date}' and substr(serno,0,4)='MYBK';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_mybk_cs_extent_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes