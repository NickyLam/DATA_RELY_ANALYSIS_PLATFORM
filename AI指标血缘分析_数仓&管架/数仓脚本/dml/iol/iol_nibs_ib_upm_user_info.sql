/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_ib_upm_user_info
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
create table ${iol_schema}.nibs_ib_upm_user_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nibs_ib_upm_user_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_upm_user_info_op purge;
drop table ${iol_schema}.nibs_ib_upm_user_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_upm_user_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_upm_user_info where 0=1;

create table ${iol_schema}.nibs_ib_upm_user_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_upm_user_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ib_upm_user_info_cl(
            usernum -- 用户编号
            ,branchnum -- 柜员所属机构号
            ,username -- 用户名称（姓名）
            ,certtype -- 证件类型
            ,certnum -- 证件号码
            ,gender -- 性别|0:未知的性别、1:男性、2:女性、9:未说明的性别
            ,contactnum -- 联系电话（住宅电话）
            ,phonenum -- 手机号码（移动电话）
            ,contactaddr -- 联系地址（详细地址）
            ,mailbox -- 邮箱（电子邮箱）
            ,nummisppwd -- 密码输错次数
            ,pichead -- 头像图片（柜员图片路径）
            ,userstatus -- 用户状态 : u-可使用；f-被冻结；l-被锁定；o-在线；d-已删除；s-已停用；h-休假中
            ,usergcerttp -- 认证方式【0密码、1指纹、2两者】-usergcerttp
            ,padgcerttp -- pad认证方式【0密码、1指纹、2两者】-padgcerttp
            ,logintime -- 登陆日期
            ,tellerno -- 柜员号
            ,employeeid -- 员工编号
            ,domainid -- 域帐号
            ,emptype -- 员工类型|1:正式行员、2:返聘人员、3:劳务派遣、4:实习生、5:外部机构人员、6:兼职行员、7:顾问、8:外包员工、1:正常、2:锁定、3:注销
            ,organcode -- 所在部门编号
            ,titlecode -- 职称|10:高级、11:正高级、12:副高级、20:中级、30:初级、31:员级、32:助理级、99:未知
            ,place -- 职位
            ,managertype -- 客户经理标志
            ,managerlevel -- 客户经理级别
            ,userlevel -- 柜员级别
            ,tellermanagerid -- 柜员旧柜员号
            ,status -- 员工状态|1:在职、2:离职、3:退休、4:内退、7:开除、8:死亡
            ,sysstatus -- 用户系统状态
            ,orderno -- 序号
            ,hsorgancode -- 虚拟核算部门编号
            ,placehr -- 职务
            ,surname -- 姓氏
            ,firstname -- 英文名字
            ,lastname -- 英文姓氏
            ,birthdate -- 出生日期
            ,ethnic -- 民族
            ,politicface -- 政治面貌
            ,marriage -- 婚姻状况
            ,education -- 学历
            ,jobdate -- 参加工作日期
            ,theentrydate -- 入职日期
            ,leaveofficedate -- 离职日期
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
            ,housesubphone -- 住宅电话分机号
            ,mobile1 -- 移动电话1
            ,mobile2 -- 移动电话2
            ,mobile3 -- 移动电话3
            ,post -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 县/区代码
            ,sallevel -- 薪资级别
            ,updatedate -- 最后修改时间
            ,subsidydate -- 补贴正式发放日期
            ,userid -- 钉钉userid
            ,branchsignstatus -- 机构签到状态（1签到 0-未签到 ）
            ,hightlowfalg -- 柜员高低柜标识 0-低柜 1-高柜
            ,userage -- 年龄
            ,serviceage -- 服务年龄（工龄）
            ,errorrate -- 差错率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ib_upm_user_info_op(
            usernum -- 用户编号
            ,branchnum -- 柜员所属机构号
            ,username -- 用户名称（姓名）
            ,certtype -- 证件类型
            ,certnum -- 证件号码
            ,gender -- 性别|0:未知的性别、1:男性、2:女性、9:未说明的性别
            ,contactnum -- 联系电话（住宅电话）
            ,phonenum -- 手机号码（移动电话）
            ,contactaddr -- 联系地址（详细地址）
            ,mailbox -- 邮箱（电子邮箱）
            ,nummisppwd -- 密码输错次数
            ,pichead -- 头像图片（柜员图片路径）
            ,userstatus -- 用户状态 : u-可使用；f-被冻结；l-被锁定；o-在线；d-已删除；s-已停用；h-休假中
            ,usergcerttp -- 认证方式【0密码、1指纹、2两者】-usergcerttp
            ,padgcerttp -- pad认证方式【0密码、1指纹、2两者】-padgcerttp
            ,logintime -- 登陆日期
            ,tellerno -- 柜员号
            ,employeeid -- 员工编号
            ,domainid -- 域帐号
            ,emptype -- 员工类型|1:正式行员、2:返聘人员、3:劳务派遣、4:实习生、5:外部机构人员、6:兼职行员、7:顾问、8:外包员工、1:正常、2:锁定、3:注销
            ,organcode -- 所在部门编号
            ,titlecode -- 职称|10:高级、11:正高级、12:副高级、20:中级、30:初级、31:员级、32:助理级、99:未知
            ,place -- 职位
            ,managertype -- 客户经理标志
            ,managerlevel -- 客户经理级别
            ,userlevel -- 柜员级别
            ,tellermanagerid -- 柜员旧柜员号
            ,status -- 员工状态|1:在职、2:离职、3:退休、4:内退、7:开除、8:死亡
            ,sysstatus -- 用户系统状态
            ,orderno -- 序号
            ,hsorgancode -- 虚拟核算部门编号
            ,placehr -- 职务
            ,surname -- 姓氏
            ,firstname -- 英文名字
            ,lastname -- 英文姓氏
            ,birthdate -- 出生日期
            ,ethnic -- 民族
            ,politicface -- 政治面貌
            ,marriage -- 婚姻状况
            ,education -- 学历
            ,jobdate -- 参加工作日期
            ,theentrydate -- 入职日期
            ,leaveofficedate -- 离职日期
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
            ,housesubphone -- 住宅电话分机号
            ,mobile1 -- 移动电话1
            ,mobile2 -- 移动电话2
            ,mobile3 -- 移动电话3
            ,post -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 县/区代码
            ,sallevel -- 薪资级别
            ,updatedate -- 最后修改时间
            ,subsidydate -- 补贴正式发放日期
            ,userid -- 钉钉userid
            ,branchsignstatus -- 机构签到状态（1签到 0-未签到 ）
            ,hightlowfalg -- 柜员高低柜标识 0-低柜 1-高柜
            ,userage -- 年龄
            ,serviceage -- 服务年龄（工龄）
            ,errorrate -- 差错率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.usernum, o.usernum) as usernum -- 用户编号
    ,nvl(n.branchnum, o.branchnum) as branchnum -- 柜员所属机构号
    ,nvl(n.username, o.username) as username -- 用户名称（姓名）
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certnum, o.certnum) as certnum -- 证件号码
    ,nvl(n.gender, o.gender) as gender -- 性别|0:未知的性别、1:男性、2:女性、9:未说明的性别
    ,nvl(n.contactnum, o.contactnum) as contactnum -- 联系电话（住宅电话）
    ,nvl(n.phonenum, o.phonenum) as phonenum -- 手机号码（移动电话）
    ,nvl(n.contactaddr, o.contactaddr) as contactaddr -- 联系地址（详细地址）
    ,nvl(n.mailbox, o.mailbox) as mailbox -- 邮箱（电子邮箱）
    ,nvl(n.nummisppwd, o.nummisppwd) as nummisppwd -- 密码输错次数
    ,nvl(n.pichead, o.pichead) as pichead -- 头像图片（柜员图片路径）
    ,nvl(n.userstatus, o.userstatus) as userstatus -- 用户状态 : u-可使用；f-被冻结；l-被锁定；o-在线；d-已删除；s-已停用；h-休假中
    ,nvl(n.usergcerttp, o.usergcerttp) as usergcerttp -- 认证方式【0密码、1指纹、2两者】-usergcerttp
    ,nvl(n.padgcerttp, o.padgcerttp) as padgcerttp -- pad认证方式【0密码、1指纹、2两者】-padgcerttp
    ,nvl(n.logintime, o.logintime) as logintime -- 登陆日期
    ,nvl(n.tellerno, o.tellerno) as tellerno -- 柜员号
    ,nvl(n.employeeid, o.employeeid) as employeeid -- 员工编号
    ,nvl(n.domainid, o.domainid) as domainid -- 域帐号
    ,nvl(n.emptype, o.emptype) as emptype -- 员工类型|1:正式行员、2:返聘人员、3:劳务派遣、4:实习生、5:外部机构人员、6:兼职行员、7:顾问、8:外包员工、1:正常、2:锁定、3:注销
    ,nvl(n.organcode, o.organcode) as organcode -- 所在部门编号
    ,nvl(n.titlecode, o.titlecode) as titlecode -- 职称|10:高级、11:正高级、12:副高级、20:中级、30:初级、31:员级、32:助理级、99:未知
    ,nvl(n.place, o.place) as place -- 职位
    ,nvl(n.managertype, o.managertype) as managertype -- 客户经理标志
    ,nvl(n.managerlevel, o.managerlevel) as managerlevel -- 客户经理级别
    ,nvl(n.userlevel, o.userlevel) as userlevel -- 柜员级别
    ,nvl(n.tellermanagerid, o.tellermanagerid) as tellermanagerid -- 柜员旧柜员号
    ,nvl(n.status, o.status) as status -- 员工状态|1:在职、2:离职、3:退休、4:内退、7:开除、8:死亡
    ,nvl(n.sysstatus, o.sysstatus) as sysstatus -- 用户系统状态
    ,nvl(n.orderno, o.orderno) as orderno -- 序号
    ,nvl(n.hsorgancode, o.hsorgancode) as hsorgancode -- 虚拟核算部门编号
    ,nvl(n.placehr, o.placehr) as placehr -- 职务
    ,nvl(n.surname, o.surname) as surname -- 姓氏
    ,nvl(n.firstname, o.firstname) as firstname -- 英文名字
    ,nvl(n.lastname, o.lastname) as lastname -- 英文姓氏
    ,nvl(n.birthdate, o.birthdate) as birthdate -- 出生日期
    ,nvl(n.ethnic, o.ethnic) as ethnic -- 民族
    ,nvl(n.politicface, o.politicface) as politicface -- 政治面貌
    ,nvl(n.marriage, o.marriage) as marriage -- 婚姻状况
    ,nvl(n.education, o.education) as education -- 学历
    ,nvl(n.jobdate, o.jobdate) as jobdate -- 参加工作日期
    ,nvl(n.theentrydate, o.theentrydate) as theentrydate -- 入职日期
    ,nvl(n.leaveofficedate, o.leaveofficedate) as leaveofficedate -- 离职日期
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
    ,nvl(n.housesubphone, o.housesubphone) as housesubphone -- 住宅电话分机号
    ,nvl(n.mobile1, o.mobile1) as mobile1 -- 移动电话1
    ,nvl(n.mobile2, o.mobile2) as mobile2 -- 移动电话2
    ,nvl(n.mobile3, o.mobile3) as mobile3 -- 移动电话3
    ,nvl(n.post, o.post) as post -- 邮政编码
    ,nvl(n.country, o.country) as country -- 所在国家
    ,nvl(n.province, o.province) as province -- 所在省/州
    ,nvl(n.city, o.city) as city -- 所在城市
    ,nvl(n.county, o.county) as county -- 县/区代码
    ,nvl(n.sallevel, o.sallevel) as sallevel -- 薪资级别
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 最后修改时间
    ,nvl(n.subsidydate, o.subsidydate) as subsidydate -- 补贴正式发放日期
    ,nvl(n.userid, o.userid) as userid -- 钉钉userid
    ,nvl(n.branchsignstatus, o.branchsignstatus) as branchsignstatus -- 机构签到状态（1签到 0-未签到 ）
    ,nvl(n.hightlowfalg, o.hightlowfalg) as hightlowfalg -- 柜员高低柜标识 0-低柜 1-高柜
    ,nvl(n.userage, o.userage) as userage -- 年龄
    ,nvl(n.serviceage, o.serviceage) as serviceage -- 服务年龄（工龄）
    ,nvl(n.errorrate, o.errorrate) as errorrate -- 差错率
    ,case when
            n.usernum is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.usernum is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.usernum is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nibs_ib_upm_user_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nibs_ib_upm_user_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.usernum = n.usernum
where (
        o.usernum is null
    )
    or (
        n.usernum is null
    )
    or (
        o.branchnum <> n.branchnum
        or o.username <> n.username
        or o.certtype <> n.certtype
        or o.certnum <> n.certnum
        or o.gender <> n.gender
        or o.contactnum <> n.contactnum
        or o.phonenum <> n.phonenum
        or o.contactaddr <> n.contactaddr
        or o.mailbox <> n.mailbox
        or o.nummisppwd <> n.nummisppwd
        or o.pichead <> n.pichead
        or o.userstatus <> n.userstatus
        or o.usergcerttp <> n.usergcerttp
        or o.padgcerttp <> n.padgcerttp
        or o.logintime <> n.logintime
        or o.tellerno <> n.tellerno
        or o.employeeid <> n.employeeid
        or o.domainid <> n.domainid
        or o.emptype <> n.emptype
        or o.organcode <> n.organcode
        or o.titlecode <> n.titlecode
        or o.place <> n.place
        or o.managertype <> n.managertype
        or o.managerlevel <> n.managerlevel
        or o.userlevel <> n.userlevel
        or o.tellermanagerid <> n.tellermanagerid
        or o.status <> n.status
        or o.sysstatus <> n.sysstatus
        or o.orderno <> n.orderno
        or o.hsorgancode <> n.hsorgancode
        or o.placehr <> n.placehr
        or o.surname <> n.surname
        or o.firstname <> n.firstname
        or o.lastname <> n.lastname
        or o.birthdate <> n.birthdate
        or o.ethnic <> n.ethnic
        or o.politicface <> n.politicface
        or o.marriage <> n.marriage
        or o.education <> n.education
        or o.jobdate <> n.jobdate
        or o.theentrydate <> n.theentrydate
        or o.leaveofficedate <> n.leaveofficedate
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
        or o.housesubphone <> n.housesubphone
        or o.mobile1 <> n.mobile1
        or o.mobile2 <> n.mobile2
        or o.mobile3 <> n.mobile3
        or o.post <> n.post
        or o.country <> n.country
        or o.province <> n.province
        or o.city <> n.city
        or o.county <> n.county
        or o.sallevel <> n.sallevel
        or o.updatedate <> n.updatedate
        or o.subsidydate <> n.subsidydate
        or o.userid <> n.userid
        or o.branchsignstatus <> n.branchsignstatus
        or o.hightlowfalg <> n.hightlowfalg
        or o.userage <> n.userage
        or o.serviceage <> n.serviceage
        or o.errorrate <> n.errorrate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ib_upm_user_info_cl(
            usernum -- 用户编号
            ,branchnum -- 柜员所属机构号
            ,username -- 用户名称（姓名）
            ,certtype -- 证件类型
            ,certnum -- 证件号码
            ,gender -- 性别|0:未知的性别、1:男性、2:女性、9:未说明的性别
            ,contactnum -- 联系电话（住宅电话）
            ,phonenum -- 手机号码（移动电话）
            ,contactaddr -- 联系地址（详细地址）
            ,mailbox -- 邮箱（电子邮箱）
            ,nummisppwd -- 密码输错次数
            ,pichead -- 头像图片（柜员图片路径）
            ,userstatus -- 用户状态 : u-可使用；f-被冻结；l-被锁定；o-在线；d-已删除；s-已停用；h-休假中
            ,usergcerttp -- 认证方式【0密码、1指纹、2两者】-usergcerttp
            ,padgcerttp -- pad认证方式【0密码、1指纹、2两者】-padgcerttp
            ,logintime -- 登陆日期
            ,tellerno -- 柜员号
            ,employeeid -- 员工编号
            ,domainid -- 域帐号
            ,emptype -- 员工类型|1:正式行员、2:返聘人员、3:劳务派遣、4:实习生、5:外部机构人员、6:兼职行员、7:顾问、8:外包员工、1:正常、2:锁定、3:注销
            ,organcode -- 所在部门编号
            ,titlecode -- 职称|10:高级、11:正高级、12:副高级、20:中级、30:初级、31:员级、32:助理级、99:未知
            ,place -- 职位
            ,managertype -- 客户经理标志
            ,managerlevel -- 客户经理级别
            ,userlevel -- 柜员级别
            ,tellermanagerid -- 柜员旧柜员号
            ,status -- 员工状态|1:在职、2:离职、3:退休、4:内退、7:开除、8:死亡
            ,sysstatus -- 用户系统状态
            ,orderno -- 序号
            ,hsorgancode -- 虚拟核算部门编号
            ,placehr -- 职务
            ,surname -- 姓氏
            ,firstname -- 英文名字
            ,lastname -- 英文姓氏
            ,birthdate -- 出生日期
            ,ethnic -- 民族
            ,politicface -- 政治面貌
            ,marriage -- 婚姻状况
            ,education -- 学历
            ,jobdate -- 参加工作日期
            ,theentrydate -- 入职日期
            ,leaveofficedate -- 离职日期
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
            ,housesubphone -- 住宅电话分机号
            ,mobile1 -- 移动电话1
            ,mobile2 -- 移动电话2
            ,mobile3 -- 移动电话3
            ,post -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 县/区代码
            ,sallevel -- 薪资级别
            ,updatedate -- 最后修改时间
            ,subsidydate -- 补贴正式发放日期
            ,userid -- 钉钉userid
            ,branchsignstatus -- 机构签到状态（1签到 0-未签到 ）
            ,hightlowfalg -- 柜员高低柜标识 0-低柜 1-高柜
            ,userage -- 年龄
            ,serviceage -- 服务年龄（工龄）
            ,errorrate -- 差错率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ib_upm_user_info_op(
            usernum -- 用户编号
            ,branchnum -- 柜员所属机构号
            ,username -- 用户名称（姓名）
            ,certtype -- 证件类型
            ,certnum -- 证件号码
            ,gender -- 性别|0:未知的性别、1:男性、2:女性、9:未说明的性别
            ,contactnum -- 联系电话（住宅电话）
            ,phonenum -- 手机号码（移动电话）
            ,contactaddr -- 联系地址（详细地址）
            ,mailbox -- 邮箱（电子邮箱）
            ,nummisppwd -- 密码输错次数
            ,pichead -- 头像图片（柜员图片路径）
            ,userstatus -- 用户状态 : u-可使用；f-被冻结；l-被锁定；o-在线；d-已删除；s-已停用；h-休假中
            ,usergcerttp -- 认证方式【0密码、1指纹、2两者】-usergcerttp
            ,padgcerttp -- pad认证方式【0密码、1指纹、2两者】-padgcerttp
            ,logintime -- 登陆日期
            ,tellerno -- 柜员号
            ,employeeid -- 员工编号
            ,domainid -- 域帐号
            ,emptype -- 员工类型|1:正式行员、2:返聘人员、3:劳务派遣、4:实习生、5:外部机构人员、6:兼职行员、7:顾问、8:外包员工、1:正常、2:锁定、3:注销
            ,organcode -- 所在部门编号
            ,titlecode -- 职称|10:高级、11:正高级、12:副高级、20:中级、30:初级、31:员级、32:助理级、99:未知
            ,place -- 职位
            ,managertype -- 客户经理标志
            ,managerlevel -- 客户经理级别
            ,userlevel -- 柜员级别
            ,tellermanagerid -- 柜员旧柜员号
            ,status -- 员工状态|1:在职、2:离职、3:退休、4:内退、7:开除、8:死亡
            ,sysstatus -- 用户系统状态
            ,orderno -- 序号
            ,hsorgancode -- 虚拟核算部门编号
            ,placehr -- 职务
            ,surname -- 姓氏
            ,firstname -- 英文名字
            ,lastname -- 英文姓氏
            ,birthdate -- 出生日期
            ,ethnic -- 民族
            ,politicface -- 政治面貌
            ,marriage -- 婚姻状况
            ,education -- 学历
            ,jobdate -- 参加工作日期
            ,theentrydate -- 入职日期
            ,leaveofficedate -- 离职日期
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
            ,housesubphone -- 住宅电话分机号
            ,mobile1 -- 移动电话1
            ,mobile2 -- 移动电话2
            ,mobile3 -- 移动电话3
            ,post -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 县/区代码
            ,sallevel -- 薪资级别
            ,updatedate -- 最后修改时间
            ,subsidydate -- 补贴正式发放日期
            ,userid -- 钉钉userid
            ,branchsignstatus -- 机构签到状态（1签到 0-未签到 ）
            ,hightlowfalg -- 柜员高低柜标识 0-低柜 1-高柜
            ,userage -- 年龄
            ,serviceage -- 服务年龄（工龄）
            ,errorrate -- 差错率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.usernum -- 用户编号
    ,o.branchnum -- 柜员所属机构号
    ,o.username -- 用户名称（姓名）
    ,o.certtype -- 证件类型
    ,o.certnum -- 证件号码
    ,o.gender -- 性别|0:未知的性别、1:男性、2:女性、9:未说明的性别
    ,o.contactnum -- 联系电话（住宅电话）
    ,o.phonenum -- 手机号码（移动电话）
    ,o.contactaddr -- 联系地址（详细地址）
    ,o.mailbox -- 邮箱（电子邮箱）
    ,o.nummisppwd -- 密码输错次数
    ,o.pichead -- 头像图片（柜员图片路径）
    ,o.userstatus -- 用户状态 : u-可使用；f-被冻结；l-被锁定；o-在线；d-已删除；s-已停用；h-休假中
    ,o.usergcerttp -- 认证方式【0密码、1指纹、2两者】-usergcerttp
    ,o.padgcerttp -- pad认证方式【0密码、1指纹、2两者】-padgcerttp
    ,o.logintime -- 登陆日期
    ,o.tellerno -- 柜员号
    ,o.employeeid -- 员工编号
    ,o.domainid -- 域帐号
    ,o.emptype -- 员工类型|1:正式行员、2:返聘人员、3:劳务派遣、4:实习生、5:外部机构人员、6:兼职行员、7:顾问、8:外包员工、1:正常、2:锁定、3:注销
    ,o.organcode -- 所在部门编号
    ,o.titlecode -- 职称|10:高级、11:正高级、12:副高级、20:中级、30:初级、31:员级、32:助理级、99:未知
    ,o.place -- 职位
    ,o.managertype -- 客户经理标志
    ,o.managerlevel -- 客户经理级别
    ,o.userlevel -- 柜员级别
    ,o.tellermanagerid -- 柜员旧柜员号
    ,o.status -- 员工状态|1:在职、2:离职、3:退休、4:内退、7:开除、8:死亡
    ,o.sysstatus -- 用户系统状态
    ,o.orderno -- 序号
    ,o.hsorgancode -- 虚拟核算部门编号
    ,o.placehr -- 职务
    ,o.surname -- 姓氏
    ,o.firstname -- 英文名字
    ,o.lastname -- 英文姓氏
    ,o.birthdate -- 出生日期
    ,o.ethnic -- 民族
    ,o.politicface -- 政治面貌
    ,o.marriage -- 婚姻状况
    ,o.education -- 学历
    ,o.jobdate -- 参加工作日期
    ,o.theentrydate -- 入职日期
    ,o.leaveofficedate -- 离职日期
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
    ,o.housesubphone -- 住宅电话分机号
    ,o.mobile1 -- 移动电话1
    ,o.mobile2 -- 移动电话2
    ,o.mobile3 -- 移动电话3
    ,o.post -- 邮政编码
    ,o.country -- 所在国家
    ,o.province -- 所在省/州
    ,o.city -- 所在城市
    ,o.county -- 县/区代码
    ,o.sallevel -- 薪资级别
    ,o.updatedate -- 最后修改时间
    ,o.subsidydate -- 补贴正式发放日期
    ,o.userid -- 钉钉userid
    ,o.branchsignstatus -- 机构签到状态（1签到 0-未签到 ）
    ,o.hightlowfalg -- 柜员高低柜标识 0-低柜 1-高柜
    ,o.userage -- 年龄
    ,o.serviceage -- 服务年龄（工龄）
    ,o.errorrate -- 差错率
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
from ${iol_schema}.nibs_ib_upm_user_info_bk o
    left join ${iol_schema}.nibs_ib_upm_user_info_op n
        on
            o.usernum = n.usernum
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nibs_ib_upm_user_info_cl d
        on
            o.usernum = d.usernum
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nibs_ib_upm_user_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nibs_ib_upm_user_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nibs_ib_upm_user_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nibs_ib_upm_user_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nibs_ib_upm_user_info exchange partition p_${batch_date} with table ${iol_schema}.nibs_ib_upm_user_info_cl;
alter table ${iol_schema}.nibs_ib_upm_user_info exchange partition p_20991231 with table ${iol_schema}.nibs_ib_upm_user_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_ib_upm_user_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_upm_user_info_op purge;
drop table ${iol_schema}.nibs_ib_upm_user_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nibs_ib_upm_user_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_ib_upm_user_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
