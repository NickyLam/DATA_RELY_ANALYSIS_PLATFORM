/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ind_work_resume
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ind_work_resume
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ind_work_resume purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_work_resume(
    serialno varchar2(64) -- 流水号
    ,acctopenorg varchar2(64) -- 工资账号开户银行
    ,companyadd varchar2(400) -- 单位地址
    ,begindate date -- 开始日期开始日
    ,companyzip varchar2(64) -- 单位地址邮编
    ,customername varchar2(160) -- 所在单位
    ,remark varchar2(1000) -- 备注
    ,certid varchar2(32) -- 单位证件号
    ,industrytype varchar2(64) -- 所属行业类型
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,officetel varchar2(64) -- 办公电话
    ,relationship varchar2(50) -- 担任职务担任职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）
    ,unitcountryname varchar2(64) -- 单位所在地名称
    ,techpost varchar2(64) -- 职称
    ,industryname varchar2(64) -- 所属行业名称
    ,updatedate date -- 更新日期
    ,enddate date -- 结束日期结束日
    ,updateuserid varchar2(64) -- 更新人
    ,otherposition varchar2(64) -- 其他职务
    ,inputuserid varchar2(64) -- 登记人
    ,corporgid varchar2(64) -- 法人机构编号
    ,account varchar2(64) -- 工资账号
    ,inputorgid varchar2(64) -- 登记机构
    ,updateorgid varchar2(64) -- 更新机构
    ,certtype varchar2(4) -- 单位证件类型
    ,unitcountry varchar2(64) -- 单位所在地
    ,monthincome number(24,6) -- 月收入
    ,customerid varchar2(32) -- 客户编号个人客户编号
    ,companynature varchar2(36) -- 单位性质单位性质（代码：1-事业2-军队3-国有企业4-集团企业5-三资企业6-个人独资企业7-个体8-其他）
    ,companytel varchar2(64) -- 单位电话
    ,inputdate date -- 登记时间
    ,department varchar2(160) -- 所在部门
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
grant select on ${iol_schema}.icms_ind_work_resume to ${iml_schema};
grant select on ${iol_schema}.icms_ind_work_resume to ${icl_schema};
grant select on ${iol_schema}.icms_ind_work_resume to ${idl_schema};
grant select on ${iol_schema}.icms_ind_work_resume to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ind_work_resume is '个人工作履历个人工作履历';
comment on column ${iol_schema}.icms_ind_work_resume.serialno is '流水号';
comment on column ${iol_schema}.icms_ind_work_resume.acctopenorg is '工资账号开户银行';
comment on column ${iol_schema}.icms_ind_work_resume.companyadd is '单位地址';
comment on column ${iol_schema}.icms_ind_work_resume.begindate is '开始日期开始日';
comment on column ${iol_schema}.icms_ind_work_resume.companyzip is '单位地址邮编';
comment on column ${iol_schema}.icms_ind_work_resume.customername is '所在单位';
comment on column ${iol_schema}.icms_ind_work_resume.remark is '备注';
comment on column ${iol_schema}.icms_ind_work_resume.certid is '单位证件号';
comment on column ${iol_schema}.icms_ind_work_resume.industrytype is '所属行业类型';
comment on column ${iol_schema}.icms_ind_work_resume.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_ind_work_resume.officetel is '办公电话';
comment on column ${iol_schema}.icms_ind_work_resume.relationship is '担任职务担任职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）';
comment on column ${iol_schema}.icms_ind_work_resume.unitcountryname is '单位所在地名称';
comment on column ${iol_schema}.icms_ind_work_resume.techpost is '职称';
comment on column ${iol_schema}.icms_ind_work_resume.industryname is '所属行业名称';
comment on column ${iol_schema}.icms_ind_work_resume.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ind_work_resume.enddate is '结束日期结束日';
comment on column ${iol_schema}.icms_ind_work_resume.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ind_work_resume.otherposition is '其他职务';
comment on column ${iol_schema}.icms_ind_work_resume.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ind_work_resume.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_ind_work_resume.account is '工资账号';
comment on column ${iol_schema}.icms_ind_work_resume.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ind_work_resume.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ind_work_resume.certtype is '单位证件类型';
comment on column ${iol_schema}.icms_ind_work_resume.unitcountry is '单位所在地';
comment on column ${iol_schema}.icms_ind_work_resume.monthincome is '月收入';
comment on column ${iol_schema}.icms_ind_work_resume.customerid is '客户编号个人客户编号';
comment on column ${iol_schema}.icms_ind_work_resume.companynature is '单位性质单位性质（代码：1-事业2-军队3-国有企业4-集团企业5-三资企业6-个人独资企业7-个体8-其他）';
comment on column ${iol_schema}.icms_ind_work_resume.companytel is '单位电话';
comment on column ${iol_schema}.icms_ind_work_resume.inputdate is '登记时间';
comment on column ${iol_schema}.icms_ind_work_resume.department is '所在部门';
comment on column ${iol_schema}.icms_ind_work_resume.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ind_work_resume.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ind_work_resume.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ind_work_resume.etl_timestamp is 'ETL处理时间戳';
