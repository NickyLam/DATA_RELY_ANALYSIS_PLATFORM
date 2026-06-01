/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_temp_wyd_guarantee_cont_rep_three
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
drop table ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three_ex purge;
alter table ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three_ex nologging
compress
as
select * from ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three where 0=1;

insert /*+ append */ into ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three_ex(
    datadt -- 数据日期
    ,orgid -- 机构号
    ,guarcontractno -- 担保合同号
    ,maincontracttype -- 主合同类型
    ,guaramt -- 担保总金额
    ,ccycd -- 币种
    ,signdate -- 签约日期
    ,maturitydate -- 到期日期
    ,guarcustno -- 保证人或抵质押品的权属人客户号
    ,guarcustname -- 保证人或抵质押品的权属人客户名称
    ,guarcusttype -- 保证人或抵质押品的权属人客户类型
    ,guarcustidtype -- 保证人或抵质押品的权属人客户证件类型
    ,guarcustidno -- 保证人或抵质押品的权属人客户证件号码
    ,guarcontracttype -- 担保合同类型
    ,guartype -- 担保方式
    ,guarstartdate -- 担保起始日期
    ,guarenddate -- 担保到期日期
    ,expiredate -- 担保合同失效日期
    ,guarcontractsts -- 担保合同状态
    ,operator -- 经办员工号
    ,guarantortype -- 保证人类型
    ,contractno -- 额度合同编号
    ,merchantid -- 单位ID
    ,isplatformguar -- 是否是平台批量担保
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    datadt -- 数据日期
    ,orgid -- 机构号
    ,guarcontractno -- 担保合同号
    ,maincontracttype -- 主合同类型
    ,guaramt -- 担保总金额
    ,ccycd -- 币种
    ,signdate -- 签约日期
    ,maturitydate -- 到期日期
    ,guarcustno -- 保证人或抵质押品的权属人客户号
    ,guarcustname -- 保证人或抵质押品的权属人客户名称
    ,guarcusttype -- 保证人或抵质押品的权属人客户类型
    ,guarcustidtype -- 保证人或抵质押品的权属人客户证件类型
    ,guarcustidno -- 保证人或抵质押品的权属人客户证件号码
    ,guarcontracttype -- 担保合同类型
    ,guartype -- 担保方式
    ,guarstartdate -- 担保起始日期
    ,guarenddate -- 担保到期日期
    ,expiredate -- 担保合同失效日期
    ,guarcontractsts -- 担保合同状态
    ,operator -- 经办员工号
    ,guarantortype -- 保证人类型
    ,contractno -- 额度合同编号
    ,merchantid -- 单位ID
    ,isplatformguar -- 是否是平台批量担保
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_temp_wyd_guarantee_cont_rep_three
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three exchange partition p_${batch_date} with table ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_temp_wyd_guarantee_cont_rep_three',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);