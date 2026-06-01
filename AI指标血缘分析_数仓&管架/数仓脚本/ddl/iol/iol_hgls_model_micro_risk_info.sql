/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol hgls_model_micro_risk_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.hgls_model_micro_risk_info
whenever sqlerror continue none;
drop table ${iol_schema}.hgls_model_micro_risk_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_model_micro_risk_info(
    risk_id number(22,0) -- 主键id
    ,loan_id number(22,0) -- 进件id
    ,process_type varchar2(4000) -- 审批类型：1、准入模型输出结果 2、征信模型输出结果 3、业务申请评分模型输出结果 4、风险核查模型输出结果 5、免下户额度模型输出结果；6、企业征信模型输出结果 7、流水模型输出结果 8、交叉检验模型输出结果 9、综合评分授信模型
    ,biz_type number(22,0) -- 业务类型０个人信息１配偶信息２共同借款人３担保人4微信借款
    ,biz_id number(22,0) -- 信息来源主表ID
    ,type varchar2(4000) -- 风险类型大类：根据dict字典值查询，risk_type
    ,risk_type varchar2(4000) -- 风险类型小类：根据dict字典值查询，risk_small_type
    ,risk_level varchar2(4000) -- 风险等级：根据dict字典值查询risk_level
    ,risk_info varchar2(4000) -- 风险点内容
    ,term varchar2(4000) -- 话术主键
    ,create_date timestamp -- 申请日期
    ,update_date timestamp -- 更新时间
    ,point varchar2(4000) -- 是否需要高亮展示1需要
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
grant select on ${iol_schema}.hgls_model_micro_risk_info to ${iml_schema};
grant select on ${iol_schema}.hgls_model_micro_risk_info to ${icl_schema};
grant select on ${iol_schema}.hgls_model_micro_risk_info to ${idl_schema};
grant select on ${iol_schema}.hgls_model_micro_risk_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.hgls_model_micro_risk_info is '风险信息表';
comment on column ${iol_schema}.hgls_model_micro_risk_info.risk_id is '主键id';
comment on column ${iol_schema}.hgls_model_micro_risk_info.loan_id is '进件id';
comment on column ${iol_schema}.hgls_model_micro_risk_info.process_type is '审批类型：1、准入模型输出结果 2、征信模型输出结果 3、业务申请评分模型输出结果 4、风险核查模型输出结果 5、免下户额度模型输出结果；6、企业征信模型输出结果 7、流水模型输出结果 8、交叉检验模型输出结果 9、综合评分授信模型';
comment on column ${iol_schema}.hgls_model_micro_risk_info.biz_type is '业务类型０个人信息１配偶信息２共同借款人３担保人4微信借款';
comment on column ${iol_schema}.hgls_model_micro_risk_info.biz_id is '信息来源主表ID';
comment on column ${iol_schema}.hgls_model_micro_risk_info.type is '风险类型大类：根据dict字典值查询，risk_type';
comment on column ${iol_schema}.hgls_model_micro_risk_info.risk_type is '风险类型小类：根据dict字典值查询，risk_small_type';
comment on column ${iol_schema}.hgls_model_micro_risk_info.risk_level is '风险等级：根据dict字典值查询risk_level';
comment on column ${iol_schema}.hgls_model_micro_risk_info.risk_info is '风险点内容';
comment on column ${iol_schema}.hgls_model_micro_risk_info.term is '话术主键';
comment on column ${iol_schema}.hgls_model_micro_risk_info.create_date is '申请日期';
comment on column ${iol_schema}.hgls_model_micro_risk_info.update_date is '更新时间';
comment on column ${iol_schema}.hgls_model_micro_risk_info.point is '是否需要高亮展示1需要';
comment on column ${iol_schema}.hgls_model_micro_risk_info.start_dt is '开始时间';
comment on column ${iol_schema}.hgls_model_micro_risk_info.end_dt is '结束时间';
comment on column ${iol_schema}.hgls_model_micro_risk_info.id_mark is '增删标志';
comment on column ${iol_schema}.hgls_model_micro_risk_info.etl_timestamp is 'ETL处理时间戳';
