/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_chinamutualfunddescription
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.wind_chinamutualfunddescription_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_chinamutualfunddescription
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_chinamutualfunddescription_op purge;
drop table ${iol_schema}.wind_chinamutualfunddescription_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_chinamutualfunddescription_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_chinamutualfunddescription where 0=1;

create table ${iol_schema}.wind_chinamutualfunddescription_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_chinamutualfunddescription where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.wind_chinamutualfunddescription_op(
        object_id -- 对象ID
        ,f_info_windcode -- Wind代码
        ,f_info_front_code -- 前端代码
        ,f_info_backend_code -- 后端代码
        ,f_info_fullname -- 名称
        ,f_info_name -- 简称
        ,f_info_corp_fundmanagementcomp -- 管理人
        ,f_info_custodianbank -- 托管人
        ,f_info_firstinvesttype -- 投资类型
        ,f_info_setupdate -- 成立日期
        ,f_info_maturitydate -- 到期日期
        ,f_issue_totalunit -- 发行份额
        ,f_info_managementfeeratio -- 管理费
        ,f_info_custodianfeeratio -- 托管费
        ,crny_code -- 货币代码
        ,f_info_ptmyear -- 存续期
        ,f_issue_oef_startdateinst -- 机构投资者认购起始日
        ,f_issue_oef_dnddateinst -- 机构投资者认购终止日
        ,f_info_parvalue -- 面值
        ,f_info_trusttype -- 信托类别
        ,f_info_trustee -- 受托人
        ,f_pchredm_pchstartdate -- 日常申购起始日
        ,f_info_redmstartdate -- 日常赎回起始日
        ,f_info_minbuyamount -- 起点金额
        ,f_info_expectedrateofreturn -- 预期收益率
        ,f_info_issuingplace -- 发行地
        ,f_info_benchmark -- 业绩比较基准
        ,f_info_status -- 存续状态
        ,f_info_restrictedornot -- 限定类型
        ,f_info_structuredornot -- 是否结构化产品
        ,f_info_exchmarket -- 交易所
        ,f_info_firstinveststyle -- 投资风格
        ,f_info_issuedate -- 发行日期
        ,f_info_type -- 基金类型
        ,f_info_isinitial -- 是否为初始基金
        ,f_info_pinyin -- 简称拼音
        ,f_info_investscope -- 投资范围
        ,f_info_investobject -- 投资目标
        ,f_info_investconception -- 投资理念
        ,f_info_decision_basis -- 决策依据
        ,is_indexfund -- 是否指数基金
        ,f_info_delistdate -- 退市日期
        ,f_info_corp_fundmanagementid -- 基金管理人ID
        ,f_info_custodianbankid -- 托管人id
        ,max_num_holder -- 单一投资者持有份额上限(亿份)
        ,max_num_coltarget -- 封闭期目标募集数量上限(亿份)
        ,investstrategy -- 投资策略
        ,risk_return -- 基金风险收益特征
        ,f_pchredm_pchminamt -- 每次最低申购金额(场外)(万元)
        ,f_pchredm_pchminamt_ex -- 每次最低申购金额(场内) (万元)
        ,f_info_listdate -- 上市时间
        ,f_info_anndate -- 公告日期
        ,f_closed_operation_period -- 封闭运作期
        ,f_closed_operation_interval -- 封闭运作期满开放日间隔
        ,f_info_registrant -- 基金注册与过户登记人ID
        ,f_personal_startdateind -- 个人投资者认购起始日
        ,f_personal_enddateind -- 个人投资者认购终止日
        ,f_info_fund_id -- 基金品种ID
        ,f_personal_subtype -- 个人投资者认购方式
        ,close_institu_subtype -- 封闭期机构投资者认购方式
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.object_id -- 对象ID
    ,n.f_info_windcode -- Wind代码
    ,n.f_info_front_code -- 前端代码
    ,n.f_info_backend_code -- 后端代码
    ,n.f_info_fullname -- 名称
    ,n.f_info_name -- 简称
    ,n.f_info_corp_fundmanagementcomp -- 管理人
    ,n.f_info_custodianbank -- 托管人
    ,n.f_info_firstinvesttype -- 投资类型
    ,n.f_info_setupdate -- 成立日期
    ,n.f_info_maturitydate -- 到期日期
    ,n.f_issue_totalunit -- 发行份额
    ,n.f_info_managementfeeratio -- 管理费
    ,n.f_info_custodianfeeratio -- 托管费
    ,n.crny_code -- 货币代码
    ,n.f_info_ptmyear -- 存续期
    ,n.f_issue_oef_startdateinst -- 机构投资者认购起始日
    ,n.f_issue_oef_dnddateinst -- 机构投资者认购终止日
    ,n.f_info_parvalue -- 面值
    ,n.f_info_trusttype -- 信托类别
    ,n.f_info_trustee -- 受托人
    ,n.f_pchredm_pchstartdate -- 日常申购起始日
    ,n.f_info_redmstartdate -- 日常赎回起始日
    ,n.f_info_minbuyamount -- 起点金额
    ,n.f_info_expectedrateofreturn -- 预期收益率
    ,n.f_info_issuingplace -- 发行地
    ,n.f_info_benchmark -- 业绩比较基准
    ,n.f_info_status -- 存续状态
    ,n.f_info_restrictedornot -- 限定类型
    ,n.f_info_structuredornot -- 是否结构化产品
    ,n.f_info_exchmarket -- 交易所
    ,n.f_info_firstinveststyle -- 投资风格
    ,n.f_info_issuedate -- 发行日期
    ,n.f_info_type -- 基金类型
    ,n.f_info_isinitial -- 是否为初始基金
    ,n.f_info_pinyin -- 简称拼音
    ,substr(n.f_info_investscope,1,1051) as f_info_investscope -- 投资范围
    ,n.f_info_investobject -- 投资目标
    ,n.f_info_investconception -- 投资理念
    ,n.f_info_decision_basis -- 决策依据
    ,n.is_indexfund -- 是否指数基金
    ,n.f_info_delistdate -- 退市日期
    ,n.f_info_corp_fundmanagementid -- 基金管理人ID
    ,n.f_info_custodianbankid -- 托管人id
    ,n.max_num_holder -- 单一投资者持有份额上限(亿份)
    ,n.max_num_coltarget -- 封闭期目标募集数量上限(亿份)
    ,n.investstrategy -- 投资策略
    ,n.risk_return -- 基金风险收益特征
    ,n.f_pchredm_pchminamt -- 每次最低申购金额(场外)(万元)
    ,n.f_pchredm_pchminamt_ex -- 每次最低申购金额(场内) (万元)
    ,n.f_info_listdate -- 上市时间
    ,n.f_info_anndate -- 公告日期
    ,n.f_closed_operation_period -- 封闭运作期
    ,n.f_closed_operation_interval -- 封闭运作期满开放日间隔
    ,n.f_info_registrant -- 基金注册与过户登记人ID
    ,n.f_personal_startdateind -- 个人投资者认购起始日
    ,n.f_personal_enddateind -- 个人投资者认购终止日
    ,n.f_info_fund_id -- 基金品种ID
    ,n.f_personal_subtype -- 个人投资者认购方式
    ,n.close_institu_subtype -- 封闭期机构投资者认购方式
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_chinamutualfunddescription_bk o
    right join (select * from ${itl_schema}.wind_chinamutualfunddescription where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.f_info_windcode = n.f_info_windcode
where (
        o.f_info_windcode is null
    )
    or (
        o.object_id <> n.object_id
        or o.f_info_front_code <> n.f_info_front_code
        or o.f_info_backend_code <> n.f_info_backend_code
        or o.f_info_fullname <> n.f_info_fullname
        or o.f_info_name <> n.f_info_name
        or o.f_info_corp_fundmanagementcomp <> n.f_info_corp_fundmanagementcomp
        or o.f_info_custodianbank <> n.f_info_custodianbank
        or o.f_info_firstinvesttype <> n.f_info_firstinvesttype
        or o.f_info_setupdate <> n.f_info_setupdate
        or o.f_info_maturitydate <> n.f_info_maturitydate
        or o.f_issue_totalunit <> n.f_issue_totalunit
        or o.f_info_managementfeeratio <> n.f_info_managementfeeratio
        or o.f_info_custodianfeeratio <> n.f_info_custodianfeeratio
        or o.crny_code <> n.crny_code
        or o.f_info_ptmyear <> n.f_info_ptmyear
        or o.f_issue_oef_startdateinst <> n.f_issue_oef_startdateinst
        or o.f_issue_oef_dnddateinst <> n.f_issue_oef_dnddateinst
        or o.f_info_parvalue <> n.f_info_parvalue
        or o.f_info_trusttype <> n.f_info_trusttype
        or o.f_info_trustee <> n.f_info_trustee
        or o.f_pchredm_pchstartdate <> n.f_pchredm_pchstartdate
        or o.f_info_redmstartdate <> n.f_info_redmstartdate
        or o.f_info_minbuyamount <> n.f_info_minbuyamount
        or o.f_info_expectedrateofreturn <> n.f_info_expectedrateofreturn
        or o.f_info_issuingplace <> n.f_info_issuingplace
        or o.f_info_benchmark <> n.f_info_benchmark
        or o.f_info_status <> n.f_info_status
        or o.f_info_restrictedornot <> n.f_info_restrictedornot
        or o.f_info_structuredornot <> n.f_info_structuredornot
        or o.f_info_exchmarket <> n.f_info_exchmarket
        or o.f_info_firstinveststyle <> n.f_info_firstinveststyle
        or o.f_info_issuedate <> n.f_info_issuedate
        or o.f_info_type <> n.f_info_type
        or o.f_info_isinitial <> n.f_info_isinitial
        or o.f_info_pinyin <> n.f_info_pinyin
        or o.f_info_investscope <> n.f_info_investscope
        or o.f_info_investobject <> n.f_info_investobject
        or o.f_info_investconception <> n.f_info_investconception
        or o.f_info_decision_basis <> n.f_info_decision_basis
        or o.is_indexfund <> n.is_indexfund
        or o.f_info_delistdate <> n.f_info_delistdate
        or o.f_info_corp_fundmanagementid <> n.f_info_corp_fundmanagementid
        or o.f_info_custodianbankid <> n.f_info_custodianbankid
        or o.max_num_holder <> n.max_num_holder
        or o.max_num_coltarget <> n.max_num_coltarget
        or o.investstrategy <> n.investstrategy
        or o.risk_return <> n.risk_return
        or o.f_pchredm_pchminamt <> n.f_pchredm_pchminamt
        or o.f_pchredm_pchminamt_ex <> n.f_pchredm_pchminamt_ex
        or o.f_info_listdate <> n.f_info_listdate
        or o.f_info_anndate <> n.f_info_anndate
        or o.f_closed_operation_period <> n.f_closed_operation_period
        or o.f_closed_operation_interval <> n.f_closed_operation_interval
        or o.f_info_registrant <> n.f_info_registrant
        or o.f_personal_startdateind <> n.f_personal_startdateind
        or o.f_personal_enddateind <> n.f_personal_enddateind
        or o.f_info_fund_id <> n.f_info_fund_id
        or o.f_personal_subtype <> n.f_personal_subtype
        or o.close_institu_subtype <> n.close_institu_subtype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_chinamutualfunddescription_cl(
            object_id -- 对象ID
        ,f_info_windcode -- Wind代码
        ,f_info_front_code -- 前端代码
        ,f_info_backend_code -- 后端代码
        ,f_info_fullname -- 名称
        ,f_info_name -- 简称
        ,f_info_corp_fundmanagementcomp -- 管理人
        ,f_info_custodianbank -- 托管人
        ,f_info_firstinvesttype -- 投资类型
        ,f_info_setupdate -- 成立日期
        ,f_info_maturitydate -- 到期日期
        ,f_issue_totalunit -- 发行份额
        ,f_info_managementfeeratio -- 管理费
        ,f_info_custodianfeeratio -- 托管费
        ,crny_code -- 货币代码
        ,f_info_ptmyear -- 存续期
        ,f_issue_oef_startdateinst -- 机构投资者认购起始日
        ,f_issue_oef_dnddateinst -- 机构投资者认购终止日
        ,f_info_parvalue -- 面值
        ,f_info_trusttype -- 信托类别
        ,f_info_trustee -- 受托人
        ,f_pchredm_pchstartdate -- 日常申购起始日
        ,f_info_redmstartdate -- 日常赎回起始日
        ,f_info_minbuyamount -- 起点金额
        ,f_info_expectedrateofreturn -- 预期收益率
        ,f_info_issuingplace -- 发行地
        ,f_info_benchmark -- 业绩比较基准
        ,f_info_status -- 存续状态
        ,f_info_restrictedornot -- 限定类型
        ,f_info_structuredornot -- 是否结构化产品
        ,f_info_exchmarket -- 交易所
        ,f_info_firstinveststyle -- 投资风格
        ,f_info_issuedate -- 发行日期
        ,f_info_type -- 基金类型
        ,f_info_isinitial -- 是否为初始基金
        ,f_info_pinyin -- 简称拼音
        ,f_info_investscope -- 投资范围
        ,f_info_investobject -- 投资目标
        ,f_info_investconception -- 投资理念
        ,f_info_decision_basis -- 决策依据
        ,is_indexfund -- 是否指数基金
        ,f_info_delistdate -- 退市日期
        ,f_info_corp_fundmanagementid -- 基金管理人ID
        ,f_info_custodianbankid -- 托管人id
        ,max_num_holder -- 单一投资者持有份额上限(亿份)
        ,max_num_coltarget -- 封闭期目标募集数量上限(亿份)
        ,investstrategy -- 投资策略
        ,risk_return -- 基金风险收益特征
        ,f_pchredm_pchminamt -- 每次最低申购金额(场外)(万元)
        ,f_pchredm_pchminamt_ex -- 每次最低申购金额(场内) (万元)
        ,f_info_listdate -- 上市时间
        ,f_info_anndate -- 公告日期
        ,f_closed_operation_period -- 封闭运作期
        ,f_closed_operation_interval -- 封闭运作期满开放日间隔
        ,f_info_registrant -- 基金注册与过户登记人ID
        ,f_personal_startdateind -- 个人投资者认购起始日
        ,f_personal_enddateind -- 个人投资者认购终止日
        ,f_info_fund_id -- 基金品种ID
        ,f_personal_subtype -- 个人投资者认购方式
        ,close_institu_subtype -- 封闭期机构投资者认购方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_chinamutualfunddescription_op(
            object_id -- 对象ID
        ,f_info_windcode -- Wind代码
        ,f_info_front_code -- 前端代码
        ,f_info_backend_code -- 后端代码
        ,f_info_fullname -- 名称
        ,f_info_name -- 简称
        ,f_info_corp_fundmanagementcomp -- 管理人
        ,f_info_custodianbank -- 托管人
        ,f_info_firstinvesttype -- 投资类型
        ,f_info_setupdate -- 成立日期
        ,f_info_maturitydate -- 到期日期
        ,f_issue_totalunit -- 发行份额
        ,f_info_managementfeeratio -- 管理费
        ,f_info_custodianfeeratio -- 托管费
        ,crny_code -- 货币代码
        ,f_info_ptmyear -- 存续期
        ,f_issue_oef_startdateinst -- 机构投资者认购起始日
        ,f_issue_oef_dnddateinst -- 机构投资者认购终止日
        ,f_info_parvalue -- 面值
        ,f_info_trusttype -- 信托类别
        ,f_info_trustee -- 受托人
        ,f_pchredm_pchstartdate -- 日常申购起始日
        ,f_info_redmstartdate -- 日常赎回起始日
        ,f_info_minbuyamount -- 起点金额
        ,f_info_expectedrateofreturn -- 预期收益率
        ,f_info_issuingplace -- 发行地
        ,f_info_benchmark -- 业绩比较基准
        ,f_info_status -- 存续状态
        ,f_info_restrictedornot -- 限定类型
        ,f_info_structuredornot -- 是否结构化产品
        ,f_info_exchmarket -- 交易所
        ,f_info_firstinveststyle -- 投资风格
        ,f_info_issuedate -- 发行日期
        ,f_info_type -- 基金类型
        ,f_info_isinitial -- 是否为初始基金
        ,f_info_pinyin -- 简称拼音
        ,f_info_investscope -- 投资范围
        ,f_info_investobject -- 投资目标
        ,f_info_investconception -- 投资理念
        ,f_info_decision_basis -- 决策依据
        ,is_indexfund -- 是否指数基金
        ,f_info_delistdate -- 退市日期
        ,f_info_corp_fundmanagementid -- 基金管理人ID
        ,f_info_custodianbankid -- 托管人id
        ,max_num_holder -- 单一投资者持有份额上限(亿份)
        ,max_num_coltarget -- 封闭期目标募集数量上限(亿份)
        ,investstrategy -- 投资策略
        ,risk_return -- 基金风险收益特征
        ,f_pchredm_pchminamt -- 每次最低申购金额(场外)(万元)
        ,f_pchredm_pchminamt_ex -- 每次最低申购金额(场内) (万元)
        ,f_info_listdate -- 上市时间
        ,f_info_anndate -- 公告日期
        ,f_closed_operation_period -- 封闭运作期
        ,f_closed_operation_interval -- 封闭运作期满开放日间隔
        ,f_info_registrant -- 基金注册与过户登记人ID
        ,f_personal_startdateind -- 个人投资者认购起始日
        ,f_personal_enddateind -- 个人投资者认购终止日
        ,f_info_fund_id -- 基金品种ID
        ,f_personal_subtype -- 个人投资者认购方式
        ,close_institu_subtype -- 封闭期机构投资者认购方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象ID
    ,o.f_info_windcode -- Wind代码
    ,o.f_info_front_code -- 前端代码
    ,o.f_info_backend_code -- 后端代码
    ,o.f_info_fullname -- 名称
    ,o.f_info_name -- 简称
    ,o.f_info_corp_fundmanagementcomp -- 管理人
    ,o.f_info_custodianbank -- 托管人
    ,o.f_info_firstinvesttype -- 投资类型
    ,o.f_info_setupdate -- 成立日期
    ,o.f_info_maturitydate -- 到期日期
    ,o.f_issue_totalunit -- 发行份额
    ,o.f_info_managementfeeratio -- 管理费
    ,o.f_info_custodianfeeratio -- 托管费
    ,o.crny_code -- 货币代码
    ,o.f_info_ptmyear -- 存续期
    ,o.f_issue_oef_startdateinst -- 机构投资者认购起始日
    ,o.f_issue_oef_dnddateinst -- 机构投资者认购终止日
    ,o.f_info_parvalue -- 面值
    ,o.f_info_trusttype -- 信托类别
    ,o.f_info_trustee -- 受托人
    ,o.f_pchredm_pchstartdate -- 日常申购起始日
    ,o.f_info_redmstartdate -- 日常赎回起始日
    ,o.f_info_minbuyamount -- 起点金额
    ,o.f_info_expectedrateofreturn -- 预期收益率
    ,o.f_info_issuingplace -- 发行地
    ,o.f_info_benchmark -- 业绩比较基准
    ,o.f_info_status -- 存续状态
    ,o.f_info_restrictedornot -- 限定类型
    ,o.f_info_structuredornot -- 是否结构化产品
    ,o.f_info_exchmarket -- 交易所
    ,o.f_info_firstinveststyle -- 投资风格
    ,o.f_info_issuedate -- 发行日期
    ,o.f_info_type -- 基金类型
    ,o.f_info_isinitial -- 是否为初始基金
    ,o.f_info_pinyin -- 简称拼音
    ,o.f_info_investscope -- 投资范围
    ,o.f_info_investobject -- 投资目标
    ,o.f_info_investconception -- 投资理念
    ,o.f_info_decision_basis -- 决策依据
    ,o.is_indexfund -- 是否指数基金
    ,o.f_info_delistdate -- 退市日期
    ,o.f_info_corp_fundmanagementid -- 基金管理人ID
    ,o.f_info_custodianbankid -- 托管人id
    ,o.max_num_holder -- 单一投资者持有份额上限(亿份)
    ,o.max_num_coltarget -- 封闭期目标募集数量上限(亿份)
    ,o.investstrategy -- 投资策略
    ,o.risk_return -- 基金风险收益特征
    ,o.f_pchredm_pchminamt -- 每次最低申购金额(场外)(万元)
    ,o.f_pchredm_pchminamt_ex -- 每次最低申购金额(场内) (万元)
    ,o.f_info_listdate -- 上市时间
    ,o.f_info_anndate -- 公告日期
    ,o.f_closed_operation_period -- 封闭运作期
    ,o.f_closed_operation_interval -- 封闭运作期满开放日间隔
    ,o.f_info_registrant -- 基金注册与过户登记人ID
    ,o.f_personal_startdateind -- 个人投资者认购起始日
    ,o.f_personal_enddateind -- 个人投资者认购终止日
    ,o.f_info_fund_id -- 基金品种ID
    ,o.f_personal_subtype -- 个人投资者认购方式
    ,o.close_institu_subtype -- 封闭期机构投资者认购方式
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_chinamutualfunddescription_bk o
    left join ${iol_schema}.wind_chinamutualfunddescription_op n
        on
            o.f_info_windcode = n.f_info_windcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wind_chinamutualfunddescription;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('wind_chinamutualfunddescription') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.wind_chinamutualfunddescription drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.wind_chinamutualfunddescription add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.wind_chinamutualfunddescription exchange partition p_${batch_date} with table ${iol_schema}.wind_chinamutualfunddescription_cl;
alter table ${iol_schema}.wind_chinamutualfunddescription exchange partition p_20991231 with table ${iol_schema}.wind_chinamutualfunddescription_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_chinamutualfunddescription to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_chinamutualfunddescription_op purge;
drop table ${iol_schema}.wind_chinamutualfunddescription_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_chinamutualfunddescription_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_chinamutualfunddescription',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
