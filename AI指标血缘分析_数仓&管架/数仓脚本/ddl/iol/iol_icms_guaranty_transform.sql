/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_guaranty_transform
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_guaranty_transform
whenever sqlerror continue none;
drop table ${iol_schema}.icms_guaranty_transform purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_guaranty_transform(
    serialno varchar2(64) -- 申请流水号
    ,guarantybailsubaccount varchar2(64) -- 押品保证金子账号
    ,transformreason varchar2(3000) -- 变更原因
    ,manageorgid varchar2(64) -- 管户机构ID
    ,relativeserialno varchar2(64) -- 合同流水号字段
    ,customerid varchar2(16) -- 客户编号
    ,objecttype varchar2(64) -- 对象类型
    ,inputuserid varchar2(64) -- 登记人
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,guarantybailaccount varchar2(64) -- 押品保证金账号
    ,artificialno varchar2(96) -- 文本合同号
    ,businesscurrency varchar2(3) -- 币种
    ,updateuserid varchar2(64) -- 更新人
    ,balance number(24,6) -- 当前余额
    ,occurtype varchar2(16) -- 发生类型
    ,updatedate date -- 更新日期
    ,customername varchar2(200) -- 客户名称
    ,chgtype varchar2(1) -- 担保变更类型
    ,istfb varchar2(1) -- 是否提放保
    ,businesssum number(24,6) -- 金额
    ,pigeonholedate date -- 归档日期
    ,manageuserid varchar2(64) -- 管户人ID
    ,businesstype varchar2(64) -- 业务品种
    ,approvestatus varchar2(64) -- 审批状态
    ,changenums number(4,0) -- 变更次数
    ,corporgid varchar2(64) -- 法人机构编号
    ,updateorgid varchar2(64) -- 更新机构
    ,ischangeapprove varchar2(2) -- 是否需要授信批复变更
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
grant select on ${iol_schema}.icms_guaranty_transform to ${iml_schema};
grant select on ${iol_schema}.icms_guaranty_transform to ${icl_schema};
grant select on ${iol_schema}.icms_guaranty_transform to ${idl_schema};
grant select on ${iol_schema}.icms_guaranty_transform to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_guaranty_transform is '担保合同变更表';
comment on column ${iol_schema}.icms_guaranty_transform.serialno is '申请流水号';
comment on column ${iol_schema}.icms_guaranty_transform.guarantybailsubaccount is '押品保证金子账号';
comment on column ${iol_schema}.icms_guaranty_transform.transformreason is '变更原因';
comment on column ${iol_schema}.icms_guaranty_transform.manageorgid is '管户机构ID';
comment on column ${iol_schema}.icms_guaranty_transform.relativeserialno is '合同流水号字段';
comment on column ${iol_schema}.icms_guaranty_transform.customerid is '客户编号';
comment on column ${iol_schema}.icms_guaranty_transform.objecttype is '对象类型';
comment on column ${iol_schema}.icms_guaranty_transform.inputuserid is '登记人';
comment on column ${iol_schema}.icms_guaranty_transform.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_guaranty_transform.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_guaranty_transform.inputdate is '登记日期';
comment on column ${iol_schema}.icms_guaranty_transform.guarantybailaccount is '押品保证金账号';
comment on column ${iol_schema}.icms_guaranty_transform.artificialno is '文本合同号';
comment on column ${iol_schema}.icms_guaranty_transform.businesscurrency is '币种';
comment on column ${iol_schema}.icms_guaranty_transform.updateuserid is '更新人';
comment on column ${iol_schema}.icms_guaranty_transform.balance is '当前余额';
comment on column ${iol_schema}.icms_guaranty_transform.occurtype is '发生类型';
comment on column ${iol_schema}.icms_guaranty_transform.updatedate is '更新日期';
comment on column ${iol_schema}.icms_guaranty_transform.customername is '客户名称';
comment on column ${iol_schema}.icms_guaranty_transform.chgtype is '担保变更类型';
comment on column ${iol_schema}.icms_guaranty_transform.istfb is '是否提放保';
comment on column ${iol_schema}.icms_guaranty_transform.businesssum is '金额';
comment on column ${iol_schema}.icms_guaranty_transform.pigeonholedate is '归档日期';
comment on column ${iol_schema}.icms_guaranty_transform.manageuserid is '管户人ID';
comment on column ${iol_schema}.icms_guaranty_transform.businesstype is '业务品种';
comment on column ${iol_schema}.icms_guaranty_transform.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_guaranty_transform.changenums is '变更次数';
comment on column ${iol_schema}.icms_guaranty_transform.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_guaranty_transform.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_guaranty_transform.ischangeapprove is '是否需要授信批复变更';
comment on column ${iol_schema}.icms_guaranty_transform.start_dt is '开始时间';
comment on column ${iol_schema}.icms_guaranty_transform.end_dt is '结束时间';
comment on column ${iol_schema}.icms_guaranty_transform.id_mark is '增删标志';
comment on column ${iol_schema}.icms_guaranty_transform.etl_timestamp is 'ETL处理时间戳';
