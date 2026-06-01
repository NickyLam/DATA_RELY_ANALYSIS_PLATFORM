: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pcls_yxyd_sj_info_f
CreateDate: 20250711
FileName:   ${iel_data_path}/pcls_yxyd_sj_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.rj_rule_big,chr(13),''),chr(10),'') as rj_rule_big
,replace(replace(t1.rj_rule,chr(13),''),chr(10),'') as rj_rule
,t_1_cnt
,t_2_cnt
,t_3_cnt
,t_4_cnt
,t_5_cnt
,t_6_cnt
,t_7_cnt

from ${iol_schema}.pcls_yxyd_sj_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pcls_yxyd_sj_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
