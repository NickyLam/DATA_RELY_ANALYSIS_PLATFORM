/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_pph_dishonestpersoninc
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
create table ${iol_schema}.icms_pph_dishonestpersoninc_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_pph_dishonestpersoninc
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_pph_dishonestpersoninc_op purge;
drop table ${iol_schema}.icms_pph_dishonestpersoninc_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_pph_dishonestpersoninc_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_pph_dishonestpersoninc where 0=1;

create table ${iol_schema}.icms_pph_dishonestpersoninc_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_pph_dishonestpersoninc where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_pph_dishonestpersoninc_cl(
            serialno -- 主键ID
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,caseno -- 案号
            ,ptype -- 失信人类型
            ,inputdate -- 登记时间
            ,fulfildesc -- 被执行人的履行情况
            ,fufiled -- 已履行
            ,executecourt -- 执行法院
            ,username -- 被执行人姓名/名称
            ,pubdate -- 发布时间
            ,age -- 年龄
            ,idcardsignaddress -- 身份证原始发证地
            ,customerid -- 内部客户号
            ,aggreusername -- 法定代表人/负责人姓名
            ,obligation -- 生效法律文书确定的义务
            ,showexecutereasonorg -- 做出执行依据单位
            ,province -- 省份
            ,executefileno -- 执行依据文号
            ,behaviordesc -- 失信被执行人行为具体情形
            ,unfulfiled -- 未履行
            ,idno -- 身份证号码/工商注册号
            ,regdate -- 立案时间
            ,sex -- 性别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_pph_dishonestpersoninc_op(
            serialno -- 主键ID
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,caseno -- 案号
            ,ptype -- 失信人类型
            ,inputdate -- 登记时间
            ,fulfildesc -- 被执行人的履行情况
            ,fufiled -- 已履行
            ,executecourt -- 执行法院
            ,username -- 被执行人姓名/名称
            ,pubdate -- 发布时间
            ,age -- 年龄
            ,idcardsignaddress -- 身份证原始发证地
            ,customerid -- 内部客户号
            ,aggreusername -- 法定代表人/负责人姓名
            ,obligation -- 生效法律文书确定的义务
            ,showexecutereasonorg -- 做出执行依据单位
            ,province -- 省份
            ,executefileno -- 执行依据文号
            ,behaviordesc -- 失信被执行人行为具体情形
            ,unfulfiled -- 未履行
            ,idno -- 身份证号码/工商注册号
            ,regdate -- 立案时间
            ,sex -- 性别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 主键ID
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.caseno, o.caseno) as caseno -- 案号
    ,nvl(n.ptype, o.ptype) as ptype -- 失信人类型
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.fulfildesc, o.fulfildesc) as fulfildesc -- 被执行人的履行情况
    ,nvl(n.fufiled, o.fufiled) as fufiled -- 已履行
    ,nvl(n.executecourt, o.executecourt) as executecourt -- 执行法院
    ,nvl(n.username, o.username) as username -- 被执行人姓名/名称
    ,nvl(n.pubdate, o.pubdate) as pubdate -- 发布时间
    ,nvl(n.age, o.age) as age -- 年龄
    ,nvl(n.idcardsignaddress, o.idcardsignaddress) as idcardsignaddress -- 身份证原始发证地
    ,nvl(n.customerid, o.customerid) as customerid -- 内部客户号
    ,nvl(n.aggreusername, o.aggreusername) as aggreusername -- 法定代表人/负责人姓名
    ,nvl(n.obligation, o.obligation) as obligation -- 生效法律文书确定的义务
    ,nvl(n.showexecutereasonorg, o.showexecutereasonorg) as showexecutereasonorg -- 做出执行依据单位
    ,nvl(n.province, o.province) as province -- 省份
    ,nvl(n.executefileno, o.executefileno) as executefileno -- 执行依据文号
    ,nvl(n.behaviordesc, o.behaviordesc) as behaviordesc -- 失信被执行人行为具体情形
    ,nvl(n.unfulfiled, o.unfulfiled) as unfulfiled -- 未履行
    ,nvl(n.idno, o.idno) as idno -- 身份证号码/工商注册号
    ,nvl(n.regdate, o.regdate) as regdate -- 立案时间
    ,nvl(n.sex, o.sex) as sex -- 性别
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
from (select * from ${iol_schema}.icms_pph_dishonestpersoninc_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_pph_dishonestpersoninc where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.migtflag <> n.migtflag
        or o.caseno <> n.caseno
        or o.ptype <> n.ptype
        or o.inputdate <> n.inputdate
        or o.fulfildesc <> n.fulfildesc
        or o.fufiled <> n.fufiled
        or o.executecourt <> n.executecourt
        or o.username <> n.username
        or o.pubdate <> n.pubdate
        or o.age <> n.age
        or o.idcardsignaddress <> n.idcardsignaddress
        or o.customerid <> n.customerid
        or o.aggreusername <> n.aggreusername
        or o.obligation <> n.obligation
        or o.showexecutereasonorg <> n.showexecutereasonorg
        or o.province <> n.province
        or o.executefileno <> n.executefileno
        or o.behaviordesc <> n.behaviordesc
        or o.unfulfiled <> n.unfulfiled
        or o.idno <> n.idno
        or o.regdate <> n.regdate
        or o.sex <> n.sex
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_pph_dishonestpersoninc_cl(
            serialno -- 主键ID
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,caseno -- 案号
            ,ptype -- 失信人类型
            ,inputdate -- 登记时间
            ,fulfildesc -- 被执行人的履行情况
            ,fufiled -- 已履行
            ,executecourt -- 执行法院
            ,username -- 被执行人姓名/名称
            ,pubdate -- 发布时间
            ,age -- 年龄
            ,idcardsignaddress -- 身份证原始发证地
            ,customerid -- 内部客户号
            ,aggreusername -- 法定代表人/负责人姓名
            ,obligation -- 生效法律文书确定的义务
            ,showexecutereasonorg -- 做出执行依据单位
            ,province -- 省份
            ,executefileno -- 执行依据文号
            ,behaviordesc -- 失信被执行人行为具体情形
            ,unfulfiled -- 未履行
            ,idno -- 身份证号码/工商注册号
            ,regdate -- 立案时间
            ,sex -- 性别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_pph_dishonestpersoninc_op(
            serialno -- 主键ID
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,caseno -- 案号
            ,ptype -- 失信人类型
            ,inputdate -- 登记时间
            ,fulfildesc -- 被执行人的履行情况
            ,fufiled -- 已履行
            ,executecourt -- 执行法院
            ,username -- 被执行人姓名/名称
            ,pubdate -- 发布时间
            ,age -- 年龄
            ,idcardsignaddress -- 身份证原始发证地
            ,customerid -- 内部客户号
            ,aggreusername -- 法定代表人/负责人姓名
            ,obligation -- 生效法律文书确定的义务
            ,showexecutereasonorg -- 做出执行依据单位
            ,province -- 省份
            ,executefileno -- 执行依据文号
            ,behaviordesc -- 失信被执行人行为具体情形
            ,unfulfiled -- 未履行
            ,idno -- 身份证号码/工商注册号
            ,regdate -- 立案时间
            ,sex -- 性别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 主键ID
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.caseno -- 案号
    ,o.ptype -- 失信人类型
    ,o.inputdate -- 登记时间
    ,o.fulfildesc -- 被执行人的履行情况
    ,o.fufiled -- 已履行
    ,o.executecourt -- 执行法院
    ,o.username -- 被执行人姓名/名称
    ,o.pubdate -- 发布时间
    ,o.age -- 年龄
    ,o.idcardsignaddress -- 身份证原始发证地
    ,o.customerid -- 内部客户号
    ,o.aggreusername -- 法定代表人/负责人姓名
    ,o.obligation -- 生效法律文书确定的义务
    ,o.showexecutereasonorg -- 做出执行依据单位
    ,o.province -- 省份
    ,o.executefileno -- 执行依据文号
    ,o.behaviordesc -- 失信被执行人行为具体情形
    ,o.unfulfiled -- 未履行
    ,o.idno -- 身份证号码/工商注册号
    ,o.regdate -- 立案时间
    ,o.sex -- 性别
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
from ${iol_schema}.icms_pph_dishonestpersoninc_bk o
    left join ${iol_schema}.icms_pph_dishonestpersoninc_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_pph_dishonestpersoninc_cl d
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
--truncate table ${iol_schema}.icms_pph_dishonestpersoninc;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_pph_dishonestpersoninc') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_pph_dishonestpersoninc drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_pph_dishonestpersoninc add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_pph_dishonestpersoninc exchange partition p_${batch_date} with table ${iol_schema}.icms_pph_dishonestpersoninc_cl;
alter table ${iol_schema}.icms_pph_dishonestpersoninc exchange partition p_20991231 with table ${iol_schema}.icms_pph_dishonestpersoninc_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_pph_dishonestpersoninc to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_pph_dishonestpersoninc_op purge;
drop table ${iol_schema}.icms_pph_dishonestpersoninc_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_pph_dishonestpersoninc_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_pph_dishonestpersoninc',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
