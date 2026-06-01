/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_nonretail_asset_disposal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_nonretail_asset_disposal
whenever sqlerror continue none;
drop table ${iol_schema}.icms_nonretail_asset_disposal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_nonretail_asset_disposal(
    programno varchar2(64) -- 方案编号
    ,programname varchar2(1000) -- 方案名称
    ,summarize varchar2(4000) -- 方案描述
    ,customername varchar2(4000) -- 涉及借款人
    ,declarationinstruction varchar2(4000) -- 申报说明
    ,handletype varchar2(120) -- 处置方式
    ,oldhandletype varchar2(120) -- 旧处置方式（用于判断是否变更了）
    ,ischangehandletype varchar2(12) -- 是否变更处置方式
    ,isrollback varchar2(12) -- 是否退回
    ,flowstatus varchar2(12) -- 流程状态
    ,taskstatus varchar2(12) -- 任务状态
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,reviewno1 varchar2(200) -- 审查编号（审查意见-分行）
    ,reviewno2 varchar2(200) -- 审查编号（审查意见-总行）
    ,reviewno3 varchar2(200) -- 审查编号（回复意见）
    ,updatedate date -- 更新日期
    ,inputdate date -- 登记日期
    ,reviewcomment varchar2(2000) -- 审查结论
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
grant select on ${iol_schema}.icms_nonretail_asset_disposal to ${iml_schema};
grant select on ${iol_schema}.icms_nonretail_asset_disposal to ${icl_schema};
grant select on ${iol_schema}.icms_nonretail_asset_disposal to ${idl_schema};
grant select on ${iol_schema}.icms_nonretail_asset_disposal to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_nonretail_asset_disposal is '非零售问题资产处理表';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.programno is '方案编号';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.programname is '方案名称';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.summarize is '方案描述';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.customername is '涉及借款人';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.declarationinstruction is '申报说明';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.handletype is '处置方式';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.oldhandletype is '旧处置方式（用于判断是否变更了）';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.ischangehandletype is '是否变更处置方式';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.isrollback is '是否退回';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.flowstatus is '流程状态';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.taskstatus is '任务状态';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.inputuserid is '登记人';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.updateuserid is '更新人';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.reviewno1 is '审查编号（审查意见-分行）';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.reviewno2 is '审查编号（审查意见-总行）';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.reviewno3 is '审查编号（回复意见）';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.updatedate is '更新日期';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.inputdate is '登记日期';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.reviewcomment is '审查结论';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.start_dt is '开始时间';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.end_dt is '结束时间';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.id_mark is '增删标志';
comment on column ${iol_schema}.icms_nonretail_asset_disposal.etl_timestamp is 'ETL处理时间戳';
