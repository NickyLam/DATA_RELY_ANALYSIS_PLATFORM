: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_coll_insur_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_coll_insur_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,replace(replace(t1.coll_id,chr(13),''),chr(10),'') as coll_id
,replace(replace(t1.insur_ord_nbr,chr(13),''),chr(10),'') as insur_ord_nbr
,replace(replace(t1.insur_corp_name,chr(13),''),chr(10),'') as insur_corp_name
,replace(replace(t1.insur_corp_frame_org_cd,chr(13),''),chr(10),'') as insur_corp_frame_org_cd
,replace(replace(t1.full_amt_insur_flg,chr(13),''),chr(10),'') as full_amt_insur_flg
,t1.insur_amt as insur_amt
,t1.start_dt as start_dt
,t1.due_dt as due_dt
from ${idl_schema}.hdws_iml_agt_coll_insur_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_coll_insur_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes