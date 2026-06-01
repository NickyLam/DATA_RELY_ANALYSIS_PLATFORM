/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_und_asset
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_und_asset
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_und_asset purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_und_asset(
    id varchar2(75) -- 内部资产编号
    ,parent_id varchar2(75) -- 上层资产编号
    ,i_code varchar2(75) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,u_i_code varchar2(75) -- 资产代码
    ,u_i_name varchar2(338) -- 资产名称
    ,a_class varchar2(15) -- 资产分类
    ,a_class_min varchar2(30) -- 资产小类
    ,amount number(31,4) -- 投资金额(元)
    ,inv_date varchar2(15) -- 投资日期
    ,start_date varchar2(15) -- 起息日
    ,mtr_date varchar2(15) -- 到期日
    ,coupon number(12,6) -- 利率
    ,payment_freq varchar2(9) -- 付息频率
    ,first_payment_date varchar2(15) -- 首次付息日
    ,currency varchar2(5) -- 币种
    ,update_time varchar2(29) -- 更新时间
    ,update_user varchar2(75) -- 更新人
    ,imp_date varchar2(15) -- 导入日期
    ,party_id number(19,0) -- 交易对手
    ,und_status varchar2(3) -- 底层资产状态，0-新建，1-已生效，2-失效
    ,is_using_credit varchar2(3) -- 是否占用授信，0-不占用，1-占用
    ,credit_status varchar2(3) -- 授信状态，0-未占用，1-已占用
    ,credit_party_id number(22) -- 授信主体
    ,credit_weight number(6,4) -- 授信权重
    ,credit_amount number(31,4) -- 授信金额
    ,account_user varchar2(45) -- 复核人
    ,account_time varchar2(30) -- 复核时间
    ,account_date varchar2(15) -- 复核日期
    ,deprecate_user varchar2(45) -- 作废人
    ,deprecate_date varchar2(15) -- 作废日期
    ,update_date varchar2(15) -- 更新日期
    ,prop number(6,4) -- 投资比例
    ,risk_weight number(6,4) -- 风险权重
    ,risk_asset_id varchar2(30) -- 风险资产分类，对应ttrd_project_risk_weight表中的project_value
    ,category varchar2(45) -- 行业分类
    ,volume number(31,4) -- 投资份额
    ,belong_toarea varchar2(45) -- 省份
    ,belong_tocity varchar2(45) -- 城市id
    ,belong_tocityname varchar2(45) -- 城市名称
    ,grade varchar2(15) -- 评级，对应字典undassetgrade
    ,grade_insti number(19,0) -- 评级机构
    ,final_invest varchar2(15) -- 最终投向类型，对应字典undassetfinalinvest
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
grant select on ${iol_schema}.ibms_ttrd_und_asset to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_und_asset to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_und_asset to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_und_asset to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_und_asset is '底层资产表';
comment on column ${iol_schema}.ibms_ttrd_und_asset.id is '内部资产编号';
comment on column ${iol_schema}.ibms_ttrd_und_asset.parent_id is '上层资产编号';
comment on column ${iol_schema}.ibms_ttrd_und_asset.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_und_asset.a_type is '资产类型';
comment on column ${iol_schema}.ibms_ttrd_und_asset.m_type is '市场类型';
comment on column ${iol_schema}.ibms_ttrd_und_asset.u_i_code is '资产代码';
comment on column ${iol_schema}.ibms_ttrd_und_asset.u_i_name is '资产名称';
comment on column ${iol_schema}.ibms_ttrd_und_asset.a_class is '资产分类';
comment on column ${iol_schema}.ibms_ttrd_und_asset.a_class_min is '资产小类';
comment on column ${iol_schema}.ibms_ttrd_und_asset.amount is '投资金额(元)';
comment on column ${iol_schema}.ibms_ttrd_und_asset.inv_date is '投资日期';
comment on column ${iol_schema}.ibms_ttrd_und_asset.start_date is '起息日';
comment on column ${iol_schema}.ibms_ttrd_und_asset.mtr_date is '到期日';
comment on column ${iol_schema}.ibms_ttrd_und_asset.coupon is '利率';
comment on column ${iol_schema}.ibms_ttrd_und_asset.payment_freq is '付息频率';
comment on column ${iol_schema}.ibms_ttrd_und_asset.first_payment_date is '首次付息日';
comment on column ${iol_schema}.ibms_ttrd_und_asset.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_und_asset.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_und_asset.update_user is '更新人';
comment on column ${iol_schema}.ibms_ttrd_und_asset.imp_date is '导入日期';
comment on column ${iol_schema}.ibms_ttrd_und_asset.party_id is '交易对手';
comment on column ${iol_schema}.ibms_ttrd_und_asset.und_status is '底层资产状态，0-新建，1-已生效，2-失效';
comment on column ${iol_schema}.ibms_ttrd_und_asset.is_using_credit is '是否占用授信，0-不占用，1-占用';
comment on column ${iol_schema}.ibms_ttrd_und_asset.credit_status is '授信状态，0-未占用，1-已占用';
comment on column ${iol_schema}.ibms_ttrd_und_asset.credit_party_id is '授信主体';
comment on column ${iol_schema}.ibms_ttrd_und_asset.credit_weight is '授信权重';
comment on column ${iol_schema}.ibms_ttrd_und_asset.credit_amount is '授信金额';
comment on column ${iol_schema}.ibms_ttrd_und_asset.account_user is '复核人';
comment on column ${iol_schema}.ibms_ttrd_und_asset.account_time is '复核时间';
comment on column ${iol_schema}.ibms_ttrd_und_asset.account_date is '复核日期';
comment on column ${iol_schema}.ibms_ttrd_und_asset.deprecate_user is '作废人';
comment on column ${iol_schema}.ibms_ttrd_und_asset.deprecate_date is '作废日期';
comment on column ${iol_schema}.ibms_ttrd_und_asset.update_date is '更新日期';
comment on column ${iol_schema}.ibms_ttrd_und_asset.prop is '投资比例';
comment on column ${iol_schema}.ibms_ttrd_und_asset.risk_weight is '风险权重';
comment on column ${iol_schema}.ibms_ttrd_und_asset.risk_asset_id is '风险资产分类，对应ttrd_project_risk_weight表中的project_value';
comment on column ${iol_schema}.ibms_ttrd_und_asset.category is '行业分类';
comment on column ${iol_schema}.ibms_ttrd_und_asset.volume is '投资份额';
comment on column ${iol_schema}.ibms_ttrd_und_asset.belong_toarea is '省份';
comment on column ${iol_schema}.ibms_ttrd_und_asset.belong_tocity is '城市id';
comment on column ${iol_schema}.ibms_ttrd_und_asset.belong_tocityname is '城市名称';
comment on column ${iol_schema}.ibms_ttrd_und_asset.grade is '评级，对应字典undassetgrade';
comment on column ${iol_schema}.ibms_ttrd_und_asset.grade_insti is '评级机构';
comment on column ${iol_schema}.ibms_ttrd_und_asset.final_invest is '最终投向类型，对应字典undassetfinalinvest';
comment on column ${iol_schema}.ibms_ttrd_und_asset.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_und_asset.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_und_asset.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_und_asset.etl_timestamp is 'ETL处理时间戳';
