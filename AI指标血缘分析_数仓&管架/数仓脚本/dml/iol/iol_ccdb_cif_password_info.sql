/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ccdb_cif_password_info
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
whenever sqlerror continue none ;
create table ${iol_schema}.ccdb_cif_password_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ccdb_cif_password_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccdb_cif_password_info_op purge;
drop table ${iol_schema}.ccdb_cif_password_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_cif_password_info_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ccdb_cif_password_info where 0=1;

create table ${iol_schema}.ccdb_cif_password_info_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ccdb_cif_password_info where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.ccdb_cif_password_info_op(
        id -- 流水号
        ,customer_no -- 客户号
        ,business_type -- 业务类型
        ,password_type -- 密码类型
        ,status -- 状态
        ,update_date -- 更新日期
        ,version -- 版本号
        ,card_no -- 账号
        ,password -- 密码（密文）
        ,from_channel -- 请求渠道
        ,verify_error_num -- 验证错误次数
        ,verify_record_date -- 验证日期
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.id -- 流水号
    ,n.customer_no -- 客户号
    ,n.business_type -- 业务类型
    ,n.password_type -- 密码类型
    ,n.status -- 状态
    ,n.update_date -- 更新日期
    ,n.version -- 版本号
    ,n.card_no -- 账号
    ,n.password -- 密码（密文）
    ,n.from_channel -- 请求渠道
    ,n.verify_error_num -- 验证错误次数
    ,n.verify_record_date -- 验证日期
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ccdb_cif_password_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.ccdb_cif_password_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.verify_record_date = n.verify_record_date
where (
        o.verify_record_date is null
    )
    or (
        o.id <> n.id
        or o.customer_no <> n.customer_no
        or o.business_type <> n.business_type
        or o.password_type <> n.password_type
        or o.status <> n.status
        or o.update_date <> n.update_date
        or o.version <> n.version
        or o.card_no <> n.card_no
        or o.password <> n.password
        or o.from_channel <> n.from_channel
        or o.verify_error_num <> n.verify_error_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ccdb_cif_password_info_cl(
            id -- 流水号
        ,customer_no -- 客户号
        ,business_type -- 业务类型
        ,password_type -- 密码类型
        ,status -- 状态
        ,update_date -- 更新日期
        ,version -- 版本号
        ,card_no -- 账号
        ,password -- 密码（密文）
        ,from_channel -- 请求渠道
        ,verify_error_num -- 验证错误次数
        ,verify_record_date -- 验证日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ccdb_cif_password_info_op(
            id -- 流水号
        ,customer_no -- 客户号
        ,business_type -- 业务类型
        ,password_type -- 密码类型
        ,status -- 状态
        ,update_date -- 更新日期
        ,version -- 版本号
        ,card_no -- 账号
        ,password -- 密码（密文）
        ,from_channel -- 请求渠道
        ,verify_error_num -- 验证错误次数
        ,verify_record_date -- 验证日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 流水号
    ,o.customer_no -- 客户号
    ,o.business_type -- 业务类型
    ,o.password_type -- 密码类型
    ,o.status -- 状态
    ,o.update_date -- 更新日期
    ,o.version -- 版本号
    ,o.card_no -- 账号
    ,o.password -- 密码（密文）
    ,o.from_channel -- 请求渠道
    ,o.verify_error_num -- 验证错误次数
    ,o.verify_record_date -- 验证日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ccdb_cif_password_info_bk o
    left join ${iol_schema}.ccdb_cif_password_info_op n
        on
            o.verify_record_date = n.verify_record_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ccdb_cif_password_info;

-- 4.2 exchange partition
alter table ${iol_schema}.ccdb_cif_password_info exchange partition p_19000101 with table ${iol_schema}.ccdb_cif_password_info_cl;
alter table ${iol_schema}.ccdb_cif_password_info exchange partition p_20991231 with table ${iol_schema}.ccdb_cif_password_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ccdb_cif_password_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccdb_cif_password_info_op purge;
drop table ${iol_schema}.ccdb_cif_password_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ccdb_cif_password_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ccdb_cif_password_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
