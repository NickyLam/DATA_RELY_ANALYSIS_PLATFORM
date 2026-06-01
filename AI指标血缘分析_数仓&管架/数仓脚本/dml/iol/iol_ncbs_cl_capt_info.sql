/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_capt_info
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
create table ${iol_schema}.ncbs_cl_capt_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_capt_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_capt_info_op purge;
drop table ${iol_schema}.ncbs_cl_capt_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_capt_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_capt_info where 0=1;

create table ${iol_schema}.ncbs_cl_capt_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_capt_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_capt_info_cl(
            branch -- 机构编号
            ,business_unit -- 账套
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,days -- 天数
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,reference -- 交易参考号
            ,remark -- 备注
            ,agree_change_type -- 协议变动方式
            ,company -- 法人
            ,gl_posted_flag -- 过账标记
            ,reversal -- 是否冲正标志
            ,seq_no -- 序号
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,tax_type -- 税种
            ,tran_source -- 交易发起方
            ,tran_status -- 冲补抹标志
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,accounting_status -- 核算状态
            ,capt_date -- 结息日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,agree_fixed_rate -- 协议固定利率
            ,agree_percent_rate -- 协议浮动百分比
            ,agree_spread_rate -- 协议浮动百分点
            ,float_rate -- 浮动利率
            ,int_accrued -- 累计计提
            ,int_adj -- 利息调增金额
            ,int_amt -- 利息金额
            ,int_posted -- 结息金额
            ,int_posted_ctd -- 结息日利息金额
            ,loan_no -- 贷款号
            ,pay_int -- 前付息金额
            ,real_rate -- 执行利率
            ,tax_posted -- 利息税累计金额
            ,tax_posted_ctd -- 结息日利息税
            ,tax_rate -- 税率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_capt_info_op(
            branch -- 机构编号
            ,business_unit -- 账套
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,days -- 天数
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,reference -- 交易参考号
            ,remark -- 备注
            ,agree_change_type -- 协议变动方式
            ,company -- 法人
            ,gl_posted_flag -- 过账标记
            ,reversal -- 是否冲正标志
            ,seq_no -- 序号
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,tax_type -- 税种
            ,tran_source -- 交易发起方
            ,tran_status -- 冲补抹标志
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,accounting_status -- 核算状态
            ,capt_date -- 结息日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,agree_fixed_rate -- 协议固定利率
            ,agree_percent_rate -- 协议浮动百分比
            ,agree_spread_rate -- 协议浮动百分点
            ,float_rate -- 浮动利率
            ,int_accrued -- 累计计提
            ,int_adj -- 利息调增金额
            ,int_amt -- 利息金额
            ,int_posted -- 结息金额
            ,int_posted_ctd -- 结息日利息金额
            ,loan_no -- 贷款号
            ,pay_int -- 前付息金额
            ,real_rate -- 执行利率
            ,tax_posted -- 利息税累计金额
            ,tax_posted_ctd -- 结息日利息税
            ,tax_rate -- 税率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.business_unit, o.business_unit) as business_unit -- 账套
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.days, o.days) as days -- 天数
    ,nvl(n.int_type, o.int_type) as int_type -- 利率类型
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.profit_center, o.profit_center) as profit_center -- 利润中心
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.agree_change_type, o.agree_change_type) as agree_change_type -- 协议变动方式
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.gl_posted_flag, o.gl_posted_flag) as gl_posted_flag -- 过账标记
    ,nvl(n.reversal, o.reversal) as reversal -- 是否冲正标志
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.source_module, o.source_module) as source_module -- 源模块
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.tax_type, o.tax_type) as tax_type -- 税种
    ,nvl(n.tran_source, o.tran_source) as tran_source -- 交易发起方
    ,nvl(n.tran_status, o.tran_status) as tran_status -- 冲补抹标志
    ,nvl(n.year_basis, o.year_basis) as year_basis -- 年基准天数
    ,nvl(n.int_class, o.int_class) as int_class -- 利息分类
    ,nvl(n.accounting_status, o.accounting_status) as accounting_status -- 核算状态
    ,nvl(n.capt_date, o.capt_date) as capt_date -- 结息日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_fixed_rate, o.acct_fixed_rate) as acct_fixed_rate -- 分户级固定利率
    ,nvl(n.acct_percent_rate, o.acct_percent_rate) as acct_percent_rate -- 分户级利率浮动百分比
    ,nvl(n.acct_spread_rate, o.acct_spread_rate) as acct_spread_rate -- 分户级利率浮动百分点
    ,nvl(n.actual_rate, o.actual_rate) as actual_rate -- 行内利率
    ,nvl(n.agree_fixed_rate, o.agree_fixed_rate) as agree_fixed_rate -- 协议固定利率
    ,nvl(n.agree_percent_rate, o.agree_percent_rate) as agree_percent_rate -- 协议浮动百分比
    ,nvl(n.agree_spread_rate, o.agree_spread_rate) as agree_spread_rate -- 协议浮动百分点
    ,nvl(n.float_rate, o.float_rate) as float_rate -- 浮动利率
    ,nvl(n.int_accrued, o.int_accrued) as int_accrued -- 累计计提
    ,nvl(n.int_adj, o.int_adj) as int_adj -- 利息调增金额
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息金额
    ,nvl(n.int_posted, o.int_posted) as int_posted -- 结息金额
    ,nvl(n.int_posted_ctd, o.int_posted_ctd) as int_posted_ctd -- 结息日利息金额
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,nvl(n.pay_int, o.pay_int) as pay_int -- 前付息金额
    ,nvl(n.real_rate, o.real_rate) as real_rate -- 执行利率
    ,nvl(n.tax_posted, o.tax_posted) as tax_posted -- 利息税累计金额
    ,nvl(n.tax_posted_ctd, o.tax_posted_ctd) as tax_posted_ctd -- 结息日利息税
    ,nvl(n.tax_rate, o.tax_rate) as tax_rate -- 税率
    ,case when
            n.seq_no is null
            and n.capt_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_no is null
            and n.capt_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_no is null
            and n.capt_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_capt_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_capt_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
            and o.capt_date = n.capt_date
where (
        o.seq_no is null
        and o.capt_date is null
    )
    or (
        n.seq_no is null
        and n.capt_date is null
    )
    or (
        o.branch <> n.branch
        or o.business_unit <> n.business_unit
        or o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.client_type <> n.client_type
        or o.days <> n.days
        or o.int_type <> n.int_type
        or o.internal_key <> n.internal_key
        or o.prod_type <> n.prod_type
        or o.profit_center <> n.profit_center
        or o.reference <> n.reference
        or o.remark <> n.remark
        or o.agree_change_type <> n.agree_change_type
        or o.company <> n.company
        or o.gl_posted_flag <> n.gl_posted_flag
        or o.reversal <> n.reversal
        or o.source_module <> n.source_module
        or o.source_type <> n.source_type
        or o.tax_type <> n.tax_type
        or o.tran_source <> n.tran_source
        or o.tran_status <> n.tran_status
        or o.year_basis <> n.year_basis
        or o.int_class <> n.int_class
        or o.accounting_status <> n.accounting_status
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_fixed_rate <> n.acct_fixed_rate
        or o.acct_percent_rate <> n.acct_percent_rate
        or o.acct_spread_rate <> n.acct_spread_rate
        or o.actual_rate <> n.actual_rate
        or o.agree_fixed_rate <> n.agree_fixed_rate
        or o.agree_percent_rate <> n.agree_percent_rate
        or o.agree_spread_rate <> n.agree_spread_rate
        or o.float_rate <> n.float_rate
        or o.int_accrued <> n.int_accrued
        or o.int_adj <> n.int_adj
        or o.int_amt <> n.int_amt
        or o.int_posted <> n.int_posted
        or o.int_posted_ctd <> n.int_posted_ctd
        or o.loan_no <> n.loan_no
        or o.pay_int <> n.pay_int
        or o.real_rate <> n.real_rate
        or o.tax_posted <> n.tax_posted
        or o.tax_posted_ctd <> n.tax_posted_ctd
        or o.tax_rate <> n.tax_rate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_capt_info_cl(
            branch -- 机构编号
            ,business_unit -- 账套
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,days -- 天数
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,reference -- 交易参考号
            ,remark -- 备注
            ,agree_change_type -- 协议变动方式
            ,company -- 法人
            ,gl_posted_flag -- 过账标记
            ,reversal -- 是否冲正标志
            ,seq_no -- 序号
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,tax_type -- 税种
            ,tran_source -- 交易发起方
            ,tran_status -- 冲补抹标志
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,accounting_status -- 核算状态
            ,capt_date -- 结息日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,agree_fixed_rate -- 协议固定利率
            ,agree_percent_rate -- 协议浮动百分比
            ,agree_spread_rate -- 协议浮动百分点
            ,float_rate -- 浮动利率
            ,int_accrued -- 累计计提
            ,int_adj -- 利息调增金额
            ,int_amt -- 利息金额
            ,int_posted -- 结息金额
            ,int_posted_ctd -- 结息日利息金额
            ,loan_no -- 贷款号
            ,pay_int -- 前付息金额
            ,real_rate -- 执行利率
            ,tax_posted -- 利息税累计金额
            ,tax_posted_ctd -- 结息日利息税
            ,tax_rate -- 税率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_capt_info_op(
            branch -- 机构编号
            ,business_unit -- 账套
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,days -- 天数
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,reference -- 交易参考号
            ,remark -- 备注
            ,agree_change_type -- 协议变动方式
            ,company -- 法人
            ,gl_posted_flag -- 过账标记
            ,reversal -- 是否冲正标志
            ,seq_no -- 序号
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,tax_type -- 税种
            ,tran_source -- 交易发起方
            ,tran_status -- 冲补抹标志
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,accounting_status -- 核算状态
            ,capt_date -- 结息日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,agree_fixed_rate -- 协议固定利率
            ,agree_percent_rate -- 协议浮动百分比
            ,agree_spread_rate -- 协议浮动百分点
            ,float_rate -- 浮动利率
            ,int_accrued -- 累计计提
            ,int_adj -- 利息调增金额
            ,int_amt -- 利息金额
            ,int_posted -- 结息金额
            ,int_posted_ctd -- 结息日利息金额
            ,loan_no -- 贷款号
            ,pay_int -- 前付息金额
            ,real_rate -- 执行利率
            ,tax_posted -- 利息税累计金额
            ,tax_posted_ctd -- 结息日利息税
            ,tax_rate -- 税率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branch -- 机构编号
    ,o.business_unit -- 账套
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.client_type -- 客户类型
    ,o.days -- 天数
    ,o.int_type -- 利率类型
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.profit_center -- 利润中心
    ,o.reference -- 交易参考号
    ,o.remark -- 备注
    ,o.agree_change_type -- 协议变动方式
    ,o.company -- 法人
    ,o.gl_posted_flag -- 过账标记
    ,o.reversal -- 是否冲正标志
    ,o.seq_no -- 序号
    ,o.source_module -- 源模块
    ,o.source_type -- 渠道编号
    ,o.tax_type -- 税种
    ,o.tran_source -- 交易发起方
    ,o.tran_status -- 冲补抹标志
    ,o.year_basis -- 年基准天数
    ,o.int_class -- 利息分类
    ,o.accounting_status -- 核算状态
    ,o.capt_date -- 结息日期
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_fixed_rate -- 分户级固定利率
    ,o.acct_percent_rate -- 分户级利率浮动百分比
    ,o.acct_spread_rate -- 分户级利率浮动百分点
    ,o.actual_rate -- 行内利率
    ,o.agree_fixed_rate -- 协议固定利率
    ,o.agree_percent_rate -- 协议浮动百分比
    ,o.agree_spread_rate -- 协议浮动百分点
    ,o.float_rate -- 浮动利率
    ,o.int_accrued -- 累计计提
    ,o.int_adj -- 利息调增金额
    ,o.int_amt -- 利息金额
    ,o.int_posted -- 结息金额
    ,o.int_posted_ctd -- 结息日利息金额
    ,o.loan_no -- 贷款号
    ,o.pay_int -- 前付息金额
    ,o.real_rate -- 执行利率
    ,o.tax_posted -- 利息税累计金额
    ,o.tax_posted_ctd -- 结息日利息税
    ,o.tax_rate -- 税率
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
from ${iol_schema}.ncbs_cl_capt_info_bk o
    left join ${iol_schema}.ncbs_cl_capt_info_op n
        on
            o.seq_no = n.seq_no
            and o.capt_date = n.capt_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_capt_info_cl d
        on
            o.seq_no = d.seq_no
            and o.capt_date = d.capt_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_capt_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_capt_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_capt_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_capt_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_capt_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_capt_info_cl;
alter table ${iol_schema}.ncbs_cl_capt_info exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_capt_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_capt_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_capt_info_op purge;
drop table ${iol_schema}.ncbs_cl_capt_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_capt_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_capt_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
