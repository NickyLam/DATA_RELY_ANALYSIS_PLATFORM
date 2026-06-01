: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_alsointerest_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_alsointerest_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select replace(replace(duebillserialno, chr(10), ''), chr(13), '') as duebillserialno,
       replace(replace(alsointerestno, chr(10), ''), chr(13), '') as alsointerestno,
       replace(replace(businesscurrency, chr(10), ''), chr(13), '') as businesscurrency,
       replace(replace(alsointerestsum, chr(10), ''), chr(13), '') as alsointerestsum,
       replace(replace(interesttype, chr(10), ''), chr(13), '') as interesttype,
       replace(replace(alsointerestdate, chr(10), ''), chr(13), '') as alsointerestdate,
       replace(replace(dateno, chr(10), ''), chr(13), '') as dateno,
       replace(replace(loansq, chr(10), ''), chr(13), '') as loansq,
       replace(replace(insttg, chr(10), ''), chr(13), '') as insttg,
       replace(replace(pdlnsq, chr(10), ''), chr(13), '') as pdlnsq,
       replace(replace(pdtmno, chr(10), ''), chr(13), '') as pdtmno,
       replace(replace(paymentaccountno, chr(10), ''), chr(13), '') as paymentaccountno,
       etl_dt,
       etl_timestamp
  from iol.crss_alsointerest_info
 where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and
       to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_alsointerest_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes