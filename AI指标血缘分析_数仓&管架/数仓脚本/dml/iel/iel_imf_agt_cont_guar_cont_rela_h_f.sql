: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_cont_guar_cont_rela_h_f
CreateDate: 20250928
FileName:   ${iel_data_path}/agt_cont_guar_cont_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id
,replace(replace(t1.guar_type_cd,chr(13),''),chr(10),'') as guar_type_cd
,guar_amt
,replace(replace(t1.guar_curr_cd,chr(13),''),chr(10),'') as guar_curr_cd
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
,replace(replace(t1.strip_line_cd,chr(13),''),chr(10),'') as strip_line_cd
,replace(replace(t1.pri_contr_type_cd,chr(13),''),chr(10),'') as pri_contr_type_cd

from ${iml_schema}.agt_cont_guar_cont_rela_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cont_guar_cont_rela_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
