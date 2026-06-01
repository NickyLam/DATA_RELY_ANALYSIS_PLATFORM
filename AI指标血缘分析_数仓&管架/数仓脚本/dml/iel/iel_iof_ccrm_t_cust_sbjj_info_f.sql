: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ccrm_t_cust_sbjj_info_f
CreateDate: 20230804
FileName:   ${iel_data_path}/ccrm_t_cust_sbjj_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.sbjj_id,chr(13),''),chr(10),'') as sbjj_id
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.cn_fname,chr(13),''),chr(10),'') as cn_fname
,replace(replace(t1.acct_num,chr(13),''),chr(10),'') as acct_num
,replace(replace(t1.acct_znum,chr(13),''),chr(10),'') as acct_znum
,replace(replace(t1.sbjj_flag,chr(13),''),chr(10),'') as sbjj_flag
,replace(replace(t1.oper_user,chr(13),''),chr(10),'') as oper_user
,replace(replace(t1.oper_org,chr(13),''),chr(10),'') as oper_org
,oper_time

from ${iol_schema}.ccrm_t_cust_sbjj_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_t_cust_sbjj_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
