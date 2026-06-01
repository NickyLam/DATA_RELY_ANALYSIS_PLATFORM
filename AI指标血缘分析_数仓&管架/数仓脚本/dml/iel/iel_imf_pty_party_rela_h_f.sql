: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_pty_party_rela_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_party_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.party_rela_type_cd,chr(13),''),chr(10),'') as party_rela_type_cd
    ,replace(replace(t.seq_num,chr(13),''),chr(10),'') as seq_num
    ,t.start_dt as start_dt
    ,replace(replace(t.rela_party_id,chr(13),''),chr(10),'') as rela_party_id
    ,replace(replace(t.valid_flg,chr(13),''),chr(10),'') as valid_flg
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.pty_party_rela_h t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_rela_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes