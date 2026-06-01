: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_pty_e_chn_user_safe_in_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_pty_e_chn_user_safe_in.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.etl_dt as etl_dt
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.safe_instr_typ_cd,chr(13),''),chr(10),'') as safe_instr_typ_cd
,replace(replace(t1.safe_instr_id,chr(13),''),chr(10),'') as safe_instr_id
,replace(replace(t1.safe_instr_name,chr(13),''),chr(10),'') as safe_instr_name
,replace(replace(t1.safe_instr_status_cd,chr(13),''),chr(10),'') as safe_instr_status_cd
,t1.safe_instr_crea_tm as safe_instr_crea_tm
,t1.safe_instr_modif_tm as safe_instr_modif_tm
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_rpts_pty_e_chn_user_safe_in t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_pty_e_chn_user_safe_in.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes