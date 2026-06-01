/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_fbs_v_ibo_accrual
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
create table ${iol_schema}.ctms_fbs_v_ibo_accrual_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_fbs_v_ibo_accrual;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_ibo_accrual_op purge;
drop table ${iol_schema}.ctms_fbs_v_ibo_accrual_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_ibo_accrual_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_ibo_accrual where 0=1;

create table ${iol_schema}.ctms_fbs_v_ibo_accrual_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_ibo_accrual where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_ibo_accrual_cl(
            cus_number -- 部门编号
            ,branch_id -- 后台的机构编号
            ,branch_number -- 分支机构号
            ,deal_sqno -- 投组交易的流水号
            ,crncy_code -- 贵金属货币
            ,first_amnt -- 交易量
            ,maturity_amnt -- 期末结算金额
            ,deal_rate -- 拆借利率
            ,deal_date -- 交易日期
            ,value_date -- 起息日
            ,maturity_date -- 到期日
            ,rate_type -- 利率类型
            ,trade_purpose -- 交易目的
            ,counter_party_id -- 交易对手ID
            ,intrst_basis -- 计息基准
            ,portfolio_id -- 投组ID
            ,load_date -- 计提日期
            ,total_accrual_amount -- 总的计提金额
            ,deal_dir -- 交易方向
            ,ibo_type -- 拆借类型
            ,client_deal_sqno -- 业务成交编号
            ,updtd_date -- 计提的更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_ibo_accrual_op(
            cus_number -- 部门编号
            ,branch_id -- 后台的机构编号
            ,branch_number -- 分支机构号
            ,deal_sqno -- 投组交易的流水号
            ,crncy_code -- 贵金属货币
            ,first_amnt -- 交易量
            ,maturity_amnt -- 期末结算金额
            ,deal_rate -- 拆借利率
            ,deal_date -- 交易日期
            ,value_date -- 起息日
            ,maturity_date -- 到期日
            ,rate_type -- 利率类型
            ,trade_purpose -- 交易目的
            ,counter_party_id -- 交易对手ID
            ,intrst_basis -- 计息基准
            ,portfolio_id -- 投组ID
            ,load_date -- 计提日期
            ,total_accrual_amount -- 总的计提金额
            ,deal_dir -- 交易方向
            ,ibo_type -- 拆借类型
            ,client_deal_sqno -- 业务成交编号
            ,updtd_date -- 计提的更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cus_number, o.cus_number) as cus_number -- 部门编号
    ,nvl(n.branch_id, o.branch_id) as branch_id -- 后台的机构编号
    ,nvl(n.branch_number, o.branch_number) as branch_number -- 分支机构号
    ,nvl(n.deal_sqno, o.deal_sqno) as deal_sqno -- 投组交易的流水号
    ,nvl(n.crncy_code, o.crncy_code) as crncy_code -- 贵金属货币
    ,nvl(n.first_amnt, o.first_amnt) as first_amnt -- 交易量
    ,nvl(n.maturity_amnt, o.maturity_amnt) as maturity_amnt -- 期末结算金额
    ,nvl(n.deal_rate, o.deal_rate) as deal_rate -- 拆借利率
    ,nvl(n.deal_date, o.deal_date) as deal_date -- 交易日期
    ,nvl(n.value_date, o.value_date) as value_date -- 起息日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日
    ,nvl(n.rate_type, o.rate_type) as rate_type -- 利率类型
    ,nvl(n.trade_purpose, o.trade_purpose) as trade_purpose -- 交易目的
    ,nvl(n.counter_party_id, o.counter_party_id) as counter_party_id -- 交易对手ID
    ,nvl(n.intrst_basis, o.intrst_basis) as intrst_basis -- 计息基准
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 投组ID
    ,nvl(n.load_date, o.load_date) as load_date -- 计提日期
    ,nvl(n.total_accrual_amount, o.total_accrual_amount) as total_accrual_amount -- 总的计提金额
    ,nvl(n.deal_dir, o.deal_dir) as deal_dir -- 交易方向
    ,nvl(n.ibo_type, o.ibo_type) as ibo_type -- 拆借类型
    ,nvl(n.client_deal_sqno, o.client_deal_sqno) as client_deal_sqno -- 业务成交编号
    ,nvl(n.updtd_date, o.updtd_date) as updtd_date -- 计提的更新时间
    ,case when
            n.cus_number is null
            and n.branch_number is null
            and n.deal_sqno is null
            and n.load_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cus_number is null
            and n.branch_number is null
            and n.deal_sqno is null
            and n.load_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cus_number is null
            and n.branch_number is null
            and n.deal_sqno is null
            and n.load_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_fbs_v_ibo_accrual_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_fbs_v_ibo_accrual where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cus_number = n.cus_number
            and o.branch_number = n.branch_number
            and o.deal_sqno = n.deal_sqno
            and o.load_date = n.load_date
where (
        o.cus_number is null
        and o.branch_number is null
        and o.deal_sqno is null
        and o.load_date is null
    )
    or (
        n.cus_number is null
        and n.branch_number is null
        and n.deal_sqno is null
        and n.load_date is null
    )
    or (
        o.branch_id <> n.branch_id
        or o.crncy_code <> n.crncy_code
        or o.first_amnt <> n.first_amnt
        or o.maturity_amnt <> n.maturity_amnt
        or o.deal_rate <> n.deal_rate
        or o.deal_date <> n.deal_date
        or o.value_date <> n.value_date
        or o.maturity_date <> n.maturity_date
        or o.rate_type <> n.rate_type
        or o.trade_purpose <> n.trade_purpose
        or o.counter_party_id <> n.counter_party_id
        or o.intrst_basis <> n.intrst_basis
        or o.portfolio_id <> n.portfolio_id
        or o.total_accrual_amount <> n.total_accrual_amount
        or o.deal_dir <> n.deal_dir
        or o.ibo_type <> n.ibo_type
        or o.client_deal_sqno <> n.client_deal_sqno
        or o.updtd_date <> n.updtd_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_ibo_accrual_cl(
            cus_number -- 部门编号
            ,branch_id -- 后台的机构编号
            ,branch_number -- 分支机构号
            ,deal_sqno -- 投组交易的流水号
            ,crncy_code -- 贵金属货币
            ,first_amnt -- 交易量
            ,maturity_amnt -- 期末结算金额
            ,deal_rate -- 拆借利率
            ,deal_date -- 交易日期
            ,value_date -- 起息日
            ,maturity_date -- 到期日
            ,rate_type -- 利率类型
            ,trade_purpose -- 交易目的
            ,counter_party_id -- 交易对手ID
            ,intrst_basis -- 计息基准
            ,portfolio_id -- 投组ID
            ,load_date -- 计提日期
            ,total_accrual_amount -- 总的计提金额
            ,deal_dir -- 交易方向
            ,ibo_type -- 拆借类型
            ,client_deal_sqno -- 业务成交编号
            ,updtd_date -- 计提的更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_ibo_accrual_op(
            cus_number -- 部门编号
            ,branch_id -- 后台的机构编号
            ,branch_number -- 分支机构号
            ,deal_sqno -- 投组交易的流水号
            ,crncy_code -- 贵金属货币
            ,first_amnt -- 交易量
            ,maturity_amnt -- 期末结算金额
            ,deal_rate -- 拆借利率
            ,deal_date -- 交易日期
            ,value_date -- 起息日
            ,maturity_date -- 到期日
            ,rate_type -- 利率类型
            ,trade_purpose -- 交易目的
            ,counter_party_id -- 交易对手ID
            ,intrst_basis -- 计息基准
            ,portfolio_id -- 投组ID
            ,load_date -- 计提日期
            ,total_accrual_amount -- 总的计提金额
            ,deal_dir -- 交易方向
            ,ibo_type -- 拆借类型
            ,client_deal_sqno -- 业务成交编号
            ,updtd_date -- 计提的更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cus_number -- 部门编号
    ,o.branch_id -- 后台的机构编号
    ,o.branch_number -- 分支机构号
    ,o.deal_sqno -- 投组交易的流水号
    ,o.crncy_code -- 贵金属货币
    ,o.first_amnt -- 交易量
    ,o.maturity_amnt -- 期末结算金额
    ,o.deal_rate -- 拆借利率
    ,o.deal_date -- 交易日期
    ,o.value_date -- 起息日
    ,o.maturity_date -- 到期日
    ,o.rate_type -- 利率类型
    ,o.trade_purpose -- 交易目的
    ,o.counter_party_id -- 交易对手ID
    ,o.intrst_basis -- 计息基准
    ,o.portfolio_id -- 投组ID
    ,o.load_date -- 计提日期
    ,o.total_accrual_amount -- 总的计提金额
    ,o.deal_dir -- 交易方向
    ,o.ibo_type -- 拆借类型
    ,o.client_deal_sqno -- 业务成交编号
    ,o.updtd_date -- 计提的更新时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_fbs_v_ibo_accrual_bk o
    left join ${iol_schema}.ctms_fbs_v_ibo_accrual_op n
        on
            o.cus_number = n.cus_number
            and o.branch_number = n.branch_number
            and o.deal_sqno = n.deal_sqno
            and o.load_date = n.load_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_fbs_v_ibo_accrual_cl d
        on
            o.cus_number = d.cus_number
            and o.branch_number = d.branch_number
            and o.deal_sqno = d.deal_sqno
            and o.load_date = d.load_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_fbs_v_ibo_accrual;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_fbs_v_ibo_accrual exchange partition p_19000101 with table ${iol_schema}.ctms_fbs_v_ibo_accrual_cl;
alter table ${iol_schema}.ctms_fbs_v_ibo_accrual exchange partition p_20991231 with table ${iol_schema}.ctms_fbs_v_ibo_accrual_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_fbs_v_ibo_accrual to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_ibo_accrual_op purge;
drop table ${iol_schema}.ctms_fbs_v_ibo_accrual_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_fbs_v_ibo_accrual_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_fbs_v_ibo_accrual',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
