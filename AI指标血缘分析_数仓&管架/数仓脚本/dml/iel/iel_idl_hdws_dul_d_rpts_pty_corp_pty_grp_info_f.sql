: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_pty_corp_pty_grp_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_pty_corp_pty_grp_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
pty_id
,etl_dt
,last_update_dt
,blng_grp_num
,blng_grp_name
,blng_grp_org_cd
,blng_grp_loan_card_num
,blng_grp_login_cty
,blng_grp_loc_cd
,blng_grp_login_loc
,grp_bcs_mem_flg
,data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_pty_corp_pty_grp_info 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_pty_corp_pty_grp_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes