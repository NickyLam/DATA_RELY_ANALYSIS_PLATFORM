: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_fin_am_sob_f
CreateDate: 20240118
FileName:   ${iel_data_path}/fin_am_sob.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.sob_id,chr(13),''),chr(10),'') as sob_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sob_name,chr(13),''),chr(10),'') as sob_name
,replace(replace(t1.sob_fname,chr(13),''),chr(10),'') as sob_fname
,replace(replace(t1.sob_cate_cd,chr(13),''),chr(10),'') as sob_cate_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.tepla_sob_id,chr(13),''),chr(10),'') as tepla_sob_id
,create_dt
,update_dt

from ${iml_schema}.fin_am_sob t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fin_am_sob.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
