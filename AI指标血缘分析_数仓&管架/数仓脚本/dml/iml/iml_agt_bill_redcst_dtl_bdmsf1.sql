/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bill_redcst_dtl_bdmsf1
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
drop table ${iml_schema}.agt_bill_redcst_dtl_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_redcst_dtl_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_bill_redcst_dtl add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_bill_redcst_dtl modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bill_redcst_dtl_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_redcst_dtl partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_redcst_dtl_bdmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,redcst_dtl_id -- 再贴现明细编号
    ,batch_id -- 批次编号
    ,bill_id -- 票据编号
    ,fac_val_amt -- 票面金额
    ,bill_exp_dt -- 票据到期日期
    ,actl_exp_dt -- 实际到期日期
    ,surp_tenor -- 剩余期限
    ,int_paybl -- 应付利息
    ,stl_amt -- 结算金额
    ,exp_stl_amt -- 到期结算金额
    ,lmt_ocup_status_cd -- 额度占用状态代码
    ,proc_status_cd -- 处理状态代码
    ,entry_status_cd -- 记账状态代码
    ,valid_flg -- 有效标志
    ,discount_bill_flg -- 转贴现票据标志
    ,remote_bill_flg -- 异地票据标志
    ,policy_std_flg -- 政策标准标志
    ,refuse_flg -- 拒绝标志
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,bf_split_intrv_id -- 拆前区间编号
    ,bill_num -- 票据号码
    ,init_bill_amt -- 原始票据金额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_redcst_dtl
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_bill_redcst_dtl_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_bill_redcst_dtl partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_cpes_redsct_details-
insert into ${iml_schema}.agt_bill_redcst_dtl_bdmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,redcst_dtl_id -- 再贴现明细编号
    ,batch_id -- 批次编号
    ,bill_id -- 票据编号
    ,fac_val_amt -- 票面金额
    ,bill_exp_dt -- 票据到期日期
    ,actl_exp_dt -- 实际到期日期
    ,surp_tenor -- 剩余期限
    ,int_paybl -- 应付利息
    ,stl_amt -- 结算金额
    ,exp_stl_amt -- 到期结算金额
    ,lmt_ocup_status_cd -- 额度占用状态代码
    ,proc_status_cd -- 处理状态代码
    ,entry_status_cd -- 记账状态代码
    ,valid_flg -- 有效标志
    ,discount_bill_flg -- 转贴现票据标志
    ,remote_bill_flg -- 异地票据标志
    ,policy_std_flg -- 政策标准标志
    ,refuse_flg -- 拒绝标志
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,bf_split_intrv_id -- 拆前区间编号
    ,bill_num -- 票据号码
    ,init_bill_amt -- 原始票据金额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223104'||P1.ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ID -- 再贴现明细编号
    ,P1.CONTRACT_ID -- 批次编号
    ,P1.DRAFT_ID -- 票据编号
    ,P1.DRAFT_AMOUNT -- 票面金额
    ,${iml_schema}.DATEFORMAT_MAX2(P1.MATURITY_DATE) -- 票据到期日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.REAL_DUE_DATE) -- 实际到期日期
    ,P1.TENOR_DAYS -- 剩余期限
    ,P1.PAY_INTEREST -- 应付利息
    ,P1.SETTLE_AMT -- 结算金额
    ,P1.DUE_SETTLE_AMT -- 到期结算金额
    ,NVL(TRIM(P1.CREDIT_STATUS),'-') -- 额度占用状态代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DETAILS_STATUS END -- 处理状态代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.ACCOUNT_STATUS END -- 记账状态代码
    ,NVL(TRIM(P1.VALID_FLAG),'-') -- 有效标志
    ,NVL(TRIM(P1.IS_DISCOUNT),'-') -- 转贴现票据标志
    ,NVL(TRIM(P1.IS_ALLOPATRIC),'-') -- 异地票据标志
    ,NVL(TRIM(P1.IS_MEET_POLICY),'-') -- 政策标准标志
    ,NVL(TRIM(P1.IS_REFUSE),'-') -- 拒绝标志
    ,P1.CD_RANGE -- 票据子区间编号
    ,P1.STANDARD_AMT -- 票据区间标准金额
    ,P1.SPLIT_RANGE -- 拆前区间编号
    ,NVL(TRIM(P1.DRAFT_NUMBER),0) -- 票据号码
    ,P1.ORG_DRAFT_AMOUNT -- 原始票据金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cpes_redsct_details' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_redsct_details p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DETAILS_STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_CPES_REDSCT_DETAILS'
        AND R1.SRC_FIELD_EN_NAME= 'DETAILS_STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_BILL_REDCST_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PROC_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.ACCOUNT_STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_CPES_REDSCT_DETAILS'
        AND R2.SRC_FIELD_EN_NAME= 'ACCOUNT_STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_BILL_REDCST_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bill_redcst_dtl_bdmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_bill_redcst_dtl_bdmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,redcst_dtl_id -- 再贴现明细编号
    ,batch_id -- 批次编号
    ,bill_id -- 票据编号
    ,fac_val_amt -- 票面金额
    ,bill_exp_dt -- 票据到期日期
    ,actl_exp_dt -- 实际到期日期
    ,surp_tenor -- 剩余期限
    ,int_paybl -- 应付利息
    ,stl_amt -- 结算金额
    ,exp_stl_amt -- 到期结算金额
    ,lmt_ocup_status_cd -- 额度占用状态代码
    ,proc_status_cd -- 处理状态代码
    ,entry_status_cd -- 记账状态代码
    ,valid_flg -- 有效标志
    ,discount_bill_flg -- 转贴现票据标志
    ,remote_bill_flg -- 异地票据标志
    ,policy_std_flg -- 政策标准标志
    ,refuse_flg -- 拒绝标志
    ,bill_sub_intrv_id -- 票据子区间编号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,bf_split_intrv_id -- 拆前区间编号
    ,bill_num -- 票据号码
    ,init_bill_amt -- 原始票据金额
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.redcst_dtl_id, o.redcst_dtl_id) as redcst_dtl_id -- 再贴现明细编号
    ,nvl(n.batch_id, o.batch_id) as batch_id -- 批次编号
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.fac_val_amt, o.fac_val_amt) as fac_val_amt -- 票面金额
    ,nvl(n.bill_exp_dt, o.bill_exp_dt) as bill_exp_dt -- 票据到期日期
    ,nvl(n.actl_exp_dt, o.actl_exp_dt) as actl_exp_dt -- 实际到期日期
    ,nvl(n.surp_tenor, o.surp_tenor) as surp_tenor -- 剩余期限
    ,nvl(n.int_paybl, o.int_paybl) as int_paybl -- 应付利息
    ,nvl(n.stl_amt, o.stl_amt) as stl_amt -- 结算金额
    ,nvl(n.exp_stl_amt, o.exp_stl_amt) as exp_stl_amt -- 到期结算金额
    ,nvl(n.lmt_ocup_status_cd, o.lmt_ocup_status_cd) as lmt_ocup_status_cd -- 额度占用状态代码
    ,nvl(n.proc_status_cd, o.proc_status_cd) as proc_status_cd -- 处理状态代码
    ,nvl(n.entry_status_cd, o.entry_status_cd) as entry_status_cd -- 记账状态代码
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.discount_bill_flg, o.discount_bill_flg) as discount_bill_flg -- 转贴现票据标志
    ,nvl(n.remote_bill_flg, o.remote_bill_flg) as remote_bill_flg -- 异地票据标志
    ,nvl(n.policy_std_flg, o.policy_std_flg) as policy_std_flg -- 政策标准标志
    ,nvl(n.refuse_flg, o.refuse_flg) as refuse_flg -- 拒绝标志
    ,nvl(n.bill_sub_intrv_id, o.bill_sub_intrv_id) as bill_sub_intrv_id -- 票据子区间编号
    ,nvl(n.bill_intrv_std_amt, o.bill_intrv_std_amt) as bill_intrv_std_amt -- 票据区间标准金额
    ,nvl(n.bf_split_intrv_id, o.bf_split_intrv_id) as bf_split_intrv_id -- 拆前区间编号
    ,nvl(n.bill_num, o.bill_num) as bill_num -- 票据号码
    ,nvl(n.init_bill_amt, o.init_bill_amt) as init_bill_amt -- 原始票据金额
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.redcst_dtl_id <> n.redcst_dtl_id
                or o.batch_id <> n.batch_id
                or o.bill_id <> n.bill_id
                or o.fac_val_amt <> n.fac_val_amt
                or o.bill_exp_dt <> n.bill_exp_dt
                or o.actl_exp_dt <> n.actl_exp_dt
                or o.surp_tenor <> n.surp_tenor
                or o.int_paybl <> n.int_paybl
                or o.stl_amt <> n.stl_amt
                or o.exp_stl_amt <> n.exp_stl_amt
                or o.lmt_ocup_status_cd <> n.lmt_ocup_status_cd
                or o.proc_status_cd <> n.proc_status_cd
                or o.entry_status_cd <> n.entry_status_cd
                or o.valid_flg <> n.valid_flg
                or o.discount_bill_flg <> n.discount_bill_flg
                or o.remote_bill_flg <> n.remote_bill_flg
                or o.policy_std_flg <> n.policy_std_flg
                or o.refuse_flg <> n.refuse_flg
                or o.bill_sub_intrv_id <> n.bill_sub_intrv_id
                or o.bill_intrv_std_amt <> n.bill_intrv_std_amt
                or o.bf_split_intrv_id <> n.bf_split_intrv_id
                or o.bill_num <> n.bill_num
                or o.init_bill_amt <> n.init_bill_amt
            ) or (
                 case when (
                           n.agt_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_redcst_dtl_bdmsf1_tm n
    full join ${iml_schema}.agt_bill_redcst_dtl_bdmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_bill_redcst_dtl truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_bill_redcst_dtl exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_bill_redcst_dtl_bdmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_bill_redcst_dtl drop subpartition p_bdmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bill_redcst_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_bill_redcst_dtl_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_redcst_dtl_bdmsf1_ex purge;
drop table ${iml_schema}.agt_bill_redcst_dtl_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bill_redcst_dtl', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);