: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_pty_corp_pty_ntw_loc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_pty_corp_pty_ntw_loc.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,etl_dt
      ,replace(replace(e_loc_typ_cd,chr(10),''),chr(13),'') as e_loc_typ_cd
      ,replace(replace(e_loc,chr(10),''),chr(13),'') as e_loc
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg 
from idl.hdws_dul_d_ccrm_pty_corp_pty_ntw_loc 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_pty_corp_pty_ntw_loc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes