/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_upm_user_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_upm_user_info
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_upm_user_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_upm_user_info(
    usernum varchar2(12) -- 用户编号
    ,branchnum varchar2(10) -- 柜员所属机构号
    ,username varchar2(150) -- 用户名称（姓名）
    ,certtype varchar2(5) -- 证件类型
    ,certnum varchar2(60) -- 证件号码
    ,gender varchar2(2) -- 性别|0:未知的性别、1:男性、2:女性、9:未说明的性别
    ,contactnum varchar2(30) -- 联系电话（住宅电话）
    ,phonenum varchar2(22) -- 手机号码（移动电话）
    ,contactaddr varchar2(400) -- 联系地址（详细地址）
    ,mailbox varchar2(64) -- 邮箱（电子邮箱）
    ,nummisppwd varchar2(3) -- 密码输错次数
    ,pichead varchar2(100) -- 头像图片（柜员图片路径）
    ,userstatus varchar2(2) -- 用户状态 : u-可使用；f-被冻结；l-被锁定；o-在线；d-已删除；s-已停用；h-休假中
    ,usergcerttp varchar2(1) -- 认证方式【0密码、1指纹、2两者】-usergcerttp
    ,padgcerttp varchar2(1) -- pad认证方式【0密码、1指纹、2两者】-padgcerttp
    ,logintime varchar2(10) -- 登陆日期
    ,tellerno varchar2(20) -- 柜员号
    ,employeeid varchar2(20) -- 员工编号
    ,domainid varchar2(60) -- 域帐号
    ,emptype varchar2(255) -- 员工类型|1:正式行员、2:返聘人员、3:劳务派遣、4:实习生、5:外部机构人员、6:兼职行员、7:顾问、8:外包员工、1:正常、2:锁定、3:注销
    ,organcode varchar2(255) -- 所在部门编号
    ,titlecode varchar2(255) -- 职称|10:高级、11:正高级、12:副高级、20:中级、30:初级、31:员级、32:助理级、99:未知
    ,place varchar2(255) -- 职位
    ,managertype varchar2(255) -- 客户经理标志
    ,managerlevel varchar2(255) -- 客户经理级别
    ,userlevel varchar2(255) -- 柜员级别
    ,tellermanagerid varchar2(20) -- 柜员旧柜员号
    ,status varchar2(255) -- 员工状态|1:在职、2:离职、3:退休、4:内退、7:开除、8:死亡
    ,sysstatus varchar2(255) -- 用户系统状态
    ,orderno varchar2(255) -- 序号
    ,hsorgancode varchar2(255) -- 虚拟核算部门编号
    ,placehr varchar2(255) -- 职务
    ,surname varchar2(255) -- 姓氏
    ,firstname varchar2(255) -- 英文名字
    ,lastname varchar2(255) -- 英文姓氏
    ,birthdate varchar2(10) -- 出生日期
    ,ethnic varchar2(255) -- 民族
    ,politicface varchar2(255) -- 政治面貌
    ,marriage varchar2(255) -- 婚姻状况
    ,education varchar2(255) -- 学历
    ,jobdate varchar2(10) -- 参加工作日期
    ,theentrydate varchar2(10) -- 入职日期
    ,leaveofficedate varchar2(10) -- 离职日期
    ,fixcountrycode varchar2(255) -- 传真国际区号
    ,fixareacode varchar2(255) -- 传真国内区号
    ,fixphone varchar2(255) -- 传真
    ,fixsubphone varchar2(255) -- 传真分机号
    ,companycountrycode varchar2(255) -- 单位电话国际区号
    ,companyareacode varchar2(255) -- 单位电话国内区号
    ,companyphone varchar2(255) -- 单位电话
    ,companysubphone varchar2(255) -- 单位电话分机号
    ,housecountrycode varchar2(255) -- 住宅电话国际区号
    ,houseareacode varchar2(255) -- 住宅电话国内区号
    ,housesubphone varchar2(255) -- 住宅电话分机号
    ,mobile1 varchar2(255) -- 移动电话1
    ,mobile2 varchar2(255) -- 移动电话2
    ,mobile3 varchar2(255) -- 移动电话3
    ,post varchar2(255) -- 邮政编码
    ,country varchar2(255) -- 所在国家
    ,province varchar2(255) -- 所在省/州
    ,city varchar2(255) -- 所在城市
    ,county varchar2(255) -- 县/区代码
    ,sallevel varchar2(255) -- 薪资级别
    ,updatedate varchar2(10) -- 最后修改时间
    ,subsidydate varchar2(10) -- 补贴正式发放日期
    ,userid varchar2(255) -- 钉钉userid
    ,branchsignstatus varchar2(1) -- 机构签到状态（1签到 0-未签到 ）
    ,hightlowfalg varchar2(1) -- 柜员高低柜标识 0-低柜 1-高柜
    ,userage varchar2(5) -- 年龄
    ,serviceage varchar2(5) -- 服务年龄（工龄）
    ,errorrate varchar2(20) -- 差错率
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
grant select on ${iol_schema}.nibs_ib_upm_user_info to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_upm_user_info to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_upm_user_info to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_upm_user_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_upm_user_info is '用户信息表';
comment on column ${iol_schema}.nibs_ib_upm_user_info.usernum is '用户编号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.branchnum is '柜员所属机构号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.username is '用户名称（姓名）';
comment on column ${iol_schema}.nibs_ib_upm_user_info.certtype is '证件类型';
comment on column ${iol_schema}.nibs_ib_upm_user_info.certnum is '证件号码';
comment on column ${iol_schema}.nibs_ib_upm_user_info.gender is '性别|0:未知的性别、1:男性、2:女性、9:未说明的性别';
comment on column ${iol_schema}.nibs_ib_upm_user_info.contactnum is '联系电话（住宅电话）';
comment on column ${iol_schema}.nibs_ib_upm_user_info.phonenum is '手机号码（移动电话）';
comment on column ${iol_schema}.nibs_ib_upm_user_info.contactaddr is '联系地址（详细地址）';
comment on column ${iol_schema}.nibs_ib_upm_user_info.mailbox is '邮箱（电子邮箱）';
comment on column ${iol_schema}.nibs_ib_upm_user_info.nummisppwd is '密码输错次数';
comment on column ${iol_schema}.nibs_ib_upm_user_info.pichead is '头像图片（柜员图片路径）';
comment on column ${iol_schema}.nibs_ib_upm_user_info.userstatus is '用户状态 : u-可使用；f-被冻结；l-被锁定；o-在线；d-已删除；s-已停用；h-休假中';
comment on column ${iol_schema}.nibs_ib_upm_user_info.usergcerttp is '认证方式【0密码、1指纹、2两者】-usergcerttp';
comment on column ${iol_schema}.nibs_ib_upm_user_info.padgcerttp is 'pad认证方式【0密码、1指纹、2两者】-padgcerttp';
comment on column ${iol_schema}.nibs_ib_upm_user_info.logintime is '登陆日期';
comment on column ${iol_schema}.nibs_ib_upm_user_info.tellerno is '柜员号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.employeeid is '员工编号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.domainid is '域帐号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.emptype is '员工类型|1:正式行员、2:返聘人员、3:劳务派遣、4:实习生、5:外部机构人员、6:兼职行员、7:顾问、8:外包员工、1:正常、2:锁定、3:注销';
comment on column ${iol_schema}.nibs_ib_upm_user_info.organcode is '所在部门编号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.titlecode is '职称|10:高级、11:正高级、12:副高级、20:中级、30:初级、31:员级、32:助理级、99:未知';
comment on column ${iol_schema}.nibs_ib_upm_user_info.place is '职位';
comment on column ${iol_schema}.nibs_ib_upm_user_info.managertype is '客户经理标志';
comment on column ${iol_schema}.nibs_ib_upm_user_info.managerlevel is '客户经理级别';
comment on column ${iol_schema}.nibs_ib_upm_user_info.userlevel is '柜员级别';
comment on column ${iol_schema}.nibs_ib_upm_user_info.tellermanagerid is '柜员旧柜员号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.status is '员工状态|1:在职、2:离职、3:退休、4:内退、7:开除、8:死亡';
comment on column ${iol_schema}.nibs_ib_upm_user_info.sysstatus is '用户系统状态';
comment on column ${iol_schema}.nibs_ib_upm_user_info.orderno is '序号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.hsorgancode is '虚拟核算部门编号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.placehr is '职务';
comment on column ${iol_schema}.nibs_ib_upm_user_info.surname is '姓氏';
comment on column ${iol_schema}.nibs_ib_upm_user_info.firstname is '英文名字';
comment on column ${iol_schema}.nibs_ib_upm_user_info.lastname is '英文姓氏';
comment on column ${iol_schema}.nibs_ib_upm_user_info.birthdate is '出生日期';
comment on column ${iol_schema}.nibs_ib_upm_user_info.ethnic is '民族';
comment on column ${iol_schema}.nibs_ib_upm_user_info.politicface is '政治面貌';
comment on column ${iol_schema}.nibs_ib_upm_user_info.marriage is '婚姻状况';
comment on column ${iol_schema}.nibs_ib_upm_user_info.education is '学历';
comment on column ${iol_schema}.nibs_ib_upm_user_info.jobdate is '参加工作日期';
comment on column ${iol_schema}.nibs_ib_upm_user_info.theentrydate is '入职日期';
comment on column ${iol_schema}.nibs_ib_upm_user_info.leaveofficedate is '离职日期';
comment on column ${iol_schema}.nibs_ib_upm_user_info.fixcountrycode is '传真国际区号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.fixareacode is '传真国内区号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.fixphone is '传真';
comment on column ${iol_schema}.nibs_ib_upm_user_info.fixsubphone is '传真分机号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.companycountrycode is '单位电话国际区号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.companyareacode is '单位电话国内区号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.companyphone is '单位电话';
comment on column ${iol_schema}.nibs_ib_upm_user_info.companysubphone is '单位电话分机号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.housecountrycode is '住宅电话国际区号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.houseareacode is '住宅电话国内区号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.housesubphone is '住宅电话分机号';
comment on column ${iol_schema}.nibs_ib_upm_user_info.mobile1 is '移动电话1';
comment on column ${iol_schema}.nibs_ib_upm_user_info.mobile2 is '移动电话2';
comment on column ${iol_schema}.nibs_ib_upm_user_info.mobile3 is '移动电话3';
comment on column ${iol_schema}.nibs_ib_upm_user_info.post is '邮政编码';
comment on column ${iol_schema}.nibs_ib_upm_user_info.country is '所在国家';
comment on column ${iol_schema}.nibs_ib_upm_user_info.province is '所在省/州';
comment on column ${iol_schema}.nibs_ib_upm_user_info.city is '所在城市';
comment on column ${iol_schema}.nibs_ib_upm_user_info.county is '县/区代码';
comment on column ${iol_schema}.nibs_ib_upm_user_info.sallevel is '薪资级别';
comment on column ${iol_schema}.nibs_ib_upm_user_info.updatedate is '最后修改时间';
comment on column ${iol_schema}.nibs_ib_upm_user_info.subsidydate is '补贴正式发放日期';
comment on column ${iol_schema}.nibs_ib_upm_user_info.userid is '钉钉userid';
comment on column ${iol_schema}.nibs_ib_upm_user_info.branchsignstatus is '机构签到状态（1签到 0-未签到 ）';
comment on column ${iol_schema}.nibs_ib_upm_user_info.hightlowfalg is '柜员高低柜标识 0-低柜 1-高柜';
comment on column ${iol_schema}.nibs_ib_upm_user_info.userage is '年龄';
comment on column ${iol_schema}.nibs_ib_upm_user_info.serviceage is '服务年龄（工龄）';
comment on column ${iol_schema}.nibs_ib_upm_user_info.errorrate is '差错率';
comment on column ${iol_schema}.nibs_ib_upm_user_info.start_dt is '开始时间';
comment on column ${iol_schema}.nibs_ib_upm_user_info.end_dt is '结束时间';
comment on column ${iol_schema}.nibs_ib_upm_user_info.id_mark is '增删标志';
comment on column ${iol_schema}.nibs_ib_upm_user_info.etl_timestamp is 'ETL处理时间戳';
