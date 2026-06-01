: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_dzhx_approve_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_dzhx_approve_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select replace(replace(customerid, chr(10), ''), chr(13), '') as customerid,
       replace(replace(customername, chr(10), ''), chr(13), '') as customername,
       replace(replace(certtype, chr(10), ''), chr(13), '') as certtype,
       replace(replace(certid, chr(10), ''), chr(13), '') as certid,
       replace(replace(mainrepresent, chr(10), ''), chr(13), '') as mainrepresent,
       replace(replace(entproperty, chr(10), ''), chr(13), '') as entproperty,
       replace(replace(industry, chr(10), ''), chr(13), '') as industry,
       replace(replace(courtdecisionserialno, chr(10), ''), chr(13), '') as courtdecisionserialno,
       replace(replace(courtdecisiondate, chr(10), ''), chr(13), '') as courtdecisiondate,
       replace(replace(violateserialno, chr(10), ''), chr(13), '') as violateserialno,
       replace(replace(violatedate, chr(10), ''), chr(13), '') as violatedate,
       replace(replace(otherserialno, chr(10), ''), chr(13), '') as otherserialno,
       replace(replace(otherdate, chr(10), ''), chr(13), '') as otherdate,
       replace(replace(cancellicensedate, chr(10), ''), chr(13), '') as cancellicensedate,
       replace(replace(approvehxsum, chr(10), ''), chr(13), '') as approvehxsum,
       replace(replace(hxmoney, chr(10), ''), chr(13), '') as hxmoney,
       replace(replace(hxininterest, chr(10), ''), chr(13), '') as hxininterest,
       replace(replace(hxoutinterest, chr(10), ''), chr(13), '') as hxoutinterest,
       replace(replace(attribute1, chr(10), ''), chr(13), '') as attribute1,
       replace(replace(attribute2, chr(10), ''), chr(13), '') as attribute2,
       replace(replace(hxtype, chr(10), ''), chr(13), '') as hxtype,
       replace(replace(approvehxdate, chr(10), ''), chr(13), '') as approvehxdate,
       replace(replace(remark, chr(10), ''), chr(13), '') as remark,
       replace(replace(remark1, chr(10), ''), chr(13), '') as remark1,
       replace(replace(remark2, chr(10), ''), chr(13), '') as remark2,
       replace(replace(remark3, chr(10), ''), chr(13), '') as remark3,
       replace(replace(ifsearch, chr(10), ''), chr(13), '') as ifsearch,
       start_dt,
       end_dt,
       id_mark,
       etl_timestamp
  from iol.crss_dzhx_approve
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_dzhx_approve_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes