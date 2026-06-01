/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_uuss_uus_employee
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_uuss_uus_employee drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_uuss_uus_employee add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_uuss_uus_employee (
etl_dt  --数据日期
,tellerno  --柜员号
,givenname  --名字
,surname  --姓氏
,firstname  --英文名字
,lastname  --英文姓氏
,idtype  --证件类型
,idcode  --证件号码
,sex  --性别
,birthdate  --出生日期
,ethnic  --民族
,politicface  --政治面貌
,marriage  --婚姻状况
,education  --学历
,jobdate  --参加工作日期
,picturepath  --柜员图片路径
,emptype  --员工类型
,organcode  --所在部门编号
,titlecode  --职称
,place  --职位
,managertype  --客户经理标志
,managerlevel  --客户经理级别
,tellerlevel  --柜员级别
,tellermanagerid  --柜员主管编号
,attachorgan  --柜员所属机构
,theentrydate  --入职日期
,leaveofficedate  --离职日期
,status  --员工状态
,sysstatus  --用户系统状态
,fixcountrycode  --传真国际区号
,fixareacode  --传真国内区号
,fixphone  --传真
,fixsubphone  --传真分机号
,companycountrycode  --单位电话国际区号
,companyareacode  --单位电话国内区号
,companyphone  --单位电话
,companysubphone  --单位电话分机号
,housecountrycode  --住宅电话国际区号
,houseareacode  --住宅电话国内区号
,homephone  --住宅电话
,housesubphone  --住宅电话分机号
,mobile  --移动电话
,mobile1  --移动电话1
,mobile2  --移动电话2
,mobile3  --移动电话3
,post  --邮政编码
,country  --所在国家
,province  --所在省/州
,city  --所在城市
,county  --县/区代码
,address  --详细地址
,email  --电子邮箱
,sallevel  --薪资级别
,orderno  --显示顺序号
,hsorgancode  --虚拟核算部门编号
,updatedate  --更新日期
,subsidydate  --补贴正式发放日期
,userid  --钉钉UserID
,placehr  --职务
,jobcategory  --（职务类别）员工职务代码
,tellerstatus  --柜员状态
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,employeeid  --员工编号
,domainid  --域帐号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.tellerno,chr(13),''),chr(10),'') as tellerno --柜员号
,replace(replace(t1.givenname,chr(13),''),chr(10),'') as givenname --名字
,replace(replace(t1.surname,chr(13),''),chr(10),'') as surname --姓氏
,replace(replace(t1.firstname,chr(13),''),chr(10),'') as firstname --英文名字
,replace(replace(t1.lastname,chr(13),''),chr(10),'') as lastname --英文姓氏
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype --证件类型
,replace(replace(t1.idcode,chr(13),''),chr(10),'') as idcode --证件号码
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex --性别
,replace(replace(t1.birthdate,chr(13),''),chr(10),'') as birthdate --出生日期
,replace(replace(t1.ethnic,chr(13),''),chr(10),'') as ethnic --民族
,replace(replace(t1.politicface,chr(13),''),chr(10),'') as politicface --政治面貌
,replace(replace(t1.marriage,chr(13),''),chr(10),'') as marriage --婚姻状况
,replace(replace(t1.education,chr(13),''),chr(10),'') as education --学历
,replace(replace(t1.jobdate,chr(13),''),chr(10),'') as jobdate --参加工作日期
,replace(replace(t1.picturepath,chr(13),''),chr(10),'') as picturepath --柜员图片路径
,replace(replace(t1.emptype,chr(13),''),chr(10),'') as emptype --员工类型
,replace(replace(t1.organcode,chr(13),''),chr(10),'') as organcode --所在部门编号
,replace(replace(t1.titlecode,chr(13),''),chr(10),'') as titlecode --职称
,replace(replace(t1.place,chr(13),''),chr(10),'') as place --职位
,replace(replace(t1.managertype,chr(13),''),chr(10),'') as managertype --客户经理标志
,replace(replace(t1.managerlevel,chr(13),''),chr(10),'') as managerlevel --客户经理级别
,replace(replace(t1.tellerlevel,chr(13),''),chr(10),'') as tellerlevel --柜员级别
,replace(replace(t1.tellermanagerid,chr(13),''),chr(10),'') as tellermanagerid --柜员主管编号
,replace(replace(t1.attachorgan,chr(13),''),chr(10),'') as attachorgan --柜员所属机构
,replace(replace(t1.theentrydate,chr(13),''),chr(10),'') as theentrydate --入职日期
,replace(replace(t1.leaveofficedate,chr(13),''),chr(10),'') as leaveofficedate --离职日期
,replace(replace(t1.status,chr(13),''),chr(10),'') as status --员工状态
,replace(replace(t1.sysstatus,chr(13),''),chr(10),'') as sysstatus --用户系统状态
,replace(replace(t1.fixcountrycode,chr(13),''),chr(10),'') as fixcountrycode --传真国际区号
,replace(replace(t1.fixareacode,chr(13),''),chr(10),'') as fixareacode --传真国内区号
,replace(replace(t1.fixphone,chr(13),''),chr(10),'') as fixphone --传真
,replace(replace(t1.fixsubphone,chr(13),''),chr(10),'') as fixsubphone --传真分机号
,replace(replace(t1.companycountrycode,chr(13),''),chr(10),'') as companycountrycode --单位电话国际区号
,replace(replace(t1.companyareacode,chr(13),''),chr(10),'') as companyareacode --单位电话国内区号
,replace(replace(t1.companyphone,chr(13),''),chr(10),'') as companyphone --单位电话
,replace(replace(t1.companysubphone,chr(13),''),chr(10),'') as companysubphone --单位电话分机号
,replace(replace(t1.housecountrycode,chr(13),''),chr(10),'') as housecountrycode --住宅电话国际区号
,replace(replace(t1.houseareacode,chr(13),''),chr(10),'') as houseareacode --住宅电话国内区号
,replace(replace(t1.homephone,chr(13),''),chr(10),'') as homephone --住宅电话
,replace(replace(t1.housesubphone,chr(13),''),chr(10),'') as housesubphone --住宅电话分机号
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile --移动电话
,replace(replace(t1.mobile1,chr(13),''),chr(10),'') as mobile1 --移动电话1
,replace(replace(t1.mobile2,chr(13),''),chr(10),'') as mobile2 --移动电话2
,replace(replace(t1.mobile3,chr(13),''),chr(10),'') as mobile3 --移动电话3
,replace(replace(t1.post,chr(13),''),chr(10),'') as post --邮政编码
,replace(replace(t1.country,chr(13),''),chr(10),'') as country --所在国家
,replace(replace(t1.province,chr(13),''),chr(10),'') as province --所在省/州
,replace(replace(t1.city,chr(13),''),chr(10),'') as city --所在城市
,replace(replace(t1.county,chr(13),''),chr(10),'') as county --县/区代码
,replace(replace(t1.address,chr(13),''),chr(10),'') as address --详细地址
,replace(replace(t1.email,chr(13),''),chr(10),'') as email --电子邮箱
,replace(replace(t1.sallevel,chr(13),''),chr(10),'') as sallevel --薪资级别
,replace(replace(t1.orderno,chr(13),''),chr(10),'') as orderno --显示顺序号
,replace(replace(t1.hsorgancode,chr(13),''),chr(10),'') as hsorgancode --虚拟核算部门编号
,replace(replace(t1.updatedate,chr(13),''),chr(10),'') as updatedate --更新日期
,replace(replace(t1.subsidydate,chr(13),''),chr(10),'') as subsidydate --补贴正式发放日期
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid --钉钉UserID
,replace(replace(t1.placehr,chr(13),''),chr(10),'') as placehr --职务
,replace(replace(t1.jobcategory,chr(13),''),chr(10),'') as jobcategory --（职务类别）员工职务代码
,replace(replace(t1.tellerstatus,chr(13),''),chr(10),'') as tellerstatus --柜员状态
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.employeeid,chr(13),''),chr(10),'') as employeeid --员工编号
,replace(replace(t1.domainid,chr(13),''),chr(10),'') as domainid --域帐号
from ${iol_schema}.uuss_uus_employee t1    --员工信息表
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_uuss_uus_employee',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
