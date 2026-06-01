: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_evt_coa_rela_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_evt_coa_rela.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(evt_id,chr(10),''),chr(13),'') as evt_id
      ,replace(replace(biz_sys_evt_id,chr(10),''),chr(13),'') as biz_sys_evt_id
      ,replace(replace(global_chn_seq_num,chr(10),''),chr(13),'') as global_chn_seq_num
      ,txn_dt
      ,replace(replace(accting_coa_id,chr(10),''),chr(13),'') as accting_coa_id
      ,replace(replace(db_cr_flg,chr(10),''),chr(13),'') as db_cr_flg
      ,replace(replace(src_sys_cd,chr(10),''),chr(13),'') as src_sys_cd
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,etl_dt
      ,replace(replace(etl_task_name,chr(10),''),chr(13),'') as etl_task_name 
from idl.hdws_dul_d_rpts_evt_coa_rela 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_evt_coa_rela.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes