/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol hgls_gh_uus_employee
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.hgls_gh_uus_employee
whenever sqlerror continue none;
drop table ${iol_schema}.hgls_gh_uus_employee purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_gh_uus_employee(
    id number(22,0) -- 主键id
    ,employeeid varchar2(4000) -- 员工编号
    ,domainid varchar2(4000) -- 域帐号
    ,tellerno varchar2(4000) -- 柜员号
    ,givenname varchar2(4000) -- 员工姓名
    ,surname varchar2(4000) -- 员工姓氏
    ,firstname varchar2(4000) -- 英文名字
    ,lastname varchar2(4000) -- 英文姓氏
    ,idtype varchar2(4000) -- 证件类型
    ,idcode varchar2(4000) -- 证件号码
    ,sex varchar2(4000) -- 员工性别
    ,birthdate varchar2(4000) -- 员工出生日期
    ,ethnic varchar2(4000) -- 民族
    ,politicface varchar2(4000) -- 政治面貌
    ,marriage varchar2(4000) -- 婚姻状况
    ,education varchar2(4000) -- 员工学历
    ,jobdate varchar2(4000) -- 参加工作日期
    ,picturepath varchar2(4000) -- 柜员图片路径
    ,emptype varchar2(4000) -- 员工类型
    ,organcode varchar2(4000) -- 所属部门编号
    ,titlecode varchar2(4000) -- 职称
    ,place varchar2(4000) -- 职位
    ,managertype varchar2(4000) -- 客户经理标志
    ,managerlevel varchar2(4000) -- 客户经理级别
    ,tellerlevel varchar2(4000) -- 柜员级别
    ,tellermanagerid varchar2(4000) -- 旧柜员号
    ,attachorgan varchar2(4000) -- 柜员所属机构
    ,theentrydate varchar2(4000) -- 员工入职日期
    ,leaveofficedate varchar2(4000) -- 离职日期
    ,status varchar2(4000) -- 员工状态代码
    ,sysstatus varchar2(4000) -- 用户系统状态
    ,fixcountrycode varchar2(4000) -- 传真国际区号
    ,fixareacode varchar2(4000) -- 传真国内区号
    ,fixphone varchar2(4000) -- 传真
    ,fixsubphone varchar2(4000) -- 传真分机号
    ,companycountrycode varchar2(4000) -- 单位电话国际区号
    ,companyareacode varchar2(4000) -- 单位电话国内区号
    ,companyphone varchar2(4000) -- 单位电话
    ,companysubphone varchar2(4000) -- 单位电话分机号
    ,housecountrycode varchar2(4000) -- 住宅电话国际区号
    ,houseareacode varchar2(4000) -- 住宅电话国内区号
    ,homephone varchar2(4000) -- 住宅电话
    ,housesubphone varchar2(4000) -- 住宅电话分机号
    ,mobile varchar2(4000) -- 联系电话
    ,mobile1 varchar2(4000) -- 移动电话1
    ,mobile2 varchar2(4000) -- 移动电话2
    ,mobile3 varchar2(4000) -- 移动电话3
    ,post varchar2(4000) -- 邮政编码
    ,country varchar2(4000) -- 所在国家
    ,province varchar2(4000) -- 所在省/州
    ,city varchar2(4000) -- 所在城市
    ,county varchar2(4000) -- 县/区代码
    ,address varchar2(4000) -- 详细地址
    ,email varchar2(4000) -- 电子邮箱
    ,sallevel varchar2(4000) -- 薪资级别
    ,orderno varchar2(4000) -- 序号
    ,partorgancode varchar2(4000) -- 兼职所在部门编号
    ,partplace varchar2(4000) -- 
    ,hsorgancode varchar2(4000) -- 虚拟核算部门编号
    ,parttellerno varchar2(4000) -- 兼职柜员号
    ,parttellerattachorgan varchar2(4000) -- 兼职柜员所属机构
    ,subsidydate varchar2(4000) -- 补贴正式发放日期
    ,userid varchar2(4000) -- 钉钉UserID
    ,placehr varchar2(4000) -- HR职务编码(HR更新）
    ,jobcategory varchar2(4000) -- (职务类别)员工职务代码
    ,jobcategoryname varchar2(4000) -- 职务类别名称HR
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
grant select on ${iol_schema}.hgls_gh_uus_employee to ${iml_schema};
grant select on ${iol_schema}.hgls_gh_uus_employee to ${icl_schema};
grant select on ${iol_schema}.hgls_gh_uus_employee to ${idl_schema};
grant select on ${iol_schema}.hgls_gh_uus_employee to ${iel_schema};

-- comment
comment on table ${iol_schema}.hgls_gh_uus_employee is '统一用户系统用户表';
comment on column ${iol_schema}.hgls_gh_uus_employee.id is '主键id';
comment on column ${iol_schema}.hgls_gh_uus_employee.employeeid is '员工编号';
comment on column ${iol_schema}.hgls_gh_uus_employee.domainid is '域帐号';
comment on column ${iol_schema}.hgls_gh_uus_employee.tellerno is '柜员号';
comment on column ${iol_schema}.hgls_gh_uus_employee.givenname is '员工姓名';
comment on column ${iol_schema}.hgls_gh_uus_employee.surname is '员工姓氏';
comment on column ${iol_schema}.hgls_gh_uus_employee.firstname is '英文名字';
comment on column ${iol_schema}.hgls_gh_uus_employee.lastname is '英文姓氏';
comment on column ${iol_schema}.hgls_gh_uus_employee.idtype is '证件类型';
comment on column ${iol_schema}.hgls_gh_uus_employee.idcode is '证件号码';
comment on column ${iol_schema}.hgls_gh_uus_employee.sex is '员工性别';
comment on column ${iol_schema}.hgls_gh_uus_employee.birthdate is '员工出生日期';
comment on column ${iol_schema}.hgls_gh_uus_employee.ethnic is '民族';
comment on column ${iol_schema}.hgls_gh_uus_employee.politicface is '政治面貌';
comment on column ${iol_schema}.hgls_gh_uus_employee.marriage is '婚姻状况';
comment on column ${iol_schema}.hgls_gh_uus_employee.education is '员工学历';
comment on column ${iol_schema}.hgls_gh_uus_employee.jobdate is '参加工作日期';
comment on column ${iol_schema}.hgls_gh_uus_employee.picturepath is '柜员图片路径';
comment on column ${iol_schema}.hgls_gh_uus_employee.emptype is '员工类型';
comment on column ${iol_schema}.hgls_gh_uus_employee.organcode is '所属部门编号';
comment on column ${iol_schema}.hgls_gh_uus_employee.titlecode is '职称';
comment on column ${iol_schema}.hgls_gh_uus_employee.place is '职位';
comment on column ${iol_schema}.hgls_gh_uus_employee.managertype is '客户经理标志';
comment on column ${iol_schema}.hgls_gh_uus_employee.managerlevel is '客户经理级别';
comment on column ${iol_schema}.hgls_gh_uus_employee.tellerlevel is '柜员级别';
comment on column ${iol_schema}.hgls_gh_uus_employee.tellermanagerid is '旧柜员号';
comment on column ${iol_schema}.hgls_gh_uus_employee.attachorgan is '柜员所属机构';
comment on column ${iol_schema}.hgls_gh_uus_employee.theentrydate is '员工入职日期';
comment on column ${iol_schema}.hgls_gh_uus_employee.leaveofficedate is '离职日期';
comment on column ${iol_schema}.hgls_gh_uus_employee.status is '员工状态代码';
comment on column ${iol_schema}.hgls_gh_uus_employee.sysstatus is '用户系统状态';
comment on column ${iol_schema}.hgls_gh_uus_employee.fixcountrycode is '传真国际区号';
comment on column ${iol_schema}.hgls_gh_uus_employee.fixareacode is '传真国内区号';
comment on column ${iol_schema}.hgls_gh_uus_employee.fixphone is '传真';
comment on column ${iol_schema}.hgls_gh_uus_employee.fixsubphone is '传真分机号';
comment on column ${iol_schema}.hgls_gh_uus_employee.companycountrycode is '单位电话国际区号';
comment on column ${iol_schema}.hgls_gh_uus_employee.companyareacode is '单位电话国内区号';
comment on column ${iol_schema}.hgls_gh_uus_employee.companyphone is '单位电话';
comment on column ${iol_schema}.hgls_gh_uus_employee.companysubphone is '单位电话分机号';
comment on column ${iol_schema}.hgls_gh_uus_employee.housecountrycode is '住宅电话国际区号';
comment on column ${iol_schema}.hgls_gh_uus_employee.houseareacode is '住宅电话国内区号';
comment on column ${iol_schema}.hgls_gh_uus_employee.homephone is '住宅电话';
comment on column ${iol_schema}.hgls_gh_uus_employee.housesubphone is '住宅电话分机号';
comment on column ${iol_schema}.hgls_gh_uus_employee.mobile is '联系电话';
comment on column ${iol_schema}.hgls_gh_uus_employee.mobile1 is '移动电话1';
comment on column ${iol_schema}.hgls_gh_uus_employee.mobile2 is '移动电话2';
comment on column ${iol_schema}.hgls_gh_uus_employee.mobile3 is '移动电话3';
comment on column ${iol_schema}.hgls_gh_uus_employee.post is '邮政编码';
comment on column ${iol_schema}.hgls_gh_uus_employee.country is '所在国家';
comment on column ${iol_schema}.hgls_gh_uus_employee.province is '所在省/州';
comment on column ${iol_schema}.hgls_gh_uus_employee.city is '所在城市';
comment on column ${iol_schema}.hgls_gh_uus_employee.county is '县/区代码';
comment on column ${iol_schema}.hgls_gh_uus_employee.address is '详细地址';
comment on column ${iol_schema}.hgls_gh_uus_employee.email is '电子邮箱';
comment on column ${iol_schema}.hgls_gh_uus_employee.sallevel is '薪资级别';
comment on column ${iol_schema}.hgls_gh_uus_employee.orderno is '序号';
comment on column ${iol_schema}.hgls_gh_uus_employee.partorgancode is '兼职所在部门编号';
comment on column ${iol_schema}.hgls_gh_uus_employee.partplace is '';
comment on column ${iol_schema}.hgls_gh_uus_employee.hsorgancode is '虚拟核算部门编号';
comment on column ${iol_schema}.hgls_gh_uus_employee.parttellerno is '兼职柜员号';
comment on column ${iol_schema}.hgls_gh_uus_employee.parttellerattachorgan is '兼职柜员所属机构';
comment on column ${iol_schema}.hgls_gh_uus_employee.subsidydate is '补贴正式发放日期';
comment on column ${iol_schema}.hgls_gh_uus_employee.userid is '钉钉UserID';
comment on column ${iol_schema}.hgls_gh_uus_employee.placehr is 'HR职务编码(HR更新）';
comment on column ${iol_schema}.hgls_gh_uus_employee.jobcategory is '(职务类别)员工职务代码';
comment on column ${iol_schema}.hgls_gh_uus_employee.jobcategoryname is '职务类别名称HR';
comment on column ${iol_schema}.hgls_gh_uus_employee.start_dt is '开始时间';
comment on column ${iol_schema}.hgls_gh_uus_employee.end_dt is '结束时间';
comment on column ${iol_schema}.hgls_gh_uus_employee.id_mark is '增删标志';
comment on column ${iol_schema}.hgls_gh_uus_employee.etl_timestamp is 'ETL处理时间戳';
