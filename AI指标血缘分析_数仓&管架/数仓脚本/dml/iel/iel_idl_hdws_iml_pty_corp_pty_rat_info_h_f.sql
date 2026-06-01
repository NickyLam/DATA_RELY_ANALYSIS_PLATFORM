: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_pty_corp_pty_rat_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_pty_corp_pty_rat_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.crdt_rat_typ_cd,chr(13),''),chr(10),'') as crdt_rat_typ_cd
,replace(replace(t1.crdt_rat_org_num,chr(13),''),chr(10),'') as crdt_rat_org_num
,replace(replace(t1.crdt_rat_org_name,chr(13),''),chr(10),'') as crdt_rat_org_name
,replace(replace(t1.crdt_rat_resu_cd,chr(13),''),chr(10),'') as crdt_rat_resu_cd
,t1.crdt_score_val as crdt_score_val
,t1.crdt_rat_dt as crdt_rat_dt
,t1.crdt_rat_valid_dt as crdt_rat_valid_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'PTY_CORP_PTY_RAT_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'PTY_CORP_PTY_RAT_INFO_H') as etl_task_name 
from ${idl_schema}.hdws_iml_pty_corp_pty_rat_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_pty_corp_pty_rat_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes