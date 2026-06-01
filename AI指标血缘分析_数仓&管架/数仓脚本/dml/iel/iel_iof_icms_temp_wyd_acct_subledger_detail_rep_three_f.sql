: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_temp_wyd_acct_subledger_detail_rep_three_f
CreateDate: 20251112
FileName:   ${iel_data_path}/icms_temp_wyd_acct_subledger_detail_rep_three.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.transserialno,chr(13),''),chr(10),'') as transserialno
,replace(replace(t1.transcode,chr(13),''),chr(10),'') as transcode
,replace(replace(t1.subledgerserialno,chr(13),''),chr(10),'') as subledgerserialno
,replace(replace(t1.relativeobjectno,chr(13),''),chr(10),'') as relativeobjectno
,replace(replace(t1.accountingorgid,chr(13),''),chr(10),'') as accountingorgid
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.bookdate,chr(13),''),chr(10),'') as bookdate
,replace(replace(t1.accountcodeno,chr(13),''),chr(10),'') as accountcodeno
,replace(replace(t1.exaccountcodeno,chr(13),''),chr(10),'') as exaccountcodeno
,amount
,replace(replace(t1.direction,chr(13),''),chr(10),'') as direction
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,debitbalance
,creditbalance
,odebitbalance
,ocreditbalance
,replace(replace(t1.subtranscode,chr(13),''),chr(10),'') as subtranscode
,replace(replace(t1.remarkcode,chr(13),''),chr(10),'') as remarkcode
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.subdetailtype,chr(13),''),chr(10),'') as subdetailtype
,replace(replace(t1.capitaltransserialno,chr(13),''),chr(10),'') as capitaltransserialno

from ${iol_schema}.icms_temp_wyd_acct_subledger_detail_rep_three t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_temp_wyd_acct_subledger_detail_rep_three.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
