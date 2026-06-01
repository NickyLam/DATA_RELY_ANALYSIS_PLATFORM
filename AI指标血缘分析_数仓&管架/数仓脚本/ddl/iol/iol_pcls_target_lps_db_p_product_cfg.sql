/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pcls_target_lps_db_p_product_cfg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pcls_target_lps_db_p_product_cfg
whenever sqlerror continue none;
drop table ${iol_schema}.pcls_target_lps_db_p_product_cfg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pcls_target_lps_db_p_product_cfg(
    id number(22) -- 主键
    ,product_code varchar2(4000) -- 产品编号
    ,product_type varchar2(4000) -- XF-消费贷，JY-经营贷
    ,guarantee_type varchar2(4000) -- 担保方式，1.信用 -CREDIT，2.保证担保 - GUARANTEE，3.抵押担保 -PLEDGE，4.组合担保-COMBINATION
    ,raise_switch varchar2(4000) -- 是否允许提额，Y/N
    ,product_state varchar2(4000) -- 状态，上架-ON，下架-OFF，草稿-DRAFT，模板-TEMP， 删除-DELETED
    ,product_name varchar2(4000) -- 产品名称
    ,male_min_age number(22) -- 男性最小年龄
    ,male_max_age number(22) -- 男性最大年龄
    ,female_min_age number(22) -- 女性最小年龄
    ,female_max_age number(22) -- 女性最大年龄
    ,min_credit_amount number(38,8) -- 营销侧最小授信金额（万）
    ,max_credit_amount number(38,8) -- 营销侧最大授信金额（万）
    ,min_interest_rate number(38,8) -- 营销侧最小年利率（无%）
    ,max_interest_rate number(38,8) -- 营销侧最大年利率（无%）
    ,age_rule varchar2(4000) -- 年龄取值规则
    ,area_type varchar2(4000) -- 展业区域类型
    ,locate_mode varchar2(4000) -- 定位方式
    ,date_effective date -- 生效时间
    ,date_expire date -- 失效时间
    ,main_flag varchar2(4000) -- 主推产品
    ,hide_flag varchar2(4000) -- 是否隐藏
    ,date_created date -- 创建时间
    ,created_by varchar2(4000) -- 创建人
    ,date_updated date -- 修改时间
    ,updated_by varchar2(4000) -- 修改人
    ,extend_data varchar2(4000) -- 
    ,locate_check_rule varchar2(4000) -- 
    ,appl_cancel_switch varchar2(4000) -- 是否支持客户主动取消申请
    ,system_survey_switch varchar2(4000) -- 是否支持 系统触发尽调
    ,cust_identity_config varchar2(4000) -- 客户身份配置
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pcls_target_lps_db_p_product_cfg to ${iml_schema};
grant select on ${iol_schema}.pcls_target_lps_db_p_product_cfg to ${icl_schema};
grant select on ${iol_schema}.pcls_target_lps_db_p_product_cfg to ${idl_schema};
grant select on ${iol_schema}.pcls_target_lps_db_p_product_cfg to ${iel_schema};

-- comment
comment on table ${iol_schema}.pcls_target_lps_db_p_product_cfg is '产品配置表';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.id is '主键';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.product_code is '产品编号';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.product_type is 'XF-消费贷，JY-经营贷';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.guarantee_type is '担保方式，1.信用 -CREDIT，2.保证担保 - GUARANTEE，3.抵押担保 -PLEDGE，4.组合担保-COMBINATION';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.raise_switch is '是否允许提额，Y/N';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.product_state is '状态，上架-ON，下架-OFF，草稿-DRAFT，模板-TEMP， 删除-DELETED';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.product_name is '产品名称';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.male_min_age is '男性最小年龄';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.male_max_age is '男性最大年龄';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.female_min_age is '女性最小年龄';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.female_max_age is '女性最大年龄';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.min_credit_amount is '营销侧最小授信金额（万）';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.max_credit_amount is '营销侧最大授信金额（万）';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.min_interest_rate is '营销侧最小年利率（无%）';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.max_interest_rate is '营销侧最大年利率（无%）';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.age_rule is '年龄取值规则';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.area_type is '展业区域类型';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.locate_mode is '定位方式';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.date_effective is '生效时间';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.date_expire is '失效时间';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.main_flag is '主推产品';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.hide_flag is '是否隐藏';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.date_created is '创建时间';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.created_by is '创建人';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.date_updated is '修改时间';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.updated_by is '修改人';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.extend_data is '';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.locate_check_rule is '';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.appl_cancel_switch is '是否支持客户主动取消申请';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.system_survey_switch is '是否支持 系统触发尽调';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.cust_identity_config is '客户身份配置';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pcls_target_lps_db_p_product_cfg.etl_timestamp is 'ETL处理时间戳';
