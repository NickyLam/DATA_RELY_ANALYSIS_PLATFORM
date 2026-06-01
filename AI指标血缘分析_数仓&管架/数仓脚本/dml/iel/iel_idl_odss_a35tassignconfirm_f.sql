: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_a35tassignconfirm_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_a35tassignconfirm_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
cobank
,custname
,idtype
,idno
,acctno
,pswd
,seccd
,secname
,capitalacctno
,capitalpswd
,ccy
,custmanagerid
,custtype
,openbrcno
,sex
,secbrcno
,tycustno
,tyacctno
,signtm
,brcno
,brcname
,confirmstatus
,rspmsg
,custno
,bizagtname
,bizagtidtype
,bizagtidno
,reserve2
,reserve3
from ${idl_schema}.odss_a35tassignconfirm
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_a35tassignconfirm_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes