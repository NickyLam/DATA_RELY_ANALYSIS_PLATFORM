/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_product_sub_info
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
create table ${iol_schema}.mrms_tbl_product_sub_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_product_sub_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_product_sub_info_op purge;
drop table ${iol_schema}.mrms_tbl_product_sub_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_product_sub_info_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mrms_tbl_product_sub_info where 0=1;

create table ${iol_schema}.mrms_tbl_product_sub_info_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mrms_tbl_product_sub_info where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.mrms_tbl_product_sub_info_op(
        id -- ID
        ,key_rsp -- 关联流水号(积分商城登记流水表的主键)
        ,product_no -- 商品编号
        ,product_nm -- 商品名称
        ,product_num -- 商品总数量
        ,trade_money -- 对应商品总金额
        ,trade_type -- 交易类型
        ,trade_point -- 对应商品总积分
        ,undo_refund_flag -- 退货专用字段 0：未退货    2：已退货
        ,create_time -- 创建时间
        ,update_time -- 更新时间
        ,adddata1 -- 附加数据1
        ,adddata2 -- 附加数据2
        ,product_desc -- 商品描述信息
        ,order_no -- 外部订单号(渠道方流水号)
        ,txn_sta -- 订单状态
        ,equity_star -- 权益星
        ,provi_name -- 供应商名称
        ,form_mrchd_fee -- 单个商品手续费
        ,product_type -- 商品类型(1、实体商品2、虚拟商品3、实物贵金属)
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.id -- ID
    ,n.key_rsp -- 关联流水号(积分商城登记流水表的主键)
    ,n.product_no -- 商品编号
    ,n.product_nm -- 商品名称
    ,n.product_num -- 商品总数量
    ,n.trade_money -- 对应商品总金额
    ,n.trade_type -- 交易类型
    ,n.trade_point -- 对应商品总积分
    ,n.undo_refund_flag -- 退货专用字段 0：未退货    2：已退货
    ,n.create_time -- 创建时间
    ,n.update_time -- 更新时间
    ,n.adddata1 -- 附加数据1
    ,n.adddata2 -- 附加数据2
    ,n.product_desc -- 商品描述信息
    ,n.order_no -- 外部订单号(渠道方流水号)
    ,n.txn_sta -- 订单状态
    ,n.equity_star -- 权益星
    ,n.provi_name -- 供应商名称
    ,n.form_mrchd_fee -- 单个商品手续费
    ,n.product_type -- 商品类型(1、实体商品2、虚拟商品3、实物贵金属)
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mrms_tbl_product_sub_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.mrms_tbl_product_sub_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        o.key_rsp <> n.key_rsp
        or o.product_no <> n.product_no
        or o.product_nm <> n.product_nm
        or o.product_num <> n.product_num
        or o.trade_money <> n.trade_money
        or o.trade_type <> n.trade_type
        or o.trade_point <> n.trade_point
        or o.undo_refund_flag <> n.undo_refund_flag
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.adddata1 <> n.adddata1
        or o.adddata2 <> n.adddata2
        or o.product_desc <> n.product_desc
        or o.order_no <> n.order_no
        or o.txn_sta <> n.txn_sta
        or o.equity_star <> n.equity_star
        or o.provi_name <> n.provi_name
        or o.form_mrchd_fee <> n.form_mrchd_fee
        or o.product_type <> n.product_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_product_sub_info_cl(
            id -- ID
        ,key_rsp -- 关联流水号(积分商城登记流水表的主键)
        ,product_no -- 商品编号
        ,product_nm -- 商品名称
        ,product_num -- 商品总数量
        ,trade_money -- 对应商品总金额
        ,trade_type -- 交易类型
        ,trade_point -- 对应商品总积分
        ,undo_refund_flag -- 退货专用字段 0：未退货    2：已退货
        ,create_time -- 创建时间
        ,update_time -- 更新时间
        ,adddata1 -- 附加数据1
        ,adddata2 -- 附加数据2
        ,product_desc -- 商品描述信息
        ,order_no -- 外部订单号(渠道方流水号)
        ,txn_sta -- 订单状态
        ,equity_star -- 权益星
        ,provi_name -- 供应商名称
        ,form_mrchd_fee -- 单个商品手续费
        ,product_type -- 商品类型(1、实体商品2、虚拟商品3、实物贵金属)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_product_sub_info_op(
            id -- ID
        ,key_rsp -- 关联流水号(积分商城登记流水表的主键)
        ,product_no -- 商品编号
        ,product_nm -- 商品名称
        ,product_num -- 商品总数量
        ,trade_money -- 对应商品总金额
        ,trade_type -- 交易类型
        ,trade_point -- 对应商品总积分
        ,undo_refund_flag -- 退货专用字段 0：未退货    2：已退货
        ,create_time -- 创建时间
        ,update_time -- 更新时间
        ,adddata1 -- 附加数据1
        ,adddata2 -- 附加数据2
        ,product_desc -- 商品描述信息
        ,order_no -- 外部订单号(渠道方流水号)
        ,txn_sta -- 订单状态
        ,equity_star -- 权益星
        ,provi_name -- 供应商名称
        ,form_mrchd_fee -- 单个商品手续费
        ,product_type -- 商品类型(1、实体商品2、虚拟商品3、实物贵金属)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.key_rsp -- 关联流水号(积分商城登记流水表的主键)
    ,o.product_no -- 商品编号
    ,o.product_nm -- 商品名称
    ,o.product_num -- 商品总数量
    ,o.trade_money -- 对应商品总金额
    ,o.trade_type -- 交易类型
    ,o.trade_point -- 对应商品总积分
    ,o.undo_refund_flag -- 退货专用字段 0：未退货    2：已退货
    ,o.create_time -- 创建时间
    ,o.update_time -- 更新时间
    ,o.adddata1 -- 附加数据1
    ,o.adddata2 -- 附加数据2
    ,o.product_desc -- 商品描述信息
    ,o.order_no -- 外部订单号(渠道方流水号)
    ,o.txn_sta -- 订单状态
    ,o.equity_star -- 权益星
    ,o.provi_name -- 供应商名称
    ,o.form_mrchd_fee -- 单个商品手续费
    ,o.product_type -- 商品类型(1、实体商品2、虚拟商品3、实物贵金属)
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
from ${iol_schema}.mrms_tbl_product_sub_info_bk o
    left join ${iol_schema}.mrms_tbl_product_sub_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mrms_tbl_product_sub_info;

-- 4.2 exchange partition
alter table ${iol_schema}.mrms_tbl_product_sub_info exchange partition p_19000101 with table ${iol_schema}.mrms_tbl_product_sub_info_cl;
alter table ${iol_schema}.mrms_tbl_product_sub_info exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_product_sub_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_product_sub_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_product_sub_info_op purge;
drop table ${iol_schema}.mrms_tbl_product_sub_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_product_sub_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_product_sub_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
