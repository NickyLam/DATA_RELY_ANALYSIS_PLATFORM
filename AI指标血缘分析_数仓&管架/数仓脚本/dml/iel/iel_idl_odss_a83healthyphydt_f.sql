: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_a83healthyphydt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_a83healthyphydt_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
transeq
,dealdt
,no
,yshacct
,yshclassname
,yshclass
,ltkacct
,ltkclass
,custname
,idtfno
,phone
,content
,contentoff
,orderdt
,usedt
,offername
,remark
,brnnbr
,tlrnbr
,remark1
,remark2
,remark3
,remark4
from ${idl_schema}.odss_a83healthyphydt
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_a83healthyphydt_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes