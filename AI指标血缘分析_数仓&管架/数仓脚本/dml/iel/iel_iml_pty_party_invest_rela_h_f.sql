: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_invest_rela_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/pty_party_invest_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(party_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(rela_party_id,chr(13),''),chr(10),'')
,replace(replace(party_rela_type_cd,chr(13),''),chr(10),'')
,replace(replace(legal_rep,chr(13),''),chr(10),'')
,replace(replace(curr_cd,chr(13),''),chr(10),'')
,actl_amt
,invest_ratio
,replace(replace(invest_situ_type_cd,chr(13),''),chr(10),'')
,invest_dt
,resp_bid_cap_lmt
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.pty_party_invest_rela_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_invest_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
