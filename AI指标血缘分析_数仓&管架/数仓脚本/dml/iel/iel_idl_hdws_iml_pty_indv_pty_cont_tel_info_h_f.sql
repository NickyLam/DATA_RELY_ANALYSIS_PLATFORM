: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_pty_indv_pty_cont_tel_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_pty_indv_pty_cont_tel_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.tel_num_typ_cd,chr(13),''),chr(10),'') as tel_num_typ_cd
,replace(replace(t1.tel_intl_phone_cty_cd,chr(13),''),chr(10),'') as tel_intl_phone_cty_cd
,replace(replace(t1.dom_tel_area_cd,chr(13),''),chr(10),'') as dom_tel_area_cd
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t1.tel_ext,chr(13),''),chr(10),'') as tel_ext
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'PTY_INDV_PTY_CONT_TEL_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'PTY_INDV_PTY_CONT_TEL_INFO_H') as etl_task_name 
from ${idl_schema}.hdws_iml_pty_indv_pty_cont_tel_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_pty_indv_pty_cont_tel_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes