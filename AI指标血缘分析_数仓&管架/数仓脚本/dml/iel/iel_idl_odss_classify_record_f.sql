: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_classify_record_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_classify_record_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select objecttype
   ,objectno
   ,serialno
   ,modelno
   ,firstresult
   ,secondresult
   ,result1
   ,resultopinion1
   ,result2
   ,resultopinion2
   ,result3
   ,resultopinion3
   ,result4
   ,resultopinion4
   ,finallyresult
   ,sum1
   ,sum2
   ,sum3
   ,sum4
   ,sum5
   ,expectlosssum
   ,reservesum
   ,classifyuserid
   ,classifyorgid
   ,classifydate
   ,finishdate
   ,inputdate
   ,updatedate
   ,remark
   ,businessbalance
   ,orgid
   ,userid
   ,accountmonth
   ,result5
   ,resultopinion5
   ,resultusername5
   ,resultusername4
   ,resultusername3
   ,resultusername2
   ,resultusername1
   ,classifylevel
   ,resultuserid2
   ,resultuserid3
   ,resultuserid4
   ,resultuserid5
   ,finishdate2
   ,finishdate3
   ,finishdate4
   ,finishdate5
   ,originalputoutdate
   ,lastresult
   ,customerid
   ,contractserialno
   ,flag
from ${idl_schema}.odss_classify_record
where etl_dt = TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_classify_record_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes