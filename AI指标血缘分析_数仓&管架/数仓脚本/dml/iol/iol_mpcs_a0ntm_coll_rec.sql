/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0ntm_coll_rec
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
drop table ${iol_schema}.mpcs_a0ntm_coll_rec_ex purge;
alter table ${iol_schema}.mpcs_a0ntm_coll_rec add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a0ntm_coll_rec truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a0ntm_coll_rec_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0ntm_coll_rec where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a0ntm_coll_rec_ex(
    org -- 机构号
    ,coll_rec_id -- 催记流水号
    ,case_no -- 案件编号
    ,cust_id -- 客户编号
    ,coll_rec_type -- 催记类型
    ,action_code -- 催收动作
    ,buser_field21 -- 系统备用域21
    ,buser_field22 -- 系统备用域22
    ,coll_time -- 催收时间
    ,coll_conseq -- 催收结果
    ,prom_amt -- 承诺金额
    ,prom_date -- 承诺日期
    ,remark -- 备注
    ,buser_field23 -- 系统备用域23
    ,buser_field24 -- 系统备用域24
    ,buser_field25 -- 系统备用域25
    ,buser_field26 -- 系统备用域26
    ,buser_field27 -- 系统备用域27
    ,buser_field28 -- 系统备用域28
    ,buser_field29 -- 系统备用域29
    ,buser_field30 -- 系统备用域30
    ,buser_field31 -- 系统备用域31
    ,buser_field32 -- 系统备用域32
    ,buser_field33 -- 系统备用域33
    ,buser_field34 -- 系统备用域34
    ,buser_field35 -- 系统备用域35
    ,buser_field36 -- 系统备用域36
    ,created_datetime -- 创建时间
    ,last_modified_datetime -- 最后修改时间
    ,jpa_version -- JPA_VERSION
    ,batchfilename -- 批量文件名
    ,seqno -- 序列号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    org -- 机构号
    ,coll_rec_id -- 催记流水号
    ,case_no -- 案件编号
    ,cust_id -- 客户编号
    ,coll_rec_type -- 催记类型
    ,action_code -- 催收动作
    ,buser_field21 -- 系统备用域21
    ,buser_field22 -- 系统备用域22
    ,coll_time -- 催收时间
    ,coll_conseq -- 催收结果
    ,prom_amt -- 承诺金额
    ,prom_date -- 承诺日期
    ,remark -- 备注
    ,buser_field23 -- 系统备用域23
    ,buser_field24 -- 系统备用域24
    ,buser_field25 -- 系统备用域25
    ,buser_field26 -- 系统备用域26
    ,buser_field27 -- 系统备用域27
    ,buser_field28 -- 系统备用域28
    ,buser_field29 -- 系统备用域29
    ,buser_field30 -- 系统备用域30
    ,buser_field31 -- 系统备用域31
    ,buser_field32 -- 系统备用域32
    ,buser_field33 -- 系统备用域33
    ,buser_field34 -- 系统备用域34
    ,buser_field35 -- 系统备用域35
    ,buser_field36 -- 系统备用域36
    ,created_datetime -- 创建时间
    ,last_modified_datetime -- 最后修改时间
    ,jpa_version -- JPA_VERSION
    ,batchfilename -- 批量文件名
    ,seqno -- 序列号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a0ntm_coll_rec
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a0ntm_coll_rec exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a0ntm_coll_rec_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0ntm_coll_rec to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a0ntm_coll_rec_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0ntm_coll_rec',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);