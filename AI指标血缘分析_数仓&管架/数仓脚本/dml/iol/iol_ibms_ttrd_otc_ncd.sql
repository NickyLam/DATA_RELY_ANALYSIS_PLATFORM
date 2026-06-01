/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_otc_ncd
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
create table ${iol_schema}.ibms_ttrd_otc_ncd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_otc_ncd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_otc_ncd_op purge;
drop table ${iol_schema}.ibms_ttrd_otc_ncd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_otc_ncd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_otc_ncd where 0=1;

create table ${iol_schema}.ibms_ttrd_otc_ncd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_otc_ncd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_otc_ncd_cl(
            i_code -- 存单代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,currency -- 币种
            ,q_type -- 报价方式
            ,b_name -- 存单名称
            ,p_type -- 产品分类
            ,p_class -- 产品分类名称
            ,b_coupon -- 利率%、利差BP
            ,ncdcount -- 发行量
            ,b_issue_price -- 发行价格
            ,min_issue_price -- 最低发行价格
            ,max_issue_price -- 最高发行价格
            ,b_start_date -- 起息日
            ,b_mtr_date -- 到期日
            ,b_term -- 期限
            ,first_date -- 首次利率确定日
            ,b_pay_freq -- 付息频率
            ,b_issue_mode -- 发行方式
            ,b_coupon_type -- 息票类型
            ,i_code_bench -- 利率基准
            ,a_type_bench -- 利率基准
            ,m_type_bench -- 利率基准
            ,settle_status -- 结算状态：0-未结算， 1-部分已结算， 2—已结算
            ,set_date -- 缴款日
            ,honour_date -- 兑付日
            ,b_issue_date -- 发行日
            ,annual_rate -- 年化利率
            ,b_daycount -- 计息基准
            ,b_fst_pay_date -- 首次付息日
            ,tender_type -- 招标方式 ，0为单一价格招标，1为数量招标
            ,min_rate -- 最低收益率，最低标位参考收益率
            ,max_rate -- 最高收益率，最高标位参考收益率
            ,b_actual_issue_amount -- 实际发行量(亿元)
            ,intordid -- 内部交易号
            ,issuer -- 发行人
            ,issuerange -- 范围
            ,gradeinst -- 评级机构
            ,grade -- 评级
            ,parvalue -- 票面
            ,issue_start_date -- 开始发行日期
            ,issue_mtr_date -- 结束发行日期
            ,max_bid_amount -- 最大认购量
            ,min_bid_amount -- 最小认购量
            ,singe_max_bid_amount -- 单笔最大认购量
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_otc_ncd_op(
            i_code -- 存单代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,currency -- 币种
            ,q_type -- 报价方式
            ,b_name -- 存单名称
            ,p_type -- 产品分类
            ,p_class -- 产品分类名称
            ,b_coupon -- 利率%、利差BP
            ,ncdcount -- 发行量
            ,b_issue_price -- 发行价格
            ,min_issue_price -- 最低发行价格
            ,max_issue_price -- 最高发行价格
            ,b_start_date -- 起息日
            ,b_mtr_date -- 到期日
            ,b_term -- 期限
            ,first_date -- 首次利率确定日
            ,b_pay_freq -- 付息频率
            ,b_issue_mode -- 发行方式
            ,b_coupon_type -- 息票类型
            ,i_code_bench -- 利率基准
            ,a_type_bench -- 利率基准
            ,m_type_bench -- 利率基准
            ,settle_status -- 结算状态：0-未结算， 1-部分已结算， 2—已结算
            ,set_date -- 缴款日
            ,honour_date -- 兑付日
            ,b_issue_date -- 发行日
            ,annual_rate -- 年化利率
            ,b_daycount -- 计息基准
            ,b_fst_pay_date -- 首次付息日
            ,tender_type -- 招标方式 ，0为单一价格招标，1为数量招标
            ,min_rate -- 最低收益率，最低标位参考收益率
            ,max_rate -- 最高收益率，最高标位参考收益率
            ,b_actual_issue_amount -- 实际发行量(亿元)
            ,intordid -- 内部交易号
            ,issuer -- 发行人
            ,issuerange -- 范围
            ,gradeinst -- 评级机构
            ,grade -- 评级
            ,parvalue -- 票面
            ,issue_start_date -- 开始发行日期
            ,issue_mtr_date -- 结束发行日期
            ,max_bid_amount -- 最大认购量
            ,min_bid_amount -- 最小认购量
            ,singe_max_bid_amount -- 单笔最大认购量
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_code, o.i_code) as i_code -- 存单代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.q_type, o.q_type) as q_type -- 报价方式
    ,nvl(n.b_name, o.b_name) as b_name -- 存单名称
    ,nvl(n.p_type, o.p_type) as p_type -- 产品分类
    ,nvl(n.p_class, o.p_class) as p_class -- 产品分类名称
    ,nvl(n.b_coupon, o.b_coupon) as b_coupon -- 利率%、利差BP
    ,nvl(n.ncdcount, o.ncdcount) as ncdcount -- 发行量
    ,nvl(n.b_issue_price, o.b_issue_price) as b_issue_price -- 发行价格
    ,nvl(n.min_issue_price, o.min_issue_price) as min_issue_price -- 最低发行价格
    ,nvl(n.max_issue_price, o.max_issue_price) as max_issue_price -- 最高发行价格
    ,nvl(n.b_start_date, o.b_start_date) as b_start_date -- 起息日
    ,nvl(n.b_mtr_date, o.b_mtr_date) as b_mtr_date -- 到期日
    ,nvl(n.b_term, o.b_term) as b_term -- 期限
    ,nvl(n.first_date, o.first_date) as first_date -- 首次利率确定日
    ,nvl(n.b_pay_freq, o.b_pay_freq) as b_pay_freq -- 付息频率
    ,nvl(n.b_issue_mode, o.b_issue_mode) as b_issue_mode -- 发行方式
    ,nvl(n.b_coupon_type, o.b_coupon_type) as b_coupon_type -- 息票类型
    ,nvl(n.i_code_bench, o.i_code_bench) as i_code_bench -- 利率基准
    ,nvl(n.a_type_bench, o.a_type_bench) as a_type_bench -- 利率基准
    ,nvl(n.m_type_bench, o.m_type_bench) as m_type_bench -- 利率基准
    ,nvl(n.settle_status, o.settle_status) as settle_status -- 结算状态：0-未结算， 1-部分已结算， 2—已结算
    ,nvl(n.set_date, o.set_date) as set_date -- 缴款日
    ,nvl(n.honour_date, o.honour_date) as honour_date -- 兑付日
    ,nvl(n.b_issue_date, o.b_issue_date) as b_issue_date -- 发行日
    ,nvl(n.annual_rate, o.annual_rate) as annual_rate -- 年化利率
    ,nvl(n.b_daycount, o.b_daycount) as b_daycount -- 计息基准
    ,nvl(n.b_fst_pay_date, o.b_fst_pay_date) as b_fst_pay_date -- 首次付息日
    ,nvl(n.tender_type, o.tender_type) as tender_type -- 招标方式 ，0为单一价格招标，1为数量招标
    ,nvl(n.min_rate, o.min_rate) as min_rate -- 最低收益率，最低标位参考收益率
    ,nvl(n.max_rate, o.max_rate) as max_rate -- 最高收益率，最高标位参考收益率
    ,nvl(n.b_actual_issue_amount, o.b_actual_issue_amount) as b_actual_issue_amount -- 实际发行量(亿元)
    ,nvl(n.intordid, o.intordid) as intordid -- 内部交易号
    ,nvl(n.issuer, o.issuer) as issuer -- 发行人
    ,nvl(n.issuerange, o.issuerange) as issuerange -- 范围
    ,nvl(n.gradeinst, o.gradeinst) as gradeinst -- 评级机构
    ,nvl(n.grade, o.grade) as grade -- 评级
    ,nvl(n.parvalue, o.parvalue) as parvalue -- 票面
    ,nvl(n.issue_start_date, o.issue_start_date) as issue_start_date -- 开始发行日期
    ,nvl(n.issue_mtr_date, o.issue_mtr_date) as issue_mtr_date -- 结束发行日期
    ,nvl(n.max_bid_amount, o.max_bid_amount) as max_bid_amount -- 最大认购量
    ,nvl(n.min_bid_amount, o.min_bid_amount) as min_bid_amount -- 最小认购量
    ,nvl(n.singe_max_bid_amount, o.singe_max_bid_amount) as singe_max_bid_amount -- 单笔最大认购量
    ,case when
            n.intordid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.intordid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.intordid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_otc_ncd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_otc_ncd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.intordid = n.intordid
where (
        o.intordid is null
    )
    or (
        n.intordid is null
    )
    or (
        o.i_code <> n.i_code
        or o.a_type <> n.a_type
        or o.m_type <> n.m_type
        or o.currency <> n.currency
        or o.q_type <> n.q_type
        or o.b_name <> n.b_name
        or o.p_type <> n.p_type
        or o.p_class <> n.p_class
        or o.b_coupon <> n.b_coupon
        or o.ncdcount <> n.ncdcount
        or o.b_issue_price <> n.b_issue_price
        or o.min_issue_price <> n.min_issue_price
        or o.max_issue_price <> n.max_issue_price
        or o.b_start_date <> n.b_start_date
        or o.b_mtr_date <> n.b_mtr_date
        or o.b_term <> n.b_term
        or o.first_date <> n.first_date
        or o.b_pay_freq <> n.b_pay_freq
        or o.b_issue_mode <> n.b_issue_mode
        or o.b_coupon_type <> n.b_coupon_type
        or o.i_code_bench <> n.i_code_bench
        or o.a_type_bench <> n.a_type_bench
        or o.m_type_bench <> n.m_type_bench
        or o.settle_status <> n.settle_status
        or o.set_date <> n.set_date
        or o.honour_date <> n.honour_date
        or o.b_issue_date <> n.b_issue_date
        or o.annual_rate <> n.annual_rate
        or o.b_daycount <> n.b_daycount
        or o.b_fst_pay_date <> n.b_fst_pay_date
        or o.tender_type <> n.tender_type
        or o.min_rate <> n.min_rate
        or o.max_rate <> n.max_rate
        or o.b_actual_issue_amount <> n.b_actual_issue_amount
        or o.issuer <> n.issuer
        or o.issuerange <> n.issuerange
        or o.gradeinst <> n.gradeinst
        or o.grade <> n.grade
        or o.parvalue <> n.parvalue
        or o.issue_start_date <> n.issue_start_date
        or o.issue_mtr_date <> n.issue_mtr_date
        or o.max_bid_amount <> n.max_bid_amount
        or o.min_bid_amount <> n.min_bid_amount
        or o.singe_max_bid_amount <> n.singe_max_bid_amount
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_otc_ncd_cl(
            i_code -- 存单代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,currency -- 币种
            ,q_type -- 报价方式
            ,b_name -- 存单名称
            ,p_type -- 产品分类
            ,p_class -- 产品分类名称
            ,b_coupon -- 利率%、利差BP
            ,ncdcount -- 发行量
            ,b_issue_price -- 发行价格
            ,min_issue_price -- 最低发行价格
            ,max_issue_price -- 最高发行价格
            ,b_start_date -- 起息日
            ,b_mtr_date -- 到期日
            ,b_term -- 期限
            ,first_date -- 首次利率确定日
            ,b_pay_freq -- 付息频率
            ,b_issue_mode -- 发行方式
            ,b_coupon_type -- 息票类型
            ,i_code_bench -- 利率基准
            ,a_type_bench -- 利率基准
            ,m_type_bench -- 利率基准
            ,settle_status -- 结算状态：0-未结算， 1-部分已结算， 2—已结算
            ,set_date -- 缴款日
            ,honour_date -- 兑付日
            ,b_issue_date -- 发行日
            ,annual_rate -- 年化利率
            ,b_daycount -- 计息基准
            ,b_fst_pay_date -- 首次付息日
            ,tender_type -- 招标方式 ，0为单一价格招标，1为数量招标
            ,min_rate -- 最低收益率，最低标位参考收益率
            ,max_rate -- 最高收益率，最高标位参考收益率
            ,b_actual_issue_amount -- 实际发行量(亿元)
            ,intordid -- 内部交易号
            ,issuer -- 发行人
            ,issuerange -- 范围
            ,gradeinst -- 评级机构
            ,grade -- 评级
            ,parvalue -- 票面
            ,issue_start_date -- 开始发行日期
            ,issue_mtr_date -- 结束发行日期
            ,max_bid_amount -- 最大认购量
            ,min_bid_amount -- 最小认购量
            ,singe_max_bid_amount -- 单笔最大认购量
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_otc_ncd_op(
            i_code -- 存单代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,currency -- 币种
            ,q_type -- 报价方式
            ,b_name -- 存单名称
            ,p_type -- 产品分类
            ,p_class -- 产品分类名称
            ,b_coupon -- 利率%、利差BP
            ,ncdcount -- 发行量
            ,b_issue_price -- 发行价格
            ,min_issue_price -- 最低发行价格
            ,max_issue_price -- 最高发行价格
            ,b_start_date -- 起息日
            ,b_mtr_date -- 到期日
            ,b_term -- 期限
            ,first_date -- 首次利率确定日
            ,b_pay_freq -- 付息频率
            ,b_issue_mode -- 发行方式
            ,b_coupon_type -- 息票类型
            ,i_code_bench -- 利率基准
            ,a_type_bench -- 利率基准
            ,m_type_bench -- 利率基准
            ,settle_status -- 结算状态：0-未结算， 1-部分已结算， 2—已结算
            ,set_date -- 缴款日
            ,honour_date -- 兑付日
            ,b_issue_date -- 发行日
            ,annual_rate -- 年化利率
            ,b_daycount -- 计息基准
            ,b_fst_pay_date -- 首次付息日
            ,tender_type -- 招标方式 ，0为单一价格招标，1为数量招标
            ,min_rate -- 最低收益率，最低标位参考收益率
            ,max_rate -- 最高收益率，最高标位参考收益率
            ,b_actual_issue_amount -- 实际发行量(亿元)
            ,intordid -- 内部交易号
            ,issuer -- 发行人
            ,issuerange -- 范围
            ,gradeinst -- 评级机构
            ,grade -- 评级
            ,parvalue -- 票面
            ,issue_start_date -- 开始发行日期
            ,issue_mtr_date -- 结束发行日期
            ,max_bid_amount -- 最大认购量
            ,min_bid_amount -- 最小认购量
            ,singe_max_bid_amount -- 单笔最大认购量
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_code -- 存单代码
    ,o.a_type -- 资产类型
    ,o.m_type -- 市场类型
    ,o.currency -- 币种
    ,o.q_type -- 报价方式
    ,o.b_name -- 存单名称
    ,o.p_type -- 产品分类
    ,o.p_class -- 产品分类名称
    ,o.b_coupon -- 利率%、利差BP
    ,o.ncdcount -- 发行量
    ,o.b_issue_price -- 发行价格
    ,o.min_issue_price -- 最低发行价格
    ,o.max_issue_price -- 最高发行价格
    ,o.b_start_date -- 起息日
    ,o.b_mtr_date -- 到期日
    ,o.b_term -- 期限
    ,o.first_date -- 首次利率确定日
    ,o.b_pay_freq -- 付息频率
    ,o.b_issue_mode -- 发行方式
    ,o.b_coupon_type -- 息票类型
    ,o.i_code_bench -- 利率基准
    ,o.a_type_bench -- 利率基准
    ,o.m_type_bench -- 利率基准
    ,o.settle_status -- 结算状态：0-未结算， 1-部分已结算， 2—已结算
    ,o.set_date -- 缴款日
    ,o.honour_date -- 兑付日
    ,o.b_issue_date -- 发行日
    ,o.annual_rate -- 年化利率
    ,o.b_daycount -- 计息基准
    ,o.b_fst_pay_date -- 首次付息日
    ,o.tender_type -- 招标方式 ，0为单一价格招标，1为数量招标
    ,o.min_rate -- 最低收益率，最低标位参考收益率
    ,o.max_rate -- 最高收益率，最高标位参考收益率
    ,o.b_actual_issue_amount -- 实际发行量(亿元)
    ,o.intordid -- 内部交易号
    ,o.issuer -- 发行人
    ,o.issuerange -- 范围
    ,o.gradeinst -- 评级机构
    ,o.grade -- 评级
    ,o.parvalue -- 票面
    ,o.issue_start_date -- 开始发行日期
    ,o.issue_mtr_date -- 结束发行日期
    ,o.max_bid_amount -- 最大认购量
    ,o.min_bid_amount -- 最小认购量
    ,o.singe_max_bid_amount -- 单笔最大认购量
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_otc_ncd_bk o
    left join ${iol_schema}.ibms_ttrd_otc_ncd_op n
        on
            o.intordid = n.intordid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_otc_ncd_cl d
        on
            o.intordid = d.intordid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_otc_ncd;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_otc_ncd exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_otc_ncd_cl;
alter table ${iol_schema}.ibms_ttrd_otc_ncd exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_otc_ncd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_otc_ncd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_otc_ncd_op purge;
drop table ${iol_schema}.ibms_ttrd_otc_ncd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_otc_ncd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_otc_ncd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
