: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_pty_fx_cap_cntpty_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_pty_fx_cap_cntpty.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,party_id
,lp_id
,cntpty_id
,dept_id
,cn_name
,en_name
,cn_abbr
,en_abbr
,fx_id
,cust_id from idl.icrm_pty_fx_cap_cntpty where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_pty_fx_cap_cntpty.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes