/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_tfnd
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
create table ${iol_schema}.ibms_tfnd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_tfnd
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tfnd_op purge;
drop table ${iol_schema}.ibms_tfnd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tfnd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tfnd where 0=1;

create table ${iol_schema}.ibms_tfnd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tfnd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tfnd_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,l_code -- 交易所本地代码
            ,currency -- 币种
            ,country -- 国家
            ,q_type -- 报价方式
            ,f_name -- 基金名称
            ,p_class -- 产品分类
            ,f_date -- 上市日期
            ,f_opendate -- 开放日期
            ,f_manager -- 管理者
            ,f_trustee -- 托管方
            ,imp_date -- 导入日期
            ,pipe_id -- 导入管道
            ,p_type -- 产品类型
            ,chinesespell -- 拼音
            ,state -- 产品状态
            ,user_id -- 操作人id
            ,user_name -- 操作人
            ,update_time -- 操作时间
            ,f_manager_code -- 管理者代码
            ,f_trustee_code -- 托管方代码
            ,issuer_id -- 管理人id
            ,f_invest_type -- 投资类型
            ,f_setupdate -- 成立日期
            ,f_manager_name -- 基金经理
            ,i_id -- 机构ID
            ,is_idx -- 是否指数型基金(0:否 1:是)
            ,huge_redemption_ratio -- 巨额赎回认定比例
            ,compounding_method -- 结转复利方式，0：单利；2：连续复利；仅对货币基金有效
            ,s_type -- 标准类型
            ,f_mtrdate -- 到期日期
            ,carry_forword_type -- 结转方式：1：按日结转，2：按月结转，3：按季结转
            ,inv_order_id -- 投金审批单号
            ,par_value -- 基金面值
            ,pay_freq -- 结转频率，仅对货币基金有效
            ,f_grade_type -- 分级基金类型，0：非分级基金；1：分级母基金；2：分级子基金A类；3：分级子基金B类；
            ,f_fullname -- 资产全称
            ,sales_channel -- 销售通道0-直销,1-代销
            ,open_type -- 每日开放：0,每周开放：1
            ,start_open_date -- 开放周期开始日
            ,end_open_date -- 开放周期结束日
            ,management_model -- 管理模式
            ,mitigation_freq -- 缓释频率
            ,manager_value -- 
            ,main_code -- 基金主代码(分级基金相同)
            ,f_name_full -- 
            ,pay_month -- 
            ,pay_day -- 
            ,run_term -- 
            ,p_i_code -- 
            ,p_a_type -- 
            ,p_m_type -- 
            ,manager_id -- 
            ,redemption_date -- 
            ,is_pub_offer -- 
            ,this_open_end_date -- 本周期开放终止日期
            ,this_hold_end_date -- 本周期持有到期日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tfnd_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,l_code -- 交易所本地代码
            ,currency -- 币种
            ,country -- 国家
            ,q_type -- 报价方式
            ,f_name -- 基金名称
            ,p_class -- 产品分类
            ,f_date -- 上市日期
            ,f_opendate -- 开放日期
            ,f_manager -- 管理者
            ,f_trustee -- 托管方
            ,imp_date -- 导入日期
            ,pipe_id -- 导入管道
            ,p_type -- 产品类型
            ,chinesespell -- 拼音
            ,state -- 产品状态
            ,user_id -- 操作人id
            ,user_name -- 操作人
            ,update_time -- 操作时间
            ,f_manager_code -- 管理者代码
            ,f_trustee_code -- 托管方代码
            ,issuer_id -- 管理人id
            ,f_invest_type -- 投资类型
            ,f_setupdate -- 成立日期
            ,f_manager_name -- 基金经理
            ,i_id -- 机构ID
            ,is_idx -- 是否指数型基金(0:否 1:是)
            ,huge_redemption_ratio -- 巨额赎回认定比例
            ,compounding_method -- 结转复利方式，0：单利；2：连续复利；仅对货币基金有效
            ,s_type -- 标准类型
            ,f_mtrdate -- 到期日期
            ,carry_forword_type -- 结转方式：1：按日结转，2：按月结转，3：按季结转
            ,inv_order_id -- 投金审批单号
            ,par_value -- 基金面值
            ,pay_freq -- 结转频率，仅对货币基金有效
            ,f_grade_type -- 分级基金类型，0：非分级基金；1：分级母基金；2：分级子基金A类；3：分级子基金B类；
            ,f_fullname -- 资产全称
            ,sales_channel -- 销售通道0-直销,1-代销
            ,open_type -- 每日开放：0,每周开放：1
            ,start_open_date -- 开放周期开始日
            ,end_open_date -- 开放周期结束日
            ,management_model -- 管理模式
            ,mitigation_freq -- 缓释频率
            ,manager_value -- 
            ,main_code -- 基金主代码(分级基金相同)
            ,f_name_full -- 
            ,pay_month -- 
            ,pay_day -- 
            ,run_term -- 
            ,p_i_code -- 
            ,p_a_type -- 
            ,p_m_type -- 
            ,manager_id -- 
            ,redemption_date -- 
            ,is_pub_offer -- 
            ,this_open_end_date -- 本周期开放终止日期
            ,this_hold_end_date -- 本周期持有到期日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.l_code, o.l_code) as l_code -- 交易所本地代码
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.country, o.country) as country -- 国家
    ,nvl(n.q_type, o.q_type) as q_type -- 报价方式
    ,nvl(n.f_name, o.f_name) as f_name -- 基金名称
    ,nvl(n.p_class, o.p_class) as p_class -- 产品分类
    ,nvl(n.f_date, o.f_date) as f_date -- 上市日期
    ,nvl(n.f_opendate, o.f_opendate) as f_opendate -- 开放日期
    ,nvl(n.f_manager, o.f_manager) as f_manager -- 管理者
    ,nvl(n.f_trustee, o.f_trustee) as f_trustee -- 托管方
    ,nvl(n.imp_date, o.imp_date) as imp_date -- 导入日期
    ,nvl(n.pipe_id, o.pipe_id) as pipe_id -- 导入管道
    ,nvl(n.p_type, o.p_type) as p_type -- 产品类型
    ,nvl(n.chinesespell, o.chinesespell) as chinesespell -- 拼音
    ,nvl(n.state, o.state) as state -- 产品状态
    ,nvl(n.user_id, o.user_id) as user_id -- 操作人id
    ,nvl(n.user_name, o.user_name) as user_name -- 操作人
    ,nvl(n.update_time, o.update_time) as update_time -- 操作时间
    ,nvl(n.f_manager_code, o.f_manager_code) as f_manager_code -- 管理者代码
    ,nvl(n.f_trustee_code, o.f_trustee_code) as f_trustee_code -- 托管方代码
    ,nvl(n.issuer_id, o.issuer_id) as issuer_id -- 管理人id
    ,nvl(n.f_invest_type, o.f_invest_type) as f_invest_type -- 投资类型
    ,nvl(n.f_setupdate, o.f_setupdate) as f_setupdate -- 成立日期
    ,nvl(n.f_manager_name, o.f_manager_name) as f_manager_name -- 基金经理
    ,nvl(n.i_id, o.i_id) as i_id -- 机构ID
    ,nvl(n.is_idx, o.is_idx) as is_idx -- 是否指数型基金(0:否 1:是)
    ,nvl(n.huge_redemption_ratio, o.huge_redemption_ratio) as huge_redemption_ratio -- 巨额赎回认定比例
    ,nvl(n.compounding_method, o.compounding_method) as compounding_method -- 结转复利方式，0：单利；2：连续复利；仅对货币基金有效
    ,nvl(n.s_type, o.s_type) as s_type -- 标准类型
    ,nvl(n.f_mtrdate, o.f_mtrdate) as f_mtrdate -- 到期日期
    ,nvl(n.carry_forword_type, o.carry_forword_type) as carry_forword_type -- 结转方式：1：按日结转，2：按月结转，3：按季结转
    ,nvl(n.inv_order_id, o.inv_order_id) as inv_order_id -- 投金审批单号
    ,nvl(n.par_value, o.par_value) as par_value -- 基金面值
    ,nvl(n.pay_freq, o.pay_freq) as pay_freq -- 结转频率，仅对货币基金有效
    ,nvl(n.f_grade_type, o.f_grade_type) as f_grade_type -- 分级基金类型，0：非分级基金；1：分级母基金；2：分级子基金A类；3：分级子基金B类；
    ,nvl(n.f_fullname, o.f_fullname) as f_fullname -- 资产全称
    ,nvl(n.sales_channel, o.sales_channel) as sales_channel -- 销售通道0-直销,1-代销
    ,nvl(n.open_type, o.open_type) as open_type -- 每日开放：0,每周开放：1
    ,nvl(n.start_open_date, o.start_open_date) as start_open_date -- 开放周期开始日
    ,nvl(n.end_open_date, o.end_open_date) as end_open_date -- 开放周期结束日
    ,nvl(n.management_model, o.management_model) as management_model -- 管理模式
    ,nvl(n.mitigation_freq, o.mitigation_freq) as mitigation_freq -- 缓释频率
    ,nvl(n.manager_value, o.manager_value) as manager_value -- 
    ,nvl(n.main_code, o.main_code) as main_code -- 基金主代码(分级基金相同)
    ,nvl(n.f_name_full, o.f_name_full) as f_name_full -- 
    ,nvl(n.pay_month, o.pay_month) as pay_month -- 
    ,nvl(n.pay_day, o.pay_day) as pay_day -- 
    ,nvl(n.run_term, o.run_term) as run_term -- 
    ,nvl(n.p_i_code, o.p_i_code) as p_i_code -- 
    ,nvl(n.p_a_type, o.p_a_type) as p_a_type -- 
    ,nvl(n.p_m_type, o.p_m_type) as p_m_type -- 
    ,nvl(n.manager_id, o.manager_id) as manager_id -- 
    ,nvl(n.redemption_date, o.redemption_date) as redemption_date -- 
    ,nvl(n.is_pub_offer, o.is_pub_offer) as is_pub_offer -- 
    ,nvl(n.this_open_end_date, o.this_open_end_date) as this_open_end_date -- 本周期开放终止日期
    ,nvl(n.this_hold_end_date, o.this_hold_end_date) as this_hold_end_date -- 本周期持有到期日期
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_tfnd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_tfnd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
where (
        o.i_code is null
        and o.a_type is null
        and o.m_type is null
    )
    or (
        n.i_code is null
        and n.a_type is null
        and n.m_type is null
    )
    or (
        o.l_code <> n.l_code
        or o.currency <> n.currency
        or o.country <> n.country
        or o.q_type <> n.q_type
        or o.f_name <> n.f_name
        or o.p_class <> n.p_class
        or o.f_date <> n.f_date
        or o.f_opendate <> n.f_opendate
        or o.f_manager <> n.f_manager
        or o.f_trustee <> n.f_trustee
        or o.imp_date <> n.imp_date
        or o.pipe_id <> n.pipe_id
        or o.p_type <> n.p_type
        or o.chinesespell <> n.chinesespell
        or o.state <> n.state
        or o.user_id <> n.user_id
        or o.user_name <> n.user_name
        or o.update_time <> n.update_time
        or o.f_manager_code <> n.f_manager_code
        or o.f_trustee_code <> n.f_trustee_code
        or o.issuer_id <> n.issuer_id
        or o.f_invest_type <> n.f_invest_type
        or o.f_setupdate <> n.f_setupdate
        or o.f_manager_name <> n.f_manager_name
        or o.i_id <> n.i_id
        or o.is_idx <> n.is_idx
        or o.huge_redemption_ratio <> n.huge_redemption_ratio
        or o.compounding_method <> n.compounding_method
        or o.s_type <> n.s_type
        or o.f_mtrdate <> n.f_mtrdate
        or o.carry_forword_type <> n.carry_forword_type
        or o.inv_order_id <> n.inv_order_id
        or o.par_value <> n.par_value
        or o.pay_freq <> n.pay_freq
        or o.f_grade_type <> n.f_grade_type
        or o.f_fullname <> n.f_fullname
        or o.sales_channel <> n.sales_channel
        or o.open_type <> n.open_type
        or o.start_open_date <> n.start_open_date
        or o.end_open_date <> n.end_open_date
        or o.management_model <> n.management_model
        or o.mitigation_freq <> n.mitigation_freq
        or o.manager_value <> n.manager_value
        or o.main_code <> n.main_code
        or o.f_name_full <> n.f_name_full
        or o.pay_month <> n.pay_month
        or o.pay_day <> n.pay_day
        or o.run_term <> n.run_term
        or o.p_i_code <> n.p_i_code
        or o.p_a_type <> n.p_a_type
        or o.p_m_type <> n.p_m_type
        or o.manager_id <> n.manager_id
        or o.redemption_date <> n.redemption_date
        or o.is_pub_offer <> n.is_pub_offer
        or o.this_open_end_date <> n.this_open_end_date
        or o.this_hold_end_date <> n.this_hold_end_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tfnd_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,l_code -- 交易所本地代码
            ,currency -- 币种
            ,country -- 国家
            ,q_type -- 报价方式
            ,f_name -- 基金名称
            ,p_class -- 产品分类
            ,f_date -- 上市日期
            ,f_opendate -- 开放日期
            ,f_manager -- 管理者
            ,f_trustee -- 托管方
            ,imp_date -- 导入日期
            ,pipe_id -- 导入管道
            ,p_type -- 产品类型
            ,chinesespell -- 拼音
            ,state -- 产品状态
            ,user_id -- 操作人id
            ,user_name -- 操作人
            ,update_time -- 操作时间
            ,f_manager_code -- 管理者代码
            ,f_trustee_code -- 托管方代码
            ,issuer_id -- 管理人id
            ,f_invest_type -- 投资类型
            ,f_setupdate -- 成立日期
            ,f_manager_name -- 基金经理
            ,i_id -- 机构ID
            ,is_idx -- 是否指数型基金(0:否 1:是)
            ,huge_redemption_ratio -- 巨额赎回认定比例
            ,compounding_method -- 结转复利方式，0：单利；2：连续复利；仅对货币基金有效
            ,s_type -- 标准类型
            ,f_mtrdate -- 到期日期
            ,carry_forword_type -- 结转方式：1：按日结转，2：按月结转，3：按季结转
            ,inv_order_id -- 投金审批单号
            ,par_value -- 基金面值
            ,pay_freq -- 结转频率，仅对货币基金有效
            ,f_grade_type -- 分级基金类型，0：非分级基金；1：分级母基金；2：分级子基金A类；3：分级子基金B类；
            ,f_fullname -- 资产全称
            ,sales_channel -- 销售通道0-直销,1-代销
            ,open_type -- 每日开放：0,每周开放：1
            ,start_open_date -- 开放周期开始日
            ,end_open_date -- 开放周期结束日
            ,management_model -- 管理模式
            ,mitigation_freq -- 缓释频率
            ,manager_value -- 
            ,main_code -- 基金主代码(分级基金相同)
            ,f_name_full -- 
            ,pay_month -- 
            ,pay_day -- 
            ,run_term -- 
            ,p_i_code -- 
            ,p_a_type -- 
            ,p_m_type -- 
            ,manager_id -- 
            ,redemption_date -- 
            ,is_pub_offer -- 
            ,this_open_end_date -- 本周期开放终止日期
            ,this_hold_end_date -- 本周期持有到期日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tfnd_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,l_code -- 交易所本地代码
            ,currency -- 币种
            ,country -- 国家
            ,q_type -- 报价方式
            ,f_name -- 基金名称
            ,p_class -- 产品分类
            ,f_date -- 上市日期
            ,f_opendate -- 开放日期
            ,f_manager -- 管理者
            ,f_trustee -- 托管方
            ,imp_date -- 导入日期
            ,pipe_id -- 导入管道
            ,p_type -- 产品类型
            ,chinesespell -- 拼音
            ,state -- 产品状态
            ,user_id -- 操作人id
            ,user_name -- 操作人
            ,update_time -- 操作时间
            ,f_manager_code -- 管理者代码
            ,f_trustee_code -- 托管方代码
            ,issuer_id -- 管理人id
            ,f_invest_type -- 投资类型
            ,f_setupdate -- 成立日期
            ,f_manager_name -- 基金经理
            ,i_id -- 机构ID
            ,is_idx -- 是否指数型基金(0:否 1:是)
            ,huge_redemption_ratio -- 巨额赎回认定比例
            ,compounding_method -- 结转复利方式，0：单利；2：连续复利；仅对货币基金有效
            ,s_type -- 标准类型
            ,f_mtrdate -- 到期日期
            ,carry_forword_type -- 结转方式：1：按日结转，2：按月结转，3：按季结转
            ,inv_order_id -- 投金审批单号
            ,par_value -- 基金面值
            ,pay_freq -- 结转频率，仅对货币基金有效
            ,f_grade_type -- 分级基金类型，0：非分级基金；1：分级母基金；2：分级子基金A类；3：分级子基金B类；
            ,f_fullname -- 资产全称
            ,sales_channel -- 销售通道0-直销,1-代销
            ,open_type -- 每日开放：0,每周开放：1
            ,start_open_date -- 开放周期开始日
            ,end_open_date -- 开放周期结束日
            ,management_model -- 管理模式
            ,mitigation_freq -- 缓释频率
            ,manager_value -- 
            ,main_code -- 基金主代码(分级基金相同)
            ,f_name_full -- 
            ,pay_month -- 
            ,pay_day -- 
            ,run_term -- 
            ,p_i_code -- 
            ,p_a_type -- 
            ,p_m_type -- 
            ,manager_id -- 
            ,redemption_date -- 
            ,is_pub_offer -- 
            ,this_open_end_date -- 本周期开放终止日期
            ,this_hold_end_date -- 本周期持有到期日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_code -- 金融工具代码
    ,o.a_type -- 资产类型
    ,o.m_type -- 市场类型
    ,o.l_code -- 交易所本地代码
    ,o.currency -- 币种
    ,o.country -- 国家
    ,o.q_type -- 报价方式
    ,o.f_name -- 基金名称
    ,o.p_class -- 产品分类
    ,o.f_date -- 上市日期
    ,o.f_opendate -- 开放日期
    ,o.f_manager -- 管理者
    ,o.f_trustee -- 托管方
    ,o.imp_date -- 导入日期
    ,o.pipe_id -- 导入管道
    ,o.p_type -- 产品类型
    ,o.chinesespell -- 拼音
    ,o.state -- 产品状态
    ,o.user_id -- 操作人id
    ,o.user_name -- 操作人
    ,o.update_time -- 操作时间
    ,o.f_manager_code -- 管理者代码
    ,o.f_trustee_code -- 托管方代码
    ,o.issuer_id -- 管理人id
    ,o.f_invest_type -- 投资类型
    ,o.f_setupdate -- 成立日期
    ,o.f_manager_name -- 基金经理
    ,o.i_id -- 机构ID
    ,o.is_idx -- 是否指数型基金(0:否 1:是)
    ,o.huge_redemption_ratio -- 巨额赎回认定比例
    ,o.compounding_method -- 结转复利方式，0：单利；2：连续复利；仅对货币基金有效
    ,o.s_type -- 标准类型
    ,o.f_mtrdate -- 到期日期
    ,o.carry_forword_type -- 结转方式：1：按日结转，2：按月结转，3：按季结转
    ,o.inv_order_id -- 投金审批单号
    ,o.par_value -- 基金面值
    ,o.pay_freq -- 结转频率，仅对货币基金有效
    ,o.f_grade_type -- 分级基金类型，0：非分级基金；1：分级母基金；2：分级子基金A类；3：分级子基金B类；
    ,o.f_fullname -- 资产全称
    ,o.sales_channel -- 销售通道0-直销,1-代销
    ,o.open_type -- 每日开放：0,每周开放：1
    ,o.start_open_date -- 开放周期开始日
    ,o.end_open_date -- 开放周期结束日
    ,o.management_model -- 管理模式
    ,o.mitigation_freq -- 缓释频率
    ,o.manager_value -- 
    ,o.main_code -- 基金主代码(分级基金相同)
    ,o.f_name_full -- 
    ,o.pay_month -- 
    ,o.pay_day -- 
    ,o.run_term -- 
    ,o.p_i_code -- 
    ,o.p_a_type -- 
    ,o.p_m_type -- 
    ,o.manager_id -- 
    ,o.redemption_date -- 
    ,o.is_pub_offer -- 
    ,o.this_open_end_date -- 本周期开放终止日期
    ,o.this_hold_end_date -- 本周期持有到期日期
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
from ${iol_schema}.ibms_tfnd_bk o
    left join ${iol_schema}.ibms_tfnd_op n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_tfnd_cl d
        on
            o.i_code = d.i_code
            and o.a_type = d.a_type
            and o.m_type = d.m_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_tfnd;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_tfnd') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_tfnd drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_tfnd add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_tfnd exchange partition p_${batch_date} with table ${iol_schema}.ibms_tfnd_cl;
alter table ${iol_schema}.ibms_tfnd exchange partition p_20991231 with table ${iol_schema}.ibms_tfnd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_tfnd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tfnd_op purge;
drop table ${iol_schema}.ibms_tfnd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_tfnd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_tfnd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
