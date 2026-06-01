/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_udwtr_distr_tran_clear_dtl_ctmsf1
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
drop table ${iml_schema}.evt_udwtr_distr_tran_clear_dtl_ctmsf1_tm purge;
alter table ${iml_schema}.evt_udwtr_distr_tran_clear_dtl add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_udwtr_distr_tran_clear_dtl modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_udwtr_distr_tran_clear_dtl_ctmsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pay_id -- 支付编号
    ,dept_id -- 部门编号
    ,tran_cfm_id -- 交易确认编号
    ,bus_id -- 业务编号
    ,tard_way_cd -- 交易方式代码
    ,ser_num -- 序列号
    ,acct_b_id -- 账簿编号
    ,asset_type_name -- 资产类型名称
    ,tran_cate_name -- 交易类别名称
    ,tran_type_descb -- 交易类型描述
    ,tran_descb -- 交易描述
    ,dlvy_dt -- 交割日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,acpt_pay_type_cd -- 收付类型代码
    ,dlvy_curr_cd -- 交割币种代码
    ,contn_int_dlvy_tot_amt -- 含利息交割总金额
    ,dlvy_bond_id -- 交割债券编号
    ,pric_dlvy_amt -- 本金交割金额
    ,actl_stl_dt -- 实际结算日期
    ,actl_dlvy_curr_cd -- 实际交割币种代码
    ,actl_contn_int_dlvy_tot_amt -- 实际含利息交割总金额
    ,actl_dlvy_bond_id -- 实际交割债券编号
    ,actl_pric_dlvy_amt -- 实际本金交割金额
    ,status_cd -- 状态代码
    ,dlvy_way_cd -- 交割方式代码
    ,actl_dlvy_way_cd -- 实际交割方式代码
    ,init_tran_id -- 原交易编号
    ,bs_type_cd -- 买卖类型代码
    ,ghb_tran_id -- 本方交易编号
    ,ghb_bs_type_cd -- 本方买卖类型代码
    ,ghb_cap_acct_en_name -- 本方资金账户英文名称
    ,ghb_cap_acct_cn_name -- 本方资金账户中文名称
    ,ghb_cap_open_bank_name -- 本方资金开户行名称
    ,ghb_cap_acct_id -- 本方资金账户编号
    ,ghb_cap_open_ibank_no -- 本方资金开户联行号
    ,ghb_bond_acct_name -- 本方债券账户名称
    ,ghb_bond_acct_bank_name -- 本方债券账户银行名称
    ,ghb_bond_acct_id -- 本方债券账户编号
    ,cntpty_tran_id -- 交易对手交易编号
    ,cntpty_bs_type_cd -- 对手方买卖类型代码
    ,cntpty_cap_acct_en_name -- 对手方资金账户英文名称
    ,cntpty_cap_acct_cn_name -- 对手方资金账户中文名称
    ,cntpty_cap_open_bank_name -- 对手方资金开户行名称
    ,cntpty_cap_acct_id -- 对手方资金账户编号
    ,cntpty_cap_open_ibank_no -- 对手方资金开户联行号
    ,cntpty_bond_acct_name -- 对手方债券账户名称
    ,cntpty_bond_acct_bank_name -- 对手方债券账户银行名称
    ,cntpty_bond_acct_id -- 对手方债券账户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_udwtr_distr_tran_clear_dtl
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ctms_tbs_vs_payment_trsi_underwrite-
insert into ${iml_schema}.evt_udwtr_distr_tran_clear_dtl_ctmsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pay_id -- 支付编号
    ,dept_id -- 部门编号
    ,tran_cfm_id -- 交易确认编号
    ,bus_id -- 业务编号
    ,tard_way_cd -- 交易方式代码
    ,ser_num -- 序列号
    ,acct_b_id -- 账簿编号
    ,asset_type_name -- 资产类型名称
    ,tran_cate_name -- 交易类别名称
    ,tran_type_descb -- 交易类型描述
    ,tran_descb -- 交易描述
    ,dlvy_dt -- 交割日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,acpt_pay_type_cd -- 收付类型代码
    ,dlvy_curr_cd -- 交割币种代码
    ,contn_int_dlvy_tot_amt -- 含利息交割总金额
    ,dlvy_bond_id -- 交割债券编号
    ,pric_dlvy_amt -- 本金交割金额
    ,actl_stl_dt -- 实际结算日期
    ,actl_dlvy_curr_cd -- 实际交割币种代码
    ,actl_contn_int_dlvy_tot_amt -- 实际含利息交割总金额
    ,actl_dlvy_bond_id -- 实际交割债券编号
    ,actl_pric_dlvy_amt -- 实际本金交割金额
    ,status_cd -- 状态代码
    ,dlvy_way_cd -- 交割方式代码
    ,actl_dlvy_way_cd -- 实际交割方式代码
    ,init_tran_id -- 原交易编号
    ,bs_type_cd -- 买卖类型代码
    ,ghb_tran_id -- 本方交易编号
    ,ghb_bs_type_cd -- 本方买卖类型代码
    ,ghb_cap_acct_en_name -- 本方资金账户英文名称
    ,ghb_cap_acct_cn_name -- 本方资金账户中文名称
    ,ghb_cap_open_bank_name -- 本方资金开户行名称
    ,ghb_cap_acct_id -- 本方资金账户编号
    ,ghb_cap_open_ibank_no -- 本方资金开户联行号
    ,ghb_bond_acct_name -- 本方债券账户名称
    ,ghb_bond_acct_bank_name -- 本方债券账户银行名称
    ,ghb_bond_acct_id -- 本方债券账户编号
    ,cntpty_tran_id -- 交易对手交易编号
    ,cntpty_bs_type_cd -- 对手方买卖类型代码
    ,cntpty_cap_acct_en_name -- 对手方资金账户英文名称
    ,cntpty_cap_acct_cn_name -- 对手方资金账户中文名称
    ,cntpty_cap_open_bank_name -- 对手方资金开户行名称
    ,cntpty_cap_acct_id -- 对手方资金账户编号
    ,cntpty_cap_open_ibank_no -- 对手方资金开户联行号
    ,cntpty_bond_acct_name -- 对手方债券账户名称
    ,cntpty_bond_acct_bank_name -- 对手方债券账户银行名称
    ,cntpty_bond_acct_id -- 对手方债券账户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201012'||P1.PAYMENT_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.PAYMENT_ID -- 支付编号
    ,P1.ASPCLIENT_ID -- 部门编号
    ,P1.DEALSCONFIRM_ID -- 交易确认编号
    ,P1.DEAL_ID -- 业务编号
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.EVENTTYPE END -- 交易方式代码
    ,P1.SEQUENCE -- 序列号
    ,P1.KEEPFOLDER_ID -- 账簿编号
    ,P1.ASSETTYPE -- 资产类型名称
    ,P1.BUZTYPE -- 交易类别名称
    ,P1.DEALTYPE -- 交易类型描述
    ,P1.ACTIONTYPE -- 交易描述
    ,${iml_schema}.DATEFORMAT_MAX2(P1.SETTLEDATE) -- 交割日期
    ,P1.CPTY_ID -- 交易对手编号
    ,P1.CPTY_NAME -- 交易对手名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PAYRECEIVETYPE END -- 收付类型代码
    ,P1.SETTLECURRENCY -- 交割币种代码
    ,P1.SETTLEAMOUNT -- 含利息交割总金额
    ,P1.SECURITYCODE -- 交割债券编号
    ,P1.QUANTITY -- 本金交割金额
    ,${iml_schema}.DATEFORMAT_MAX2(P1.ACT_SETTLEDATE) -- 实际结算日期
    ,P1.ACT_SETTLECURRENCY -- 实际交割币种代码
    ,P1.ACT_SETTLEAMOUNT -- 实际含利息交割总金额
    ,P1.ACT_SECURITYCODE -- 实际交割债券编号
    ,P1.ACT_QUANTITY -- 实际本金交割金额
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.PSTATUS END -- 状态代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.SETTLEMETHOD END -- 交割方式代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.ACT_SETTLEMETHOD END -- 实际交割方式代码
    ,P1.SERIAL_NUMBER -- 原交易编号
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.BS END -- 买卖类型代码
    ,P1.SELF_SERIAL_NUMBER -- 本方交易编号
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.SELF_BS END -- 本方买卖类型代码
    ,P1.SELF_CASH_ACC_ENAME -- 本方资金账户英文名称
    ,P1.SELF_CASH_ACC_CNAME -- 本方资金账户中文名称
    ,P1.SELF_CASH_ACC_BANK -- 本方资金开户行名称
    ,P1.SELF_CASH_ACC_NO -- 本方资金账户编号
    ,P1.SELF_CASH_ACC_BANK_EX -- 本方资金开户联行号
    ,P1.SELF_BOND_ACC_NAME -- 本方债券账户名称
    ,P1.SELF_BOND_ACC_BANK -- 本方债券账户银行名称
    ,P1.SELF_BOND_ACC_NO -- 本方债券账户编号
    ,P1.CPTY_SERIAL_NUMBER -- 交易对手交易编号
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.CPTY_BS END -- 对手方买卖类型代码
    ,P1.CPTY_CASH_ACC_ENAME -- 对手方资金账户英文名称
    ,P1.CPTY_CASH_ACC_CNAME -- 对手方资金账户中文名称
    ,P1.CPTY_CASH_ACC_BANK -- 对手方资金开户行名称
    ,P1.CPTY_CASH_ACC_NO -- 对手方资金账户编号
    ,P1.CPTY_CASH_ACC_BANK_EX -- 对手方资金开户联行号
    ,P1.CPTY_BOND_ACC_NAME -- 对手方债券账户名称
    ,P1.CPTY_BOND_ACC_BANK -- 对手方债券账户银行名称
    ,P1.CPTY_BOND_ACC_NO -- 对手方债券账户编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vs_payment_trsi_underwrite' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_vs_payment_trsi_underwrite p1
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.EVENTTYPE = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'CTMS'
        AND R8.SRC_TAB_EN_NAME= 'CTMS_VS_PAYMENT_TRSI_BONDSDEALS'
        AND R8.SRC_FIELD_EN_NAME= 'EVENTTYPE'
        AND R8.TARGET_TAB_EN_NAME= 'EVT_SEC_CLEAR_INFO'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'TARD_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PAYRECEIVETYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'CTMS'
        AND R1.SRC_TAB_EN_NAME= 'CTMS_VS_PAYMENT_TRSI_BONDSDEALS'
        AND R1.SRC_FIELD_EN_NAME= 'PAYRECEIVETYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_SEC_CLEAR_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ACPT_PAY_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PSTATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'CTMS'
        AND R2.SRC_TAB_EN_NAME= 'CTMS_VS_PAYMENT_TRSI_BONDSDEALS'
        AND R2.SRC_FIELD_EN_NAME= 'PSTATUS'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_SEC_CLEAR_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.SETTLEMETHOD = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'CTMS'
        AND R3.SRC_TAB_EN_NAME= 'CTMS_VS_PAYMENT_TRSI_BONDSDEALS'
        AND R3.SRC_FIELD_EN_NAME= 'SETTLEMETHOD'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_SEC_CLEAR_INFO'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'DLVY_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.ACT_SETTLEMETHOD = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'CTMS'
        AND R4.SRC_TAB_EN_NAME= 'CTMS_VS_PAYMENT_TRSI_BONDSDEALS'
        AND R4.SRC_FIELD_EN_NAME= 'ACT_SETTLEMETHOD'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_SEC_CLEAR_INFO'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'ACTL_DLVY_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.BS = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'CTMS'
        AND R5.SRC_TAB_EN_NAME= 'CTMS_VS_PAYMENT_TRSI_BONDSDEALS'
        AND R5.SRC_FIELD_EN_NAME= 'BS'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_SEC_CLEAR_INFO'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'BS_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.SELF_BS = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'CTMS'
        AND R6.SRC_TAB_EN_NAME= 'CTMS_VS_PAYMENT_TRSI_BONDSDEALS'
        AND R6.SRC_FIELD_EN_NAME= 'SELF_BS'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_SEC_CLEAR_INFO'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'GHB_BS_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.CPTY_BS = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'CTMS'
        AND R7.SRC_TAB_EN_NAME= 'CTMS_VS_PAYMENT_TRSI_BONDSDEALS'
        AND R7.SRC_FIELD_EN_NAME= 'CPTY_BS'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_SEC_CLEAR_INFO'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'CNTPTY_BS_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_udwtr_distr_tran_clear_dtl truncate partition p_ctmsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_udwtr_distr_tran_clear_dtl exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.evt_udwtr_distr_tran_clear_dtl_ctmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_udwtr_distr_tran_clear_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_udwtr_distr_tran_clear_dtl_ctmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_udwtr_distr_tran_clear_dtl', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);