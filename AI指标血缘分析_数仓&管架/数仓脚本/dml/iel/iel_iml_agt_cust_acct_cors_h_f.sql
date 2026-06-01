: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cust_acct_cors_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cust_acct_cors_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.agt_party_rela_type_cd,chr(13),''),chr(10),'') as agt_party_rela_type_cd
    ,replace(replace(t.seq_num,chr(13),''),chr(10),'') as seq_num
    ,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
    ,replace(replace(t.data_kind_cd,chr(13),''),chr(10),'') as data_kind_cd
    ,replace(replace(t.data_content,chr(13),''),chr(10),'') as data_content
    ,replace(replace(t.status_cd,chr(13),''),chr(10),'') as status_cd
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_cust_acct_cors_h t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cust_acct_cors_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes