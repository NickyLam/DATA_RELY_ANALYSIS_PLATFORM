: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_pty_corp_pty_cont_tel_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_pty_corp_pty_cont_tel.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
pty_id
,etl_dt
,tel_num_typ_cd
,tel_intl_phone_cty_cd
,dom_tel_area_cd
,tel_num
,tel_ext
,data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_pty_corp_pty_cont_tel 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_pty_corp_pty_cont_tel.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes