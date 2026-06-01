: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_pcrs_pty_indv_pty_cont_tel_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_pcrs_pty_indv_pty_cont_tel_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,t1.etl_dt as etl_dt
,replace(replace(t1.tel_num_typ_cd,chr(13),''),chr(10),'') as tel_num_typ_cd
,replace(replace(t1.tel_intl_phone_cty_cd,chr(13),''),chr(10),'') as tel_intl_phone_cty_cd
,replace(replace(t1.dom_tel_area_cd,chr(13),''),chr(10),'') as dom_tel_area_cd
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t1.tel_ext,chr(13),''),chr(10),'') as tel_ext
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_pcrs_pty_indv_pty_cont_tel_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_pcrs_pty_indv_pty_cont_tel_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes