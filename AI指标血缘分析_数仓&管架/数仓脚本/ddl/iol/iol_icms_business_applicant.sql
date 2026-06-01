/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_business_applicant
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_business_applicant
whenever sqlerror continue none;
drop table ${iol_schema}.icms_business_applicant purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_applicant(
    serialno varchar2(64) -- 流水号
    ,remark varchar2(1000) -- 备注
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(64) -- 更新人
    ,corporgid varchar2(64) -- 法人机构编号
    ,updateorgid varchar2(64) -- 更新机构
    ,applicantid varchar2(64) -- 申请人编号
    ,relationship varchar2(36) -- 与主借人关系
    ,objectno varchar2(64) -- 对象编号
    ,rightprop number(24,8) -- 权益分担比例
    ,inputorgid varchar2(64) -- 登记机构
    ,objecttype varchar2(64) -- 对象类型
    ,applicantname varchar2(160) -- 申请人名称
    ,debtprop number(24,8) -- 债务分担比例
    ,inputuserid varchar2(64) -- 登记人
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,updatedate date -- 更新时间
    ,approvestatus varchar2(32) -- 审批状态
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
grant select on ${iol_schema}.icms_business_applicant to ${iml_schema};
grant select on ${iol_schema}.icms_business_applicant to ${icl_schema};
grant select on ${iol_schema}.icms_business_applicant to ${idl_schema};
grant select on ${iol_schema}.icms_business_applicant to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_business_applicant is '共同申请人信息表共同申请人信息表';
comment on column ${iol_schema}.icms_business_applicant.serialno is '流水号';
comment on column ${iol_schema}.icms_business_applicant.remark is '备注';
comment on column ${iol_schema}.icms_business_applicant.inputdate is '登记时间';
comment on column ${iol_schema}.icms_business_applicant.updateuserid is '更新人';
comment on column ${iol_schema}.icms_business_applicant.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_business_applicant.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_business_applicant.applicantid is '申请人编号';
comment on column ${iol_schema}.icms_business_applicant.relationship is '与主借人关系';
comment on column ${iol_schema}.icms_business_applicant.objectno is '对象编号';
comment on column ${iol_schema}.icms_business_applicant.rightprop is '权益分担比例';
comment on column ${iol_schema}.icms_business_applicant.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_business_applicant.objecttype is '对象类型';
comment on column ${iol_schema}.icms_business_applicant.applicantname is '申请人名称';
comment on column ${iol_schema}.icms_business_applicant.debtprop is '债务分担比例';
comment on column ${iol_schema}.icms_business_applicant.inputuserid is '登记人';
comment on column ${iol_schema}.icms_business_applicant.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_business_applicant.updatedate is '更新时间';
comment on column ${iol_schema}.icms_business_applicant.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_business_applicant.start_dt is '开始时间';
comment on column ${iol_schema}.icms_business_applicant.end_dt is '结束时间';
comment on column ${iol_schema}.icms_business_applicant.id_mark is '增删标志';
comment on column ${iol_schema}.icms_business_applicant.etl_timestamp is 'ETL处理时间戳';
