/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_equity
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_equity
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_equity purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_equity(
    i_code varchar2(75) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型：净值型项目spt_ntp
    ,m_type varchar2(30) -- 市场类型
    ,l_code varchar2(113) -- 本地代码
    ,i_name varchar2(300) -- 金融工具名称
    ,currency varchar2(5) -- 币种
    ,country varchar2(3) -- 国家
    ,q_type varchar2(3) -- 发行类型：净值型
    ,p_type varchar2(45) -- 产品类型
    ,p_class varchar2(150) -- 产品分类
    ,list_date varchar2(15) -- 上市时间
    ,open_date varchar2(15) -- 开发时间
    ,issuer varchar2(300) -- 发行人
    ,risk_rating number(22,0) -- 风险等级
    ,trustee varchar2(383) -- 托管人
    ,imp_date varchar2(15) -- 导入日期
    ,pipe_id number(22,0) -- 导入方式
    ,chinesespell varchar2(150) -- 拼音简称
    ,update_user varchar2(150) -- 
    ,update_time varchar2(35) -- 
    ,account_user varchar2(45) -- 
    ,account_time varchar2(30) -- 
    ,issuer_id number(22,0) -- 发行机构id
    ,trustee_id number(22,0) -- 托管机构id
    ,usable_flag number(22,0) -- 是否已生效：1： 正常 0： 新增
    ,product_rate varchar2(150) -- 产品评级
    ,rate_institution varchar2(150) -- 评级机构
    ,open_type varchar2(30) -- 每日开放：0,每周开放：1
    ,start_open_date varchar2(30) -- 开放周期开始日
    ,end_open_date varchar2(30) -- 开放周期结束日
    ,guarantee_way varchar2(3) -- 担保方式
    ,guarantee_infor varchar2(450) -- 担保物情况
    ,ctrct_id varchar2(75) -- 合同编号
    ,platform varchar2(3) -- 平台
    ,invest_direction varchar2(750) -- 投向
    ,final_invest varchar2(15) -- 最终投向类型
    ,five_class varchar2(3) -- 五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）
    ,contract_version varchar2(3) -- 合同版本号（已审合同:0,送审合同:1,标准合同:2）
    ,extordid varchar2(75) -- 外部交易号
    ,mitigation_freq varchar2(15) -- 缓释频率
    ,manager_id number(16,0) -- 实际管理人id
    ,manager_value varchar2(383) -- 实际管理人
    ,risk_proportion number(14,6) -- 风险权重占比
    ,middle_classify varchar2(75) -- 业务中类
    ,small_classify varchar2(75) -- 业务小类
    ,closing_start_date varchar2(15) -- 封闭开始日(对应开放类型为封闭型)
    ,closing_end_date varchar2(15) -- 封闭结束日(对应开放类型为封闭型)
    ,curr_open_break_date varchar2(15) -- 本周期开放终止日期
    ,curr_hold_end_date varchar2(15) -- 本周期持有到期日期
    ,update_time2 varchar2(29) -- 更新时间
    ,refer_code varchar2(150) -- 参照代码
    ,is_cash_manage_type varchar2(2) -- 是否现金管理类产品
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
grant select on ${iol_schema}.ibms_ttrd_equity to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_equity to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_equity to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_equity to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_equity is '净值型产品信息表';
comment on column ${iol_schema}.ibms_ttrd_equity.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_equity.a_type is '资产类型：净值型项目spt_ntp';
comment on column ${iol_schema}.ibms_ttrd_equity.m_type is '市场类型';
comment on column ${iol_schema}.ibms_ttrd_equity.l_code is '本地代码';
comment on column ${iol_schema}.ibms_ttrd_equity.i_name is '金融工具名称';
comment on column ${iol_schema}.ibms_ttrd_equity.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_equity.country is '国家';
comment on column ${iol_schema}.ibms_ttrd_equity.q_type is '发行类型：净值型';
comment on column ${iol_schema}.ibms_ttrd_equity.p_type is '产品类型';
comment on column ${iol_schema}.ibms_ttrd_equity.p_class is '产品分类';
comment on column ${iol_schema}.ibms_ttrd_equity.list_date is '上市时间';
comment on column ${iol_schema}.ibms_ttrd_equity.open_date is '开发时间';
comment on column ${iol_schema}.ibms_ttrd_equity.issuer is '发行人';
comment on column ${iol_schema}.ibms_ttrd_equity.risk_rating is '风险等级';
comment on column ${iol_schema}.ibms_ttrd_equity.trustee is '托管人';
comment on column ${iol_schema}.ibms_ttrd_equity.imp_date is '导入日期';
comment on column ${iol_schema}.ibms_ttrd_equity.pipe_id is '导入方式';
comment on column ${iol_schema}.ibms_ttrd_equity.chinesespell is '拼音简称';
comment on column ${iol_schema}.ibms_ttrd_equity.update_user is '';
comment on column ${iol_schema}.ibms_ttrd_equity.update_time is '';
comment on column ${iol_schema}.ibms_ttrd_equity.account_user is '';
comment on column ${iol_schema}.ibms_ttrd_equity.account_time is '';
comment on column ${iol_schema}.ibms_ttrd_equity.issuer_id is '发行机构id';
comment on column ${iol_schema}.ibms_ttrd_equity.trustee_id is '托管机构id';
comment on column ${iol_schema}.ibms_ttrd_equity.usable_flag is '是否已生效：1： 正常 0： 新增';
comment on column ${iol_schema}.ibms_ttrd_equity.product_rate is '产品评级';
comment on column ${iol_schema}.ibms_ttrd_equity.rate_institution is '评级机构';
comment on column ${iol_schema}.ibms_ttrd_equity.open_type is '每日开放：0,每周开放：1';
comment on column ${iol_schema}.ibms_ttrd_equity.start_open_date is '开放周期开始日';
comment on column ${iol_schema}.ibms_ttrd_equity.end_open_date is '开放周期结束日';
comment on column ${iol_schema}.ibms_ttrd_equity.guarantee_way is '担保方式';
comment on column ${iol_schema}.ibms_ttrd_equity.guarantee_infor is '担保物情况';
comment on column ${iol_schema}.ibms_ttrd_equity.ctrct_id is '合同编号';
comment on column ${iol_schema}.ibms_ttrd_equity.platform is '平台';
comment on column ${iol_schema}.ibms_ttrd_equity.invest_direction is '投向';
comment on column ${iol_schema}.ibms_ttrd_equity.final_invest is '最终投向类型';
comment on column ${iol_schema}.ibms_ttrd_equity.five_class is '五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）';
comment on column ${iol_schema}.ibms_ttrd_equity.contract_version is '合同版本号（已审合同:0,送审合同:1,标准合同:2）';
comment on column ${iol_schema}.ibms_ttrd_equity.extordid is '外部交易号';
comment on column ${iol_schema}.ibms_ttrd_equity.mitigation_freq is '缓释频率';
comment on column ${iol_schema}.ibms_ttrd_equity.manager_id is '实际管理人id';
comment on column ${iol_schema}.ibms_ttrd_equity.manager_value is '实际管理人';
comment on column ${iol_schema}.ibms_ttrd_equity.risk_proportion is '风险权重占比';
comment on column ${iol_schema}.ibms_ttrd_equity.middle_classify is '业务中类';
comment on column ${iol_schema}.ibms_ttrd_equity.small_classify is '业务小类';
comment on column ${iol_schema}.ibms_ttrd_equity.closing_start_date is '封闭开始日(对应开放类型为封闭型)';
comment on column ${iol_schema}.ibms_ttrd_equity.closing_end_date is '封闭结束日(对应开放类型为封闭型)';
comment on column ${iol_schema}.ibms_ttrd_equity.curr_open_break_date is '本周期开放终止日期';
comment on column ${iol_schema}.ibms_ttrd_equity.curr_hold_end_date is '本周期持有到期日期';
comment on column ${iol_schema}.ibms_ttrd_equity.update_time2 is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_equity.refer_code is '参照代码';
comment on column ${iol_schema}.ibms_ttrd_equity.is_cash_manage_type is '是否现金管理类产品';
comment on column ${iol_schema}.ibms_ttrd_equity.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_equity.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_equity.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_equity.etl_timestamp is 'ETL处理时间戳';
