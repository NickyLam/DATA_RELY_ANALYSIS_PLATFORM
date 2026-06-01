: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_pty_party_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_pty_party_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.pty_typ_cd,chr(13),''),chr(10),'') as pty_typ_cd
,replace(replace(t1.cn_fname,chr(13),''),chr(10),'') as cn_fname
,replace(replace(t1.cn_sname,chr(13),''),chr(10),'') as cn_sname
,replace(replace(t1.piny_name,chr(13),''),chr(10),'') as piny_name
,replace(replace(t1.en_fname,chr(13),''),chr(10),'') as en_fname
,replace(replace(t1.en_sname,chr(13),''),chr(10),'') as en_sname
,t1.open_dt as open_dt
,replace(replace(t1.open_org_id,chr(13),''),chr(10),'') as open_org_id
,replace(replace(t1.open_teller_id,chr(13),''),chr(10),'') as open_teller_id
,t1.colse_dt as colse_dt
,replace(replace(t1.colse_org_id,chr(13),''),chr(10),'') as colse_org_id
,replace(replace(t1.colse_teller_id,chr(13),''),chr(10),'') as colse_teller_id
,replace(replace(t1.non_resident_flg,chr(13),''),chr(10),'') as non_resident_flg
,replace(replace(t1.pty_status_cd,chr(13),''),chr(10),'') as pty_status_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'PTY_PARTY_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'PTY_PARTY_H') as etl_task_name 
from ${idl_schema}.hdws_iml_pty_party t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_pty_party_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes