/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_shell_entinfo_ent_info_basic
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
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic_ex purge;
alter table ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic;

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic_ex nologging
compress
as
select * from ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic_ex(
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,ent_info_basic -- 关联标签
    ,entname -- 企业名称
    ,entname_old -- 曾用名
    ,orgcodes -- 组织机构代码
    ,creditcode -- 统一信用代码
    ,regno -- 注册号
    ,frname -- 法定代表人/负责人/执行事务合伙人
    ,regcap -- 注册资本（企业:万元）
    ,regcapcurcode -- 注册资本币种代码
    ,regcapcur -- 注册资本币种
    ,esdate -- 成立日期
    ,opfrom -- 经营期限自
    ,opto -- 经营期限至
    ,entitytype -- 实体类型
    ,enttype -- 企业类型
    ,entstatus -- 经营状态
    ,entstatuscode -- 经营状态编码
    ,abuitem -- 许可经营项目
    ,zsopscope -- 经营业务范围
    ,regorg -- 登记机关
    ,ancheyear -- 最后年检年度
    ,candate -- 注销日期
    ,revdate -- 吊销日期
    ,apprdate -- 核准日期
    ,enttypecode -- 企业(机构)类型编码
    ,industrycocode -- 工业代码
    ,industryconame -- 工业业务
    ,dom -- 住址
    ,regorgcode -- 注册地址行政编号
    ,regorgprovince -- 所在省份
    ,regorgcity -- 所在城市
    ,regcity -- 所在城市编码
    ,regorgdistrict -- 所在区/县
    ,postalcode -- 邮编
    ,s_ext_nodenum -- 所在省份编码
    ,entid -- 企业ENTID
    ,paidincap -- 实缴资本(万元)
    ,genmonth -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,ent_info_basic -- 关联标签
    ,entname -- 企业名称
    ,entname_old -- 曾用名
    ,orgcodes -- 组织机构代码
    ,creditcode -- 统一信用代码
    ,regno -- 注册号
    ,frname -- 法定代表人/负责人/执行事务合伙人
    ,regcap -- 注册资本（企业:万元）
    ,regcapcurcode -- 注册资本币种代码
    ,regcapcur -- 注册资本币种
    ,esdate -- 成立日期
    ,opfrom -- 经营期限自
    ,opto -- 经营期限至
    ,entitytype -- 实体类型
    ,enttype -- 企业类型
    ,entstatus -- 经营状态
    ,entstatuscode -- 经营状态编码
    ,abuitem -- 许可经营项目
    ,zsopscope -- 经营业务范围
    ,regorg -- 登记机关
    ,ancheyear -- 最后年检年度
    ,candate -- 注销日期
    ,revdate -- 吊销日期
    ,apprdate -- 核准日期
    ,enttypecode -- 企业(机构)类型编码
    ,industrycocode -- 工业代码
    ,industryconame -- 工业业务
    ,dom -- 住址
    ,regorgcode -- 注册地址行政编号
    ,regorgprovince -- 所在省份
    ,regorgcity -- 所在城市
    ,regcity -- 所在城市编码
    ,regorgdistrict -- 所在区/县
    ,postalcode -- 邮编
    ,s_ext_nodenum -- 所在省份编码
    ,entid -- 企业ENTID
    ,paidincap -- 实缴资本(万元)
    ,genmonth -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_shell_entinfo_ent_info_basic
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_shell_entinfo_ent_info_basic',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);