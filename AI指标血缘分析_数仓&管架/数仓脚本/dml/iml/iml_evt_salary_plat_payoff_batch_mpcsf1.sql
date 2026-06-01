/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_salary_plat_payoff_batch_mpcsf1
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
drop table ${iml_schema}.evt_salary_plat_payoff_batch_mpcsf1_tm purge;
alter table ${iml_schema}.evt_salary_plat_payoff_batch add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_salary_plat_payoff_batch modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_salary_plat_payoff_batch_mpcsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,batch_caption -- 批次标题
    ,batch_flow_cd -- 批次流程代码
    ,batch_status_cd -- 批次状态代码
    ,batch_dt -- 批次日期
    ,batch_cmplt_dt -- 批次完成日期
    ,corp_id -- 企业编号
    ,corp_name -- 企业名称
    ,payoff_src_cd -- 代发来源代码
    ,payoff_kind_cd -- 代发种类代码
    ,payoff_year -- 代发年份
    ,payoff_mon -- 代发月份
    ,tot_number -- 总人数
    ,tot -- 总笔数
    ,tot_amt -- 总金额
    ,avg_amt -- 平均金额
    ,sucs_tot_amt -- 成功总金额
    ,fail_tot_amt -- 失败总金额
    ,sucs_cnt -- 成功笔数
    ,fail_cnt -- 失败笔数
    ,tran_status_union_qtty -- 交易状态未知数量
    ,apv_ser_num -- 审批序列号
    ,salary_group_id -- 薪酬组编号
    ,org_id -- 机构编号
    ,diplay_payoff_dtl_flg -- 展示代发明细标志
    ,lock_flg -- 锁定标志
    ,batch_create_dt -- 批次创建日期
    ,batch_update_dt -- 批次更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_salary_plat_payoff_batch
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- mpcs_a1wsp_batch_info-1
insert into ${iml_schema}.evt_salary_plat_payoff_batch_mpcsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,batch_caption -- 批次标题
    ,batch_flow_cd -- 批次流程代码
    ,batch_status_cd -- 批次状态代码
    ,batch_dt -- 批次日期
    ,batch_cmplt_dt -- 批次完成日期
    ,corp_id -- 企业编号
    ,corp_name -- 企业名称
    ,payoff_src_cd -- 代发来源代码
    ,payoff_kind_cd -- 代发种类代码
    ,payoff_year -- 代发年份
    ,payoff_mon -- 代发月份
    ,tot_number -- 总人数
    ,tot -- 总笔数
    ,tot_amt -- 总金额
    ,avg_amt -- 平均金额
    ,sucs_tot_amt -- 成功总金额
    ,fail_tot_amt -- 失败总金额
    ,sucs_cnt -- 成功笔数
    ,fail_cnt -- 失败笔数
    ,tran_status_union_qtty -- 交易状态未知数量
    ,apv_ser_num -- 审批序列号
    ,salary_group_id -- 薪酬组编号
    ,org_id -- 机构编号
    ,diplay_payoff_dtl_flg -- 展示代发明细标志
    ,lock_flg -- 锁定标志
    ,batch_create_dt -- 批次创建日期
    ,batch_update_dt -- 批次更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102074'||P1.BATCH_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BATCH_NO -- 批次编号
    ,P1.BATCH_TITLE -- 批次标题
    ,nvl(trim(P1.BATCH_STEP),'-') -- 批次流程代码
    ,nvl(trim(P1.BATCH_STATUS),'-') -- 批次状态代码
    ,${iml_schema}.dateformat_max2(P1.BATCH_DATE) -- 批次日期
    ,${iml_schema}.dateformat_max2(P1.BATCH_FINISH_TIME) -- 批次完成日期
    ,P1.COMPANY_ID -- 企业编号
    ,P1.COMPANY_NAME -- 企业名称
    ,nvl(trim(P1.PAY_SOURCE),'-') -- 代发来源代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL  ELSE '@'||P1.PAY_TYPE END -- 代发种类代码
    ,to_number(nvl(trim(P1.BATCH_MONTH),'0')) -- 代发年份
    ,to_number(nvl(trim(P1.BATCH_YEAR),'0')) -- 代发月份
    ,to_number(nvl(trim(P1.TOTAL_PEOPLE_COUNT),'0')) -- 总人数
    ,to_number(nvl(trim(P1.TOTAL_DTL_NUM),'0')) -- 总笔数
    ,to_number(nvl(trim(P1.TOTAL_AMT),'0')) -- 总金额
    ,to_number(nvl(trim(P1.AVERAGE_AMT),'0')) -- 平均金额
    ,to_number(nvl(trim(P1.SUCCESS_AMT),'0')) -- 成功总金额
    ,to_number(nvl(trim(P1.FAIL_AMT),'0')) -- 失败总金额
    ,to_number(nvl(trim(P1.SUCC_DTL_NUM),'0')) -- 成功笔数
    ,to_number(nvl(trim(P1.FAIL_DTL_NUM),'0')) -- 失败笔数
    ,to_number(nvl(trim(P1.UNKNOWN_DTL_NUM),'0')) -- 交易状态未知数量
    ,P1.MATTER_ID -- 审批序列号
    ,P1.SALARY_GROUP_ID -- 薪酬组编号
    ,P1.BRANCH_NO -- 机构编号
    ,decode(P1.SHOW_DTL_FLAG,'Y','1','N','0',' ','-',P1.SHOW_DTL_FLAG) -- 展示代发明细标志
    ,P1.LOCK_FLAG -- 锁定标志
    ,${iml_schema}.dateformat_min(P1.CREATE_TIMESTAMP) -- 批次创建日期
    ,${iml_schema}.dateformat_max2(P1.UPDATE_TIMESTAMP) -- 批次更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a1wsp_batch_info' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a1wsp_batch_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PAY_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A1WSP_BATCH_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'PAY_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_SALARY_PLAT_PAYOFF_BATCH'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PAYOFF_KIND_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_salary_plat_payoff_batch truncate partition p_mpcsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_salary_plat_payoff_batch exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.evt_salary_plat_payoff_batch_mpcsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_salary_plat_payoff_batch to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_salary_plat_payoff_batch_mpcsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_salary_plat_payoff_batch', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);