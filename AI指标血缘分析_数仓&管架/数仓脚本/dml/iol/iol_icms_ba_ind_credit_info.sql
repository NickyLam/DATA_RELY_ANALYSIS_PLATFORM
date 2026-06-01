/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ba_ind_credit_info
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
drop table ${iol_schema}.icms_ba_ind_credit_info_ex purge;
alter table ${iol_schema}.icms_ba_ind_credit_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_ba_ind_credit_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_ba_ind_credit_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ba_ind_credit_info where 0=1;

insert /*+ append */ into ${iol_schema}.icms_ba_ind_credit_info_ex(
    serialno -- 流水号
    ,baserialno -- 申请流水号
    ,reportdate -- 报告日期
    ,reportid -- 报告ID
    ,certtype -- 证件类型
    ,certid -- 证件号码
    ,customername -- 客户姓名
    ,customerid -- 客户号
    ,customertype -- 客户类型
    ,relativetype -- 关联人类型
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,inputdate -- 登记日期
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,reportremark -- 征信报告备注
    ,qryopertp -- 查询操作申请类型
    ,authotype -- 授权方式
    ,biometrics -- 生物识别技术
    ,status -- 请求结果状态
    ,pbcdata -- 征信查询结果
    ,migtflag -- 迁移标志：crs rcr ilc upl
    ,authodate -- 授权时间
    ,authostrdate -- 授权起始时间
    ,authoenddate -- 授权结束时间
    ,supplyflag -- 补录标识YesNo 1-是 ，0-否
    ,supplycomplete -- 影像资料是否补充完全YesNo,1-是，0-否
    ,iscreditflag -- 是否查询征信报告
    ,craserialno -- 征信申请流程关联流水号
    ,xxdyxserialno -- 新兴贷用信申请关联流水号
    ,creditvalidatetime -- 征信有效期
    ,authobkid -- 客户数据授权书编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno -- 流水号
    ,baserialno -- 申请流水号
    ,reportdate -- 报告日期
    ,reportid -- 报告ID
    ,certtype -- 证件类型
    ,certid -- 证件号码
    ,customername -- 客户姓名
    ,customerid -- 客户号
    ,customertype -- 客户类型
    ,relativetype -- 关联人类型
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,inputdate -- 登记日期
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,reportremark -- 征信报告备注
    ,qryopertp -- 查询操作申请类型
    ,authotype -- 授权方式
    ,biometrics -- 生物识别技术
    ,status -- 请求结果状态
    ,pbcdata -- 征信查询结果
    ,migtflag -- 迁移标志：crs rcr ilc upl
    ,authodate -- 授权时间
    ,authostrdate -- 授权起始时间
    ,authoenddate -- 授权结束时间
    ,supplyflag -- 补录标识YesNo 1-是 ，0-否
    ,supplycomplete -- 影像资料是否补充完全YesNo,1-是，0-否
    ,iscreditflag -- 是否查询征信报告
    ,craserialno -- 征信申请流程关联流水号
    ,xxdyxserialno -- 新兴贷用信申请关联流水号
    ,creditvalidatetime -- 征信有效期
    ,authobkid -- 客户数据授权书编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_ba_ind_credit_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_ba_ind_credit_info exchange partition p_${batch_date} with table ${iol_schema}.icms_ba_ind_credit_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ba_ind_credit_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_ba_ind_credit_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ba_ind_credit_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);