/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_bctl_view
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
create table ${iol_schema}.bdms_bms_bctl_view_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_bctl_view
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_bctl_view_op purge;
drop table ${iol_schema}.bdms_bms_bctl_view_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_bctl_view_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_bctl_view where 0=1;

create table ${iol_schema}.bdms_bms_bctl_view_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_bctl_view where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_bctl_view_cl(
            id -- id
            ,br_no -- 外部机构号
            ,br_name -- 机构名称
            ,bank_no -- 联行行号
            ,br_class -- 机构级别 1-总行2-分行 3-个贷中心 5-支行
            ,br_attr -- 1-财务机构
            ,br_manager_id -- 总行id
            ,br_up_id -- 归属上级行999分行的上级行是9999 其他的分行级别的上级行是999分行
            ,tele_no -- 联系电话
            ,address -- 地址
            ,post_no -- 邮编
            ,ip -- ip
            ,finance_code -- 预留字段
            ,status -- 是否生效：0-无效1-有效
            ,update_userid -- 最后修改人
            ,update_date -- 最后更新时间
            ,is_del -- 是否已删除 0-未删除，1-已删除
            ,create_userid -- 创建人
            ,create_date -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_bctl_view_op(
            id -- id
            ,br_no -- 外部机构号
            ,br_name -- 机构名称
            ,bank_no -- 联行行号
            ,br_class -- 机构级别 1-总行2-分行 3-个贷中心 5-支行
            ,br_attr -- 1-财务机构
            ,br_manager_id -- 总行id
            ,br_up_id -- 归属上级行999分行的上级行是9999 其他的分行级别的上级行是999分行
            ,tele_no -- 联系电话
            ,address -- 地址
            ,post_no -- 邮编
            ,ip -- ip
            ,finance_code -- 预留字段
            ,status -- 是否生效：0-无效1-有效
            ,update_userid -- 最后修改人
            ,update_date -- 最后更新时间
            ,is_del -- 是否已删除 0-未删除，1-已删除
            ,create_userid -- 创建人
            ,create_date -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- id
    ,nvl(n.br_no, o.br_no) as br_no -- 外部机构号
    ,nvl(n.br_name, o.br_name) as br_name -- 机构名称
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 联行行号
    ,nvl(n.br_class, o.br_class) as br_class -- 机构级别 1-总行2-分行 3-个贷中心 5-支行
    ,nvl(n.br_attr, o.br_attr) as br_attr -- 1-财务机构
    ,nvl(n.br_manager_id, o.br_manager_id) as br_manager_id -- 总行id
    ,nvl(n.br_up_id, o.br_up_id) as br_up_id -- 归属上级行999分行的上级行是9999 其他的分行级别的上级行是999分行
    ,nvl(n.tele_no, o.tele_no) as tele_no -- 联系电话
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.post_no, o.post_no) as post_no -- 邮编
    ,nvl(n.ip, o.ip) as ip -- ip
    ,nvl(n.finance_code, o.finance_code) as finance_code -- 预留字段
    ,nvl(n.status, o.status) as status -- 是否生效：0-无效1-有效
    ,nvl(n.update_userid, o.update_userid) as update_userid -- 最后修改人
    ,nvl(n.update_date, o.update_date) as update_date -- 最后更新时间
    ,nvl(n.is_del, o.is_del) as is_del -- 是否已删除 0-未删除，1-已删除
    ,nvl(n.create_userid, o.create_userid) as create_userid -- 创建人
    ,nvl(n.create_date, o.create_date) as create_date -- 创建时间
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_bms_bctl_view_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_bctl_view where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.br_no <> n.br_no
        or o.br_name <> n.br_name
        or o.bank_no <> n.bank_no
        or o.br_class <> n.br_class
        or o.br_attr <> n.br_attr
        or o.br_manager_id <> n.br_manager_id
        or o.br_up_id <> n.br_up_id
        or o.tele_no <> n.tele_no
        or o.address <> n.address
        or o.post_no <> n.post_no
        or o.ip <> n.ip
        or o.finance_code <> n.finance_code
        or o.status <> n.status
        or o.update_userid <> n.update_userid
        or o.update_date <> n.update_date
        or o.is_del <> n.is_del
        or o.create_userid <> n.create_userid
        or o.create_date <> n.create_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_bctl_view_cl(
            id -- id
            ,br_no -- 外部机构号
            ,br_name -- 机构名称
            ,bank_no -- 联行行号
            ,br_class -- 机构级别 1-总行2-分行 3-个贷中心 5-支行
            ,br_attr -- 1-财务机构
            ,br_manager_id -- 总行id
            ,br_up_id -- 归属上级行999分行的上级行是9999 其他的分行级别的上级行是999分行
            ,tele_no -- 联系电话
            ,address -- 地址
            ,post_no -- 邮编
            ,ip -- ip
            ,finance_code -- 预留字段
            ,status -- 是否生效：0-无效1-有效
            ,update_userid -- 最后修改人
            ,update_date -- 最后更新时间
            ,is_del -- 是否已删除 0-未删除，1-已删除
            ,create_userid -- 创建人
            ,create_date -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_bctl_view_op(
            id -- id
            ,br_no -- 外部机构号
            ,br_name -- 机构名称
            ,bank_no -- 联行行号
            ,br_class -- 机构级别 1-总行2-分行 3-个贷中心 5-支行
            ,br_attr -- 1-财务机构
            ,br_manager_id -- 总行id
            ,br_up_id -- 归属上级行999分行的上级行是9999 其他的分行级别的上级行是999分行
            ,tele_no -- 联系电话
            ,address -- 地址
            ,post_no -- 邮编
            ,ip -- ip
            ,finance_code -- 预留字段
            ,status -- 是否生效：0-无效1-有效
            ,update_userid -- 最后修改人
            ,update_date -- 最后更新时间
            ,is_del -- 是否已删除 0-未删除，1-已删除
            ,create_userid -- 创建人
            ,create_date -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- id
    ,o.br_no -- 外部机构号
    ,o.br_name -- 机构名称
    ,o.bank_no -- 联行行号
    ,o.br_class -- 机构级别 1-总行2-分行 3-个贷中心 5-支行
    ,o.br_attr -- 1-财务机构
    ,o.br_manager_id -- 总行id
    ,o.br_up_id -- 归属上级行999分行的上级行是9999 其他的分行级别的上级行是999分行
    ,o.tele_no -- 联系电话
    ,o.address -- 地址
    ,o.post_no -- 邮编
    ,o.ip -- ip
    ,o.finance_code -- 预留字段
    ,o.status -- 是否生效：0-无效1-有效
    ,o.update_userid -- 最后修改人
    ,o.update_date -- 最后更新时间
    ,o.is_del -- 是否已删除 0-未删除，1-已删除
    ,o.create_userid -- 创建人
    ,o.create_date -- 创建时间
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
from ${iol_schema}.bdms_bms_bctl_view_bk o
    left join ${iol_schema}.bdms_bms_bctl_view_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_bctl_view_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_bms_bctl_view;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_bctl_view') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_bctl_view drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_bctl_view add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_bctl_view exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_bctl_view_cl;
alter table ${iol_schema}.bdms_bms_bctl_view exchange partition p_20991231 with table ${iol_schema}.bdms_bms_bctl_view_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_bctl_view to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_bctl_view_op purge;
drop table ${iol_schema}.bdms_bms_bctl_view_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_bctl_view_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_bctl_view',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
