: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_credit_principal_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_credit_principal_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select replace(replace(duebillserialno, chr(10), ''), chr(13), '') as duebillserialno,
       replace(replace(businesscurrency, chr(10), ''), chr(13), '') as businesscurrency,
       replace(replace(principalsum, chr(10), ''), chr(13), '') as principalsum,
       replace(replace(principaldate, chr(10), ''), chr(13), '') as principaldate,
       replace(replace(billtype, chr(10), ''), chr(13), '') as billtype,
       replace(replace(attribute1, chr(10), ''), chr(13), '') as attribute1,
       replace(replace(attribute2, chr(10), ''), chr(13), '') as attribute2,
       replace(replace(attribute3, chr(10), ''), chr(13), '') as attribute3,
       replace(replace(attribute4, chr(10), ''), chr(13), '') as attribute4,
       replace(replace(paymentaccountno, chr(10), ''), chr(13), '') as paymentaccountno,
       etl_dt,
       etl_timestamp
  from iol.crss_credit_principal
 where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and
       to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_credit_principal_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes