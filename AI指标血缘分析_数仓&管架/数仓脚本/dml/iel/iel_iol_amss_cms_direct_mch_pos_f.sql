: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amss_cms_direct_mch_pos_f
CreateDate: 20250506
FileName:   ${iel_data_path}/amss_cms_direct_mch_pos.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,id
,replace(replace(t1.term_no,chr(13),''),chr(10),'') as term_no
,replace(replace(t1.js_no,chr(13),''),chr(10),'') as js_no
,replace(replace(t1.term_type,chr(13),''),chr(10),'') as term_type
,replace(replace(t1.use_city,chr(13),''),chr(10),'') as use_city
,replace(replace(t1.term_sn,chr(13),''),chr(10),'') as term_sn
,replace(replace(t1.product_no,chr(13),''),chr(10),'') as product_no
,replace(replace(t1.producer,chr(13),''),chr(10),'') as producer
,replace(replace(t1.term_address,chr(13),''),chr(10),'') as term_address
,replace(replace(t1.term_status,chr(13),''),chr(10),'') as term_status
,replace(replace(t1.term_secret,chr(13),''),chr(10),'') as term_secret
,replace(replace(t1.union_partner,chr(13),''),chr(10),'') as union_partner
,replace(replace(t1.mch_no,chr(13),''),chr(10),'') as mch_no
,replace(replace(t1.mch_nm,chr(13),''),chr(10),'') as mch_nm
,replace(replace(t1.channel_id,chr(13),''),chr(10),'') as channel_id
,replace(replace(t1.aff_channel,chr(13),''),chr(10),'') as aff_channel
,replace(replace(t1.channel_nm,chr(13),''),chr(10),'') as channel_nm
,physics_flag
,create_time
,create_user
,replace(replace(t1.create_emp,chr(13),''),chr(10),'') as create_emp
,update_user
,update_time
,replace(replace(t1.update_emp,chr(13),''),chr(10),'') as update_emp

from ${iol_schema}.amss_cms_direct_mch_pos t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amss_cms_direct_mch_pos.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
