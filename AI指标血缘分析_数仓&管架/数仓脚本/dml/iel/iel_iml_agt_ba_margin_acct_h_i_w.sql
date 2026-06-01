: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_ba_margin_acct_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_ba_margin_acct_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id 
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t.agt_rela_type_cd,chr(13),''),chr(10),'') as agt_rela_type_cd 
,replace(replace(t.seq_num,chr(13),''),chr(10),'') as seq_num 
,replace(replace(t.rela_agt_id,chr(13),''),chr(10),'') as rela_agt_id 
,replace(replace(t.acpt_agt_id,chr(13),''),chr(10),'') as acpt_agt_id 
,replace(replace(t.margin_acct_id,chr(13),''),chr(10),'') as margin_acct_id 
,replace(replace(t.margin_sub_acct_id,chr(13),''),chr(10),'') as margin_sub_acct_id 
,replace(replace(t.status_cd,chr(13),''),chr(10),'') as status_cd 
,replace(replace(t.bill_id,chr(13),''),chr(10),'') as bill_id 
,replace(replace(t.acpt_acct_num,chr(13),''),chr(10),'') as acpt_acct_num 
,t.froz_dt as froz_dt 
,replace(replace(t.froz_flow_num,chr(13),''),chr(10),'') as froz_flow_num 
,replace(replace(t.chn_cd,chr(13),''),chr(10),'') as chn_cd 
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_ba_margin_acct_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6)" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ba_margin_acct_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes