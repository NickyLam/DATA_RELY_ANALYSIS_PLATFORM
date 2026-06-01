/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_tzbl_hkje
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
drop table ${iol_schema}.rcds_ir_tzbl_hkje_ex purge;
alter table ${iol_schema}.rcds_ir_tzbl_hkje add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.rcds_ir_tzbl_hkje;

-- 2.3 insert data to ex table
create table ${iol_schema}.rcds_ir_tzbl_hkje_ex nologging
compress
as
select * from ${iol_schema}.rcds_ir_tzbl_hkje where 0=1;

insert /*+ append */ into ${iol_schema}.rcds_ir_tzbl_hkje_ex(
    key_id -- 主键
    ,loan_no -- 借据号
    ,data_dt -- 数据日期
    ,loan_biz_type_cd -- 业务品种代码
    ,var0201 -- 当前月还款金额
    ,var0202 -- 过去3个月还款金额的平均值
    ,var0203 -- 过去6个月还款金额的平均值
    ,var0204 -- 过去12个月还款金额的平均值
    ,var0205 -- 过去3个月还款金额的总和
    ,var0206 -- 过去6个月还款金额的总和
    ,var0207 -- 过去12个月还款金额的总和
    ,var0208 -- 过去3个月还款金额最小值
    ,var0209 -- 过去6个月还款金额最小值
    ,var0210 -- 过去12个月还款金额最小值
    ,var0211 -- 过去3个月还款金额最大值
    ,var0212 -- 过去6个月还款金额最大值
    ,var0213 -- 过去12个月还款金额最大值
    ,var0214 -- 过去3个月还款金额>0的次数
    ,var0215 -- 过去6个月还款金额>0的次数
    ,var0216 -- 过去12个月还款金额>0的次数
    ,var0217 -- 过去3个月还款金额最后一次>0的距今月数
    ,var0218 -- 过去6个月还款金额最后一次>0的距今月数
    ,var0219 -- 过去12个月还款金额最后一次>0的距今月数
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    key_id -- 主键
    ,loan_no -- 借据号
    ,data_dt -- 数据日期
    ,loan_biz_type_cd -- 业务品种代码
    ,var0201 -- 当前月还款金额
    ,var0202 -- 过去3个月还款金额的平均值
    ,var0203 -- 过去6个月还款金额的平均值
    ,var0204 -- 过去12个月还款金额的平均值
    ,var0205 -- 过去3个月还款金额的总和
    ,var0206 -- 过去6个月还款金额的总和
    ,var0207 -- 过去12个月还款金额的总和
    ,var0208 -- 过去3个月还款金额最小值
    ,var0209 -- 过去6个月还款金额最小值
    ,var0210 -- 过去12个月还款金额最小值
    ,var0211 -- 过去3个月还款金额最大值
    ,var0212 -- 过去6个月还款金额最大值
    ,var0213 -- 过去12个月还款金额最大值
    ,var0214 -- 过去3个月还款金额>0的次数
    ,var0215 -- 过去6个月还款金额>0的次数
    ,var0216 -- 过去12个月还款金额>0的次数
    ,var0217 -- 过去3个月还款金额最后一次>0的距今月数
    ,var0218 -- 过去6个月还款金额最后一次>0的距今月数
    ,var0219 -- 过去12个月还款金额最后一次>0的距今月数
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rcds_ir_tzbl_hkje
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rcds_ir_tzbl_hkje exchange partition p_${batch_date} with table ${iol_schema}.rcds_ir_tzbl_hkje_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_tzbl_hkje to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rcds_ir_tzbl_hkje_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_tzbl_hkje',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);