: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_pty_corp_pty_addr_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_pty_corp_pty_addr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
pty_id
,etl_dt
,last_update_dt
,phys_loc_typ_cd
,phys_loc_cty_cd
,phys_loc_prov_cd
,phys_loc_city_cd
,phys_loc_cuty_cd
,phys_dtl_loc
,phys_loc_pst_encd
,data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_pty_corp_pty_addr_info 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_pty_corp_pty_addr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes