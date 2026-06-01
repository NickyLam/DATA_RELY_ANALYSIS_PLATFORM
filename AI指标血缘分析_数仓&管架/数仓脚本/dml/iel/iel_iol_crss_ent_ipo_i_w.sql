: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_ent_ipo_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_ent_ipo_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select replace(replace(customerid, chr(10), ''), chr(13), '') as customerid,
       replace(replace(serialno, chr(10), ''), chr(13), '') as serialno,
       replace(replace(ipodate, chr(10), ''), chr(13), '') as ipodate,
       replace(replace(boursename, chr(10), ''), chr(13), '') as boursename,
       replace(replace(stockcode, chr(10), ''), chr(13), '') as stockcode,
       replace(replace(stocktype, chr(10), ''), chr(13), '') as stocktype,
       replace(replace(stockname, chr(10), ''), chr(13), '') as stockname,
       replace(replace(inputorgid, chr(10), ''), chr(13), '') as inputorgid,
       replace(replace(inputuserid, chr(10), ''), chr(13), '') as inputuserid,
       replace(replace(inputdate, chr(10), ''), chr(13), '') as inputdate,
       replace(replace(updatedate, chr(10), ''), chr(13), '') as updatedate,
       replace(replace(remark, chr(10), ''), chr(13), '') as remark,
       start_dt,
       end_dt,
       id_mark,
       etl_timestamp
  from iol.crss_ent_ipo
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_ent_ipo_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes