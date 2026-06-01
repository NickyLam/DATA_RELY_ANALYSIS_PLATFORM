/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_und_asset
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
create table ${iol_schema}.ibms_ttrd_und_asset_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_und_asset;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_und_asset_op purge;
drop table ${iol_schema}.ibms_ttrd_und_asset_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_und_asset_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_und_asset where 0=1;

create table ${iol_schema}.ibms_ttrd_und_asset_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_und_asset where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_und_asset_cl(
            id -- 内部资产编号
            ,parent_id -- 上层资产编号
            ,i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,u_i_code -- 资产代码
            ,u_i_name -- 资产名称
            ,a_class -- 资产分类
            ,a_class_min -- 资产小类
            ,amount -- 投资金额(元)
            ,inv_date -- 投资日期
            ,start_date -- 起息日
            ,mtr_date -- 到期日
            ,coupon -- 利率
            ,payment_freq -- 付息频率
            ,first_payment_date -- 首次付息日
            ,currency -- 币种
            ,update_time -- 更新时间
            ,update_user -- 更新人
            ,imp_date -- 导入日期
            ,party_id -- 交易对手
            ,und_status -- 底层资产状态，0-新建，1-已生效，2-失效
            ,is_using_credit -- 是否占用授信，0-不占用，1-占用
            ,credit_status -- 授信状态，0-未占用，1-已占用
            ,credit_party_id -- 授信主体
            ,credit_weight -- 授信权重
            ,credit_amount -- 授信金额
            ,account_user -- 复核人
            ,account_time -- 复核时间
            ,account_date -- 复核日期
            ,deprecate_user -- 作废人
            ,deprecate_date -- 作废日期
            ,update_date -- 更新日期
            ,prop -- 投资比例
            ,risk_weight -- 风险权重
            ,risk_asset_id -- 风险资产分类，对应TTRD_PROJECT_RISK_WEIGHT表中的PROJECT_VALUE
            ,category -- 行业分类
            ,volume -- 投资份额
            ,belong_toarea -- 省份
            ,belong_tocity -- 城市id
            ,belong_tocityname -- 城市名称
            ,grade -- 评级，对应字典undassetgrade
            ,grade_insti -- 评级机构
            ,final_invest -- 最终投向类型，对应字典undassetfinalinvest
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_und_asset_op(
            id -- 内部资产编号
            ,parent_id -- 上层资产编号
            ,i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,u_i_code -- 资产代码
            ,u_i_name -- 资产名称
            ,a_class -- 资产分类
            ,a_class_min -- 资产小类
            ,amount -- 投资金额(元)
            ,inv_date -- 投资日期
            ,start_date -- 起息日
            ,mtr_date -- 到期日
            ,coupon -- 利率
            ,payment_freq -- 付息频率
            ,first_payment_date -- 首次付息日
            ,currency -- 币种
            ,update_time -- 更新时间
            ,update_user -- 更新人
            ,imp_date -- 导入日期
            ,party_id -- 交易对手
            ,und_status -- 底层资产状态，0-新建，1-已生效，2-失效
            ,is_using_credit -- 是否占用授信，0-不占用，1-占用
            ,credit_status -- 授信状态，0-未占用，1-已占用
            ,credit_party_id -- 授信主体
            ,credit_weight -- 授信权重
            ,credit_amount -- 授信金额
            ,account_user -- 复核人
            ,account_time -- 复核时间
            ,account_date -- 复核日期
            ,deprecate_user -- 作废人
            ,deprecate_date -- 作废日期
            ,update_date -- 更新日期
            ,prop -- 投资比例
            ,risk_weight -- 风险权重
            ,risk_asset_id -- 风险资产分类，对应TTRD_PROJECT_RISK_WEIGHT表中的PROJECT_VALUE
            ,category -- 行业分类
            ,volume -- 投资份额
            ,belong_toarea -- 省份
            ,belong_tocity -- 城市id
            ,belong_tocityname -- 城市名称
            ,grade -- 评级，对应字典undassetgrade
            ,grade_insti -- 评级机构
            ,final_invest -- 最终投向类型，对应字典undassetfinalinvest
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 内部资产编号
    ,nvl(n.parent_id, o.parent_id) as parent_id -- 上层资产编号
    ,nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.u_i_code, o.u_i_code) as u_i_code -- 资产代码
    ,nvl(n.u_i_name, o.u_i_name) as u_i_name -- 资产名称
    ,nvl(n.a_class, o.a_class) as a_class -- 资产分类
    ,nvl(n.a_class_min, o.a_class_min) as a_class_min -- 资产小类
    ,nvl(n.amount, o.amount) as amount -- 投资金额(元)
    ,nvl(n.inv_date, o.inv_date) as inv_date -- 投资日期
    ,nvl(n.start_date, o.start_date) as start_date -- 起息日
    ,nvl(n.mtr_date, o.mtr_date) as mtr_date -- 到期日
    ,nvl(n.coupon, o.coupon) as coupon -- 利率
    ,nvl(n.payment_freq, o.payment_freq) as payment_freq -- 付息频率
    ,nvl(n.first_payment_date, o.first_payment_date) as first_payment_date -- 首次付息日
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.imp_date, o.imp_date) as imp_date -- 导入日期
    ,nvl(n.party_id, o.party_id) as party_id -- 交易对手
    ,nvl(n.und_status, o.und_status) as und_status -- 底层资产状态，0-新建，1-已生效，2-失效
    ,nvl(n.is_using_credit, o.is_using_credit) as is_using_credit -- 是否占用授信，0-不占用，1-占用
    ,nvl(n.credit_status, o.credit_status) as credit_status -- 授信状态，0-未占用，1-已占用
    ,nvl(n.credit_party_id, o.credit_party_id) as credit_party_id -- 授信主体
    ,nvl(n.credit_weight, o.credit_weight) as credit_weight -- 授信权重
    ,nvl(n.credit_amount, o.credit_amount) as credit_amount -- 授信金额
    ,nvl(n.account_user, o.account_user) as account_user -- 复核人
    ,nvl(n.account_time, o.account_time) as account_time -- 复核时间
    ,nvl(n.account_date, o.account_date) as account_date -- 复核日期
    ,nvl(n.deprecate_user, o.deprecate_user) as deprecate_user -- 作废人
    ,nvl(n.deprecate_date, o.deprecate_date) as deprecate_date -- 作废日期
    ,nvl(n.update_date, o.update_date) as update_date -- 更新日期
    ,nvl(n.prop, o.prop) as prop -- 投资比例
    ,nvl(n.risk_weight, o.risk_weight) as risk_weight -- 风险权重
    ,nvl(n.risk_asset_id, o.risk_asset_id) as risk_asset_id -- 风险资产分类，对应TTRD_PROJECT_RISK_WEIGHT表中的PROJECT_VALUE
    ,nvl(n.category, o.category) as category -- 行业分类
    ,nvl(n.volume, o.volume) as volume -- 投资份额
    ,nvl(n.belong_toarea, o.belong_toarea) as belong_toarea -- 省份
    ,nvl(n.belong_tocity, o.belong_tocity) as belong_tocity -- 城市id
    ,nvl(n.belong_tocityname, o.belong_tocityname) as belong_tocityname -- 城市名称
    ,nvl(n.grade, o.grade) as grade -- 评级，对应字典undassetgrade
    ,nvl(n.grade_insti, o.grade_insti) as grade_insti -- 评级机构
    ,nvl(n.final_invest, o.final_invest) as final_invest -- 最终投向类型，对应字典undassetfinalinvest
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_und_asset_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_und_asset where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.parent_id <> n.parent_id
        or o.i_code <> n.i_code
        or o.a_type <> n.a_type
        or o.m_type <> n.m_type
        or o.u_i_code <> n.u_i_code
        or o.u_i_name <> n.u_i_name
        or o.a_class <> n.a_class
        or o.a_class_min <> n.a_class_min
        or o.amount <> n.amount
        or o.inv_date <> n.inv_date
        or o.start_date <> n.start_date
        or o.mtr_date <> n.mtr_date
        or o.coupon <> n.coupon
        or o.payment_freq <> n.payment_freq
        or o.first_payment_date <> n.first_payment_date
        or o.currency <> n.currency
        or o.update_time <> n.update_time
        or o.update_user <> n.update_user
        or o.imp_date <> n.imp_date
        or o.party_id <> n.party_id
        or o.und_status <> n.und_status
        or o.is_using_credit <> n.is_using_credit
        or o.credit_status <> n.credit_status
        or o.credit_party_id <> n.credit_party_id
        or o.credit_weight <> n.credit_weight
        or o.credit_amount <> n.credit_amount
        or o.account_user <> n.account_user
        or o.account_time <> n.account_time
        or o.account_date <> n.account_date
        or o.deprecate_user <> n.deprecate_user
        or o.deprecate_date <> n.deprecate_date
        or o.update_date <> n.update_date
        or o.prop <> n.prop
        or o.risk_weight <> n.risk_weight
        or o.risk_asset_id <> n.risk_asset_id
        or o.category <> n.category
        or o.volume <> n.volume
        or o.belong_toarea <> n.belong_toarea
        or o.belong_tocity <> n.belong_tocity
        or o.belong_tocityname <> n.belong_tocityname
        or o.grade <> n.grade
        or o.grade_insti <> n.grade_insti
        or o.final_invest <> n.final_invest
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_und_asset_cl(
            id -- 内部资产编号
            ,parent_id -- 上层资产编号
            ,i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,u_i_code -- 资产代码
            ,u_i_name -- 资产名称
            ,a_class -- 资产分类
            ,a_class_min -- 资产小类
            ,amount -- 投资金额(元)
            ,inv_date -- 投资日期
            ,start_date -- 起息日
            ,mtr_date -- 到期日
            ,coupon -- 利率
            ,payment_freq -- 付息频率
            ,first_payment_date -- 首次付息日
            ,currency -- 币种
            ,update_time -- 更新时间
            ,update_user -- 更新人
            ,imp_date -- 导入日期
            ,party_id -- 交易对手
            ,und_status -- 底层资产状态，0-新建，1-已生效，2-失效
            ,is_using_credit -- 是否占用授信，0-不占用，1-占用
            ,credit_status -- 授信状态，0-未占用，1-已占用
            ,credit_party_id -- 授信主体
            ,credit_weight -- 授信权重
            ,credit_amount -- 授信金额
            ,account_user -- 复核人
            ,account_time -- 复核时间
            ,account_date -- 复核日期
            ,deprecate_user -- 作废人
            ,deprecate_date -- 作废日期
            ,update_date -- 更新日期
            ,prop -- 投资比例
            ,risk_weight -- 风险权重
            ,risk_asset_id -- 风险资产分类，对应TTRD_PROJECT_RISK_WEIGHT表中的PROJECT_VALUE
            ,category -- 行业分类
            ,volume -- 投资份额
            ,belong_toarea -- 省份
            ,belong_tocity -- 城市id
            ,belong_tocityname -- 城市名称
            ,grade -- 评级，对应字典undassetgrade
            ,grade_insti -- 评级机构
            ,final_invest -- 最终投向类型，对应字典undassetfinalinvest
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_und_asset_op(
            id -- 内部资产编号
            ,parent_id -- 上层资产编号
            ,i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,u_i_code -- 资产代码
            ,u_i_name -- 资产名称
            ,a_class -- 资产分类
            ,a_class_min -- 资产小类
            ,amount -- 投资金额(元)
            ,inv_date -- 投资日期
            ,start_date -- 起息日
            ,mtr_date -- 到期日
            ,coupon -- 利率
            ,payment_freq -- 付息频率
            ,first_payment_date -- 首次付息日
            ,currency -- 币种
            ,update_time -- 更新时间
            ,update_user -- 更新人
            ,imp_date -- 导入日期
            ,party_id -- 交易对手
            ,und_status -- 底层资产状态，0-新建，1-已生效，2-失效
            ,is_using_credit -- 是否占用授信，0-不占用，1-占用
            ,credit_status -- 授信状态，0-未占用，1-已占用
            ,credit_party_id -- 授信主体
            ,credit_weight -- 授信权重
            ,credit_amount -- 授信金额
            ,account_user -- 复核人
            ,account_time -- 复核时间
            ,account_date -- 复核日期
            ,deprecate_user -- 作废人
            ,deprecate_date -- 作废日期
            ,update_date -- 更新日期
            ,prop -- 投资比例
            ,risk_weight -- 风险权重
            ,risk_asset_id -- 风险资产分类，对应TTRD_PROJECT_RISK_WEIGHT表中的PROJECT_VALUE
            ,category -- 行业分类
            ,volume -- 投资份额
            ,belong_toarea -- 省份
            ,belong_tocity -- 城市id
            ,belong_tocityname -- 城市名称
            ,grade -- 评级，对应字典undassetgrade
            ,grade_insti -- 评级机构
            ,final_invest -- 最终投向类型，对应字典undassetfinalinvest
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 内部资产编号
    ,o.parent_id -- 上层资产编号
    ,o.i_code -- 金融工具代码
    ,o.a_type -- 资产类型
    ,o.m_type -- 市场类型
    ,o.u_i_code -- 资产代码
    ,o.u_i_name -- 资产名称
    ,o.a_class -- 资产分类
    ,o.a_class_min -- 资产小类
    ,o.amount -- 投资金额(元)
    ,o.inv_date -- 投资日期
    ,o.start_date -- 起息日
    ,o.mtr_date -- 到期日
    ,o.coupon -- 利率
    ,o.payment_freq -- 付息频率
    ,o.first_payment_date -- 首次付息日
    ,o.currency -- 币种
    ,o.update_time -- 更新时间
    ,o.update_user -- 更新人
    ,o.imp_date -- 导入日期
    ,o.party_id -- 交易对手
    ,o.und_status -- 底层资产状态，0-新建，1-已生效，2-失效
    ,o.is_using_credit -- 是否占用授信，0-不占用，1-占用
    ,o.credit_status -- 授信状态，0-未占用，1-已占用
    ,o.credit_party_id -- 授信主体
    ,o.credit_weight -- 授信权重
    ,o.credit_amount -- 授信金额
    ,o.account_user -- 复核人
    ,o.account_time -- 复核时间
    ,o.account_date -- 复核日期
    ,o.deprecate_user -- 作废人
    ,o.deprecate_date -- 作废日期
    ,o.update_date -- 更新日期
    ,o.prop -- 投资比例
    ,o.risk_weight -- 风险权重
    ,o.risk_asset_id -- 风险资产分类，对应TTRD_PROJECT_RISK_WEIGHT表中的PROJECT_VALUE
    ,o.category -- 行业分类
    ,o.volume -- 投资份额
    ,o.belong_toarea -- 省份
    ,o.belong_tocity -- 城市id
    ,o.belong_tocityname -- 城市名称
    ,o.grade -- 评级，对应字典undassetgrade
    ,o.grade_insti -- 评级机构
    ,o.final_invest -- 最终投向类型，对应字典undassetfinalinvest
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_und_asset_bk o
    left join ${iol_schema}.ibms_ttrd_und_asset_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_und_asset_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_und_asset;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_und_asset exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_und_asset_cl;
alter table ${iol_schema}.ibms_ttrd_und_asset exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_und_asset_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_und_asset to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_und_asset_op purge;
drop table ${iol_schema}.ibms_ttrd_und_asset_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_und_asset_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_und_asset',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
