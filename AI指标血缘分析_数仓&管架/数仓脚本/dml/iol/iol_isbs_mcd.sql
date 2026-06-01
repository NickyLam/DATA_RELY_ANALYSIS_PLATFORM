/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_mcd
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
drop table ${iol_schema}.isbs_mcd_ex purge;
alter table ${iol_schema}.isbs_mcd add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.isbs_mcd;

-- 2.3 insert data to ex table
create table ${iol_schema}.isbs_mcd_ex nologging
compress
as
select * from ${iol_schema}.isbs_mcd where 0=1;

insert /*+ append */ into ${iol_schema}.isbs_mcd_ex(
    inr -- 唯一ID
    ,ownref -- 交易参考号
    ,nam -- 交易名称
    ,ownusr -- 责任人
    ,credat -- 创建时间
    ,opndat -- 激活时间
    ,clsdat -- 关闭时间
    ,expdat -- 到期时间
    ,orddat -- 定但时间
    ,aderef -- 收件人参考号
    ,aplref -- 申请人参考号
    ,ver -- 版本号
    ,stacty -- 国家代码
    ,etyextkey -- 实体标志
    ,branchinr -- 所属机构号
    ,bchkeyinr -- 经办机构号
    ,mcttyp -- 手工交易类型
    ,subref -- 子参考号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    inr -- 唯一ID
    ,ownref -- 交易参考号
    ,nam -- 交易名称
    ,ownusr -- 责任人
    ,credat -- 创建时间
    ,opndat -- 激活时间
    ,clsdat -- 关闭时间
    ,expdat -- 到期时间
    ,orddat -- 定但时间
    ,aderef -- 收件人参考号
    ,aplref -- 申请人参考号
    ,ver -- 版本号
    ,stacty -- 国家代码
    ,etyextkey -- 实体标志
    ,branchinr -- 所属机构号
    ,bchkeyinr -- 经办机构号
    ,mcttyp -- 手工交易类型
    ,subref -- 子参考号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.isbs_mcd
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.isbs_mcd exchange partition p_${batch_date} with table ${iol_schema}.isbs_mcd_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_mcd to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.isbs_mcd_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_mcd',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);