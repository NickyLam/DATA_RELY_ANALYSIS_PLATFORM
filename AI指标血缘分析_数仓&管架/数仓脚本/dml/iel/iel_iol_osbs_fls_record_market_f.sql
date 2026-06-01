: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_osbs_fls_record_market_f
CreateDate: 20180529
FileName:   ${iel_data_path}/osbs_fls_record_market.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.fcb_flowid,chr(13),''),chr(10),'') as fcb_flowid
    ,replace(replace(t.fcb_acct_no,chr(13),''),chr(10),'') as fcb_acct_no
    ,replace(replace(t.fcb_channel,chr(13),''),chr(10),'') as fcb_channel
    ,replace(replace(t.fcb_market_no,chr(13),''),chr(10),'') as fcb_market_no
    ,replace(replace(t.fcb_product_type,chr(13),''),chr(10),'') as fcb_product_type
    ,replace(replace(t.fcb_lc_template,chr(13),''),chr(10),'') as fcb_lc_template
    ,replace(replace(t.fcb_product_no,chr(13),''),chr(10),'') as fcb_product_no
    ,replace(replace(t.fcb_createtime,chr(13),''),chr(10),'') as fcb_createtime
    ,replace(replace(t.fcb_updatetime,chr(13),''),chr(10),'') as fcb_updatetime
from ${iol_schema}.osbs_fls_record_market t
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/osbs_fls_record_market.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes