: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amss_cms_vpay_qr_info_f
CreateDate: 20250506
FileName:   ${iel_data_path}/amss_cms_vpay_qr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.qr_id,chr(13),''),chr(10),'') as qr_id
,replace(replace(t1.channel_id,chr(13),''),chr(10),'') as channel_id
,replace(replace(t1.channel_name,chr(13),''),chr(10),'') as channel_name
,replace(replace(t1.second_channel_id,chr(13),''),chr(10),'') as second_channel_id
,replace(replace(t1.second_channel_name,chr(13),''),chr(10),'') as second_channel_name
,salesman_id
,replace(replace(t1.salesman_name,chr(13),''),chr(10),'') as salesman_name
,replace(replace(t1.merchant_id,chr(13),''),chr(10),'') as merchant_id
,replace(replace(t1.merchant_name,chr(13),''),chr(10),'') as merchant_name
,use_status
,bind_time
,replace(replace(t1.qr_logo,chr(13),''),chr(10),'') as qr_logo
,replace(replace(t1.mch_logo,chr(13),''),chr(10),'') as mch_logo
,replace(replace(t1.qr_url,chr(13),''),chr(10),'') as qr_url
,qr_batch_id
,update_time
,create_time
,replace(replace(t1.accept_org_id,chr(13),''),chr(10),'') as accept_org_id
,replace(replace(t1.qr_no,chr(13),''),chr(10),'') as qr_no
,cashier_id
,replace(replace(t1.cashier_name,chr(13),''),chr(10),'') as cashier_name
,fld_n1
,fld_n2
,replace(replace(t1.fld_s1,chr(13),''),chr(10),'') as fld_s1
,replace(replace(t1.fld_s2,chr(13),''),chr(10),'') as fld_s2
,replace(replace(t1.enabled,chr(13),''),chr(10),'') as enabled
,business_type
,origin
,replace(replace(t1.terminal_id,chr(13),''),chr(10),'') as terminal_id
,replace(replace(t1.mch_terminal_id,chr(13),''),chr(10),'') as mch_terminal_id
,replace(replace(t1.terminal_address,chr(13),''),chr(10),'') as terminal_address

from ${iol_schema}.amss_cms_vpay_qr_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amss_cms_vpay_qr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
