/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_prd_year_yield
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
create table ${iol_schema}.fams_prd_year_yield_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_prd_year_yield
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_prd_year_yield_op purge;
drop table ${iol_schema}.fams_prd_year_yield_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_prd_year_yield_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_prd_year_yield where 0=1;

create table ${iol_schema}.fams_prd_year_yield_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_prd_year_yield where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_prd_year_yield_cl(
            prod_id -- 产品代码
            ,prod_name -- 产品名称
            ,val_date -- 估值日期
            ,ccy -- 币种
            ,paidup_capital -- 实收资本（元）
            ,unit_net -- 单位净值
            ,total_net -- 累计净值
            ,asset_val -- 资产净值（元）
            ,day_yield -- 日年化收益率（%）
            ,seven_yield -- 七日年化收益率（%）
            ,month_yield -- 近1个月年化收益率（%）
            ,three_month_yield -- 近3个月年化收益率（%）
            ,six_month_yield -- 近6个月年化收益率（%）
            ,year_yield -- 近一年年化收益率（%）
            ,since_this_year_yield -- 今年以来年化收益率（%）
            ,two_year_yield -- 近两年年化收益率（%）
            ,three_year_yield -- 近三年年化收益率（%）
            ,establish_yield -- 成立以来年化收益率（%）
            ,upper_cycle_yield -- 上周期年化收益率（%）
            ,send_type -- 发送方式
            ,send_status -- 发送状态
            ,send_time -- 发送时间
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,seven_retreat_yield -- 七日最大回撤率
            ,month_retreat_yield -- 一个月最大回撤率
            ,three_month_retreat_yield -- 三个月最大回撤率
            ,six_month_retreat_yield -- 六个月最大回撤率
            ,year_retreat_yield -- 一年最大回撤率
            ,since_this_year_retreat_yield -- 今年以来最大回撤率
            ,establish_retreat_yield -- 成立以来以来最大回撤率
            ,deal_mode -- 产品处理模式
            ,profit_type -- 产品收益类型
            ,vdate -- 产品成立日
            ,mdate -- 产品到期日
            ,base_rule_value -- 业绩比较基准%
            ,tot_net_unit_value -- 累计单位净值/累计万份收益
            ,five_year_yield -- 近五年年化收益率（%）
            ,day_yield_chg -- 当日年化收益率涨跌幅
            ,seven_yield_chg -- 近七日年化收益率涨跌幅%
            ,month_yield_chg -- 近一个月年化收益率涨跌幅(%)
            ,three_month_yield_chg -- 近三个月年化收益率涨跌幅(%)
            ,six_month_yield_chg -- 近六个月年化收益率涨跌幅（%）
            ,year_yield_chg -- 近一年年化收益率涨跌幅（%）
            ,three_year_yield_chg -- 近三年年化收益率涨跌幅（%）
            ,five_year_yield_chg -- 近五年年化收益率涨跌幅（%）
            ,since_this_year_yield_chg -- 今年以来年化收益率涨跌幅（%）
            ,establish_yield_chg -- 成立以来年化收益率涨跌幅(%)
            ,past_fiscal_year_yield -- 过往会计年度年化收益率（一年）(%)
            ,past_fiscal_year_two_yield -- 过往会计年度年化收益率（两年）(%)
            ,past_fiscal_year_three_yield -- 过往会计年度年化收益率（三年）(%)
            ,past_fiscal_year_four_yield -- 过往会计年度年化收益率（四年）(%)
            ,past_fiscal_year_five_yield -- 过往会计年度年化收益率（五年）(%)
            ,raise_amt -- 募集余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_prd_year_yield_op(
            prod_id -- 产品代码
            ,prod_name -- 产品名称
            ,val_date -- 估值日期
            ,ccy -- 币种
            ,paidup_capital -- 实收资本（元）
            ,unit_net -- 单位净值
            ,total_net -- 累计净值
            ,asset_val -- 资产净值（元）
            ,day_yield -- 日年化收益率（%）
            ,seven_yield -- 七日年化收益率（%）
            ,month_yield -- 近1个月年化收益率（%）
            ,three_month_yield -- 近3个月年化收益率（%）
            ,six_month_yield -- 近6个月年化收益率（%）
            ,year_yield -- 近一年年化收益率（%）
            ,since_this_year_yield -- 今年以来年化收益率（%）
            ,two_year_yield -- 近两年年化收益率（%）
            ,three_year_yield -- 近三年年化收益率（%）
            ,establish_yield -- 成立以来年化收益率（%）
            ,upper_cycle_yield -- 上周期年化收益率（%）
            ,send_type -- 发送方式
            ,send_status -- 发送状态
            ,send_time -- 发送时间
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,seven_retreat_yield -- 七日最大回撤率
            ,month_retreat_yield -- 一个月最大回撤率
            ,three_month_retreat_yield -- 三个月最大回撤率
            ,six_month_retreat_yield -- 六个月最大回撤率
            ,year_retreat_yield -- 一年最大回撤率
            ,since_this_year_retreat_yield -- 今年以来最大回撤率
            ,establish_retreat_yield -- 成立以来以来最大回撤率
            ,deal_mode -- 产品处理模式
            ,profit_type -- 产品收益类型
            ,vdate -- 产品成立日
            ,mdate -- 产品到期日
            ,base_rule_value -- 业绩比较基准%
            ,tot_net_unit_value -- 累计单位净值/累计万份收益
            ,five_year_yield -- 近五年年化收益率（%）
            ,day_yield_chg -- 当日年化收益率涨跌幅
            ,seven_yield_chg -- 近七日年化收益率涨跌幅%
            ,month_yield_chg -- 近一个月年化收益率涨跌幅(%)
            ,three_month_yield_chg -- 近三个月年化收益率涨跌幅(%)
            ,six_month_yield_chg -- 近六个月年化收益率涨跌幅（%）
            ,year_yield_chg -- 近一年年化收益率涨跌幅（%）
            ,three_year_yield_chg -- 近三年年化收益率涨跌幅（%）
            ,five_year_yield_chg -- 近五年年化收益率涨跌幅（%）
            ,since_this_year_yield_chg -- 今年以来年化收益率涨跌幅（%）
            ,establish_yield_chg -- 成立以来年化收益率涨跌幅(%)
            ,past_fiscal_year_yield -- 过往会计年度年化收益率（一年）(%)
            ,past_fiscal_year_two_yield -- 过往会计年度年化收益率（两年）(%)
            ,past_fiscal_year_three_yield -- 过往会计年度年化收益率（三年）(%)
            ,past_fiscal_year_four_yield -- 过往会计年度年化收益率（四年）(%)
            ,past_fiscal_year_five_yield -- 过往会计年度年化收益率（五年）(%)
            ,raise_amt -- 募集余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品代码
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.val_date, o.val_date) as val_date -- 估值日期
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.paidup_capital, o.paidup_capital) as paidup_capital -- 实收资本（元）
    ,nvl(n.unit_net, o.unit_net) as unit_net -- 单位净值
    ,nvl(n.total_net, o.total_net) as total_net -- 累计净值
    ,nvl(n.asset_val, o.asset_val) as asset_val -- 资产净值（元）
    ,nvl(n.day_yield, o.day_yield) as day_yield -- 日年化收益率（%）
    ,nvl(n.seven_yield, o.seven_yield) as seven_yield -- 七日年化收益率（%）
    ,nvl(n.month_yield, o.month_yield) as month_yield -- 近1个月年化收益率（%）
    ,nvl(n.three_month_yield, o.three_month_yield) as three_month_yield -- 近3个月年化收益率（%）
    ,nvl(n.six_month_yield, o.six_month_yield) as six_month_yield -- 近6个月年化收益率（%）
    ,nvl(n.year_yield, o.year_yield) as year_yield -- 近一年年化收益率（%）
    ,nvl(n.since_this_year_yield, o.since_this_year_yield) as since_this_year_yield -- 今年以来年化收益率（%）
    ,nvl(n.two_year_yield, o.two_year_yield) as two_year_yield -- 近两年年化收益率（%）
    ,nvl(n.three_year_yield, o.three_year_yield) as three_year_yield -- 近三年年化收益率（%）
    ,nvl(n.establish_yield, o.establish_yield) as establish_yield -- 成立以来年化收益率（%）
    ,nvl(n.upper_cycle_yield, o.upper_cycle_yield) as upper_cycle_yield -- 上周期年化收益率（%）
    ,nvl(n.send_type, o.send_type) as send_type -- 发送方式
    ,nvl(n.send_status, o.send_status) as send_status -- 发送状态
    ,nvl(n.send_time, o.send_time) as send_time -- 发送时间
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.seven_retreat_yield, o.seven_retreat_yield) as seven_retreat_yield -- 七日最大回撤率
    ,nvl(n.month_retreat_yield, o.month_retreat_yield) as month_retreat_yield -- 一个月最大回撤率
    ,nvl(n.three_month_retreat_yield, o.three_month_retreat_yield) as three_month_retreat_yield -- 三个月最大回撤率
    ,nvl(n.six_month_retreat_yield, o.six_month_retreat_yield) as six_month_retreat_yield -- 六个月最大回撤率
    ,nvl(n.year_retreat_yield, o.year_retreat_yield) as year_retreat_yield -- 一年最大回撤率
    ,nvl(n.since_this_year_retreat_yield, o.since_this_year_retreat_yield) as since_this_year_retreat_yield -- 今年以来最大回撤率
    ,nvl(n.establish_retreat_yield, o.establish_retreat_yield) as establish_retreat_yield -- 成立以来以来最大回撤率
    ,nvl(n.deal_mode, o.deal_mode) as deal_mode -- 产品处理模式
    ,nvl(n.profit_type, o.profit_type) as profit_type -- 产品收益类型
    ,nvl(n.vdate, o.vdate) as vdate -- 产品成立日
    ,nvl(n.mdate, o.mdate) as mdate -- 产品到期日
    ,nvl(n.base_rule_value, o.base_rule_value) as base_rule_value -- 业绩比较基准%
    ,nvl(n.tot_net_unit_value, o.tot_net_unit_value) as tot_net_unit_value -- 累计单位净值/累计万份收益
    ,nvl(n.five_year_yield, o.five_year_yield) as five_year_yield -- 近五年年化收益率（%）
    ,nvl(n.day_yield_chg, o.day_yield_chg) as day_yield_chg -- 当日年化收益率涨跌幅
    ,nvl(n.seven_yield_chg, o.seven_yield_chg) as seven_yield_chg -- 近七日年化收益率涨跌幅%
    ,nvl(n.month_yield_chg, o.month_yield_chg) as month_yield_chg -- 近一个月年化收益率涨跌幅(%)
    ,nvl(n.three_month_yield_chg, o.three_month_yield_chg) as three_month_yield_chg -- 近三个月年化收益率涨跌幅(%)
    ,nvl(n.six_month_yield_chg, o.six_month_yield_chg) as six_month_yield_chg -- 近六个月年化收益率涨跌幅（%）
    ,nvl(n.year_yield_chg, o.year_yield_chg) as year_yield_chg -- 近一年年化收益率涨跌幅（%）
    ,nvl(n.three_year_yield_chg, o.three_year_yield_chg) as three_year_yield_chg -- 近三年年化收益率涨跌幅（%）
    ,nvl(n.five_year_yield_chg, o.five_year_yield_chg) as five_year_yield_chg -- 近五年年化收益率涨跌幅（%）
    ,nvl(n.since_this_year_yield_chg, o.since_this_year_yield_chg) as since_this_year_yield_chg -- 今年以来年化收益率涨跌幅（%）
    ,nvl(n.establish_yield_chg, o.establish_yield_chg) as establish_yield_chg -- 成立以来年化收益率涨跌幅(%)
    ,nvl(n.past_fiscal_year_yield, o.past_fiscal_year_yield) as past_fiscal_year_yield -- 过往会计年度年化收益率（一年）(%)
    ,nvl(n.past_fiscal_year_two_yield, o.past_fiscal_year_two_yield) as past_fiscal_year_two_yield -- 过往会计年度年化收益率（两年）(%)
    ,nvl(n.past_fiscal_year_three_yield, o.past_fiscal_year_three_yield) as past_fiscal_year_three_yield -- 过往会计年度年化收益率（三年）(%)
    ,nvl(n.past_fiscal_year_four_yield, o.past_fiscal_year_four_yield) as past_fiscal_year_four_yield -- 过往会计年度年化收益率（四年）(%)
    ,nvl(n.past_fiscal_year_five_yield, o.past_fiscal_year_five_yield) as past_fiscal_year_five_yield -- 过往会计年度年化收益率（五年）(%)
    ,nvl(n.raise_amt, o.raise_amt) as raise_amt -- 募集余额
    ,case when
            n.prod_id is null
            and n.val_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_id is null
            and n.val_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_id is null
            and n.val_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_prd_year_yield_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_prd_year_yield where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prod_id = n.prod_id
            and o.val_date = n.val_date
where (
        o.prod_id is null
        and o.val_date is null
    )
    or (
        n.prod_id is null
        and n.val_date is null
    )
    or (
        o.prod_name <> n.prod_name
        or o.ccy <> n.ccy
        or o.paidup_capital <> n.paidup_capital
        or o.unit_net <> n.unit_net
        or o.total_net <> n.total_net
        or o.asset_val <> n.asset_val
        or o.day_yield <> n.day_yield
        or o.seven_yield <> n.seven_yield
        or o.month_yield <> n.month_yield
        or o.three_month_yield <> n.three_month_yield
        or o.six_month_yield <> n.six_month_yield
        or o.year_yield <> n.year_yield
        or o.since_this_year_yield <> n.since_this_year_yield
        or o.two_year_yield <> n.two_year_yield
        or o.three_year_yield <> n.three_year_yield
        or o.establish_yield <> n.establish_yield
        or o.upper_cycle_yield <> n.upper_cycle_yield
        or o.send_type <> n.send_type
        or o.send_status <> n.send_status
        or o.send_time <> n.send_time
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.seven_retreat_yield <> n.seven_retreat_yield
        or o.month_retreat_yield <> n.month_retreat_yield
        or o.three_month_retreat_yield <> n.three_month_retreat_yield
        or o.six_month_retreat_yield <> n.six_month_retreat_yield
        or o.year_retreat_yield <> n.year_retreat_yield
        or o.since_this_year_retreat_yield <> n.since_this_year_retreat_yield
        or o.establish_retreat_yield <> n.establish_retreat_yield
        or o.deal_mode <> n.deal_mode
        or o.profit_type <> n.profit_type
        or o.vdate <> n.vdate
        or o.mdate <> n.mdate
        or o.base_rule_value <> n.base_rule_value
        or o.tot_net_unit_value <> n.tot_net_unit_value
        or o.five_year_yield <> n.five_year_yield
        or o.day_yield_chg <> n.day_yield_chg
        or o.seven_yield_chg <> n.seven_yield_chg
        or o.month_yield_chg <> n.month_yield_chg
        or o.three_month_yield_chg <> n.three_month_yield_chg
        or o.six_month_yield_chg <> n.six_month_yield_chg
        or o.year_yield_chg <> n.year_yield_chg
        or o.three_year_yield_chg <> n.three_year_yield_chg
        or o.five_year_yield_chg <> n.five_year_yield_chg
        or o.since_this_year_yield_chg <> n.since_this_year_yield_chg
        or o.establish_yield_chg <> n.establish_yield_chg
        or o.past_fiscal_year_yield <> n.past_fiscal_year_yield
        or o.past_fiscal_year_two_yield <> n.past_fiscal_year_two_yield
        or o.past_fiscal_year_three_yield <> n.past_fiscal_year_three_yield
        or o.past_fiscal_year_four_yield <> n.past_fiscal_year_four_yield
        or o.past_fiscal_year_five_yield <> n.past_fiscal_year_five_yield
        or o.raise_amt <> n.raise_amt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_prd_year_yield_cl(
            prod_id -- 产品代码
            ,prod_name -- 产品名称
            ,val_date -- 估值日期
            ,ccy -- 币种
            ,paidup_capital -- 实收资本（元）
            ,unit_net -- 单位净值
            ,total_net -- 累计净值
            ,asset_val -- 资产净值（元）
            ,day_yield -- 日年化收益率（%）
            ,seven_yield -- 七日年化收益率（%）
            ,month_yield -- 近1个月年化收益率（%）
            ,three_month_yield -- 近3个月年化收益率（%）
            ,six_month_yield -- 近6个月年化收益率（%）
            ,year_yield -- 近一年年化收益率（%）
            ,since_this_year_yield -- 今年以来年化收益率（%）
            ,two_year_yield -- 近两年年化收益率（%）
            ,three_year_yield -- 近三年年化收益率（%）
            ,establish_yield -- 成立以来年化收益率（%）
            ,upper_cycle_yield -- 上周期年化收益率（%）
            ,send_type -- 发送方式
            ,send_status -- 发送状态
            ,send_time -- 发送时间
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,seven_retreat_yield -- 七日最大回撤率
            ,month_retreat_yield -- 一个月最大回撤率
            ,three_month_retreat_yield -- 三个月最大回撤率
            ,six_month_retreat_yield -- 六个月最大回撤率
            ,year_retreat_yield -- 一年最大回撤率
            ,since_this_year_retreat_yield -- 今年以来最大回撤率
            ,establish_retreat_yield -- 成立以来以来最大回撤率
            ,deal_mode -- 产品处理模式
            ,profit_type -- 产品收益类型
            ,vdate -- 产品成立日
            ,mdate -- 产品到期日
            ,base_rule_value -- 业绩比较基准%
            ,tot_net_unit_value -- 累计单位净值/累计万份收益
            ,five_year_yield -- 近五年年化收益率（%）
            ,day_yield_chg -- 当日年化收益率涨跌幅
            ,seven_yield_chg -- 近七日年化收益率涨跌幅%
            ,month_yield_chg -- 近一个月年化收益率涨跌幅(%)
            ,three_month_yield_chg -- 近三个月年化收益率涨跌幅(%)
            ,six_month_yield_chg -- 近六个月年化收益率涨跌幅（%）
            ,year_yield_chg -- 近一年年化收益率涨跌幅（%）
            ,three_year_yield_chg -- 近三年年化收益率涨跌幅（%）
            ,five_year_yield_chg -- 近五年年化收益率涨跌幅（%）
            ,since_this_year_yield_chg -- 今年以来年化收益率涨跌幅（%）
            ,establish_yield_chg -- 成立以来年化收益率涨跌幅(%)
            ,past_fiscal_year_yield -- 过往会计年度年化收益率（一年）(%)
            ,past_fiscal_year_two_yield -- 过往会计年度年化收益率（两年）(%)
            ,past_fiscal_year_three_yield -- 过往会计年度年化收益率（三年）(%)
            ,past_fiscal_year_four_yield -- 过往会计年度年化收益率（四年）(%)
            ,past_fiscal_year_five_yield -- 过往会计年度年化收益率（五年）(%)
            ,raise_amt -- 募集余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_prd_year_yield_op(
            prod_id -- 产品代码
            ,prod_name -- 产品名称
            ,val_date -- 估值日期
            ,ccy -- 币种
            ,paidup_capital -- 实收资本（元）
            ,unit_net -- 单位净值
            ,total_net -- 累计净值
            ,asset_val -- 资产净值（元）
            ,day_yield -- 日年化收益率（%）
            ,seven_yield -- 七日年化收益率（%）
            ,month_yield -- 近1个月年化收益率（%）
            ,three_month_yield -- 近3个月年化收益率（%）
            ,six_month_yield -- 近6个月年化收益率（%）
            ,year_yield -- 近一年年化收益率（%）
            ,since_this_year_yield -- 今年以来年化收益率（%）
            ,two_year_yield -- 近两年年化收益率（%）
            ,three_year_yield -- 近三年年化收益率（%）
            ,establish_yield -- 成立以来年化收益率（%）
            ,upper_cycle_yield -- 上周期年化收益率（%）
            ,send_type -- 发送方式
            ,send_status -- 发送状态
            ,send_time -- 发送时间
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,seven_retreat_yield -- 七日最大回撤率
            ,month_retreat_yield -- 一个月最大回撤率
            ,three_month_retreat_yield -- 三个月最大回撤率
            ,six_month_retreat_yield -- 六个月最大回撤率
            ,year_retreat_yield -- 一年最大回撤率
            ,since_this_year_retreat_yield -- 今年以来最大回撤率
            ,establish_retreat_yield -- 成立以来以来最大回撤率
            ,deal_mode -- 产品处理模式
            ,profit_type -- 产品收益类型
            ,vdate -- 产品成立日
            ,mdate -- 产品到期日
            ,base_rule_value -- 业绩比较基准%
            ,tot_net_unit_value -- 累计单位净值/累计万份收益
            ,five_year_yield -- 近五年年化收益率（%）
            ,day_yield_chg -- 当日年化收益率涨跌幅
            ,seven_yield_chg -- 近七日年化收益率涨跌幅%
            ,month_yield_chg -- 近一个月年化收益率涨跌幅(%)
            ,three_month_yield_chg -- 近三个月年化收益率涨跌幅(%)
            ,six_month_yield_chg -- 近六个月年化收益率涨跌幅（%）
            ,year_yield_chg -- 近一年年化收益率涨跌幅（%）
            ,three_year_yield_chg -- 近三年年化收益率涨跌幅（%）
            ,five_year_yield_chg -- 近五年年化收益率涨跌幅（%）
            ,since_this_year_yield_chg -- 今年以来年化收益率涨跌幅（%）
            ,establish_yield_chg -- 成立以来年化收益率涨跌幅(%)
            ,past_fiscal_year_yield -- 过往会计年度年化收益率（一年）(%)
            ,past_fiscal_year_two_yield -- 过往会计年度年化收益率（两年）(%)
            ,past_fiscal_year_three_yield -- 过往会计年度年化收益率（三年）(%)
            ,past_fiscal_year_four_yield -- 过往会计年度年化收益率（四年）(%)
            ,past_fiscal_year_five_yield -- 过往会计年度年化收益率（五年）(%)
            ,raise_amt -- 募集余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prod_id -- 产品代码
    ,o.prod_name -- 产品名称
    ,o.val_date -- 估值日期
    ,o.ccy -- 币种
    ,o.paidup_capital -- 实收资本（元）
    ,o.unit_net -- 单位净值
    ,o.total_net -- 累计净值
    ,o.asset_val -- 资产净值（元）
    ,o.day_yield -- 日年化收益率（%）
    ,o.seven_yield -- 七日年化收益率（%）
    ,o.month_yield -- 近1个月年化收益率（%）
    ,o.three_month_yield -- 近3个月年化收益率（%）
    ,o.six_month_yield -- 近6个月年化收益率（%）
    ,o.year_yield -- 近一年年化收益率（%）
    ,o.since_this_year_yield -- 今年以来年化收益率（%）
    ,o.two_year_yield -- 近两年年化收益率（%）
    ,o.three_year_yield -- 近三年年化收益率（%）
    ,o.establish_yield -- 成立以来年化收益率（%）
    ,o.upper_cycle_yield -- 上周期年化收益率（%）
    ,o.send_type -- 发送方式
    ,o.send_status -- 发送状态
    ,o.send_time -- 发送时间
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.seven_retreat_yield -- 七日最大回撤率
    ,o.month_retreat_yield -- 一个月最大回撤率
    ,o.three_month_retreat_yield -- 三个月最大回撤率
    ,o.six_month_retreat_yield -- 六个月最大回撤率
    ,o.year_retreat_yield -- 一年最大回撤率
    ,o.since_this_year_retreat_yield -- 今年以来最大回撤率
    ,o.establish_retreat_yield -- 成立以来以来最大回撤率
    ,o.deal_mode -- 产品处理模式
    ,o.profit_type -- 产品收益类型
    ,o.vdate -- 产品成立日
    ,o.mdate -- 产品到期日
    ,o.base_rule_value -- 业绩比较基准%
    ,o.tot_net_unit_value -- 累计单位净值/累计万份收益
    ,o.five_year_yield -- 近五年年化收益率（%）
    ,o.day_yield_chg -- 当日年化收益率涨跌幅
    ,o.seven_yield_chg -- 近七日年化收益率涨跌幅%
    ,o.month_yield_chg -- 近一个月年化收益率涨跌幅(%)
    ,o.three_month_yield_chg -- 近三个月年化收益率涨跌幅(%)
    ,o.six_month_yield_chg -- 近六个月年化收益率涨跌幅（%）
    ,o.year_yield_chg -- 近一年年化收益率涨跌幅（%）
    ,o.three_year_yield_chg -- 近三年年化收益率涨跌幅（%）
    ,o.five_year_yield_chg -- 近五年年化收益率涨跌幅（%）
    ,o.since_this_year_yield_chg -- 今年以来年化收益率涨跌幅（%）
    ,o.establish_yield_chg -- 成立以来年化收益率涨跌幅(%)
    ,o.past_fiscal_year_yield -- 过往会计年度年化收益率（一年）(%)
    ,o.past_fiscal_year_two_yield -- 过往会计年度年化收益率（两年）(%)
    ,o.past_fiscal_year_three_yield -- 过往会计年度年化收益率（三年）(%)
    ,o.past_fiscal_year_four_yield -- 过往会计年度年化收益率（四年）(%)
    ,o.past_fiscal_year_five_yield -- 过往会计年度年化收益率（五年）(%)
    ,o.raise_amt -- 募集余额
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
from ${iol_schema}.fams_prd_year_yield_bk o
    left join ${iol_schema}.fams_prd_year_yield_op n
        on
            o.prod_id = n.prod_id
            and o.val_date = n.val_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_prd_year_yield_cl d
        on
            o.prod_id = d.prod_id
            and o.val_date = d.val_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_prd_year_yield;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_prd_year_yield') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_prd_year_yield drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_prd_year_yield add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_prd_year_yield exchange partition p_${batch_date} with table ${iol_schema}.fams_prd_year_yield_cl;
alter table ${iol_schema}.fams_prd_year_yield exchange partition p_20991231 with table ${iol_schema}.fams_prd_year_yield_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_prd_year_yield to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_prd_year_yield_op purge;
drop table ${iol_schema}.fams_prd_year_yield_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_prd_year_yield_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_prd_year_yield',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
