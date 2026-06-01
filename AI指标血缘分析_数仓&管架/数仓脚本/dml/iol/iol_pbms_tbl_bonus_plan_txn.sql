/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pbms_tbl_bonus_plan_txn
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
create table ${iol_schema}.pbms_tbl_bonus_plan_txn_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pbms_tbl_bonus_plan_txn
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pbms_tbl_bonus_plan_txn_op purge;
drop table ${iol_schema}.pbms_tbl_bonus_plan_txn_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pbms_tbl_bonus_plan_txn_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pbms_tbl_bonus_plan_txn where 0=1;

create table ${iol_schema}.pbms_tbl_bonus_plan_txn_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pbms_tbl_bonus_plan_txn where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pbms_tbl_bonus_plan_txn_cl(
            pk_bonus_plan_txn -- 主键
            ,ssn -- 积分权益管理平台交易流水号
            ,ori_order_id -- 原订单号（只有退货时才有）
            ,glob_seq -- 全局流水号
            ,order_id -- 订单号（业务流水号）
            ,txn_chn -- 交易渠道，源发送通道号
            ,txn_date -- 交易日期（yyyyMMdd）
            ,txn_time -- 交易时间（HHmmss）
            ,posting_date -- 入账日期（yyyyMMdd）
            ,posting_time -- 入账时间（HHmmss）
            ,txn_type -- 交易类型1：获赠2：消费3：到期 4：手工调整、5:退货
            ,biz_typ -- 业务类型，如0001：网上商城，0002：刷卡
            ,summary -- 摘要，显示给用户
            ,memo_info -- 备注，仅显示在系统页面
            ,txn_code -- 交易码
            ,txn_desc -- 交易描述
            ,cnsn_arti_id -- 消费品编码
            ,usage_key -- 权益用途key
            ,ext_coulmn3 -- 预留字段3
            ,ext_coulmn2 -- 预留字段2
            ,ext_coulmn1 -- 预留字段1
            ,cust_id -- 客户号
            ,bonus_plan_type -- 积分来源，权益层级：x
            ,txn_bonus -- 交易积分
            ,bonus_cd_flag -- 交易方向，1-增加 0-减少
            ,return_flag -- 冲正标志，0-正常 1-待冲正
            ,batch_id -- 批次号
            ,created_by -- 创建人，系统创建写system
            ,create_time -- 创建时间
            ,updated_by -- 更新人，系统创建写system
            ,update_time -- 更新时间
            ,del_flag -- 逻辑删除标志（0-正常，1-删除）
            ,card_no -- 卡号
            ,rema_useb_bonus -- 交易后可用积分余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pbms_tbl_bonus_plan_txn_op(
            pk_bonus_plan_txn -- 主键
            ,ssn -- 积分权益管理平台交易流水号
            ,ori_order_id -- 原订单号（只有退货时才有）
            ,glob_seq -- 全局流水号
            ,order_id -- 订单号（业务流水号）
            ,txn_chn -- 交易渠道，源发送通道号
            ,txn_date -- 交易日期（yyyyMMdd）
            ,txn_time -- 交易时间（HHmmss）
            ,posting_date -- 入账日期（yyyyMMdd）
            ,posting_time -- 入账时间（HHmmss）
            ,txn_type -- 交易类型1：获赠2：消费3：到期 4：手工调整、5:退货
            ,biz_typ -- 业务类型，如0001：网上商城，0002：刷卡
            ,summary -- 摘要，显示给用户
            ,memo_info -- 备注，仅显示在系统页面
            ,txn_code -- 交易码
            ,txn_desc -- 交易描述
            ,cnsn_arti_id -- 消费品编码
            ,usage_key -- 权益用途key
            ,ext_coulmn3 -- 预留字段3
            ,ext_coulmn2 -- 预留字段2
            ,ext_coulmn1 -- 预留字段1
            ,cust_id -- 客户号
            ,bonus_plan_type -- 积分来源，权益层级：x
            ,txn_bonus -- 交易积分
            ,bonus_cd_flag -- 交易方向，1-增加 0-减少
            ,return_flag -- 冲正标志，0-正常 1-待冲正
            ,batch_id -- 批次号
            ,created_by -- 创建人，系统创建写system
            ,create_time -- 创建时间
            ,updated_by -- 更新人，系统创建写system
            ,update_time -- 更新时间
            ,del_flag -- 逻辑删除标志（0-正常，1-删除）
            ,card_no -- 卡号
            ,rema_useb_bonus -- 交易后可用积分余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pk_bonus_plan_txn, o.pk_bonus_plan_txn) as pk_bonus_plan_txn -- 主键
    ,nvl(n.ssn, o.ssn) as ssn -- 积分权益管理平台交易流水号
    ,nvl(n.ori_order_id, o.ori_order_id) as ori_order_id -- 原订单号（只有退货时才有）
    ,nvl(n.glob_seq, o.glob_seq) as glob_seq -- 全局流水号
    ,nvl(n.order_id, o.order_id) as order_id -- 订单号（业务流水号）
    ,nvl(n.txn_chn, o.txn_chn) as txn_chn -- 交易渠道，源发送通道号
    ,nvl(n.txn_date, o.txn_date) as txn_date -- 交易日期（yyyyMMdd）
    ,nvl(n.txn_time, o.txn_time) as txn_time -- 交易时间（HHmmss）
    ,nvl(n.posting_date, o.posting_date) as posting_date -- 入账日期（yyyyMMdd）
    ,nvl(n.posting_time, o.posting_time) as posting_time -- 入账时间（HHmmss）
    ,nvl(n.txn_type, o.txn_type) as txn_type -- 交易类型1：获赠2：消费3：到期 4：手工调整、5:退货
    ,nvl(n.biz_typ, o.biz_typ) as biz_typ -- 业务类型，如0001：网上商城，0002：刷卡
    ,nvl(n.summary, o.summary) as summary -- 摘要，显示给用户
    ,nvl(n.memo_info, o.memo_info) as memo_info -- 备注，仅显示在系统页面
    ,nvl(n.txn_code, o.txn_code) as txn_code -- 交易码
    ,nvl(n.txn_desc, o.txn_desc) as txn_desc -- 交易描述
    ,nvl(n.cnsn_arti_id, o.cnsn_arti_id) as cnsn_arti_id -- 消费品编码
    ,nvl(n.usage_key, o.usage_key) as usage_key -- 权益用途key
    ,nvl(n.ext_coulmn3, o.ext_coulmn3) as ext_coulmn3 -- 预留字段3
    ,nvl(n.ext_coulmn2, o.ext_coulmn2) as ext_coulmn2 -- 预留字段2
    ,nvl(n.ext_coulmn1, o.ext_coulmn1) as ext_coulmn1 -- 预留字段1
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户号
    ,nvl(n.bonus_plan_type, o.bonus_plan_type) as bonus_plan_type -- 积分来源，权益层级：x
    ,nvl(n.txn_bonus, o.txn_bonus) as txn_bonus -- 交易积分
    ,nvl(n.bonus_cd_flag, o.bonus_cd_flag) as bonus_cd_flag -- 交易方向，1-增加 0-减少
    ,nvl(n.return_flag, o.return_flag) as return_flag -- 冲正标志，0-正常 1-待冲正
    ,nvl(n.batch_id, o.batch_id) as batch_id -- 批次号
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人，系统创建写system
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.updated_by, o.updated_by) as updated_by -- 更新人，系统创建写system
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.del_flag, o.del_flag) as del_flag -- 逻辑删除标志（0-正常，1-删除）
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.rema_useb_bonus, o.rema_useb_bonus) as rema_useb_bonus -- 交易后可用积分余额
    ,case when
            n.pk_bonus_plan_txn is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_bonus_plan_txn is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_bonus_plan_txn is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pbms_tbl_bonus_plan_txn_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pbms_tbl_bonus_plan_txn where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_bonus_plan_txn = n.pk_bonus_plan_txn
where (
        o.pk_bonus_plan_txn is null
    )
    or (
        n.pk_bonus_plan_txn is null
    )
    or (
        o.ssn <> n.ssn
        or o.ori_order_id <> n.ori_order_id
        or o.glob_seq <> n.glob_seq
        or o.order_id <> n.order_id
        or o.txn_chn <> n.txn_chn
        or o.txn_date <> n.txn_date
        or o.txn_time <> n.txn_time
        or o.posting_date <> n.posting_date
        or o.posting_time <> n.posting_time
        or o.txn_type <> n.txn_type
        or o.biz_typ <> n.biz_typ
        or o.summary <> n.summary
        or o.memo_info <> n.memo_info
        or o.txn_code <> n.txn_code
        or o.txn_desc <> n.txn_desc
        or o.cnsn_arti_id <> n.cnsn_arti_id
        or o.usage_key <> n.usage_key
        or o.ext_coulmn3 <> n.ext_coulmn3
        or o.ext_coulmn2 <> n.ext_coulmn2
        or o.ext_coulmn1 <> n.ext_coulmn1
        or o.cust_id <> n.cust_id
        or o.bonus_plan_type <> n.bonus_plan_type
        or o.txn_bonus <> n.txn_bonus
        or o.bonus_cd_flag <> n.bonus_cd_flag
        or o.return_flag <> n.return_flag
        or o.batch_id <> n.batch_id
        or o.created_by <> n.created_by
        or o.create_time <> n.create_time
        or o.updated_by <> n.updated_by
        or o.update_time <> n.update_time
        or o.del_flag <> n.del_flag
        or o.card_no <> n.card_no
        or o.rema_useb_bonus <> n.rema_useb_bonus
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pbms_tbl_bonus_plan_txn_cl(
            pk_bonus_plan_txn -- 主键
            ,ssn -- 积分权益管理平台交易流水号
            ,ori_order_id -- 原订单号（只有退货时才有）
            ,glob_seq -- 全局流水号
            ,order_id -- 订单号（业务流水号）
            ,txn_chn -- 交易渠道，源发送通道号
            ,txn_date -- 交易日期（yyyyMMdd）
            ,txn_time -- 交易时间（HHmmss）
            ,posting_date -- 入账日期（yyyyMMdd）
            ,posting_time -- 入账时间（HHmmss）
            ,txn_type -- 交易类型1：获赠2：消费3：到期 4：手工调整、5:退货
            ,biz_typ -- 业务类型，如0001：网上商城，0002：刷卡
            ,summary -- 摘要，显示给用户
            ,memo_info -- 备注，仅显示在系统页面
            ,txn_code -- 交易码
            ,txn_desc -- 交易描述
            ,cnsn_arti_id -- 消费品编码
            ,usage_key -- 权益用途key
            ,ext_coulmn3 -- 预留字段3
            ,ext_coulmn2 -- 预留字段2
            ,ext_coulmn1 -- 预留字段1
            ,cust_id -- 客户号
            ,bonus_plan_type -- 积分来源，权益层级：x
            ,txn_bonus -- 交易积分
            ,bonus_cd_flag -- 交易方向，1-增加 0-减少
            ,return_flag -- 冲正标志，0-正常 1-待冲正
            ,batch_id -- 批次号
            ,created_by -- 创建人，系统创建写system
            ,create_time -- 创建时间
            ,updated_by -- 更新人，系统创建写system
            ,update_time -- 更新时间
            ,del_flag -- 逻辑删除标志（0-正常，1-删除）
            ,card_no -- 卡号
            ,rema_useb_bonus -- 交易后可用积分余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pbms_tbl_bonus_plan_txn_op(
            pk_bonus_plan_txn -- 主键
            ,ssn -- 积分权益管理平台交易流水号
            ,ori_order_id -- 原订单号（只有退货时才有）
            ,glob_seq -- 全局流水号
            ,order_id -- 订单号（业务流水号）
            ,txn_chn -- 交易渠道，源发送通道号
            ,txn_date -- 交易日期（yyyyMMdd）
            ,txn_time -- 交易时间（HHmmss）
            ,posting_date -- 入账日期（yyyyMMdd）
            ,posting_time -- 入账时间（HHmmss）
            ,txn_type -- 交易类型1：获赠2：消费3：到期 4：手工调整、5:退货
            ,biz_typ -- 业务类型，如0001：网上商城，0002：刷卡
            ,summary -- 摘要，显示给用户
            ,memo_info -- 备注，仅显示在系统页面
            ,txn_code -- 交易码
            ,txn_desc -- 交易描述
            ,cnsn_arti_id -- 消费品编码
            ,usage_key -- 权益用途key
            ,ext_coulmn3 -- 预留字段3
            ,ext_coulmn2 -- 预留字段2
            ,ext_coulmn1 -- 预留字段1
            ,cust_id -- 客户号
            ,bonus_plan_type -- 积分来源，权益层级：x
            ,txn_bonus -- 交易积分
            ,bonus_cd_flag -- 交易方向，1-增加 0-减少
            ,return_flag -- 冲正标志，0-正常 1-待冲正
            ,batch_id -- 批次号
            ,created_by -- 创建人，系统创建写system
            ,create_time -- 创建时间
            ,updated_by -- 更新人，系统创建写system
            ,update_time -- 更新时间
            ,del_flag -- 逻辑删除标志（0-正常，1-删除）
            ,card_no -- 卡号
            ,rema_useb_bonus -- 交易后可用积分余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pk_bonus_plan_txn -- 主键
    ,o.ssn -- 积分权益管理平台交易流水号
    ,o.ori_order_id -- 原订单号（只有退货时才有）
    ,o.glob_seq -- 全局流水号
    ,o.order_id -- 订单号（业务流水号）
    ,o.txn_chn -- 交易渠道，源发送通道号
    ,o.txn_date -- 交易日期（yyyyMMdd）
    ,o.txn_time -- 交易时间（HHmmss）
    ,o.posting_date -- 入账日期（yyyyMMdd）
    ,o.posting_time -- 入账时间（HHmmss）
    ,o.txn_type -- 交易类型1：获赠2：消费3：到期 4：手工调整、5:退货
    ,o.biz_typ -- 业务类型，如0001：网上商城，0002：刷卡
    ,o.summary -- 摘要，显示给用户
    ,o.memo_info -- 备注，仅显示在系统页面
    ,o.txn_code -- 交易码
    ,o.txn_desc -- 交易描述
    ,o.cnsn_arti_id -- 消费品编码
    ,o.usage_key -- 权益用途key
    ,o.ext_coulmn3 -- 预留字段3
    ,o.ext_coulmn2 -- 预留字段2
    ,o.ext_coulmn1 -- 预留字段1
    ,o.cust_id -- 客户号
    ,o.bonus_plan_type -- 积分来源，权益层级：x
    ,o.txn_bonus -- 交易积分
    ,o.bonus_cd_flag -- 交易方向，1-增加 0-减少
    ,o.return_flag -- 冲正标志，0-正常 1-待冲正
    ,o.batch_id -- 批次号
    ,o.created_by -- 创建人，系统创建写system
    ,o.create_time -- 创建时间
    ,o.updated_by -- 更新人，系统创建写system
    ,o.update_time -- 更新时间
    ,o.del_flag -- 逻辑删除标志（0-正常，1-删除）
    ,o.card_no -- 卡号
    ,o.rema_useb_bonus -- 交易后可用积分余额
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
from ${iol_schema}.pbms_tbl_bonus_plan_txn_bk o
    left join ${iol_schema}.pbms_tbl_bonus_plan_txn_op n
        on
            o.pk_bonus_plan_txn = n.pk_bonus_plan_txn
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pbms_tbl_bonus_plan_txn_cl d
        on
            o.pk_bonus_plan_txn = d.pk_bonus_plan_txn
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pbms_tbl_bonus_plan_txn;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pbms_tbl_bonus_plan_txn') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pbms_tbl_bonus_plan_txn drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pbms_tbl_bonus_plan_txn add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pbms_tbl_bonus_plan_txn exchange partition p_${batch_date} with table ${iol_schema}.pbms_tbl_bonus_plan_txn_cl;
alter table ${iol_schema}.pbms_tbl_bonus_plan_txn exchange partition p_20991231 with table ${iol_schema}.pbms_tbl_bonus_plan_txn_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pbms_tbl_bonus_plan_txn to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pbms_tbl_bonus_plan_txn_op purge;
drop table ${iol_schema}.pbms_tbl_bonus_plan_txn_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pbms_tbl_bonus_plan_txn_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pbms_tbl_bonus_plan_txn',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
