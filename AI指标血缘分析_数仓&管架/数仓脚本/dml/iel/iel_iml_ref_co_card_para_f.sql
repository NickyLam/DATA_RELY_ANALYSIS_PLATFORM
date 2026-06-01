: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_co_card_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_co_card_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.co_card_cd,chr(13),''),chr(10),'') as co_card_cd
    ,replace(replace(t.co_card_fname,chr(13),''),chr(10),'') as co_card_fname
    ,replace(replace(t.co_card_abbr,chr(13),''),chr(10),'') as co_card_abbr
    ,replace(replace(t.stop_card_iss_flg,chr(13),''),chr(10),'') as stop_card_iss_flg
    ,replace(replace(t.func_rstrct_flg,chr(13),''),chr(10),'') as func_rstrct_flg
    ,t.create_dt as create_dt
    ,t.update_dt as update_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
    ,replace(replace(t.card_bin_num,chr(13),''),chr(10),'') as card_bin_num
from iml.ref_co_card_para t
  where t.create_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_co_card_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes