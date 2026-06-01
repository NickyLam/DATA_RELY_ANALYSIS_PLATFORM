/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wmps_tbproductadd
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
create table ${iol_schema}.wmps_tbproductadd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wmps_tbproductadd
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wmps_tbproductadd_op purge;
drop table ${iol_schema}.wmps_tbproductadd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wmps_tbproductadd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wmps_tbproductadd where 0=1;

create table ${iol_schema}.wmps_tbproductadd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wmps_tbproductadd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wmps_tbproductadd_cl(
            prd_code -- 产品代码
            ,debt_regist_code -- 产品中债登记编码
            ,debt_fund_type -- 中债产品划分:1-普通个人产品、2-高净值产品、3-私行专属、6-机构专属、7-同业专属
            ,benchmark_summary -- 业绩基准说明
            ,allow_client_group -- 允许销售的中债客户组别:1-一般个人客户 2-高资产净值客户 3-私人银行客户 4-银行业金融机构客户 5-非银行业金融机构客户 6-法人机构其他 7-非法人资产管理产品 8-非法人机构其他
            ,ipo_type -- 产品募集方式:0-公募 1-私募
            ,calm_time -- 冷静期小时
            ,calm_day -- 冷静期天数
            ,calm_optype -- 冷静期计算方式:0-按理论时间 1-按有效时间
            ,investment_targets -- 投资标的(投资性质):0-固定收益类 1-权益类 2-商品及金融衍生品类 3-混合类
            ,cltnum_limit_code -- 产品人数计划代码
            ,cltnum_client_type -- 人数控制客户类型
            ,last_cycle_date -- 最近周期日期
            ,next_cycle_date -- 下一周期日
            ,last_cfm_date -- 最后确认日期
            ,next_cfm_date -- 下一确认日
            ,prev_month_nav -- 一个月前净值
            ,three_month_nav -- 三月净值盈亏:三个月前净值
            ,six_month_nav -- 半年前净值
            ,prev_year_nav -- 一年前净值
            ,integer1 -- 备用整型1
            ,integer2 -- 备用整型2
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,reserve1 -- 保留字段1:F18文件业绩比较基准
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,create_time -- 创建时间戳:转换费率使用
            ,last_modified_time -- 修改时间戳:0 年 1月 2元  3日，该字段填单位
            ,version -- 版本号
            ,prd_scale -- 产品总规模
            ,tot_vol -- 总份额
            ,conv_flag -- 转换标志:[K_ZHBZ] 0\t-\t可转入，可转出 1\t-\t只可转入 2\t-\t只可转出 3\t-\t不可转换
            ,yield -- 七日年化收益率
            ,yield_flag -- 货币基金七日年化收益率正负:0-正  1-负
            ,annual_rate_date -- 年化收益更新日期
            ,prd_limit_day -- 产品期限
            ,prd_scale_agency -- 产品规模-代销端
            ,cust_manager_no -- 投资经理编号
            ,access_status -- 准入状态:法人行产品准入状态 0初始状态 1省准入 2市准入 3法人行准入
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wmps_tbproductadd_op(
            prd_code -- 产品代码
            ,debt_regist_code -- 产品中债登记编码
            ,debt_fund_type -- 中债产品划分:1-普通个人产品、2-高净值产品、3-私行专属、6-机构专属、7-同业专属
            ,benchmark_summary -- 业绩基准说明
            ,allow_client_group -- 允许销售的中债客户组别:1-一般个人客户 2-高资产净值客户 3-私人银行客户 4-银行业金融机构客户 5-非银行业金融机构客户 6-法人机构其他 7-非法人资产管理产品 8-非法人机构其他
            ,ipo_type -- 产品募集方式:0-公募 1-私募
            ,calm_time -- 冷静期小时
            ,calm_day -- 冷静期天数
            ,calm_optype -- 冷静期计算方式:0-按理论时间 1-按有效时间
            ,investment_targets -- 投资标的(投资性质):0-固定收益类 1-权益类 2-商品及金融衍生品类 3-混合类
            ,cltnum_limit_code -- 产品人数计划代码
            ,cltnum_client_type -- 人数控制客户类型
            ,last_cycle_date -- 最近周期日期
            ,next_cycle_date -- 下一周期日
            ,last_cfm_date -- 最后确认日期
            ,next_cfm_date -- 下一确认日
            ,prev_month_nav -- 一个月前净值
            ,three_month_nav -- 三月净值盈亏:三个月前净值
            ,six_month_nav -- 半年前净值
            ,prev_year_nav -- 一年前净值
            ,integer1 -- 备用整型1
            ,integer2 -- 备用整型2
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,reserve1 -- 保留字段1:F18文件业绩比较基准
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,create_time -- 创建时间戳:转换费率使用
            ,last_modified_time -- 修改时间戳:0 年 1月 2元  3日，该字段填单位
            ,version -- 版本号
            ,prd_scale -- 产品总规模
            ,tot_vol -- 总份额
            ,conv_flag -- 转换标志:[K_ZHBZ] 0\t-\t可转入，可转出 1\t-\t只可转入 2\t-\t只可转出 3\t-\t不可转换
            ,yield -- 七日年化收益率
            ,yield_flag -- 货币基金七日年化收益率正负:0-正  1-负
            ,annual_rate_date -- 年化收益更新日期
            ,prd_limit_day -- 产品期限
            ,prd_scale_agency -- 产品规模-代销端
            ,cust_manager_no -- 投资经理编号
            ,access_status -- 准入状态:法人行产品准入状态 0初始状态 1省准入 2市准入 3法人行准入
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prd_code, o.prd_code) as prd_code -- 产品代码
    ,nvl(n.debt_regist_code, o.debt_regist_code) as debt_regist_code -- 产品中债登记编码
    ,nvl(n.debt_fund_type, o.debt_fund_type) as debt_fund_type -- 中债产品划分:1-普通个人产品、2-高净值产品、3-私行专属、6-机构专属、7-同业专属
    ,nvl(n.benchmark_summary, o.benchmark_summary) as benchmark_summary -- 业绩基准说明
    ,nvl(n.allow_client_group, o.allow_client_group) as allow_client_group -- 允许销售的中债客户组别:1-一般个人客户 2-高资产净值客户 3-私人银行客户 4-银行业金融机构客户 5-非银行业金融机构客户 6-法人机构其他 7-非法人资产管理产品 8-非法人机构其他
    ,nvl(n.ipo_type, o.ipo_type) as ipo_type -- 产品募集方式:0-公募 1-私募
    ,nvl(n.calm_time, o.calm_time) as calm_time -- 冷静期小时
    ,nvl(n.calm_day, o.calm_day) as calm_day -- 冷静期天数
    ,nvl(n.calm_optype, o.calm_optype) as calm_optype -- 冷静期计算方式:0-按理论时间 1-按有效时间
    ,nvl(n.investment_targets, o.investment_targets) as investment_targets -- 投资标的(投资性质):0-固定收益类 1-权益类 2-商品及金融衍生品类 3-混合类
    ,nvl(n.cltnum_limit_code, o.cltnum_limit_code) as cltnum_limit_code -- 产品人数计划代码
    ,nvl(n.cltnum_client_type, o.cltnum_client_type) as cltnum_client_type -- 人数控制客户类型
    ,nvl(n.last_cycle_date, o.last_cycle_date) as last_cycle_date -- 最近周期日期
    ,nvl(n.next_cycle_date, o.next_cycle_date) as next_cycle_date -- 下一周期日
    ,nvl(n.last_cfm_date, o.last_cfm_date) as last_cfm_date -- 最后确认日期
    ,nvl(n.next_cfm_date, o.next_cfm_date) as next_cfm_date -- 下一确认日
    ,nvl(n.prev_month_nav, o.prev_month_nav) as prev_month_nav -- 一个月前净值
    ,nvl(n.three_month_nav, o.three_month_nav) as three_month_nav -- 三月净值盈亏:三个月前净值
    ,nvl(n.six_month_nav, o.six_month_nav) as six_month_nav -- 半年前净值
    ,nvl(n.prev_year_nav, o.prev_year_nav) as prev_year_nav -- 一年前净值
    ,nvl(n.integer1, o.integer1) as integer1 -- 备用整型1
    ,nvl(n.integer2, o.integer2) as integer2 -- 备用整型2
    ,nvl(n.amt1, o.amt1) as amt1 -- 备用金额1
    ,nvl(n.amt2, o.amt2) as amt2 -- 备用金额2
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 保留字段1:F18文件业绩比较基准
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 保留字段2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 保留字段3
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间戳:转换费率使用
    ,nvl(n.last_modified_time, o.last_modified_time) as last_modified_time -- 修改时间戳:0 年 1月 2元  3日，该字段填单位
    ,nvl(n.version, o.version) as version -- 版本号
    ,nvl(n.prd_scale, o.prd_scale) as prd_scale -- 产品总规模
    ,nvl(n.tot_vol, o.tot_vol) as tot_vol -- 总份额
    ,nvl(n.conv_flag, o.conv_flag) as conv_flag -- 转换标志:[K_ZHBZ] 0\t-\t可转入，可转出 1\t-\t只可转入 2\t-\t只可转出 3\t-\t不可转换
    ,nvl(n.yield, o.yield) as yield -- 七日年化收益率
    ,nvl(n.yield_flag, o.yield_flag) as yield_flag -- 货币基金七日年化收益率正负:0-正  1-负
    ,nvl(n.annual_rate_date, o.annual_rate_date) as annual_rate_date -- 年化收益更新日期
    ,nvl(n.prd_limit_day, o.prd_limit_day) as prd_limit_day -- 产品期限
    ,nvl(n.prd_scale_agency, o.prd_scale_agency) as prd_scale_agency -- 产品规模-代销端
    ,nvl(n.cust_manager_no, o.cust_manager_no) as cust_manager_no -- 投资经理编号
    ,nvl(n.access_status, o.access_status) as access_status -- 准入状态:法人行产品准入状态 0初始状态 1省准入 2市准入 3法人行准入
    ,case when
            n.prd_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prd_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prd_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wmps_tbproductadd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.wmps_tbproductadd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prd_code = n.prd_code
where (
        o.prd_code is null
    )
    or (
        n.prd_code is null
    )
    or (
        o.debt_regist_code <> n.debt_regist_code
        or o.debt_fund_type <> n.debt_fund_type
        or o.benchmark_summary <> n.benchmark_summary
        or o.allow_client_group <> n.allow_client_group
        or o.ipo_type <> n.ipo_type
        or o.calm_time <> n.calm_time
        or o.calm_day <> n.calm_day
        or o.calm_optype <> n.calm_optype
        or o.investment_targets <> n.investment_targets
        or o.cltnum_limit_code <> n.cltnum_limit_code
        or o.cltnum_client_type <> n.cltnum_client_type
        or o.last_cycle_date <> n.last_cycle_date
        or o.next_cycle_date <> n.next_cycle_date
        or o.last_cfm_date <> n.last_cfm_date
        or o.next_cfm_date <> n.next_cfm_date
        or o.prev_month_nav <> n.prev_month_nav
        or o.three_month_nav <> n.three_month_nav
        or o.six_month_nav <> n.six_month_nav
        or o.prev_year_nav <> n.prev_year_nav
        or o.integer1 <> n.integer1
        or o.integer2 <> n.integer2
        or o.amt1 <> n.amt1
        or o.amt2 <> n.amt2
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.create_time <> n.create_time
        or o.last_modified_time <> n.last_modified_time
        or o.version <> n.version
        or o.prd_scale <> n.prd_scale
        or o.tot_vol <> n.tot_vol
        or o.conv_flag <> n.conv_flag
        or o.yield <> n.yield
        or o.yield_flag <> n.yield_flag
        or o.annual_rate_date <> n.annual_rate_date
        or o.prd_limit_day <> n.prd_limit_day
        or o.prd_scale_agency <> n.prd_scale_agency
        or o.cust_manager_no <> n.cust_manager_no
        or o.access_status <> n.access_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wmps_tbproductadd_cl(
            prd_code -- 产品代码
            ,debt_regist_code -- 产品中债登记编码
            ,debt_fund_type -- 中债产品划分:1-普通个人产品、2-高净值产品、3-私行专属、6-机构专属、7-同业专属
            ,benchmark_summary -- 业绩基准说明
            ,allow_client_group -- 允许销售的中债客户组别:1-一般个人客户 2-高资产净值客户 3-私人银行客户 4-银行业金融机构客户 5-非银行业金融机构客户 6-法人机构其他 7-非法人资产管理产品 8-非法人机构其他
            ,ipo_type -- 产品募集方式:0-公募 1-私募
            ,calm_time -- 冷静期小时
            ,calm_day -- 冷静期天数
            ,calm_optype -- 冷静期计算方式:0-按理论时间 1-按有效时间
            ,investment_targets -- 投资标的(投资性质):0-固定收益类 1-权益类 2-商品及金融衍生品类 3-混合类
            ,cltnum_limit_code -- 产品人数计划代码
            ,cltnum_client_type -- 人数控制客户类型
            ,last_cycle_date -- 最近周期日期
            ,next_cycle_date -- 下一周期日
            ,last_cfm_date -- 最后确认日期
            ,next_cfm_date -- 下一确认日
            ,prev_month_nav -- 一个月前净值
            ,three_month_nav -- 三月净值盈亏:三个月前净值
            ,six_month_nav -- 半年前净值
            ,prev_year_nav -- 一年前净值
            ,integer1 -- 备用整型1
            ,integer2 -- 备用整型2
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,reserve1 -- 保留字段1:F18文件业绩比较基准
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,create_time -- 创建时间戳:转换费率使用
            ,last_modified_time -- 修改时间戳:0 年 1月 2元  3日，该字段填单位
            ,version -- 版本号
            ,prd_scale -- 产品总规模
            ,tot_vol -- 总份额
            ,conv_flag -- 转换标志:[K_ZHBZ] 0\t-\t可转入，可转出 1\t-\t只可转入 2\t-\t只可转出 3\t-\t不可转换
            ,yield -- 七日年化收益率
            ,yield_flag -- 货币基金七日年化收益率正负:0-正  1-负
            ,annual_rate_date -- 年化收益更新日期
            ,prd_limit_day -- 产品期限
            ,prd_scale_agency -- 产品规模-代销端
            ,cust_manager_no -- 投资经理编号
            ,access_status -- 准入状态:法人行产品准入状态 0初始状态 1省准入 2市准入 3法人行准入
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wmps_tbproductadd_op(
            prd_code -- 产品代码
            ,debt_regist_code -- 产品中债登记编码
            ,debt_fund_type -- 中债产品划分:1-普通个人产品、2-高净值产品、3-私行专属、6-机构专属、7-同业专属
            ,benchmark_summary -- 业绩基准说明
            ,allow_client_group -- 允许销售的中债客户组别:1-一般个人客户 2-高资产净值客户 3-私人银行客户 4-银行业金融机构客户 5-非银行业金融机构客户 6-法人机构其他 7-非法人资产管理产品 8-非法人机构其他
            ,ipo_type -- 产品募集方式:0-公募 1-私募
            ,calm_time -- 冷静期小时
            ,calm_day -- 冷静期天数
            ,calm_optype -- 冷静期计算方式:0-按理论时间 1-按有效时间
            ,investment_targets -- 投资标的(投资性质):0-固定收益类 1-权益类 2-商品及金融衍生品类 3-混合类
            ,cltnum_limit_code -- 产品人数计划代码
            ,cltnum_client_type -- 人数控制客户类型
            ,last_cycle_date -- 最近周期日期
            ,next_cycle_date -- 下一周期日
            ,last_cfm_date -- 最后确认日期
            ,next_cfm_date -- 下一确认日
            ,prev_month_nav -- 一个月前净值
            ,three_month_nav -- 三月净值盈亏:三个月前净值
            ,six_month_nav -- 半年前净值
            ,prev_year_nav -- 一年前净值
            ,integer1 -- 备用整型1
            ,integer2 -- 备用整型2
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,reserve1 -- 保留字段1:F18文件业绩比较基准
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,create_time -- 创建时间戳:转换费率使用
            ,last_modified_time -- 修改时间戳:0 年 1月 2元  3日，该字段填单位
            ,version -- 版本号
            ,prd_scale -- 产品总规模
            ,tot_vol -- 总份额
            ,conv_flag -- 转换标志:[K_ZHBZ] 0\t-\t可转入，可转出 1\t-\t只可转入 2\t-\t只可转出 3\t-\t不可转换
            ,yield -- 七日年化收益率
            ,yield_flag -- 货币基金七日年化收益率正负:0-正  1-负
            ,annual_rate_date -- 年化收益更新日期
            ,prd_limit_day -- 产品期限
            ,prd_scale_agency -- 产品规模-代销端
            ,cust_manager_no -- 投资经理编号
            ,access_status -- 准入状态:法人行产品准入状态 0初始状态 1省准入 2市准入 3法人行准入
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prd_code -- 产品代码
    ,o.debt_regist_code -- 产品中债登记编码
    ,o.debt_fund_type -- 中债产品划分:1-普通个人产品、2-高净值产品、3-私行专属、6-机构专属、7-同业专属
    ,o.benchmark_summary -- 业绩基准说明
    ,o.allow_client_group -- 允许销售的中债客户组别:1-一般个人客户 2-高资产净值客户 3-私人银行客户 4-银行业金融机构客户 5-非银行业金融机构客户 6-法人机构其他 7-非法人资产管理产品 8-非法人机构其他
    ,o.ipo_type -- 产品募集方式:0-公募 1-私募
    ,o.calm_time -- 冷静期小时
    ,o.calm_day -- 冷静期天数
    ,o.calm_optype -- 冷静期计算方式:0-按理论时间 1-按有效时间
    ,o.investment_targets -- 投资标的(投资性质):0-固定收益类 1-权益类 2-商品及金融衍生品类 3-混合类
    ,o.cltnum_limit_code -- 产品人数计划代码
    ,o.cltnum_client_type -- 人数控制客户类型
    ,o.last_cycle_date -- 最近周期日期
    ,o.next_cycle_date -- 下一周期日
    ,o.last_cfm_date -- 最后确认日期
    ,o.next_cfm_date -- 下一确认日
    ,o.prev_month_nav -- 一个月前净值
    ,o.three_month_nav -- 三月净值盈亏:三个月前净值
    ,o.six_month_nav -- 半年前净值
    ,o.prev_year_nav -- 一年前净值
    ,o.integer1 -- 备用整型1
    ,o.integer2 -- 备用整型2
    ,o.amt1 -- 备用金额1
    ,o.amt2 -- 备用金额2
    ,o.reserve1 -- 保留字段1:F18文件业绩比较基准
    ,o.reserve2 -- 保留字段2
    ,o.reserve3 -- 保留字段3
    ,o.create_time -- 创建时间戳:转换费率使用
    ,o.last_modified_time -- 修改时间戳:0 年 1月 2元  3日，该字段填单位
    ,o.version -- 版本号
    ,o.prd_scale -- 产品总规模
    ,o.tot_vol -- 总份额
    ,o.conv_flag -- 转换标志:[K_ZHBZ] 0\t-\t可转入，可转出 1\t-\t只可转入 2\t-\t只可转出 3\t-\t不可转换
    ,o.yield -- 七日年化收益率
    ,o.yield_flag -- 货币基金七日年化收益率正负:0-正  1-负
    ,o.annual_rate_date -- 年化收益更新日期
    ,o.prd_limit_day -- 产品期限
    ,o.prd_scale_agency -- 产品规模-代销端
    ,o.cust_manager_no -- 投资经理编号
    ,o.access_status -- 准入状态:法人行产品准入状态 0初始状态 1省准入 2市准入 3法人行准入
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
from ${iol_schema}.wmps_tbproductadd_bk o
    left join ${iol_schema}.wmps_tbproductadd_op n
        on
            o.prd_code = n.prd_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wmps_tbproductadd_cl d
        on
            o.prd_code = d.prd_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wmps_tbproductadd;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('wmps_tbproductadd') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.wmps_tbproductadd drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.wmps_tbproductadd add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.wmps_tbproductadd exchange partition p_${batch_date} with table ${iol_schema}.wmps_tbproductadd_cl;
alter table ${iol_schema}.wmps_tbproductadd exchange partition p_20991231 with table ${iol_schema}.wmps_tbproductadd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wmps_tbproductadd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wmps_tbproductadd_op purge;
drop table ${iol_schema}.wmps_tbproductadd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wmps_tbproductadd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wmps_tbproductadd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
