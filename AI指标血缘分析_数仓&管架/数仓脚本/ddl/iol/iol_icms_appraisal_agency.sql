/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_appraisal_agency
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_appraisal_agency
whenever sqlerror continue none;
drop table ${iol_schema}.icms_appraisal_agency purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_appraisal_agency(
    appraisalorgid varchar2(96) -- 评估机构编号
    ,appraisalorgname varchar2(240) -- 评估机构名称
    ,appraisalorgtype varchar2(54) -- 评估公司类型 02  特殊资产准入 03  特别准入,一次性)
    ,appraisalorgaddress varchar2(1500) -- 机构地址
    ,appraisalorgstatus varchar2(18) -- 评估机构管理状态
    ,registerdate date -- 机构成立日期
    ,assetstype varchar2(54) -- 可评估资产类型
    ,qualifylevel varchar2(54) -- 执业资质等级
    ,assessarea varchar2(240) -- 可估价地域范围
    ,certname varchar2(240) -- 资质证书名称
    ,certid varchar2(96) -- 资质证书标号
    ,approvedate date -- 资质核准日期
    ,approveenddate date -- 资质到期日期
    ,departmentcare varchar2(18) -- 行业主管部门是否年审
    ,inputuser varchar2(240) -- 基本信息录入岗
    ,continuetime number(38,0) -- 连续执业时间
    ,businessscope varchar2(1500) -- 经营范围
    ,registercapital number(24,6) -- 注册资本（万元）
    ,legalrep varchar2(240) -- 法人代表
    ,orgtelephone varchar2(54) -- 评估机构电话
    ,orgfax varchar2(54) -- 评估机构传真电话
    ,orgemail varchar2(96) -- 评估机构电子邮箱
    ,appraisernum number(38,0) -- 评估师数量
    ,parentorgid varchar2(240) -- 所属分行
    ,appraisalcertid varchar2(96) -- 评估机构证件号码
    ,appraisalcerttype varchar2(54) -- 评估机构证件类型
    ,relacertid varchar2(96) -- 关联机构
    ,tempsaveflag varchar2(3) -- 暂存标志
    ,isinalertlist varchar2(3) -- 警示标识
    ,inputuserid varchar2(240) -- 登记人
    ,inputorgid varchar2(240) -- 登记机构
    ,inputdate timestamp -- 登记日期
    ,updateuserid varchar2(240) -- 更新人
    ,updateorgid varchar2(240) -- 更新机构
    ,updatedate timestamp -- 更新日期
    ,remark varchar2(3000) -- 备注
    ,corporgid varchar2(96) -- 法人机构编号
    ,appraisallisttype varchar2(2) -- 评估机构名单标识
    ,coopstartdate date -- 合作起始日期
    ,coopenddate date -- 合作到期日
    ,belongdept varchar2(18) -- 所属条线
    ,appraisalorgstatustime date -- 操作评估机构管理状态执行时间
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
grant select on ${iol_schema}.icms_appraisal_agency to ${iml_schema};
grant select on ${iol_schema}.icms_appraisal_agency to ${icl_schema};
grant select on ${iol_schema}.icms_appraisal_agency to ${idl_schema};
grant select on ${iol_schema}.icms_appraisal_agency to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_appraisal_agency is '评估机构特殊名单';
comment on column ${iol_schema}.icms_appraisal_agency.appraisalorgid is '评估机构编号';
comment on column ${iol_schema}.icms_appraisal_agency.appraisalorgname is '评估机构名称';
comment on column ${iol_schema}.icms_appraisal_agency.appraisalorgtype is '评估公司类型 02  特殊资产准入 03  特别准入,一次性)';
comment on column ${iol_schema}.icms_appraisal_agency.appraisalorgaddress is '机构地址';
comment on column ${iol_schema}.icms_appraisal_agency.appraisalorgstatus is '评估机构管理状态';
comment on column ${iol_schema}.icms_appraisal_agency.registerdate is '机构成立日期';
comment on column ${iol_schema}.icms_appraisal_agency.assetstype is '可评估资产类型';
comment on column ${iol_schema}.icms_appraisal_agency.qualifylevel is '执业资质等级';
comment on column ${iol_schema}.icms_appraisal_agency.assessarea is '可估价地域范围';
comment on column ${iol_schema}.icms_appraisal_agency.certname is '资质证书名称';
comment on column ${iol_schema}.icms_appraisal_agency.certid is '资质证书标号';
comment on column ${iol_schema}.icms_appraisal_agency.approvedate is '资质核准日期';
comment on column ${iol_schema}.icms_appraisal_agency.approveenddate is '资质到期日期';
comment on column ${iol_schema}.icms_appraisal_agency.departmentcare is '行业主管部门是否年审';
comment on column ${iol_schema}.icms_appraisal_agency.inputuser is '基本信息录入岗';
comment on column ${iol_schema}.icms_appraisal_agency.continuetime is '连续执业时间';
comment on column ${iol_schema}.icms_appraisal_agency.businessscope is '经营范围';
comment on column ${iol_schema}.icms_appraisal_agency.registercapital is '注册资本（万元）';
comment on column ${iol_schema}.icms_appraisal_agency.legalrep is '法人代表';
comment on column ${iol_schema}.icms_appraisal_agency.orgtelephone is '评估机构电话';
comment on column ${iol_schema}.icms_appraisal_agency.orgfax is '评估机构传真电话';
comment on column ${iol_schema}.icms_appraisal_agency.orgemail is '评估机构电子邮箱';
comment on column ${iol_schema}.icms_appraisal_agency.appraisernum is '评估师数量';
comment on column ${iol_schema}.icms_appraisal_agency.parentorgid is '所属分行';
comment on column ${iol_schema}.icms_appraisal_agency.appraisalcertid is '评估机构证件号码';
comment on column ${iol_schema}.icms_appraisal_agency.appraisalcerttype is '评估机构证件类型';
comment on column ${iol_schema}.icms_appraisal_agency.relacertid is '关联机构';
comment on column ${iol_schema}.icms_appraisal_agency.tempsaveflag is '暂存标志';
comment on column ${iol_schema}.icms_appraisal_agency.isinalertlist is '警示标识';
comment on column ${iol_schema}.icms_appraisal_agency.inputuserid is '登记人';
comment on column ${iol_schema}.icms_appraisal_agency.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_appraisal_agency.inputdate is '登记日期';
comment on column ${iol_schema}.icms_appraisal_agency.updateuserid is '更新人';
comment on column ${iol_schema}.icms_appraisal_agency.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_appraisal_agency.updatedate is '更新日期';
comment on column ${iol_schema}.icms_appraisal_agency.remark is '备注';
comment on column ${iol_schema}.icms_appraisal_agency.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_appraisal_agency.appraisallisttype is '评估机构名单标识';
comment on column ${iol_schema}.icms_appraisal_agency.coopstartdate is '合作起始日期';
comment on column ${iol_schema}.icms_appraisal_agency.coopenddate is '合作到期日';
comment on column ${iol_schema}.icms_appraisal_agency.belongdept is '所属条线';
comment on column ${iol_schema}.icms_appraisal_agency.appraisalorgstatustime is '操作评估机构管理状态执行时间';
comment on column ${iol_schema}.icms_appraisal_agency.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_appraisal_agency.start_dt is '开始时间';
comment on column ${iol_schema}.icms_appraisal_agency.end_dt is '结束时间';
comment on column ${iol_schema}.icms_appraisal_agency.id_mark is '增删标志';
comment on column ${iol_schema}.icms_appraisal_agency.etl_timestamp is 'ETL处理时间戳';
