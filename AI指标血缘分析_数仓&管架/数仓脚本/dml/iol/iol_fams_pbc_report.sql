/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_pbc_report
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
drop table ${iol_schema}.fams_pbc_report_ex purge;
alter table ${iol_schema}.fams_pbc_report add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.fams_pbc_report;

-- 2.3 insert data to ex table
create table ${iol_schema}.fams_pbc_report_ex nologging
compress
as
select * from ${iol_schema}.fams_pbc_report where 0=1;

insert /*+ append */ into ${iol_schema}.fams_pbc_report_ex(
    reportuuid -- 主键
    ,termid -- 期数
    ,reporttype -- 报表类型:
    ,startdate -- 开始日期
    ,enddate -- 结束日期
    ,issue_party_id -- 发行机构代码
    ,issue_party_name -- 发行机构名称
    ,reportfrequ -- 报表频率：D-日，WE-周报，M-月报，S-季，Y-年
    ,report_org_name -- 填报机构名称
    ,social_credit_code -- 社会信用代码
    ,fin_institution_code -- 金融机构编码
    ,prod_variety -- 产品品种
    ,person_liable -- 责任人
    ,contact -- 联系方式
    ,report_date -- 制表日期
    ,submit_time -- 报送日期
    ,chb_submit_deadline -- 中债报送截止日
    ,submit_deadline -- 行内报送截止日
    ,submit_feedback_status -- 返回信息
    ,status -- 有效状态
    ,send_status -- 报送状态
    ,status_date -- 数据日期
    ,create_user -- 创建人
    ,create_time -- 创建时间
    ,update_user -- 更新人
    ,update_time -- 更新时间
    ,org_code -- 机构代码
    ,dept_code -- 部门代码
    ,create_dept -- 创建部门
    ,pbc_account_id -- 资产池代码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    reportuuid -- 主键
    ,termid -- 期数
    ,reporttype -- 报表类型:
    ,startdate -- 开始日期
    ,enddate -- 结束日期
    ,issue_party_id -- 发行机构代码
    ,issue_party_name -- 发行机构名称
    ,reportfrequ -- 报表频率：D-日，WE-周报，M-月报，S-季，Y-年
    ,report_org_name -- 填报机构名称
    ,social_credit_code -- 社会信用代码
    ,fin_institution_code -- 金融机构编码
    ,prod_variety -- 产品品种
    ,person_liable -- 责任人
    ,contact -- 联系方式
    ,report_date -- 制表日期
    ,submit_time -- 报送日期
    ,chb_submit_deadline -- 中债报送截止日
    ,submit_deadline -- 行内报送截止日
    ,submit_feedback_status -- 返回信息
    ,status -- 有效状态
    ,send_status -- 报送状态
    ,status_date -- 数据日期
    ,create_user -- 创建人
    ,create_time -- 创建时间
    ,update_user -- 更新人
    ,update_time -- 更新时间
    ,org_code -- 机构代码
    ,dept_code -- 部门代码
    ,create_dept -- 创建部门
    ,pbc_account_id -- 资产池代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.fams_pbc_report
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.fams_pbc_report exchange partition p_${batch_date} with table ${iol_schema}.fams_pbc_report_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_pbc_report to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.fams_pbc_report_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_pbc_report',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);