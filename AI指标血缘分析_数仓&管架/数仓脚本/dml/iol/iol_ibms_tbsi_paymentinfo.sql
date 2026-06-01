/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_tbsi_paymentinfo
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
create table ${iol_schema}.ibms_tbsi_paymentinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_tbsi_paymentinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tbsi_paymentinfo_op purge;
drop table ${iol_schema}.ibms_tbsi_paymentinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tbsi_paymentinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tbsi_paymentinfo where 0=1;

create table ${iol_schema}.ibms_tbsi_paymentinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tbsi_paymentinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tbsi_paymentinfo_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,tg_code -- 任务组代码
            ,pi_id -- 现金流ID
            ,stream_id -- 利率流ID
            ,pi_fixed -- 是否是确定现金流
            ,pi_calcenddate -- 计息结束日期
            ,pi_paymentdate -- 支付日
            ,pi_amount -- 金额
            ,pi_discount -- 折现率
            ,pi_notionalamount -- 金额中的本金部分
            ,pi_notionalamount_forcasted -- 金额中的本金部分中的预测部分
            ,pi_interestamount -- 金额中的利息部分
            ,pi_interestamount_forcasted -- 金额中的利息部分中的预测部分
            ,pi_prenotionalamount -- 发生前本金
            ,pi_nextnotionalamount -- 发生后本金
            ,pi_premium -- 期权费
            ,pi_premium_forcasted -- 期权费中的预测部分
            ,pi_probability -- 概率
            ,imp_time -- 更新时间
            ,real_i_code -- 真实的金融工具代码
            ,pi_calcstartdate -- 计息开始日期
            ,pi_currency -- 币种
            ,pi_settlecurrency -- 结算币种
            ,pi_discounttime -- 贴现年化时间
            ,pe_code -- 定价环境代码
            ,beg_date -- 计算日期
            ,pi_cumudefaultrate -- 累积违约概率
            ,i_code_rpt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tbsi_paymentinfo_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,tg_code -- 任务组代码
            ,pi_id -- 现金流ID
            ,stream_id -- 利率流ID
            ,pi_fixed -- 是否是确定现金流
            ,pi_calcenddate -- 计息结束日期
            ,pi_paymentdate -- 支付日
            ,pi_amount -- 金额
            ,pi_discount -- 折现率
            ,pi_notionalamount -- 金额中的本金部分
            ,pi_notionalamount_forcasted -- 金额中的本金部分中的预测部分
            ,pi_interestamount -- 金额中的利息部分
            ,pi_interestamount_forcasted -- 金额中的利息部分中的预测部分
            ,pi_prenotionalamount -- 发生前本金
            ,pi_nextnotionalamount -- 发生后本金
            ,pi_premium -- 期权费
            ,pi_premium_forcasted -- 期权费中的预测部分
            ,pi_probability -- 概率
            ,imp_time -- 更新时间
            ,real_i_code -- 真实的金融工具代码
            ,pi_calcstartdate -- 计息开始日期
            ,pi_currency -- 币种
            ,pi_settlecurrency -- 结算币种
            ,pi_discounttime -- 贴现年化时间
            ,pe_code -- 定价环境代码
            ,beg_date -- 计算日期
            ,pi_cumudefaultrate -- 累积违约概率
            ,i_code_rpt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.tg_code, o.tg_code) as tg_code -- 任务组代码
    ,nvl(n.pi_id, o.pi_id) as pi_id -- 现金流ID
    ,nvl(n.stream_id, o.stream_id) as stream_id -- 利率流ID
    ,nvl(n.pi_fixed, o.pi_fixed) as pi_fixed -- 是否是确定现金流
    ,nvl(n.pi_calcenddate, o.pi_calcenddate) as pi_calcenddate -- 计息结束日期
    ,nvl(n.pi_paymentdate, o.pi_paymentdate) as pi_paymentdate -- 支付日
    ,nvl(n.pi_amount, o.pi_amount) as pi_amount -- 金额
    ,nvl(n.pi_discount, o.pi_discount) as pi_discount -- 折现率
    ,nvl(n.pi_notionalamount, o.pi_notionalamount) as pi_notionalamount -- 金额中的本金部分
    ,nvl(n.pi_notionalamount_forcasted, o.pi_notionalamount_forcasted) as pi_notionalamount_forcasted -- 金额中的本金部分中的预测部分
    ,nvl(n.pi_interestamount, o.pi_interestamount) as pi_interestamount -- 金额中的利息部分
    ,nvl(n.pi_interestamount_forcasted, o.pi_interestamount_forcasted) as pi_interestamount_forcasted -- 金额中的利息部分中的预测部分
    ,nvl(n.pi_prenotionalamount, o.pi_prenotionalamount) as pi_prenotionalamount -- 发生前本金
    ,nvl(n.pi_nextnotionalamount, o.pi_nextnotionalamount) as pi_nextnotionalamount -- 发生后本金
    ,nvl(n.pi_premium, o.pi_premium) as pi_premium -- 期权费
    ,nvl(n.pi_premium_forcasted, o.pi_premium_forcasted) as pi_premium_forcasted -- 期权费中的预测部分
    ,nvl(n.pi_probability, o.pi_probability) as pi_probability -- 概率
    ,nvl(n.imp_time, o.imp_time) as imp_time -- 更新时间
    ,nvl(n.real_i_code, o.real_i_code) as real_i_code -- 真实的金融工具代码
    ,nvl(n.pi_calcstartdate, o.pi_calcstartdate) as pi_calcstartdate -- 计息开始日期
    ,nvl(n.pi_currency, o.pi_currency) as pi_currency -- 币种
    ,nvl(n.pi_settlecurrency, o.pi_settlecurrency) as pi_settlecurrency -- 结算币种
    ,nvl(n.pi_discounttime, o.pi_discounttime) as pi_discounttime -- 贴现年化时间
    ,nvl(n.pe_code, o.pe_code) as pe_code -- 定价环境代码
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 计算日期
    ,nvl(n.pi_cumudefaultrate, o.pi_cumudefaultrate) as pi_cumudefaultrate -- 累积违约概率
    ,nvl(n.i_code_rpt, o.i_code_rpt) as i_code_rpt -- 
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.tg_code is null
            and n.pi_id is null
            and n.stream_id is null
            and n.pi_calcenddate is null
            and n.pe_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.tg_code is null
            and n.pi_id is null
            and n.stream_id is null
            and n.pi_calcenddate is null
            and n.pe_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.tg_code is null
            and n.pi_id is null
            and n.stream_id is null
            and n.pi_calcenddate is null
            and n.pe_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_tbsi_paymentinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_tbsi_paymentinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.tg_code = n.tg_code
            and o.pi_id = n.pi_id
            and o.stream_id = n.stream_id
            and o.pi_calcenddate = n.pi_calcenddate
            and o.pe_code = n.pe_code
where (
        o.i_code is null
        and o.a_type is null
        and o.m_type is null
        and o.tg_code is null
        and o.pi_id is null
        and o.stream_id is null
        and o.pi_calcenddate is null
        and o.pe_code is null
    )
    or (
        n.i_code is null
        and n.a_type is null
        and n.m_type is null
        and n.tg_code is null
        and n.pi_id is null
        and n.stream_id is null
        and n.pi_calcenddate is null
        and n.pe_code is null
    )
    or (
        o.pi_fixed <> n.pi_fixed
        or o.pi_paymentdate <> n.pi_paymentdate
        or o.pi_amount <> n.pi_amount
        or o.pi_discount <> n.pi_discount
        or o.pi_notionalamount <> n.pi_notionalamount
        or o.pi_notionalamount_forcasted <> n.pi_notionalamount_forcasted
        or o.pi_interestamount <> n.pi_interestamount
        or o.pi_interestamount_forcasted <> n.pi_interestamount_forcasted
        or o.pi_prenotionalamount <> n.pi_prenotionalamount
        or o.pi_nextnotionalamount <> n.pi_nextnotionalamount
        or o.pi_premium <> n.pi_premium
        or o.pi_premium_forcasted <> n.pi_premium_forcasted
        or o.pi_probability <> n.pi_probability
        or o.imp_time <> n.imp_time
        or o.real_i_code <> n.real_i_code
        or o.pi_calcstartdate <> n.pi_calcstartdate
        or o.pi_currency <> n.pi_currency
        or o.pi_settlecurrency <> n.pi_settlecurrency
        or o.pi_discounttime <> n.pi_discounttime
        or o.beg_date <> n.beg_date
        or o.pi_cumudefaultrate <> n.pi_cumudefaultrate
        or o.i_code_rpt <> n.i_code_rpt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tbsi_paymentinfo_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,tg_code -- 任务组代码
            ,pi_id -- 现金流ID
            ,stream_id -- 利率流ID
            ,pi_fixed -- 是否是确定现金流
            ,pi_calcenddate -- 计息结束日期
            ,pi_paymentdate -- 支付日
            ,pi_amount -- 金额
            ,pi_discount -- 折现率
            ,pi_notionalamount -- 金额中的本金部分
            ,pi_notionalamount_forcasted -- 金额中的本金部分中的预测部分
            ,pi_interestamount -- 金额中的利息部分
            ,pi_interestamount_forcasted -- 金额中的利息部分中的预测部分
            ,pi_prenotionalamount -- 发生前本金
            ,pi_nextnotionalamount -- 发生后本金
            ,pi_premium -- 期权费
            ,pi_premium_forcasted -- 期权费中的预测部分
            ,pi_probability -- 概率
            ,imp_time -- 更新时间
            ,real_i_code -- 真实的金融工具代码
            ,pi_calcstartdate -- 计息开始日期
            ,pi_currency -- 币种
            ,pi_settlecurrency -- 结算币种
            ,pi_discounttime -- 贴现年化时间
            ,pe_code -- 定价环境代码
            ,beg_date -- 计算日期
            ,pi_cumudefaultrate -- 累积违约概率
            ,i_code_rpt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tbsi_paymentinfo_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,tg_code -- 任务组代码
            ,pi_id -- 现金流ID
            ,stream_id -- 利率流ID
            ,pi_fixed -- 是否是确定现金流
            ,pi_calcenddate -- 计息结束日期
            ,pi_paymentdate -- 支付日
            ,pi_amount -- 金额
            ,pi_discount -- 折现率
            ,pi_notionalamount -- 金额中的本金部分
            ,pi_notionalamount_forcasted -- 金额中的本金部分中的预测部分
            ,pi_interestamount -- 金额中的利息部分
            ,pi_interestamount_forcasted -- 金额中的利息部分中的预测部分
            ,pi_prenotionalamount -- 发生前本金
            ,pi_nextnotionalamount -- 发生后本金
            ,pi_premium -- 期权费
            ,pi_premium_forcasted -- 期权费中的预测部分
            ,pi_probability -- 概率
            ,imp_time -- 更新时间
            ,real_i_code -- 真实的金融工具代码
            ,pi_calcstartdate -- 计息开始日期
            ,pi_currency -- 币种
            ,pi_settlecurrency -- 结算币种
            ,pi_discounttime -- 贴现年化时间
            ,pe_code -- 定价环境代码
            ,beg_date -- 计算日期
            ,pi_cumudefaultrate -- 累积违约概率
            ,i_code_rpt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_code -- 金融工具代码
    ,o.a_type -- 资产类型
    ,o.m_type -- 市场类型
    ,o.tg_code -- 任务组代码
    ,o.pi_id -- 现金流ID
    ,o.stream_id -- 利率流ID
    ,o.pi_fixed -- 是否是确定现金流
    ,o.pi_calcenddate -- 计息结束日期
    ,o.pi_paymentdate -- 支付日
    ,o.pi_amount -- 金额
    ,o.pi_discount -- 折现率
    ,o.pi_notionalamount -- 金额中的本金部分
    ,o.pi_notionalamount_forcasted -- 金额中的本金部分中的预测部分
    ,o.pi_interestamount -- 金额中的利息部分
    ,o.pi_interestamount_forcasted -- 金额中的利息部分中的预测部分
    ,o.pi_prenotionalamount -- 发生前本金
    ,o.pi_nextnotionalamount -- 发生后本金
    ,o.pi_premium -- 期权费
    ,o.pi_premium_forcasted -- 期权费中的预测部分
    ,o.pi_probability -- 概率
    ,o.imp_time -- 更新时间
    ,o.real_i_code -- 真实的金融工具代码
    ,o.pi_calcstartdate -- 计息开始日期
    ,o.pi_currency -- 币种
    ,o.pi_settlecurrency -- 结算币种
    ,o.pi_discounttime -- 贴现年化时间
    ,o.pe_code -- 定价环境代码
    ,o.beg_date -- 计算日期
    ,o.pi_cumudefaultrate -- 累积违约概率
    ,o.i_code_rpt -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_tbsi_paymentinfo_bk o
    left join ${iol_schema}.ibms_tbsi_paymentinfo_op n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.tg_code = n.tg_code
            and o.pi_id = n.pi_id
            and o.stream_id = n.stream_id
            and o.pi_calcenddate = n.pi_calcenddate
            and o.pe_code = n.pe_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_tbsi_paymentinfo_cl d
        on
            o.i_code = d.i_code
            and o.a_type = d.a_type
            and o.m_type = d.m_type
            and o.tg_code = d.tg_code
            and o.pi_id = d.pi_id
            and o.stream_id = d.stream_id
            and o.pi_calcenddate = d.pi_calcenddate
            and o.pe_code = d.pe_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_tbsi_paymentinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_tbsi_paymentinfo exchange partition p_19000101 with table ${iol_schema}.ibms_tbsi_paymentinfo_cl;
alter table ${iol_schema}.ibms_tbsi_paymentinfo exchange partition p_20991231 with table ${iol_schema}.ibms_tbsi_paymentinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_tbsi_paymentinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tbsi_paymentinfo_op purge;
drop table ${iol_schema}.ibms_tbsi_paymentinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_tbsi_paymentinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_tbsi_paymentinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
