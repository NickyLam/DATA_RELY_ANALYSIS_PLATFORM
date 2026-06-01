: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_pty_blkl_pty_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_pty_blkl_pty_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.blkl_src_cd,chr(13),''),chr(10),'') as blkl_src_cd
,replace(replace(t1.input_tell_id,chr(13),''),chr(10),'') as input_tell_id
,replace(replace(t1.typ_cd,chr(13),''),chr(10),'') as typ_cd
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,t1.up_blkl_dt as up_blkl_dt
,replace(replace(t1.up_blkl_rsns,chr(13),''),chr(10),'') as up_blkl_rsns
,replace(replace(t1.rems,chr(13),''),chr(10),'') as rems
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'PTY_BLKL_PTY_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'PTY_BLKL_PTY_INFO_H') as etl_task_name 
from ${idl_schema}.hdws_iml_pty_blkl_pty_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_pty_blkl_pty_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes