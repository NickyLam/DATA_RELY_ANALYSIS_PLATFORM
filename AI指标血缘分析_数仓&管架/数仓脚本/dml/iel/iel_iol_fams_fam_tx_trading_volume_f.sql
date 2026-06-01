: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_fam_tx_trading_volume_f
CreateDate: 20260116
FileName:   ${iel_data_path}/fams_fam_tx_trading_volume.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,cdate
,replace(replace(t1.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
,replace(replace(t1.orer_userno,chr(13),''),chr(10),'') as orer_userno
,replace(replace(t1.orer_username,chr(13),''),chr(10),'') as orer_username
,replace(replace(t1.auth_userno,chr(13),''),chr(10),'') as auth_userno
,replace(replace(t1.auth_username,chr(13),''),chr(10),'') as auth_username
,replace(replace(t1.auth_orgid,chr(13),''),chr(10),'') as auth_orgid
,replace(replace(t1.txn_num,chr(13),''),chr(10),'') as txn_num
,replace(replace(t1.txn_desc,chr(13),''),chr(10),'') as txn_desc
,begin_time
,end_time
,replace(replace(t1.txn_id,chr(13),''),chr(10),'') as txn_id
,replace(replace(t1.src_cd,chr(13),''),chr(10),'') as src_cd

from ${iol_schema}.fams_fam_tx_trading_volume t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_fam_tx_trading_volume.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
