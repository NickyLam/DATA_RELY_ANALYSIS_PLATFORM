: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_scrm_we_news_trends_i
CreateDate: 20230804
FileName:   ${iel_data_path}/scrm_we_news_trends.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.trends_id,chr(13),''),chr(10),'') as trends_id
,replace(replace(t1.external_userid,chr(13),''),chr(10),'') as external_userid
,replace(replace(t1.external_username,chr(13),''),chr(10),'') as external_username
,replace(replace(t1.opr_prsn_id,chr(13),''),chr(10),'') as opr_prsn_id
,replace(replace(t1.vist_func_id,chr(13),''),chr(10),'') as vist_func_id
,counts
,replace(replace(t1.mov_tp_cd,chr(13),''),chr(10),'') as mov_tp_cd
,replace(replace(t1.mov_tp_nm,chr(13),''),chr(10),'') as mov_tp_nm
,replace(replace(t1.mov_title,chr(13),''),chr(10),'') as mov_title
,replace(replace(t1.mov_inf_dsc,chr(13),''),chr(10),'') as mov_inf_dsc
,replace(replace(t1.mov_dt,chr(13),''),chr(10),'') as mov_dt
,replace(replace(t1.mov_tm,chr(13),''),chr(10),'') as mov_tm
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.opr_prsn_name,chr(13),''),chr(10),'') as opr_prsn_name
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.type_id,chr(13),''),chr(10),'') as type_id
,replace(replace(t1.trends_type,chr(13),''),chr(10),'') as trends_type
,replace(replace(t1.cust_type,chr(13),''),chr(10),'') as cust_type

from ${iol_schema}.scrm_we_news_trends t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/scrm_we_news_trends.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
