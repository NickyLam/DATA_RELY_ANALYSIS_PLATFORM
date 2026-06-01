/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_tmp_zjbk_inctrctinfo
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
drop table ${iol_schema}.icms_tmp_zjbk_inctrctinfo_ex purge;
alter table ${iol_schema}.icms_tmp_zjbk_inctrctinfo add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_tmp_zjbk_inctrctinfo truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_tmp_zjbk_inctrctinfo_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_tmp_zjbk_inctrctinfo where 0=1;

insert /*+ append */ into ${iol_schema}.icms_tmp_zjbk_inctrctinfo_ex(
    infrectype -- 信息记录类型
    ,contractcode -- 授信协议标识码
    ,rptdate -- 信息报告日期
    ,rptdatecode -- 报告时点说明代码
    ,name -- 受信人姓名
    ,idtype -- 受信人证件类型
    ,idnum -- 受信人证件号码
    ,mngmtorgcode -- 业务管理机构代码
    ,ctrctcertrelsgmt_updflag -- 共同受信人信息段上报标志
    ,creditlimsgmt_updflag -- 额度信息段上报标志
    ,brernm -- 共同受信人个数
    ,ctrctcertreldata -- 共同受信人信息段
    ,creditlimtype -- 授信额度类型
    ,limloopflg -- 额度循环标志
    ,creditlim -- 授信额度
    ,cy -- 币种
    ,coneffdate -- 额度生效日期
    ,conexpdate -- 额度到期日期
    ,constatus -- 额度状态
    ,creditrest -- 授信限额
    ,creditrestcode -- 授信限额编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    infrectype -- 信息记录类型
    ,contractcode -- 授信协议标识码
    ,rptdate -- 信息报告日期
    ,rptdatecode -- 报告时点说明代码
    ,name -- 受信人姓名
    ,idtype -- 受信人证件类型
    ,idnum -- 受信人证件号码
    ,mngmtorgcode -- 业务管理机构代码
    ,ctrctcertrelsgmt_updflag -- 共同受信人信息段上报标志
    ,creditlimsgmt_updflag -- 额度信息段上报标志
    ,brernm -- 共同受信人个数
    ,ctrctcertreldata -- 共同受信人信息段
    ,creditlimtype -- 授信额度类型
    ,limloopflg -- 额度循环标志
    ,creditlim -- 授信额度
    ,cy -- 币种
    ,coneffdate -- 额度生效日期
    ,conexpdate -- 额度到期日期
    ,constatus -- 额度状态
    ,creditrest -- 授信限额
    ,creditrestcode -- 授信限额编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_tmp_zjbk_inctrctinfo
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_tmp_zjbk_inctrctinfo exchange partition p_${batch_date} with table ${iol_schema}.icms_tmp_zjbk_inctrctinfo_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_tmp_zjbk_inctrctinfo to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_tmp_zjbk_inctrctinfo_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_tmp_zjbk_inctrctinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);