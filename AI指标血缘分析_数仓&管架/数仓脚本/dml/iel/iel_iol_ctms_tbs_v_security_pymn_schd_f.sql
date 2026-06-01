: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_security_pymn_schd_f
CreateDate: 20250416
FileName:   ${iel_data_path}/ctms_tbs_v_security_pymn_schd.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.security_code,chr(13),''),chr(10),'') as security_code
,seq
,replace(replace(t1.payment_date,chr(13),''),chr(10),'') as payment_date
,replace(replace(t1.call_date,chr(13),''),chr(10),'') as call_date
,replace(replace(t1.put_date,chr(13),''),chr(10),'') as put_date
,coupon_amt
,back_amt
,last_amt
,modify_date
,call_price
,put_price
,replace(replace(t1.convert_date,chr(13),''),chr(10),'') as convert_date
,replace(replace(t1.convert_security_code,chr(13),''),chr(10),'') as convert_security_code
,replace(replace(t1.back_announce_date,chr(13),''),chr(10),'') as back_announce_date

from ${iol_schema}.ctms_tbs_v_security_pymn_schd t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_security_pymn_schd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
