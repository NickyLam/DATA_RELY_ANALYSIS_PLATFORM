: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdps_receivable_account_detail_f
CreateDate: 20240829
FileName:   ${iel_data_path}/bdps_receivable_account_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acctna,chr(13),''),chr(10),'') as acctna
,replace(replace(t1.acctou,chr(13),''),chr(10),'') as acctou
,replace(replace(t1.bail_acctno,chr(13),''),chr(10),'') as bail_acctno
,replace(replace(t1.balance_acctno,chr(13),''),chr(10),'') as balance_acctno
,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t1.cuime,chr(13),''),chr(10),'') as cuime
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.dtitcd,chr(13),''),chr(10),'') as dtitcd
,replace(replace(t1.froztg,chr(13),''),chr(10),'') as froztg
,id
,instrt
,replace(replace(t1.matudt,chr(13),''),chr(10),'') as matudt
,replace(replace(t1.pssbtp,chr(13),''),chr(10),'') as pssbtp
,replace(replace(t1.termcd,chr(13),''),chr(10),'') as termcd
,tranam

from ${iol_schema}.bdps_receivable_account_detail t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdps_receivable_account_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
