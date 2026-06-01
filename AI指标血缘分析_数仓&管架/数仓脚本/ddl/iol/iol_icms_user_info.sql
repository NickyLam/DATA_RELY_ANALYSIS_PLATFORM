/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_user_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_user_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_user_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_user_info(
    userid varchar2(8) -- 员工编号
    ,username varchar2(200) -- 员工姓名
    ,attribute4 varchar2(400) -- 属性四
    ,updatedate varchar2(32) -- 更新日期
    ,skinpath varchar2(1000) -- 皮肤路径
    ,attribute1 varchar2(400) -- 属性一
    ,describe4 varchar2(1000) -- 描述四
    ,certtype varchar2(4) -- 证件类型
    ,companytel varchar2(64) -- 单位电话
    ,inputuserid varchar2(64) -- 登记人
    ,loginid varchar2(64) -- 登录账号
    ,password varchar2(160) -- 用户密码
    ,describe3 varchar2(1000) -- 描述三
    ,ntid varchar2(64) -- NTID
    ,language varchar2(64) -- 语言
    ,attribute8 varchar2(400) -- 属性八
    ,birthday date -- 员工出生日期
    ,belongorg varchar2(12) -- 所属部门编号
    ,remark varchar2(1000) -- 备注
    ,workbench varchar2(64) -- 工作台类型
    ,inputorg varchar2(80) -- 登记机构名称
    ,id1 varchar2(64) -- 编号1
    ,updateuserid varchar2(64) -- 更新人编号
    ,attribute2 varchar2(400) -- 属性二
    ,sum2 number(24,6) -- 相关金额2
    ,position varchar2(1000) -- 职称
    ,attribute6 varchar2(400) -- 属性六
    ,belongteam varchar2(64) -- 所属团队
    ,inputorgid varchar2(64) -- 登记机构
    ,attribute5 varchar2(400) -- 属性五
    ,describe2 varchar2(1000) -- 描述二
    ,status varchar2(1) -- 状态
    ,accountid varchar2(64) -- 个贷系统编号
    ,title varchar2(7) -- 员工职务代码
    ,updateorgid varchar2(64) -- 更新机构
    ,updateuser varchar2(80) -- 更新人
    ,attribute3 varchar2(400) -- 属性三
    ,describe1 varchar2(1000) -- 描述一
    ,mobiletel varchar2(30) -- 联系电话
    ,sum1 number(24,6) -- 相关金额1
    ,vocationexp varchar2(2000) -- 工作经历
    ,wfiifmsg varchar2(10) -- 流程跟踪提醒-是否发送短信，1-是2-否
    ,inputdate varchar2(32) -- 登记日期
    ,attribute7 varchar2(400) -- 属性七
    ,email varchar2(400) -- 电子邮件
    ,amlevel varchar2(36) -- 客户经理级别
    ,educationexp varchar2(2000) -- 教育经历
    ,inputtime varchar2(32) -- 登记时间
    ,educationalbg varchar2(2) -- 员工学历
    ,lob varchar2(64) -- 业务条线
    ,updatetime varchar2(32) -- 更新时间
    ,finabrid varchar2(40) -- 账务机构
    ,tellerno varchar2(12) -- 柜员号
    ,certid varchar2(60) -- 证件号码
    ,id2 varchar2(64) -- 编号2
    ,inputuser varchar2(80) -- 登记人名称
    ,attribute varchar2(400) -- 属性集
    ,qualification varchar2(1000) -- 任职资格
    ,gender varchar2(1) -- 员工性别
    ,familyadd varchar2(1000) -- 家庭住址
    ,issynoaorg varchar2(1) -- 是否同步OA所属机构（0不同步 1同步）
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
grant select on ${iol_schema}.icms_user_info to ${iml_schema};
grant select on ${iol_schema}.icms_user_info to ${icl_schema};
grant select on ${iol_schema}.icms_user_info to ${idl_schema};
grant select on ${iol_schema}.icms_user_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_user_info is '用户基本信息';
comment on column ${iol_schema}.icms_user_info.userid is '员工编号';
comment on column ${iol_schema}.icms_user_info.username is '员工姓名';
comment on column ${iol_schema}.icms_user_info.attribute4 is '属性四';
comment on column ${iol_schema}.icms_user_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_user_info.skinpath is '皮肤路径';
comment on column ${iol_schema}.icms_user_info.attribute1 is '属性一';
comment on column ${iol_schema}.icms_user_info.describe4 is '描述四';
comment on column ${iol_schema}.icms_user_info.certtype is '证件类型';
comment on column ${iol_schema}.icms_user_info.companytel is '单位电话';
comment on column ${iol_schema}.icms_user_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_user_info.loginid is '登录账号';
comment on column ${iol_schema}.icms_user_info.password is '用户密码';
comment on column ${iol_schema}.icms_user_info.describe3 is '描述三';
comment on column ${iol_schema}.icms_user_info.ntid is 'NTID';
comment on column ${iol_schema}.icms_user_info.language is '语言';
comment on column ${iol_schema}.icms_user_info.attribute8 is '属性八';
comment on column ${iol_schema}.icms_user_info.birthday is '员工出生日期';
comment on column ${iol_schema}.icms_user_info.belongorg is '所属部门编号';
comment on column ${iol_schema}.icms_user_info.remark is '备注';
comment on column ${iol_schema}.icms_user_info.workbench is '工作台类型';
comment on column ${iol_schema}.icms_user_info.inputorg is '登记机构名称';
comment on column ${iol_schema}.icms_user_info.id1 is '编号1';
comment on column ${iol_schema}.icms_user_info.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_user_info.attribute2 is '属性二';
comment on column ${iol_schema}.icms_user_info.sum2 is '相关金额2';
comment on column ${iol_schema}.icms_user_info.position is '职称';
comment on column ${iol_schema}.icms_user_info.attribute6 is '属性六';
comment on column ${iol_schema}.icms_user_info.belongteam is '所属团队';
comment on column ${iol_schema}.icms_user_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_user_info.attribute5 is '属性五';
comment on column ${iol_schema}.icms_user_info.describe2 is '描述二';
comment on column ${iol_schema}.icms_user_info.status is '状态';
comment on column ${iol_schema}.icms_user_info.accountid is '个贷系统编号';
comment on column ${iol_schema}.icms_user_info.title is '员工职务代码';
comment on column ${iol_schema}.icms_user_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_user_info.updateuser is '更新人';
comment on column ${iol_schema}.icms_user_info.attribute3 is '属性三';
comment on column ${iol_schema}.icms_user_info.describe1 is '描述一';
comment on column ${iol_schema}.icms_user_info.mobiletel is '联系电话';
comment on column ${iol_schema}.icms_user_info.sum1 is '相关金额1';
comment on column ${iol_schema}.icms_user_info.vocationexp is '工作经历';
comment on column ${iol_schema}.icms_user_info.wfiifmsg is '流程跟踪提醒-是否发送短信，1-是2-否';
comment on column ${iol_schema}.icms_user_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_user_info.attribute7 is '属性七';
comment on column ${iol_schema}.icms_user_info.email is '电子邮件';
comment on column ${iol_schema}.icms_user_info.amlevel is '客户经理级别';
comment on column ${iol_schema}.icms_user_info.educationexp is '教育经历';
comment on column ${iol_schema}.icms_user_info.inputtime is '登记时间';
comment on column ${iol_schema}.icms_user_info.educationalbg is '员工学历';
comment on column ${iol_schema}.icms_user_info.lob is '业务条线';
comment on column ${iol_schema}.icms_user_info.updatetime is '更新时间';
comment on column ${iol_schema}.icms_user_info.finabrid is '账务机构';
comment on column ${iol_schema}.icms_user_info.tellerno is '柜员号';
comment on column ${iol_schema}.icms_user_info.certid is '证件号码';
comment on column ${iol_schema}.icms_user_info.id2 is '编号2';
comment on column ${iol_schema}.icms_user_info.inputuser is '登记人名称';
comment on column ${iol_schema}.icms_user_info.attribute is '属性集';
comment on column ${iol_schema}.icms_user_info.qualification is '任职资格';
comment on column ${iol_schema}.icms_user_info.gender is '员工性别';
comment on column ${iol_schema}.icms_user_info.familyadd is '家庭住址';
comment on column ${iol_schema}.icms_user_info.issynoaorg is '是否同步OA所属机构（0不同步 1同步）';
comment on column ${iol_schema}.icms_user_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_user_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_user_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_user_info.etl_timestamp is 'ETL处理时间戳';
