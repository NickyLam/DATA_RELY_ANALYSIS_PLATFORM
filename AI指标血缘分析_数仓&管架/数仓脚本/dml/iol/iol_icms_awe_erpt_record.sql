/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_awe_erpt_record
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.icms_awe_erpt_record_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_awe_erpt_record
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_awe_erpt_record_op purge;
drop table ${iol_schema}.icms_awe_erpt_record_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_awe_erpt_record_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_awe_erpt_record where 0=1;

create table ${iol_schema}.icms_awe_erpt_record_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_awe_erpt_record where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_awe_erpt_record_cl(
            serialno -- 流水号字段
            ,attribute4 -- 属性4
            ,updatedate -- 更新日期
            ,attribute2 -- 属性2
            ,attribute3 -- 属性3
            ,attribute5 -- 属性5
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,offlineversion -- 离线报告最新版本号
            ,savepath -- 保存路径
            ,docid -- 文档类型编号
            ,attribute1 -- 属性1
            ,savedate -- 生成报告日期
            ,orgid -- 登记机构
            ,userid -- 登记人
            ,inputdate -- 登记日期
            ,migtflag -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_awe_erpt_record_op(
            serialno -- 流水号字段
            ,attribute4 -- 属性4
            ,updatedate -- 更新日期
            ,attribute2 -- 属性2
            ,attribute3 -- 属性3
            ,attribute5 -- 属性5
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,offlineversion -- 离线报告最新版本号
            ,savepath -- 保存路径
            ,docid -- 文档类型编号
            ,attribute1 -- 属性1
            ,savedate -- 生成报告日期
            ,orgid -- 登记机构
            ,userid -- 登记人
            ,inputdate -- 登记日期
            ,migtflag -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号字段
    ,nvl(n.attribute4, o.attribute4) as attribute4 -- 属性4
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 属性2
    ,nvl(n.attribute3, o.attribute3) as attribute3 -- 属性3
    ,nvl(n.attribute5, o.attribute5) as attribute5 -- 属性5
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.objectno, o.objectno) as objectno -- 对象编号
    ,nvl(n.offlineversion, o.offlineversion) as offlineversion -- 离线报告最新版本号
    ,nvl(n.savepath, o.savepath) as savepath -- 保存路径
    ,nvl(n.docid, o.docid) as docid -- 文档类型编号
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 属性1
    ,nvl(n.savedate, o.savedate) as savedate -- 生成报告日期
    ,nvl(n.orgid, o.orgid) as orgid -- 登记机构
    ,nvl(n.userid, o.userid) as userid -- 登记人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_awe_erpt_record_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_awe_erpt_record where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.attribute4 <> n.attribute4
        or o.updatedate <> n.updatedate
        or o.attribute2 <> n.attribute2
        or o.attribute3 <> n.attribute3
        or o.attribute5 <> n.attribute5
        or o.objecttype <> n.objecttype
        or o.objectno <> n.objectno
        or o.offlineversion <> n.offlineversion
        or o.savepath <> n.savepath
        or o.docid <> n.docid
        or o.attribute1 <> n.attribute1
        or o.savedate <> n.savedate
        or o.orgid <> n.orgid
        or o.userid <> n.userid
        or o.inputdate <> n.inputdate
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_awe_erpt_record_cl(
            serialno -- 流水号字段
            ,attribute4 -- 属性4
            ,updatedate -- 更新日期
            ,attribute2 -- 属性2
            ,attribute3 -- 属性3
            ,attribute5 -- 属性5
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,offlineversion -- 离线报告最新版本号
            ,savepath -- 保存路径
            ,docid -- 文档类型编号
            ,attribute1 -- 属性1
            ,savedate -- 生成报告日期
            ,orgid -- 登记机构
            ,userid -- 登记人
            ,inputdate -- 登记日期
            ,migtflag -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_awe_erpt_record_op(
            serialno -- 流水号字段
            ,attribute4 -- 属性4
            ,updatedate -- 更新日期
            ,attribute2 -- 属性2
            ,attribute3 -- 属性3
            ,attribute5 -- 属性5
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,offlineversion -- 离线报告最新版本号
            ,savepath -- 保存路径
            ,docid -- 文档类型编号
            ,attribute1 -- 属性1
            ,savedate -- 生成报告日期
            ,orgid -- 登记机构
            ,userid -- 登记人
            ,inputdate -- 登记日期
            ,migtflag -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号字段
    ,o.attribute4 -- 属性4
    ,o.updatedate -- 更新日期
    ,o.attribute2 -- 属性2
    ,o.attribute3 -- 属性3
    ,o.attribute5 -- 属性5
    ,o.objecttype -- 对象类型
    ,o.objectno -- 对象编号
    ,o.offlineversion -- 离线报告最新版本号
    ,o.savepath -- 保存路径
    ,o.docid -- 文档类型编号
    ,o.attribute1 -- 属性1
    ,o.savedate -- 生成报告日期
    ,o.orgid -- 登记机构
    ,o.userid -- 登记人
    ,o.inputdate -- 登记日期
    ,o.migtflag -- 迁移标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_awe_erpt_record_bk o
    left join ${iol_schema}.icms_awe_erpt_record_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_awe_erpt_record_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_awe_erpt_record;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_awe_erpt_record') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_awe_erpt_record drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_awe_erpt_record add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_awe_erpt_record exchange partition p_${batch_date} with table ${iol_schema}.icms_awe_erpt_record_cl;
alter table ${iol_schema}.icms_awe_erpt_record exchange partition p_20991231 with table ${iol_schema}.icms_awe_erpt_record_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_awe_erpt_record to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_awe_erpt_record_op purge;
drop table ${iol_schema}.icms_awe_erpt_record_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_awe_erpt_record_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_awe_erpt_record',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
