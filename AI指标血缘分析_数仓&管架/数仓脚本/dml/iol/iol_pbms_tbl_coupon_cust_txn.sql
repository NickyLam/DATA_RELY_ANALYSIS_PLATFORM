/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pbms_tbl_coupon_cust_txn
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
create table ${iol_schema}.pbms_tbl_coupon_cust_txn_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pbms_tbl_coupon_cust_txn
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pbms_tbl_coupon_cust_txn_op purge;
drop table ${iol_schema}.pbms_tbl_coupon_cust_txn_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pbms_tbl_coupon_cust_txn_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pbms_tbl_coupon_cust_txn where 0=1;

create table ${iol_schema}.pbms_tbl_coupon_cust_txn_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pbms_tbl_coupon_cust_txn where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pbms_tbl_coupon_cust_txn_cl(
            pk_coupon_used -- 唯一标识,主键
            ,coupon_id -- 卡券的唯一劵码
            ,deal_type -- 交易类型 1：核销 2：作废 3：重置 4：赠送 5.转让 6.冲正 7：过期 8：调整
            ,deal_status -- 交易状态 1：成功 0：失败 2:未响应
            ,deal_num -- 交易数量（核销次数、转让次数）
            ,overdue_date -- 过期时间
            ,used_time -- 交易时间
            ,exchange_code -- 卡券兑换码
            ,channel_no -- 核销渠道
            ,check_id -- 核销者
            ,txn_code -- 出账流水号
            ,deal_explain -- 交易说明（核销说明、作废原因、重置原因，赠送原因、转让原因）
            ,cust_id -- 客户号
            ,roll_int_cust_id -- 转入客户号
            ,summary -- 摘要
            ,audit_status -- 审批状态
            ,created_by -- 创建人
            ,updated_by -- 修改人
            ,create_time -- 创建时间戳
            ,update_time -- 更新时间戳
            ,del_flag -- 逻辑删除标记(0-正常，1-删除)
            ,batch_no -- 批次号
            ,deal_dir -- 交易方向(0=减少 1=增加 2=不变=不变)
            ,draw_src -- 领取来源：HYZX-会员中心
            ,glob_seq -- 全局流水号
            ,coop_order_seq -- 第三方交易流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pbms_tbl_coupon_cust_txn_op(
            pk_coupon_used -- 唯一标识,主键
            ,coupon_id -- 卡券的唯一劵码
            ,deal_type -- 交易类型 1：核销 2：作废 3：重置 4：赠送 5.转让 6.冲正 7：过期 8：调整
            ,deal_status -- 交易状态 1：成功 0：失败 2:未响应
            ,deal_num -- 交易数量（核销次数、转让次数）
            ,overdue_date -- 过期时间
            ,used_time -- 交易时间
            ,exchange_code -- 卡券兑换码
            ,channel_no -- 核销渠道
            ,check_id -- 核销者
            ,txn_code -- 出账流水号
            ,deal_explain -- 交易说明（核销说明、作废原因、重置原因，赠送原因、转让原因）
            ,cust_id -- 客户号
            ,roll_int_cust_id -- 转入客户号
            ,summary -- 摘要
            ,audit_status -- 审批状态
            ,created_by -- 创建人
            ,updated_by -- 修改人
            ,create_time -- 创建时间戳
            ,update_time -- 更新时间戳
            ,del_flag -- 逻辑删除标记(0-正常，1-删除)
            ,batch_no -- 批次号
            ,deal_dir -- 交易方向(0=减少 1=增加 2=不变=不变)
            ,draw_src -- 领取来源：HYZX-会员中心
            ,glob_seq -- 全局流水号
            ,coop_order_seq -- 第三方交易流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pk_coupon_used, o.pk_coupon_used) as pk_coupon_used -- 唯一标识,主键
    ,nvl(n.coupon_id, o.coupon_id) as coupon_id -- 卡券的唯一劵码
    ,nvl(n.deal_type, o.deal_type) as deal_type -- 交易类型 1：核销 2：作废 3：重置 4：赠送 5.转让 6.冲正 7：过期 8：调整
    ,nvl(n.deal_status, o.deal_status) as deal_status -- 交易状态 1：成功 0：失败 2:未响应
    ,nvl(n.deal_num, o.deal_num) as deal_num -- 交易数量（核销次数、转让次数）
    ,nvl(n.overdue_date, o.overdue_date) as overdue_date -- 过期时间
    ,nvl(n.used_time, o.used_time) as used_time -- 交易时间
    ,nvl(n.exchange_code, o.exchange_code) as exchange_code -- 卡券兑换码
    ,nvl(n.channel_no, o.channel_no) as channel_no -- 核销渠道
    ,nvl(n.check_id, o.check_id) as check_id -- 核销者
    ,nvl(n.txn_code, o.txn_code) as txn_code -- 出账流水号
    ,nvl(n.deal_explain, o.deal_explain) as deal_explain -- 交易说明（核销说明、作废原因、重置原因，赠送原因、转让原因）
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户号
    ,nvl(n.roll_int_cust_id, o.roll_int_cust_id) as roll_int_cust_id -- 转入客户号
    ,nvl(n.summary, o.summary) as summary -- 摘要
    ,nvl(n.audit_status, o.audit_status) as audit_status -- 审批状态
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.updated_by, o.updated_by) as updated_by -- 修改人
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间戳
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间戳
    ,nvl(n.del_flag, o.del_flag) as del_flag -- 逻辑删除标记(0-正常，1-删除)
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.deal_dir, o.deal_dir) as deal_dir -- 交易方向(0=减少 1=增加 2=不变=不变)
    ,nvl(n.draw_src, o.draw_src) as draw_src -- 领取来源：HYZX-会员中心
    ,nvl(n.glob_seq, o.glob_seq) as glob_seq -- 全局流水号
    ,nvl(n.coop_order_seq, o.coop_order_seq) as coop_order_seq -- 第三方交易流水号
    ,case when
            n.pk_coupon_used is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_coupon_used is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_coupon_used is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pbms_tbl_coupon_cust_txn_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pbms_tbl_coupon_cust_txn where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_coupon_used = n.pk_coupon_used
where (
        o.pk_coupon_used is null
    )
    or (
        n.pk_coupon_used is null
    )
    or (
        o.coupon_id <> n.coupon_id
        or o.deal_type <> n.deal_type
        or o.deal_status <> n.deal_status
        or o.deal_num <> n.deal_num
        or o.overdue_date <> n.overdue_date
        or o.used_time <> n.used_time
        or o.exchange_code <> n.exchange_code
        or o.channel_no <> n.channel_no
        or o.check_id <> n.check_id
        or o.txn_code <> n.txn_code
        or o.deal_explain <> n.deal_explain
        or o.cust_id <> n.cust_id
        or o.roll_int_cust_id <> n.roll_int_cust_id
        or o.summary <> n.summary
        or o.audit_status <> n.audit_status
        or o.created_by <> n.created_by
        or o.updated_by <> n.updated_by
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.del_flag <> n.del_flag
        or o.batch_no <> n.batch_no
        or o.deal_dir <> n.deal_dir
        or o.draw_src <> n.draw_src
        or o.glob_seq <> n.glob_seq
        or o.coop_order_seq <> n.coop_order_seq
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pbms_tbl_coupon_cust_txn_cl(
            pk_coupon_used -- 唯一标识,主键
            ,coupon_id -- 卡券的唯一劵码
            ,deal_type -- 交易类型 1：核销 2：作废 3：重置 4：赠送 5.转让 6.冲正 7：过期 8：调整
            ,deal_status -- 交易状态 1：成功 0：失败 2:未响应
            ,deal_num -- 交易数量（核销次数、转让次数）
            ,overdue_date -- 过期时间
            ,used_time -- 交易时间
            ,exchange_code -- 卡券兑换码
            ,channel_no -- 核销渠道
            ,check_id -- 核销者
            ,txn_code -- 出账流水号
            ,deal_explain -- 交易说明（核销说明、作废原因、重置原因，赠送原因、转让原因）
            ,cust_id -- 客户号
            ,roll_int_cust_id -- 转入客户号
            ,summary -- 摘要
            ,audit_status -- 审批状态
            ,created_by -- 创建人
            ,updated_by -- 修改人
            ,create_time -- 创建时间戳
            ,update_time -- 更新时间戳
            ,del_flag -- 逻辑删除标记(0-正常，1-删除)
            ,batch_no -- 批次号
            ,deal_dir -- 交易方向(0=减少 1=增加 2=不变=不变)
            ,draw_src -- 领取来源：HYZX-会员中心
            ,glob_seq -- 全局流水号
            ,coop_order_seq -- 第三方交易流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pbms_tbl_coupon_cust_txn_op(
            pk_coupon_used -- 唯一标识,主键
            ,coupon_id -- 卡券的唯一劵码
            ,deal_type -- 交易类型 1：核销 2：作废 3：重置 4：赠送 5.转让 6.冲正 7：过期 8：调整
            ,deal_status -- 交易状态 1：成功 0：失败 2:未响应
            ,deal_num -- 交易数量（核销次数、转让次数）
            ,overdue_date -- 过期时间
            ,used_time -- 交易时间
            ,exchange_code -- 卡券兑换码
            ,channel_no -- 核销渠道
            ,check_id -- 核销者
            ,txn_code -- 出账流水号
            ,deal_explain -- 交易说明（核销说明、作废原因、重置原因，赠送原因、转让原因）
            ,cust_id -- 客户号
            ,roll_int_cust_id -- 转入客户号
            ,summary -- 摘要
            ,audit_status -- 审批状态
            ,created_by -- 创建人
            ,updated_by -- 修改人
            ,create_time -- 创建时间戳
            ,update_time -- 更新时间戳
            ,del_flag -- 逻辑删除标记(0-正常，1-删除)
            ,batch_no -- 批次号
            ,deal_dir -- 交易方向(0=减少 1=增加 2=不变=不变)
            ,draw_src -- 领取来源：HYZX-会员中心
            ,glob_seq -- 全局流水号
            ,coop_order_seq -- 第三方交易流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pk_coupon_used -- 唯一标识,主键
    ,o.coupon_id -- 卡券的唯一劵码
    ,o.deal_type -- 交易类型 1：核销 2：作废 3：重置 4：赠送 5.转让 6.冲正 7：过期 8：调整
    ,o.deal_status -- 交易状态 1：成功 0：失败 2:未响应
    ,o.deal_num -- 交易数量（核销次数、转让次数）
    ,o.overdue_date -- 过期时间
    ,o.used_time -- 交易时间
    ,o.exchange_code -- 卡券兑换码
    ,o.channel_no -- 核销渠道
    ,o.check_id -- 核销者
    ,o.txn_code -- 出账流水号
    ,o.deal_explain -- 交易说明（核销说明、作废原因、重置原因，赠送原因、转让原因）
    ,o.cust_id -- 客户号
    ,o.roll_int_cust_id -- 转入客户号
    ,o.summary -- 摘要
    ,o.audit_status -- 审批状态
    ,o.created_by -- 创建人
    ,o.updated_by -- 修改人
    ,o.create_time -- 创建时间戳
    ,o.update_time -- 更新时间戳
    ,o.del_flag -- 逻辑删除标记(0-正常，1-删除)
    ,o.batch_no -- 批次号
    ,o.deal_dir -- 交易方向(0=减少 1=增加 2=不变=不变)
    ,o.draw_src -- 领取来源：HYZX-会员中心
    ,o.glob_seq -- 全局流水号
    ,o.coop_order_seq -- 第三方交易流水号
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
from ${iol_schema}.pbms_tbl_coupon_cust_txn_bk o
    left join ${iol_schema}.pbms_tbl_coupon_cust_txn_op n
        on
            o.pk_coupon_used = n.pk_coupon_used
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pbms_tbl_coupon_cust_txn_cl d
        on
            o.pk_coupon_used = d.pk_coupon_used
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pbms_tbl_coupon_cust_txn;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pbms_tbl_coupon_cust_txn') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pbms_tbl_coupon_cust_txn drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pbms_tbl_coupon_cust_txn add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pbms_tbl_coupon_cust_txn exchange partition p_${batch_date} with table ${iol_schema}.pbms_tbl_coupon_cust_txn_cl;
alter table ${iol_schema}.pbms_tbl_coupon_cust_txn exchange partition p_20991231 with table ${iol_schema}.pbms_tbl_coupon_cust_txn_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pbms_tbl_coupon_cust_txn to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pbms_tbl_coupon_cust_txn_op purge;
drop table ${iol_schema}.pbms_tbl_coupon_cust_txn_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pbms_tbl_coupon_cust_txn_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pbms_tbl_coupon_cust_txn',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
