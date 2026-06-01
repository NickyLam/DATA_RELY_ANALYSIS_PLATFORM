: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ctms_crdtbond_timelimit_dtl_a
CreateDate: 20250415
FileName:   ${iel_data_path}/ctms_crdtbond_timelimit_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.settledate,chr(13),''),chr(10),'') as settledate
,replace(replace(t1.src_trd_id,chr(13),''),chr(10),'') as src_trd_id
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.limit_name,chr(13),''),chr(10),'') as limit_name
,portfolio_id
,replace(replace(t1.portfolio_name,chr(13),''),chr(10),'') as portfolio_name
,replace(replace(t1.bondscode,chr(13),''),chr(10),'') as bondscode
,replace(replace(t1.bondsname,chr(13),''),chr(10),'') as bondsname
,replace(replace(t1.bondstype,chr(13),''),chr(10),'') as bondstype
,occupy_value
,sum_occupy_value
,balance
,replace(replace(t1.maturity_date,chr(13),''),chr(10),'') as maturity_date
,replace(replace(t1.trade_date,chr(13),''),chr(10),'') as trade_date
,replace(replace(t1.sec_maturity_date,chr(13),''),chr(10),'') as sec_maturity_date
,sec_term_to_maturity
,replace(replace(t1.thd_maturity_date,chr(13),''),chr(10),'') as thd_maturity_date
,thd_term_to_maturity
,dmp_time

from ${iol_schema}.ctms_crdtbond_timelimit_dtl t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_crdtbond_timelimit_dtl.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
