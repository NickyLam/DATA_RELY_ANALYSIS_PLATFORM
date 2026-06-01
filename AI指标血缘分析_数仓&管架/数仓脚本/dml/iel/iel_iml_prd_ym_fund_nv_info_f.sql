: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_ym_fund_nv_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_ym_fund_nv_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.nv_dt as nv_dt
,replace(replace(t.fund_cd,chr(13),''),chr(10),'') as fund_cd
,replace(replace(t.serv_plat_abbr,chr(13),''),chr(10),'') as serv_plat_abbr
,replace(replace(t.mercht_id,chr(13),''),chr(10),'') as mercht_id
,t.corp_nv as corp_nv
,t.acm_nv as acm_nv
,t.daily_incr as daily_incr
,t.ten_thous_prft as ten_thous_prft
,t.sevn_aual_yld as sevn_aual_yld
,t.status_dt as status_dt
,replace(replace(t.fund_status_cd,chr(13),''),chr(10),'') as fund_status_cd
,replace(replace(t.fund_tran_status_cd,chr(13),''),chr(10),'') as fund_tran_status_cd
,replace(replace(t.aip_status_cd,chr(13),''),chr(10),'') as aip_status_cd
,t.create_dt as create_dt
,t.update_dt as update_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.prd_ym_fund_nv_info t
where t.create_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_ym_fund_nv_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes