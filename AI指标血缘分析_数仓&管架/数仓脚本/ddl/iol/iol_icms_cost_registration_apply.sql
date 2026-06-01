/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cost_registration_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cost_registration_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cost_registration_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cost_registration_apply(
    serialno varchar2(64) -- 流水号
    ,relativeserialno varchar2(64) -- 关联流水号
    ,lastevalvalue number(24,6) -- 上期评估价值/公允价值
    ,costamountsum number(24,6) -- 费用总金额
    ,approvestatus varchar2(64) -- 审批状态
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,operateuserid varchar2(64) -- 经办客户经理
    ,operateorgid varchar2(64) -- 经办客户经理所属机构
    ,operatedate date -- 经办时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_cost_registration_apply to ${iml_schema};
grant select on ${iol_schema}.icms_cost_registration_apply to ${icl_schema};
grant select on ${iol_schema}.icms_cost_registration_apply to ${idl_schema};
grant select on ${iol_schema}.icms_cost_registration_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cost_registration_apply is '费用登记申请表';
comment on column ${iol_schema}.icms_cost_registration_apply.serialno is '流水号';
comment on column ${iol_schema}.icms_cost_registration_apply.relativeserialno is '关联流水号';
comment on column ${iol_schema}.icms_cost_registration_apply.lastevalvalue is '上期评估价值/公允价值';
comment on column ${iol_schema}.icms_cost_registration_apply.costamountsum is '费用总金额';
comment on column ${iol_schema}.icms_cost_registration_apply.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_cost_registration_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cost_registration_apply.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cost_registration_apply.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cost_registration_apply.operateuserid is '经办客户经理';
comment on column ${iol_schema}.icms_cost_registration_apply.operateorgid is '经办客户经理所属机构';
comment on column ${iol_schema}.icms_cost_registration_apply.operatedate is '经办时间';
comment on column ${iol_schema}.icms_cost_registration_apply.updateuserid is '更新人';
comment on column ${iol_schema}.icms_cost_registration_apply.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_cost_registration_apply.updatedate is '更新日期';
comment on column ${iol_schema}.icms_cost_registration_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_cost_registration_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_cost_registration_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_cost_registration_apply.etl_timestamp is 'ETL处理时间戳';
