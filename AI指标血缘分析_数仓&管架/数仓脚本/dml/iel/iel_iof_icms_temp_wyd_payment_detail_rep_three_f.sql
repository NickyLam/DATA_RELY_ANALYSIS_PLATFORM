: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_temp_wyd_payment_detail_rep_three_f
CreateDate: 20251112
FileName:   ${iel_data_path}/icms_temp_wyd_payment_detail_rep_three.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.loanno,chr(13),''),chr(10),'') as loanno
,replace(replace(t1.refno,chr(13),''),chr(10),'') as refno
,ppay
,ipay
,pppay
,replace(replace(t1.type,chr(13),''),chr(10),'') as type
,replace(replace(t1.transdate,chr(13),''),chr(10),'') as transdate

from ${iol_schema}.icms_temp_wyd_payment_detail_rep_three t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_temp_wyd_payment_detail_rep_three.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
