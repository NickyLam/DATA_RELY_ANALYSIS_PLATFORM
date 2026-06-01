: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_insu_comp_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_insu_comp.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.insure_bank_cd,chr(13),''),chr(10),'') as insure_bank_cd
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,replace(replace(t1.corp_abbr,chr(13),''),chr(10),'') as corp_abbr
,replace(replace(t1.insu_comp_type_cd,chr(13),''),chr(10),'') as insu_comp_type_cd
,replace(replace(t1.lmt_ctrl_type_cd,chr(13),''),chr(10),'') as lmt_ctrl_type_cd
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.ref_insu_comp t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_insu_comp.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
