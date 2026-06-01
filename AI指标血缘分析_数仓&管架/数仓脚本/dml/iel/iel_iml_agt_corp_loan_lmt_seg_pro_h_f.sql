: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_corp_loan_lmt_seg_pro_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_corp_loan_lmt_seg_pro_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.seg_lmt_id,chr(13),''),chr(10),'') as seg_lmt_id
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.asset_bus_breed_id,chr(13),''),chr(10),'') as asset_bus_breed_id
    ,replace(replace(t.circl_flg,chr(13),''),chr(10),'') as circl_flg
    ,t.margin_ratio as margin_ratio
    ,replace(replace(t.guar_type_cd,chr(13),''),chr(10),'') as guar_type_cd
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,t.seg_lmt_amt as seg_lmt_amt
    ,t.open_amt as open_amt
    ,replace(replace(t.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
    ,replace(replace(t.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
    ,t.rgst_dt as rgst_dt
    ,replace(replace(t.exlus_lmt_flg,chr(13),''),chr(10),'') as exlus_lmt_flg
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_corp_loan_lmt_seg_pro_h t
where t.start_dt <= to_date(${batch_date},'yyyymmdd') and t.end_dt >= to_date(${batch_date},'yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_corp_loan_lmt_seg_pro_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes