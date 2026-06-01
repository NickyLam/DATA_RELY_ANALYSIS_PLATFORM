/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_cms_bank
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
create table ${iol_schema}.amss_cms_bank_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_cms_bank
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_bank_op purge;
drop table ${iol_schema}.amss_cms_bank_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_bank_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_bank where 0=1;

create table ${iol_schema}.amss_cms_bank_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_bank where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_bank_cl(
            bank_id -- 银行ID.
            ,bank_type -- 银行类型.1:总行;2:分行
            ,bank_name -- 银行名称.
            ,bank_no -- 银行编码.银行在我们系统中分配的编码,生成渠道编号时要用到
            ,bank_letter_no -- 银行英文编码.银行在我们系统中分配的英文编码,导入导出时要用到
            ,bank_tel -- 银行电话.
            ,bank_letter_code -- 银行英文缩写.
            ,remark -- 备注.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,bank_code -- 银行代码（兴业提供的广义联行号）
            ,platform_version -- 银行所属平台字段
            ,deprecated -- 是否废弃
            ,deprecated_comment -- 废弃注释
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_bank_op(
            bank_id -- 银行ID.
            ,bank_type -- 银行类型.1:总行;2:分行
            ,bank_name -- 银行名称.
            ,bank_no -- 银行编码.银行在我们系统中分配的编码,生成渠道编号时要用到
            ,bank_letter_no -- 银行英文编码.银行在我们系统中分配的英文编码,导入导出时要用到
            ,bank_tel -- 银行电话.
            ,bank_letter_code -- 银行英文缩写.
            ,remark -- 备注.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,bank_code -- 银行代码（兴业提供的广义联行号）
            ,platform_version -- 银行所属平台字段
            ,deprecated -- 是否废弃
            ,deprecated_comment -- 废弃注释
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bank_id, o.bank_id) as bank_id -- 银行ID.
    ,nvl(n.bank_type, o.bank_type) as bank_type -- 银行类型.1:总行;2:分行
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 银行名称.
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行编码.银行在我们系统中分配的编码,生成渠道编号时要用到
    ,nvl(n.bank_letter_no, o.bank_letter_no) as bank_letter_no -- 银行英文编码.银行在我们系统中分配的英文编码,导入导出时要用到
    ,nvl(n.bank_tel, o.bank_tel) as bank_tel -- 银行电话.
    ,nvl(n.bank_letter_code, o.bank_letter_code) as bank_letter_code -- 银行英文缩写.
    ,nvl(n.remark, o.remark) as remark -- 备注.
    ,nvl(n.create_user, o.create_user) as create_user -- 创建用户.
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建人.
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间.
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间.
    ,nvl(n.bank_code, o.bank_code) as bank_code -- 银行代码（兴业提供的广义联行号）
    ,nvl(n.platform_version, o.platform_version) as platform_version -- 银行所属平台字段
    ,nvl(n.deprecated, o.deprecated) as deprecated -- 是否废弃
    ,nvl(n.deprecated_comment, o.deprecated_comment) as deprecated_comment -- 废弃注释
    ,case when
            n.bank_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bank_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bank_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_cms_bank_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_cms_bank where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bank_id = n.bank_id
where (
        o.bank_id is null
    )
    or (
        n.bank_id is null
    )
    or (
        o.bank_type <> n.bank_type
        or o.bank_name <> n.bank_name
        or o.bank_no <> n.bank_no
        or o.bank_letter_no <> n.bank_letter_no
        or o.bank_tel <> n.bank_tel
        or o.bank_letter_code <> n.bank_letter_code
        or o.remark <> n.remark
        or o.create_user <> n.create_user
        or o.create_emp <> n.create_emp
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.bank_code <> n.bank_code
        or o.platform_version <> n.platform_version
        or o.deprecated <> n.deprecated
        or o.deprecated_comment <> n.deprecated_comment
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_bank_cl(
            bank_id -- 银行ID.
            ,bank_type -- 银行类型.1:总行;2:分行
            ,bank_name -- 银行名称.
            ,bank_no -- 银行编码.银行在我们系统中分配的编码,生成渠道编号时要用到
            ,bank_letter_no -- 银行英文编码.银行在我们系统中分配的英文编码,导入导出时要用到
            ,bank_tel -- 银行电话.
            ,bank_letter_code -- 银行英文缩写.
            ,remark -- 备注.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,bank_code -- 银行代码（兴业提供的广义联行号）
            ,platform_version -- 银行所属平台字段
            ,deprecated -- 是否废弃
            ,deprecated_comment -- 废弃注释
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_bank_op(
            bank_id -- 银行ID.
            ,bank_type -- 银行类型.1:总行;2:分行
            ,bank_name -- 银行名称.
            ,bank_no -- 银行编码.银行在我们系统中分配的编码,生成渠道编号时要用到
            ,bank_letter_no -- 银行英文编码.银行在我们系统中分配的英文编码,导入导出时要用到
            ,bank_tel -- 银行电话.
            ,bank_letter_code -- 银行英文缩写.
            ,remark -- 备注.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,bank_code -- 银行代码（兴业提供的广义联行号）
            ,platform_version -- 银行所属平台字段
            ,deprecated -- 是否废弃
            ,deprecated_comment -- 废弃注释
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bank_id -- 银行ID.
    ,o.bank_type -- 银行类型.1:总行;2:分行
    ,o.bank_name -- 银行名称.
    ,o.bank_no -- 银行编码.银行在我们系统中分配的编码,生成渠道编号时要用到
    ,o.bank_letter_no -- 银行英文编码.银行在我们系统中分配的英文编码,导入导出时要用到
    ,o.bank_tel -- 银行电话.
    ,o.bank_letter_code -- 银行英文缩写.
    ,o.remark -- 备注.
    ,o.create_user -- 创建用户.
    ,o.create_emp -- 创建人.
    ,o.create_time -- 创建时间.
    ,o.update_time -- 更新时间.
    ,o.bank_code -- 银行代码（兴业提供的广义联行号）
    ,o.platform_version -- 银行所属平台字段
    ,o.deprecated -- 是否废弃
    ,o.deprecated_comment -- 废弃注释
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
from ${iol_schema}.amss_cms_bank_bk o
    left join ${iol_schema}.amss_cms_bank_op n
        on
            o.bank_id = n.bank_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_cms_bank_cl d
        on
            o.bank_id = d.bank_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_cms_bank;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_cms_bank') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_cms_bank drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_cms_bank add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_cms_bank exchange partition p_${batch_date} with table ${iol_schema}.amss_cms_bank_cl;
alter table ${iol_schema}.amss_cms_bank exchange partition p_20991231 with table ${iol_schema}.amss_cms_bank_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_cms_bank to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_bank_op purge;
drop table ${iol_schema}.amss_cms_bank_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_cms_bank_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_cms_bank',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
