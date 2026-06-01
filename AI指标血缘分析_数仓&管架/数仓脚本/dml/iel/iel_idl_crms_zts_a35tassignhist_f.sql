: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_zts_a35tassignhist_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_zts_a35tassignhist_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
cobank
,custname
,idtype
,idno
,oriacctno
,oripswd
,newacctno
,newpswd
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
,trntype
,trnname
,signtm
,brcno
,brcname
,chgflag
from ${idl_schema}.crms_zts_a35tassignhist
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_zts_a35tassignhist_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes