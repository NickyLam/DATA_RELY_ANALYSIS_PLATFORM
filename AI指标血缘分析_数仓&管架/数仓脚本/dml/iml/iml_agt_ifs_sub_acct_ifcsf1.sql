/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline 
Usage:      python $ETL_HOME/script/main.py 20220930 iml_agt_ifs_sub_acct_ifcsf1   
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

drop table ${iml_schema}.agt_ifs_sub_acct_ifcsf1_tm purge;
drop table ${iml_schema}.agt_ifs_sub_acct_ifcsf1_ex purge;
drop table ${iml_schema}.agt_ifs_sub_acct_ifcsf1_bk purge;
-- 手工脚本
drop table ${iml_schema}.agt_ifs_sub_acct_ifcsf1_bk_his purge;
drop table ${iml_schema}.ifcs_bk_dep_prod_acct_info_iml purge;
drop table ${iml_schema}.ifcs_dep_prod_acct_info_history_iml purge;


-- 2.2 add partition for target table
alter table ${iml_schema}.agt_ifs_sub_acct add partition p_ifcsf1 values ('ifcsf1')(
        subpartition p_ifcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_ifs_sub_acct modify partition p_ifcsf1
    add subpartition p_ifcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

alter table ${iml_schema}.agt_ifs_sub_acct_h add partition p_ifcsf1 values ('ifcsf1')(
        subpartition p_ifcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_ifs_sub_acct_h modify partition p_ifcsf1
    add subpartition p_ifcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ifs_sub_acct_ifcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ifs_sub_acct partition for ('ifcsf1')
where create_dt <= to_date('${batch_date}','yyyymmdd')
and (not (pric_amt = 0   --余额为0
      and dep_acct_status_cd = '0'   --账户状态为销户
      and clos_acct_dt <= trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') - 1)) --销户日期小于等于上年末
;

-- 手工脚本
create table ${iml_schema}.agt_ifs_sub_acct_ifcsf1_bk_his nologging   
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ifs_sub_acct partition for ('ifcsf1')
where create_dt <= to_date('${batch_date}','yyyymmdd')
 and pric_amt = 0   --余额为0
 and dep_acct_status_cd = '0'   --账户状态为销户
 and clos_acct_dt <= trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') - 1 --销户日期小于等于上年末
;

-- 2.3.2 创建临时表存放ifcs_bk_dep_prod_acct_info当天的数据
create table ${iml_schema}.ifcs_bk_dep_prod_acct_info_iml nologging   
compress ${option_switch} for query high
as
select *
  from ${iol_schema}.ifcs_bk_dep_prod_acct_info P1
 where  1 = 1 
   and (not (P1.bal = 0   --余额为0
            and P1.dep_acct_status_cd = '0'   --账户状态为销户
         --   and P1.close_acct_dt <= to_char(trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') - 1, 'yyyymmdd')))   --销户日期小于等于上年末
            and ${iml_schema}.dateformat_max(P1.close_acct_dt) <= trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') - 1))   --销户日期小于等于上年末
   and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;

-- 2.3.3 创建临时表存放ifcs_dep_prod_acct_info_history当天的数据
create table ${iml_schema}.ifcs_dep_prod_acct_info_history_iml nologging   
compress ${option_switch} for query high
as
select *
  from ${iol_schema}.ifcs_dep_prod_acct_info_history P1
 where  1 = 1 
   and (not (P1.bal = 0   --余额为0
            and P1.dep_acct_status_cd = '0'   --账户状态为销户
         --   and P1.close_acct_dt <= to_char(trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') - 1, 'yyyymmdd')))   --销户日期小于等于上年末
            and ${iml_schema}.dateformat_max(P1.close_acct_dt) <= trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') - 1))   --销户日期小于等于上年末
   and P1.etl_dt = to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ifs_sub_acct_ifcsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_prod_sub_acct_id -- 存款产品分户编号
    ,dep_acct_id -- 存款账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,ext_prod_id -- 外部产品编号
    ,dep_acct_status_cd -- 存款账户状态代码
    ,acpt_pay_flg_cd -- 收付标志代码
    ,froz_status_cd -- 冻结状态代码
    ,stop_pay_status_cd -- 止付状态代码
    ,int_accr_flg -- 计息标志
    ,open_acct_dt -- 开户日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,pric_amt -- 本金金额
    ,froz_amt -- 冻结金额
    ,stop_pay_amt -- 止付金额
    ,acct_instit_id -- 账务机构编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_chn_cd -- 开户渠道代码
    ,open_acct_flow_num -- 开户流水号
    ,last_activ_acct_dt -- 上次动户日期
    ,exec_int_rat -- 执行利率
    ,base_rat -- 基准利率
    ,flo_val -- 浮动值
    ,clos_acct_dt -- 销户日期
    ,clos_acct_flow_num -- 销户流水号
    ,pa_ext_cnt -- 部提次数
    ,dep_term_cd -- 存期代码
    ,dep_tenor -- 存款期限
    ,adu_bk_acct_dt -- 对接行的账务日期
    ,open_acct_tm -- 开户时间
    ,clos_acct_tm -- 销户时间
    ,fee_dt -- 费用日期
    ,webank_card_no -- 微众银行卡号
    ,sav_type_cd -- 储种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ifs_sub_acct
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_ifs_sub_acct_ifcsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_ifs_sub_acct partition for ('ifcsf1') where 0=1;

-- 2.1 insert data to tm table
-- ifcs_bk_dep_prod_acct_info-
insert /*+ append */ into ${iml_schema}.agt_ifs_sub_acct_ifcsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_prod_sub_acct_id -- 存款产品分户编号
    ,dep_acct_id -- 存款账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,ext_prod_id -- 外部产品编号
    ,dep_acct_status_cd -- 存款账户状态代码
    ,acpt_pay_flg_cd -- 收付标志代码
    ,froz_status_cd -- 冻结状态代码
    ,stop_pay_status_cd -- 止付状态代码
    ,int_accr_flg -- 计息标志
    ,open_acct_dt -- 开户日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,pric_amt -- 本金金额
    ,froz_amt -- 冻结金额
    ,stop_pay_amt -- 止付金额
    ,acct_instit_id -- 账务机构编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_chn_cd -- 开户渠道代码
    ,open_acct_flow_num -- 开户流水号
    ,last_activ_acct_dt -- 上次动户日期
    ,exec_int_rat -- 执行利率
    ,base_rat -- 基准利率
    ,flo_val -- 浮动值
    ,clos_acct_dt -- 销户日期
    ,clos_acct_flow_num -- 销户流水号
    ,pa_ext_cnt -- 部提次数
    ,dep_term_cd -- 存期代码
    ,dep_tenor -- 存款期限
    ,adu_bk_acct_dt -- 对接行的账务日期
    ,open_acct_tm -- 开户时间
    ,clos_acct_tm -- 销户时间
    ,fee_dt -- 费用日期
    ,webank_card_no -- 微众银行卡号
    ,sav_type_cd -- 储种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120015'||P1.DEP_ACCT_ID||P1.DEP_PROD_SUB_ACCT_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.DEP_PROD_SUB_ACCT_ID -- 存款产品分户编号
    ,P1.DEP_ACCT_ID -- 存款账户编号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.CUST_ID -- 客户编号
    ,P1.PROD_ID -- 产品编号
    ,P1.EXT_PROD_ID -- 外部产品编号
    ,decode(P1.DEP_ACCT_STATUS_CD,'0','C','1','A','-') -- 存款账户状态代码
    ,P1.ACPT_PAY_STATUS -- 收付标志代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.FROZ_STATUS END -- 冻结状态代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.STPAY_STATUS_CD END -- 止付状态代码
    ,P1.INT_ACCR_FLG -- 计息标志
    ,${iml_schema}.dateformat_min(P1.OPEN_ACCT_DT) -- 开户日期
    ,${iml_schema}.dateformat_min(P1.VALUE_DT) -- 起息日期
    ,${iml_schema}.dateformat_max(P1.EXP_DT) -- 到期日期
    ,P1.BAL -- 本金金额
    ,P1.FROZ_AMT -- 冻结金额
    ,P1.STPAYBL -- 止付金额
    ,P1.ACCT_INSTIT_ID -- 账务机构编号
    ,P1.OPEN_ACCT_ORG_ID -- 开户机构编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.OPEN_ACCT_CHN_ID END -- 开户渠道代码
    ,P1.OPEN_ACCT_FLOW_NUM -- 开户流水号
    ,${iml_schema}.dateformat_min(P1.LAST_ACTIV_ACCT_DT) -- 上次动户日期
    ,P1.EXEC_INT_RAT -- 执行利率
    ,P1.BASE_RAT -- 基准利率
    ,P1.SPREAD_VAL -- 浮动值
    ,${iml_schema}.dateformat_max(P1.CLOSE_ACCT_DT) -- 销户日期
    ,P1.CLOSE_ACCT_FLOW_NUM -- 销户流水号
    ,P1.PA_EXT_CNT -- 部提次数
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DEP_TERM_CD END -- 存期代码
    ,P1.DEP_TERM_CD -- 存款期限
    ,${iml_schema}.dateformat_min(P1.EXT_ACCT_DT) -- 对接行的账务日期
    ,to_timestamp(trim(P1.OPEN_ACCT_TI),'yyyymmddhh24missff6') -- 开户时间
    ,to_timestamp(trim(P1.CLOSE_ACCT_TI),'yyyymmdd hh24:mi:ss.ff6') -- 销户时间
    ,${iml_schema}.dateformat_min(P1.FEE_DT) -- 费用日期
    ,P1.BIND_ACCT_ID -- 微众银行卡号
    ,P1.DPS_TYPE_CD -- 储种代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifcs_bk_dep_prod_acct_info' -- 源表名称
    ,'ifcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ifcs_bk_dep_prod_acct_info_iml p1
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.FROZ_STATUS = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IFCS'
        AND R3.SRC_TAB_EN_NAME= 'IFCS_DEP_PROD_ACCT_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'FROZ_STATUS'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_IFS_SUB_ACCT'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'FROZ_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.STPAY_STATUS_CD = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'IFCS'
        AND R4.SRC_TAB_EN_NAME= 'IFCS_DEP_PROD_ACCT_INFO'
        AND R4.SRC_FIELD_EN_NAME= 'STPAY_STATUS_CD'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_IFS_SUB_ACCT'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'STOP_PAY_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.OPEN_ACCT_CHN_ID = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFCS'
        AND R1.SRC_TAB_EN_NAME= 'IFCS_DEP_PROD_ACCT_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'OPEN_ACCT_CHN_ID'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_IFS_SUB_ACCT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'OPEN_ACCT_CHN_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DEP_TERM_CD = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFCS'
        AND R2.SRC_TAB_EN_NAME= 'IFCS_DEP_PROD_ACCT_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'DEP_TERM_CD'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_IFS_SUB_ACCT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'DEP_TERM_CD'
where  1 = 1 
    and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;

-- ifcs_dep_prod_acct_info_history-
insert /*+ append */ into ${iml_schema}.agt_ifs_sub_acct_ifcsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_prod_sub_acct_id -- 存款产品分户编号
    ,dep_acct_id -- 存款账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,ext_prod_id -- 外部产品编号
    ,dep_acct_status_cd -- 存款账户状态代码
    ,acpt_pay_flg_cd -- 收付标志代码
    ,froz_status_cd -- 冻结状态代码
    ,stop_pay_status_cd -- 止付状态代码
    ,int_accr_flg -- 计息标志
    ,open_acct_dt -- 开户日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,pric_amt -- 本金金额
    ,froz_amt -- 冻结金额
    ,stop_pay_amt -- 止付金额
    ,acct_instit_id -- 账务机构编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_chn_cd -- 开户渠道代码
    ,open_acct_flow_num -- 开户流水号
    ,last_activ_acct_dt -- 上次动户日期
    ,exec_int_rat -- 执行利率
    ,base_rat -- 基准利率
    ,flo_val -- 浮动值
    ,clos_acct_dt -- 销户日期
    ,clos_acct_flow_num -- 销户流水号
    ,pa_ext_cnt -- 部提次数
    ,dep_term_cd -- 存期代码
    ,dep_tenor -- 存款期限
    ,adu_bk_acct_dt -- 对接行的账务日期
    ,open_acct_tm -- 开户时间
    ,clos_acct_tm -- 销户时间
    ,fee_dt -- 费用日期
    ,webank_card_no -- 微众银行卡号
    ,sav_type_cd -- 储种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120015'||P1.DEP_ACCT_ID||P1.DEP_PROD_SUB_ACCT_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.DEP_PROD_SUB_ACCT_ID -- 存款产品分户编号
    ,P1.DEP_ACCT_ID -- 存款账户编号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.CUST_ID -- 客户编号
    ,P1.PROD_ID -- 产品编号
    ,P1.EXT_PROD_ID -- 外部产品编号
    ,decode(P1.DEP_ACCT_STATUS_CD,'0','C','1','A','-') -- 存款账户状态代码
    ,P1.ACPT_PAY_STATUS -- 收付标志代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.FROZ_STATUS END -- 冻结状态代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.STPAY_STATUS_CD END -- 止付状态代码
    ,P1.INT_ACCR_FLG -- 计息标志
    ,${iml_schema}.dateformat_min(P1.OPEN_ACCT_DT) -- 开户日期
    ,${iml_schema}.dateformat_min(P1.VALUE_DT) -- 起息日期
    ,${iml_schema}.dateformat_max(P1.EXP_DT) -- 到期日期
    ,P1.BAL -- 本金金额
    ,P1.FROZ_AMT -- 冻结金额
    ,P1.STPAYBL -- 止付金额
    ,P1.ACCT_INSTIT_ID -- 账务机构编号
    ,P1.OPEN_ACCT_ORG_ID -- 开户机构编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.OPEN_ACCT_CHN_ID END   -- 开户渠道代码
    ,P1.OPEN_ACCT_FLOW_NUM -- 开户流水号
    ,${iml_schema}.dateformat_min(P1.LAST_ACTIV_ACCT_DT) -- 上次动户日期
    ,P1.EXEC_INT_RAT -- 执行利率
    ,P1.BASE_RAT -- 基准利率
    ,P1.SPREAD_VAL -- 浮动值
    ,${iml_schema}.dateformat_max(P1.CLOSE_ACCT_DT) -- 销户日期
    ,P1.CLOSE_ACCT_FLOW_NUM -- 销户流水号
    ,P1.PA_EXT_CNT -- 部提次数
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DEP_TERM_CD END -- 存期代码
    ,P1.DEP_TERM_CD -- 存款期限
    ,${iml_schema}.dateformat_min(P1.EXT_ACCT_DT) -- 对接行的账务日期
    ,to_timestamp(trim(P1.OPEN_ACCT_TI),'yyyymmddhh24missff6') -- 开户时间
    ,to_timestamp(trim(P1.CLOSE_ACCT_TI),'yyyymmdd hh24:mi:ss.ff6') -- 销户时间
    ,${iml_schema}.dateformat_min(P1.FEE_DT) -- 费用日期
    ,P1.BIND_ACCT_ID -- 微众银行卡号
    ,P1.DPS_TYPE_CD -- 储种代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifcs_dep_prod_acct_info_history' -- 源表名称
    ,'ifcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ifcs_dep_prod_acct_info_history_iml p1
    left join ${iml_schema}.ifcs_bk_dep_prod_acct_info_iml p2 
      on p1.DEP_PROD_SUB_ACCT_ID=p2.DEP_PROD_SUB_ACCT_ID 
     and p1.DEP_ACCT_ID=p2.DEP_ACCT_ID 
     and p2.etl_dt = to_date('${batch_date}','yyyymmdd')
     left join ${iml_schema}.ref_pub_cd_map r1 on P1.OPEN_ACCT_CHN_ID = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFCS'
        AND R1.SRC_TAB_EN_NAME= 'IFCS_DEP_PROD_ACCT_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'OPEN_ACCT_CHN_ID'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_IFS_SUB_ACCT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'OPEN_ACCT_CHN_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.FROZ_STATUS = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IFCS'
        AND R3.SRC_TAB_EN_NAME= 'IFCS_DEP_PROD_ACCT_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'FROZ_STATUS'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_IFS_SUB_ACCT'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'FROZ_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.STPAY_STATUS_CD = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'IFCS'
        AND R4.SRC_TAB_EN_NAME= 'IFCS_DEP_PROD_ACCT_INFO'
        AND R4.SRC_FIELD_EN_NAME= 'STPAY_STATUS_CD'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_IFS_SUB_ACCT'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'STOP_PAY_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DEP_TERM_CD = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFCS'
        AND R2.SRC_TAB_EN_NAME= 'IFCS_DEP_PROD_ACCT_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'DEP_TERM_CD'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_IFS_SUB_ACCT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'DEP_TERM_CD'
where  1 = 1 
     and p2.DEP_ACCT_ID is null
     and p1.open_acct_dt<='${batch_date}'
;
commit;

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_ifs_sub_acct_ifcsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_prod_sub_acct_id -- 存款产品分户编号
    ,dep_acct_id -- 存款账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,ext_prod_id -- 外部产品编号
    ,dep_acct_status_cd -- 存款账户状态代码
    ,acpt_pay_flg_cd -- 收付标志代码
    ,froz_status_cd -- 冻结状态代码
    ,stop_pay_status_cd -- 止付状态代码
    ,int_accr_flg -- 计息标志
    ,open_acct_dt -- 开户日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,pric_amt -- 本金金额
    ,froz_amt -- 冻结金额
    ,stop_pay_amt -- 止付金额
    ,acct_instit_id -- 账务机构编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_chn_cd -- 开户渠道代码
    ,open_acct_flow_num -- 开户流水号
    ,last_activ_acct_dt -- 上次动户日期
    ,exec_int_rat -- 执行利率
    ,base_rat -- 基准利率
    ,flo_val -- 浮动值
    ,clos_acct_dt -- 销户日期
    ,clos_acct_flow_num -- 销户流水号
    ,pa_ext_cnt -- 部提次数
    ,dep_term_cd -- 存期代码
    ,dep_tenor -- 存款期限
    ,adu_bk_acct_dt -- 对接行的账务日期
    ,open_acct_tm -- 开户时间
    ,clos_acct_tm -- 销户时间
    ,fee_dt -- 费用日期
    ,webank_card_no -- 微众银行卡号
    ,sav_type_cd -- 储种代码
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
    ,nvl(n.dep_prod_sub_acct_id, o.dep_prod_sub_acct_id) as dep_prod_sub_acct_id -- 存款产品分户编号
    ,nvl(n.dep_acct_id, o.dep_acct_id) as dep_acct_id -- 存款账户编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.ext_prod_id, o.ext_prod_id) as ext_prod_id -- 外部产品编号
    ,nvl(n.dep_acct_status_cd, o.dep_acct_status_cd) as dep_acct_status_cd -- 存款账户状态代码
    ,nvl(n.acpt_pay_flg_cd, o.acpt_pay_flg_cd) as acpt_pay_flg_cd -- 收付标志代码
    ,nvl(n.froz_status_cd, o.froz_status_cd) as froz_status_cd -- 冻结状态代码
    ,nvl(n.stop_pay_status_cd, o.stop_pay_status_cd) as stop_pay_status_cd -- 止付状态代码
    ,nvl(n.int_accr_flg, o.int_accr_flg) as int_accr_flg -- 计息标志
    ,nvl(n.open_acct_dt, o.open_acct_dt) as open_acct_dt -- 开户日期
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.pric_amt, o.pric_amt) as pric_amt -- 本金金额
    ,nvl(n.froz_amt, o.froz_amt) as froz_amt -- 冻结金额
    ,nvl(n.stop_pay_amt, o.stop_pay_amt) as stop_pay_amt -- 止付金额
    ,nvl(n.acct_instit_id, o.acct_instit_id) as acct_instit_id -- 账务机构编号
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.open_acct_chn_cd, o.open_acct_chn_cd) as open_acct_chn_cd -- 开户渠道代码
    ,nvl(n.open_acct_flow_num, o.open_acct_flow_num) as open_acct_flow_num -- 开户流水号
    ,nvl(n.last_activ_acct_dt, o.last_activ_acct_dt) as last_activ_acct_dt -- 上次动户日期
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.flo_val, o.flo_val) as flo_val -- 浮动值
    ,nvl(n.clos_acct_dt, o.clos_acct_dt) as clos_acct_dt -- 销户日期
    ,nvl(n.clos_acct_flow_num, o.clos_acct_flow_num) as clos_acct_flow_num -- 销户流水号
    ,nvl(n.pa_ext_cnt, o.pa_ext_cnt) as pa_ext_cnt -- 部提次数
    ,nvl(n.dep_term_cd, o.dep_term_cd) as dep_term_cd -- 存期代码
    ,nvl(n.dep_tenor, o.dep_tenor) as dep_tenor -- 存款期限
    ,nvl(n.adu_bk_acct_dt, o.adu_bk_acct_dt) as adu_bk_acct_dt -- 对接行的账务日期
    ,nvl(n.open_acct_tm, o.open_acct_tm) as open_acct_tm -- 开户时间
    ,nvl(n.clos_acct_tm, o.clos_acct_tm) as clos_acct_tm -- 销户时间
    ,nvl(n.fee_dt, o.fee_dt) as fee_dt -- 费用日期
    ,nvl(n.webank_card_no, o.webank_card_no) as webank_card_no -- 微众银行卡号
    ,nvl(n.sav_type_cd, o.sav_type_cd) as sav_type_cd -- 储种代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.dep_prod_sub_acct_id <> n.dep_prod_sub_acct_id
                or o.dep_acct_id <> n.dep_acct_id
                or o.acct_name <> n.acct_name
                or o.cust_id <> n.cust_id
                or o.prod_id <> n.prod_id
                or o.ext_prod_id <> n.ext_prod_id
                or o.dep_acct_status_cd <> n.dep_acct_status_cd
                or o.acpt_pay_flg_cd <> n.acpt_pay_flg_cd
                or o.froz_status_cd <> n.froz_status_cd
                or o.stop_pay_status_cd <> n.stop_pay_status_cd
                or o.int_accr_flg <> n.int_accr_flg
                or o.open_acct_dt <> n.open_acct_dt
                or o.value_dt <> n.value_dt
                or o.exp_dt <> n.exp_dt
                or o.pric_amt <> n.pric_amt
                or o.froz_amt <> n.froz_amt
                or o.stop_pay_amt <> n.stop_pay_amt
                or o.acct_instit_id <> n.acct_instit_id
                or o.open_acct_org_id <> n.open_acct_org_id
                or o.open_acct_chn_cd <> n.open_acct_chn_cd
                or o.open_acct_flow_num <> n.open_acct_flow_num
                or o.last_activ_acct_dt <> n.last_activ_acct_dt
                or o.exec_int_rat <> n.exec_int_rat
                or o.base_rat <> n.base_rat
                or o.flo_val <> n.flo_val
                or o.clos_acct_dt <> n.clos_acct_dt
                or o.clos_acct_flow_num <> n.clos_acct_flow_num
                or o.pa_ext_cnt <> n.pa_ext_cnt
                or o.dep_term_cd <> n.dep_term_cd
                or o.dep_tenor <> n.dep_tenor
                or o.adu_bk_acct_dt <> n.adu_bk_acct_dt
                or o.open_acct_tm <> n.open_acct_tm
                or o.clos_acct_tm <> n.clos_acct_tm
                or o.fee_dt <> n.fee_dt
                or o.webank_card_no <> n.webank_card_no
                or o.sav_type_cd <> n.sav_type_cd
            )or (
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
    ,case when (o.sav_type_cd='S02' 
                 and o.dep_acct_status_cd = '0')
           then 'I'
          when (
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ifs_sub_acct_ifcsf1_tm n
    full join ${iml_schema}.agt_ifs_sub_acct_ifcsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_ifs_sub_acct truncate partition for ('ifcsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_ifs_sub_acct exchange subpartition p_ifcsf1_${batch_date} with table ${iml_schema}.agt_ifs_sub_acct_ifcsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_ifs_sub_acct drop subpartition p_ifcsf1_${last_date} update global indexes;

-- 3.4 backup the data closed in last year  (手工脚本)
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_ifs_sub_acct_h(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_prod_sub_acct_id -- 存款产品分户编号
    ,dep_acct_id -- 存款账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,ext_prod_id -- 外部产品编号
    ,dep_acct_status_cd -- 存款账户状态代码
    ,acpt_pay_flg_cd -- 收付标志代码
    ,froz_status_cd -- 冻结状态代码
    ,stop_pay_status_cd -- 止付状态代码
    ,int_accr_flg -- 计息标志
    ,open_acct_dt -- 开户日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,pric_amt -- 本金金额
    ,froz_amt -- 冻结金额
    ,stop_pay_amt -- 止付金额
    ,acct_instit_id -- 账务机构编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_chn_cd -- 开户渠道代码
    ,open_acct_flow_num -- 开户流水号
    ,last_activ_acct_dt -- 上次动户日期
    ,exec_int_rat -- 执行利率
    ,base_rat -- 基准利率
    ,flo_val -- 浮动值
    ,clos_acct_dt -- 销户日期
    ,clos_acct_flow_num -- 销户流水号
    ,pa_ext_cnt -- 部提次数
    ,dep_term_cd -- 存期代码
    ,dep_tenor -- 存款期限
    ,adu_bk_acct_dt -- 对接行的账务日期
    ,open_acct_tm -- 开户时间
    ,clos_acct_tm -- 销户时间
    ,fee_dt -- 费用日期
    ,webank_card_no -- 微众银行卡号
    ,sav_type_cd -- 储种代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
   agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_prod_sub_acct_id -- 存款产品分户编号
    ,dep_acct_id -- 存款账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,ext_prod_id -- 外部产品编号
    ,dep_acct_status_cd -- 存款账户状态代码
    ,acpt_pay_flg_cd -- 收付标志代码
    ,froz_status_cd -- 冻结状态代码
    ,stop_pay_status_cd -- 止付状态代码
    ,int_accr_flg -- 计息标志
    ,open_acct_dt -- 开户日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,pric_amt -- 本金金额
    ,froz_amt -- 冻结金额
    ,stop_pay_amt -- 止付金额
    ,acct_instit_id -- 账务机构编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_chn_cd -- 开户渠道代码
    ,open_acct_flow_num -- 开户流水号
    ,last_activ_acct_dt -- 上次动户日期
    ,exec_int_rat -- 执行利率
    ,base_rat -- 基准利率
    ,flo_val -- 浮动值
    ,clos_acct_dt -- 销户日期
    ,clos_acct_flow_num -- 销户流水号
    ,pa_ext_cnt -- 部提次数
    ,dep_term_cd -- 存期代码
    ,dep_tenor -- 存款期限
    ,adu_bk_acct_dt -- 对接行的账务日期
    ,open_acct_tm -- 开户时间
    ,clos_acct_tm -- 销户时间
    ,fee_dt -- 费用日期
    ,webank_card_no -- 微众银行卡号
    ,sav_type_cd-- 储种代码
    ,p1.create_dt -- 创建日期
    ,p1.update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,p1.id_mark -- 增删标志
    ,p1.src_table_name -- 源表名称
    ,p1.job_cd -- 任务编码
    ,p1.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ifs_sub_acct_ifcsf1_bk_his p1
where 1=1
;
   
commit;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ifs_sub_acct to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_ifs_sub_acct_ifcsf1_tm purge;
drop table ${iml_schema}.agt_ifs_sub_acct_ifcsf1_ex purge;
drop table ${iml_schema}.agt_ifs_sub_acct_ifcsf1_bk purge;
---- 手工脚本
drop table ${iml_schema}.agt_ifs_sub_acct_ifcsf1_bk_his purge;
drop table ${iml_schema}.ifcs_bk_dep_prod_acct_info_iml purge;
drop table ${iml_schema}.ifcs_dep_prod_acct_info_history_iml purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ifs_sub_acct', partname => 'p_ifcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ifs_sub_acct_h', partname => 'p_ifcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);