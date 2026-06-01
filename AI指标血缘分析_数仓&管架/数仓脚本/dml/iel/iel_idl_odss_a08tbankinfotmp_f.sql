: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_a08tbankinfotmp_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_a08tbankinfotmp_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
trndt
,transmitdt
,transseq
,sndbrn
,sndupbrn
,rcvbrn
,rcvupbrn
,syscd
,chngtp
,bkcd
,bkstatus
,banktype
,bkctgycd
,drctbkcd
,bkname
,bksname
,lglprsn
,hghptcpt
,brbkcd
,chrgbkcd
,ndcd
,citycd
,sgn
,tel
,chngnb
,fctvdt
,ifctvdt
from ${idl_schema}.odss_a08tbankinfotmp
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_a08tbankinfotmp_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes