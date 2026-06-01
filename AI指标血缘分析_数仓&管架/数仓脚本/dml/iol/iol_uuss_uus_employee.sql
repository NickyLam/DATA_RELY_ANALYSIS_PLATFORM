/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uuss_uus_employee
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.uuss_uus_employee_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.uuss_uus_employee
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uuss_uus_employee_op purge;
drop table ${iol_schema}.uuss_uus_employee_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uuss_uus_employee_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uuss_uus_employee where 0=1;

create table ${iol_schema}.uuss_uus_employee_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uuss_uus_employee where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uuss_uus_employee_cl(
            employeeid -- 员工编号
            ,domainid -- 域帐号
            ,tellerno -- 柜员号
            ,givenname -- 名字
            ,surname -- 姓氏
            ,firstname -- 英文名字
            ,lastname -- 英文姓氏
            ,idtype -- 证件类型
            ,idcode -- 证件号码
            ,sex -- 性别
            ,birthdate -- 出生日期
            ,ethnic -- 民族
            ,politicface -- 政治面貌
            ,marriage -- 婚姻状况
            ,education -- 学历
            ,jobdate -- 参加工作日期
            ,picturepath -- 柜员图片路径
            ,emptype -- 员工类型
            ,organcode -- 所在部门编号
            ,titlecode -- 职称
            ,place -- 职位
            ,managertype -- 客户经理标志
            ,managerlevel -- 客户经理级别
            ,tellerlevel -- 柜员级别
            ,tellermanagerid -- 柜员主管编号
            ,attachorgan -- 柜员所属机构
            ,theentrydate -- 入职日期
            ,leaveofficedate -- 离职日期
            ,status -- 员工状态
            ,sysstatus -- 用户系统状态
            ,fixcountrycode -- 传真国际区号
            ,fixareacode -- 传真国内区号
            ,fixphone -- 传真
            ,fixsubphone -- 传真分机号
            ,companycountrycode -- 单位电话国际区号
            ,companyareacode -- 单位电话国内区号
            ,companyphone -- 单位电话
            ,companysubphone -- 单位电话分机号
            ,housecountrycode -- 住宅电话国际区号
            ,houseareacode -- 住宅电话国内区号
            ,homephone -- 住宅电话
            ,housesubphone -- 住宅电话分机号
            ,mobile -- 移动电话
            ,mobile1 -- 移动电话1
            ,mobile2 -- 移动电话2
            ,mobile3 -- 移动电话3
            ,post -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 县/区代码
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,sallevel -- 薪资级别
            ,orderno -- 显示顺序号
            ,hsorgancode -- 虚拟核算部门编号
            ,updatedate -- 更新日期
            ,subsidydate -- 补贴正式发放日期
            ,userid -- 钉钉UserID
            ,placehr -- 职务
            ,jobcategory -- （职务类别）员工职务代码
            ,tellerstatus -- 柜员状态
            ,leavestatus -- 离职审批中（在岗）2-离职审批中（不在岗）职审批状态(1-离职审批中（在岗）2-离职审批中（不在岗）)
            ,postnum -- 具体岗位编号
            ,postdesc -- 具体岗位描述
            ,posttype -- 岗位类别
            ,postname -- 岗位名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uuss_uus_employee_op(
            employeeid -- 员工编号
            ,domainid -- 域帐号
            ,tellerno -- 柜员号
            ,givenname -- 名字
            ,surname -- 姓氏
            ,firstname -- 英文名字
            ,lastname -- 英文姓氏
            ,idtype -- 证件类型
            ,idcode -- 证件号码
            ,sex -- 性别
            ,birthdate -- 出生日期
            ,ethnic -- 民族
            ,politicface -- 政治面貌
            ,marriage -- 婚姻状况
            ,education -- 学历
            ,jobdate -- 参加工作日期
            ,picturepath -- 柜员图片路径
            ,emptype -- 员工类型
            ,organcode -- 所在部门编号
            ,titlecode -- 职称
            ,place -- 职位
            ,managertype -- 客户经理标志
            ,managerlevel -- 客户经理级别
            ,tellerlevel -- 柜员级别
            ,tellermanagerid -- 柜员主管编号
            ,attachorgan -- 柜员所属机构
            ,theentrydate -- 入职日期
            ,leaveofficedate -- 离职日期
            ,status -- 员工状态
            ,sysstatus -- 用户系统状态
            ,fixcountrycode -- 传真国际区号
            ,fixareacode -- 传真国内区号
            ,fixphone -- 传真
            ,fixsubphone -- 传真分机号
            ,companycountrycode -- 单位电话国际区号
            ,companyareacode -- 单位电话国内区号
            ,companyphone -- 单位电话
            ,companysubphone -- 单位电话分机号
            ,housecountrycode -- 住宅电话国际区号
            ,houseareacode -- 住宅电话国内区号
            ,homephone -- 住宅电话
            ,housesubphone -- 住宅电话分机号
            ,mobile -- 移动电话
            ,mobile1 -- 移动电话1
            ,mobile2 -- 移动电话2
            ,mobile3 -- 移动电话3
            ,post -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 县/区代码
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,sallevel -- 薪资级别
            ,orderno -- 显示顺序号
            ,hsorgancode -- 虚拟核算部门编号
            ,updatedate -- 更新日期
            ,subsidydate -- 补贴正式发放日期
            ,userid -- 钉钉UserID
            ,placehr -- 职务
            ,jobcategory -- （职务类别）员工职务代码
            ,tellerstatus -- 柜员状态
            ,leavestatus -- 离职审批中（在岗）2-离职审批中（不在岗）职审批状态(1-离职审批中（在岗）2-离职审批中（不在岗）)
            ,postnum -- 具体岗位编号
            ,postdesc -- 具体岗位描述
            ,posttype -- 岗位类别
            ,postname -- 岗位名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.employeeid, o.employeeid) as employeeid -- 员工编号
    ,nvl(n.domainid, o.domainid) as domainid -- 域帐号
    ,nvl(n.tellerno, o.tellerno) as tellerno -- 柜员号
    ,nvl(n.givenname, o.givenname) as givenname -- 名字
    ,nvl(n.surname, o.surname) as surname -- 姓氏
    ,nvl(n.firstname, o.firstname) as firstname -- 英文名字
    ,nvl(n.lastname, o.lastname) as lastname -- 英文姓氏
    ,nvl(n.idtype, o.idtype) as idtype -- 证件类型
    ,nvl(n.idcode, o.idcode) as idcode -- 证件号码
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.birthdate, o.birthdate) as birthdate -- 出生日期
    ,nvl(n.ethnic, o.ethnic) as ethnic -- 民族
    ,nvl(n.politicface, o.politicface) as politicface -- 政治面貌
    ,nvl(n.marriage, o.marriage) as marriage -- 婚姻状况
    ,nvl(n.education, o.education) as education -- 学历
    ,nvl(n.jobdate, o.jobdate) as jobdate -- 参加工作日期
    ,nvl(n.picturepath, o.picturepath) as picturepath -- 柜员图片路径
    ,nvl(n.emptype, o.emptype) as emptype -- 员工类型
    ,nvl(n.organcode, o.organcode) as organcode -- 所在部门编号
    ,nvl(n.titlecode, o.titlecode) as titlecode -- 职称
    ,nvl(n.place, o.place) as place -- 职位
    ,nvl(n.managertype, o.managertype) as managertype -- 客户经理标志
    ,nvl(n.managerlevel, o.managerlevel) as managerlevel -- 客户经理级别
    ,nvl(n.tellerlevel, o.tellerlevel) as tellerlevel -- 柜员级别
    ,nvl(n.tellermanagerid, o.tellermanagerid) as tellermanagerid -- 柜员主管编号
    ,nvl(n.attachorgan, o.attachorgan) as attachorgan -- 柜员所属机构
    ,nvl(n.theentrydate, o.theentrydate) as theentrydate -- 入职日期
    ,nvl(n.leaveofficedate, o.leaveofficedate) as leaveofficedate -- 离职日期
    ,nvl(n.status, o.status) as status -- 员工状态
    ,nvl(n.sysstatus, o.sysstatus) as sysstatus -- 用户系统状态
    ,nvl(n.fixcountrycode, o.fixcountrycode) as fixcountrycode -- 传真国际区号
    ,nvl(n.fixareacode, o.fixareacode) as fixareacode -- 传真国内区号
    ,nvl(n.fixphone, o.fixphone) as fixphone -- 传真
    ,nvl(n.fixsubphone, o.fixsubphone) as fixsubphone -- 传真分机号
    ,nvl(n.companycountrycode, o.companycountrycode) as companycountrycode -- 单位电话国际区号
    ,nvl(n.companyareacode, o.companyareacode) as companyareacode -- 单位电话国内区号
    ,nvl(n.companyphone, o.companyphone) as companyphone -- 单位电话
    ,nvl(n.companysubphone, o.companysubphone) as companysubphone -- 单位电话分机号
    ,nvl(n.housecountrycode, o.housecountrycode) as housecountrycode -- 住宅电话国际区号
    ,nvl(n.houseareacode, o.houseareacode) as houseareacode -- 住宅电话国内区号
    ,nvl(n.homephone, o.homephone) as homephone -- 住宅电话
    ,nvl(n.housesubphone, o.housesubphone) as housesubphone -- 住宅电话分机号
    ,nvl(n.mobile, o.mobile) as mobile -- 移动电话
    ,nvl(n.mobile1, o.mobile1) as mobile1 -- 移动电话1
    ,nvl(n.mobile2, o.mobile2) as mobile2 -- 移动电话2
    ,nvl(n.mobile3, o.mobile3) as mobile3 -- 移动电话3
    ,nvl(n.post, o.post) as post -- 邮政编码
    ,nvl(n.country, o.country) as country -- 所在国家
    ,nvl(n.province, o.province) as province -- 所在省/州
    ,nvl(n.city, o.city) as city -- 所在城市
    ,nvl(n.county, o.county) as county -- 县/区代码
    ,nvl(n.address, o.address) as address -- 详细地址
    ,nvl(n.email, o.email) as email -- 电子邮箱
    ,nvl(n.sallevel, o.sallevel) as sallevel -- 薪资级别
    ,nvl(n.orderno, o.orderno) as orderno -- 显示顺序号
    ,nvl(n.hsorgancode, o.hsorgancode) as hsorgancode -- 虚拟核算部门编号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.subsidydate, o.subsidydate) as subsidydate -- 补贴正式发放日期
    ,nvl(n.userid, o.userid) as userid -- 钉钉UserID
    ,nvl(n.placehr, o.placehr) as placehr -- 职务
    ,nvl(n.jobcategory, o.jobcategory) as jobcategory -- （职务类别）员工职务代码
    ,nvl(n.tellerstatus, o.tellerstatus) as tellerstatus -- 柜员状态
    ,nvl(n.leavestatus, o.leavestatus) as leavestatus -- 离职审批中（在岗）2-离职审批中（不在岗）职审批状态(1-离职审批中（在岗）2-离职审批中（不在岗）)
    ,nvl(n.postnum, o.postnum) as postnum -- 具体岗位编号
    ,nvl(n.postdesc, o.postdesc) as postdesc -- 具体岗位描述
    ,nvl(n.posttype, o.posttype) as posttype -- 岗位类别
    ,nvl(n.postname, o.postname) as postname -- 岗位名称
    ,case when
            n.employeeid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.employeeid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.employeeid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.uuss_uus_employee_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.uuss_uus_employee where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.employeeid = n.employeeid
where (
        o.employeeid is null
    )
    or (
        n.employeeid is null
    )
    or (
        o.domainid <> n.domainid
        or o.tellerno <> n.tellerno
        or o.givenname <> n.givenname
        or o.surname <> n.surname
        or o.firstname <> n.firstname
        or o.lastname <> n.lastname
        or o.idtype <> n.idtype
        or o.idcode <> n.idcode
        or o.sex <> n.sex
        or o.birthdate <> n.birthdate
        or o.ethnic <> n.ethnic
        or o.politicface <> n.politicface
        or o.marriage <> n.marriage
        or o.education <> n.education
        or o.jobdate <> n.jobdate
        or o.picturepath <> n.picturepath
        or o.emptype <> n.emptype
        or o.organcode <> n.organcode
        or o.titlecode <> n.titlecode
        or o.place <> n.place
        or o.managertype <> n.managertype
        or o.managerlevel <> n.managerlevel
        or o.tellerlevel <> n.tellerlevel
        or o.tellermanagerid <> n.tellermanagerid
        or o.attachorgan <> n.attachorgan
        or o.theentrydate <> n.theentrydate
        or o.leaveofficedate <> n.leaveofficedate
        or o.status <> n.status
        or o.sysstatus <> n.sysstatus
        or o.fixcountrycode <> n.fixcountrycode
        or o.fixareacode <> n.fixareacode
        or o.fixphone <> n.fixphone
        or o.fixsubphone <> n.fixsubphone
        or o.companycountrycode <> n.companycountrycode
        or o.companyareacode <> n.companyareacode
        or o.companyphone <> n.companyphone
        or o.companysubphone <> n.companysubphone
        or o.housecountrycode <> n.housecountrycode
        or o.houseareacode <> n.houseareacode
        or o.homephone <> n.homephone
        or o.housesubphone <> n.housesubphone
        or o.mobile <> n.mobile
        or o.mobile1 <> n.mobile1
        or o.mobile2 <> n.mobile2
        or o.mobile3 <> n.mobile3
        or o.post <> n.post
        or o.country <> n.country
        or o.province <> n.province
        or o.city <> n.city
        or o.county <> n.county
        or o.address <> n.address
        or o.email <> n.email
        or o.sallevel <> n.sallevel
        or o.orderno <> n.orderno
        or o.hsorgancode <> n.hsorgancode
        or o.updatedate <> n.updatedate
        or o.subsidydate <> n.subsidydate
        or o.userid <> n.userid
        or o.placehr <> n.placehr
        or o.jobcategory <> n.jobcategory
        or o.tellerstatus <> n.tellerstatus
        or o.leavestatus <> n.leavestatus
        or o.postnum <> n.postnum
        or o.postdesc <> n.postdesc
        or o.posttype <> n.posttype
        or o.postname <> n.postname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uuss_uus_employee_cl(
            employeeid -- 员工编号
            ,domainid -- 域帐号
            ,tellerno -- 柜员号
            ,givenname -- 名字
            ,surname -- 姓氏
            ,firstname -- 英文名字
            ,lastname -- 英文姓氏
            ,idtype -- 证件类型
            ,idcode -- 证件号码
            ,sex -- 性别
            ,birthdate -- 出生日期
            ,ethnic -- 民族
            ,politicface -- 政治面貌
            ,marriage -- 婚姻状况
            ,education -- 学历
            ,jobdate -- 参加工作日期
            ,picturepath -- 柜员图片路径
            ,emptype -- 员工类型
            ,organcode -- 所在部门编号
            ,titlecode -- 职称
            ,place -- 职位
            ,managertype -- 客户经理标志
            ,managerlevel -- 客户经理级别
            ,tellerlevel -- 柜员级别
            ,tellermanagerid -- 柜员主管编号
            ,attachorgan -- 柜员所属机构
            ,theentrydate -- 入职日期
            ,leaveofficedate -- 离职日期
            ,status -- 员工状态
            ,sysstatus -- 用户系统状态
            ,fixcountrycode -- 传真国际区号
            ,fixareacode -- 传真国内区号
            ,fixphone -- 传真
            ,fixsubphone -- 传真分机号
            ,companycountrycode -- 单位电话国际区号
            ,companyareacode -- 单位电话国内区号
            ,companyphone -- 单位电话
            ,companysubphone -- 单位电话分机号
            ,housecountrycode -- 住宅电话国际区号
            ,houseareacode -- 住宅电话国内区号
            ,homephone -- 住宅电话
            ,housesubphone -- 住宅电话分机号
            ,mobile -- 移动电话
            ,mobile1 -- 移动电话1
            ,mobile2 -- 移动电话2
            ,mobile3 -- 移动电话3
            ,post -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 县/区代码
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,sallevel -- 薪资级别
            ,orderno -- 显示顺序号
            ,hsorgancode -- 虚拟核算部门编号
            ,updatedate -- 更新日期
            ,subsidydate -- 补贴正式发放日期
            ,userid -- 钉钉UserID
            ,placehr -- 职务
            ,jobcategory -- （职务类别）员工职务代码
            ,tellerstatus -- 柜员状态
            ,leavestatus -- 离职审批中（在岗）2-离职审批中（不在岗）职审批状态(1-离职审批中（在岗）2-离职审批中（不在岗）)
            ,postnum -- 具体岗位编号
            ,postdesc -- 具体岗位描述
            ,posttype -- 岗位类别
            ,postname -- 岗位名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uuss_uus_employee_op(
            employeeid -- 员工编号
            ,domainid -- 域帐号
            ,tellerno -- 柜员号
            ,givenname -- 名字
            ,surname -- 姓氏
            ,firstname -- 英文名字
            ,lastname -- 英文姓氏
            ,idtype -- 证件类型
            ,idcode -- 证件号码
            ,sex -- 性别
            ,birthdate -- 出生日期
            ,ethnic -- 民族
            ,politicface -- 政治面貌
            ,marriage -- 婚姻状况
            ,education -- 学历
            ,jobdate -- 参加工作日期
            ,picturepath -- 柜员图片路径
            ,emptype -- 员工类型
            ,organcode -- 所在部门编号
            ,titlecode -- 职称
            ,place -- 职位
            ,managertype -- 客户经理标志
            ,managerlevel -- 客户经理级别
            ,tellerlevel -- 柜员级别
            ,tellermanagerid -- 柜员主管编号
            ,attachorgan -- 柜员所属机构
            ,theentrydate -- 入职日期
            ,leaveofficedate -- 离职日期
            ,status -- 员工状态
            ,sysstatus -- 用户系统状态
            ,fixcountrycode -- 传真国际区号
            ,fixareacode -- 传真国内区号
            ,fixphone -- 传真
            ,fixsubphone -- 传真分机号
            ,companycountrycode -- 单位电话国际区号
            ,companyareacode -- 单位电话国内区号
            ,companyphone -- 单位电话
            ,companysubphone -- 单位电话分机号
            ,housecountrycode -- 住宅电话国际区号
            ,houseareacode -- 住宅电话国内区号
            ,homephone -- 住宅电话
            ,housesubphone -- 住宅电话分机号
            ,mobile -- 移动电话
            ,mobile1 -- 移动电话1
            ,mobile2 -- 移动电话2
            ,mobile3 -- 移动电话3
            ,post -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 县/区代码
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,sallevel -- 薪资级别
            ,orderno -- 显示顺序号
            ,hsorgancode -- 虚拟核算部门编号
            ,updatedate -- 更新日期
            ,subsidydate -- 补贴正式发放日期
            ,userid -- 钉钉UserID
            ,placehr -- 职务
            ,jobcategory -- （职务类别）员工职务代码
            ,tellerstatus -- 柜员状态
            ,leavestatus -- 离职审批中（在岗）2-离职审批中（不在岗）职审批状态(1-离职审批中（在岗）2-离职审批中（不在岗）)
            ,postnum -- 具体岗位编号
            ,postdesc -- 具体岗位描述
            ,posttype -- 岗位类别
            ,postname -- 岗位名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.employeeid -- 员工编号
    ,o.domainid -- 域帐号
    ,o.tellerno -- 柜员号
    ,o.givenname -- 名字
    ,o.surname -- 姓氏
    ,o.firstname -- 英文名字
    ,o.lastname -- 英文姓氏
    ,o.idtype -- 证件类型
    ,o.idcode -- 证件号码
    ,o.sex -- 性别
    ,o.birthdate -- 出生日期
    ,o.ethnic -- 民族
    ,o.politicface -- 政治面貌
    ,o.marriage -- 婚姻状况
    ,o.education -- 学历
    ,o.jobdate -- 参加工作日期
    ,o.picturepath -- 柜员图片路径
    ,o.emptype -- 员工类型
    ,o.organcode -- 所在部门编号
    ,o.titlecode -- 职称
    ,o.place -- 职位
    ,o.managertype -- 客户经理标志
    ,o.managerlevel -- 客户经理级别
    ,o.tellerlevel -- 柜员级别
    ,o.tellermanagerid -- 柜员主管编号
    ,o.attachorgan -- 柜员所属机构
    ,o.theentrydate -- 入职日期
    ,o.leaveofficedate -- 离职日期
    ,o.status -- 员工状态
    ,o.sysstatus -- 用户系统状态
    ,o.fixcountrycode -- 传真国际区号
    ,o.fixareacode -- 传真国内区号
    ,o.fixphone -- 传真
    ,o.fixsubphone -- 传真分机号
    ,o.companycountrycode -- 单位电话国际区号
    ,o.companyareacode -- 单位电话国内区号
    ,o.companyphone -- 单位电话
    ,o.companysubphone -- 单位电话分机号
    ,o.housecountrycode -- 住宅电话国际区号
    ,o.houseareacode -- 住宅电话国内区号
    ,o.homephone -- 住宅电话
    ,o.housesubphone -- 住宅电话分机号
    ,o.mobile -- 移动电话
    ,o.mobile1 -- 移动电话1
    ,o.mobile2 -- 移动电话2
    ,o.mobile3 -- 移动电话3
    ,o.post -- 邮政编码
    ,o.country -- 所在国家
    ,o.province -- 所在省/州
    ,o.city -- 所在城市
    ,o.county -- 县/区代码
    ,o.address -- 详细地址
    ,o.email -- 电子邮箱
    ,o.sallevel -- 薪资级别
    ,o.orderno -- 显示顺序号
    ,o.hsorgancode -- 虚拟核算部门编号
    ,o.updatedate -- 更新日期
    ,o.subsidydate -- 补贴正式发放日期
    ,o.userid -- 钉钉UserID
    ,o.placehr -- 职务
    ,o.jobcategory -- （职务类别）员工职务代码
    ,o.tellerstatus -- 柜员状态
    ,o.leavestatus -- 离职审批中（在岗）2-离职审批中（不在岗）职审批状态(1-离职审批中（在岗）2-离职审批中（不在岗）)
    ,o.postnum -- 具体岗位编号
    ,o.postdesc -- 具体岗位描述
    ,o.posttype -- 岗位类别
    ,o.postname -- 岗位名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.uuss_uus_employee_bk o
    left join ${iol_schema}.uuss_uus_employee_op n
        on
            o.employeeid = n.employeeid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.uuss_uus_employee_cl d
        on
            o.employeeid = d.employeeid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.uuss_uus_employee;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('uuss_uus_employee') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.uuss_uus_employee drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.uuss_uus_employee add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.uuss_uus_employee exchange partition p_${batch_date} with table ${iol_schema}.uuss_uus_employee_cl;
alter table ${iol_schema}.uuss_uus_employee exchange partition p_20991231 with table ${iol_schema}.uuss_uus_employee_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uuss_uus_employee to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uuss_uus_employee_op purge;
drop table ${iol_schema}.uuss_uus_employee_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.uuss_uus_employee_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uuss_uus_employee',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
