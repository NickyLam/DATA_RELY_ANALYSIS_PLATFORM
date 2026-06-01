: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_putout_online_f
CreateDate: 20241230
FileName:   ${iel_data_path}/icms_putout_online.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.putoutno,chr(13),''),chr(10),'') as putoutno
,replace(replace(t1.contractserialno,chr(13),''),chr(10),'') as contractserialno
,replace(replace(t1.hostnbr,chr(13),''),chr(10),'') as hostnbr
,replace(replace(t1.dd_status,chr(13),''),chr(10),'') as dd_status
,replace(replace(t1.hostdate,chr(13),''),chr(10),'') as hostdate
,firstpayamt
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t1.isfirstpay,chr(13),''),chr(10),'') as isfirstpay
,firstpayratio
,replace(replace(t1.duebillserialno,chr(13),''),chr(10),'') as duebillserialno
,billamt
,replace(replace(t1.oarateexaresult,chr(13),''),chr(10),'') as oarateexaresult
,replace(replace(t1.orderno,chr(13),''),chr(10),'') as orderno
,ordersumamt

from ${iol_schema}.icms_putout_online t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_putout_online.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
