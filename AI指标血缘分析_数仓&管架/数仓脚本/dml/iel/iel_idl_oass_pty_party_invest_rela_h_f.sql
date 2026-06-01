: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_party_invest_rela_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_pty_party_invest_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.rela_party_id as rela_party_id
,t1.party_rela_type_cd as party_rela_type_cd
,t1.legal_rep as legal_rep
,t1.curr_cd as curr_cd
,t1.actl_amt as actl_amt
,t1.invest_ratio as invest_ratio
,t1.invest_situ_type_cd as invest_situ_type_cd
,t1.invest_dt as invest_dt
,t1.resp_bid_cap_lmt as resp_bid_cap_lmt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.party_id as party_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_pty_party_invest_rela_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_party_invest_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
