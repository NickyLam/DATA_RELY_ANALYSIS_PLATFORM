/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_bd_psndoc
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM nhrs_bd_psndoc_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('nhrs_bd_psndoc');
  
  if v_var <> 0 then 
    execute immediate 'alter table nhrs_bd_psndoc drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table nhrs_bd_psndoc add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.nhrs_bd_psndoc(
            addr -- 
            ,birthdate -- 
            ,code -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,def1 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def2 -- 
            ,def20 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,dr -- 
            ,email -- 
            ,enablestate -- 
            ,homephone -- 
            ,id -- 
            ,idtype -- 
            ,isshopassist -- 
            ,joinworkdate -- 
            ,mnecode -- 
            ,mobile -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,officephone -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_psndoc -- 
            ,sex -- 
            ,ts -- 
            ,usedname -- 
            ,bloodtype -- 
            ,censusaddr -- 
            ,characterrpr -- 
            ,country -- 
            ,die_date -- 
            ,die_remark -- 
            ,edu -- 
            ,fax -- 
            ,fileaddress -- 
            ,health -- 
            ,ishiskeypsn -- 
            ,joinpolitydate -- 
            ,marital -- 
            ,marriagedate -- 
            ,nationality -- 
            ,nativeplace -- 
            ,penelauth -- 
            ,permanreside -- 
            ,photo -- 
            ,pk_degree -- 
            ,pk_hrorg -- 
            ,polity -- 
            ,postalcode -- 
            ,previewphoto -- 
            ,prof -- 
            ,retiredate -- 
            ,secret_email -- 
            ,shortname -- 
            ,titletechpost -- 
            ,glbdef1 -- 
            ,glbdef2 -- 
            ,glbdef3 -- 
            ,glbdef4 -- 
            ,glbdef5 -- 
            ,glbdef6 -- 
            ,glbdef7 -- 
            ,glbdef8 -- 
            ,glbdef9 -- 
            ,glbdef10 -- 
            ,glbdef11 -- 
            ,glbdef12 -- 
            ,glbdef13 -- 
            ,glbdef14 -- 
            ,glbdef15 -- 
            ,glbdef16 -- 
            ,glbdef17 -- 
            ,glbdef18 -- 
            ,glbdef19 -- 
            ,glbdef20 -- 
            ,glbdef21 -- 
            ,glbdef22 -- 
            ,glbdef23 -- 
            ,glbdef24 -- 
            ,glbdef25 -- 
            ,glbdef26 -- 
            ,glbdef27 -- 
            ,glbdef28 -- 
            ,glbdef29 -- 
            ,glbdef30 -- 
            ,glbdef31 -- 
            ,glbdef32 -- 
            ,glbdef40 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            addr -- 
            ,birthdate -- 
            ,code -- 
            ,creationtime -- 
            ,creator -- 
            ,dataoriginflag -- 
            ,def1 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def2 -- 
            ,def20 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,dr -- 
            ,email -- 
            ,enablestate -- 
            ,homephone -- 
            ,id -- 
            ,idtype -- 
            ,isshopassist -- 
            ,joinworkdate -- 
            ,mnecode -- 
            ,mobile -- 
            ,modifiedtime -- 
            ,modifier -- 
            ,name -- 
            ,name2 -- 
            ,name3 -- 
            ,name4 -- 
            ,name5 -- 
            ,name6 -- 
            ,officephone -- 
            ,pk_group -- 
            ,pk_org -- 
            ,pk_psndoc -- 
            ,sex -- 
            ,ts -- 
            ,usedname -- 
            ,bloodtype -- 
            ,censusaddr -- 
            ,characterrpr -- 
            ,country -- 
            ,die_date -- 
            ,die_remark -- 
            ,edu -- 
            ,fax -- 
            ,fileaddress -- 
            ,health -- 
            ,ishiskeypsn -- 
            ,joinpolitydate -- 
            ,marital -- 
            ,marriagedate -- 
            ,nationality -- 
            ,nativeplace -- 
            ,penelauth -- 
            ,permanreside -- 
            ,photo -- 
            ,pk_degree -- 
            ,pk_hrorg -- 
            ,polity -- 
            ,postalcode -- 
            ,previewphoto -- 
            ,prof -- 
            ,retiredate -- 
            ,secret_email -- 
            ,shortname -- 
            ,titletechpost -- 
            ,glbdef1 -- 
            ,glbdef2 -- 
            ,glbdef3 -- 
            ,glbdef4 -- 
            ,glbdef5 -- 
            ,glbdef6 -- 
            ,glbdef7 -- 
            ,glbdef8 -- 
            ,glbdef9 -- 
            ,glbdef10 -- 
            ,glbdef11 -- 
            ,glbdef12 -- 
            ,glbdef13 -- 
            ,glbdef14 -- 
            ,glbdef15 -- 
            ,glbdef16 -- 
            ,glbdef17 -- 
            ,glbdef18 -- 
            ,glbdef19 -- 
            ,glbdef20 -- 
            ,glbdef21 -- 
            ,glbdef22 -- 
            ,glbdef23 -- 
            ,glbdef24 -- 
            ,glbdef25 -- 
            ,glbdef26 -- 
            ,glbdef27 -- 
            ,glbdef28 -- 
            ,glbdef29 -- 
            ,glbdef30 -- 
            ,glbdef31 -- 
            ,glbdef32 -- 
            ,' ' as glbdef40 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from nhrs_bd_psndoc_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
