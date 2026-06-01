/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_chs_branch_charge_info
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
create table ${iol_schema}.bdms_chs_branch_charge_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_chs_branch_charge_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_chs_branch_charge_info_op purge;
drop table ${iol_schema}.bdms_chs_branch_charge_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_chs_branch_charge_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_chs_branch_charge_info where 0=1;

create table ${iol_schema}.bdms_chs_branch_charge_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_chs_branch_charge_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_chs_branch_charge_info_cl(
            id -- ID
            ,mem_no -- 会员代码
            ,brh_no -- 机构代码
            ,charge_period -- 服务费期数
            ,trans_amt -- 交易手续费计费金额
            ,trans_reb_amt -- 交易手续费优惠金额
            ,settle_amt -- 结算过户费计费金额
            ,settle_reb_amt -- 结算过户费优惠金额
            ,other_amt -- 其他结算费计费金额
            ,other_reb_amt -- 其他结算费优惠金额
            ,account_amt -- 账户维护费计费金额
            ,account_reb_amt -- 账户维护费优惠金额
            ,fee_amt -- 应缴金额
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_chs_branch_charge_info_op(
            id -- ID
            ,mem_no -- 会员代码
            ,brh_no -- 机构代码
            ,charge_period -- 服务费期数
            ,trans_amt -- 交易手续费计费金额
            ,trans_reb_amt -- 交易手续费优惠金额
            ,settle_amt -- 结算过户费计费金额
            ,settle_reb_amt -- 结算过户费优惠金额
            ,other_amt -- 其他结算费计费金额
            ,other_reb_amt -- 其他结算费优惠金额
            ,account_amt -- 账户维护费计费金额
            ,account_reb_amt -- 账户维护费优惠金额
            ,fee_amt -- 应缴金额
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.mem_no, o.mem_no) as mem_no -- 会员代码
    ,nvl(n.brh_no, o.brh_no) as brh_no -- 机构代码
    ,nvl(n.charge_period, o.charge_period) as charge_period -- 服务费期数
    ,nvl(n.trans_amt, o.trans_amt) as trans_amt -- 交易手续费计费金额
    ,nvl(n.trans_reb_amt, o.trans_reb_amt) as trans_reb_amt -- 交易手续费优惠金额
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算过户费计费金额
    ,nvl(n.settle_reb_amt, o.settle_reb_amt) as settle_reb_amt -- 结算过户费优惠金额
    ,nvl(n.other_amt, o.other_amt) as other_amt -- 其他结算费计费金额
    ,nvl(n.other_reb_amt, o.other_reb_amt) as other_reb_amt -- 其他结算费优惠金额
    ,nvl(n.account_amt, o.account_amt) as account_amt -- 账户维护费计费金额
    ,nvl(n.account_reb_amt, o.account_reb_amt) as account_reb_amt -- 账户维护费优惠金额
    ,nvl(n.fee_amt, o.fee_amt) as fee_amt -- 应缴金额
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 机构号
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后修改人
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.remark, o.remark) as remark -- 备注
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
from (select * from ${iol_schema}.bdms_chs_branch_charge_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_chs_branch_charge_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.mem_no <> n.mem_no
        or o.brh_no <> n.brh_no
        or o.charge_period <> n.charge_period
        or o.trans_amt <> n.trans_amt
        or o.trans_reb_amt <> n.trans_reb_amt
        or o.settle_amt <> n.settle_amt
        or o.settle_reb_amt <> n.settle_reb_amt
        or o.other_amt <> n.other_amt
        or o.other_reb_amt <> n.other_reb_amt
        or o.account_amt <> n.account_amt
        or o.account_reb_amt <> n.account_reb_amt
        or o.fee_amt <> n.fee_amt
        or o.account_status <> n.account_status
        or o.top_branch_no <> n.top_branch_no
        or o.branch_no <> n.branch_no
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.remark <> n.remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_chs_branch_charge_info_cl(
            id -- ID
            ,mem_no -- 会员代码
            ,brh_no -- 机构代码
            ,charge_period -- 服务费期数
            ,trans_amt -- 交易手续费计费金额
            ,trans_reb_amt -- 交易手续费优惠金额
            ,settle_amt -- 结算过户费计费金额
            ,settle_reb_amt -- 结算过户费优惠金额
            ,other_amt -- 其他结算费计费金额
            ,other_reb_amt -- 其他结算费优惠金额
            ,account_amt -- 账户维护费计费金额
            ,account_reb_amt -- 账户维护费优惠金额
            ,fee_amt -- 应缴金额
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_chs_branch_charge_info_op(
            id -- ID
            ,mem_no -- 会员代码
            ,brh_no -- 机构代码
            ,charge_period -- 服务费期数
            ,trans_amt -- 交易手续费计费金额
            ,trans_reb_amt -- 交易手续费优惠金额
            ,settle_amt -- 结算过户费计费金额
            ,settle_reb_amt -- 结算过户费优惠金额
            ,other_amt -- 其他结算费计费金额
            ,other_reb_amt -- 其他结算费优惠金额
            ,account_amt -- 账户维护费计费金额
            ,account_reb_amt -- 账户维护费优惠金额
            ,fee_amt -- 应缴金额
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.mem_no -- 会员代码
    ,o.brh_no -- 机构代码
    ,o.charge_period -- 服务费期数
    ,o.trans_amt -- 交易手续费计费金额
    ,o.trans_reb_amt -- 交易手续费优惠金额
    ,o.settle_amt -- 结算过户费计费金额
    ,o.settle_reb_amt -- 结算过户费优惠金额
    ,o.other_amt -- 其他结算费计费金额
    ,o.other_reb_amt -- 其他结算费优惠金额
    ,o.account_amt -- 账户维护费计费金额
    ,o.account_reb_amt -- 账户维护费优惠金额
    ,o.fee_amt -- 应缴金额
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.top_branch_no -- 总行机构号
    ,o.branch_no -- 机构号
    ,o.last_upd_opr -- 最后修改人
    ,o.last_upd_time -- 最后修改时间
    ,o.remark -- 备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_chs_branch_charge_info_bk o
    left join ${iol_schema}.bdms_chs_branch_charge_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_chs_branch_charge_info_cl d
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
-- truncate table ${iol_schema}.bdms_chs_branch_charge_info;

-- 4.2 exchange partition
alter table ${iol_schema}.bdms_chs_branch_charge_info exchange partition p_19000101 with table ${iol_schema}.bdms_chs_branch_charge_info_cl;
alter table ${iol_schema}.bdms_chs_branch_charge_info exchange partition p_20991231 with table ${iol_schema}.bdms_chs_branch_charge_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_chs_branch_charge_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_chs_branch_charge_info_op purge;
drop table ${iol_schema}.bdms_chs_branch_charge_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_chs_branch_charge_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_chs_branch_charge_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
