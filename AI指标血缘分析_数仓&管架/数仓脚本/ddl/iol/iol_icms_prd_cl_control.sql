/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_prd_cl_control
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_prd_cl_control
whenever sqlerror continue none;
drop table ${iol_schema}.icms_prd_cl_control purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_cl_control(
    productid varchar2(64) -- 产品编号上层授信类型编号
    ,limitproductid varchar2(64) -- 上层授信类型编号三
    ,corporgid varchar2(64) -- 法人机构编号
    ,businessperiod varchar2(160) -- 限制业务品种阶段
    ,message varchar2(2000) -- 检查提示语
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(64) -- 更新机构
    ,occupyrole varchar2(160) -- 占用角色
    ,updateuserid varchar2(64) -- 更新人
    ,updatedate date -- 更新日期
    ,limitperiod varchar2(160) -- 限制额度阶段	限制额度阶段
    ,inputorgid varchar2(64) -- 登记机构
    ,priority number(22) -- 规则优先级
    ,serialno varchar2(64) -- 流水号
    ,occupymod varchar2(160) -- 占用上层授信模式
    ,inputuserid varchar2(64) -- 登记人
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
grant select on ${iol_schema}.icms_prd_cl_control to ${iml_schema};
grant select on ${iol_schema}.icms_prd_cl_control to ${icl_schema};
grant select on ${iol_schema}.icms_prd_cl_control to ${idl_schema};
grant select on ${iol_schema}.icms_prd_cl_control to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_prd_cl_control is '产品额度管控表产品额度管控表';
comment on column ${iol_schema}.icms_prd_cl_control.productid is '产品编号上层授信类型编号';
comment on column ${iol_schema}.icms_prd_cl_control.limitproductid is '上层授信类型编号三';
comment on column ${iol_schema}.icms_prd_cl_control.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_prd_cl_control.businessperiod is '限制业务品种阶段';
comment on column ${iol_schema}.icms_prd_cl_control.message is '检查提示语';
comment on column ${iol_schema}.icms_prd_cl_control.inputdate is '登记日期';
comment on column ${iol_schema}.icms_prd_cl_control.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_prd_cl_control.occupyrole is '占用角色';
comment on column ${iol_schema}.icms_prd_cl_control.updateuserid is '更新人';
comment on column ${iol_schema}.icms_prd_cl_control.updatedate is '更新日期';
comment on column ${iol_schema}.icms_prd_cl_control.limitperiod is '限制额度阶段	限制额度阶段';
comment on column ${iol_schema}.icms_prd_cl_control.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_prd_cl_control.priority is '规则优先级';
comment on column ${iol_schema}.icms_prd_cl_control.serialno is '流水号';
comment on column ${iol_schema}.icms_prd_cl_control.occupymod is '占用上层授信模式';
comment on column ${iol_schema}.icms_prd_cl_control.inputuserid is '登记人';
comment on column ${iol_schema}.icms_prd_cl_control.start_dt is '开始时间';
comment on column ${iol_schema}.icms_prd_cl_control.end_dt is '结束时间';
comment on column ${iol_schema}.icms_prd_cl_control.id_mark is '增删标志';
comment on column ${iol_schema}.icms_prd_cl_control.etl_timestamp is 'ETL处理时间戳';
