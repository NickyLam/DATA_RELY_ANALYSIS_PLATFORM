/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_appraisal_agency_information
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_appraisal_agency_information
whenever sqlerror continue none;
drop table ${iol_schema}.icms_appraisal_agency_information purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_appraisal_agency_information(
    serialno varchar2(96) -- 流水号
    ,appraisalorgid varchar2(96) -- 评估公司组织机构代码证
    ,informationtype varchar2(54) -- 信息类型
    ,attribute1 varchar2(240) -- 联系人列表_姓名,资质情况_资质证书名称，专家信息_姓名，大事信息_标题
    ,attribute2 varchar2(96) -- 联系人列表_电话,资质情况_资质证书标号，专家信息_电话，大事信息_无
    ,attribute3 varchar2(96) -- 联系人列表_所属部门,资质情况_无，专家信息_所属部门，大事信息_无
    ,attribute4 varchar2(27) -- 联系人列表_是否有效,资质情况_执业资质等级，专家信息_无，大事信息_是否有效
    ,attribute6 date -- 联系人列表_无,资质情况_资质核准日期，专家信息_无，大事信息_发生日期
    ,attribute7 date -- 联系人列表_无,资质情况_资质到期日期，专家信息_无，大事信息_无
    ,workyears varchar2(18) -- 从业年限
    ,inputuserid varchar2(240) -- 登记人
    ,inputorgid varchar2(240) -- 登记机构
    ,inputdate timestamp -- 登记日期
    ,updateuserid varchar2(240) -- 更新人
    ,updateorgid varchar2(240) -- 更新机构
    ,updatedate timestamp -- 更新日期
    ,remark varchar2(1500) -- 备注
    ,corporgid varchar2(96) -- 法人机构编号
    ,attribute5 varchar2(3000) -- 联系人列表_无,资质情况_无，专家信息_专业领域，大事信息_事件描述及原因
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
grant select on ${iol_schema}.icms_appraisal_agency_information to ${iml_schema};
grant select on ${iol_schema}.icms_appraisal_agency_information to ${icl_schema};
grant select on ${iol_schema}.icms_appraisal_agency_information to ${idl_schema};
grant select on ${iol_schema}.icms_appraisal_agency_information to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_appraisal_agency_information is '评估公司相关信息';
comment on column ${iol_schema}.icms_appraisal_agency_information.serialno is '流水号';
comment on column ${iol_schema}.icms_appraisal_agency_information.appraisalorgid is '评估公司组织机构代码证';
comment on column ${iol_schema}.icms_appraisal_agency_information.informationtype is '信息类型';
comment on column ${iol_schema}.icms_appraisal_agency_information.attribute1 is '联系人列表_姓名,资质情况_资质证书名称，专家信息_姓名，大事信息_标题';
comment on column ${iol_schema}.icms_appraisal_agency_information.attribute2 is '联系人列表_电话,资质情况_资质证书标号，专家信息_电话，大事信息_无';
comment on column ${iol_schema}.icms_appraisal_agency_information.attribute3 is '联系人列表_所属部门,资质情况_无，专家信息_所属部门，大事信息_无';
comment on column ${iol_schema}.icms_appraisal_agency_information.attribute4 is '联系人列表_是否有效,资质情况_执业资质等级，专家信息_无，大事信息_是否有效';
comment on column ${iol_schema}.icms_appraisal_agency_information.attribute6 is '联系人列表_无,资质情况_资质核准日期，专家信息_无，大事信息_发生日期';
comment on column ${iol_schema}.icms_appraisal_agency_information.attribute7 is '联系人列表_无,资质情况_资质到期日期，专家信息_无，大事信息_无';
comment on column ${iol_schema}.icms_appraisal_agency_information.workyears is '从业年限';
comment on column ${iol_schema}.icms_appraisal_agency_information.inputuserid is '登记人';
comment on column ${iol_schema}.icms_appraisal_agency_information.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_appraisal_agency_information.inputdate is '登记日期';
comment on column ${iol_schema}.icms_appraisal_agency_information.updateuserid is '更新人';
comment on column ${iol_schema}.icms_appraisal_agency_information.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_appraisal_agency_information.updatedate is '更新日期';
comment on column ${iol_schema}.icms_appraisal_agency_information.remark is '备注';
comment on column ${iol_schema}.icms_appraisal_agency_information.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_appraisal_agency_information.attribute5 is '联系人列表_无,资质情况_无，专家信息_专业领域，大事信息_事件描述及原因';
comment on column ${iol_schema}.icms_appraisal_agency_information.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_appraisal_agency_information.start_dt is '开始时间';
comment on column ${iol_schema}.icms_appraisal_agency_information.end_dt is '结束时间';
comment on column ${iol_schema}.icms_appraisal_agency_information.id_mark is '增删标志';
comment on column ${iol_schema}.icms_appraisal_agency_information.etl_timestamp is 'ETL处理时间戳';
