: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_newly_dep_flg_name_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_newly_dep_flg_name_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.flg_field_name,chr(13),''),chr(10),'') as flg_field_name
,replace(replace(t.flg_comnt,chr(13),''),chr(10),'') as flg_comnt
,replace(replace(t.flg_deflt_val,chr(13),''),chr(10),'') as flg_deflt_val
,replace(replace(t.rec_status_cd,chr(13),''),chr(10),'') as rec_status_cd
,replace(replace(t.matn_teller_id,chr(13),''),chr(10),'') as matn_teller_id
,replace(replace(t.matn_org_id,chr(13),''),chr(10),'') as matn_org_id
,t.matn_dt as matn_dt
,replace(replace(t.matn_tm,chr(13),''),chr(10),'') as matn_tm
,t.create_dt as create_dt
,t.update_dt as update_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.ref_newly_dep_flg_name_para t
where t.create_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_newly_dep_flg_name_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes