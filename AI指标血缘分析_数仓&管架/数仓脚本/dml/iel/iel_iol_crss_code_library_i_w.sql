: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_code_library_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_code_library_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select replace(replace(codeno, chr(10), ''), chr(13), '') as codeno,
       replace(replace(itemno, chr(10), ''), chr(13), '') as itemno,
       replace(replace(itemname, chr(10), ''), chr(13), '') as itemname,
       replace(replace(bankno, chr(10), ''), chr(13), '') as bankno,
       replace(replace(sortno, chr(10), ''), chr(13), '') as sortno,
       replace(replace(isinuse, chr(10), ''), chr(13), '') as isinuse,
       replace(replace(itemdescribe, chr(10), ''), chr(13), '') as itemdescribe,
       replace(replace(itemattribute, chr(10), ''), chr(13), '') as itemattribute,
       replace(replace(relativecode, chr(10), ''), chr(13), '') as relativecode,
       replace(replace(attribute1, chr(10), ''), chr(13), '') as attribute1,
       replace(replace(attribute2, chr(10), ''), chr(13), '') as attribute2,
       replace(replace(attribute3, chr(10), ''), chr(13), '') as attribute3,
       replace(replace(attribute4, chr(10), ''), chr(13), '') as attribute4,
       replace(replace(attribute5, chr(10), ''), chr(13), '') as attribute5,
       replace(replace(attribute6, chr(10), ''), chr(13), '') as attribute6,
       replace(replace(attribute7, chr(10), ''), chr(13), '') as attribute7,
       replace(replace(attribute8, chr(10), ''), chr(13), '') as attribute8,
       replace(replace(inputuser, chr(10), ''), chr(13), '') as inputuser,
       replace(replace(inputorg, chr(10), ''), chr(13), '') as inputorg,
       replace(replace(inputtime, chr(10), ''), chr(13), '') as inputtime,
       replace(replace(updateuser, chr(10), ''), chr(13), '') as updateuser,
       replace(replace(updatetime, chr(10), ''), chr(13), '') as updatetime,
       replace(replace(remark, chr(10), ''), chr(13), '') as remark,
       replace(replace(helptext, chr(10), ''), chr(13), '') as helptext,
       replace(replace(guarantyinfo, chr(10), ''), chr(13), '') as guarantyinfo,
       replace(replace(remark2, chr(10), ''), chr(13), '') as remark2,
       replace(replace(dscode, chr(10), ''), chr(13), '') as dscode,
       start_dt,
       end_dt,
       id_mark,
       etl_timestamp
  from iol.crss_code_library
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_code_library_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes