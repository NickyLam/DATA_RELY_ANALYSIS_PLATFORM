/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_batch_law_attach
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
drop table ${iol_schema}.ncbs_rb_batch_law_attach_ex purge;
alter table ${iol_schema}.ncbs_rb_batch_law_attach add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_rb_batch_law_attach;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_batch_law_attach_ex nologging
compress
as
select * from ${iol_schema}.ncbs_rb_batch_law_attach where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_batch_law_attach_ex(
    batch_no -- 批次号
    ,company -- 法人
    ,detail_file_name -- 明细文件名称
    ,law_no -- 法律文书号
    ,main_file_name -- 汇总文件名称
    ,tran_timestamp -- 交易时间戳
    ,deduction_judiciary_name -- 有权机关名称
    ,judiciary_document_id -- 执法人1证件号码
    ,judiciary_document_id1 -- 执法人1证件号码1
    ,judiciary_document_type -- 执法人1证件类型
    ,judiciary_document_type1 -- 执法人1证件类型1
    ,judiciary_officer_name -- 执法人1姓名
    ,judiciary_oth_document_id -- 执法人2证件号码
    ,judiciary_oth_document_id1 -- 执法人2证件号码1
    ,judiciary_oth_document_type -- 执法人2证件类型
    ,judiciary_oth_document_type1 -- 执法人2证件类型1
    ,judiciary_oth_officer_name -- 执法人2姓名
    ,case_type -- 案件类型
    ,deduction_judiciary_part -- 执法部门
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    batch_no -- 批次号
    ,company -- 法人
    ,detail_file_name -- 明细文件名称
    ,law_no -- 法律文书号
    ,main_file_name -- 汇总文件名称
    ,tran_timestamp -- 交易时间戳
    ,deduction_judiciary_name -- 有权机关名称
    ,judiciary_document_id -- 执法人1证件号码
    ,judiciary_document_id1 -- 执法人1证件号码1
    ,judiciary_document_type -- 执法人1证件类型
    ,judiciary_document_type1 -- 执法人1证件类型1
    ,judiciary_officer_name -- 执法人1姓名
    ,judiciary_oth_document_id -- 执法人2证件号码
    ,judiciary_oth_document_id1 -- 执法人2证件号码1
    ,judiciary_oth_document_type -- 执法人2证件类型
    ,judiciary_oth_document_type1 -- 执法人2证件类型1
    ,judiciary_oth_officer_name -- 执法人2姓名
    ,case_type -- 案件类型
    ,deduction_judiciary_part -- 执法部门
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_batch_law_attach
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_batch_law_attach exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_batch_law_attach_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_batch_law_attach to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_batch_law_attach_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_batch_law_attach',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);