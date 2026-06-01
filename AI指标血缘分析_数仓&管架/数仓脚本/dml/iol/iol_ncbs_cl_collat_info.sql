/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_collat_info
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
create table ${iol_schema}.ncbs_cl_collat_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_collat_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_collat_info_op purge;
drop table ${iol_schema}.ncbs_cl_collat_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_collat_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_collat_info where 0=1;

create table ${iol_schema}.ncbs_cl_collat_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_collat_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_collat_info_cl(
            branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,channel_seq_no -- 全局流水号
            ,collat_no -- 押品编号
            ,collat_type -- 抵押品种类
            ,company -- 法人
            ,tran_seq_no -- 交易序号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,payment_direction -- 押品收付方向
            ,register_type -- 登记薄类型
            ,collat_amount -- 押品金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_collat_info_op(
            branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,channel_seq_no -- 全局流水号
            ,collat_no -- 押品编号
            ,collat_type -- 抵押品种类
            ,company -- 法人
            ,tran_seq_no -- 交易序号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,payment_direction -- 押品收付方向
            ,register_type -- 登记薄类型
            ,collat_amount -- 押品金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.channel_seq_no, o.channel_seq_no) as channel_seq_no -- 全局流水号
    ,nvl(n.collat_no, o.collat_no) as collat_no -- 押品编号
    ,nvl(n.collat_type, o.collat_type) as collat_type -- 抵押品种类
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.tran_seq_no, o.tran_seq_no) as tran_seq_no -- 交易序号
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.payment_direction, o.payment_direction) as payment_direction -- 押品收付方向
    ,nvl(n.register_type, o.register_type) as register_type -- 登记薄类型
    ,nvl(n.collat_amount, o.collat_amount) as collat_amount -- 押品金额
    ,case when
            n.internal_key is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_collat_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_collat_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
where (
        o.internal_key is null
    )
    or (
        n.internal_key is null
    )
    or (
        o.branch <> n.branch
        or o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.prod_type <> n.prod_type
        or o.remark <> n.remark
        or o.channel_seq_no <> n.channel_seq_no
        or o.collat_no <> n.collat_no
        or o.collat_type <> n.collat_type
        or o.company <> n.company
        or o.tran_seq_no <> n.tran_seq_no
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.payment_direction <> n.payment_direction
        or o.register_type <> n.register_type
        or o.collat_amount <> n.collat_amount
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_collat_info_cl(
            branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,channel_seq_no -- 全局流水号
            ,collat_no -- 押品编号
            ,collat_type -- 抵押品种类
            ,company -- 法人
            ,tran_seq_no -- 交易序号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,payment_direction -- 押品收付方向
            ,register_type -- 登记薄类型
            ,collat_amount -- 押品金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_collat_info_op(
            branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,remark -- 备注
            ,channel_seq_no -- 全局流水号
            ,collat_no -- 押品编号
            ,collat_type -- 抵押品种类
            ,company -- 法人
            ,tran_seq_no -- 交易序号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,payment_direction -- 押品收付方向
            ,register_type -- 登记薄类型
            ,collat_amount -- 押品金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branch -- 机构编号
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.remark -- 备注
    ,o.channel_seq_no -- 全局流水号
    ,o.collat_no -- 押品编号
    ,o.collat_type -- 抵押品种类
    ,o.company -- 法人
    ,o.tran_seq_no -- 交易序号
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.payment_direction -- 押品收付方向
    ,o.register_type -- 登记薄类型
    ,o.collat_amount -- 押品金额
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
from ${iol_schema}.ncbs_cl_collat_info_bk o
    left join ${iol_schema}.ncbs_cl_collat_info_op n
        on
            o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_collat_info_cl d
        on
            o.internal_key = d.internal_key
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_collat_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_collat_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_collat_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_collat_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_collat_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_collat_info_cl;
alter table ${iol_schema}.ncbs_cl_collat_info exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_collat_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_collat_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_collat_info_op purge;
drop table ${iol_schema}.ncbs_cl_collat_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_collat_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_collat_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
