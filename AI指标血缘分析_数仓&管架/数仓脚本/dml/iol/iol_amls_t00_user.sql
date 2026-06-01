/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t00_user
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t00_user_ex purge;
alter table ${iol_schema}.amls_t00_user add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.amls_t00_user truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.amls_t00_user_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t00_user where 0=1;

insert /*+ append */ into ${iol_schema}.amls_t00_user_ex(
    organkey -- 所属机构 仅表示原所属机构
    ,flag -- 标志位 0:禁用1:正常2:删除
    ,isbuildin -- 是否内建用户1:是0:否
    ,isadmin -- 是否管理员  1:管理员0:非管理员
    ,address -- 用户地址
    ,postalcode -- 邮政编码
    ,emailaddress -- 电子邮箱
    ,telephone -- 电话号码
    ,mobilephone -- 移动电话
    ,des -- 简短描述
    ,sex -- 性别 1:男2:女X:其它
    ,birth -- 出生年月日
    ,education -- 学历
    ,isnewuser -- 是否新建用户1:是0:否
    ,position -- 职务名称
    ,postitle -- 职称
    ,worklevel -- 行员级别
    ,political -- 政治面貌
    ,indate -- 入行时间
    ,stafcode -- 员工号      稽核报告编号 由员工号按规则生成
    ,remark -- 其它
    ,createdate -- 创建时间
    ,creator -- 创建人
    ,modifydate -- 修改时间
    ,modifier -- 修改人员
    ,curr_cd -- 币种
    ,color -- 颜色
    ,indextemplate -- 首页模板
    ,wrongpassword -- 登录密码错误次数
    ,defgroupkey -- 默认组
    ,template_id -- 安全模版主键
    ,template_name -- 安全模版名称
    ,username -- 用户名 主键
    ,realname -- 真实名（中文名）
    ,password -- 密码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    organkey -- 所属机构 仅表示原所属机构
    ,flag -- 标志位 0:禁用1:正常2:删除
    ,isbuildin -- 是否内建用户1:是0:否
    ,isadmin -- 是否管理员  1:管理员0:非管理员
    ,address -- 用户地址
    ,postalcode -- 邮政编码
    ,emailaddress -- 电子邮箱
    ,telephone -- 电话号码
    ,mobilephone -- 移动电话
    ,des -- 简短描述
    ,sex -- 性别 1:男2:女X:其它
    ,birth -- 出生年月日
    ,education -- 学历
    ,isnewuser -- 是否新建用户1:是0:否
    ,position -- 职务名称
    ,postitle -- 职称
    ,worklevel -- 行员级别
    ,political -- 政治面貌
    ,indate -- 入行时间
    ,stafcode -- 员工号      稽核报告编号 由员工号按规则生成
    ,remark -- 其它
    ,createdate -- 创建时间
    ,creator -- 创建人
    ,modifydate -- 修改时间
    ,modifier -- 修改人员
    ,curr_cd -- 币种
    ,color -- 颜色
    ,indextemplate -- 首页模板
    ,wrongpassword -- 登录密码错误次数
    ,defgroupkey -- 默认组
    ,template_id -- 安全模版主键
    ,template_name -- 安全模版名称
    ,username -- 用户名 主键
    ,realname -- 真实名（中文名）
    ,password -- 密码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.amls_t00_user
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.amls_t00_user exchange partition p_${batch_date} with table ${iol_schema}.amls_t00_user_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t00_user to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.amls_t00_user_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t00_user',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);