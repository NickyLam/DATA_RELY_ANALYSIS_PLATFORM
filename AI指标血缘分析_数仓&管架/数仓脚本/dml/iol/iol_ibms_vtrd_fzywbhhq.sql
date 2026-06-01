/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_vtrd_fzywbhhq
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
create table ${iol_schema}.ibms_vtrd_fzywbhhq_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_vtrd_fzywbhhq
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_vtrd_fzywbhhq_op purge;
drop table ${iol_schema}.ibms_vtrd_fzywbhhq_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_fzywbhhq_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_vtrd_fzywbhhq where 0=1;

create table ${iol_schema}.ibms_vtrd_fzywbhhq_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_vtrd_fzywbhhq where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_vtrd_fzywbhhq_cl(
            obj_id -- 核算ID
            ,beg_date -- 余额日期
            ,trade_id -- 交易单号
            ,org_id -- 机构号
            ,secu_acct_name -- 投组单元
            ,secu_acct_type_name -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,i_code -- 金融工具代码
            ,i_name -- 金融工具名称
            ,trd_orddate -- 交易日期
            ,trd_party_name -- 交易对手
            ,trd_party_class -- 交易对手客户分类
            ,currency -- 币种
            ,cp -- 本金
            ,coupon -- 执行利率
            ,inst_start_date -- 起息日
            ,inst_mrt_date -- 到期日
            ,trem -- 原始期限
            ,sy_trem -- 剩余期限
            ,first_payment_date -- 首次付息日
            ,pay_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,ai -- 应计利息
            ,prft_ir -- 利息收入
            ,amount -- 余额
            ,tycb -- 摊余成本
            ,business_category_name -- 所属行业门类
            ,business_category_min_name -- 所属行业大类
            ,s_grade -- 债项/主体评级
            ,cash_ext_acct_code -- 本方账户
            ,party_acct_code -- 交易对手账户
            ,trader -- 经办人
            ,op_user_name1 -- 总行经办人
            ,op_user_name2 -- 总行复核人
            ,cp_subj_code -- 本金科目号
            ,ibs -- 数据来源
            ,hxkhh -- 交易对手核心客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_vtrd_fzywbhhq_op(
            obj_id -- 核算ID
            ,beg_date -- 余额日期
            ,trade_id -- 交易单号
            ,org_id -- 机构号
            ,secu_acct_name -- 投组单元
            ,secu_acct_type_name -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,i_code -- 金融工具代码
            ,i_name -- 金融工具名称
            ,trd_orddate -- 交易日期
            ,trd_party_name -- 交易对手
            ,trd_party_class -- 交易对手客户分类
            ,currency -- 币种
            ,cp -- 本金
            ,coupon -- 执行利率
            ,inst_start_date -- 起息日
            ,inst_mrt_date -- 到期日
            ,trem -- 原始期限
            ,sy_trem -- 剩余期限
            ,first_payment_date -- 首次付息日
            ,pay_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,ai -- 应计利息
            ,prft_ir -- 利息收入
            ,amount -- 余额
            ,tycb -- 摊余成本
            ,business_category_name -- 所属行业门类
            ,business_category_min_name -- 所属行业大类
            ,s_grade -- 债项/主体评级
            ,cash_ext_acct_code -- 本方账户
            ,party_acct_code -- 交易对手账户
            ,trader -- 经办人
            ,op_user_name1 -- 总行经办人
            ,op_user_name2 -- 总行复核人
            ,cp_subj_code -- 本金科目号
            ,ibs -- 数据来源
            ,hxkhh -- 交易对手核心客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.obj_id, o.obj_id) as obj_id -- 核算ID
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 余额日期
    ,nvl(n.trade_id, o.trade_id) as trade_id -- 交易单号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构号
    ,nvl(n.secu_acct_name, o.secu_acct_name) as secu_acct_name -- 投组单元
    ,nvl(n.secu_acct_type_name, o.secu_acct_type_name) as secu_acct_type_name -- 会计分类
    ,nvl(n.p_type_name, o.p_type_name) as p_type_name -- 产品类型
    ,nvl(n.p_class, o.p_class) as p_class -- 产品分类
    ,nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.i_name, o.i_name) as i_name -- 金融工具名称
    ,nvl(n.trd_orddate, o.trd_orddate) as trd_orddate -- 交易日期
    ,nvl(n.trd_party_name, o.trd_party_name) as trd_party_name -- 交易对手
    ,nvl(n.trd_party_class, o.trd_party_class) as trd_party_class -- 交易对手客户分类
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.cp, o.cp) as cp -- 本金
    ,nvl(n.coupon, o.coupon) as coupon -- 执行利率
    ,nvl(n.inst_start_date, o.inst_start_date) as inst_start_date -- 起息日
    ,nvl(n.inst_mrt_date, o.inst_mrt_date) as inst_mrt_date -- 到期日
    ,nvl(n.trem, o.trem) as trem -- 原始期限
    ,nvl(n.sy_trem, o.sy_trem) as sy_trem -- 剩余期限
    ,nvl(n.first_payment_date, o.first_payment_date) as first_payment_date -- 首次付息日
    ,nvl(n.pay_freq_name, o.pay_freq_name) as pay_freq_name -- 付息频率
    ,nvl(n.daycount_name, o.daycount_name) as daycount_name -- 计息基准
    ,nvl(n.coupon_type_name, o.coupon_type_name) as coupon_type_name -- 息票类型
    ,nvl(n.ai, o.ai) as ai -- 应计利息
    ,nvl(n.prft_ir, o.prft_ir) as prft_ir -- 利息收入
    ,nvl(n.amount, o.amount) as amount -- 余额
    ,nvl(n.tycb, o.tycb) as tycb -- 摊余成本
    ,nvl(n.business_category_name, o.business_category_name) as business_category_name -- 所属行业门类
    ,nvl(n.business_category_min_name, o.business_category_min_name) as business_category_min_name -- 所属行业大类
    ,nvl(n.s_grade, o.s_grade) as s_grade -- 债项/主体评级
    ,nvl(n.cash_ext_acct_code, o.cash_ext_acct_code) as cash_ext_acct_code -- 本方账户
    ,nvl(n.party_acct_code, o.party_acct_code) as party_acct_code -- 交易对手账户
    ,nvl(n.trader, o.trader) as trader -- 经办人
    ,nvl(n.op_user_name1, o.op_user_name1) as op_user_name1 -- 总行经办人
    ,nvl(n.op_user_name2, o.op_user_name2) as op_user_name2 -- 总行复核人
    ,nvl(n.cp_subj_code, o.cp_subj_code) as cp_subj_code -- 本金科目号
    ,nvl(n.ibs, o.ibs) as ibs -- 数据来源
    ,nvl(n.hxkhh, o.hxkhh) as hxkhh -- 交易对手核心客户号
    ,case when
            n.obj_id is null
            and n.beg_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.obj_id is null
            and n.beg_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.obj_id is null
            and n.beg_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_vtrd_fzywbhhq_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_vtrd_fzywbhhq where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.obj_id = n.obj_id
            and o.beg_date = n.beg_date
where (
        o.obj_id is null
        and o.beg_date is null
    )
    or (
        n.obj_id is null
        and n.beg_date is null
    )
    or (
        o.trade_id <> n.trade_id
        or o.org_id <> n.org_id
        or o.secu_acct_name <> n.secu_acct_name
        or o.secu_acct_type_name <> n.secu_acct_type_name
        or o.p_type_name <> n.p_type_name
        or o.p_class <> n.p_class
        or o.i_code <> n.i_code
        or o.i_name <> n.i_name
        or o.trd_orddate <> n.trd_orddate
        or o.trd_party_name <> n.trd_party_name
        or o.trd_party_class <> n.trd_party_class
        or o.currency <> n.currency
        or o.cp <> n.cp
        or o.coupon <> n.coupon
        or o.inst_start_date <> n.inst_start_date
        or o.inst_mrt_date <> n.inst_mrt_date
        or o.trem <> n.trem
        or o.sy_trem <> n.sy_trem
        or o.first_payment_date <> n.first_payment_date
        or o.pay_freq_name <> n.pay_freq_name
        or o.daycount_name <> n.daycount_name
        or o.coupon_type_name <> n.coupon_type_name
        or o.ai <> n.ai
        or o.prft_ir <> n.prft_ir
        or o.amount <> n.amount
        or o.tycb <> n.tycb
        or o.business_category_name <> n.business_category_name
        or o.business_category_min_name <> n.business_category_min_name
        or o.s_grade <> n.s_grade
        or o.cash_ext_acct_code <> n.cash_ext_acct_code
        or o.party_acct_code <> n.party_acct_code
        or o.trader <> n.trader
        or o.op_user_name1 <> n.op_user_name1
        or o.op_user_name2 <> n.op_user_name2
        or o.cp_subj_code <> n.cp_subj_code
        or o.ibs <> n.ibs
        or o.hxkhh <> n.hxkhh
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_vtrd_fzywbhhq_cl(
            obj_id -- 核算ID
            ,beg_date -- 余额日期
            ,trade_id -- 交易单号
            ,org_id -- 机构号
            ,secu_acct_name -- 投组单元
            ,secu_acct_type_name -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,i_code -- 金融工具代码
            ,i_name -- 金融工具名称
            ,trd_orddate -- 交易日期
            ,trd_party_name -- 交易对手
            ,trd_party_class -- 交易对手客户分类
            ,currency -- 币种
            ,cp -- 本金
            ,coupon -- 执行利率
            ,inst_start_date -- 起息日
            ,inst_mrt_date -- 到期日
            ,trem -- 原始期限
            ,sy_trem -- 剩余期限
            ,first_payment_date -- 首次付息日
            ,pay_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,ai -- 应计利息
            ,prft_ir -- 利息收入
            ,amount -- 余额
            ,tycb -- 摊余成本
            ,business_category_name -- 所属行业门类
            ,business_category_min_name -- 所属行业大类
            ,s_grade -- 债项/主体评级
            ,cash_ext_acct_code -- 本方账户
            ,party_acct_code -- 交易对手账户
            ,trader -- 经办人
            ,op_user_name1 -- 总行经办人
            ,op_user_name2 -- 总行复核人
            ,cp_subj_code -- 本金科目号
            ,ibs -- 数据来源
            ,hxkhh -- 交易对手核心客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_vtrd_fzywbhhq_op(
            obj_id -- 核算ID
            ,beg_date -- 余额日期
            ,trade_id -- 交易单号
            ,org_id -- 机构号
            ,secu_acct_name -- 投组单元
            ,secu_acct_type_name -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,i_code -- 金融工具代码
            ,i_name -- 金融工具名称
            ,trd_orddate -- 交易日期
            ,trd_party_name -- 交易对手
            ,trd_party_class -- 交易对手客户分类
            ,currency -- 币种
            ,cp -- 本金
            ,coupon -- 执行利率
            ,inst_start_date -- 起息日
            ,inst_mrt_date -- 到期日
            ,trem -- 原始期限
            ,sy_trem -- 剩余期限
            ,first_payment_date -- 首次付息日
            ,pay_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,ai -- 应计利息
            ,prft_ir -- 利息收入
            ,amount -- 余额
            ,tycb -- 摊余成本
            ,business_category_name -- 所属行业门类
            ,business_category_min_name -- 所属行业大类
            ,s_grade -- 债项/主体评级
            ,cash_ext_acct_code -- 本方账户
            ,party_acct_code -- 交易对手账户
            ,trader -- 经办人
            ,op_user_name1 -- 总行经办人
            ,op_user_name2 -- 总行复核人
            ,cp_subj_code -- 本金科目号
            ,ibs -- 数据来源
            ,hxkhh -- 交易对手核心客户号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.obj_id -- 核算ID
    ,o.beg_date -- 余额日期
    ,o.trade_id -- 交易单号
    ,o.org_id -- 机构号
    ,o.secu_acct_name -- 投组单元
    ,o.secu_acct_type_name -- 会计分类
    ,o.p_type_name -- 产品类型
    ,o.p_class -- 产品分类
    ,o.i_code -- 金融工具代码
    ,o.i_name -- 金融工具名称
    ,o.trd_orddate -- 交易日期
    ,o.trd_party_name -- 交易对手
    ,o.trd_party_class -- 交易对手客户分类
    ,o.currency -- 币种
    ,o.cp -- 本金
    ,o.coupon -- 执行利率
    ,o.inst_start_date -- 起息日
    ,o.inst_mrt_date -- 到期日
    ,o.trem -- 原始期限
    ,o.sy_trem -- 剩余期限
    ,o.first_payment_date -- 首次付息日
    ,o.pay_freq_name -- 付息频率
    ,o.daycount_name -- 计息基准
    ,o.coupon_type_name -- 息票类型
    ,o.ai -- 应计利息
    ,o.prft_ir -- 利息收入
    ,o.amount -- 余额
    ,o.tycb -- 摊余成本
    ,o.business_category_name -- 所属行业门类
    ,o.business_category_min_name -- 所属行业大类
    ,o.s_grade -- 债项/主体评级
    ,o.cash_ext_acct_code -- 本方账户
    ,o.party_acct_code -- 交易对手账户
    ,o.trader -- 经办人
    ,o.op_user_name1 -- 总行经办人
    ,o.op_user_name2 -- 总行复核人
    ,o.cp_subj_code -- 本金科目号
    ,o.ibs -- 数据来源
    ,o.hxkhh -- 交易对手核心客户号
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
from ${iol_schema}.ibms_vtrd_fzywbhhq_bk o
    left join ${iol_schema}.ibms_vtrd_fzywbhhq_op n
        on
            o.obj_id = n.obj_id
            and o.beg_date = n.beg_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_vtrd_fzywbhhq_cl d
        on
            o.obj_id = d.obj_id
            and o.beg_date = d.beg_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_vtrd_fzywbhhq;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_vtrd_fzywbhhq') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_vtrd_fzywbhhq drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_vtrd_fzywbhhq add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_vtrd_fzywbhhq exchange partition p_${batch_date} with table ${iol_schema}.ibms_vtrd_fzywbhhq_cl;
alter table ${iol_schema}.ibms_vtrd_fzywbhhq exchange partition p_20991231 with table ${iol_schema}.ibms_vtrd_fzywbhhq_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_vtrd_fzywbhhq to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_vtrd_fzywbhhq_op purge;
drop table ${iol_schema}.ibms_vtrd_fzywbhhq_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_vtrd_fzywbhhq_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_vtrd_fzywbhhq',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
