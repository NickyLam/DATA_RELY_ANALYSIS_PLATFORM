/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_gdpronsrsqssxx_body_djnsrxx
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
drop table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx_ex purge;
alter table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx_ex(
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,scjydz -- 生产经营地址
    ,zzlx_dm -- 执照类型代码
    ,zgswskfj_dm -- 主管税务所（科、分局）代码
    ,gdghlx_dm -- 国地管户类型代码
    ,scjydzxzqhszmc -- 生产经营地址行政区划数字名称
    ,hymc -- 行业名称
    ,djnsrxx -- 关联标签
    ,nsrztmc -- 纳税人状态代码
    ,zcdzxzqhsz_dm -- 注册地址行政区划数字代码
    ,zzlxmc -- 执照类型名称
    ,kyslrq -- 开业设立日期
    ,dwlsgxmc -- 单位隶属关系名称
    ,fddbrxm -- 法定代表人姓名
    ,fddbrsfzjlx_dm -- 法定代表人身份证件类型代码
    ,ssgly_dm -- 税收管理员代码
    ,gdslx_dm -- 国地税类型代码
    ,djzclxmc -- 登记注册类型名称
    ,zcdz -- 注册地址
    ,djxh -- 登记序号
    ,hy_dm -- 行业代码
    ,ssglymc -- 税收管理员名称
    ,zcdzxzqhszmc -- 注册地址行政区划数字名称
    ,shxydm -- 社会信用代码
    ,nsrsbh -- 税务代理人纳税人识别号
    ,gdslxmc -- 国地税类型名称
    ,fddbrsfzjlxmc -- 法定代表人身份证件类型名称
    ,djrq -- 登记日期
    ,djjgmc -- 登记机关名称
    ,djjg_dm -- 登记机关代码
    ,nsrzt_dm -- 纳税人状态代码
    ,zzhm -- 证照编号
    ,djzclx_dm -- 登记注册类型代码
    ,ssdabh -- 税收档案编号
    ,nsrmc -- 纳税人名称
    ,zzjg_dm -- 组织机构代码
    ,zgswskfjmc -- 主管税务所（科、分局）名称
    ,jdxz_dm -- 街道乡镇代码
    ,fddbrsfzjhm -- 法定代表人身份证号码
    ,zzjgmc -- 组织机构名称
    ,zgswj_dm -- 主管税务局代码
    ,jdxzmc -- 街道乡镇名称
    ,zgswjmc -- 主管税务局名称
    ,dwlsgx_dm -- 单位隶属关系代码
    ,gdghlxmc -- 国地管户类型名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,scjydz -- 生产经营地址
    ,zzlx_dm -- 执照类型代码
    ,zgswskfj_dm -- 主管税务所（科、分局）代码
    ,gdghlx_dm -- 国地管户类型代码
    ,scjydzxzqhszmc -- 生产经营地址行政区划数字名称
    ,hymc -- 行业名称
    ,djnsrxx -- 关联标签
    ,nsrztmc -- 纳税人状态代码
    ,zcdzxzqhsz_dm -- 注册地址行政区划数字代码
    ,zzlxmc -- 执照类型名称
    ,kyslrq -- 开业设立日期
    ,dwlsgxmc -- 单位隶属关系名称
    ,fddbrxm -- 法定代表人姓名
    ,fddbrsfzjlx_dm -- 法定代表人身份证件类型代码
    ,ssgly_dm -- 税收管理员代码
    ,gdslx_dm -- 国地税类型代码
    ,djzclxmc -- 登记注册类型名称
    ,zcdz -- 注册地址
    ,djxh -- 登记序号
    ,hy_dm -- 行业代码
    ,ssglymc -- 税收管理员名称
    ,zcdzxzqhszmc -- 注册地址行政区划数字名称
    ,shxydm -- 社会信用代码
    ,nsrsbh -- 税务代理人纳税人识别号
    ,gdslxmc -- 国地税类型名称
    ,fddbrsfzjlxmc -- 法定代表人身份证件类型名称
    ,djrq -- 登记日期
    ,djjgmc -- 登记机关名称
    ,djjg_dm -- 登记机关代码
    ,nsrzt_dm -- 纳税人状态代码
    ,zzhm -- 证照编号
    ,djzclx_dm -- 登记注册类型代码
    ,ssdabh -- 税收档案编号
    ,nsrmc -- 纳税人名称
    ,zzjg_dm -- 组织机构代码
    ,zgswskfjmc -- 主管税务所（科、分局）名称
    ,jdxz_dm -- 街道乡镇代码
    ,fddbrsfzjhm -- 法定代表人身份证号码
    ,zzjgmc -- 组织机构名称
    ,zgswj_dm -- 主管税务局代码
    ,jdxzmc -- 街道乡镇名称
    ,zgswjmc -- 主管税务局名称
    ,dwlsgx_dm -- 单位隶属关系代码
    ,gdghlxmc -- 国地管户类型名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_djnsrxx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_gdpronsrsqssxx_body_djnsrxx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);