: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a08tbankinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a08tbankinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.bkcd,chr(13),''),chr(10),'') as bkcd
,replace(replace(t.bkstatus,chr(13),''),chr(10),'') as bkstatus
,replace(replace(t.banktype,chr(13),''),chr(10),'') as banktype
,replace(replace(t.bkctgycd,chr(13),''),chr(10),'') as bkctgycd
,replace(replace(t.drctbkcd,chr(13),''),chr(10),'') as drctbkcd
,replace(replace(t.bkname,chr(13),''),chr(10),'') as bkname
,replace(replace(t.bksname,chr(13),''),chr(10),'') as bksname
,replace(replace(t.lglprsn,chr(13),''),chr(10),'') as lglprsn
,replace(replace(t.hghptcpt,chr(13),''),chr(10),'') as hghptcpt
,replace(replace(t.brbkcd,chr(13),''),chr(10),'') as brbkcd
,replace(replace(t.chrgbkcd,chr(13),''),chr(10),'') as chrgbkcd
,replace(replace(t.ndcd,chr(13),''),chr(10),'') as ndcd
,replace(replace(t.citycd,chr(13),''),chr(10),'') as citycd
,replace(replace(t.sgn,chr(13),''),chr(10),'') as sgn
,replace(replace(t.tel,chr(13),''),chr(10),'') as tel
,replace(replace(t.chngnb,chr(13),''),chr(10),'') as chngnb
,replace(replace(t.fctvdt,chr(13),''),chr(10),'') as fctvdt
,replace(replace(t.ifctvdt,chr(13),''),chr(10),'') as ifctvdt
,replace(replace(t.acctbkcdinf,chr(13),''),chr(10),'') as acctbkcdinf
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.MPCS_A08TBANKINFO t 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a08tbankinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes