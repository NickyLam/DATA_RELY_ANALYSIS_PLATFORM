/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_cci
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
drop table ${iol_schema}.isbs_cci_ex purge;
alter table ${iol_schema}.isbs_cci add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.isbs_cci truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.isbs_cci_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_cci where 0=1;

insert /*+ append */ into ${iol_schema}.isbs_cci_ex(
    objtyp -- 关联对象类型
    ,objinr -- 关联对象inr
    ,ownref -- 业务编号
    ,nam -- 名称
    ,ownusr -- 经办用户
    ,credat -- 创建日期
    ,opndat -- 开立时间
    ,clsdat -- 闭卷日期
    ,amedat -- 上次修改日期
    ,expdat -- 到期日
    ,ccibanrol -- 银行角色
    ,ccibanptainr -- 银行pta表inr
    ,ccicusrol -- 客户角色
    ,ccicusptainr -- 客户pta表inr
    ,ver -- 版本号
    ,etyextkey -- 实体关键字
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    objtyp -- 关联对象类型
    ,objinr -- 关联对象inr
    ,ownref -- 业务编号
    ,nam -- 名称
    ,ownusr -- 经办用户
    ,credat -- 创建日期
    ,opndat -- 开立时间
    ,clsdat -- 闭卷日期
    ,amedat -- 上次修改日期
    ,expdat -- 到期日
    ,ccibanrol -- 银行角色
    ,ccibanptainr -- 银行pta表inr
    ,ccicusrol -- 客户角色
    ,ccicusptainr -- 客户pta表inr
    ,ver -- 版本号
    ,etyextkey -- 实体关键字
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.isbs_cci
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.isbs_cci exchange partition p_${batch_date} with table ${iol_schema}.isbs_cci_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_cci to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.isbs_cci_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_cci',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);