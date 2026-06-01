: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_rcr0042t_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_rcr0042t.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.cusid,chr(13),''),chr(10),'') as cusid
,replace(replace(t.flag,chr(13),''),chr(10),'') as flag
,replace(replace(t.message,chr(13),''),chr(10),'') as message
,replace(replace(t.isblack,chr(13),''),chr(10),'') as isblack
,replace(replace(t.blackenddate,chr(13),''),chr(10),'') as blackenddate
,replace(replace(t.blackreason,chr(13),''),chr(10),'') as blackreason
from iol.ilss_ghb_rcr0042t t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_rcr0042t.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes