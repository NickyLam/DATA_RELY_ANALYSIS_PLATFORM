/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_ft_product_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_ft_product_history
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_ft_product_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_ft_product_history(
    id varchar2(75) -- 主键序号
    ,product_id varchar2(75) -- 主键序号
    ,product_name varchar2(150) -- 产品名称
    ,product_code varchar2(48) -- 产品代码
    ,risk_grade varchar2(5) -- 风险等级 r1:r1低风险  r2:r2中低风险 r3:r3中风险 r4:r4中高风险 r5:r5高风险
    ,performance_status number(20,2) -- 业绩比较基准
    ,establishment_date varchar2(36) -- 成立日
    ,termination_date varchar2(36) -- 终止日
    ,product_status varchar2(5) -- 产品状态 0募集，1成立，2终止
    ,purchase_amount number(20,2) -- 起购金额
    ,commencement_date varchar2(36) -- 募集开始日
    ,closing_date varchar2(36) -- 募集结束日
    ,init_amount number(20,2) -- 初始创立金额
    ,current_net_worth number(20,8) -- 当前净值
    ,current_market_value number(20,8) -- 当前市值
    ,trustcompany_code varchar2(48) -- 信托公司代码
    ,trustcompany_name varchar2(150) -- 信托公司名称
    ,product_sorted varchar2(21) -- 排序字段
    ,product_comment varchar2(3000) -- 备注（修改原因）
    ,created_time date -- 创建时间
    ,submit_time date -- 提交认证时间
    ,audit_time date -- 审核时间
    ,audit_status varchar2(15) -- 审核状态
    ,remark varchar2(900) -- 审核失败原因
    ,audit_by varchar2(15) -- 审核人
    ,history_created_time date -- 归档时间
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
grant select on ${iol_schema}.nfss_ft_product_history to ${iml_schema};
grant select on ${iol_schema}.nfss_ft_product_history to ${icl_schema};
grant select on ${iol_schema}.nfss_ft_product_history to ${idl_schema};
grant select on ${iol_schema}.nfss_ft_product_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_ft_product_history is '产品表历史记录';
comment on column ${iol_schema}.nfss_ft_product_history.id is '主键序号';
comment on column ${iol_schema}.nfss_ft_product_history.product_id is '主键序号';
comment on column ${iol_schema}.nfss_ft_product_history.product_name is '产品名称';
comment on column ${iol_schema}.nfss_ft_product_history.product_code is '产品代码';
comment on column ${iol_schema}.nfss_ft_product_history.risk_grade is '风险等级 r1:r1低风险  r2:r2中低风险 r3:r3中风险 r4:r4中高风险 r5:r5高风险';
comment on column ${iol_schema}.nfss_ft_product_history.performance_status is '业绩比较基准';
comment on column ${iol_schema}.nfss_ft_product_history.establishment_date is '成立日';
comment on column ${iol_schema}.nfss_ft_product_history.termination_date is '终止日';
comment on column ${iol_schema}.nfss_ft_product_history.product_status is '产品状态 0募集，1成立，2终止';
comment on column ${iol_schema}.nfss_ft_product_history.purchase_amount is '起购金额';
comment on column ${iol_schema}.nfss_ft_product_history.commencement_date is '募集开始日';
comment on column ${iol_schema}.nfss_ft_product_history.closing_date is '募集结束日';
comment on column ${iol_schema}.nfss_ft_product_history.init_amount is '初始创立金额';
comment on column ${iol_schema}.nfss_ft_product_history.current_net_worth is '当前净值';
comment on column ${iol_schema}.nfss_ft_product_history.current_market_value is '当前市值';
comment on column ${iol_schema}.nfss_ft_product_history.trustcompany_code is '信托公司代码';
comment on column ${iol_schema}.nfss_ft_product_history.trustcompany_name is '信托公司名称';
comment on column ${iol_schema}.nfss_ft_product_history.product_sorted is '排序字段';
comment on column ${iol_schema}.nfss_ft_product_history.product_comment is '备注（修改原因）';
comment on column ${iol_schema}.nfss_ft_product_history.created_time is '创建时间';
comment on column ${iol_schema}.nfss_ft_product_history.submit_time is '提交认证时间';
comment on column ${iol_schema}.nfss_ft_product_history.audit_time is '审核时间';
comment on column ${iol_schema}.nfss_ft_product_history.audit_status is '审核状态';
comment on column ${iol_schema}.nfss_ft_product_history.remark is '审核失败原因';
comment on column ${iol_schema}.nfss_ft_product_history.audit_by is '审核人';
comment on column ${iol_schema}.nfss_ft_product_history.history_created_time is '归档时间';
comment on column ${iol_schema}.nfss_ft_product_history.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nfss_ft_product_history.etl_timestamp is 'ETL处理时间戳';
