/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifrs_fct_account_res_estimatio_mid1
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
drop table ${iol_schema}.ifrs_fct_account_res_estimatio_mid1_ex purge;
alter table ${iol_schema}.ifrs_fct_account_res_estimatio_mid1 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ifrs_fct_account_res_estimatio_mid1 truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ifrs_fct_account_res_estimatio_mid1_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifrs_fct_account_res_estimatio_mid1 where 0=1;

insert /*+ append */ into ${iol_schema}.ifrs_fct_account_res_estimatio_mid1_ex(
    dt                           -- 数据日期
    ,three_cd                     -- 三分类
    ,org                          -- 机构
    ,ccy                          -- 币种
    ,sub_name                     -- 科目名
    ,sub                          -- 科目号
    ,dac                          -- 借贷标识
    ,report_acc_cur_debit         -- 报表：总账借方本期余额
    ,report_acc_cur_credit        -- 报表：总账贷方本期余额
    ,debit_pv_cur                 -- 借方公允价值变动（T1-T2）rh
    ,credit_pv_cur                -- 方公允价值变动（T1-T2）rh
    ,report_acc_cur_deibt_dis     -- 报表：轧差借方
    ,report_acc_cur_credit_dis    -- 报表：轧差贷方
    ,to_acc_cur_debit             -- 总账借方本期余额
    ,to_acc_cur_credit            -- 总账贷方本期余额
    ,to_acc_cur_debit_dis         -- 入账：轧差借方r
    ,to_acc_cur_credit_dis        -- 入账：轧差贷方r
    ,v_sub_before                 -- 拼接科目码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    dt                           -- 数据日期
    ,three_cd                     -- 三分类
    ,org                          -- 机构
    ,ccy                          -- 币种
    ,sub_name                     -- 科目名
    ,sub                          -- 科目号
    ,dac                          -- 借贷标识
    ,report_acc_cur_debit         -- 报表：总账借方本期余额
    ,report_acc_cur_credit        -- 报表：总账贷方本期余额
    ,debit_pv_cur                 -- 借方公允价值变动（T1-T2）rh
    ,credit_pv_cur                -- 方公允价值变动（T1-T2）rh
    ,report_acc_cur_deibt_dis     -- 报表：轧差借方
    ,report_acc_cur_credit_dis    -- 报表：轧差贷方
    ,to_acc_cur_debit             -- 总账借方本期余额
    ,to_acc_cur_credit            -- 总账贷方本期余额
    ,to_acc_cur_debit_dis         -- 入账：轧差借方r
    ,to_acc_cur_credit_dis        -- 入账：轧差贷方r
    ,v_sub_before                 -- 拼接科目码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifrs_fct_account_res_estimatio_mid1
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifrs_fct_account_res_estimatio_mid1 exchange partition p_${batch_date} with table ${iol_schema}.ifrs_fct_account_res_estimatio_mid1_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifrs_fct_account_res_estimatio_mid1 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifrs_fct_account_res_estimatio_mid1_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifrs_fct_account_res_estimatio_mid1',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);