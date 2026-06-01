/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol hgls_product_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.hgls_product_info
whenever sqlerror continue none;
drop table ${iol_schema}.hgls_product_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_product_info(
    prd_id number(22,0) -- 产品ID:主键
    ,code varchar2(4000) -- 产品编码
    ,prd_name varchar2(4000) -- 产品名
    ,prd_type number(22,0) -- 产品类型:1.网贷,2.经营贷
    ,loan_apply_type varchar2(4000) -- 贷款类型
    ,prd_status number(22,0) -- 发布状态:1.未发布,2.已发布
    ,tpl_code varchar2(4000) -- 模板CODE
    ,loan_limit number(38,8) -- 贷款额度(单位:万元):0.000-9999.999
    ,loan_rate number(38,8) -- 贷款日利率(单位:‱):0.9999~0.0001，无锡改版，允许为空
    ,loan_months varchar2(4000) -- 最长用信周期
    ,loan_auth_days varchar2(4000) -- 最长授信周期
    ,repayment_kind varchar2(4000) -- 还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款 以,分隔每个值
    ,interest_type number(22,0) -- 计息方式:1.按月,2.按天
    ,auth_type varchar2(4000) -- 授信方式 以,分隔每个值
    ,cities_id varchar2(4000) -- 发放城市列表,以,分隔每个城市的值
    ,loan_type varchar2(4000) -- 放款方式,长度256
    ,req_condition varchar2(4000) -- 申请资格,长度256
    ,audience varchar2(4000) -- 适用人群,长度256
    ,approve_num number(22,0) -- 审批人数
    ,examine_num number(22,0) -- 审查人数
    ,customer_industry varchar2(4000) -- 受众行业 以,分隔每个值
    ,prd_ad varchar2(4000) -- 广告语,长度50
    ,prd_describe varchar2(4000) -- 产品描述，长度500
    ,age_limit number(22,0) -- 最小年龄(单位:岁):0~200
    ,age_max number(22,0) -- 最大年龄(单位:岁):0~200
    ,enterprise_code varchar2(4000) -- 企业编码
    ,edited_index number(22,0) -- 步骤
    ,create_user number(22,0) -- 创建人ID
    ,credit_on number(22,0) -- 预授信模式:0.关闭,１.开启
    ,tpl_default number(22,0) -- 启用默认模板:0.否,１.是
    ,isfixed_rate number(22,0) -- 是否固定利率，0否1是
    ,create_date timestamp -- 申请日期
    ,update_date timestamp -- 更新时间
    ,isdel number(22,0) -- 删除标识:0.未删除,1.已删除
    ,year_rate number(38,8) -- 贷款年利率(单位:%)
    ,order_index number(22,0) -- 产品列表排序字段，默认0
    ,year_rate_max number(38,8) -- 最高年利率(单位:%)
    ,org_num varchar2(4000) -- 机构编码 以,分割每个值
    ,prd_num varchar2(4000) -- 产品编号
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
grant select on ${iol_schema}.hgls_product_info to ${iml_schema};
grant select on ${iol_schema}.hgls_product_info to ${icl_schema};
grant select on ${iol_schema}.hgls_product_info to ${idl_schema};
grant select on ${iol_schema}.hgls_product_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.hgls_product_info is '产品主表';
comment on column ${iol_schema}.hgls_product_info.prd_id is '产品ID:主键';
comment on column ${iol_schema}.hgls_product_info.code is '产品编码';
comment on column ${iol_schema}.hgls_product_info.prd_name is '产品名';
comment on column ${iol_schema}.hgls_product_info.prd_type is '产品类型:1.网贷,2.经营贷';
comment on column ${iol_schema}.hgls_product_info.loan_apply_type is '贷款类型';
comment on column ${iol_schema}.hgls_product_info.prd_status is '发布状态:1.未发布,2.已发布';
comment on column ${iol_schema}.hgls_product_info.tpl_code is '模板CODE';
comment on column ${iol_schema}.hgls_product_info.loan_limit is '贷款额度(单位:万元):0.000-9999.999';
comment on column ${iol_schema}.hgls_product_info.loan_rate is '贷款日利率(单位:‱):0.9999~0.0001，无锡改版，允许为空';
comment on column ${iol_schema}.hgls_product_info.loan_months is '最长用信周期';
comment on column ${iol_schema}.hgls_product_info.loan_auth_days is '最长授信周期';
comment on column ${iol_schema}.hgls_product_info.repayment_kind is '还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款 以,分隔每个值';
comment on column ${iol_schema}.hgls_product_info.interest_type is '计息方式:1.按月,2.按天';
comment on column ${iol_schema}.hgls_product_info.auth_type is '授信方式 以,分隔每个值';
comment on column ${iol_schema}.hgls_product_info.cities_id is '发放城市列表,以,分隔每个城市的值';
comment on column ${iol_schema}.hgls_product_info.loan_type is '放款方式,长度256';
comment on column ${iol_schema}.hgls_product_info.req_condition is '申请资格,长度256';
comment on column ${iol_schema}.hgls_product_info.audience is '适用人群,长度256';
comment on column ${iol_schema}.hgls_product_info.approve_num is '审批人数';
comment on column ${iol_schema}.hgls_product_info.examine_num is '审查人数';
comment on column ${iol_schema}.hgls_product_info.customer_industry is '受众行业 以,分隔每个值';
comment on column ${iol_schema}.hgls_product_info.prd_ad is '广告语,长度50';
comment on column ${iol_schema}.hgls_product_info.prd_describe is '产品描述，长度500';
comment on column ${iol_schema}.hgls_product_info.age_limit is '最小年龄(单位:岁):0~200';
comment on column ${iol_schema}.hgls_product_info.age_max is '最大年龄(单位:岁):0~200';
comment on column ${iol_schema}.hgls_product_info.enterprise_code is '企业编码';
comment on column ${iol_schema}.hgls_product_info.edited_index is '步骤';
comment on column ${iol_schema}.hgls_product_info.create_user is '创建人ID';
comment on column ${iol_schema}.hgls_product_info.credit_on is '预授信模式:0.关闭,１.开启';
comment on column ${iol_schema}.hgls_product_info.tpl_default is '启用默认模板:0.否,１.是';
comment on column ${iol_schema}.hgls_product_info.isfixed_rate is '是否固定利率，0否1是';
comment on column ${iol_schema}.hgls_product_info.create_date is '申请日期';
comment on column ${iol_schema}.hgls_product_info.update_date is '更新时间';
comment on column ${iol_schema}.hgls_product_info.isdel is '删除标识:0.未删除,1.已删除';
comment on column ${iol_schema}.hgls_product_info.year_rate is '贷款年利率(单位:%)';
comment on column ${iol_schema}.hgls_product_info.order_index is '产品列表排序字段，默认0';
comment on column ${iol_schema}.hgls_product_info.year_rate_max is '最高年利率(单位:%)';
comment on column ${iol_schema}.hgls_product_info.org_num is '机构编码 以,分割每个值';
comment on column ${iol_schema}.hgls_product_info.prd_num is '产品编号';
comment on column ${iol_schema}.hgls_product_info.start_dt is '开始时间';
comment on column ${iol_schema}.hgls_product_info.end_dt is '结束时间';
comment on column ${iol_schema}.hgls_product_info.id_mark is '增删标志';
comment on column ${iol_schema}.hgls_product_info.etl_timestamp is 'ETL处理时间戳';
