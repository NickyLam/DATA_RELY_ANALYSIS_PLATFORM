: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_opr_pty_indv_pty_cont_tel_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_opr_pty_indv_pty_cont_tel_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,etl_dt
      ,replace(replace(tel_num_typ_cd,chr(10),''),chr(13),'') as tel_num_typ_cd
      ,replace(replace(tel_intl_phone_cty_cd,chr(10),''),chr(13),'') as tel_intl_phone_cty_cd
      ,replace(replace(dom_tel_area_cd,chr(10),''),chr(13),'') as dom_tel_area_cd
      ,replace(replace(tel_num,chr(10),''),chr(13),'') as tel_num
      ,replace(replace(tel_ext,chr(10),''),chr(13),'') as tel_ext
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd 
from idl.hdws_dul_d_opr_pty_indv_pty_cont_tel_info
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_opr_pty_indv_pty_cont_tel_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes