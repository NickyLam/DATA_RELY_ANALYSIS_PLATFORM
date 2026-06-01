/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_auth_parameter
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_auth_parameter
whenever sqlerror continue none;
drop table ${iol_schema}.icms_auth_parameter purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_auth_parameter(
    parameterid varchar2(32) -- 参数编号
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,parameterclassification varchar2(32) -- 参数分类
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,parametername varchar2(80) -- 参数名称
    ,rangetype varchar2(32) -- 值域类型值域类型(sql/码值/金额/数值/日期)
    ,updatedate date -- 更新日期
    ,parametertype varchar2(32) -- 参数类型参数类型（字符型等）
    ,datarange varchar2(1000) -- 值域
    ,status varchar2(32) -- 状态状态(启用、停用)
    ,inputdate date -- 登记日期
    ,remark varchar2(1000) -- 备注
    ,businesssql varchar2(2000) -- 执行sql
    ,rangesqlkey varchar2(32) -- 取值范围sql
    ,corporgid varchar2(32) -- 法人机构编号
    ,entityattribute varchar2(80) -- 实体属性
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
grant select on ${iol_schema}.icms_auth_parameter to ${iml_schema};
grant select on ${iol_schema}.icms_auth_parameter to ${icl_schema};
grant select on ${iol_schema}.icms_auth_parameter to ${idl_schema};
grant select on ${iol_schema}.icms_auth_parameter to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_auth_parameter is '授权参数授权参数';
comment on column ${iol_schema}.icms_auth_parameter.parameterid is '参数编号';
comment on column ${iol_schema}.icms_auth_parameter.updateuserid is '更新人';
comment on column ${iol_schema}.icms_auth_parameter.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_auth_parameter.parameterclassification is '参数分类';
comment on column ${iol_schema}.icms_auth_parameter.inputuserid is '登记人';
comment on column ${iol_schema}.icms_auth_parameter.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_auth_parameter.parametername is '参数名称';
comment on column ${iol_schema}.icms_auth_parameter.rangetype is '值域类型值域类型(sql/码值/金额/数值/日期)';
comment on column ${iol_schema}.icms_auth_parameter.updatedate is '更新日期';
comment on column ${iol_schema}.icms_auth_parameter.parametertype is '参数类型参数类型（字符型等）';
comment on column ${iol_schema}.icms_auth_parameter.datarange is '值域';
comment on column ${iol_schema}.icms_auth_parameter.status is '状态状态(启用、停用)';
comment on column ${iol_schema}.icms_auth_parameter.inputdate is '登记日期';
comment on column ${iol_schema}.icms_auth_parameter.remark is '备注';
comment on column ${iol_schema}.icms_auth_parameter.businesssql is '执行sql';
comment on column ${iol_schema}.icms_auth_parameter.rangesqlkey is '取值范围sql';
comment on column ${iol_schema}.icms_auth_parameter.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_auth_parameter.entityattribute is '实体属性';
comment on column ${iol_schema}.icms_auth_parameter.start_dt is '开始时间';
comment on column ${iol_schema}.icms_auth_parameter.end_dt is '结束时间';
comment on column ${iol_schema}.icms_auth_parameter.id_mark is '增删标志';
comment on column ${iol_schema}.icms_auth_parameter.etl_timestamp is 'ETL处理时间戳';
