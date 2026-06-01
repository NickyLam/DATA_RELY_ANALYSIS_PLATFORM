: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ecrs_customer_belong_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ecrs_customer_belong_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 customerid
,orgid
,userid
,belongattribute
,belongattribute1
,belongattribute2
,belongattribute3
,belongattribute4
,inputuserid
,inputorgid
,inputdate
,updatedate
,applyattribute
,applyattribute1
,applyattribute2
,applyattribute3
,applyattribute4
,remark
,applystatus
,applyreason
,applyright
,applytype
from idl.ecrs_customer_belong
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/ecrs_customer_belong_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes