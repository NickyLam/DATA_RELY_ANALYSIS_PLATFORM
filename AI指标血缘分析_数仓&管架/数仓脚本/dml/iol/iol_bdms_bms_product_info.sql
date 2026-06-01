/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_product_info
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
create table ${iol_schema}.bdms_bms_product_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_product_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_product_info_op purge;
drop table ${iol_schema}.bdms_bms_product_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_product_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_product_info where 0=1;

create table ${iol_schema}.bdms_bms_product_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_product_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_product_info_cl(
            id -- 
            ,product_name -- 产品名称
            ,product_no -- 产品号
            ,busi_type -- 业务种类
            ,busi_attr_name -- 业务属性名称
            ,busi_attr_no -- 业务属性号
            ,draft_attr -- 票据属性
            ,draft_type -- 票据类型
            ,dualcontrol_lockstatus -- 双岗复核锁标记
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,status -- 状态
            ,trans_no -- 
            ,top_branch_no -- 所属总行机构
            ,jiti_type -- 计提类型 1;贴现 2:转贴现 3:买入质押式回购 4:买入买断式回购 5:卖出质押式回购 6:卖出买断式回购 7.再贴现回购
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_product_info_op(
            id -- 
            ,product_name -- 产品名称
            ,product_no -- 产品号
            ,busi_type -- 业务种类
            ,busi_attr_name -- 业务属性名称
            ,busi_attr_no -- 业务属性号
            ,draft_attr -- 票据属性
            ,draft_type -- 票据类型
            ,dualcontrol_lockstatus -- 双岗复核锁标记
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,status -- 状态
            ,trans_no -- 
            ,top_branch_no -- 所属总行机构
            ,jiti_type -- 计提类型 1;贴现 2:转贴现 3:买入质押式回购 4:买入买断式回购 5:卖出质押式回购 6:卖出买断式回购 7.再贴现回购
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.product_name, o.product_name) as product_name -- 产品名称
    ,nvl(n.product_no, o.product_no) as product_no -- 产品号
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务种类
    ,nvl(n.busi_attr_name, o.busi_attr_name) as busi_attr_name -- 业务属性名称
    ,nvl(n.busi_attr_no, o.busi_attr_no) as busi_attr_no -- 业务属性号
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据属性
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型
    ,nvl(n.dualcontrol_lockstatus, o.dualcontrol_lockstatus) as dualcontrol_lockstatus -- 双岗复核锁标记
    ,nvl(n.last_operator_no, o.last_operator_no) as last_operator_no -- 最后操作员编号
    ,nvl(n.last_txn_date, o.last_txn_date) as last_txn_date -- 最后操作日期
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.trans_no, o.trans_no) as trans_no -- 
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 所属总行机构
    ,nvl(n.jiti_type, o.jiti_type) as jiti_type -- 计提类型 1;贴现 2:转贴现 3:买入质押式回购 4:买入买断式回购 5:卖出质押式回购 6:卖出买断式回购 7.再贴现回购
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
from (select * from ${iol_schema}.bdms_bms_product_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_product_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.product_name <> n.product_name
        or o.product_no <> n.product_no
        or o.busi_type <> n.busi_type
        or o.busi_attr_name <> n.busi_attr_name
        or o.busi_attr_no <> n.busi_attr_no
        or o.draft_attr <> n.draft_attr
        or o.draft_type <> n.draft_type
        or o.dualcontrol_lockstatus <> n.dualcontrol_lockstatus
        or o.last_operator_no <> n.last_operator_no
        or o.last_txn_date <> n.last_txn_date
        or o.status <> n.status
        or o.trans_no <> n.trans_no
        or o.top_branch_no <> n.top_branch_no
        or o.jiti_type <> n.jiti_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_product_info_cl(
            id -- 
            ,product_name -- 产品名称
            ,product_no -- 产品号
            ,busi_type -- 业务种类
            ,busi_attr_name -- 业务属性名称
            ,busi_attr_no -- 业务属性号
            ,draft_attr -- 票据属性
            ,draft_type -- 票据类型
            ,dualcontrol_lockstatus -- 双岗复核锁标记
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,status -- 状态
            ,trans_no -- 
            ,top_branch_no -- 所属总行机构
            ,jiti_type -- 计提类型 1;贴现 2:转贴现 3:买入质押式回购 4:买入买断式回购 5:卖出质押式回购 6:卖出买断式回购 7.再贴现回购
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_product_info_op(
            id -- 
            ,product_name -- 产品名称
            ,product_no -- 产品号
            ,busi_type -- 业务种类
            ,busi_attr_name -- 业务属性名称
            ,busi_attr_no -- 业务属性号
            ,draft_attr -- 票据属性
            ,draft_type -- 票据类型
            ,dualcontrol_lockstatus -- 双岗复核锁标记
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,status -- 状态
            ,trans_no -- 
            ,top_branch_no -- 所属总行机构
            ,jiti_type -- 计提类型 1;贴现 2:转贴现 3:买入质押式回购 4:买入买断式回购 5:卖出质押式回购 6:卖出买断式回购 7.再贴现回购
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.product_name -- 产品名称
    ,o.product_no -- 产品号
    ,o.busi_type -- 业务种类
    ,o.busi_attr_name -- 业务属性名称
    ,o.busi_attr_no -- 业务属性号
    ,o.draft_attr -- 票据属性
    ,o.draft_type -- 票据类型
    ,o.dualcontrol_lockstatus -- 双岗复核锁标记
    ,o.last_operator_no -- 最后操作员编号
    ,o.last_txn_date -- 最后操作日期
    ,o.status -- 状态
    ,o.trans_no -- 
    ,o.top_branch_no -- 所属总行机构
    ,o.jiti_type -- 计提类型 1;贴现 2:转贴现 3:买入质押式回购 4:买入买断式回购 5:卖出质押式回购 6:卖出买断式回购 7.再贴现回购
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_bms_product_info_bk o
    left join ${iol_schema}.bdms_bms_product_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_product_info_cl d
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
-- truncate table ${iol_schema}.bdms_bms_product_info;

-- 4.2 exchange partition
alter table ${iol_schema}.bdms_bms_product_info exchange partition p_19000101 with table ${iol_schema}.bdms_bms_product_info_cl;
alter table ${iol_schema}.bdms_bms_product_info exchange partition p_20991231 with table ${iol_schema}.bdms_bms_product_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_product_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_product_info_op purge;
drop table ${iol_schema}.bdms_bms_product_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_product_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_product_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
