/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_settle_card_holder_info
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
create table ${iol_schema}.ncbs_rb_settle_card_holder_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_settle_card_holder_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_settle_card_holder_info_op purge;
drop table ${iol_schema}.ncbs_rb_settle_card_holder_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_settle_card_holder_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_settle_card_holder_info where 0=1;

create table ${iol_schema}.ncbs_rb_settle_card_holder_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_settle_card_holder_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_settle_card_holder_info_cl(
            card_no -- 卡号
            ,client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,main_card_flag -- 主卡标识
            ,mobile_no -- 电话号码
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,ch_client_name -- 客户中文名称
            ,main_card_no -- 主卡卡号
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_settle_card_holder_info_op(
            card_no -- 卡号
            ,client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,main_card_flag -- 主卡标识
            ,mobile_no -- 电话号码
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,ch_client_name -- 客户中文名称
            ,main_card_no -- 主卡卡号
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.main_card_flag, o.main_card_flag) as main_card_flag -- 主卡标识
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 电话号码
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.ch_client_name, o.ch_client_name) as ch_client_name -- 客户中文名称
    ,nvl(n.main_card_no, o.main_card_no) as main_card_no -- 主卡卡号
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,case when
            n.card_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.card_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.card_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_settle_card_holder_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_settle_card_holder_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.card_no = n.card_no
where (
        o.card_no is null
    )
    or (
        n.card_no is null
    )
    or (
        o.client_no <> n.client_no
        or o.document_id <> n.document_id
        or o.document_type <> n.document_type
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.main_card_flag <> n.main_card_flag
        or o.mobile_no <> n.mobile_no
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.ch_client_name <> n.ch_client_name
        or o.main_card_no <> n.main_card_no
        or o.tran_branch <> n.tran_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_settle_card_holder_info_cl(
            card_no -- 卡号
            ,client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,main_card_flag -- 主卡标识
            ,mobile_no -- 电话号码
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,ch_client_name -- 客户中文名称
            ,main_card_no -- 主卡卡号
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_settle_card_holder_info_op(
            card_no -- 卡号
            ,client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,main_card_flag -- 主卡标识
            ,mobile_no -- 电话号码
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,ch_client_name -- 客户中文名称
            ,main_card_no -- 主卡卡号
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.card_no -- 卡号
    ,o.client_no -- 客户编号
    ,o.document_id -- 证件号码
    ,o.document_type -- 客户证件类型
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.main_card_flag -- 主卡标识
    ,o.mobile_no -- 电话号码
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.ch_client_name -- 客户中文名称
    ,o.main_card_no -- 主卡卡号
    ,o.tran_branch -- 核心交易机构编号
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
from ${iol_schema}.ncbs_rb_settle_card_holder_info_bk o
    left join ${iol_schema}.ncbs_rb_settle_card_holder_info_op n
        on
            o.card_no = n.card_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_settle_card_holder_info_cl d
        on
            o.card_no = d.card_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_settle_card_holder_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_settle_card_holder_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_settle_card_holder_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_settle_card_holder_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_settle_card_holder_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_settle_card_holder_info_cl;
alter table ${iol_schema}.ncbs_rb_settle_card_holder_info exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_settle_card_holder_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_settle_card_holder_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_settle_card_holder_info_op purge;
drop table ${iol_schema}.ncbs_rb_settle_card_holder_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_settle_card_holder_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_settle_card_holder_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
