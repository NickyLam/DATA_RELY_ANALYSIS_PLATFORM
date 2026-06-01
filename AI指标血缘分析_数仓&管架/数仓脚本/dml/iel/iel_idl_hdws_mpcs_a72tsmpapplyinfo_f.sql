: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a72tsmpapplyinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a72tsmpapplyinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.transdate
,t1.transtime
,t1.applystate
,t1.persnlstate
,t1.rspcd
,t1.rspmsg
,t1.msgid
,t1.pamid
,t1.instpaid
,t1.acctno
,t1.periddata
,t1.custno
,t1.certidtype
,t1.certid
,t1.pername
,t1.phoneid
,t1.cardnm
,t1.stepnum
,t1.stepindex
,t1.dgifilename
from ${idl_schema}.hdws_mpcs_a72tsmpapplyinfo t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a72tsmpapplyinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes