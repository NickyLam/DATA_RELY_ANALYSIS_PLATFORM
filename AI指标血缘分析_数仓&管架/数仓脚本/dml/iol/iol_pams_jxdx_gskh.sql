/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_gskh
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
drop table ${iol_schema}.pams_jxdx_gskh_ex purge;
alter table ${iol_schema}.pams_jxdx_gskh add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.pams_jxdx_gskh;

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxdx_gskh_ex nologging
compress
as
select * from ${iol_schema}.pams_jxdx_gskh where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxdx_gskh_ex(
    jxdxdh -- 考核对象代号
    ,khh -- 客户号
    ,khlx -- 客户类型
    ,jgdh -- 机构代号
    ,khmc -- 客户名称
    ,zjlb -- 证件类别
    ,zjhm -- 证件号码
    ,khjjxz -- 客户经济性质
    ,khhylb -- 客户行业类别
    ,qygm -- 企业规模
    ,txdz -- 通讯地址
    ,dwdh -- 单位电话
    ,dzyj -- 电子邮件
    ,lxdh -- 联系电话
    ,khzt -- 客户状态
    ,khrq -- 开户日期
    ,zczb -- 注册资本
    ,khlyxx -- 客户来源信息
    ,gxhslx -- 关系函数类型
    ,csrq -- 出生日期
    ,tjrq -- 统计日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    jxdxdh -- 考核对象代号
    ,khh -- 客户号
    ,khlx -- 客户类型
    ,jgdh -- 机构代号
    ,khmc -- 客户名称
    ,zjlb -- 证件类别
    ,zjhm -- 证件号码
    ,khjjxz -- 客户经济性质
    ,khhylb -- 客户行业类别
    ,qygm -- 企业规模
    ,txdz -- 通讯地址
    ,dwdh -- 单位电话
    ,dzyj -- 电子邮件
    ,lxdh -- 联系电话
    ,khzt -- 客户状态
    ,khrq -- 开户日期
    ,zczb -- 注册资本
    ,khlyxx -- 客户来源信息
    ,gxhslx -- 关系函数类型
    ,csrq -- 出生日期
    ,tjrq -- 统计日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxdx_gskh
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxdx_gskh exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_gskh_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_gskh to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxdx_gskh_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_gskh',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);