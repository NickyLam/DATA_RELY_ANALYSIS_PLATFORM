: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t00_dict_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t00_dict.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.disctype,chr(13),''),chr(10),'') as disctype
    ,replace(replace(t.disctypename,chr(13),''),chr(10),'') as disctypename
    ,replace(replace(t.disckey,chr(13),''),chr(10),'') as disckey
    ,replace(replace(t.discname,chr(13),''),chr(10),'') as discname
    ,replace(replace(t.des,chr(13),''),chr(10),'') as des
    ,replace(replace(t.flag,chr(13),''),chr(10),'') as flag
    ,t.dispseq as dispseq
    ,replace(replace(t.applytype,chr(13),''),chr(10),'') as applytype
from iol.amls_t00_dict t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t00_dict.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes