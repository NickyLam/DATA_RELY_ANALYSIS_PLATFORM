: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_rcrs_mybk_cs_extent_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_rcrs_mybk_cs_extent_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.serno
,t1.apply_no
,t1.mobile
,t1.address
,t1.prov
,t1.city
,t1.area
,t1.cert_valid_end_date
,t1.busdata_req_date
,t1.bus_info_exist_flag
,t1.not_exist_reason
,t1.company_info_name
,t1.company_info_lawer
,t1.register_no
,t1.register_date
,t1.register_address
,t1.register_address_area_code
,t1.register_address_area
,t1.register_fund
,t1.fund_currency
,t1.trade_code
,t1.manage_range
,t1.org_code
,t1.register_department
,t1.status_id
,t1.status_desc
,t1.last_check_year
,t1.manage_begin_date
,t1.manage_end_date
,t1.open_date
,t1.company_type
,t1.economic_type
,t1.target_jy_flag_1
,t1.industry_name
from ${idl_schema}.hdws_rcrs_mybk_cs_extent_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_rcrs_mybk_cs_extent_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes