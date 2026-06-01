/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_pa_fin_product
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_pa_fin_product
whenever sqlerror continue none;
drop table ${iol_schema}.fams_pa_fin_product purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_pa_fin_product(
    finprod_id varchar2(50) -- 金融产品代码
    ,deal_mode varchar2(50) -- 处理模式，“普通”、“滚动”、“日添利”、“智能日添利”等
    ,asset_source varchar2(50) -- 资产来源，行内、行外
    ,asset_provider varchar2(1000) -- 资产提供行，多选，逗号分隔
    ,cash_out_no varchar2(32) -- cms出账编号
    ,asset_source_unit varchar2(50) -- 资产来源条线
    ,load_bank varchar2(32) -- 放款分行
    ,settle_days number(10) -- 清算时效（工作日）
    ,proj_invest_industry varchar2(50) -- 项目投向行业
    ,proj_invest_industry2 varchar2(50) -- 项目投向行业二级分类
    ,bank_trust_code varchar2(300) -- 人行信托代码
    ,actual_credit_provid varchar2(300) -- 实际授信主体
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,investment_attributes varchar2(32) -- 
    ,prod_series varchar2(50) -- 产品系列
    ,prod_class varchar2(50) -- 产品分类
    ,prod_feature varchar2(50) -- 产品特点
    ,exclusive_prod varchar2(50) -- 专属产品
    ,prod_manager varchar2(50) -- 产品经理
    ,sale_type varchar2(50) -- 销售类型
    ,same_org varchar2(50) -- 同业机构
    ,investment_cycle varchar2(50) -- 投资周期 单位：天
    ,target_customer_1 varchar2(50) -- 目标客户一级分类
    ,target_customer_2 varchar2(50) -- 目标客户二级分类
    ,asset_credit_name varchar2(50) -- 资产授信名称
    ,is_interest varchar2(50) -- 股息是否累计
    ,legal_mdate date -- 法定到期日
    ,is_outs varchar2(1) -- 是否委外
    ,series_name varchar2(50) -- 系列名称
    ,asset_class varchar2(50) -- 资产分类
    ,actual_manager varchar2(50) -- 实际管理人
    ,bank_invest_code varchar2(50) -- 人行投向产品代码
    ,rep_plan_prop varchar2(50) -- 资管计划属性
    ,int_type varchar2(50) -- 利率类型，存款类前台只支持固定利率，新增字段记录浮动利率资产
    ,data_source varchar2(2) -- 数据来源
    ,trial_no varchar2(50) -- 法审编号
    ,base_rule varchar2(1000) -- 业绩基准
    ,overallocation varchar2(1000) -- 超额分成方式
    ,vat_tax_rate number(30,14) -- 增值税税率
    ,adt_tax_rate number(30,14) -- 附加税税率
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_pa_fin_product to ${iml_schema};
grant select on ${iol_schema}.fams_pa_fin_product to ${icl_schema};
grant select on ${iol_schema}.fams_pa_fin_product to ${idl_schema};
grant select on ${iol_schema}.fams_pa_fin_product to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_pa_fin_product is '标的类金融产品扩展表';
comment on column ${iol_schema}.fams_pa_fin_product.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_pa_fin_product.deal_mode is '处理模式，“普通”、“滚动”、“日添利”、“智能日添利”等';
comment on column ${iol_schema}.fams_pa_fin_product.asset_source is '资产来源，行内、行外';
comment on column ${iol_schema}.fams_pa_fin_product.asset_provider is '资产提供行，多选，逗号分隔';
comment on column ${iol_schema}.fams_pa_fin_product.cash_out_no is 'cms出账编号';
comment on column ${iol_schema}.fams_pa_fin_product.asset_source_unit is '资产来源条线';
comment on column ${iol_schema}.fams_pa_fin_product.load_bank is '放款分行';
comment on column ${iol_schema}.fams_pa_fin_product.settle_days is '清算时效（工作日）';
comment on column ${iol_schema}.fams_pa_fin_product.proj_invest_industry is '项目投向行业';
comment on column ${iol_schema}.fams_pa_fin_product.proj_invest_industry2 is '项目投向行业二级分类';
comment on column ${iol_schema}.fams_pa_fin_product.bank_trust_code is '人行信托代码';
comment on column ${iol_schema}.fams_pa_fin_product.actual_credit_provid is '实际授信主体';
comment on column ${iol_schema}.fams_pa_fin_product.create_user is '创建人';
comment on column ${iol_schema}.fams_pa_fin_product.create_dept is '创建部门';
comment on column ${iol_schema}.fams_pa_fin_product.create_time is '创建时间';
comment on column ${iol_schema}.fams_pa_fin_product.update_user is '更新人';
comment on column ${iol_schema}.fams_pa_fin_product.update_time is '更新时间';
comment on column ${iol_schema}.fams_pa_fin_product.investment_attributes is '';
comment on column ${iol_schema}.fams_pa_fin_product.prod_series is '产品系列';
comment on column ${iol_schema}.fams_pa_fin_product.prod_class is '产品分类';
comment on column ${iol_schema}.fams_pa_fin_product.prod_feature is '产品特点';
comment on column ${iol_schema}.fams_pa_fin_product.exclusive_prod is '专属产品';
comment on column ${iol_schema}.fams_pa_fin_product.prod_manager is '产品经理';
comment on column ${iol_schema}.fams_pa_fin_product.sale_type is '销售类型';
comment on column ${iol_schema}.fams_pa_fin_product.same_org is '同业机构';
comment on column ${iol_schema}.fams_pa_fin_product.investment_cycle is '投资周期 单位：天';
comment on column ${iol_schema}.fams_pa_fin_product.target_customer_1 is '目标客户一级分类';
comment on column ${iol_schema}.fams_pa_fin_product.target_customer_2 is '目标客户二级分类';
comment on column ${iol_schema}.fams_pa_fin_product.asset_credit_name is '资产授信名称';
comment on column ${iol_schema}.fams_pa_fin_product.is_interest is '股息是否累计';
comment on column ${iol_schema}.fams_pa_fin_product.legal_mdate is '法定到期日';
comment on column ${iol_schema}.fams_pa_fin_product.is_outs is '是否委外';
comment on column ${iol_schema}.fams_pa_fin_product.series_name is '系列名称';
comment on column ${iol_schema}.fams_pa_fin_product.asset_class is '资产分类';
comment on column ${iol_schema}.fams_pa_fin_product.actual_manager is '实际管理人';
comment on column ${iol_schema}.fams_pa_fin_product.bank_invest_code is '人行投向产品代码';
comment on column ${iol_schema}.fams_pa_fin_product.rep_plan_prop is '资管计划属性';
comment on column ${iol_schema}.fams_pa_fin_product.int_type is '利率类型，存款类前台只支持固定利率，新增字段记录浮动利率资产';
comment on column ${iol_schema}.fams_pa_fin_product.data_source is '数据来源';
comment on column ${iol_schema}.fams_pa_fin_product.trial_no is '法审编号';
comment on column ${iol_schema}.fams_pa_fin_product.base_rule is '业绩基准';
comment on column ${iol_schema}.fams_pa_fin_product.overallocation is '超额分成方式';
comment on column ${iol_schema}.fams_pa_fin_product.vat_tax_rate is '增值税税率';
comment on column ${iol_schema}.fams_pa_fin_product.adt_tax_rate is '附加税税率';
comment on column ${iol_schema}.fams_pa_fin_product.start_dt is '开始时间';
comment on column ${iol_schema}.fams_pa_fin_product.end_dt is '结束时间';
comment on column ${iol_schema}.fams_pa_fin_product.id_mark is '增删标志';
comment on column ${iol_schema}.fams_pa_fin_product.etl_timestamp is 'ETL处理时间戳';
