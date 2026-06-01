: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_yjzb_hyyjh_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_yjzb_hyyjh.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.khnf as khnf
,t.khzbdh as khzbdh
,t.khdxdh as khdxdh
,t.jhz1 as jhz1
,t.lzz1 as lzz1
,t.jhz2 as jhz2
,t.lzz2 as lzz2
,t.jhz3 as jhz3
,t.lzz3 as lzz3
,t.jhz4 as jhz4
,t.lzz4 as lzz4
,t.jhz5 as jhz5
,t.lzz5 as lzz5
,t.jhz6 as jhz6
,t.lzz6 as lzz6
,t.jhz7 as jhz7
,t.lzz7 as lzz7
,t.jhz8 as jhz8
,t.lzz8 as lzz8
,t.jhz9 as jhz9
,t.lzz9 as lzz9
,t.jhz10 as jhz10
,t.lzz10 as lzz10
,t.jhz11 as jhz11
,t.lzz11 as lzz11
,t.jhz12 as jhz12
,t.lzz12 as lzz12
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.pams_yjzb_hyyjh t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_yjzb_hyyjh.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes