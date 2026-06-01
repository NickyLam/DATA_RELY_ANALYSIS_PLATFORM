: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_party_fin_ind_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_pty_party_fin_ind_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.lp_id as lp_id
,t1.sorc_sys_cd as sorc_sys_cd
,t1.ind_val as ind_val
,t1.sal_acct_num as sal_acct_num
,t1.open_acct_bank as open_acct_bank
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.fin_ind_cd as fin_ind_cd
,t1.party_id as party_id

from ${idl_schema}.oass_pty_party_fin_ind_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_party_fin_ind_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
