/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_finc_cap_clear_ifmsi1
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
drop table ${iml_schema}.evt_finc_cap_clear_ifmsi1_tm purge;
alter table ${iml_schema}.evt_finc_cap_clear add partition p_ifmsi1 values ('ifmsi1')(
        subpartition p_ifmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_finc_cap_clear modify partition p_ifmsi1
    add subpartition p_ifmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_finc_cap_clear_ifmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,clear_flow_num -- 清算流水号
    ,clear_seq_num -- 清算顺序号
    ,tran_dt -- 交易日期
    ,clear_dt -- 清算日期
    ,actl_enter_acct_dt -- 实际入帐日期
    ,chg_bf_clear_dt -- 变动前清算日期
    ,flow_num -- 流水号
    ,rela_flow_num -- 关联流水号
    ,intior_cd -- 发起方代码
    ,tran_cd -- 交易代码
    ,bus_cd -- 业务代码
    ,cust_type_cd -- 客户类型代码
    ,intnal_cust_id -- 内部客户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,bank_acct_num -- 银行账号
    ,bank_acct_type_cd -- 银行帐户类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_teller_id -- 交易柜员编号
    ,termn_id -- 终端编号
    ,tran_org_id -- 交易机构编号
    ,tran_belong_org_id -- 交易所属机构编号
    ,ta_cd -- TA代码
    ,prod_id -- 产品编号
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
    ,acct_amt_src_type_cd -- 上帐金额来源类型代码
    ,cap_cate_cd -- 资金类别代码
    ,pric_prft_cd -- 本金收益代码
    ,cfm_lot -- 确认份额
    ,pric_amt -- 本金金额
    ,cfm_prft_amt -- 确认收益金额
    ,lot_accu_accum -- 份额累积积数
    ,prod_acct_num -- 产品账号
    ,prod_acct_type_cd -- 产品账户类型代码
    ,memo_comnt -- 摘要说明
    ,cap_clear_status_cd -- 资金清算状态代码
    ,init_clear_flow_num -- 原清算流水号
    ,return_code -- 返回码
    ,err_info_desc -- 错误信息描述
    ,intfc_proc_flg -- 接口处理标志
    ,remark_info_1 -- 备注信息1
    ,remark_info_2 -- 备注信息2
    ,remark_info_3 -- 备注信息3
    ,remark_info_4 -- 备注信息4
    ,remark_info_5 -- 备注信息5
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_finc_cap_clear
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ifms_tbhissquare-1
insert into ${iml_schema}.evt_finc_cap_clear_ifmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,clear_flow_num -- 清算流水号
    ,clear_seq_num -- 清算顺序号
    ,tran_dt -- 交易日期
    ,clear_dt -- 清算日期
    ,actl_enter_acct_dt -- 实际入帐日期
    ,chg_bf_clear_dt -- 变动前清算日期
    ,flow_num -- 流水号
    ,rela_flow_num -- 关联流水号
    ,intior_cd -- 发起方代码
    ,tran_cd -- 交易代码
    ,bus_cd -- 业务代码
    ,cust_type_cd -- 客户类型代码
    ,intnal_cust_id -- 内部客户编号
    ,bank_id -- 银行编号
    ,cust_id -- 客户编号
    ,bank_acct_num -- 银行账号
    ,bank_acct_type_cd -- 银行帐户类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_teller_id -- 交易柜员编号
    ,termn_id -- 终端编号
    ,tran_org_id -- 交易机构编号
    ,tran_belong_org_id -- 交易所属机构编号
    ,ta_cd -- TA代码
    ,prod_id -- 产品编号
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
    ,acct_amt_src_type_cd -- 上帐金额来源类型代码
    ,cap_cate_cd -- 资金类别代码
    ,pric_prft_cd -- 本金收益代码
    ,cfm_lot -- 确认份额
    ,pric_amt -- 本金金额
    ,cfm_prft_amt -- 确认收益金额
    ,lot_accu_accum -- 份额累积积数
    ,prod_acct_num -- 产品账号
    ,prod_acct_type_cd -- 产品账户类型代码
    ,memo_comnt -- 摘要说明
    ,cap_clear_status_cd -- 资金清算状态代码
    ,init_clear_flow_num -- 原清算流水号
    ,return_code -- 返回码
    ,err_info_desc -- 错误信息描述
    ,intfc_proc_flg -- 接口处理标志
    ,remark_info_1 -- 备注信息1
    ,remark_info_2 -- 备注信息2
    ,remark_info_3 -- 备注信息3
    ,remark_info_4 -- 备注信息4
    ,remark_info_5 -- 备注信息5
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104019'||nvl(to_char(p1.CLEAR_DATE),'00010101')||p1.SQUARE_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SQUARE_NO -- 清算流水号
    ,P1.SEQ_NO -- 清算顺序号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANS_DATE) -- 交易日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.CLEAR_DATE) -- 清算日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.SQUARE_DATE) -- 实际入帐日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.OLD_SQUARE_DATE) -- 变动前清算日期
    ,P1.SERIAL_NO -- 流水号
    ,P1.ASSO_SERIAL -- 关联流水号
    ,nvl(trim(P1.FROM_FLAG),'-') -- 发起方代码
    ,P1.TRANS_CODE -- 交易代码
    ,P1.BUSIN_CODE -- 业务代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||p1.CLIENT_TYPE END -- 客户类型代码
    ,P1.IN_CLIENT_NO -- 内部客户编号
    ,P1.BANK_NO -- 银行编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.BANK_ACC -- 银行账号
    ,P1.BANK_ACC_KIND -- 银行帐户类型代码
    ,P1.CHANNEL -- 交易渠道代码
    ,P1.OPER_NO -- 交易柜员编号
    ,P1.TERM_NO -- 终端编号
    ,P1.BRANCH_NO -- 交易机构编号
    ,P1.OPEN_BRANCH -- 交易所属机构编号
    ,P1.TA_CODE -- TA代码
    ,P1.PRD_CODE -- 产品编号
    ,P1.LIQU_DIR -- 账务方向代码
    ,P1.AMT -- 清算金额
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||p1.CURR_TYPE END -- 币种代码
    ,P1.CASH_FLAG -- 钞汇标识代码
    ,P1.UNFROZEN_AMT -- 解冻金额
    ,P1.HOST_TRANS_CODE -- 主机交易码
    ,${iml_schema}.DATEFORMAT_MIN(P1.HOST_DATE) -- 主机日期
    ,P1.HOST_SERIAL -- 主机流水号
    ,P1.FROZEN_AMT -- 冻结金额
    ,nvl(trim(P1.CHECK_STATUS),'-') -- 勾对确认代码
    ,P1.DISTRIB_FLAG -- 上帐金额来源类型代码
    ,P1.AMT_FLAG -- 资金类别代码
    ,nvl(trim(P1.COST_INCOME_FLAG),'-') -- 本金收益代码
    ,P1.CFM_VOL -- 确认份额
    ,P1.COST -- 本金金额
    ,P1.CFM_INCOME -- 确认收益金额
    ,P1.VOL_CUMULATE -- 份额累积积数
    ,P1.PRD_ACCOUNT -- 产品账号
    ,P1.PRD_ACCOUNT_KIND -- 产品账户类型代码
    ,P1.SUMMARY -- 摘要说明
    ,P1.STATUS -- 资金清算状态代码
    ,P1.OLD_SQUARE_NO -- 原清算流水号
    ,P1.ERR_CODE -- 返回码
    ,P1.ERR_MSG -- 错误信息描述
    ,P1.DEAL_STATUS -- 接口处理标志
    ,P1.RESERVE1 -- 备注信息1
    ,P1.RESERVE2 -- 备注信息2
    ,P1.RESERVE3 -- 备注信息3
    ,P1.RESERVE4 -- 备注信息4
    ,P1.RESERVE5 -- 备注信息5
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbhissquare' -- 源表名称
    ,'ifmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbhissquare p1
    left join ${iml_schema}.ref_pub_cd_map r1 on p1.CLIENT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBHISSQUARE'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_FINC_CAP_CLEAR'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on p1.CURR_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFMS'
        AND R2.SRC_TAB_EN_NAME= 'IFMS_TBHISSQUARE'
        AND R2.SRC_FIELD_EN_NAME= 'CURR_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_FINC_CAP_CLEAR'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and p1.start_dt=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_finc_cap_clear truncate subpartition p_ifmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_finc_cap_clear exchange subpartition p_ifmsi1_${batch_date} with table ${iml_schema}.evt_finc_cap_clear_ifmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_finc_cap_clear to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_finc_cap_clear_ifmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_finc_cap_clear', partname => 'p_ifmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);