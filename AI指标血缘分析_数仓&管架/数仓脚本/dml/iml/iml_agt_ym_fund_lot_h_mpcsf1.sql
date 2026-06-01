/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ym_fund_lot_h_mpcsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_ym_fund_lot_h add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ym_fund_lot_h partition for ('mpcsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_tm purge;
drop table ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_op purge;
drop table ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,lot_id -- 份额编号
    ,acct_id -- 账户编号
    ,ym_riches_acct_id -- 盈米财富账户编号
    ,mode_pay_id -- 支付方式编号
    ,fund_cd -- 基金代码
    ,prod_charge_way_cd -- 产品收费方式代码
    ,lot_tot -- 份额总数
    ,froz_lot -- 冻结份额
    ,unpaid_prft -- 未付收益
    ,divd_way_cd -- 分红方式代码
    ,inv_port_id -- 投资组合编号
    ,curr_prft -- 当前收益
    ,acm_prft -- 累计收益
    ,std_prod_id -- 标准产品编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ym_fund_lot_h partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ym_fund_lot_h partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ym_fund_lot_h partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a92sharedata-
insert into ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,lot_id -- 份额编号
    ,acct_id -- 账户编号
    ,ym_riches_acct_id -- 盈米财富账户编号
    ,mode_pay_id -- 支付方式编号
    ,fund_cd -- 基金代码
    ,prod_charge_way_cd -- 产品收费方式代码
    ,lot_tot -- 份额总数
    ,froz_lot -- 冻结份额
    ,unpaid_prft -- 未付收益
    ,divd_way_cd -- 分红方式代码
    ,inv_port_id -- 投资组合编号
    ,curr_prft -- 当前收益
    ,acm_prft -- 累计收益
    ,std_prod_id -- 标准产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '170000'||P1.BROKERUSERID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.PAYSYS -- 服务平台简称
    ,P1.INSTID -- 商户编号
    ,P1.SHAREID -- 份额编号
    ,P1.BROKERUSERID -- 账户编号
    ,P1.ACCOUNTID -- 盈米财富账户编号
    ,P1.PAYMENTMETHODID -- 支付方式编号
    ,P1.FUNDCODE -- 基金代码
    ,nvl(trim(P1.SHARETYPES),'-') -- 产品收费方式代码
    ,P1.TOTALSHARE -- 份额总数
    ,P1.FREEZESHARE -- 冻结份额
    ,P1.UNPAIDINCOME -- 未付收益
    ,nvl(trim(P1.DIVIDENDMETHOD),'-') -- 分红方式代码
    ,P1.POCODE -- 投资组合编号
    ,P1.NEWINCOME -- 当前收益
    ,P1.ACCUMULATEINCOME -- 累计收益
    ,' ' -- 标准产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a92sharedata' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a92sharedata p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,lot_id -- 份额编号
    ,acct_id -- 账户编号
    ,ym_riches_acct_id -- 盈米财富账户编号
    ,mode_pay_id -- 支付方式编号
    ,fund_cd -- 基金代码
    ,prod_charge_way_cd -- 产品收费方式代码
    ,lot_tot -- 份额总数
    ,froz_lot -- 冻结份额
    ,unpaid_prft -- 未付收益
    ,divd_way_cd -- 分红方式代码
    ,inv_port_id -- 投资组合编号
    ,curr_prft -- 当前收益
    ,acm_prft -- 累计收益
    ,std_prod_id -- 标准产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,lot_id -- 份额编号
    ,acct_id -- 账户编号
    ,ym_riches_acct_id -- 盈米财富账户编号
    ,mode_pay_id -- 支付方式编号
    ,fund_cd -- 基金代码
    ,prod_charge_way_cd -- 产品收费方式代码
    ,lot_tot -- 份额总数
    ,froz_lot -- 冻结份额
    ,unpaid_prft -- 未付收益
    ,divd_way_cd -- 分红方式代码
    ,inv_port_id -- 投资组合编号
    ,curr_prft -- 当前收益
    ,acm_prft -- 累计收益
    ,std_prod_id -- 标准产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.serv_plat_abbr, o.serv_plat_abbr) as serv_plat_abbr -- 服务平台简称
    ,nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.lot_id, o.lot_id) as lot_id -- 份额编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.ym_riches_acct_id, o.ym_riches_acct_id) as ym_riches_acct_id -- 盈米财富账户编号
    ,nvl(n.mode_pay_id, o.mode_pay_id) as mode_pay_id -- 支付方式编号
    ,nvl(n.fund_cd, o.fund_cd) as fund_cd -- 基金代码
    ,nvl(n.prod_charge_way_cd, o.prod_charge_way_cd) as prod_charge_way_cd -- 产品收费方式代码
    ,nvl(n.lot_tot, o.lot_tot) as lot_tot -- 份额总数
    ,nvl(n.froz_lot, o.froz_lot) as froz_lot -- 冻结份额
    ,nvl(n.unpaid_prft, o.unpaid_prft) as unpaid_prft -- 未付收益
    ,nvl(n.divd_way_cd, o.divd_way_cd) as divd_way_cd -- 分红方式代码
    ,nvl(n.inv_port_id, o.inv_port_id) as inv_port_id -- 投资组合编号
    ,nvl(n.curr_prft, o.curr_prft) as curr_prft -- 当前收益
    ,nvl(n.acm_prft, o.acm_prft) as acm_prft -- 累计收益
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,case when
            n.lp_id is null
            and n.lot_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.lp_id is null
            and n.lot_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.lp_id is null
            and n.lot_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_tm n
    full join (select * from ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.lp_id = n.lp_id
            and o.lot_id = n.lot_id
where (
        o.lp_id is null
        and o.lot_id is null
    )
    or (
        n.lp_id is null
        and n.lot_id is null
    )
    or (
        o.agt_id <> n.agt_id
        or o.serv_plat_abbr <> n.serv_plat_abbr
        or o.mercht_id <> n.mercht_id
        or o.acct_id <> n.acct_id
        or o.ym_riches_acct_id <> n.ym_riches_acct_id
        or o.mode_pay_id <> n.mode_pay_id
        or o.fund_cd <> n.fund_cd
        or o.prod_charge_way_cd <> n.prod_charge_way_cd
        or o.lot_tot <> n.lot_tot
        or o.froz_lot <> n.froz_lot
        or o.unpaid_prft <> n.unpaid_prft
        or o.divd_way_cd <> n.divd_way_cd
        or o.inv_port_id <> n.inv_port_id
        or o.curr_prft <> n.curr_prft
        or o.acm_prft <> n.acm_prft
        or o.std_prod_id <> n.std_prod_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,lot_id -- 份额编号
    ,acct_id -- 账户编号
    ,ym_riches_acct_id -- 盈米财富账户编号
    ,mode_pay_id -- 支付方式编号
    ,fund_cd -- 基金代码
    ,prod_charge_way_cd -- 产品收费方式代码
    ,lot_tot -- 份额总数
    ,froz_lot -- 冻结份额
    ,unpaid_prft -- 未付收益
    ,divd_way_cd -- 分红方式代码
    ,inv_port_id -- 投资组合编号
    ,curr_prft -- 当前收益
    ,acm_prft -- 累计收益
    ,std_prod_id -- 标准产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,serv_plat_abbr -- 服务平台简称
    ,mercht_id -- 商户编号
    ,lot_id -- 份额编号
    ,acct_id -- 账户编号
    ,ym_riches_acct_id -- 盈米财富账户编号
    ,mode_pay_id -- 支付方式编号
    ,fund_cd -- 基金代码
    ,prod_charge_way_cd -- 产品收费方式代码
    ,lot_tot -- 份额总数
    ,froz_lot -- 冻结份额
    ,unpaid_prft -- 未付收益
    ,divd_way_cd -- 分红方式代码
    ,inv_port_id -- 投资组合编号
    ,curr_prft -- 当前收益
    ,acm_prft -- 累计收益
    ,std_prod_id -- 标准产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.serv_plat_abbr -- 服务平台简称
    ,o.mercht_id -- 商户编号
    ,o.lot_id -- 份额编号
    ,o.acct_id -- 账户编号
    ,o.ym_riches_acct_id -- 盈米财富账户编号
    ,o.mode_pay_id -- 支付方式编号
    ,o.fund_cd -- 基金代码
    ,o.prod_charge_way_cd -- 产品收费方式代码
    ,o.lot_tot -- 份额总数
    ,o.froz_lot -- 冻结份额
    ,o.unpaid_prft -- 未付收益
    ,o.divd_way_cd -- 分红方式代码
    ,o.inv_port_id -- 投资组合编号
    ,o.curr_prft -- 当前收益
    ,o.acm_prft -- 累计收益
    ,o.std_prod_id -- 标准产品编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_bk o
    left join ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_op n
        on
            o.lp_id = n.lp_id
            and o.lot_id = n.lot_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_cl d
        on
            o.lp_id = d.lp_id
            and o.lot_id = d.lot_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_ym_fund_lot_h;
alter table ${iml_schema}.agt_ym_fund_lot_h truncate partition for ('mpcsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_ym_fund_lot_h exchange subpartition p_mpcsf1_19000101 with table ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_cl;
alter table ${iml_schema}.agt_ym_fund_lot_h exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ym_fund_lot_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_tm purge;
drop table ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_op purge;
drop table ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_ym_fund_lot_h_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ym_fund_lot_h', partname => 'p_mpcsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
