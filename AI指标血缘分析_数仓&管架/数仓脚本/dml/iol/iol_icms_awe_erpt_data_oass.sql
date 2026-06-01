/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_awe_erpt_data_oass
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
drop table ${iol_schema}.icms_awe_erpt_data_oass_ex purge;
alter table ${iol_schema}.icms_awe_erpt_data_oass add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_awe_erpt_data_oass;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_awe_erpt_data_oass_ex nologging
compress
as
select * from ${iol_schema}.icms_awe_erpt_data_oass where 0=1;

insert /*+ append */ into ${iol_schema}.icms_awe_erpt_data_oass_ex(
    serialno -- 流水号字段
    ,relativeserialno -- 对象编号
    ,treeno -- 排序号
    ,docid -- 文档编号
    ,dirid -- 目录编号
    ,dirname -- 目录名称
    ,guarantyno -- 关联担保号
    ,htmldata -- 内容
    ,contentlength -- 长度
    ,userid -- 登记人
    ,orgid -- 登记机构
    ,inputdate -- 登记日期
    ,updatedate -- 更新日期
    ,score -- 评分
    ,scoredesc -- 评分描述
    ,saved -- 保存标志
    ,migtflag -- 迁移标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno -- 流水号字段
    ,relativeserialno -- 对象编号
    ,treeno -- 排序号
    ,docid -- 文档编号
    ,dirid -- 目录编号
    ,dirname -- 目录名称
    ,guarantyno -- 关联担保号
    ,htmldata -- 内容
    ,contentlength -- 长度
    ,userid -- 登记人
    ,orgid -- 登记机构
    ,inputdate -- 登记日期
    ,updatedate -- 更新日期
    ,score -- 评分
    ,scoredesc -- 评分描述
    ,saved -- 保存标志
    ,migtflag -- 迁移标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_awe_erpt_data_oass
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_awe_erpt_data_oass exchange partition p_${batch_date} with table ${iol_schema}.icms_awe_erpt_data_oass_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_awe_erpt_data_oass to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_awe_erpt_data_oass_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_awe_erpt_data_oass',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);