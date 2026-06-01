/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbprddailyext
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
create table ${iol_schema}.nfss_tbprddailyext_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tbprddailyext
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbprddailyext_op purge;
drop table ${iol_schema}.nfss_tbprddailyext_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbprddailyext_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbprddailyext where 0=1;

create table ${iol_schema}.nfss_tbprddailyext_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbprddailyext where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbprddailyext_cl(
            iss_date -- 发布日期
            ,cfm_date -- 确认日期(当天日期)
            ,prd_code -- 产品代码
            ,nav_flag -- 净值类型
            ,nav -- 基金单位净值
            ,tot_vol -- 基金总份数
            ,status -- 基金状态
            ,prd_name -- 产品名称
            ,periodic_status -- 定期定额状态
            ,chg_agc_status -- 转托管状态
            ,curr_type -- 结算币种
            ,announc_flag -- 公告标志
            ,div_mode -- 默认分红方式
            ,osubfirst_amt -- 机构首次认购最低金额
            ,osubfirst_vol -- 机构首次认购最低份额
            ,osubapp_amt -- 机构追加认购金额
            ,osubapp_vol -- 机构追加认购份额
            ,omaxsub_amt -- 机构最高认购金额
            ,omaxsub_vol -- 机构最高认购份数
            ,osubunit_amt -- 机构认购金额单位
            ,osubunit_vol -- 机构认购份额单位
            ,ofirst_amt -- 机构首次申购最低金额
            ,oapp_amt -- 机构追加申购最低金额
            ,omax_amt -- 机构最大申购金额
            ,omax_accu_amt -- 机构当日累计购买最大金额
            ,omax_accured_amt -- 机构当日累计赎回最大份额
            ,omax_red_vol -- 机构最大赎回份额
            ,psubfirst_amt -- 个人首次认购最低金额
            ,psubfirst_vol -- 个人首次认购最低份额
            ,psubapp_amt -- 个人追加认购金额
            ,psubapp_vol -- 个人追加认购份额
            ,pmaxsub_amt -- 个人最高认购金额
            ,pmaxsub_vol -- 个人最高认购份数
            ,psubunit_amt -- 个人认购金额单位
            ,psubunit_vol -- 个人认购份额单位
            ,pfirst_amt -- 个人首次申购最低金额
            ,papp_amt -- 个人追加申购最低金额
            ,pmax_amt -- 个人最大申购金额
            ,pmax_accu_amt -- 个人当日累计购买最大金额
            ,pmax_accured_amt -- 个人当日累计赎回最大份额
            ,pmax_red_vol -- 个人最大赎回份额
            ,max_red_vol -- 基金最高赎回份额
            ,min_hold_vol -- 基金最低持有份数
            ,min_red_vol -- 基金最少赎回份数
            ,min_conv_vol -- 最低基金转换份数
            ,piss_type -- 个人发行方式
            ,oiss_type -- 机构发行方式
            ,invest_amt -- 定投金额
            ,invest_date -- 定投日期
            ,prd_trustee -- 产品托管人
            ,ipo_start_date -- 募集开始日期
            ,ipo_end_date -- 募集结束日期
            ,divident_date -- 分红日
            ,reg_date -- 权益登记日期
            ,xr_date -- 除权日
            ,sub_type -- 认购方式
            ,transfee_type -- 交易费收取方式
            ,price -- 交易价格
            ,next_trade_date -- 下一交易日
            ,value_line -- 产品价值线数值
            ,total_bonus -- 累计单位分红
            ,fundincome_unit -- 货币基金万份收益
            ,fundincome_type -- 货币基金万份收益正负
            ,yield -- 货币基金七日年化收益率
            ,yield_flag -- 货币基金七日年化收益率正负
            ,guaranteed_nav -- 保本净值
            ,yearincome_rate -- 货币基金年收益率
            ,yearincome_flag -- 货币基金年收益率正负
            ,daily_income_flag -- 基金当日总收益正负
            ,daily_income -- 基金当日总收益
            ,breach_red_flag -- 允许违约赎回标志
            ,fund_type -- 基金类型
            ,fund_type_name -- 基金类型名称
            ,prd_sponsor -- 产品发起人
            ,ta_code -- TA代码
            ,ta_name -- TA名称
            ,prd_manager -- 产品管理人
            ,prd_manager_name -- 基金管理人名称
            ,service_tel -- 基金公司客服电话
            ,internet_address -- 基金公司网站网址
            ,monthincome_rate -- 月年化收益率
            ,monthincome_flag -- 月年化收益率正负
            ,quarter_rate -- 季度年化收益率
            ,quarter_rate_flag -- 季度年化收益率正负
            ,cycle_rate -- 周期收益率
            ,cycle_rate_flag -- 周期收益率正负
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,reserve3 -- 备用3
            ,nav_date -- 资管净值日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbprddailyext_op(
            iss_date -- 发布日期
            ,cfm_date -- 确认日期(当天日期)
            ,prd_code -- 产品代码
            ,nav_flag -- 净值类型
            ,nav -- 基金单位净值
            ,tot_vol -- 基金总份数
            ,status -- 基金状态
            ,prd_name -- 产品名称
            ,periodic_status -- 定期定额状态
            ,chg_agc_status -- 转托管状态
            ,curr_type -- 结算币种
            ,announc_flag -- 公告标志
            ,div_mode -- 默认分红方式
            ,osubfirst_amt -- 机构首次认购最低金额
            ,osubfirst_vol -- 机构首次认购最低份额
            ,osubapp_amt -- 机构追加认购金额
            ,osubapp_vol -- 机构追加认购份额
            ,omaxsub_amt -- 机构最高认购金额
            ,omaxsub_vol -- 机构最高认购份数
            ,osubunit_amt -- 机构认购金额单位
            ,osubunit_vol -- 机构认购份额单位
            ,ofirst_amt -- 机构首次申购最低金额
            ,oapp_amt -- 机构追加申购最低金额
            ,omax_amt -- 机构最大申购金额
            ,omax_accu_amt -- 机构当日累计购买最大金额
            ,omax_accured_amt -- 机构当日累计赎回最大份额
            ,omax_red_vol -- 机构最大赎回份额
            ,psubfirst_amt -- 个人首次认购最低金额
            ,psubfirst_vol -- 个人首次认购最低份额
            ,psubapp_amt -- 个人追加认购金额
            ,psubapp_vol -- 个人追加认购份额
            ,pmaxsub_amt -- 个人最高认购金额
            ,pmaxsub_vol -- 个人最高认购份数
            ,psubunit_amt -- 个人认购金额单位
            ,psubunit_vol -- 个人认购份额单位
            ,pfirst_amt -- 个人首次申购最低金额
            ,papp_amt -- 个人追加申购最低金额
            ,pmax_amt -- 个人最大申购金额
            ,pmax_accu_amt -- 个人当日累计购买最大金额
            ,pmax_accured_amt -- 个人当日累计赎回最大份额
            ,pmax_red_vol -- 个人最大赎回份额
            ,max_red_vol -- 基金最高赎回份额
            ,min_hold_vol -- 基金最低持有份数
            ,min_red_vol -- 基金最少赎回份数
            ,min_conv_vol -- 最低基金转换份数
            ,piss_type -- 个人发行方式
            ,oiss_type -- 机构发行方式
            ,invest_amt -- 定投金额
            ,invest_date -- 定投日期
            ,prd_trustee -- 产品托管人
            ,ipo_start_date -- 募集开始日期
            ,ipo_end_date -- 募集结束日期
            ,divident_date -- 分红日
            ,reg_date -- 权益登记日期
            ,xr_date -- 除权日
            ,sub_type -- 认购方式
            ,transfee_type -- 交易费收取方式
            ,price -- 交易价格
            ,next_trade_date -- 下一交易日
            ,value_line -- 产品价值线数值
            ,total_bonus -- 累计单位分红
            ,fundincome_unit -- 货币基金万份收益
            ,fundincome_type -- 货币基金万份收益正负
            ,yield -- 货币基金七日年化收益率
            ,yield_flag -- 货币基金七日年化收益率正负
            ,guaranteed_nav -- 保本净值
            ,yearincome_rate -- 货币基金年收益率
            ,yearincome_flag -- 货币基金年收益率正负
            ,daily_income_flag -- 基金当日总收益正负
            ,daily_income -- 基金当日总收益
            ,breach_red_flag -- 允许违约赎回标志
            ,fund_type -- 基金类型
            ,fund_type_name -- 基金类型名称
            ,prd_sponsor -- 产品发起人
            ,ta_code -- TA代码
            ,ta_name -- TA名称
            ,prd_manager -- 产品管理人
            ,prd_manager_name -- 基金管理人名称
            ,service_tel -- 基金公司客服电话
            ,internet_address -- 基金公司网站网址
            ,monthincome_rate -- 月年化收益率
            ,monthincome_flag -- 月年化收益率正负
            ,quarter_rate -- 季度年化收益率
            ,quarter_rate_flag -- 季度年化收益率正负
            ,cycle_rate -- 周期收益率
            ,cycle_rate_flag -- 周期收益率正负
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,reserve3 -- 备用3
            ,nav_date -- 资管净值日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.iss_date, o.iss_date) as iss_date -- 发布日期
    ,nvl(n.cfm_date, o.cfm_date) as cfm_date -- 确认日期(当天日期)
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 产品代码
    ,nvl(n.nav_flag, o.nav_flag) as nav_flag -- 净值类型
    ,nvl(n.nav, o.nav) as nav -- 基金单位净值
    ,nvl(n.tot_vol, o.tot_vol) as tot_vol -- 基金总份数
    ,nvl(n.status, o.status) as status -- 基金状态
    ,nvl(n.prd_name, o.prd_name) as prd_name -- 产品名称
    ,nvl(n.periodic_status, o.periodic_status) as periodic_status -- 定期定额状态
    ,nvl(n.chg_agc_status, o.chg_agc_status) as chg_agc_status -- 转托管状态
    ,nvl(n.curr_type, o.curr_type) as curr_type -- 结算币种
    ,nvl(n.announc_flag, o.announc_flag) as announc_flag -- 公告标志
    ,nvl(n.div_mode, o.div_mode) as div_mode -- 默认分红方式
    ,nvl(n.osubfirst_amt, o.osubfirst_amt) as osubfirst_amt -- 机构首次认购最低金额
    ,nvl(n.osubfirst_vol, o.osubfirst_vol) as osubfirst_vol -- 机构首次认购最低份额
    ,nvl(n.osubapp_amt, o.osubapp_amt) as osubapp_amt -- 机构追加认购金额
    ,nvl(n.osubapp_vol, o.osubapp_vol) as osubapp_vol -- 机构追加认购份额
    ,nvl(n.omaxsub_amt, o.omaxsub_amt) as omaxsub_amt -- 机构最高认购金额
    ,nvl(n.omaxsub_vol, o.omaxsub_vol) as omaxsub_vol -- 机构最高认购份数
    ,nvl(n.osubunit_amt, o.osubunit_amt) as osubunit_amt -- 机构认购金额单位
    ,nvl(n.osubunit_vol, o.osubunit_vol) as osubunit_vol -- 机构认购份额单位
    ,nvl(n.ofirst_amt, o.ofirst_amt) as ofirst_amt -- 机构首次申购最低金额
    ,nvl(n.oapp_amt, o.oapp_amt) as oapp_amt -- 机构追加申购最低金额
    ,nvl(n.omax_amt, o.omax_amt) as omax_amt -- 机构最大申购金额
    ,nvl(n.omax_accu_amt, o.omax_accu_amt) as omax_accu_amt -- 机构当日累计购买最大金额
    ,nvl(n.omax_accured_amt, o.omax_accured_amt) as omax_accured_amt -- 机构当日累计赎回最大份额
    ,nvl(n.omax_red_vol, o.omax_red_vol) as omax_red_vol -- 机构最大赎回份额
    ,nvl(n.psubfirst_amt, o.psubfirst_amt) as psubfirst_amt -- 个人首次认购最低金额
    ,nvl(n.psubfirst_vol, o.psubfirst_vol) as psubfirst_vol -- 个人首次认购最低份额
    ,nvl(n.psubapp_amt, o.psubapp_amt) as psubapp_amt -- 个人追加认购金额
    ,nvl(n.psubapp_vol, o.psubapp_vol) as psubapp_vol -- 个人追加认购份额
    ,nvl(n.pmaxsub_amt, o.pmaxsub_amt) as pmaxsub_amt -- 个人最高认购金额
    ,nvl(n.pmaxsub_vol, o.pmaxsub_vol) as pmaxsub_vol -- 个人最高认购份数
    ,nvl(n.psubunit_amt, o.psubunit_amt) as psubunit_amt -- 个人认购金额单位
    ,nvl(n.psubunit_vol, o.psubunit_vol) as psubunit_vol -- 个人认购份额单位
    ,nvl(n.pfirst_amt, o.pfirst_amt) as pfirst_amt -- 个人首次申购最低金额
    ,nvl(n.papp_amt, o.papp_amt) as papp_amt -- 个人追加申购最低金额
    ,nvl(n.pmax_amt, o.pmax_amt) as pmax_amt -- 个人最大申购金额
    ,nvl(n.pmax_accu_amt, o.pmax_accu_amt) as pmax_accu_amt -- 个人当日累计购买最大金额
    ,nvl(n.pmax_accured_amt, o.pmax_accured_amt) as pmax_accured_amt -- 个人当日累计赎回最大份额
    ,nvl(n.pmax_red_vol, o.pmax_red_vol) as pmax_red_vol -- 个人最大赎回份额
    ,nvl(n.max_red_vol, o.max_red_vol) as max_red_vol -- 基金最高赎回份额
    ,nvl(n.min_hold_vol, o.min_hold_vol) as min_hold_vol -- 基金最低持有份数
    ,nvl(n.min_red_vol, o.min_red_vol) as min_red_vol -- 基金最少赎回份数
    ,nvl(n.min_conv_vol, o.min_conv_vol) as min_conv_vol -- 最低基金转换份数
    ,nvl(n.piss_type, o.piss_type) as piss_type -- 个人发行方式
    ,nvl(n.oiss_type, o.oiss_type) as oiss_type -- 机构发行方式
    ,nvl(n.invest_amt, o.invest_amt) as invest_amt -- 定投金额
    ,nvl(n.invest_date, o.invest_date) as invest_date -- 定投日期
    ,nvl(n.prd_trustee, o.prd_trustee) as prd_trustee -- 产品托管人
    ,nvl(n.ipo_start_date, o.ipo_start_date) as ipo_start_date -- 募集开始日期
    ,nvl(n.ipo_end_date, o.ipo_end_date) as ipo_end_date -- 募集结束日期
    ,nvl(n.divident_date, o.divident_date) as divident_date -- 分红日
    ,nvl(n.reg_date, o.reg_date) as reg_date -- 权益登记日期
    ,nvl(n.xr_date, o.xr_date) as xr_date -- 除权日
    ,nvl(n.sub_type, o.sub_type) as sub_type -- 认购方式
    ,nvl(n.transfee_type, o.transfee_type) as transfee_type -- 交易费收取方式
    ,nvl(n.price, o.price) as price -- 交易价格
    ,nvl(n.next_trade_date, o.next_trade_date) as next_trade_date -- 下一交易日
    ,nvl(n.value_line, o.value_line) as value_line -- 产品价值线数值
    ,nvl(n.total_bonus, o.total_bonus) as total_bonus -- 累计单位分红
    ,nvl(n.fundincome_unit, o.fundincome_unit) as fundincome_unit -- 货币基金万份收益
    ,nvl(n.fundincome_type, o.fundincome_type) as fundincome_type -- 货币基金万份收益正负
    ,nvl(n.yield, o.yield) as yield -- 货币基金七日年化收益率
    ,nvl(n.yield_flag, o.yield_flag) as yield_flag -- 货币基金七日年化收益率正负
    ,nvl(n.guaranteed_nav, o.guaranteed_nav) as guaranteed_nav -- 保本净值
    ,nvl(n.yearincome_rate, o.yearincome_rate) as yearincome_rate -- 货币基金年收益率
    ,nvl(n.yearincome_flag, o.yearincome_flag) as yearincome_flag -- 货币基金年收益率正负
    ,nvl(n.daily_income_flag, o.daily_income_flag) as daily_income_flag -- 基金当日总收益正负
    ,nvl(n.daily_income, o.daily_income) as daily_income -- 基金当日总收益
    ,nvl(n.breach_red_flag, o.breach_red_flag) as breach_red_flag -- 允许违约赎回标志
    ,nvl(n.fund_type, o.fund_type) as fund_type -- 基金类型
    ,nvl(n.fund_type_name, o.fund_type_name) as fund_type_name -- 基金类型名称
    ,nvl(n.prd_sponsor, o.prd_sponsor) as prd_sponsor -- 产品发起人
    ,nvl(n.ta_code, o.ta_code) as ta_code -- TA代码
    ,nvl(n.ta_name, o.ta_name) as ta_name -- TA名称
    ,nvl(n.prd_manager, o.prd_manager) as prd_manager -- 产品管理人
    ,nvl(n.prd_manager_name, o.prd_manager_name) as prd_manager_name -- 基金管理人名称
    ,nvl(n.service_tel, o.service_tel) as service_tel -- 基金公司客服电话
    ,nvl(n.internet_address, o.internet_address) as internet_address -- 基金公司网站网址
    ,nvl(n.monthincome_rate, o.monthincome_rate) as monthincome_rate -- 月年化收益率
    ,nvl(n.monthincome_flag, o.monthincome_flag) as monthincome_flag -- 月年化收益率正负
    ,nvl(n.quarter_rate, o.quarter_rate) as quarter_rate -- 季度年化收益率
    ,nvl(n.quarter_rate_flag, o.quarter_rate_flag) as quarter_rate_flag -- 季度年化收益率正负
    ,nvl(n.cycle_rate, o.cycle_rate) as cycle_rate -- 周期收益率
    ,nvl(n.cycle_rate_flag, o.cycle_rate_flag) as cycle_rate_flag -- 周期收益率正负
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备用3
    ,nvl(n.nav_date, o.nav_date) as nav_date -- 资管净值日期
    ,case when
            n.iss_date is null
            and n.cfm_date is null
            and n.prd_code is null
            and n.nav_flag is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.iss_date is null
            and n.cfm_date is null
            and n.prd_code is null
            and n.nav_flag is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.iss_date is null
            and n.cfm_date is null
            and n.prd_code is null
            and n.nav_flag is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tbprddailyext_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tbprddailyext where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.iss_date = n.iss_date
            and o.cfm_date = n.cfm_date
            and o.prd_code = n.prd_code
            and o.nav_flag = n.nav_flag
where (
        o.iss_date is null
        and o.cfm_date is null
        and o.prd_code is null
        and o.nav_flag is null
    )
    or (
        n.iss_date is null
        and n.cfm_date is null
        and n.prd_code is null
        and n.nav_flag is null
    )
    or (
        o.nav <> n.nav
        or o.tot_vol <> n.tot_vol
        or o.status <> n.status
        or o.prd_name <> n.prd_name
        or o.periodic_status <> n.periodic_status
        or o.chg_agc_status <> n.chg_agc_status
        or o.curr_type <> n.curr_type
        or o.announc_flag <> n.announc_flag
        or o.div_mode <> n.div_mode
        or o.osubfirst_amt <> n.osubfirst_amt
        or o.osubfirst_vol <> n.osubfirst_vol
        or o.osubapp_amt <> n.osubapp_amt
        or o.osubapp_vol <> n.osubapp_vol
        or o.omaxsub_amt <> n.omaxsub_amt
        or o.omaxsub_vol <> n.omaxsub_vol
        or o.osubunit_amt <> n.osubunit_amt
        or o.osubunit_vol <> n.osubunit_vol
        or o.ofirst_amt <> n.ofirst_amt
        or o.oapp_amt <> n.oapp_amt
        or o.omax_amt <> n.omax_amt
        or o.omax_accu_amt <> n.omax_accu_amt
        or o.omax_accured_amt <> n.omax_accured_amt
        or o.omax_red_vol <> n.omax_red_vol
        or o.psubfirst_amt <> n.psubfirst_amt
        or o.psubfirst_vol <> n.psubfirst_vol
        or o.psubapp_amt <> n.psubapp_amt
        or o.psubapp_vol <> n.psubapp_vol
        or o.pmaxsub_amt <> n.pmaxsub_amt
        or o.pmaxsub_vol <> n.pmaxsub_vol
        or o.psubunit_amt <> n.psubunit_amt
        or o.psubunit_vol <> n.psubunit_vol
        or o.pfirst_amt <> n.pfirst_amt
        or o.papp_amt <> n.papp_amt
        or o.pmax_amt <> n.pmax_amt
        or o.pmax_accu_amt <> n.pmax_accu_amt
        or o.pmax_accured_amt <> n.pmax_accured_amt
        or o.pmax_red_vol <> n.pmax_red_vol
        or o.max_red_vol <> n.max_red_vol
        or o.min_hold_vol <> n.min_hold_vol
        or o.min_red_vol <> n.min_red_vol
        or o.min_conv_vol <> n.min_conv_vol
        or o.piss_type <> n.piss_type
        or o.oiss_type <> n.oiss_type
        or o.invest_amt <> n.invest_amt
        or o.invest_date <> n.invest_date
        or o.prd_trustee <> n.prd_trustee
        or o.ipo_start_date <> n.ipo_start_date
        or o.ipo_end_date <> n.ipo_end_date
        or o.divident_date <> n.divident_date
        or o.reg_date <> n.reg_date
        or o.xr_date <> n.xr_date
        or o.sub_type <> n.sub_type
        or o.transfee_type <> n.transfee_type
        or o.price <> n.price
        or o.next_trade_date <> n.next_trade_date
        or o.value_line <> n.value_line
        or o.total_bonus <> n.total_bonus
        or o.fundincome_unit <> n.fundincome_unit
        or o.fundincome_type <> n.fundincome_type
        or o.yield <> n.yield
        or o.yield_flag <> n.yield_flag
        or o.guaranteed_nav <> n.guaranteed_nav
        or o.yearincome_rate <> n.yearincome_rate
        or o.yearincome_flag <> n.yearincome_flag
        or o.daily_income_flag <> n.daily_income_flag
        or o.daily_income <> n.daily_income
        or o.breach_red_flag <> n.breach_red_flag
        or o.fund_type <> n.fund_type
        or o.fund_type_name <> n.fund_type_name
        or o.prd_sponsor <> n.prd_sponsor
        or o.ta_code <> n.ta_code
        or o.ta_name <> n.ta_name
        or o.prd_manager <> n.prd_manager
        or o.prd_manager_name <> n.prd_manager_name
        or o.service_tel <> n.service_tel
        or o.internet_address <> n.internet_address
        or o.monthincome_rate <> n.monthincome_rate
        or o.monthincome_flag <> n.monthincome_flag
        or o.quarter_rate <> n.quarter_rate
        or o.quarter_rate_flag <> n.quarter_rate_flag
        or o.cycle_rate <> n.cycle_rate
        or o.cycle_rate_flag <> n.cycle_rate_flag
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.nav_date <> n.nav_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbprddailyext_cl(
            iss_date -- 发布日期
            ,cfm_date -- 确认日期(当天日期)
            ,prd_code -- 产品代码
            ,nav_flag -- 净值类型
            ,nav -- 基金单位净值
            ,tot_vol -- 基金总份数
            ,status -- 基金状态
            ,prd_name -- 产品名称
            ,periodic_status -- 定期定额状态
            ,chg_agc_status -- 转托管状态
            ,curr_type -- 结算币种
            ,announc_flag -- 公告标志
            ,div_mode -- 默认分红方式
            ,osubfirst_amt -- 机构首次认购最低金额
            ,osubfirst_vol -- 机构首次认购最低份额
            ,osubapp_amt -- 机构追加认购金额
            ,osubapp_vol -- 机构追加认购份额
            ,omaxsub_amt -- 机构最高认购金额
            ,omaxsub_vol -- 机构最高认购份数
            ,osubunit_amt -- 机构认购金额单位
            ,osubunit_vol -- 机构认购份额单位
            ,ofirst_amt -- 机构首次申购最低金额
            ,oapp_amt -- 机构追加申购最低金额
            ,omax_amt -- 机构最大申购金额
            ,omax_accu_amt -- 机构当日累计购买最大金额
            ,omax_accured_amt -- 机构当日累计赎回最大份额
            ,omax_red_vol -- 机构最大赎回份额
            ,psubfirst_amt -- 个人首次认购最低金额
            ,psubfirst_vol -- 个人首次认购最低份额
            ,psubapp_amt -- 个人追加认购金额
            ,psubapp_vol -- 个人追加认购份额
            ,pmaxsub_amt -- 个人最高认购金额
            ,pmaxsub_vol -- 个人最高认购份数
            ,psubunit_amt -- 个人认购金额单位
            ,psubunit_vol -- 个人认购份额单位
            ,pfirst_amt -- 个人首次申购最低金额
            ,papp_amt -- 个人追加申购最低金额
            ,pmax_amt -- 个人最大申购金额
            ,pmax_accu_amt -- 个人当日累计购买最大金额
            ,pmax_accured_amt -- 个人当日累计赎回最大份额
            ,pmax_red_vol -- 个人最大赎回份额
            ,max_red_vol -- 基金最高赎回份额
            ,min_hold_vol -- 基金最低持有份数
            ,min_red_vol -- 基金最少赎回份数
            ,min_conv_vol -- 最低基金转换份数
            ,piss_type -- 个人发行方式
            ,oiss_type -- 机构发行方式
            ,invest_amt -- 定投金额
            ,invest_date -- 定投日期
            ,prd_trustee -- 产品托管人
            ,ipo_start_date -- 募集开始日期
            ,ipo_end_date -- 募集结束日期
            ,divident_date -- 分红日
            ,reg_date -- 权益登记日期
            ,xr_date -- 除权日
            ,sub_type -- 认购方式
            ,transfee_type -- 交易费收取方式
            ,price -- 交易价格
            ,next_trade_date -- 下一交易日
            ,value_line -- 产品价值线数值
            ,total_bonus -- 累计单位分红
            ,fundincome_unit -- 货币基金万份收益
            ,fundincome_type -- 货币基金万份收益正负
            ,yield -- 货币基金七日年化收益率
            ,yield_flag -- 货币基金七日年化收益率正负
            ,guaranteed_nav -- 保本净值
            ,yearincome_rate -- 货币基金年收益率
            ,yearincome_flag -- 货币基金年收益率正负
            ,daily_income_flag -- 基金当日总收益正负
            ,daily_income -- 基金当日总收益
            ,breach_red_flag -- 允许违约赎回标志
            ,fund_type -- 基金类型
            ,fund_type_name -- 基金类型名称
            ,prd_sponsor -- 产品发起人
            ,ta_code -- TA代码
            ,ta_name -- TA名称
            ,prd_manager -- 产品管理人
            ,prd_manager_name -- 基金管理人名称
            ,service_tel -- 基金公司客服电话
            ,internet_address -- 基金公司网站网址
            ,monthincome_rate -- 月年化收益率
            ,monthincome_flag -- 月年化收益率正负
            ,quarter_rate -- 季度年化收益率
            ,quarter_rate_flag -- 季度年化收益率正负
            ,cycle_rate -- 周期收益率
            ,cycle_rate_flag -- 周期收益率正负
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,reserve3 -- 备用3
            ,nav_date -- 资管净值日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbprddailyext_op(
            iss_date -- 发布日期
            ,cfm_date -- 确认日期(当天日期)
            ,prd_code -- 产品代码
            ,nav_flag -- 净值类型
            ,nav -- 基金单位净值
            ,tot_vol -- 基金总份数
            ,status -- 基金状态
            ,prd_name -- 产品名称
            ,periodic_status -- 定期定额状态
            ,chg_agc_status -- 转托管状态
            ,curr_type -- 结算币种
            ,announc_flag -- 公告标志
            ,div_mode -- 默认分红方式
            ,osubfirst_amt -- 机构首次认购最低金额
            ,osubfirst_vol -- 机构首次认购最低份额
            ,osubapp_amt -- 机构追加认购金额
            ,osubapp_vol -- 机构追加认购份额
            ,omaxsub_amt -- 机构最高认购金额
            ,omaxsub_vol -- 机构最高认购份数
            ,osubunit_amt -- 机构认购金额单位
            ,osubunit_vol -- 机构认购份额单位
            ,ofirst_amt -- 机构首次申购最低金额
            ,oapp_amt -- 机构追加申购最低金额
            ,omax_amt -- 机构最大申购金额
            ,omax_accu_amt -- 机构当日累计购买最大金额
            ,omax_accured_amt -- 机构当日累计赎回最大份额
            ,omax_red_vol -- 机构最大赎回份额
            ,psubfirst_amt -- 个人首次认购最低金额
            ,psubfirst_vol -- 个人首次认购最低份额
            ,psubapp_amt -- 个人追加认购金额
            ,psubapp_vol -- 个人追加认购份额
            ,pmaxsub_amt -- 个人最高认购金额
            ,pmaxsub_vol -- 个人最高认购份数
            ,psubunit_amt -- 个人认购金额单位
            ,psubunit_vol -- 个人认购份额单位
            ,pfirst_amt -- 个人首次申购最低金额
            ,papp_amt -- 个人追加申购最低金额
            ,pmax_amt -- 个人最大申购金额
            ,pmax_accu_amt -- 个人当日累计购买最大金额
            ,pmax_accured_amt -- 个人当日累计赎回最大份额
            ,pmax_red_vol -- 个人最大赎回份额
            ,max_red_vol -- 基金最高赎回份额
            ,min_hold_vol -- 基金最低持有份数
            ,min_red_vol -- 基金最少赎回份数
            ,min_conv_vol -- 最低基金转换份数
            ,piss_type -- 个人发行方式
            ,oiss_type -- 机构发行方式
            ,invest_amt -- 定投金额
            ,invest_date -- 定投日期
            ,prd_trustee -- 产品托管人
            ,ipo_start_date -- 募集开始日期
            ,ipo_end_date -- 募集结束日期
            ,divident_date -- 分红日
            ,reg_date -- 权益登记日期
            ,xr_date -- 除权日
            ,sub_type -- 认购方式
            ,transfee_type -- 交易费收取方式
            ,price -- 交易价格
            ,next_trade_date -- 下一交易日
            ,value_line -- 产品价值线数值
            ,total_bonus -- 累计单位分红
            ,fundincome_unit -- 货币基金万份收益
            ,fundincome_type -- 货币基金万份收益正负
            ,yield -- 货币基金七日年化收益率
            ,yield_flag -- 货币基金七日年化收益率正负
            ,guaranteed_nav -- 保本净值
            ,yearincome_rate -- 货币基金年收益率
            ,yearincome_flag -- 货币基金年收益率正负
            ,daily_income_flag -- 基金当日总收益正负
            ,daily_income -- 基金当日总收益
            ,breach_red_flag -- 允许违约赎回标志
            ,fund_type -- 基金类型
            ,fund_type_name -- 基金类型名称
            ,prd_sponsor -- 产品发起人
            ,ta_code -- TA代码
            ,ta_name -- TA名称
            ,prd_manager -- 产品管理人
            ,prd_manager_name -- 基金管理人名称
            ,service_tel -- 基金公司客服电话
            ,internet_address -- 基金公司网站网址
            ,monthincome_rate -- 月年化收益率
            ,monthincome_flag -- 月年化收益率正负
            ,quarter_rate -- 季度年化收益率
            ,quarter_rate_flag -- 季度年化收益率正负
            ,cycle_rate -- 周期收益率
            ,cycle_rate_flag -- 周期收益率正负
            ,reserve1 -- 备用1
            ,reserve2 -- 备用2
            ,reserve3 -- 备用3
            ,nav_date -- 资管净值日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.iss_date -- 发布日期
    ,o.cfm_date -- 确认日期(当天日期)
    ,o.prd_code -- 产品代码
    ,o.nav_flag -- 净值类型
    ,o.nav -- 基金单位净值
    ,o.tot_vol -- 基金总份数
    ,o.status -- 基金状态
    ,o.prd_name -- 产品名称
    ,o.periodic_status -- 定期定额状态
    ,o.chg_agc_status -- 转托管状态
    ,o.curr_type -- 结算币种
    ,o.announc_flag -- 公告标志
    ,o.div_mode -- 默认分红方式
    ,o.osubfirst_amt -- 机构首次认购最低金额
    ,o.osubfirst_vol -- 机构首次认购最低份额
    ,o.osubapp_amt -- 机构追加认购金额
    ,o.osubapp_vol -- 机构追加认购份额
    ,o.omaxsub_amt -- 机构最高认购金额
    ,o.omaxsub_vol -- 机构最高认购份数
    ,o.osubunit_amt -- 机构认购金额单位
    ,o.osubunit_vol -- 机构认购份额单位
    ,o.ofirst_amt -- 机构首次申购最低金额
    ,o.oapp_amt -- 机构追加申购最低金额
    ,o.omax_amt -- 机构最大申购金额
    ,o.omax_accu_amt -- 机构当日累计购买最大金额
    ,o.omax_accured_amt -- 机构当日累计赎回最大份额
    ,o.omax_red_vol -- 机构最大赎回份额
    ,o.psubfirst_amt -- 个人首次认购最低金额
    ,o.psubfirst_vol -- 个人首次认购最低份额
    ,o.psubapp_amt -- 个人追加认购金额
    ,o.psubapp_vol -- 个人追加认购份额
    ,o.pmaxsub_amt -- 个人最高认购金额
    ,o.pmaxsub_vol -- 个人最高认购份数
    ,o.psubunit_amt -- 个人认购金额单位
    ,o.psubunit_vol -- 个人认购份额单位
    ,o.pfirst_amt -- 个人首次申购最低金额
    ,o.papp_amt -- 个人追加申购最低金额
    ,o.pmax_amt -- 个人最大申购金额
    ,o.pmax_accu_amt -- 个人当日累计购买最大金额
    ,o.pmax_accured_amt -- 个人当日累计赎回最大份额
    ,o.pmax_red_vol -- 个人最大赎回份额
    ,o.max_red_vol -- 基金最高赎回份额
    ,o.min_hold_vol -- 基金最低持有份数
    ,o.min_red_vol -- 基金最少赎回份数
    ,o.min_conv_vol -- 最低基金转换份数
    ,o.piss_type -- 个人发行方式
    ,o.oiss_type -- 机构发行方式
    ,o.invest_amt -- 定投金额
    ,o.invest_date -- 定投日期
    ,o.prd_trustee -- 产品托管人
    ,o.ipo_start_date -- 募集开始日期
    ,o.ipo_end_date -- 募集结束日期
    ,o.divident_date -- 分红日
    ,o.reg_date -- 权益登记日期
    ,o.xr_date -- 除权日
    ,o.sub_type -- 认购方式
    ,o.transfee_type -- 交易费收取方式
    ,o.price -- 交易价格
    ,o.next_trade_date -- 下一交易日
    ,o.value_line -- 产品价值线数值
    ,o.total_bonus -- 累计单位分红
    ,o.fundincome_unit -- 货币基金万份收益
    ,o.fundincome_type -- 货币基金万份收益正负
    ,o.yield -- 货币基金七日年化收益率
    ,o.yield_flag -- 货币基金七日年化收益率正负
    ,o.guaranteed_nav -- 保本净值
    ,o.yearincome_rate -- 货币基金年收益率
    ,o.yearincome_flag -- 货币基金年收益率正负
    ,o.daily_income_flag -- 基金当日总收益正负
    ,o.daily_income -- 基金当日总收益
    ,o.breach_red_flag -- 允许违约赎回标志
    ,o.fund_type -- 基金类型
    ,o.fund_type_name -- 基金类型名称
    ,o.prd_sponsor -- 产品发起人
    ,o.ta_code -- TA代码
    ,o.ta_name -- TA名称
    ,o.prd_manager -- 产品管理人
    ,o.prd_manager_name -- 基金管理人名称
    ,o.service_tel -- 基金公司客服电话
    ,o.internet_address -- 基金公司网站网址
    ,o.monthincome_rate -- 月年化收益率
    ,o.monthincome_flag -- 月年化收益率正负
    ,o.quarter_rate -- 季度年化收益率
    ,o.quarter_rate_flag -- 季度年化收益率正负
    ,o.cycle_rate -- 周期收益率
    ,o.cycle_rate_flag -- 周期收益率正负
    ,o.reserve1 -- 备用1
    ,o.reserve2 -- 备用2
    ,o.reserve3 -- 备用3
    ,o.nav_date -- 资管净值日期
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
from ${iol_schema}.nfss_tbprddailyext_bk o
    left join ${iol_schema}.nfss_tbprddailyext_op n
        on
            o.iss_date = n.iss_date
            and o.cfm_date = n.cfm_date
            and o.prd_code = n.prd_code
            and o.nav_flag = n.nav_flag
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tbprddailyext_cl d
        on
            o.iss_date = d.iss_date
            and o.cfm_date = d.cfm_date
            and o.prd_code = d.prd_code
            and o.nav_flag = d.nav_flag
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nfss_tbprddailyext;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nfss_tbprddailyext') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nfss_tbprddailyext drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nfss_tbprddailyext add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nfss_tbprddailyext exchange partition p_${batch_date} with table ${iol_schema}.nfss_tbprddailyext_cl;
alter table ${iol_schema}.nfss_tbprddailyext exchange partition p_20991231 with table ${iol_schema}.nfss_tbprddailyext_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbprddailyext to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbprddailyext_op purge;
drop table ${iol_schema}.nfss_tbprddailyext_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tbprddailyext_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbprddailyext',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
