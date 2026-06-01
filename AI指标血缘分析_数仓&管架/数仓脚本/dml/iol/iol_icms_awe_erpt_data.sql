/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_awe_erpt_data
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
create table ${iol_schema}.icms_awe_erpt_data_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_awe_erpt_data
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_awe_erpt_data_op purge;
drop table ${iol_schema}.icms_awe_erpt_data_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_awe_erpt_data_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_awe_erpt_data where 0=1;

create table ${iol_schema}.icms_awe_erpt_data_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_awe_erpt_data where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_awe_erpt_data_cl(
            serialno -- 流水号字段
            ,relativeserialno -- 对象编号
            ,treeno -- 排序号
            ,docid -- 文档编号
            ,dirid -- 目录编号
            ,dirname -- 目录名称
            ,guarantyno -- 关联担保号
            ,htmldata -- 内容
            ,contentlength -- 长度
            ,userid -- 登记人
            ,orgid -- 登记机构
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,score -- 评分
            ,scoredesc -- 评分描述
            ,saved -- 保存标志
            ,migtflag -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_awe_erpt_data_op(
            serialno -- 流水号字段
            ,relativeserialno -- 对象编号
            ,treeno -- 排序号
            ,docid -- 文档编号
            ,dirid -- 目录编号
            ,dirname -- 目录名称
            ,guarantyno -- 关联担保号
            ,htmldata -- 内容
            ,contentlength -- 长度
            ,userid -- 登记人
            ,orgid -- 登记机构
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,score -- 评分
            ,scoredesc -- 评分描述
            ,saved -- 保存标志
            ,migtflag -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号字段
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 对象编号
    ,nvl(n.treeno, o.treeno) as treeno -- 排序号
    ,nvl(n.docid, o.docid) as docid -- 文档编号
    ,nvl(n.dirid, o.dirid) as dirid -- 目录编号
    ,nvl(n.dirname, o.dirname) as dirname -- 目录名称
    ,nvl(n.guarantyno, o.guarantyno) as guarantyno -- 关联担保号
    ,nvl(n.htmldata, o.htmldata) as htmldata -- 内容
    ,nvl(n.contentlength, o.contentlength) as contentlength -- 长度
    ,nvl(n.userid, o.userid) as userid -- 登记人
    ,nvl(n.orgid, o.orgid) as orgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.score, o.score) as score -- 评分
    ,nvl(n.scoredesc, o.scoredesc) as scoredesc -- 评分描述
    ,nvl(n.saved, o.saved) as saved -- 保存标志
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志
    ,case when
            n.serialno is null
            and n.relativeserialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
            and n.relativeserialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
            and n.relativeserialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_awe_erpt_data_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_awe_erpt_data where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
            and o.relativeserialno = n.relativeserialno
where (
        o.serialno is null
        and o.relativeserialno is null
    )
    or (
        n.serialno is null
        and n.relativeserialno is null
    )
    or (
        o.treeno <> n.treeno
        or o.docid <> n.docid
        or o.dirid <> n.dirid
        or o.dirname <> n.dirname
        or o.guarantyno <> n.guarantyno
        or o.htmldata <> n.htmldata
        or o.contentlength <> n.contentlength
        or o.userid <> n.userid
        or o.orgid <> n.orgid
        or o.inputdate <> n.inputdate
        or o.updatedate <> n.updatedate
        or o.score <> n.score
        or o.scoredesc <> n.scoredesc
        or o.saved <> n.saved
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_awe_erpt_data_cl(
            serialno -- 流水号字段
            ,relativeserialno -- 对象编号
            ,treeno -- 排序号
            ,docid -- 文档编号
            ,dirid -- 目录编号
            ,dirname -- 目录名称
            ,guarantyno -- 关联担保号
            ,htmldata -- 内容
            ,contentlength -- 长度
            ,userid -- 登记人
            ,orgid -- 登记机构
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,score -- 评分
            ,scoredesc -- 评分描述
            ,saved -- 保存标志
            ,migtflag -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_awe_erpt_data_op(
            serialno -- 流水号字段
            ,relativeserialno -- 对象编号
            ,treeno -- 排序号
            ,docid -- 文档编号
            ,dirid -- 目录编号
            ,dirname -- 目录名称
            ,guarantyno -- 关联担保号
            ,htmldata -- 内容
            ,contentlength -- 长度
            ,userid -- 登记人
            ,orgid -- 登记机构
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,score -- 评分
            ,scoredesc -- 评分描述
            ,saved -- 保存标志
            ,migtflag -- 迁移标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号字段
    ,o.relativeserialno -- 对象编号
    ,o.treeno -- 排序号
    ,o.docid -- 文档编号
    ,o.dirid -- 目录编号
    ,o.dirname -- 目录名称
    ,o.guarantyno -- 关联担保号
    ,o.htmldata -- 内容
    ,o.contentlength -- 长度
    ,o.userid -- 登记人
    ,o.orgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updatedate -- 更新日期
    ,o.score -- 评分
    ,o.scoredesc -- 评分描述
    ,o.saved -- 保存标志
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
from ${iol_schema}.icms_awe_erpt_data_bk o
    left join ${iol_schema}.icms_awe_erpt_data_op n
        on
            o.serialno = n.serialno
            and o.relativeserialno = n.relativeserialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_awe_erpt_data_cl d
        on
            o.serialno = d.serialno
            and o.relativeserialno = d.relativeserialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_awe_erpt_data;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_awe_erpt_data') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_awe_erpt_data drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_awe_erpt_data add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_awe_erpt_data exchange partition p_${batch_date} with table ${iol_schema}.icms_awe_erpt_data_cl;
alter table ${iol_schema}.icms_awe_erpt_data exchange partition p_20991231 with table ${iol_schema}.icms_awe_erpt_data_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_awe_erpt_data to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_awe_erpt_data_op purge;
drop table ${iol_schema}.icms_awe_erpt_data_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_awe_erpt_data_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_awe_erpt_data',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
