/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_trust_cap_clear_info_h_trusf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.evt_trust_cap_clear_info_h add partition p_trusf1 values ('trusf1')(
        subpartition p_trusf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_trusf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_trust_cap_clear_info_h partition for ('trusf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_tm purge;
drop table ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_op purge;
drop table ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,clear_flow_num -- 清算流水号
    ,tran_dt -- 交易日期
    ,clear_dt -- 清算日期
    ,actl_enter_acct_dt -- 实际入账日期
    ,bf_actl_enter_acct_dt -- 变动前实际入账日期
    ,cfm_flow_num -- 确认流水号
    ,rela_flow_num -- 关联流水号
    ,intior_cd -- 发起方代码
    ,tran_cd -- 交易代码
    ,bus_cd -- 业务代码
    ,cust_type_cd -- 客户类型代码
    ,finc_cust_id -- 理财客户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,bank_acct_type_cd -- 银行账户类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_teller_id -- 交易柜员编号
    ,termn_id -- 终端编号
    ,tran_org_id -- 交易机构编号
    ,tran_belong_org_id -- 交易所属机构编号
    ,ta_cd -- TA代码
    ,prod_cd -- 产品代码
    ,acct_dir_cd -- 账务方向代码
    ,clear_amt -- 清算金额
    ,curr_cd -- 币种代码
    ,ec_idf_cd -- 钞汇标识代码
    ,unfrz_amt -- 解冻金额
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,froz_amt -- 冻结金额
    ,bal_chk_cfm_cd -- 勾对确认代码
    ,cap_cate_cd -- 资金类别代码
    ,pric_prft_flg -- 本金收益标志
    ,cfm_lot -- 确认份额
    ,pric -- 本金
    ,prod_acct_num -- 产品账号
    ,prod_acct_type_cd -- 产品账户类型代码
    ,memo_comnt -- 摘要说明
    ,status_cd -- 状态代码
    ,init_clear_flow_num -- 原清算流水号
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,intfc_proc_flg_cd -- 接口处理标志代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_trust_cap_clear_info_h partition for ('trusf1')
where 0=1
;

create table ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_trust_cap_clear_info_h partition for ('trusf1') where 0=1;

create table ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_trust_cap_clear_info_h partition for ('trusf1') where 0=1;

-- 3.1 get new data into table
-- nfss_tcs_tbhissquare-
insert into ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,clear_flow_num -- 清算流水号
    ,tran_dt -- 交易日期
    ,clear_dt -- 清算日期
    ,actl_enter_acct_dt -- 实际入账日期
    ,bf_actl_enter_acct_dt -- 变动前实际入账日期
    ,cfm_flow_num -- 确认流水号
    ,rela_flow_num -- 关联流水号
    ,intior_cd -- 发起方代码
    ,tran_cd -- 交易代码
    ,bus_cd -- 业务代码
    ,cust_type_cd -- 客户类型代码
    ,finc_cust_id -- 理财客户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,bank_acct_type_cd -- 银行账户类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_teller_id -- 交易柜员编号
    ,termn_id -- 终端编号
    ,tran_org_id -- 交易机构编号
    ,tran_belong_org_id -- 交易所属机构编号
    ,ta_cd -- TA代码
    ,prod_cd -- 产品代码
    ,acct_dir_cd -- 账务方向代码
    ,clear_amt -- 清算金额
    ,curr_cd -- 币种代码
    ,ec_idf_cd -- 钞汇标识代码
    ,unfrz_amt -- 解冻金额
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,froz_amt -- 冻结金额
    ,bal_chk_cfm_cd -- 勾对确认代码
    ,cap_cate_cd -- 资金类别代码
    ,pric_prft_flg -- 本金收益标志
    ,cfm_lot -- 确认份额
    ,pric -- 本金
    ,prod_acct_num -- 产品账号
    ,prod_acct_type_cd -- 产品账户类型代码
    ,memo_comnt -- 摘要说明
    ,status_cd -- 状态代码
    ,init_clear_flow_num -- 原清算流水号
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,intfc_proc_flg_cd -- 接口处理标志代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104026'||P1.SQUARE_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SQUARE_NO -- 清算流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANS_DATE) -- 交易日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.CLEAR_DATE) -- 清算日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.SQUARE_DATE) -- 实际入账日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.OLD_SQUARE_DATE) -- 变动前实际入账日期
    ,P1.SERIAL_NO -- 确认流水号
    ,P1.ASSO_SERIAL -- 关联流水号
    ,NVL(TRIM(P1.FROM_FLAG),'-') -- 发起方代码
    ,NVL(TRIM(P1.TRANS_CODE),'-') -- 交易代码
    ,NVL(TRIM(P1.BUSIN_CODE),'-') -- 业务代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.IN_CLIENT_NO -- 理财客户编号
    ,P1.BANK_NO -- 银行编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.BANK_ACC -- 银行账户编号
    ,NVL(TRIM(P1.BANK_ACC_KIND),'-') -- 银行账户类型代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.CHANNEL END -- 交易渠道代码
    ,P1.OPER_NO -- 交易柜员编号
    ,P1.TERM_NO -- 终端编号
    ,P1.BRANCH_NO -- 交易机构编号
    ,P1.OPEN_BRANCH -- 交易所属机构编号
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,P1.PRD_CODE -- 产品代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.LIQU_DIR END -- 账务方向代码
    ,P1.AMT -- 清算金额
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CURR_TYPE END -- 币种代码
    ,NVL(TRIM(P1.CASH_FLAG),'-') -- 钞汇标识代码
    ,P1.UNFROZEN_AMT -- 解冻金额
    ,P1.HOST_TRANS_CODE -- 主机交易码
    ,${iml_schema}.DATEFORMAT_MIN(P1.HOST_DATE) -- 主机日期
    ,P1.HOST_SERIAL -- 主机流水号
    ,P1.FROZEN_AMT -- 冻结金额
    ,NVL(TRIM(P1.CHECK_STATUS),'-') -- 勾对确认代码
    ,NVL(TRIM(P1.AMT_FLAG),'-') -- 资金类别代码
    ,NVL(TRIM(P1.COST_INCOME_FLAG),'-') -- 本金收益标志
    ,P1.CFM_VOL -- 确认份额
    ,P1.COST -- 本金
    ,P1.PRD_ACCOUNT -- 产品账号
    ,NVL(TRIM(P1.PRD_ACCOUNT_KIND),'-') -- 产品账户类型代码
    ,P1.SUMMARY -- 摘要说明
    ,NVL(TRIM(P1.STATUS),'-') -- 状态代码
    ,P1.OLD_SQUARE_NO -- 原清算流水号
    ,P1.ERR_CODE -- 返回码
    ,P1.ERR_MSG -- 返回信息
    ,NVL(TRIM(P1.DEAL_STATUS),'-') -- 接口处理标志代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_tcs_tbhissquare' -- 源表名称
    ,'trusf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_tcs_tbhissquare p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NFSS'
        AND R1.SRC_TAB_EN_NAME= 'NFSS_TCS_TBHISSQUARE'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_TRUST_CAP_CLEAR_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.LIQU_DIR= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'NFSS'
        AND R2.SRC_TAB_EN_NAME= 'NFSS_TCS_TBHISSQUARE'
        AND R2.SRC_FIELD_EN_NAME= 'LIQU_DIR'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_TRUST_CAP_CLEAR_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ACCT_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CURR_TYPE= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'NFSS'
        AND R3.SRC_TAB_EN_NAME= 'NFSS_TCS_TBHISSQUARE'
        AND R3.SRC_FIELD_EN_NAME= 'CURR_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_TRUST_CAP_CLEAR_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
   left join ${iml_schema}.ref_pub_cd_map r4 on P1.CHANNEL= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'NFSS'
        AND R4.SRC_TAB_EN_NAME= 'NFSS_TCS_TBHISSQUARE'
        AND R4.SRC_FIELD_EN_NAME= 'CHANNEL'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_TRUST_CAP_CLEAR_INFO_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'TRAN_CHN_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- nfss_tcs_tbsquare-
insert into ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,clear_flow_num -- 清算流水号
    ,tran_dt -- 交易日期
    ,clear_dt -- 清算日期
    ,actl_enter_acct_dt -- 实际入账日期
    ,bf_actl_enter_acct_dt -- 变动前实际入账日期
    ,cfm_flow_num -- 确认流水号
    ,rela_flow_num -- 关联流水号
    ,intior_cd -- 发起方代码
    ,tran_cd -- 交易代码
    ,bus_cd -- 业务代码
    ,cust_type_cd -- 客户类型代码
    ,finc_cust_id -- 理财客户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,bank_acct_type_cd -- 银行账户类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_teller_id -- 交易柜员编号
    ,termn_id -- 终端编号
    ,tran_org_id -- 交易机构编号
    ,tran_belong_org_id -- 交易所属机构编号
    ,ta_cd -- TA代码
    ,prod_cd -- 产品代码
    ,acct_dir_cd -- 账务方向代码
    ,clear_amt -- 清算金额
    ,curr_cd -- 币种代码
    ,ec_idf_cd -- 钞汇标识代码
    ,unfrz_amt -- 解冻金额
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,froz_amt -- 冻结金额
    ,bal_chk_cfm_cd -- 勾对确认代码
    ,cap_cate_cd -- 资金类别代码
    ,pric_prft_flg -- 本金收益标志
    ,cfm_lot -- 确认份额
    ,pric -- 本金
    ,prod_acct_num -- 产品账号
    ,prod_acct_type_cd -- 产品账户类型代码
    ,memo_comnt -- 摘要说明
    ,status_cd -- 状态代码
    ,init_clear_flow_num -- 原清算流水号
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,intfc_proc_flg_cd -- 接口处理标志代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104026'||P1.SQUARE_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SQUARE_NO -- 清算流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANS_DATE) -- 交易日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.CLEAR_DATE) -- 清算日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.SQUARE_DATE) -- 实际入账日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.OLD_SQUARE_DATE) -- 变动前实际入账日期
    ,P1.SERIAL_NO -- 确认流水号
    ,P1.ASSO_SERIAL -- 关联流水号
    ,NVL(TRIM(P1.FROM_FLAG),'-') -- 发起方代码
    ,NVL(TRIM(P1.TRANS_CODE),'-') -- 交易代码
    ,NVL(TRIM(P1.BUSIN_CODE),'-') -- 业务代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.IN_CLIENT_NO -- 理财客户编号
    ,P1.BANK_NO -- 银行编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.BANK_ACC -- 银行账户编号
    ,NVL(TRIM(P1.BANK_ACC_KIND),'-') -- 银行账户类型代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.CHANNEL END -- 交易渠道代码
    ,P1.OPER_NO -- 交易柜员编号
    ,P1.TERM_NO -- 终端编号
    ,P1.BRANCH_NO -- 交易机构编号
    ,P1.OPEN_BRANCH -- 交易所属机构编号
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,P1.PRD_CODE -- 产品代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.LIQU_DIR END -- 账务方向代码
    ,P1.AMT -- 清算金额
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CURR_TYPE END -- 币种代码
    ,NVL(TRIM(P1.CASH_FLAG),'-') -- 钞汇标识代码
    ,P1.UNFROZEN_AMT -- 解冻金额
    ,P1.HOST_TRANS_CODE -- 主机交易码
    ,${iml_schema}.DATEFORMAT_MIN(P1.HOST_DATE) -- 主机日期
    ,P1.HOST_SERIAL -- 主机流水号
    ,P1.FROZEN_AMT -- 冻结金额
    ,NVL(TRIM(P1.CHECK_STATUS),'-') -- 勾对确认代码
    ,NVL(TRIM(P1.AMT_FLAG),'-') -- 资金类别代码
    ,NVL(TRIM(P1.COST_INCOME_FLAG),'-') -- 本金收益标志
    ,P1.CFM_VOL -- 确认份额
    ,P1.COST -- 本金
    ,P1.PRD_ACCOUNT -- 产品账号
    ,NVL(TRIM(P1.PRD_ACCOUNT_KIND),'-') -- 产品账户类型代码
    ,P1.SUMMARY -- 摘要说明
    ,NVL(TRIM(P1.STATUS),'-') -- 状态代码
    ,P1.OLD_SQUARE_NO -- 原清算流水号
    ,P1.ERR_CODE -- 返回码
    ,P1.ERR_MSG -- 返回信息
    ,NVL(TRIM(P1.DEAL_STATUS),'-') -- 接口处理标志代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_tcs_tbsquare' -- 源表名称
    ,'trusf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_tcs_tbsquare p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NFSS'
        AND R1.SRC_TAB_EN_NAME= 'NFSS_TCS_TBSQUARE'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_TRUST_CAP_CLEAR_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.LIQU_DIR= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'NFSS'
        AND R2.SRC_TAB_EN_NAME= 'NFSS_TCS_TBSQUARE'
        AND R2.SRC_FIELD_EN_NAME= 'LIQU_DIR'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_TRUST_CAP_CLEAR_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ACCT_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CURR_TYPE= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'NFSS'
        AND R3.SRC_TAB_EN_NAME= 'NFSS_TCS_TBSQUARE'
        AND R3.SRC_FIELD_EN_NAME= 'CURR_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_TRUST_CAP_CLEAR_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
   left join ${iml_schema}.ref_pub_cd_map r4 on P1.CHANNEL= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'NFSS'
        AND R4.SRC_TAB_EN_NAME= 'NFSS_TCS_TBSQUARE'
        AND R4.SRC_FIELD_EN_NAME= 'CHANNEL'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_TRUST_CAP_CLEAR_INFO_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'TRAN_CHN_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,clear_flow_num -- 清算流水号
    ,tran_dt -- 交易日期
    ,clear_dt -- 清算日期
    ,actl_enter_acct_dt -- 实际入账日期
    ,bf_actl_enter_acct_dt -- 变动前实际入账日期
    ,cfm_flow_num -- 确认流水号
    ,rela_flow_num -- 关联流水号
    ,intior_cd -- 发起方代码
    ,tran_cd -- 交易代码
    ,bus_cd -- 业务代码
    ,cust_type_cd -- 客户类型代码
    ,finc_cust_id -- 理财客户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,bank_acct_type_cd -- 银行账户类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_teller_id -- 交易柜员编号
    ,termn_id -- 终端编号
    ,tran_org_id -- 交易机构编号
    ,tran_belong_org_id -- 交易所属机构编号
    ,ta_cd -- TA代码
    ,prod_cd -- 产品代码
    ,acct_dir_cd -- 账务方向代码
    ,clear_amt -- 清算金额
    ,curr_cd -- 币种代码
    ,ec_idf_cd -- 钞汇标识代码
    ,unfrz_amt -- 解冻金额
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,froz_amt -- 冻结金额
    ,bal_chk_cfm_cd -- 勾对确认代码
    ,cap_cate_cd -- 资金类别代码
    ,pric_prft_flg -- 本金收益标志
    ,cfm_lot -- 确认份额
    ,pric -- 本金
    ,prod_acct_num -- 产品账号
    ,prod_acct_type_cd -- 产品账户类型代码
    ,memo_comnt -- 摘要说明
    ,status_cd -- 状态代码
    ,init_clear_flow_num -- 原清算流水号
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,intfc_proc_flg_cd -- 接口处理标志代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,clear_flow_num -- 清算流水号
    ,tran_dt -- 交易日期
    ,clear_dt -- 清算日期
    ,actl_enter_acct_dt -- 实际入账日期
    ,bf_actl_enter_acct_dt -- 变动前实际入账日期
    ,cfm_flow_num -- 确认流水号
    ,rela_flow_num -- 关联流水号
    ,intior_cd -- 发起方代码
    ,tran_cd -- 交易代码
    ,bus_cd -- 业务代码
    ,cust_type_cd -- 客户类型代码
    ,finc_cust_id -- 理财客户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,bank_acct_type_cd -- 银行账户类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_teller_id -- 交易柜员编号
    ,termn_id -- 终端编号
    ,tran_org_id -- 交易机构编号
    ,tran_belong_org_id -- 交易所属机构编号
    ,ta_cd -- TA代码
    ,prod_cd -- 产品代码
    ,acct_dir_cd -- 账务方向代码
    ,clear_amt -- 清算金额
    ,curr_cd -- 币种代码
    ,ec_idf_cd -- 钞汇标识代码
    ,unfrz_amt -- 解冻金额
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,froz_amt -- 冻结金额
    ,bal_chk_cfm_cd -- 勾对确认代码
    ,cap_cate_cd -- 资金类别代码
    ,pric_prft_flg -- 本金收益标志
    ,cfm_lot -- 确认份额
    ,pric -- 本金
    ,prod_acct_num -- 产品账号
    ,prod_acct_type_cd -- 产品账户类型代码
    ,memo_comnt -- 摘要说明
    ,status_cd -- 状态代码
    ,init_clear_flow_num -- 原清算流水号
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,intfc_proc_flg_cd -- 接口处理标志代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.clear_flow_num, o.clear_flow_num) as clear_flow_num -- 清算流水号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.clear_dt, o.clear_dt) as clear_dt -- 清算日期
    ,nvl(n.actl_enter_acct_dt, o.actl_enter_acct_dt) as actl_enter_acct_dt -- 实际入账日期
    ,nvl(n.bf_actl_enter_acct_dt, o.bf_actl_enter_acct_dt) as bf_actl_enter_acct_dt -- 变动前实际入账日期
    ,nvl(n.cfm_flow_num, o.cfm_flow_num) as cfm_flow_num -- 确认流水号
    ,nvl(n.rela_flow_num, o.rela_flow_num) as rela_flow_num -- 关联流水号
    ,nvl(n.intior_cd, o.intior_cd) as intior_cd -- 发起方代码
    ,nvl(n.tran_cd, o.tran_cd) as tran_cd -- 交易代码
    ,nvl(n.bus_cd, o.bus_cd) as bus_cd -- 业务代码
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.finc_cust_id, o.finc_cust_id) as finc_cust_id -- 理财客户编号
    ,nvl(n.bank_id, o.bank_id) as bank_id -- 银行编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.bank_acct_id, o.bank_acct_id) as bank_acct_id -- 银行账户编号
    ,nvl(n.bank_acct_type_cd, o.bank_acct_type_cd) as bank_acct_type_cd -- 银行账户类型代码
    ,nvl(n.tran_chn_cd, o.tran_chn_cd) as tran_chn_cd -- 交易渠道代码
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.termn_id, o.termn_id) as termn_id -- 终端编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.tran_belong_org_id, o.tran_belong_org_id) as tran_belong_org_id -- 交易所属机构编号
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.prod_cd, o.prod_cd) as prod_cd -- 产品代码
    ,nvl(n.acct_dir_cd, o.acct_dir_cd) as acct_dir_cd -- 账务方向代码
    ,nvl(n.clear_amt, o.clear_amt) as clear_amt -- 清算金额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.ec_idf_cd, o.ec_idf_cd) as ec_idf_cd -- 钞汇标识代码
    ,nvl(n.unfrz_amt, o.unfrz_amt) as unfrz_amt -- 解冻金额
    ,nvl(n.host_tran_code, o.host_tran_code) as host_tran_code -- 主机交易码
    ,nvl(n.host_dt, o.host_dt) as host_dt -- 主机日期
    ,nvl(n.host_flow_num, o.host_flow_num) as host_flow_num -- 主机流水号
    ,nvl(n.froz_amt, o.froz_amt) as froz_amt -- 冻结金额
    ,nvl(n.bal_chk_cfm_cd, o.bal_chk_cfm_cd) as bal_chk_cfm_cd -- 勾对确认代码
    ,nvl(n.cap_cate_cd, o.cap_cate_cd) as cap_cate_cd -- 资金类别代码
    ,nvl(n.pric_prft_flg, o.pric_prft_flg) as pric_prft_flg -- 本金收益标志
    ,nvl(n.cfm_lot, o.cfm_lot) as cfm_lot -- 确认份额
    ,nvl(n.pric, o.pric) as pric -- 本金
    ,nvl(n.prod_acct_num, o.prod_acct_num) as prod_acct_num -- 产品账号
    ,nvl(n.prod_acct_type_cd, o.prod_acct_type_cd) as prod_acct_type_cd -- 产品账户类型代码
    ,nvl(n.memo_comnt, o.memo_comnt) as memo_comnt -- 摘要说明
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.init_clear_flow_num, o.init_clear_flow_num) as init_clear_flow_num -- 原清算流水号
    ,nvl(n.return_code, o.return_code) as return_code -- 返回码
    ,nvl(n.return_info, o.return_info) as return_info -- 返回信息
    ,nvl(n.intfc_proc_flg_cd, o.intfc_proc_flg_cd) as intfc_proc_flg_cd -- 接口处理标志代码
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_tm n
    full join (select * from ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.clear_flow_num <> n.clear_flow_num
        or o.tran_dt <> n.tran_dt
        or o.clear_dt <> n.clear_dt
        or o.actl_enter_acct_dt <> n.actl_enter_acct_dt
        or o.bf_actl_enter_acct_dt <> n.bf_actl_enter_acct_dt
        or o.cfm_flow_num <> n.cfm_flow_num
        or o.rela_flow_num <> n.rela_flow_num
        or o.intior_cd <> n.intior_cd
        or o.tran_cd <> n.tran_cd
        or o.bus_cd <> n.bus_cd
        or o.cust_type_cd <> n.cust_type_cd
        or o.finc_cust_id <> n.finc_cust_id
        or o.bank_id <> n.bank_id
        or o.cust_id <> n.cust_id
        or o.bank_acct_id <> n.bank_acct_id
        or o.bank_acct_type_cd <> n.bank_acct_type_cd
        or o.tran_chn_cd <> n.tran_chn_cd
        or o.tran_teller_id <> n.tran_teller_id
        or o.termn_id <> n.termn_id
        or o.tran_org_id <> n.tran_org_id
        or o.tran_belong_org_id <> n.tran_belong_org_id
        or o.ta_cd <> n.ta_cd
        or o.prod_cd <> n.prod_cd
        or o.acct_dir_cd <> n.acct_dir_cd
        or o.clear_amt <> n.clear_amt
        or o.curr_cd <> n.curr_cd
        or o.ec_idf_cd <> n.ec_idf_cd
        or o.unfrz_amt <> n.unfrz_amt
        or o.host_tran_code <> n.host_tran_code
        or o.host_dt <> n.host_dt
        or o.host_flow_num <> n.host_flow_num
        or o.froz_amt <> n.froz_amt
        or o.bal_chk_cfm_cd <> n.bal_chk_cfm_cd
        or o.cap_cate_cd <> n.cap_cate_cd
        or o.pric_prft_flg <> n.pric_prft_flg
        or o.cfm_lot <> n.cfm_lot
        or o.pric <> n.pric
        or o.prod_acct_num <> n.prod_acct_num
        or o.prod_acct_type_cd <> n.prod_acct_type_cd
        or o.memo_comnt <> n.memo_comnt
        or o.status_cd <> n.status_cd
        or o.init_clear_flow_num <> n.init_clear_flow_num
        or o.return_code <> n.return_code
        or o.return_info <> n.return_info
        or o.intfc_proc_flg_cd <> n.intfc_proc_flg_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,clear_flow_num -- 清算流水号
    ,tran_dt -- 交易日期
    ,clear_dt -- 清算日期
    ,actl_enter_acct_dt -- 实际入账日期
    ,bf_actl_enter_acct_dt -- 变动前实际入账日期
    ,cfm_flow_num -- 确认流水号
    ,rela_flow_num -- 关联流水号
    ,intior_cd -- 发起方代码
    ,tran_cd -- 交易代码
    ,bus_cd -- 业务代码
    ,cust_type_cd -- 客户类型代码
    ,finc_cust_id -- 理财客户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,bank_acct_type_cd -- 银行账户类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_teller_id -- 交易柜员编号
    ,termn_id -- 终端编号
    ,tran_org_id -- 交易机构编号
    ,tran_belong_org_id -- 交易所属机构编号
    ,ta_cd -- TA代码
    ,prod_cd -- 产品代码
    ,acct_dir_cd -- 账务方向代码
    ,clear_amt -- 清算金额
    ,curr_cd -- 币种代码
    ,ec_idf_cd -- 钞汇标识代码
    ,unfrz_amt -- 解冻金额
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,froz_amt -- 冻结金额
    ,bal_chk_cfm_cd -- 勾对确认代码
    ,cap_cate_cd -- 资金类别代码
    ,pric_prft_flg -- 本金收益标志
    ,cfm_lot -- 确认份额
    ,pric -- 本金
    ,prod_acct_num -- 产品账号
    ,prod_acct_type_cd -- 产品账户类型代码
    ,memo_comnt -- 摘要说明
    ,status_cd -- 状态代码
    ,init_clear_flow_num -- 原清算流水号
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,intfc_proc_flg_cd -- 接口处理标志代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,clear_flow_num -- 清算流水号
    ,tran_dt -- 交易日期
    ,clear_dt -- 清算日期
    ,actl_enter_acct_dt -- 实际入账日期
    ,bf_actl_enter_acct_dt -- 变动前实际入账日期
    ,cfm_flow_num -- 确认流水号
    ,rela_flow_num -- 关联流水号
    ,intior_cd -- 发起方代码
    ,tran_cd -- 交易代码
    ,bus_cd -- 业务代码
    ,cust_type_cd -- 客户类型代码
    ,finc_cust_id -- 理财客户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,bank_acct_id -- 银行账户编号
    ,bank_acct_type_cd -- 银行账户类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_teller_id -- 交易柜员编号
    ,termn_id -- 终端编号
    ,tran_org_id -- 交易机构编号
    ,tran_belong_org_id -- 交易所属机构编号
    ,ta_cd -- TA代码
    ,prod_cd -- 产品代码
    ,acct_dir_cd -- 账务方向代码
    ,clear_amt -- 清算金额
    ,curr_cd -- 币种代码
    ,ec_idf_cd -- 钞汇标识代码
    ,unfrz_amt -- 解冻金额
    ,host_tran_code -- 主机交易码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,froz_amt -- 冻结金额
    ,bal_chk_cfm_cd -- 勾对确认代码
    ,cap_cate_cd -- 资金类别代码
    ,pric_prft_flg -- 本金收益标志
    ,cfm_lot -- 确认份额
    ,pric -- 本金
    ,prod_acct_num -- 产品账号
    ,prod_acct_type_cd -- 产品账户类型代码
    ,memo_comnt -- 摘要说明
    ,status_cd -- 状态代码
    ,init_clear_flow_num -- 原清算流水号
    ,return_code -- 返回码
    ,return_info -- 返回信息
    ,intfc_proc_flg_cd -- 接口处理标志代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.clear_flow_num -- 清算流水号
    ,o.tran_dt -- 交易日期
    ,o.clear_dt -- 清算日期
    ,o.actl_enter_acct_dt -- 实际入账日期
    ,o.bf_actl_enter_acct_dt -- 变动前实际入账日期
    ,o.cfm_flow_num -- 确认流水号
    ,o.rela_flow_num -- 关联流水号
    ,o.intior_cd -- 发起方代码
    ,o.tran_cd -- 交易代码
    ,o.bus_cd -- 业务代码
    ,o.cust_type_cd -- 客户类型代码
    ,o.finc_cust_id -- 理财客户编号
    ,o.bank_id -- 银行编号
    ,o.cust_id -- 客户编号
    ,o.bank_acct_id -- 银行账户编号
    ,o.bank_acct_type_cd -- 银行账户类型代码
    ,o.tran_chn_cd -- 交易渠道代码
    ,o.tran_teller_id -- 交易柜员编号
    ,o.termn_id -- 终端编号
    ,o.tran_org_id -- 交易机构编号
    ,o.tran_belong_org_id -- 交易所属机构编号
    ,o.ta_cd -- TA代码
    ,o.prod_cd -- 产品代码
    ,o.acct_dir_cd -- 账务方向代码
    ,o.clear_amt -- 清算金额
    ,o.curr_cd -- 币种代码
    ,o.ec_idf_cd -- 钞汇标识代码
    ,o.unfrz_amt -- 解冻金额
    ,o.host_tran_code -- 主机交易码
    ,o.host_dt -- 主机日期
    ,o.host_flow_num -- 主机流水号
    ,o.froz_amt -- 冻结金额
    ,o.bal_chk_cfm_cd -- 勾对确认代码
    ,o.cap_cate_cd -- 资金类别代码
    ,o.pric_prft_flg -- 本金收益标志
    ,o.cfm_lot -- 确认份额
    ,o.pric -- 本金
    ,o.prod_acct_num -- 产品账号
    ,o.prod_acct_type_cd -- 产品账户类型代码
    ,o.memo_comnt -- 摘要说明
    ,o.status_cd -- 状态代码
    ,o.init_clear_flow_num -- 原清算流水号
    ,o.return_code -- 返回码
    ,o.return_info -- 返回信息
    ,o.intfc_proc_flg_cd -- 接口处理标志代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_bk o
    left join ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_trust_cap_clear_info_h;
alter table ${iml_schema}.evt_trust_cap_clear_info_h truncate partition for ('trusf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.evt_trust_cap_clear_info_h exchange subpartition p_trusf1_19000101 with table ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_cl;
alter table ${iml_schema}.evt_trust_cap_clear_info_h exchange subpartition p_trusf1_20991231 with table ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_trust_cap_clear_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_tm purge;
drop table ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_op purge;
drop table ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_trust_cap_clear_info_h_trusf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_trust_cap_clear_info_h', partname => 'p_trusf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
