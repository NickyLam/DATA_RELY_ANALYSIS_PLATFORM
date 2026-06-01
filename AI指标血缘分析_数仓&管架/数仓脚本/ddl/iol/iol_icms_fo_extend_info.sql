/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fo_extend_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fo_extend_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fo_extend_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fo_extend_info(
    serialno varchar2(64) -- 流程节点编号
    ,objecttype varchar2(64) -- 流程对象任务类型
    ,objectno varchar2(64) -- 流程对象编号
    ,customername varchar2(200) -- 客户名称
    ,vouchtype varchar2(4) -- 授信主担保方式
    ,othervouchtype varchar2(4) -- 其他担保方式
    ,credittypeone varchar2(20) -- 申请授信种类-一级
    ,ownerline varchar2(20) -- 条线
    ,credittypetwo varchar2(20) -- 申请授信种类-二级
    ,creditareaflag varchar2(10) -- 授信客户区域
    ,iscityinvestcomp varchar2(2) -- 是否城投企业
    ,ownershipclassify varchar2(4) -- 所有制分类
    ,industry varchar2(10) -- 行业
    ,iscreditpolicy varchar2(2) -- 是否符合信贷政策导向
    ,iscredit varchar2(2) -- 是否新客户授信
    ,inputorg varchar2(64) -- 登记机构
    ,inputuser varchar2(64) -- 登记人
    ,updateorg varchar2(64) -- 更新机构
    ,updateuser varchar2(64) -- 更新人
    ,inputtime date -- 登记时间
    ,updatetime date -- 更新时间
    ,isprojectloan varchar2(2) -- 是否项目贷款
    ,iscityupdate varchar2(2) -- 是否城市更新
    ,completeflag varchar2(2) -- 是否保存
    ,score varchar2(100) -- 评分
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
grant select on ${iol_schema}.icms_fo_extend_info to ${iml_schema};
grant select on ${iol_schema}.icms_fo_extend_info to ${icl_schema};
grant select on ${iol_schema}.icms_fo_extend_info to ${idl_schema};
grant select on ${iol_schema}.icms_fo_extend_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fo_extend_info is '流程节点统计信息表';
comment on column ${iol_schema}.icms_fo_extend_info.serialno is '流程节点编号';
comment on column ${iol_schema}.icms_fo_extend_info.objecttype is '流程对象任务类型';
comment on column ${iol_schema}.icms_fo_extend_info.objectno is '流程对象编号';
comment on column ${iol_schema}.icms_fo_extend_info.customername is '客户名称';
comment on column ${iol_schema}.icms_fo_extend_info.vouchtype is '授信主担保方式';
comment on column ${iol_schema}.icms_fo_extend_info.othervouchtype is '其他担保方式';
comment on column ${iol_schema}.icms_fo_extend_info.credittypeone is '申请授信种类-一级';
comment on column ${iol_schema}.icms_fo_extend_info.ownerline is '条线';
comment on column ${iol_schema}.icms_fo_extend_info.credittypetwo is '申请授信种类-二级';
comment on column ${iol_schema}.icms_fo_extend_info.creditareaflag is '授信客户区域';
comment on column ${iol_schema}.icms_fo_extend_info.iscityinvestcomp is '是否城投企业';
comment on column ${iol_schema}.icms_fo_extend_info.ownershipclassify is '所有制分类';
comment on column ${iol_schema}.icms_fo_extend_info.industry is '行业';
comment on column ${iol_schema}.icms_fo_extend_info.iscreditpolicy is '是否符合信贷政策导向';
comment on column ${iol_schema}.icms_fo_extend_info.iscredit is '是否新客户授信';
comment on column ${iol_schema}.icms_fo_extend_info.inputorg is '登记机构';
comment on column ${iol_schema}.icms_fo_extend_info.inputuser is '登记人';
comment on column ${iol_schema}.icms_fo_extend_info.updateorg is '更新机构';
comment on column ${iol_schema}.icms_fo_extend_info.updateuser is '更新人';
comment on column ${iol_schema}.icms_fo_extend_info.inputtime is '登记时间';
comment on column ${iol_schema}.icms_fo_extend_info.updatetime is '更新时间';
comment on column ${iol_schema}.icms_fo_extend_info.isprojectloan is '是否项目贷款';
comment on column ${iol_schema}.icms_fo_extend_info.iscityupdate is '是否城市更新';
comment on column ${iol_schema}.icms_fo_extend_info.completeflag is '是否保存';
comment on column ${iol_schema}.icms_fo_extend_info.score is '评分';
comment on column ${iol_schema}.icms_fo_extend_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fo_extend_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fo_extend_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fo_extend_info.etl_timestamp is 'ETL处理时间戳';
