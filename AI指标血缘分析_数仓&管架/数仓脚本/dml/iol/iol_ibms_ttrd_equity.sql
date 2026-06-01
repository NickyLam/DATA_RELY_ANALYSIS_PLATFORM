/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_equity
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
create table ${iol_schema}.ibms_ttrd_equity_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_equity
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_equity_op purge;
drop table ${iol_schema}.ibms_ttrd_equity_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_equity_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_equity where 0=1;

create table ${iol_schema}.ibms_ttrd_equity_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_equity where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_equity_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型：净值型项目spt_ntp
            ,m_type -- 市场类型
            ,l_code -- 本地代码
            ,i_name -- 金融工具名称
            ,currency -- 币种
            ,country -- 国家
            ,q_type -- 发行类型：净值型
            ,p_type -- 产品类型
            ,p_class -- 产品分类
            ,list_date -- 上市时间
            ,open_date -- 开发时间
            ,issuer -- 发行人
            ,risk_rating -- 风险等级
            ,trustee -- 托管人
            ,imp_date -- 导入日期
            ,pipe_id -- 导入方式
            ,chinesespell -- 拼音简称
            ,update_user -- 
            ,update_time -- 
            ,account_user -- 
            ,account_time -- 
            ,issuer_id -- 发行机构id
            ,trustee_id -- 托管机构id
            ,usable_flag -- 是否已生效：1： 正常 0： 新增
            ,product_rate -- 产品评级
            ,rate_institution -- 评级机构
            ,open_type -- 每日开放：0,每周开放：1
            ,start_open_date -- 开放周期开始日
            ,end_open_date -- 开放周期结束日
            ,guarantee_way -- 担保方式
            ,guarantee_infor -- 担保物情况
            ,ctrct_id -- 合同编号
            ,platform -- 平台
            ,invest_direction -- 投向
            ,final_invest -- 最终投向类型
            ,five_class -- 五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）
            ,contract_version -- 合同版本号（已审合同:0,送审合同:1,标准合同:2）
            ,extordid -- 外部交易号
            ,mitigation_freq -- 缓释频率
            ,manager_id -- 实际管理人id
            ,manager_value -- 实际管理人
            ,risk_proportion -- 风险权重占比
            ,middle_classify -- 业务中类
            ,small_classify -- 业务小类
            ,closing_start_date -- 封闭开始日(对应开放类型为封闭型)
            ,closing_end_date -- 封闭结束日(对应开放类型为封闭型)
            ,curr_open_break_date -- 本周期开放终止日期
            ,curr_hold_end_date -- 本周期持有到期日期
            ,update_time2 -- 更新时间
            ,refer_code -- 参照代码
            ,is_cash_manage_type -- 是否现金管理类产品
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_equity_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型：净值型项目spt_ntp
            ,m_type -- 市场类型
            ,l_code -- 本地代码
            ,i_name -- 金融工具名称
            ,currency -- 币种
            ,country -- 国家
            ,q_type -- 发行类型：净值型
            ,p_type -- 产品类型
            ,p_class -- 产品分类
            ,list_date -- 上市时间
            ,open_date -- 开发时间
            ,issuer -- 发行人
            ,risk_rating -- 风险等级
            ,trustee -- 托管人
            ,imp_date -- 导入日期
            ,pipe_id -- 导入方式
            ,chinesespell -- 拼音简称
            ,update_user -- 
            ,update_time -- 
            ,account_user -- 
            ,account_time -- 
            ,issuer_id -- 发行机构id
            ,trustee_id -- 托管机构id
            ,usable_flag -- 是否已生效：1： 正常 0： 新增
            ,product_rate -- 产品评级
            ,rate_institution -- 评级机构
            ,open_type -- 每日开放：0,每周开放：1
            ,start_open_date -- 开放周期开始日
            ,end_open_date -- 开放周期结束日
            ,guarantee_way -- 担保方式
            ,guarantee_infor -- 担保物情况
            ,ctrct_id -- 合同编号
            ,platform -- 平台
            ,invest_direction -- 投向
            ,final_invest -- 最终投向类型
            ,five_class -- 五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）
            ,contract_version -- 合同版本号（已审合同:0,送审合同:1,标准合同:2）
            ,extordid -- 外部交易号
            ,mitigation_freq -- 缓释频率
            ,manager_id -- 实际管理人id
            ,manager_value -- 实际管理人
            ,risk_proportion -- 风险权重占比
            ,middle_classify -- 业务中类
            ,small_classify -- 业务小类
            ,closing_start_date -- 封闭开始日(对应开放类型为封闭型)
            ,closing_end_date -- 封闭结束日(对应开放类型为封闭型)
            ,curr_open_break_date -- 本周期开放终止日期
            ,curr_hold_end_date -- 本周期持有到期日期
            ,update_time2 -- 更新时间
            ,refer_code -- 参照代码
            ,is_cash_manage_type -- 是否现金管理类产品
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型：净值型项目spt_ntp
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.l_code, o.l_code) as l_code -- 本地代码
    ,nvl(n.i_name, o.i_name) as i_name -- 金融工具名称
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.country, o.country) as country -- 国家
    ,nvl(n.q_type, o.q_type) as q_type -- 发行类型：净值型
    ,nvl(n.p_type, o.p_type) as p_type -- 产品类型
    ,nvl(n.p_class, o.p_class) as p_class -- 产品分类
    ,nvl(n.list_date, o.list_date) as list_date -- 上市时间
    ,nvl(n.open_date, o.open_date) as open_date -- 开发时间
    ,nvl(n.issuer, o.issuer) as issuer -- 发行人
    ,nvl(n.risk_rating, o.risk_rating) as risk_rating -- 风险等级
    ,nvl(n.trustee, o.trustee) as trustee -- 托管人
    ,nvl(n.imp_date, o.imp_date) as imp_date -- 导入日期
    ,nvl(n.pipe_id, o.pipe_id) as pipe_id -- 导入方式
    ,nvl(n.chinesespell, o.chinesespell) as chinesespell -- 拼音简称
    ,nvl(n.update_user, o.update_user) as update_user -- 
    ,nvl(n.update_time, o.update_time) as update_time -- 
    ,nvl(n.account_user, o.account_user) as account_user -- 
    ,nvl(n.account_time, o.account_time) as account_time -- 
    ,nvl(n.issuer_id, o.issuer_id) as issuer_id -- 发行机构id
    ,nvl(n.trustee_id, o.trustee_id) as trustee_id -- 托管机构id
    ,nvl(n.usable_flag, o.usable_flag) as usable_flag -- 是否已生效：1： 正常 0： 新增
    ,nvl(n.product_rate, o.product_rate) as product_rate -- 产品评级
    ,nvl(n.rate_institution, o.rate_institution) as rate_institution -- 评级机构
    ,nvl(n.open_type, o.open_type) as open_type -- 每日开放：0,每周开放：1
    ,nvl(n.start_open_date, o.start_open_date) as start_open_date -- 开放周期开始日
    ,nvl(n.end_open_date, o.end_open_date) as end_open_date -- 开放周期结束日
    ,nvl(n.guarantee_way, o.guarantee_way) as guarantee_way -- 担保方式
    ,nvl(n.guarantee_infor, o.guarantee_infor) as guarantee_infor -- 担保物情况
    ,nvl(n.ctrct_id, o.ctrct_id) as ctrct_id -- 合同编号
    ,nvl(n.platform, o.platform) as platform -- 平台
    ,nvl(n.invest_direction, o.invest_direction) as invest_direction -- 投向
    ,nvl(n.final_invest, o.final_invest) as final_invest -- 最终投向类型
    ,nvl(n.five_class, o.five_class) as five_class -- 五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）
    ,nvl(n.contract_version, o.contract_version) as contract_version -- 合同版本号（已审合同:0,送审合同:1,标准合同:2）
    ,nvl(n.extordid, o.extordid) as extordid -- 外部交易号
    ,nvl(n.mitigation_freq, o.mitigation_freq) as mitigation_freq -- 缓释频率
    ,nvl(n.manager_id, o.manager_id) as manager_id -- 实际管理人id
    ,nvl(n.manager_value, o.manager_value) as manager_value -- 实际管理人
    ,nvl(n.risk_proportion, o.risk_proportion) as risk_proportion -- 风险权重占比
    ,nvl(n.middle_classify, o.middle_classify) as middle_classify -- 业务中类
    ,nvl(n.small_classify, o.small_classify) as small_classify -- 业务小类
    ,nvl(n.closing_start_date, o.closing_start_date) as closing_start_date -- 封闭开始日(对应开放类型为封闭型)
    ,nvl(n.closing_end_date, o.closing_end_date) as closing_end_date -- 封闭结束日(对应开放类型为封闭型)
    ,nvl(n.curr_open_break_date, o.curr_open_break_date) as curr_open_break_date -- 本周期开放终止日期
    ,nvl(n.curr_hold_end_date, o.curr_hold_end_date) as curr_hold_end_date -- 本周期持有到期日期
    ,nvl(n.update_time2, o.update_time2) as update_time2 -- 更新时间
    ,nvl(n.refer_code, o.refer_code) as refer_code -- 参照代码
    ,nvl(n.is_cash_manage_type, o.is_cash_manage_type) as is_cash_manage_type -- 是否现金管理类产品
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
from (select * from ${iol_schema}.ibms_ttrd_equity_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_equity where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.i_name <> n.i_name
        or o.currency <> n.currency
        or o.country <> n.country
        or o.q_type <> n.q_type
        or o.p_type <> n.p_type
        or o.p_class <> n.p_class
        or o.list_date <> n.list_date
        or o.open_date <> n.open_date
        or o.issuer <> n.issuer
        or o.risk_rating <> n.risk_rating
        or o.trustee <> n.trustee
        or o.imp_date <> n.imp_date
        or o.pipe_id <> n.pipe_id
        or o.chinesespell <> n.chinesespell
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.account_user <> n.account_user
        or o.account_time <> n.account_time
        or o.issuer_id <> n.issuer_id
        or o.trustee_id <> n.trustee_id
        or o.usable_flag <> n.usable_flag
        or o.product_rate <> n.product_rate
        or o.rate_institution <> n.rate_institution
        or o.open_type <> n.open_type
        or o.start_open_date <> n.start_open_date
        or o.end_open_date <> n.end_open_date
        or o.guarantee_way <> n.guarantee_way
        or o.guarantee_infor <> n.guarantee_infor
        or o.ctrct_id <> n.ctrct_id
        or o.platform <> n.platform
        or o.invest_direction <> n.invest_direction
        or o.final_invest <> n.final_invest
        or o.five_class <> n.five_class
        or o.contract_version <> n.contract_version
        or o.extordid <> n.extordid
        or o.mitigation_freq <> n.mitigation_freq
        or o.manager_id <> n.manager_id
        or o.manager_value <> n.manager_value
        or o.risk_proportion <> n.risk_proportion
        or o.middle_classify <> n.middle_classify
        or o.small_classify <> n.small_classify
        or o.closing_start_date <> n.closing_start_date
        or o.closing_end_date <> n.closing_end_date
        or o.curr_open_break_date <> n.curr_open_break_date
        or o.curr_hold_end_date <> n.curr_hold_end_date
        or o.update_time2 <> n.update_time2
        or o.refer_code <> n.refer_code
        or o.is_cash_manage_type <> n.is_cash_manage_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_equity_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型：净值型项目spt_ntp
            ,m_type -- 市场类型
            ,l_code -- 本地代码
            ,i_name -- 金融工具名称
            ,currency -- 币种
            ,country -- 国家
            ,q_type -- 发行类型：净值型
            ,p_type -- 产品类型
            ,p_class -- 产品分类
            ,list_date -- 上市时间
            ,open_date -- 开发时间
            ,issuer -- 发行人
            ,risk_rating -- 风险等级
            ,trustee -- 托管人
            ,imp_date -- 导入日期
            ,pipe_id -- 导入方式
            ,chinesespell -- 拼音简称
            ,update_user -- 
            ,update_time -- 
            ,account_user -- 
            ,account_time -- 
            ,issuer_id -- 发行机构id
            ,trustee_id -- 托管机构id
            ,usable_flag -- 是否已生效：1： 正常 0： 新增
            ,product_rate -- 产品评级
            ,rate_institution -- 评级机构
            ,open_type -- 每日开放：0,每周开放：1
            ,start_open_date -- 开放周期开始日
            ,end_open_date -- 开放周期结束日
            ,guarantee_way -- 担保方式
            ,guarantee_infor -- 担保物情况
            ,ctrct_id -- 合同编号
            ,platform -- 平台
            ,invest_direction -- 投向
            ,final_invest -- 最终投向类型
            ,five_class -- 五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）
            ,contract_version -- 合同版本号（已审合同:0,送审合同:1,标准合同:2）
            ,extordid -- 外部交易号
            ,mitigation_freq -- 缓释频率
            ,manager_id -- 实际管理人id
            ,manager_value -- 实际管理人
            ,risk_proportion -- 风险权重占比
            ,middle_classify -- 业务中类
            ,small_classify -- 业务小类
            ,closing_start_date -- 封闭开始日(对应开放类型为封闭型)
            ,closing_end_date -- 封闭结束日(对应开放类型为封闭型)
            ,curr_open_break_date -- 本周期开放终止日期
            ,curr_hold_end_date -- 本周期持有到期日期
            ,update_time2 -- 更新时间
            ,refer_code -- 参照代码
            ,is_cash_manage_type -- 是否现金管理类产品
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_equity_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型：净值型项目spt_ntp
            ,m_type -- 市场类型
            ,l_code -- 本地代码
            ,i_name -- 金融工具名称
            ,currency -- 币种
            ,country -- 国家
            ,q_type -- 发行类型：净值型
            ,p_type -- 产品类型
            ,p_class -- 产品分类
            ,list_date -- 上市时间
            ,open_date -- 开发时间
            ,issuer -- 发行人
            ,risk_rating -- 风险等级
            ,trustee -- 托管人
            ,imp_date -- 导入日期
            ,pipe_id -- 导入方式
            ,chinesespell -- 拼音简称
            ,update_user -- 
            ,update_time -- 
            ,account_user -- 
            ,account_time -- 
            ,issuer_id -- 发行机构id
            ,trustee_id -- 托管机构id
            ,usable_flag -- 是否已生效：1： 正常 0： 新增
            ,product_rate -- 产品评级
            ,rate_institution -- 评级机构
            ,open_type -- 每日开放：0,每周开放：1
            ,start_open_date -- 开放周期开始日
            ,end_open_date -- 开放周期结束日
            ,guarantee_way -- 担保方式
            ,guarantee_infor -- 担保物情况
            ,ctrct_id -- 合同编号
            ,platform -- 平台
            ,invest_direction -- 投向
            ,final_invest -- 最终投向类型
            ,five_class -- 五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）
            ,contract_version -- 合同版本号（已审合同:0,送审合同:1,标准合同:2）
            ,extordid -- 外部交易号
            ,mitigation_freq -- 缓释频率
            ,manager_id -- 实际管理人id
            ,manager_value -- 实际管理人
            ,risk_proportion -- 风险权重占比
            ,middle_classify -- 业务中类
            ,small_classify -- 业务小类
            ,closing_start_date -- 封闭开始日(对应开放类型为封闭型)
            ,closing_end_date -- 封闭结束日(对应开放类型为封闭型)
            ,curr_open_break_date -- 本周期开放终止日期
            ,curr_hold_end_date -- 本周期持有到期日期
            ,update_time2 -- 更新时间
            ,refer_code -- 参照代码
            ,is_cash_manage_type -- 是否现金管理类产品
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_code -- 金融工具代码
    ,o.a_type -- 资产类型：净值型项目spt_ntp
    ,o.m_type -- 市场类型
    ,o.l_code -- 本地代码
    ,o.i_name -- 金融工具名称
    ,o.currency -- 币种
    ,o.country -- 国家
    ,o.q_type -- 发行类型：净值型
    ,o.p_type -- 产品类型
    ,o.p_class -- 产品分类
    ,o.list_date -- 上市时间
    ,o.open_date -- 开发时间
    ,o.issuer -- 发行人
    ,o.risk_rating -- 风险等级
    ,o.trustee -- 托管人
    ,o.imp_date -- 导入日期
    ,o.pipe_id -- 导入方式
    ,o.chinesespell -- 拼音简称
    ,o.update_user -- 
    ,o.update_time -- 
    ,o.account_user -- 
    ,o.account_time -- 
    ,o.issuer_id -- 发行机构id
    ,o.trustee_id -- 托管机构id
    ,o.usable_flag -- 是否已生效：1： 正常 0： 新增
    ,o.product_rate -- 产品评级
    ,o.rate_institution -- 评级机构
    ,o.open_type -- 每日开放：0,每周开放：1
    ,o.start_open_date -- 开放周期开始日
    ,o.end_open_date -- 开放周期结束日
    ,o.guarantee_way -- 担保方式
    ,o.guarantee_infor -- 担保物情况
    ,o.ctrct_id -- 合同编号
    ,o.platform -- 平台
    ,o.invest_direction -- 投向
    ,o.final_invest -- 最终投向类型
    ,o.five_class -- 五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）
    ,o.contract_version -- 合同版本号（已审合同:0,送审合同:1,标准合同:2）
    ,o.extordid -- 外部交易号
    ,o.mitigation_freq -- 缓释频率
    ,o.manager_id -- 实际管理人id
    ,o.manager_value -- 实际管理人
    ,o.risk_proportion -- 风险权重占比
    ,o.middle_classify -- 业务中类
    ,o.small_classify -- 业务小类
    ,o.closing_start_date -- 封闭开始日(对应开放类型为封闭型)
    ,o.closing_end_date -- 封闭结束日(对应开放类型为封闭型)
    ,o.curr_open_break_date -- 本周期开放终止日期
    ,o.curr_hold_end_date -- 本周期持有到期日期
    ,o.update_time2 -- 更新时间
    ,o.refer_code -- 参照代码
    ,o.is_cash_manage_type -- 是否现金管理类产品
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
from ${iol_schema}.ibms_ttrd_equity_bk o
    left join ${iol_schema}.ibms_ttrd_equity_op n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_equity_cl d
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
--truncate table ${iol_schema}.ibms_ttrd_equity;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_equity') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_equity drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_equity add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_equity exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_equity_cl;
alter table ${iol_schema}.ibms_ttrd_equity exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_equity_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_equity to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_equity_op purge;
drop table ${iol_schema}.ibms_ttrd_equity_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_equity_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_equity',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
