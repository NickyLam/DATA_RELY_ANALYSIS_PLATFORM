: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_fams_chb_month_report_detail_i
CreateDate: 20231008
FileName:   ${iel_data_path}/fams_chb_month_report_detail.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.termid,chr(13),''),chr(10),'') as termid
,replace(replace(t1.reporttype,chr(13),''),chr(10),'') as reporttype
,replace(replace(t1.propertycode,chr(13),''),chr(10),'') as propertycode
,prodcounts
,prodamount
,prodnetamount
,durationprodcounts
,balance
,bottombalance
,customerprofit
,bankprofit
,prodyield
,replace(replace(t1.detailuuid,chr(13),''),chr(10),'') as detailuuid
,replace(replace(t1.org_code,chr(13),''),chr(10),'') as org_code
,replace(replace(t1.dept_code,chr(13),''),chr(10),'') as dept_code
,replace(replace(t1.reportuuid,chr(13),''),chr(10),'') as reportuuid
,prodpayamount
,xgdurationprodcounts
,xgbalance
,xgbottombalance

from ${iol_schema}.fams_chb_month_report_detail t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_chb_month_report_detail.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
