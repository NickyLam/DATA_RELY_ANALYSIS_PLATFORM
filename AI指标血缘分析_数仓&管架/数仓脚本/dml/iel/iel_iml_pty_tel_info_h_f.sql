: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_tel_info_h_f
CreateDate: 20251015
FileName:   ${iel_data_path}/pty_tel_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
,replace(replace(t1.tel_type_cd,chr(13),''),chr(10),'') as tel_type_cd
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,start_dt
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t1.main_tel_num_flg,chr(13),''),chr(10),'') as main_tel_num_flg
,replace(replace(t1.dd_area_cd,chr(13),''),chr(10),'') as dd_area_cd
,replace(replace(t1.ext_num,chr(13),''),chr(10),'') as ext_num
,replace(replace(t1.tel_char_cd,chr(13),''),chr(10),'') as tel_char_cd
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.latest_chn_cd,chr(13),''),chr(10),'') as latest_chn_cd
,final_update_dt
,replace(replace(t1.real_name_cert_que_rest,chr(13),''),chr(10),'') as real_name_cert_que_rest

from ${iml_schema}.pty_tel_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_tel_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
