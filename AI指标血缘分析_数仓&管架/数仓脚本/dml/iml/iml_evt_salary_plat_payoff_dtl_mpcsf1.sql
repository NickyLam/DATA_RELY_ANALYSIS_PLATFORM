/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_salary_plat_payoff_dtl_mpcsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_salary_plat_payoff_dtl_mpcsf1_tm purge;
alter table ${iml_schema}.evt_salary_plat_payoff_dtl add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_salary_plat_payoff_dtl modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_salary_plat_payoff_dtl_mpcsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dtl_id -- 明细编号
    ,batch_id -- 批次编号
    ,tran_status_cd -- 交易状态代码
    ,cntpty_acct_id -- 对手账户编号
    ,tran_amt -- 交易金额
    ,over_lmt_amt_lmt -- 超限金额
    ,remark -- 备注
    ,emply_id -- 员工编号
    ,emply_name -- 员工姓名
    ,emply_tel -- 员工电话
    ,staf_cd_piece_no_code -- 员工证件号码
    ,corp_id -- 企业编号
    ,corp_name -- 企业名称
    ,batch_create_dt -- 批次创建日期
    ,batch_update_dt -- 批次更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_salary_plat_payoff_dtl
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- mpcs_a1wsp_batch_dtl_info-1
insert into ${iml_schema}.evt_salary_plat_payoff_dtl_mpcsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dtl_id -- 明细编号
    ,batch_id -- 批次编号
    ,tran_status_cd -- 交易状态代码
    ,cntpty_acct_id -- 对手账户编号
    ,tran_amt -- 交易金额
    ,over_lmt_amt_lmt -- 超限金额
    ,remark -- 备注
    ,emply_id -- 员工编号
    ,emply_name -- 员工姓名
    ,emply_tel -- 员工电话
    ,staf_cd_piece_no_code -- 员工证件号码
    ,corp_id -- 企业编号
    ,corp_name -- 企业名称
    ,batch_create_dt -- 批次创建日期
    ,batch_update_dt -- 批次更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102075'||P1.DETAIL_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.DETAIL_NO -- 明细编号
    ,P1.BATCH_NO -- 批次编号
    ,nvl(trim(P1.TRANS_STATUS),'-') -- 交易状态代码
    ,P1.PAYEE_ACCT_NO -- 对手账户编号
    ,to_number(nvl(trim(P1.TRANS_AMT),'0')) -- 交易金额
    ,to_number(nvl(trim(P1.TRANS_SPLIT_AMT),'0')) -- 超限金额
    ,P1.DTL_REMARK -- 备注
    ,P1.EMPLOYEE_ID -- 员工编号
    ,P1.EMPLOYEE_NAME -- 员工姓名
    ,P1.PHONE_NO -- 员工电话
    ,P1.CERT_NO -- 员工证件号码
    ,P1.COMPANY_ID -- 企业编号
    ,P1.COMPANY_NAME -- 企业名称
    ,${iml_schema}.dateformat_min(P1.CREATE_TIMESTAMP) -- 批次创建日期
    ,${iml_schema}.dateformat_max2(P1.UPDATE_TIMESTAMP) -- 批次更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a1wsp_batch_dtl_info' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a1wsp_batch_dtl_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_salary_plat_payoff_dtl truncate partition p_mpcsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_salary_plat_payoff_dtl exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.evt_salary_plat_payoff_dtl_mpcsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_salary_plat_payoff_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_salary_plat_payoff_dtl_mpcsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_salary_plat_payoff_dtl', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);