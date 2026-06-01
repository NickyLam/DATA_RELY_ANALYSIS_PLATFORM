/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_user_info
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
create table ${iol_schema}.icms_user_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_user_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_user_info_op purge;
drop table ${iol_schema}.icms_user_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_user_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_user_info where 0=1;

create table ${iol_schema}.icms_user_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_user_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_user_info_cl(
            userid -- 员工编号
            ,username -- 员工姓名
            ,attribute4 -- 属性四
            ,updatedate -- 更新日期
            ,skinpath -- 皮肤路径
            ,attribute1 -- 属性一
            ,describe4 -- 描述四
            ,certtype -- 证件类型
            ,companytel -- 单位电话
            ,inputuserid -- 登记人
            ,loginid -- 登录账号
            ,password -- 用户密码
            ,describe3 -- 描述三
            ,ntid -- NTID
            ,language -- 语言
            ,attribute8 -- 属性八
            ,birthday -- 员工出生日期
            ,belongorg -- 所属部门编号
            ,remark -- 备注
            ,workbench -- 工作台类型
            ,inputorg -- 登记机构名称
            ,id1 -- 编号1
            ,updateuserid -- 更新人编号
            ,attribute2 -- 属性二
            ,sum2 -- 相关金额2
            ,position -- 职称
            ,attribute6 -- 属性六
            ,belongteam -- 所属团队
            ,inputorgid -- 登记机构
            ,attribute5 -- 属性五
            ,describe2 -- 描述二
            ,status -- 状态
            ,accountid -- 个贷系统编号
            ,title -- 员工职务代码
            ,updateorgid -- 更新机构
            ,updateuser -- 更新人
            ,attribute3 -- 属性三
            ,describe1 -- 描述一
            ,mobiletel -- 联系电话
            ,sum1 -- 相关金额1
            ,vocationexp -- 工作经历
            ,wfiifmsg -- 流程跟踪提醒-是否发送短信，1-是2-否
            ,inputdate -- 登记日期
            ,attribute7 -- 属性七
            ,email -- 电子邮件
            ,amlevel -- 客户经理级别
            ,educationexp -- 教育经历
            ,inputtime -- 登记时间
            ,educationalbg -- 员工学历
            ,lob -- 业务条线
            ,updatetime -- 更新时间
            ,finabrid -- 账务机构
            ,tellerno -- 柜员号
            ,certid -- 证件号码
            ,id2 -- 编号2
            ,inputuser -- 登记人名称
            ,attribute -- 属性集
            ,qualification -- 任职资格
            ,gender -- 员工性别
            ,familyadd -- 家庭住址
            ,issynoaorg -- 是否同步OA所属机构（0不同步 1同步）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_user_info_op(
            userid -- 员工编号
            ,username -- 员工姓名
            ,attribute4 -- 属性四
            ,updatedate -- 更新日期
            ,skinpath -- 皮肤路径
            ,attribute1 -- 属性一
            ,describe4 -- 描述四
            ,certtype -- 证件类型
            ,companytel -- 单位电话
            ,inputuserid -- 登记人
            ,loginid -- 登录账号
            ,password -- 用户密码
            ,describe3 -- 描述三
            ,ntid -- NTID
            ,language -- 语言
            ,attribute8 -- 属性八
            ,birthday -- 员工出生日期
            ,belongorg -- 所属部门编号
            ,remark -- 备注
            ,workbench -- 工作台类型
            ,inputorg -- 登记机构名称
            ,id1 -- 编号1
            ,updateuserid -- 更新人编号
            ,attribute2 -- 属性二
            ,sum2 -- 相关金额2
            ,position -- 职称
            ,attribute6 -- 属性六
            ,belongteam -- 所属团队
            ,inputorgid -- 登记机构
            ,attribute5 -- 属性五
            ,describe2 -- 描述二
            ,status -- 状态
            ,accountid -- 个贷系统编号
            ,title -- 员工职务代码
            ,updateorgid -- 更新机构
            ,updateuser -- 更新人
            ,attribute3 -- 属性三
            ,describe1 -- 描述一
            ,mobiletel -- 联系电话
            ,sum1 -- 相关金额1
            ,vocationexp -- 工作经历
            ,wfiifmsg -- 流程跟踪提醒-是否发送短信，1-是2-否
            ,inputdate -- 登记日期
            ,attribute7 -- 属性七
            ,email -- 电子邮件
            ,amlevel -- 客户经理级别
            ,educationexp -- 教育经历
            ,inputtime -- 登记时间
            ,educationalbg -- 员工学历
            ,lob -- 业务条线
            ,updatetime -- 更新时间
            ,finabrid -- 账务机构
            ,tellerno -- 柜员号
            ,certid -- 证件号码
            ,id2 -- 编号2
            ,inputuser -- 登记人名称
            ,attribute -- 属性集
            ,qualification -- 任职资格
            ,gender -- 员工性别
            ,familyadd -- 家庭住址
            ,issynoaorg -- 是否同步OA所属机构（0不同步 1同步）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.userid, o.userid) as userid -- 员工编号
    ,nvl(n.username, o.username) as username -- 员工姓名
    ,nvl(n.attribute4, o.attribute4) as attribute4 -- 属性四
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.skinpath, o.skinpath) as skinpath -- 皮肤路径
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 属性一
    ,nvl(n.describe4, o.describe4) as describe4 -- 描述四
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.companytel, o.companytel) as companytel -- 单位电话
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.loginid, o.loginid) as loginid -- 登录账号
    ,nvl(n.password, o.password) as password -- 用户密码
    ,nvl(n.describe3, o.describe3) as describe3 -- 描述三
    ,nvl(n.ntid, o.ntid) as ntid -- NTID
    ,nvl(n.language, o.language) as language -- 语言
    ,nvl(n.attribute8, o.attribute8) as attribute8 -- 属性八
    ,nvl(n.birthday, o.birthday) as birthday -- 员工出生日期
    ,nvl(n.belongorg, o.belongorg) as belongorg -- 所属部门编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.workbench, o.workbench) as workbench -- 工作台类型
    ,nvl(n.inputorg, o.inputorg) as inputorg -- 登记机构名称
    ,nvl(n.id1, o.id1) as id1 -- 编号1
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人编号
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 属性二
    ,nvl(n.sum2, o.sum2) as sum2 -- 相关金额2
    ,nvl(n.position, o.position) as position -- 职称
    ,nvl(n.attribute6, o.attribute6) as attribute6 -- 属性六
    ,nvl(n.belongteam, o.belongteam) as belongteam -- 所属团队
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.attribute5, o.attribute5) as attribute5 -- 属性五
    ,nvl(n.describe2, o.describe2) as describe2 -- 描述二
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.accountid, o.accountid) as accountid -- 个贷系统编号
    ,nvl(n.title, o.title) as title -- 员工职务代码
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updateuser, o.updateuser) as updateuser -- 更新人
    ,nvl(n.attribute3, o.attribute3) as attribute3 -- 属性三
    ,nvl(n.describe1, o.describe1) as describe1 -- 描述一
    ,nvl(n.mobiletel, o.mobiletel) as mobiletel -- 联系电话
    ,nvl(n.sum1, o.sum1) as sum1 -- 相关金额1
    ,nvl(n.vocationexp, o.vocationexp) as vocationexp -- 工作经历
    ,nvl(n.wfiifmsg, o.wfiifmsg) as wfiifmsg -- 流程跟踪提醒-是否发送短信，1-是2-否
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.attribute7, o.attribute7) as attribute7 -- 属性七
    ,nvl(n.email, o.email) as email -- 电子邮件
    ,nvl(n.amlevel, o.amlevel) as amlevel -- 客户经理级别
    ,nvl(n.educationexp, o.educationexp) as educationexp -- 教育经历
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 登记时间
    ,nvl(n.educationalbg, o.educationalbg) as educationalbg -- 员工学历
    ,nvl(n.lob, o.lob) as lob -- 业务条线
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.finabrid, o.finabrid) as finabrid -- 账务机构
    ,nvl(n.tellerno, o.tellerno) as tellerno -- 柜员号
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.id2, o.id2) as id2 -- 编号2
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 登记人名称
    ,nvl(n.attribute, o.attribute) as attribute -- 属性集
    ,nvl(n.qualification, o.qualification) as qualification -- 任职资格
    ,nvl(n.gender, o.gender) as gender -- 员工性别
    ,nvl(n.familyadd, o.familyadd) as familyadd -- 家庭住址
    ,nvl(n.issynoaorg, o.issynoaorg) as issynoaorg -- 是否同步OA所属机构（0不同步 1同步）
    ,case when
            n.userid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.userid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.userid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_user_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_user_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.userid = n.userid
where (
        o.userid is null
    )
    or (
        n.userid is null
    )
    or (
        o.username <> n.username
        or o.attribute4 <> n.attribute4
        or o.updatedate <> n.updatedate
        or o.skinpath <> n.skinpath
        or o.attribute1 <> n.attribute1
        or o.describe4 <> n.describe4
        or o.certtype <> n.certtype
        or o.companytel <> n.companytel
        or o.inputuserid <> n.inputuserid
        or o.loginid <> n.loginid
        or o.password <> n.password
        or o.describe3 <> n.describe3
        or o.ntid <> n.ntid
        or o.language <> n.language
        or o.attribute8 <> n.attribute8
        or o.birthday <> n.birthday
        or o.belongorg <> n.belongorg
        or o.remark <> n.remark
        or o.workbench <> n.workbench
        or o.inputorg <> n.inputorg
        or o.id1 <> n.id1
        or o.updateuserid <> n.updateuserid
        or o.attribute2 <> n.attribute2
        or o.sum2 <> n.sum2
        or o.position <> n.position
        or o.attribute6 <> n.attribute6
        or o.belongteam <> n.belongteam
        or o.inputorgid <> n.inputorgid
        or o.attribute5 <> n.attribute5
        or o.describe2 <> n.describe2
        or o.status <> n.status
        or o.accountid <> n.accountid
        or o.title <> n.title
        or o.updateorgid <> n.updateorgid
        or o.updateuser <> n.updateuser
        or o.attribute3 <> n.attribute3
        or o.describe1 <> n.describe1
        or o.mobiletel <> n.mobiletel
        or o.sum1 <> n.sum1
        or o.vocationexp <> n.vocationexp
        or o.wfiifmsg <> n.wfiifmsg
        or o.inputdate <> n.inputdate
        or o.attribute7 <> n.attribute7
        or o.email <> n.email
        or o.amlevel <> n.amlevel
        or o.educationexp <> n.educationexp
        or o.inputtime <> n.inputtime
        or o.educationalbg <> n.educationalbg
        or o.lob <> n.lob
        or o.updatetime <> n.updatetime
        or o.finabrid <> n.finabrid
        or o.tellerno <> n.tellerno
        or o.certid <> n.certid
        or o.id2 <> n.id2
        or o.inputuser <> n.inputuser
        or o.attribute <> n.attribute
        or o.qualification <> n.qualification
        or o.gender <> n.gender
        or o.familyadd <> n.familyadd
        or o.issynoaorg <> n.issynoaorg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_user_info_cl(
            userid -- 员工编号
            ,username -- 员工姓名
            ,attribute4 -- 属性四
            ,updatedate -- 更新日期
            ,skinpath -- 皮肤路径
            ,attribute1 -- 属性一
            ,describe4 -- 描述四
            ,certtype -- 证件类型
            ,companytel -- 单位电话
            ,inputuserid -- 登记人
            ,loginid -- 登录账号
            ,password -- 用户密码
            ,describe3 -- 描述三
            ,ntid -- NTID
            ,language -- 语言
            ,attribute8 -- 属性八
            ,birthday -- 员工出生日期
            ,belongorg -- 所属部门编号
            ,remark -- 备注
            ,workbench -- 工作台类型
            ,inputorg -- 登记机构名称
            ,id1 -- 编号1
            ,updateuserid -- 更新人编号
            ,attribute2 -- 属性二
            ,sum2 -- 相关金额2
            ,position -- 职称
            ,attribute6 -- 属性六
            ,belongteam -- 所属团队
            ,inputorgid -- 登记机构
            ,attribute5 -- 属性五
            ,describe2 -- 描述二
            ,status -- 状态
            ,accountid -- 个贷系统编号
            ,title -- 员工职务代码
            ,updateorgid -- 更新机构
            ,updateuser -- 更新人
            ,attribute3 -- 属性三
            ,describe1 -- 描述一
            ,mobiletel -- 联系电话
            ,sum1 -- 相关金额1
            ,vocationexp -- 工作经历
            ,wfiifmsg -- 流程跟踪提醒-是否发送短信，1-是2-否
            ,inputdate -- 登记日期
            ,attribute7 -- 属性七
            ,email -- 电子邮件
            ,amlevel -- 客户经理级别
            ,educationexp -- 教育经历
            ,inputtime -- 登记时间
            ,educationalbg -- 员工学历
            ,lob -- 业务条线
            ,updatetime -- 更新时间
            ,finabrid -- 账务机构
            ,tellerno -- 柜员号
            ,certid -- 证件号码
            ,id2 -- 编号2
            ,inputuser -- 登记人名称
            ,attribute -- 属性集
            ,qualification -- 任职资格
            ,gender -- 员工性别
            ,familyadd -- 家庭住址
            ,issynoaorg -- 是否同步OA所属机构（0不同步 1同步）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_user_info_op(
            userid -- 员工编号
            ,username -- 员工姓名
            ,attribute4 -- 属性四
            ,updatedate -- 更新日期
            ,skinpath -- 皮肤路径
            ,attribute1 -- 属性一
            ,describe4 -- 描述四
            ,certtype -- 证件类型
            ,companytel -- 单位电话
            ,inputuserid -- 登记人
            ,loginid -- 登录账号
            ,password -- 用户密码
            ,describe3 -- 描述三
            ,ntid -- NTID
            ,language -- 语言
            ,attribute8 -- 属性八
            ,birthday -- 员工出生日期
            ,belongorg -- 所属部门编号
            ,remark -- 备注
            ,workbench -- 工作台类型
            ,inputorg -- 登记机构名称
            ,id1 -- 编号1
            ,updateuserid -- 更新人编号
            ,attribute2 -- 属性二
            ,sum2 -- 相关金额2
            ,position -- 职称
            ,attribute6 -- 属性六
            ,belongteam -- 所属团队
            ,inputorgid -- 登记机构
            ,attribute5 -- 属性五
            ,describe2 -- 描述二
            ,status -- 状态
            ,accountid -- 个贷系统编号
            ,title -- 员工职务代码
            ,updateorgid -- 更新机构
            ,updateuser -- 更新人
            ,attribute3 -- 属性三
            ,describe1 -- 描述一
            ,mobiletel -- 联系电话
            ,sum1 -- 相关金额1
            ,vocationexp -- 工作经历
            ,wfiifmsg -- 流程跟踪提醒-是否发送短信，1-是2-否
            ,inputdate -- 登记日期
            ,attribute7 -- 属性七
            ,email -- 电子邮件
            ,amlevel -- 客户经理级别
            ,educationexp -- 教育经历
            ,inputtime -- 登记时间
            ,educationalbg -- 员工学历
            ,lob -- 业务条线
            ,updatetime -- 更新时间
            ,finabrid -- 账务机构
            ,tellerno -- 柜员号
            ,certid -- 证件号码
            ,id2 -- 编号2
            ,inputuser -- 登记人名称
            ,attribute -- 属性集
            ,qualification -- 任职资格
            ,gender -- 员工性别
            ,familyadd -- 家庭住址
            ,issynoaorg -- 是否同步OA所属机构（0不同步 1同步）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.userid -- 员工编号
    ,o.username -- 员工姓名
    ,o.attribute4 -- 属性四
    ,o.updatedate -- 更新日期
    ,o.skinpath -- 皮肤路径
    ,o.attribute1 -- 属性一
    ,o.describe4 -- 描述四
    ,o.certtype -- 证件类型
    ,o.companytel -- 单位电话
    ,o.inputuserid -- 登记人
    ,o.loginid -- 登录账号
    ,o.password -- 用户密码
    ,o.describe3 -- 描述三
    ,o.ntid -- NTID
    ,o.language -- 语言
    ,o.attribute8 -- 属性八
    ,o.birthday -- 员工出生日期
    ,o.belongorg -- 所属部门编号
    ,o.remark -- 备注
    ,o.workbench -- 工作台类型
    ,o.inputorg -- 登记机构名称
    ,o.id1 -- 编号1
    ,o.updateuserid -- 更新人编号
    ,o.attribute2 -- 属性二
    ,o.sum2 -- 相关金额2
    ,o.position -- 职称
    ,o.attribute6 -- 属性六
    ,o.belongteam -- 所属团队
    ,o.inputorgid -- 登记机构
    ,o.attribute5 -- 属性五
    ,o.describe2 -- 描述二
    ,o.status -- 状态
    ,o.accountid -- 个贷系统编号
    ,o.title -- 员工职务代码
    ,o.updateorgid -- 更新机构
    ,o.updateuser -- 更新人
    ,o.attribute3 -- 属性三
    ,o.describe1 -- 描述一
    ,o.mobiletel -- 联系电话
    ,o.sum1 -- 相关金额1
    ,o.vocationexp -- 工作经历
    ,o.wfiifmsg -- 流程跟踪提醒-是否发送短信，1-是2-否
    ,o.inputdate -- 登记日期
    ,o.attribute7 -- 属性七
    ,o.email -- 电子邮件
    ,o.amlevel -- 客户经理级别
    ,o.educationexp -- 教育经历
    ,o.inputtime -- 登记时间
    ,o.educationalbg -- 员工学历
    ,o.lob -- 业务条线
    ,o.updatetime -- 更新时间
    ,o.finabrid -- 账务机构
    ,o.tellerno -- 柜员号
    ,o.certid -- 证件号码
    ,o.id2 -- 编号2
    ,o.inputuser -- 登记人名称
    ,o.attribute -- 属性集
    ,o.qualification -- 任职资格
    ,o.gender -- 员工性别
    ,o.familyadd -- 家庭住址
    ,o.issynoaorg -- 是否同步OA所属机构（0不同步 1同步）
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
from ${iol_schema}.icms_user_info_bk o
    left join ${iol_schema}.icms_user_info_op n
        on
            o.userid = n.userid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_user_info_cl d
        on
            o.userid = d.userid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_user_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_user_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_user_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_user_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_user_info exchange partition p_${batch_date} with table ${iol_schema}.icms_user_info_cl;
alter table ${iol_schema}.icms_user_info exchange partition p_20991231 with table ${iol_schema}.icms_user_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_user_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_user_info_op purge;
drop table ${iol_schema}.icms_user_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_user_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_user_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
