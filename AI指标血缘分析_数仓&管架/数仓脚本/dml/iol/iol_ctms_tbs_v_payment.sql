/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_payment
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
create table ${iol_schema}.ctms_tbs_v_payment_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_payment;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_payment_op purge;
drop table ${iol_schema}.ctms_tbs_v_payment_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_payment_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_payment where 0=1;

create table ${iol_schema}.ctms_tbs_v_payment_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_payment where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_payment_cl(
            payment_id -- 支付ID
            ,aspclient_id -- 部门ID
            ,dealsconfirm_id -- 交易确认ID
            ,deal_tablename -- 交易表名
            ,deal_id -- 交易表对应记录ID
            ,eventtype -- 事件类型
            ,sequence -- 序列号
            ,payment_id_prev -- 前一个支付ID
            ,keepfolder_id -- 账户ID
            ,assettype -- 资产类型
            ,buztype -- 交易类型
            ,dealtype -- 作业类型
            ,actiontype -- 操作类型
            ,releasedate -- 发布日期
            ,generatedate -- 生成日期
            ,settledate -- 交割日期
            ,cpty_id -- 交易对手ID
            ,cpty_name -- 交易对手名称
            ,payreceivetype -- 收付类型
            ,settlecurrency -- 交割币种
            ,settleamount -- 交割金额
            ,securitycode -- 债券交割代码
            ,quantity -- 交割债券
            ,act_settledate -- 实际结算日期
            ,act_settlecurrency -- 实际交割币种
            ,act_settleamount -- 实际结算金额
            ,act_securitycode -- 实际交割债券代码
            ,act_quantity -- 实际交割债券
            ,pstatus -- 状态
            ,lastmodified -- 最后修改日期
            ,users_id_modifier -- 变更用户ID
            ,settlemethod -- 交割方式
            ,act_settlemethod -- 实际交割方式
            ,act_advance_amount -- 暂未启用
            ,note -- 备注
            ,act_principal -- 实际本金
            ,act_interest -- 实际利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_payment_op(
            payment_id -- 支付ID
            ,aspclient_id -- 部门ID
            ,dealsconfirm_id -- 交易确认ID
            ,deal_tablename -- 交易表名
            ,deal_id -- 交易表对应记录ID
            ,eventtype -- 事件类型
            ,sequence -- 序列号
            ,payment_id_prev -- 前一个支付ID
            ,keepfolder_id -- 账户ID
            ,assettype -- 资产类型
            ,buztype -- 交易类型
            ,dealtype -- 作业类型
            ,actiontype -- 操作类型
            ,releasedate -- 发布日期
            ,generatedate -- 生成日期
            ,settledate -- 交割日期
            ,cpty_id -- 交易对手ID
            ,cpty_name -- 交易对手名称
            ,payreceivetype -- 收付类型
            ,settlecurrency -- 交割币种
            ,settleamount -- 交割金额
            ,securitycode -- 债券交割代码
            ,quantity -- 交割债券
            ,act_settledate -- 实际结算日期
            ,act_settlecurrency -- 实际交割币种
            ,act_settleamount -- 实际结算金额
            ,act_securitycode -- 实际交割债券代码
            ,act_quantity -- 实际交割债券
            ,pstatus -- 状态
            ,lastmodified -- 最后修改日期
            ,users_id_modifier -- 变更用户ID
            ,settlemethod -- 交割方式
            ,act_settlemethod -- 实际交割方式
            ,act_advance_amount -- 暂未启用
            ,note -- 备注
            ,act_principal -- 实际本金
            ,act_interest -- 实际利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.payment_id, o.payment_id) as payment_id -- 支付ID
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门ID
    ,nvl(n.dealsconfirm_id, o.dealsconfirm_id) as dealsconfirm_id -- 交易确认ID
    ,nvl(n.deal_tablename, o.deal_tablename) as deal_tablename -- 交易表名
    ,nvl(n.deal_id, o.deal_id) as deal_id -- 交易表对应记录ID
    ,nvl(n.eventtype, o.eventtype) as eventtype -- 事件类型
    ,nvl(n.sequence, o.sequence) as sequence -- 序列号
    ,nvl(n.payment_id_prev, o.payment_id_prev) as payment_id_prev -- 前一个支付ID
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 账户ID
    ,nvl(n.assettype, o.assettype) as assettype -- 资产类型
    ,nvl(n.buztype, o.buztype) as buztype -- 交易类型
    ,nvl(n.dealtype, o.dealtype) as dealtype -- 作业类型
    ,nvl(n.actiontype, o.actiontype) as actiontype -- 操作类型
    ,nvl(n.releasedate, o.releasedate) as releasedate -- 发布日期
    ,nvl(n.generatedate, o.generatedate) as generatedate -- 生成日期
    ,nvl(n.settledate, o.settledate) as settledate -- 交割日期
    ,nvl(n.cpty_id, o.cpty_id) as cpty_id -- 交易对手ID
    ,nvl(n.cpty_name, o.cpty_name) as cpty_name -- 交易对手名称
    ,nvl(n.payreceivetype, o.payreceivetype) as payreceivetype -- 收付类型
    ,nvl(n.settlecurrency, o.settlecurrency) as settlecurrency -- 交割币种
    ,nvl(n.settleamount, o.settleamount) as settleamount -- 交割金额
    ,nvl(n.securitycode, o.securitycode) as securitycode -- 债券交割代码
    ,nvl(n.quantity, o.quantity) as quantity -- 交割债券
    ,nvl(n.act_settledate, o.act_settledate) as act_settledate -- 实际结算日期
    ,nvl(n.act_settlecurrency, o.act_settlecurrency) as act_settlecurrency -- 实际交割币种
    ,nvl(n.act_settleamount, o.act_settleamount) as act_settleamount -- 实际结算金额
    ,nvl(n.act_securitycode, o.act_securitycode) as act_securitycode -- 实际交割债券代码
    ,nvl(n.act_quantity, o.act_quantity) as act_quantity -- 实际交割债券
    ,nvl(n.pstatus, o.pstatus) as pstatus -- 状态
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后修改日期
    ,nvl(n.users_id_modifier, o.users_id_modifier) as users_id_modifier -- 变更用户ID
    ,nvl(n.settlemethod, o.settlemethod) as settlemethod -- 交割方式
    ,nvl(n.act_settlemethod, o.act_settlemethod) as act_settlemethod -- 实际交割方式
    ,nvl(n.act_advance_amount, o.act_advance_amount) as act_advance_amount -- 暂未启用
    ,nvl(n.note, o.note) as note -- 备注
    ,nvl(n.act_principal, o.act_principal) as act_principal -- 实际本金
    ,nvl(n.act_interest, o.act_interest) as act_interest -- 实际利息
    ,case when
            n.payment_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.payment_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.payment_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_v_payment_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_payment where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.payment_id = n.payment_id
where (
        o.payment_id is null
    )
    or (
        n.payment_id is null
    )
    or (
        o.aspclient_id <> n.aspclient_id
        or o.dealsconfirm_id <> n.dealsconfirm_id
        or o.deal_tablename <> n.deal_tablename
        or o.deal_id <> n.deal_id
        or o.eventtype <> n.eventtype
        or o.sequence <> n.sequence
        or o.payment_id_prev <> n.payment_id_prev
        or o.keepfolder_id <> n.keepfolder_id
        or o.assettype <> n.assettype
        or o.buztype <> n.buztype
        or o.dealtype <> n.dealtype
        or o.actiontype <> n.actiontype
        or o.releasedate <> n.releasedate
        or o.generatedate <> n.generatedate
        or o.settledate <> n.settledate
        or o.cpty_id <> n.cpty_id
        or o.cpty_name <> n.cpty_name
        or o.payreceivetype <> n.payreceivetype
        or o.settlecurrency <> n.settlecurrency
        or o.settleamount <> n.settleamount
        or o.securitycode <> n.securitycode
        or o.quantity <> n.quantity
        or o.act_settledate <> n.act_settledate
        or o.act_settlecurrency <> n.act_settlecurrency
        or o.act_settleamount <> n.act_settleamount
        or o.act_securitycode <> n.act_securitycode
        or o.act_quantity <> n.act_quantity
        or o.pstatus <> n.pstatus
        or o.lastmodified <> n.lastmodified
        or o.users_id_modifier <> n.users_id_modifier
        or o.settlemethod <> n.settlemethod
        or o.act_settlemethod <> n.act_settlemethod
        or o.act_advance_amount <> n.act_advance_amount
        or o.note <> n.note
        or o.act_principal <> n.act_principal
        or o.act_interest <> n.act_interest
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_payment_cl(
            payment_id -- 支付ID
            ,aspclient_id -- 部门ID
            ,dealsconfirm_id -- 交易确认ID
            ,deal_tablename -- 交易表名
            ,deal_id -- 交易表对应记录ID
            ,eventtype -- 事件类型
            ,sequence -- 序列号
            ,payment_id_prev -- 前一个支付ID
            ,keepfolder_id -- 账户ID
            ,assettype -- 资产类型
            ,buztype -- 交易类型
            ,dealtype -- 作业类型
            ,actiontype -- 操作类型
            ,releasedate -- 发布日期
            ,generatedate -- 生成日期
            ,settledate -- 交割日期
            ,cpty_id -- 交易对手ID
            ,cpty_name -- 交易对手名称
            ,payreceivetype -- 收付类型
            ,settlecurrency -- 交割币种
            ,settleamount -- 交割金额
            ,securitycode -- 债券交割代码
            ,quantity -- 交割债券
            ,act_settledate -- 实际结算日期
            ,act_settlecurrency -- 实际交割币种
            ,act_settleamount -- 实际结算金额
            ,act_securitycode -- 实际交割债券代码
            ,act_quantity -- 实际交割债券
            ,pstatus -- 状态
            ,lastmodified -- 最后修改日期
            ,users_id_modifier -- 变更用户ID
            ,settlemethod -- 交割方式
            ,act_settlemethod -- 实际交割方式
            ,act_advance_amount -- 暂未启用
            ,note -- 备注
            ,act_principal -- 实际本金
            ,act_interest -- 实际利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_payment_op(
            payment_id -- 支付ID
            ,aspclient_id -- 部门ID
            ,dealsconfirm_id -- 交易确认ID
            ,deal_tablename -- 交易表名
            ,deal_id -- 交易表对应记录ID
            ,eventtype -- 事件类型
            ,sequence -- 序列号
            ,payment_id_prev -- 前一个支付ID
            ,keepfolder_id -- 账户ID
            ,assettype -- 资产类型
            ,buztype -- 交易类型
            ,dealtype -- 作业类型
            ,actiontype -- 操作类型
            ,releasedate -- 发布日期
            ,generatedate -- 生成日期
            ,settledate -- 交割日期
            ,cpty_id -- 交易对手ID
            ,cpty_name -- 交易对手名称
            ,payreceivetype -- 收付类型
            ,settlecurrency -- 交割币种
            ,settleamount -- 交割金额
            ,securitycode -- 债券交割代码
            ,quantity -- 交割债券
            ,act_settledate -- 实际结算日期
            ,act_settlecurrency -- 实际交割币种
            ,act_settleamount -- 实际结算金额
            ,act_securitycode -- 实际交割债券代码
            ,act_quantity -- 实际交割债券
            ,pstatus -- 状态
            ,lastmodified -- 最后修改日期
            ,users_id_modifier -- 变更用户ID
            ,settlemethod -- 交割方式
            ,act_settlemethod -- 实际交割方式
            ,act_advance_amount -- 暂未启用
            ,note -- 备注
            ,act_principal -- 实际本金
            ,act_interest -- 实际利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.payment_id -- 支付ID
    ,o.aspclient_id -- 部门ID
    ,o.dealsconfirm_id -- 交易确认ID
    ,o.deal_tablename -- 交易表名
    ,o.deal_id -- 交易表对应记录ID
    ,o.eventtype -- 事件类型
    ,o.sequence -- 序列号
    ,o.payment_id_prev -- 前一个支付ID
    ,o.keepfolder_id -- 账户ID
    ,o.assettype -- 资产类型
    ,o.buztype -- 交易类型
    ,o.dealtype -- 作业类型
    ,o.actiontype -- 操作类型
    ,o.releasedate -- 发布日期
    ,o.generatedate -- 生成日期
    ,o.settledate -- 交割日期
    ,o.cpty_id -- 交易对手ID
    ,o.cpty_name -- 交易对手名称
    ,o.payreceivetype -- 收付类型
    ,o.settlecurrency -- 交割币种
    ,o.settleamount -- 交割金额
    ,o.securitycode -- 债券交割代码
    ,o.quantity -- 交割债券
    ,o.act_settledate -- 实际结算日期
    ,o.act_settlecurrency -- 实际交割币种
    ,o.act_settleamount -- 实际结算金额
    ,o.act_securitycode -- 实际交割债券代码
    ,o.act_quantity -- 实际交割债券
    ,o.pstatus -- 状态
    ,o.lastmodified -- 最后修改日期
    ,o.users_id_modifier -- 变更用户ID
    ,o.settlemethod -- 交割方式
    ,o.act_settlemethod -- 实际交割方式
    ,o.act_advance_amount -- 暂未启用
    ,o.note -- 备注
    ,o.act_principal -- 实际本金
    ,o.act_interest -- 实际利息
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_v_payment_bk o
    left join ${iol_schema}.ctms_tbs_v_payment_op n
        on
            o.payment_id = n.payment_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_payment_cl d
        on
            o.payment_id = d.payment_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_v_payment;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_v_payment exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_v_payment_cl;
alter table ${iol_schema}.ctms_tbs_v_payment exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_payment_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_payment to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_payment_op purge;
drop table ${iol_schema}.ctms_tbs_v_payment_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_payment_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_payment',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
