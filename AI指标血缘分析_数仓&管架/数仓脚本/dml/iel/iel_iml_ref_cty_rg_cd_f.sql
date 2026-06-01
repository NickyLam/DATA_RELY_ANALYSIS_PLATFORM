: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_cty_rg_cd_f
CreateDate: 20221020
FileName:   ${iel_data_path}/ref_cty_rg_cd.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,translate(cd_val,chr(13)||chr(10),' ')
,translate(cd_descb,chr(13)||chr(10),' ')
,translate(data_std_flg,chr(13)||chr(10),' ')
,translate(quote_data_std,chr(13)||chr(10),' ')
,translate(remark,chr(13)||chr(10),' ')
,translate(valid_flg,chr(13)||chr(10),' ')
,invalid_dt
from ${iml_schema}.ref_cty_rg_cd t
where 1=1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_cty_rg_cd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
