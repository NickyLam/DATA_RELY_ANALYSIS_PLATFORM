: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_bus_vouch_rgst_b_a
CreateDate: 20240321
FileName:   ${iel_data_path}/evt_bus_vouch_rgst_b.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.rgst_flow_num,chr(13),''),chr(10),'') as rgst_flow_num
,rgst_dt
,replace(replace(t1.rgst_batch_no,chr(13),''),chr(10),'') as rgst_batch_no
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,chn_dt
,replace(replace(t1.chn_flow_num,chr(13),''),chr(10),'') as chn_flow_num
,replace(replace(t1.chn_cd,chr(13),''),chr(10),'') as chn_cd
,replace(replace(t1.vouch_seq_num,chr(13),''),chr(10),'') as vouch_seq_num
,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd
,replace(replace(t1.trdpty_tran_code,chr(13),''),chr(10),'') as trdpty_tran_code
,replace(replace(t1.proc_step_cd,chr(13),''),chr(10),'') as proc_step_cd
,replace(replace(t1.proc_status_cd,chr(13),''),chr(10),'') as proc_status_cd
,proc_cnt
,proc_dt
,replace(replace(t1.app_process_cd,chr(13),''),chr(10),'') as app_process_cd
,replace(replace(t1.app_proc_info,chr(13),''),chr(10),'') as app_proc_info
,replace(replace(t1.blip_batch_no,chr(13),''),chr(10),'') as blip_batch_no
,replace(replace(t1.file_num_create_way_cd,chr(13),''),chr(10),'') as file_num_create_way_cd
,replace(replace(t1.doc_upload_status_cd,chr(13),''),chr(10),'') as doc_upload_status_cd
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.teller_id,chr(13),''),chr(10),'') as teller_id
,init_create_dt
,modif_dt
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.remark_2,chr(13),''),chr(10),'') as remark_2

from ${iml_schema}.evt_bus_vouch_rgst_b t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bus_vouch_rgst_b.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
