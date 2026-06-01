: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_evt_flow_evt_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_evt_flow_evt_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg
      ,etl_dt
      ,replace(replace(evt_id,chr(10),''),chr(13),'') as evt_id
      ,replace(replace(prev_evt_id,chr(10),''),chr(13),'') as prev_evt_id
      ,replace(replace(biz_seq_num,chr(10),''),chr(13),'') as biz_seq_num
      ,replace(replace(businessname,chr(10),''),chr(13),'') as businessname
      ,replace(replace(evt_typ_cd,chr(10),''),chr(13),'') as evt_typ_cd
      ,replace(replace(evt_status_cd,chr(10),''),chr(13),'') as evt_status_cd
      ,replace(replace(chn_typ_cd,chr(10),''),chr(13),'') as chn_typ_cd
      ,replace(replace(txn_num,chr(10),''),chr(13),'') as txn_num
      ,replace(replace(txn_desc,chr(10),''),chr(13),'') as txn_desc
      ,txn_stdt
      ,replace(replace(txn_start_tm,chr(10),''),chr(13),'') as txn_start_tm
      ,txn_end_dt
      ,replace(replace(txn_end_tm,chr(10),''),chr(13),'') as txn_end_tm
      ,replace(replace(txn_org_id,chr(10),''),chr(13),'') as txn_org_id
      ,replace(replace(txn_teller_id,chr(10),''),chr(13),'') as txn_teller_id
      ,replace(replace(stage_id,chr(10),''),chr(13),'') as stage_id
      ,replace(replace(stage_name,chr(10),''),chr(13),'') as stage_name 
from idl.hdws_dul_d_rpts_evt_flow_evt_dtl 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_evt_flow_evt_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes