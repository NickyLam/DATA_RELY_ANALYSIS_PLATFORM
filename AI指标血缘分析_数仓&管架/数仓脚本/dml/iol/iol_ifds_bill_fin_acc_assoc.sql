/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifds_bill_fin_acc_assoc
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
create table ${iol_schema}.ifds_bill_fin_acc_assoc_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifds_bill_fin_acc_assoc
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifds_bill_fin_acc_assoc_op purge;
drop table ${iol_schema}.ifds_bill_fin_acc_assoc_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifds_bill_fin_acc_assoc_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifds_bill_fin_acc_assoc where 0=1;

create table ${iol_schema}.ifds_bill_fin_acc_assoc_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifds_bill_fin_acc_assoc where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifds_bill_fin_acc_assoc_cl(
            billing_account_id -- E账户编号
            ,fin_account_id -- 产品账户账号
            ,party_id -- 当事人编号
            ,third_party_id -- 商户编号
            ,product_id -- 产品编号0900100100201-活期户 0900100100202-新活期户 0900500100204-P2P1.0 0900500100205-P2P2.0 0900500100206-P2B(对公户) 0900500100207-P2P3.0
            ,account_role_type_id -- 账户角色类型编号
            ,imprinted_name -- 特征名称
            ,from_date -- 生效日期
            ,thru_date -- 失效日期
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,account_no -- 内部账户
            ,medium_type_id -- 介质类型00-虚拟卡号 01-实体卡号 02-本地凭证
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifds_bill_fin_acc_assoc_op(
            billing_account_id -- E账户编号
            ,fin_account_id -- 产品账户账号
            ,party_id -- 当事人编号
            ,third_party_id -- 商户编号
            ,product_id -- 产品编号0900100100201-活期户 0900100100202-新活期户 0900500100204-P2P1.0 0900500100205-P2P2.0 0900500100206-P2B(对公户) 0900500100207-P2P3.0
            ,account_role_type_id -- 账户角色类型编号
            ,imprinted_name -- 特征名称
            ,from_date -- 生效日期
            ,thru_date -- 失效日期
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,account_no -- 内部账户
            ,medium_type_id -- 介质类型00-虚拟卡号 01-实体卡号 02-本地凭证
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.billing_account_id, o.billing_account_id) as billing_account_id -- E账户编号
    ,nvl(n.fin_account_id, o.fin_account_id) as fin_account_id -- 产品账户账号
    ,nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.third_party_id, o.third_party_id) as third_party_id -- 商户编号
    ,nvl(n.product_id, o.product_id) as product_id -- 产品编号0900100100201-活期户 0900100100202-新活期户 0900500100204-P2P1.0 0900500100205-P2P2.0 0900500100206-P2B(对公户) 0900500100207-P2P3.0
    ,nvl(n.account_role_type_id, o.account_role_type_id) as account_role_type_id -- 账户角色类型编号
    ,nvl(n.imprinted_name, o.imprinted_name) as imprinted_name -- 特征名称
    ,nvl(n.from_date, o.from_date) as from_date -- 生效日期
    ,nvl(n.thru_date, o.thru_date) as thru_date -- 失效日期
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- 最后更新时间
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- 最后更新事务时间
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- 创建时间
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- 创建事务时间
    ,nvl(n.account_no, o.account_no) as account_no -- 内部账户
    ,nvl(n.medium_type_id, o.medium_type_id) as medium_type_id -- 介质类型00-虚拟卡号 01-实体卡号 02-本地凭证
    ,case when
            n.billing_account_id is null
            and n.fin_account_id is null
            and n.from_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.billing_account_id is null
            and n.fin_account_id is null
            and n.from_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.billing_account_id is null
            and n.fin_account_id is null
            and n.from_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifds_bill_fin_acc_assoc_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifds_bill_fin_acc_assoc where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.billing_account_id = n.billing_account_id
            and o.fin_account_id = n.fin_account_id
            and o.from_date = n.from_date
where (
        o.billing_account_id is null
        and o.fin_account_id is null
        and o.from_date is null
    )
    or (
        n.billing_account_id is null
        and n.fin_account_id is null
        and n.from_date is null
    )
    or (
        o.party_id <> n.party_id
        or o.third_party_id <> n.third_party_id
        or o.product_id <> n.product_id
        or o.account_role_type_id <> n.account_role_type_id
        or o.imprinted_name <> n.imprinted_name
        or o.thru_date <> n.thru_date
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
        or o.account_no <> n.account_no
        or o.medium_type_id <> n.medium_type_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifds_bill_fin_acc_assoc_cl(
            billing_account_id -- E账户编号
            ,fin_account_id -- 产品账户账号
            ,party_id -- 当事人编号
            ,third_party_id -- 商户编号
            ,product_id -- 产品编号0900100100201-活期户 0900100100202-新活期户 0900500100204-P2P1.0 0900500100205-P2P2.0 0900500100206-P2B(对公户) 0900500100207-P2P3.0
            ,account_role_type_id -- 账户角色类型编号
            ,imprinted_name -- 特征名称
            ,from_date -- 生效日期
            ,thru_date -- 失效日期
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,account_no -- 内部账户
            ,medium_type_id -- 介质类型00-虚拟卡号 01-实体卡号 02-本地凭证
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifds_bill_fin_acc_assoc_op(
            billing_account_id -- E账户编号
            ,fin_account_id -- 产品账户账号
            ,party_id -- 当事人编号
            ,third_party_id -- 商户编号
            ,product_id -- 产品编号0900100100201-活期户 0900100100202-新活期户 0900500100204-P2P1.0 0900500100205-P2P2.0 0900500100206-P2B(对公户) 0900500100207-P2P3.0
            ,account_role_type_id -- 账户角色类型编号
            ,imprinted_name -- 特征名称
            ,from_date -- 生效日期
            ,thru_date -- 失效日期
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,account_no -- 内部账户
            ,medium_type_id -- 介质类型00-虚拟卡号 01-实体卡号 02-本地凭证
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.billing_account_id -- E账户编号
    ,o.fin_account_id -- 产品账户账号
    ,o.party_id -- 当事人编号
    ,o.third_party_id -- 商户编号
    ,o.product_id -- 产品编号0900100100201-活期户 0900100100202-新活期户 0900500100204-P2P1.0 0900500100205-P2P2.0 0900500100206-P2B(对公户) 0900500100207-P2P3.0
    ,o.account_role_type_id -- 账户角色类型编号
    ,o.imprinted_name -- 特征名称
    ,o.from_date -- 生效日期
    ,o.thru_date -- 失效日期
    ,o.last_updated_stamp -- 最后更新时间
    ,o.last_updated_tx_stamp -- 最后更新事务时间
    ,o.created_stamp -- 创建时间
    ,o.created_tx_stamp -- 创建事务时间
    ,o.account_no -- 内部账户
    ,o.medium_type_id -- 介质类型00-虚拟卡号 01-实体卡号 02-本地凭证
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
from ${iol_schema}.ifds_bill_fin_acc_assoc_bk o
    left join ${iol_schema}.ifds_bill_fin_acc_assoc_op n
        on
            o.billing_account_id = n.billing_account_id
            and o.fin_account_id = n.fin_account_id
            and o.from_date = n.from_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifds_bill_fin_acc_assoc_cl d
        on
            o.billing_account_id = d.billing_account_id
            and o.fin_account_id = d.fin_account_id
            and o.from_date = d.from_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ifds_bill_fin_acc_assoc;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ifds_bill_fin_acc_assoc') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ifds_bill_fin_acc_assoc drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ifds_bill_fin_acc_assoc add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ifds_bill_fin_acc_assoc exchange partition p_${batch_date} with table ${iol_schema}.ifds_bill_fin_acc_assoc_cl;
alter table ${iol_schema}.ifds_bill_fin_acc_assoc exchange partition p_20991231 with table ${iol_schema}.ifds_bill_fin_acc_assoc_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifds_bill_fin_acc_assoc to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifds_bill_fin_acc_assoc_op purge;
drop table ${iol_schema}.ifds_bill_fin_acc_assoc_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifds_bill_fin_acc_assoc_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifds_bill_fin_acc_assoc',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
