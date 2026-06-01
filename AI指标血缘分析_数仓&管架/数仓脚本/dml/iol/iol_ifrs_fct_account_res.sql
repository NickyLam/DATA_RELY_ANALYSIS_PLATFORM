/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifrs_fct_account_res
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
drop table ${iol_schema}.ifrs_fct_account_res_ex purge;
alter table ${iol_schema}.ifrs_fct_account_res add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ifrs_fct_account_res truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ifrs_fct_account_res_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifrs_fct_account_res where 0=1;

insert /*+ append */ into ${iol_schema}.ifrs_fct_account_res_ex(
    dt -- 数据日期
    ,org -- 入账机构号
    ,ccy -- 币种
    ,sub_name -- 入账科目名称
    ,sub -- 入账科目号(转换为借贷科目)
    ,dac -- 借/贷方
    ,debit_cur -- 总账科目借方余额
    ,credit_cur -- 总账科目贷方余额
    ,debit_happen_cur -- 减值借方发生额
    ,credit_happen_cur -- 减值贷方发生额
    ,debit_currently_cur -- 科目借方余额
    ,credit_currently_cur -- 科目贷方余额
    ,v_asset_type_cd -- 三分类
    ,v_sub_cd_before -- 科目(旧)
    ,rep_debit_cur -- 报表借方余额
    ,rep_credit_cur -- 报表贷方余额
    ,rep_debit_currently_cur -- 报表科目借方余额
    ,rep_credit_currently_cur -- 报表科目贷方余额
    ,orderby_id -- 正常:1,国别风险:2
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    dt -- 数据日期
    ,org -- 入账机构号
    ,ccy -- 币种
    ,sub_name -- 入账科目名称
    ,sub -- 入账科目号(转换为借贷科目)
    ,dac -- 借/贷方
    ,debit_cur -- 总账科目借方余额
    ,credit_cur -- 总账科目贷方余额
    ,debit_happen_cur -- 减值借方发生额
    ,credit_happen_cur -- 减值贷方发生额
    ,debit_currently_cur -- 科目借方余额
    ,credit_currently_cur -- 科目贷方余额
    ,v_asset_type_cd -- 三分类
    ,v_sub_cd_before -- 科目(旧)
    ,rep_debit_cur -- 报表借方余额
    ,rep_credit_cur -- 报表贷方余额
    ,rep_debit_currently_cur -- 报表科目借方余额
    ,rep_credit_currently_cur -- 报表科目贷方余额
    ,orderby_id -- 正常:1,国别风险:2
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifrs_fct_account_res
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifrs_fct_account_res exchange partition p_${batch_date} with table ${iol_schema}.ifrs_fct_account_res_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifrs_fct_account_res to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifrs_fct_account_res_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifrs_fct_account_res',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);