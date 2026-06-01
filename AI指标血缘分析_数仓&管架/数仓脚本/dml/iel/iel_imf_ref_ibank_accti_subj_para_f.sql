: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ref_ibank_accti_subj_para_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_ibank_accti_subj_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.level1_subj_name,chr(13),''),chr(10),'') as level1_subj_name
,replace(replace(t1.level2_subj_name,chr(13),''),chr(10),'') as level2_subj_name
,replace(replace(t1.level3_subj_name,chr(13),''),chr(10),'') as level3_subj_name
,replace(replace(t1.accti_code,chr(13),''),chr(10),'') as accti_code
,replace(replace(t1.subj_attr_cd,chr(13),''),chr(10),'') as subj_attr_cd
,replace(replace(t1.subj_dir_cd,chr(13),''),chr(10),'') as subj_dir_cd
,replace(replace(t1.level1_subj_id,chr(13),''),chr(10),'') as level1_subj_id
,replace(replace(t1.level2_subj_id,chr(13),''),chr(10),'') as level2_subj_id
,replace(replace(t1.level3_subj_id,chr(13),''),chr(10),'') as level3_subj_id
,replace(replace(t1.entry_type_cd_3,chr(13),''),chr(10),'') as entry_type_cd_3
,replace(replace(t1.entry_type_cd,chr(13),''),chr(10),'') as entry_type_cd
,replace(replace(t1.entry_type_cd_1,chr(13),''),chr(10),'') as entry_type_cd_1
,replace(replace(t1.entry_type_cd_2,chr(13),''),chr(10),'') as entry_type_cd_2
,replace(replace(t1.entry_type_cd_4,chr(13),''),chr(10),'') as entry_type_cd_4
,replace(replace(t1.entry_type_cd_5,chr(13),''),chr(10),'') as entry_type_cd_5
,replace(replace(t1.charge_type_cd,chr(13),''),chr(10),'') as charge_type_cd
,replace(replace(t1.level4_subj_name,chr(13),''),chr(10),'') as level4_subj_name
,replace(replace(t1.level5_subj_name,chr(13),''),chr(10),'') as level5_subj_name
,replace(replace(t1.level4_subj_id,chr(13),''),chr(10),'') as level4_subj_id
,replace(replace(t1.level5_subj_id,chr(13),''),chr(10),'') as level5_subj_id
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.ref_ibank_accti_subj_para t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_ibank_accti_subj_para.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
