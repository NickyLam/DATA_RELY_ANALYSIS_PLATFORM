: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_code_catalog_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_code_catalog_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select replace(replace(codeno, chr(10), ''), chr(13), '') as codeno,
       replace(replace(sortno, chr(10), ''), chr(13), '') as sortno,
       replace(replace(codetypeone, chr(10), ''), chr(13), '') as codetypeone,
       replace(replace(codetypetwo, chr(10), ''), chr(13), '') as codetypetwo,
       replace(replace(codename, chr(10), ''), chr(13), '') as codename,
       replace(replace(codedescribe, chr(10), ''), chr(13), '') as codedescribe,
       replace(replace(codeattribute, chr(10), ''), chr(13), '') as codeattribute,
       replace(replace(inputuser, chr(10), ''), chr(13), '') as inputuser,
       replace(replace(inputorg, chr(10), ''), chr(13), '') as inputorg,
       replace(replace(inputtime, chr(10), ''), chr(13), '') as inputtime,
       replace(replace(updateuser, chr(10), ''), chr(13), '') as updateuser,
       replace(replace(updatetime, chr(10), ''), chr(13), '') as updatetime,
       replace(replace(remark, chr(10), ''), chr(13), '') as remark,
       start_dt,
       end_dt,
       id_mark,
       etl_timestamp
  from iol.crss_code_catalog
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and
       to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_code_catalog_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes