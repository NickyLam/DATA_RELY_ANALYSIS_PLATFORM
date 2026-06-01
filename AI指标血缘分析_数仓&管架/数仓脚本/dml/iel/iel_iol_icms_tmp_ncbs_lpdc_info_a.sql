: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_tmp_ncbs_lpdc_info_a
CreateDate: 20231025
FileName:   ${iel_data_path}/icms_tmp_ncbs_lpdc_info.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.compensatedate,chr(13),''),chr(10),'') as compensatedate
,compensateamt
,compensatepriamt
,compensateintamt
,compensatedueodpamt
,replace(replace(t1.compensateway,chr(13),''),chr(10),'') as compensateway
,replace(replace(t1.cmisloanno,chr(13),''),chr(10),'') as cmisloanno
,replace(replace(t1.guarcompensateacctno,chr(13),''),chr(10),'') as guarcompensateacctno
,compensatereceiptamt
,replace(replace(t1.guarcompensatetype,chr(13),''),chr(10),'') as guarcompensatetype
,compensateratio
,guarcompensateamt
,replace(replace(t1.guarcompensatestatus,chr(13),''),chr(10),'') as guarcompensatestatus
,acctbalance

from ${iol_schema}.icms_tmp_ncbs_lpdc_info t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_tmp_ncbs_lpdc_info.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
