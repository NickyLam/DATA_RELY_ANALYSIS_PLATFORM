: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_oper_corp_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_party_oper_corp_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.exist_sal_duf_situ_flg,chr(13),''),chr(10),'') as exist_sal_duf_situ_flg 
,t1.share_pct as share_pct 
,t1.accti_prft_rat as accti_prft_rat 
,replace(replace(t1.oper_site_type_cd,chr(13),''),chr(10),'') as oper_site_type_cd 
,replace(replace(t1.oper_range,chr(13),''),chr(10),'') as oper_range 
,replace(replace(t1.oper_type_cd,chr(13),''),chr(10),'') as oper_type_cd 
,replace(replace(t1.oper_corp_addr,chr(13),''),chr(10),'') as oper_corp_addr 
,t1.oper_corp_year_bus_inco as oper_corp_year_bus_inco 
,t1.mon_bus_inco as mon_bus_inco 
,t1.rgst_cap as rgst_cap 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.pty_party_oper_corp_h t1 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_oper_corp_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes