/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl hgls_loan_req_audit
CreateDate: 20250516
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.hgls_loan_req_audit purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.hgls_loan_req_audit(
etl_dt date --数据日期
,audit_id number(22) --主键id
,loan_id number(22) --进件id
,approver_user_id number(22) --审批人id
,approver_user_name varchar2(4000) --审批人名字
,daily_rate number(38,8) --日利率（百分之一）
,fnl_store number(38,8) --综合授信评分
,repayment_period varchar2(4000) --最高返款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期
,repayment_kind varchar2(4000) --还款方式
,auth_money number(38,8) --授信金额
,rank varchar2(4000) --评级（a-f）
,audit_status varchar2(4000) --audit_status
,history_audit_status number(22) --是否历史审批0否，1是
,repulse_reason varchar2(4000) --审批打回原因
,audit_date timestamp(6) --申请日期
,need_escort number(22) --是否需要陪调客户经理
,credit_guaranty number(22) --是否需要担保人
,inquiry_way varchar2(4000) --调查方式；1，简单，2，一般，3，复杂
,credit_company number(22) --是否需要上传征信
,pledge_type varchar2(4000) --抵押分类
,assess_price number(38,8) --评估价格
,year_rate number(38,8) --年利率
,resolution varchar2(4000) --信息复合会办决议
,remark varchar2(4000) --会办决议备注
,custom_capital varchar2(4000) --是否自定义本金
,allow_one_sign number(22) --是否允许单签
,loan_proof varchar2(4000) --放款凭证
,mark varchar2(3000) --模型标记信息
,biz_type number(22) --业务类型，0主借人1配偶
,model_frequency number(22) --监测周期

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.hgls_loan_req_audit to ${iel_schema};

-- comment
comment on table ${idl_schema}.hgls_loan_req_audit is '进件审批表';
comment on column ${idl_schema}.hgls_loan_req_audit.etl_dt is '数据日期';
comment on column ${idl_schema}.hgls_loan_req_audit.audit_id is '主键id';
comment on column ${idl_schema}.hgls_loan_req_audit.loan_id is '进件id';
comment on column ${idl_schema}.hgls_loan_req_audit.approver_user_id is '审批人id';
comment on column ${idl_schema}.hgls_loan_req_audit.approver_user_name is '审批人名字';
comment on column ${idl_schema}.hgls_loan_req_audit.daily_rate is '日利率（百分之一）';
comment on column ${idl_schema}.hgls_loan_req_audit.fnl_store is '综合授信评分';
comment on column ${idl_schema}.hgls_loan_req_audit.repayment_period is '最高返款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期';
comment on column ${idl_schema}.hgls_loan_req_audit.repayment_kind is '还款方式';
comment on column ${idl_schema}.hgls_loan_req_audit.auth_money is '授信金额';
comment on column ${idl_schema}.hgls_loan_req_audit.rank is '评级（a-f）';
comment on column ${idl_schema}.hgls_loan_req_audit.audit_status is 'audit_status';
comment on column ${idl_schema}.hgls_loan_req_audit.history_audit_status is '是否历史审批0否，1是';
comment on column ${idl_schema}.hgls_loan_req_audit.repulse_reason is '审批打回原因';
comment on column ${idl_schema}.hgls_loan_req_audit.audit_date is '申请日期';
comment on column ${idl_schema}.hgls_loan_req_audit.need_escort is '是否需要陪调客户经理';
comment on column ${idl_schema}.hgls_loan_req_audit.credit_guaranty is '是否需要担保人';
comment on column ${idl_schema}.hgls_loan_req_audit.inquiry_way is '调查方式；1，简单，2，一般，3，复杂';
comment on column ${idl_schema}.hgls_loan_req_audit.credit_company is '是否需要上传征信';
comment on column ${idl_schema}.hgls_loan_req_audit.pledge_type is '抵押分类';
comment on column ${idl_schema}.hgls_loan_req_audit.assess_price is '评估价格';
comment on column ${idl_schema}.hgls_loan_req_audit.year_rate is '年利率';
comment on column ${idl_schema}.hgls_loan_req_audit.resolution is '信息复合会办决议';
comment on column ${idl_schema}.hgls_loan_req_audit.remark is '会办决议备注';
comment on column ${idl_schema}.hgls_loan_req_audit.custom_capital is '是否自定义本金';
comment on column ${idl_schema}.hgls_loan_req_audit.allow_one_sign is '是否允许单签';
comment on column ${idl_schema}.hgls_loan_req_audit.loan_proof is '放款凭证';
comment on column ${idl_schema}.hgls_loan_req_audit.mark is '模型标记信息';
comment on column ${idl_schema}.hgls_loan_req_audit.biz_type is '业务类型，0主借人1配偶';
comment on column ${idl_schema}.hgls_loan_req_audit.model_frequency is '监测周期';

