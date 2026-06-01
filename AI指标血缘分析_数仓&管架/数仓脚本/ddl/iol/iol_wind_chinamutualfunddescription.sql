/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_chinamutualfunddescription
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_chinamutualfunddescription
whenever sqlerror continue none;
drop table ${iol_schema}.wind_chinamutualfunddescription purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_chinamutualfunddescription(
    object_id varchar2(150) -- 对象ID
    ,f_info_windcode varchar2(60) -- Wind代码
    ,f_info_front_code varchar2(60) -- 前端代码
    ,f_info_backend_code varchar2(60) -- 后端代码
    ,f_info_fullname varchar2(300) -- 名称
    ,f_info_name varchar2(150) -- 简称
    ,f_info_corp_fundmanagementcomp varchar2(150) -- 管理人
    ,f_info_custodianbank varchar2(150) -- 托管人
    ,f_info_firstinvesttype varchar2(150) -- 投资类型
    ,f_info_setupdate varchar2(12) -- 成立日期
    ,f_info_maturitydate varchar2(12) -- 到期日期
    ,f_issue_totalunit number(26,10) -- 发行份额
    ,f_info_managementfeeratio number(20,4) -- 管理费
    ,f_info_custodianfeeratio number(20,4) -- 托管费
    ,crny_code varchar2(15) -- 货币代码
    ,f_info_ptmyear number(20,4) -- 存续期
    ,f_issue_oef_startdateinst varchar2(12) -- 机构投资者认购起始日
    ,f_issue_oef_dnddateinst varchar2(12) -- 机构投资者认购终止日
    ,f_info_parvalue number(20,4) -- 面值
    ,f_info_trusttype varchar2(60) -- 信托类别
    ,f_info_trustee varchar2(150) -- 受托人
    ,f_pchredm_pchstartdate varchar2(12) -- 日常申购起始日
    ,f_info_redmstartdate varchar2(12) -- 日常赎回起始日
    ,f_info_minbuyamount number(20,4) -- 起点金额
    ,f_info_expectedrateofreturn number(20,4) -- 预期收益率
    ,f_info_issuingplace varchar2(150) -- 发行地
    ,f_info_benchmark varchar2(750) -- 业绩比较基准
    ,f_info_status number(9,0) -- 存续状态
    ,f_info_restrictedornot varchar2(30) -- 限定类型
    ,f_info_structuredornot number(1,0) -- 是否结构化产品
    ,f_info_exchmarket varchar2(15) -- 交易所
    ,f_info_firstinveststyle varchar2(30) -- 投资风格
    ,f_info_issuedate varchar2(12) -- 发行日期
    ,f_info_type varchar2(30) -- 基金类型
    ,f_info_isinitial number(5,0) -- 是否为初始基金
    ,f_info_pinyin varchar2(60) -- 简称拼音
    ,f_info_investscope varchar2(4000) -- 投资范围
    ,f_info_investobject varchar2(1500) -- 投资目标
    ,f_info_investconception varchar2(3000) -- 投资理念
    ,f_info_decision_basis varchar2(3000) -- 决策依据
    ,is_indexfund number(5,0) -- 是否指数基金
    ,f_info_delistdate varchar2(12) -- 退市日期
    ,f_info_corp_fundmanagementid varchar2(15) -- 基金管理人ID
    ,f_info_custodianbankid varchar2(60) -- 托管人id
    ,max_num_holder number(20,4) -- 单一投资者持有份额上限(亿份)
    ,max_num_coltarget number(20,4) -- 封闭期目标募集数量上限(亿份)
    ,investstrategy varchar2(4000) -- 投资策略
    ,risk_return varchar2(4000) -- 基金风险收益特征
    ,f_pchredm_pchminamt number(20,4) -- 每次最低申购金额(场外)(万元)
    ,f_pchredm_pchminamt_ex number(20,4) -- 每次最低申购金额(场内) (万元)
    ,f_info_listdate varchar2(12) -- 上市时间
    ,f_info_anndate varchar2(12) -- 公告日期
    ,f_closed_operation_period number(20,4) -- 封闭运作期
    ,f_closed_operation_interval number(20,4) -- 封闭运作期满开放日间隔
    ,f_info_registrant varchar2(15) -- 基金注册与过户登记人ID
    ,f_personal_startdateind varchar2(12) -- 个人投资者认购起始日
    ,f_personal_enddateind varchar2(12) -- 个人投资者认购终止日
    ,f_info_fund_id varchar2(150) -- 基金品种ID
    ,f_personal_subtype varchar2(150) -- 个人投资者认购方式
    ,close_institu_subtype varchar2(150) -- 封闭期机构投资者认购方式
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.wind_chinamutualfunddescription to ${iml_schema};
grant select on ${iol_schema}.wind_chinamutualfunddescription to ${icl_schema};
grant select on ${iol_schema}.wind_chinamutualfunddescription to ${idl_schema};
grant select on ${iol_schema}.wind_chinamutualfunddescription to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_chinamutualfunddescription is '中国共同基金基本资料';
comment on column ${iol_schema}.wind_chinamutualfunddescription.object_id is '对象ID';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_front_code is '前端代码';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_backend_code is '后端代码';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_fullname is '名称';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_name is '简称';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_corp_fundmanagementcomp is '管理人';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_custodianbank is '托管人';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_firstinvesttype is '投资类型';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_setupdate is '成立日期';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_maturitydate is '到期日期';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_issue_totalunit is '发行份额';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_managementfeeratio is '管理费';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_custodianfeeratio is '托管费';
comment on column ${iol_schema}.wind_chinamutualfunddescription.crny_code is '货币代码';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_ptmyear is '存续期';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_issue_oef_startdateinst is '机构投资者认购起始日';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_issue_oef_dnddateinst is '机构投资者认购终止日';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_parvalue is '面值';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_trusttype is '信托类别';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_trustee is '受托人';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_pchredm_pchstartdate is '日常申购起始日';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_redmstartdate is '日常赎回起始日';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_minbuyamount is '起点金额';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_expectedrateofreturn is '预期收益率';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_issuingplace is '发行地';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_benchmark is '业绩比较基准';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_status is '存续状态';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_restrictedornot is '限定类型';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_structuredornot is '是否结构化产品';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_exchmarket is '交易所';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_firstinveststyle is '投资风格';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_issuedate is '发行日期';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_type is '基金类型';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_isinitial is '是否为初始基金';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_pinyin is '简称拼音';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_investscope is '投资范围';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_investobject is '投资目标';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_investconception is '投资理念';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_decision_basis is '决策依据';
comment on column ${iol_schema}.wind_chinamutualfunddescription.is_indexfund is '是否指数基金';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_delistdate is '退市日期';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_corp_fundmanagementid is '基金管理人ID';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_custodianbankid is '托管人id';
comment on column ${iol_schema}.wind_chinamutualfunddescription.max_num_holder is '单一投资者持有份额上限(亿份)';
comment on column ${iol_schema}.wind_chinamutualfunddescription.max_num_coltarget is '封闭期目标募集数量上限(亿份)';
comment on column ${iol_schema}.wind_chinamutualfunddescription.investstrategy is '投资策略';
comment on column ${iol_schema}.wind_chinamutualfunddescription.risk_return is '基金风险收益特征';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_pchredm_pchminamt is '每次最低申购金额(场外)(万元)';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_pchredm_pchminamt_ex is '每次最低申购金额(场内) (万元)';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_listdate is '上市时间';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_anndate is '公告日期';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_closed_operation_period is '封闭运作期';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_closed_operation_interval is '封闭运作期满开放日间隔';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_registrant is '基金注册与过户登记人ID';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_personal_startdateind is '个人投资者认购起始日';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_personal_enddateind is '个人投资者认购终止日';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_info_fund_id is '基金品种ID';
comment on column ${iol_schema}.wind_chinamutualfunddescription.f_personal_subtype is '个人投资者认购方式';
comment on column ${iol_schema}.wind_chinamutualfunddescription.close_institu_subtype is '封闭期机构投资者认购方式';
comment on column ${iol_schema}.wind_chinamutualfunddescription.start_dt is '开始时间';
comment on column ${iol_schema}.wind_chinamutualfunddescription.end_dt is '结束时间';
comment on column ${iol_schema}.wind_chinamutualfunddescription.id_mark is '增删标志';
comment on column ${iol_schema}.wind_chinamutualfunddescription.etl_timestamp is 'ETL处理时间戳';
