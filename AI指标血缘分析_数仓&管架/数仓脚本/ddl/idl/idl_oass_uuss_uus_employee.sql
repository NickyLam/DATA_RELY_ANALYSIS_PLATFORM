/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_uuss_uus_employee
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_uuss_uus_employee purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_uuss_uus_employee(
etl_dt date --数据日期
,tellerno varchar2(8) --柜员号
,givenname varchar2(300) --名字
,surname varchar2(300) --姓氏
,firstname varchar2(75) --英文名字
,lastname varchar2(75) --英文姓氏
,idtype varchar2(6) --证件类型
,idcode varchar2(60) --证件号码
,sex varchar2(1) --性别
,birthdate varchar2(8) --出生日期
,ethnic varchar2(6) --民族
,politicface varchar2(3) --政治面貌
,marriage varchar2(3) --婚姻状况
,education varchar2(3) --学历
,jobdate varchar2(8) --参加工作日期
,picturepath varchar2(383) --柜员图片路径
,emptype varchar2(1) --员工类型
,organcode varchar2(12) --所在部门编号
,titlecode varchar2(3) --职称
,place varchar2(75) --职位
,managertype varchar2(1) --客户经理标志
,managerlevel varchar2(3) --客户经理级别
,tellerlevel varchar2(3) --柜员级别
,tellermanagerid varchar2(6) --柜员主管编号
,attachorgan varchar2(18) --柜员所属机构
,theentrydate varchar2(8) --入职日期
,leaveofficedate varchar2(8) --离职日期
,status varchar2(1) --员工状态
,sysstatus varchar2(1) --用户系统状态
,fixcountrycode varchar2(4) --传真国际区号
,fixareacode varchar2(4) --传真国内区号
,fixphone varchar2(17) --传真
,fixsubphone varchar2(6) --传真分机号
,companycountrycode varchar2(4) --单位电话国际区号
,companyareacode varchar2(4) --单位电话国内区号
,companyphone varchar2(45) --单位电话
,companysubphone varchar2(6) --单位电话分机号
,housecountrycode varchar2(4) --住宅电话国际区号
,houseareacode varchar2(4) --住宅电话国内区号
,homephone varchar2(17) --住宅电话
,housesubphone varchar2(6) --住宅电话分机号
,mobile varchar2(45) --移动电话
,mobile1 varchar2(17) --移动电话1
,mobile2 varchar2(17) --移动电话2
,mobile3 varchar2(17) --移动电话3
,post varchar2(9) --邮政编码
,country varchar2(5) --所在国家
,province varchar2(9) --所在省/州
,city varchar2(9) --所在城市
,county varchar2(6) --县/区代码
,address varchar2(383) --详细地址
,email varchar2(150) --电子邮箱
,sallevel varchar2(5) --薪资级别
,orderno varchar2(12) --显示顺序号
,hsorgancode varchar2(12) --虚拟核算部门编号
,updatedate varchar2(8) --更新日期
,subsidydate varchar2(8) --补贴正式发放日期
,userid varchar2(48) --钉钉UserID
,placehr varchar2(75) --职务
,jobcategory varchar2(7) --（职务类别）员工职务代码
,tellerstatus varchar2(3) --柜员状态
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,employeeid varchar2(8) --员工编号
,domainid varchar2(20) --域帐号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_uuss_uus_employee to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_uuss_uus_employee is '员工信息表';
comment on column ${idl_schema}.oass_uuss_uus_employee.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_uuss_uus_employee.tellerno is '柜员号';
comment on column ${idl_schema}.oass_uuss_uus_employee.givenname is '名字';
comment on column ${idl_schema}.oass_uuss_uus_employee.surname is '姓氏';
comment on column ${idl_schema}.oass_uuss_uus_employee.firstname is '英文名字';
comment on column ${idl_schema}.oass_uuss_uus_employee.lastname is '英文姓氏';
comment on column ${idl_schema}.oass_uuss_uus_employee.idtype is '证件类型';
comment on column ${idl_schema}.oass_uuss_uus_employee.idcode is '证件号码';
comment on column ${idl_schema}.oass_uuss_uus_employee.sex is '性别';
comment on column ${idl_schema}.oass_uuss_uus_employee.birthdate is '出生日期';
comment on column ${idl_schema}.oass_uuss_uus_employee.ethnic is '民族';
comment on column ${idl_schema}.oass_uuss_uus_employee.politicface is '政治面貌';
comment on column ${idl_schema}.oass_uuss_uus_employee.marriage is '婚姻状况';
comment on column ${idl_schema}.oass_uuss_uus_employee.education is '学历';
comment on column ${idl_schema}.oass_uuss_uus_employee.jobdate is '参加工作日期';
comment on column ${idl_schema}.oass_uuss_uus_employee.picturepath is '柜员图片路径';
comment on column ${idl_schema}.oass_uuss_uus_employee.emptype is '员工类型';
comment on column ${idl_schema}.oass_uuss_uus_employee.organcode is '所在部门编号';
comment on column ${idl_schema}.oass_uuss_uus_employee.titlecode is '职称';
comment on column ${idl_schema}.oass_uuss_uus_employee.place is '职位';
comment on column ${idl_schema}.oass_uuss_uus_employee.managertype is '客户经理标志';
comment on column ${idl_schema}.oass_uuss_uus_employee.managerlevel is '客户经理级别';
comment on column ${idl_schema}.oass_uuss_uus_employee.tellerlevel is '柜员级别';
comment on column ${idl_schema}.oass_uuss_uus_employee.tellermanagerid is '柜员主管编号';
comment on column ${idl_schema}.oass_uuss_uus_employee.attachorgan is '柜员所属机构';
comment on column ${idl_schema}.oass_uuss_uus_employee.theentrydate is '入职日期';
comment on column ${idl_schema}.oass_uuss_uus_employee.leaveofficedate is '离职日期';
comment on column ${idl_schema}.oass_uuss_uus_employee.status is '员工状态';
comment on column ${idl_schema}.oass_uuss_uus_employee.sysstatus is '用户系统状态';
comment on column ${idl_schema}.oass_uuss_uus_employee.fixcountrycode is '传真国际区号';
comment on column ${idl_schema}.oass_uuss_uus_employee.fixareacode is '传真国内区号';
comment on column ${idl_schema}.oass_uuss_uus_employee.fixphone is '传真';
comment on column ${idl_schema}.oass_uuss_uus_employee.fixsubphone is '传真分机号';
comment on column ${idl_schema}.oass_uuss_uus_employee.companycountrycode is '单位电话国际区号';
comment on column ${idl_schema}.oass_uuss_uus_employee.companyareacode is '单位电话国内区号';
comment on column ${idl_schema}.oass_uuss_uus_employee.companyphone is '单位电话';
comment on column ${idl_schema}.oass_uuss_uus_employee.companysubphone is '单位电话分机号';
comment on column ${idl_schema}.oass_uuss_uus_employee.housecountrycode is '住宅电话国际区号';
comment on column ${idl_schema}.oass_uuss_uus_employee.houseareacode is '住宅电话国内区号';
comment on column ${idl_schema}.oass_uuss_uus_employee.homephone is '住宅电话';
comment on column ${idl_schema}.oass_uuss_uus_employee.housesubphone is '住宅电话分机号';
comment on column ${idl_schema}.oass_uuss_uus_employee.mobile is '移动电话';
comment on column ${idl_schema}.oass_uuss_uus_employee.mobile1 is '移动电话1';
comment on column ${idl_schema}.oass_uuss_uus_employee.mobile2 is '移动电话2';
comment on column ${idl_schema}.oass_uuss_uus_employee.mobile3 is '移动电话3';
comment on column ${idl_schema}.oass_uuss_uus_employee.post is '邮政编码';
comment on column ${idl_schema}.oass_uuss_uus_employee.country is '所在国家';
comment on column ${idl_schema}.oass_uuss_uus_employee.province is '所在省/州';
comment on column ${idl_schema}.oass_uuss_uus_employee.city is '所在城市';
comment on column ${idl_schema}.oass_uuss_uus_employee.county is '县/区代码';
comment on column ${idl_schema}.oass_uuss_uus_employee.address is '详细地址';
comment on column ${idl_schema}.oass_uuss_uus_employee.email is '电子邮箱';
comment on column ${idl_schema}.oass_uuss_uus_employee.sallevel is '薪资级别';
comment on column ${idl_schema}.oass_uuss_uus_employee.orderno is '显示顺序号';
comment on column ${idl_schema}.oass_uuss_uus_employee.hsorgancode is '虚拟核算部门编号';
comment on column ${idl_schema}.oass_uuss_uus_employee.updatedate is '更新日期';
comment on column ${idl_schema}.oass_uuss_uus_employee.subsidydate is '补贴正式发放日期';
comment on column ${idl_schema}.oass_uuss_uus_employee.userid is '钉钉UserID';
comment on column ${idl_schema}.oass_uuss_uus_employee.placehr is '职务';
comment on column ${idl_schema}.oass_uuss_uus_employee.jobcategory is '（职务类别）员工职务代码';
comment on column ${idl_schema}.oass_uuss_uus_employee.tellerstatus is '柜员状态';
comment on column ${idl_schema}.oass_uuss_uus_employee.start_dt is '开始时间';
comment on column ${idl_schema}.oass_uuss_uus_employee.end_dt is '结束时间';
comment on column ${idl_schema}.oass_uuss_uus_employee.id_mark is '增删标志';
comment on column ${idl_schema}.oass_uuss_uus_employee.employeeid is '员工编号';
comment on column ${idl_schema}.oass_uuss_uus_employee.domainid is '域帐号';

