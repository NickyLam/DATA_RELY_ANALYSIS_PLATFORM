/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_om_apply_oa_relation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_om_apply_oa_relation
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_om_apply_oa_relation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_om_apply_oa_relation(
    oa_approval_no varchar2(100) -- OA审批单号
    ,om_apply_no varchar2(40) -- 参数平台变更申请单号
    ,business_type varchar2(4) -- 业务场景  0-产品目录维护
    ,start_timestamp varchar2(52) -- 任务开始时间戳
    ,end_timestamp varchar2(52) -- 任务结束时间戳
    ,om_user_id varchar2(40) -- 操作用户
    ,deal_status varchar2(2) -- 处理状态  0-处理中,1-处理完成,2-处理失败
    ,deal_msg varchar2(400) -- 处理信息
    ,param_code varchar2(24) -- 目录代码|目录代码
    ,param_code_name varchar2(100) -- 目录名称|目录名称
    ,effect_date varchar2(8) -- 生效日期|生效日期
    ,expire_date varchar2(8) -- 失效日期|失效日期
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
grant select on ${iol_schema}.ncbs_om_apply_oa_relation to ${iml_schema};
grant select on ${iol_schema}.ncbs_om_apply_oa_relation to ${icl_schema};
grant select on ${iol_schema}.ncbs_om_apply_oa_relation to ${idl_schema};
grant select on ${iol_schema}.ncbs_om_apply_oa_relation to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_om_apply_oa_relation is '变更申请关联OA审批单号映射表';
comment on column ${iol_schema}.ncbs_om_apply_oa_relation.oa_approval_no is 'OA审批单号';
comment on column ${iol_schema}.ncbs_om_apply_oa_relation.om_apply_no is '参数平台变更申请单号';
comment on column ${iol_schema}.ncbs_om_apply_oa_relation.business_type is '业务场景  0-产品目录维护';
comment on column ${iol_schema}.ncbs_om_apply_oa_relation.start_timestamp is '任务开始时间戳';
comment on column ${iol_schema}.ncbs_om_apply_oa_relation.end_timestamp is '任务结束时间戳';
comment on column ${iol_schema}.ncbs_om_apply_oa_relation.om_user_id is '操作用户';
comment on column ${iol_schema}.ncbs_om_apply_oa_relation.deal_status is '处理状态  0-处理中,1-处理完成,2-处理失败';
comment on column ${iol_schema}.ncbs_om_apply_oa_relation.deal_msg is '处理信息';
comment on column ${iol_schema}.ncbs_om_apply_oa_relation.param_code is '目录代码|目录代码';
comment on column ${iol_schema}.ncbs_om_apply_oa_relation.param_code_name is '目录名称|目录名称';
comment on column ${iol_schema}.ncbs_om_apply_oa_relation.effect_date is '生效日期|生效日期';
comment on column ${iol_schema}.ncbs_om_apply_oa_relation.expire_date is '失效日期|失效日期';
comment on column ${iol_schema}.ncbs_om_apply_oa_relation.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_om_apply_oa_relation.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_om_apply_oa_relation.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_om_apply_oa_relation.etl_timestamp is 'ETL处理时间戳';
