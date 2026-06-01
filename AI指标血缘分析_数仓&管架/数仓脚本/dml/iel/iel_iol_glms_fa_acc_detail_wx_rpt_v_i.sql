: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_glms_fa_acc_detail_wx_rpt_v_i
CreateDate: 20180529
FileName:   ${iel_data_path}/glms_fa_acc_detail_wx_rpt_v.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.etl_dt_ora as etl_dt_ora
    ,t.asset_id as asset_id
    ,replace(replace(t.description,chr(13),''),chr(10),'') as description
    ,replace(replace(t.subj_no,chr(13),''),chr(10),'') as subj_no
    ,t.cost as cost
    ,t.deprn_amount as deprn_amount
    ,replace(replace(t.coa_1,chr(13),''),chr(10),'') as coa_1
    ,replace(replace(t.coa_1_desc,chr(13),''),chr(10),'') as coa_1_desc
    ,replace(replace(t.coa_2,chr(13),''),chr(10),'') as coa_2
    ,replace(replace(t.coa_2_desc,chr(13),''),chr(10),'') as coa_2_desc
from iol.glms_fa_acc_detail_wx_rpt_v t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/glms_fa_acc_detail_wx_rpt_v.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes