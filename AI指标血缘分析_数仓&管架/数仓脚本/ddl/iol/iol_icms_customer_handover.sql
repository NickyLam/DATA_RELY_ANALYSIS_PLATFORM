/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_handover
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_handover
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_handover purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_handover(
    serialno varchar2(64) -- 流水号
    ,transferrange varchar2(16) -- 移交范围，01-全部客户，02-部分客户
    ,updateuserid varchar2(64) -- 更新人编号
    ,istransfer varchar2(16) -- 是否可移交
    ,operateorgid varchar2(64) -- 操作人机构编号
    ,inputuserid varchar2(64) -- 登记人编号
    ,updatedate date -- 更新时间
    ,operateuserid varchar2(64) -- 操作人编号
    ,neworgid varchar2(64) -- 新客户经理机构编号
    ,transfercomment varchar2(256) -- 移交说明
    ,updateorgid varchar2(64) -- 更新机构编号
    ,issucc varchar2(8) -- 是否成功
    ,batchno varchar2(64) -- 移交批次号（合作商移交申请流水号）
    ,inputdate date -- 登记时间
    ,businesstype varchar2(32) -- 移交业务类型
    ,transferrelative varchar2(16) -- 移交机构关系，01-机构内移交，02-跨机构移交
    ,olduserid varchar2(64) -- 旧客户经理编号
    ,inputorgid varchar2(64) -- 登记机构编号
    ,businessno varchar2(64) -- 业务流水号
    ,operatedate date -- 操作时间
    ,newuserid varchar2(64) -- 新客户经理编号
    ,oldorgid varchar2(64) -- 旧客户机构编号
    ,operatetype varchar2(16) -- 移交类型
    ,customerid varchar2(64) -- 客户编号
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
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
grant select on ${iol_schema}.icms_customer_handover to ${iml_schema};
grant select on ${iol_schema}.icms_customer_handover to ${icl_schema};
grant select on ${iol_schema}.icms_customer_handover to ${idl_schema};
grant select on ${iol_schema}.icms_customer_handover to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_handover is '客户移交';
comment on column ${iol_schema}.icms_customer_handover.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_handover.transferrange is '移交范围，01-全部客户，02-部分客户';
comment on column ${iol_schema}.icms_customer_handover.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_customer_handover.istransfer is '是否可移交';
comment on column ${iol_schema}.icms_customer_handover.operateorgid is '操作人机构编号';
comment on column ${iol_schema}.icms_customer_handover.inputuserid is '登记人编号';
comment on column ${iol_schema}.icms_customer_handover.updatedate is '更新时间';
comment on column ${iol_schema}.icms_customer_handover.operateuserid is '操作人编号';
comment on column ${iol_schema}.icms_customer_handover.neworgid is '新客户经理机构编号';
comment on column ${iol_schema}.icms_customer_handover.transfercomment is '移交说明';
comment on column ${iol_schema}.icms_customer_handover.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_customer_handover.issucc is '是否成功';
comment on column ${iol_schema}.icms_customer_handover.batchno is '移交批次号（合作商移交申请流水号）';
comment on column ${iol_schema}.icms_customer_handover.inputdate is '登记时间';
comment on column ${iol_schema}.icms_customer_handover.businesstype is '移交业务类型';
comment on column ${iol_schema}.icms_customer_handover.transferrelative is '移交机构关系，01-机构内移交，02-跨机构移交';
comment on column ${iol_schema}.icms_customer_handover.olduserid is '旧客户经理编号';
comment on column ${iol_schema}.icms_customer_handover.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_customer_handover.businessno is '业务流水号';
comment on column ${iol_schema}.icms_customer_handover.operatedate is '操作时间';
comment on column ${iol_schema}.icms_customer_handover.newuserid is '新客户经理编号';
comment on column ${iol_schema}.icms_customer_handover.oldorgid is '旧客户机构编号';
comment on column ${iol_schema}.icms_customer_handover.operatetype is '移交类型';
comment on column ${iol_schema}.icms_customer_handover.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_handover.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_customer_handover.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_handover.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_handover.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_handover.etl_timestamp is 'ETL处理时间戳';
