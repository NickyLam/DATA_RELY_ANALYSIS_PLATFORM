: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_retail_score_card_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_retail_score_card.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.apply_id,chr(13),''),chr(10),'') as apply_id
,replace(replace(t.serial_no,chr(13),''),chr(10),'') as serial_no
,t.score as score
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ilss_ghb_retail_score_card t
where start_dt <= to_date('${batch_date}','yyyymmdd')
  and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_retail_score_card.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes