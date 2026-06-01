/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_digit_curr_bus_tran_flow_mpcsf1
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
drop table ${iml_schema}.evt_digit_curr_bus_tran_flow_mpcsf1_tm purge;
alter table ${iml_schema}.evt_digit_curr_bus_tran_flow add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_digit_curr_bus_tran_flow modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_digit_curr_bus_tran_flow_mpcsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sys_code -- 系统码
    ,midgrod_flow_num -- 中台流水号
    ,midgrod_dt -- 中台日期
    ,midgrod_tran_code -- 中台交易码
    ,msg_id -- 报文编号
    ,msg_idf_id -- 报文标识编号
    ,send_bank_no -- 发送行号
    ,origi_bank_code -- 发起行LEI码
    ,recv_bank_num -- 接收行号
    ,recv_bank_code -- 接收行LEI码
    ,entr_dt -- 委托日期
    ,bank_int_bus_seq_num -- 行内业务序号
    ,bank_int_err_cd -- 行内错误码
    ,bank_int_err_info -- 行内错误信息
    ,nostro_flg -- 往来账标志
    ,fin_tran_code -- 金融交易码
    ,fin_tran_dt -- 金融交易日期
    ,fin_tran_flow_num -- 金融交易流水号
    ,fin_midgrod_flow_num -- 金融中台流水号
    ,fin_midgrod_dt -- 金融中台日期
    ,fin_check_entry_status_cd -- 金融对账状态代码
    ,acct_type_cd -- 账户类型代码
    ,curr_cd -- 币种代码
    ,payer_open_bank_num -- 付款人开户行号
    ,payer_open_bank_name -- 付款人开户行名称
    ,payer_acct_type_cd -- 付款人账户类型代码
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,pay_acct_resdnt_type_cd -- 付款账户居民类型代码
    ,pay_acct_permt_rg_cd -- 付款账户常驻地区代码
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_acct_type_cd -- 收款人账户类型代码
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recvbl_acct_resdnt_type_cd -- 收款账户居民类型代码
    ,recvbl_acct_permt_rg_cd -- 收款账户常驻地区代码
    ,open_acct_org_id -- 开户机构编号
    ,pkg_level_cd -- 钱包等级代码
    ,pkg_type_cd -- 钱包类型代码
    ,pkg_name -- 钱包名称
    ,pkg_rgst_mobile_no_site_cd -- 钱包注册手机号所在地区代码
    ,bus_type_id -- 业务类型编号
    ,bus_kind_id -- 业务种类编号
    ,bus_flow_num -- 业务流水号
    ,bus_process_cd -- 业务处理码
    ,bus_proc_dt -- 业务处理日期
    ,bus_status_cd -- 业务状态代码
    ,bus_rtn_rcpt_status_cd -- 业务回执状态代码
    ,bus_refuse_code -- 业务拒绝码
    ,bus_refuse_info -- 业务拒绝信息
    ,bus_check_entry_status_cd -- 业务对账状态代码
    ,tran_batch_no -- 交易批次号
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_excep_proc_flg -- 交易异常处理标志
    ,tran_rest_descb -- 交易结果描述
    ,tran_usage_cd -- 交易用途代码
    ,tran_cap_src_cd -- 交易资金来源代码
    ,tran_effect_dt -- 交易生效日期
    ,tran_invalid_dt -- 交易失效日期
    ,tran_chn_cd -- 交易渠道代码
    ,tran_teller_id -- 交易柜员编号
    ,debit_crdt_flg -- 借贷标志
    ,comm_fee_flg -- 手续费标志
    ,comm_fee_amt -- 手续费金额
    ,proc_cnt -- 处理次数
    ,err_rs_code -- 差错原因码
    ,err_rs_comnt -- 差错原因说明
    ,rtn_rcpt_tran_dt -- 回执交易日期
    ,rtn_rcpt_msg_idf_id -- 回执报文标识编号
    ,rtn_rcpt_msg_id -- 回执报文编号
    ,letter_idf_flow_num -- 通信级标识流水号
    ,letter_ref_flow_num -- 通信级参考流水号
    ,init_entr_dt -- 原委托日期
    ,init_msg_idf_id -- 原报文标识编号
    ,init_init_prtcpt_org_id -- 原发起参与机构编号
    ,init_msg_type_id -- 原报文类型编号
    ,ova_flow_num -- 全局流水号
    ,unify_pay_chn_flow_num -- 统一支付渠道流水号
    ,agt_id -- 挂接协议编号
    ,intfc_return_code -- ESC接口返回码
    ,intfc_return_info -- ESC接口返回信息
    ,intfc_tran_flow_num -- ESC接口交易流水号
    ,adj_entry_amt -- 调账金额
    ,postsc -- 附言
    ,remark -- 备注
    ,mgmt_org_id -- 管理机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_digit_curr_bus_tran_flow
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- mpcs_a1stdcpstrx-1
insert into ${iml_schema}.evt_digit_curr_bus_tran_flow_mpcsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sys_code -- 系统码
    ,midgrod_flow_num -- 中台流水号
    ,midgrod_dt -- 中台日期
    ,midgrod_tran_code -- 中台交易码
    ,msg_id -- 报文编号
    ,msg_idf_id -- 报文标识编号
    ,send_bank_no -- 发送行号
    ,origi_bank_code -- 发起行LEI码
    ,recv_bank_num -- 接收行号
    ,recv_bank_code -- 接收行LEI码
    ,entr_dt -- 委托日期
    ,bank_int_bus_seq_num -- 行内业务序号
    ,bank_int_err_cd -- 行内错误码
    ,bank_int_err_info -- 行内错误信息
    ,nostro_flg -- 往来账标志
    ,fin_tran_code -- 金融交易码
    ,fin_tran_dt -- 金融交易日期
    ,fin_tran_flow_num -- 金融交易流水号
    ,fin_midgrod_flow_num -- 金融中台流水号
    ,fin_midgrod_dt -- 金融中台日期
    ,fin_check_entry_status_cd -- 金融对账状态代码
    ,acct_type_cd -- 账户类型代码
    ,curr_cd -- 币种代码
    ,payer_open_bank_num -- 付款人开户行号
    ,payer_open_bank_name -- 付款人开户行名称
    ,payer_acct_type_cd -- 付款人账户类型代码
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,pay_acct_resdnt_type_cd -- 付款账户居民类型代码
    ,pay_acct_permt_rg_cd -- 付款账户常驻地区代码
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_acct_type_cd -- 收款人账户类型代码
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recvbl_acct_resdnt_type_cd -- 收款账户居民类型代码
    ,recvbl_acct_permt_rg_cd -- 收款账户常驻地区代码
    ,open_acct_org_id -- 开户机构编号
    ,pkg_level_cd -- 钱包等级代码
    ,pkg_type_cd -- 钱包类型代码
    ,pkg_name -- 钱包名称
    ,pkg_rgst_mobile_no_site_cd -- 钱包注册手机号所在地区代码
    ,bus_type_id -- 业务类型编号
    ,bus_kind_id -- 业务种类编号
    ,bus_flow_num -- 业务流水号
    ,bus_process_cd -- 业务处理码
    ,bus_proc_dt -- 业务处理日期
    ,bus_status_cd -- 业务状态代码
    ,bus_rtn_rcpt_status_cd -- 业务回执状态代码
    ,bus_refuse_code -- 业务拒绝码
    ,bus_refuse_info -- 业务拒绝信息
    ,bus_check_entry_status_cd -- 业务对账状态代码
    ,tran_batch_no -- 交易批次号
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_excep_proc_flg -- 交易异常处理标志
    ,tran_rest_descb -- 交易结果描述
    ,tran_usage_cd -- 交易用途代码
    ,tran_cap_src_cd -- 交易资金来源代码
    ,tran_effect_dt -- 交易生效日期
    ,tran_invalid_dt -- 交易失效日期
    ,tran_chn_cd -- 交易渠道代码
    ,tran_teller_id -- 交易柜员编号
    ,debit_crdt_flg -- 借贷标志
    ,comm_fee_flg -- 手续费标志
    ,comm_fee_amt -- 手续费金额
    ,proc_cnt -- 处理次数
    ,err_rs_code -- 差错原因码
    ,err_rs_comnt -- 差错原因说明
    ,rtn_rcpt_tran_dt -- 回执交易日期
    ,rtn_rcpt_msg_idf_id -- 回执报文标识编号
    ,rtn_rcpt_msg_id -- 回执报文编号
    ,letter_idf_flow_num -- 通信级标识流水号
    ,letter_ref_flow_num -- 通信级参考流水号
    ,init_entr_dt -- 原委托日期
    ,init_msg_idf_id -- 原报文标识编号
    ,init_init_prtcpt_org_id -- 原发起参与机构编号
    ,init_msg_type_id -- 原报文类型编号
    ,ova_flow_num -- 全局流水号
    ,unify_pay_chn_flow_num -- 统一支付渠道流水号
    ,agt_id -- 挂接协议编号
    ,intfc_return_code -- ESC接口返回码
    ,intfc_return_info -- ESC接口返回信息
    ,intfc_tran_flow_num -- ESC接口交易流水号
    ,adj_entry_amt -- 调账金额
    ,postsc -- 附言
    ,remark -- 备注
    ,mgmt_org_id -- 管理机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401042'||P1.SYSCD||P1.MAINSEQ||P1.TRANSDT -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SYSCD -- 系统码
    ,P1.MAINSEQ -- 中台流水号
    ,${iml_schema}.dateformat_max2(P1.TRANSDT||P1.TRANSTM) -- 中台日期
    ,P1.FRONTTRCD -- 中台交易码
    ,P1.PCKNO -- 报文编号
    ,P1.TRANSSEQ -- 报文标识编号
    ,P1.SNDBRN -- 发送行号
    ,P1.SNDBRNLEI -- 发起行LEI码
    ,P1.RCVBRN -- 接收行号
    ,P1.RCVBRNLEI -- 接收行LEI码
    ,${iml_schema}.dateformat_max2(P1.CONSIGNDT) -- 委托日期
    ,P1.BUSINESSTRACE -- 行内业务序号
    ,P1.ERRCODE -- 行内错误码
    ,P1.ERRMS -- 行内错误信息
    ,nvl(trim(P1.IOTYPE),'-') -- 往来账标志
    ,P1.HOSTTRCD -- 金融交易码
    ,${iml_schema}.dateformat_max2(P1.HOSTDATE) -- 金融交易日期
    ,P1.HOSTNBR -- 金融交易流水号
    ,P1.FINMAINSEQ -- 金融中台流水号
    ,${iml_schema}.dateformat_max2(P1.FINTRANSDT) -- 金融中台日期
    ,nvl(trim(P1.CHKHOSTSTATUS),'-') -- 金融对账状态代码
    ,nvl(trim(P1.ACCTTP),'-') -- 账户类型代码
    ,nvl(trim(P1.CCYNBR),'-') -- 币种代码
    ,P1.PAYOPENBRN -- 付款人开户行号
    ,P1.PAYOPENBANKNM -- 付款人开户行名称
    ,nvl(trim(P1.PAYACCTTP),'-') -- 付款人账户类型代码
    ,P1.PAYACCT -- 付款人账户编号
    ,P1.PAYNAME -- 付款人名称
    ,nvl(trim(P1.PAYRESDTTP),'-') -- 付款账户居民类型代码
    ,nvl(trim(P1.PAYCTRYCODE),'XXX') -- 付款账户常驻地区代码
    ,P1.INCOOPENBANK -- 收款人开户行行号
    ,P1.INCOOPENBANKNM -- 收款人开户行名称
    ,nvl(trim(P1.INCOACCTTP),'-') -- 收款人账户类型代码
    ,P1.INCOACCT -- 收款人账户编号
    ,P1.INCONAME -- 收款人名称
    ,nvl(trim(P1.RCVRESDTTP),'-') -- 收款账户居民类型代码
    ,nvl(trim(P1.RCVCTRYCODE),'XXX') -- 收款账户常驻地区代码
    ,P1.OPRBRN -- 开户机构编号
    ,nvl(trim(P1.CDTRWLTLVL),'-') -- 钱包等级代码
    ,nvl(trim(P1.CDTRWLTTP),'-') -- 钱包类型代码
    ,P1.CDTRWLTNM -- 钱包名称
    ,nvl(trim(P1.PHNCTRYCODE),'XXX') -- 钱包注册手机号所在地区代码
    ,nvl(trim(P1.BUSTYPE),'-') -- 业务类型编号
    ,P1.SERVTYPE -- 业务种类编号
    ,P1.UNIQUESEQNUM -- 业务流水号
    ,P1.PRCCD -- 业务处理码
    ,${iml_schema}.dateformat_max2(P1.TRANSMITDT) -- 业务处理日期
    ,nvl(trim(P1.PRCSTS),'-') -- 业务状态代码
    ,nvl(trim(P1.PROCESSCODE),'-') -- 业务回执状态代码
    ,P1.REJECTCODE -- 业务拒绝码
    ,P1.REJECTINFO -- 业务拒绝信息
    ,nvl(trim(P1.CHKPRODSTATUS),'-') -- 业务对账状态代码
    ,P1.BATCHID -- 交易批次号
    ,to_number(nvl(trim(P1.TRANSAMT),'0')) -- 交易金额
    ,nvl(trim(P1.STATUS),'-') -- 交易状态代码
    ,nvl(trim(P1.PROCFLAG),'-') -- 交易异常处理标志
    ,P1.FILL -- 交易结果描述
    ,case when P1.PCKNO = 'dcep.225.001.01' 
      then nvl(trim(P1.TRANSACTION),'-')
      else '-' 
     end-- 交易用途代码
    ,case when P1.PCKNO = 'dcep.221.001.01' 
      then nvl(trim(P1.TRANSACTION),'-')
      else '-' 
     end -- 交易资金来源代码
    ,${iml_schema}.dateformat_min(P1.BEGINTM) -- 交易生效日期
    ,${iml_schema}.dateformat_max2(P1.ENDTM) -- 交易失效日期
    ,nvl(trim(P1.OPNWIN),'-') -- 交易渠道代码
    ,P1.OPRTLR -- 交易柜员编号
    ,nvl(trim(P1.CDFLAG),'-') -- 借贷标志
    ,nvl(trim(P1.FEEFLAG),'-') -- 手续费标志
    ,to_number(nvl(trim(P1.FEEAMT),'0'))  -- 手续费金额
    ,to_number(nvl(trim(P1.RECNT),'0')) -- 处理次数
    ,P1.DSPTRSNCD -- 差错原因码
    ,P1.DSPTRSNDESC -- 差错原因说明
    ,${iml_schema}.dateformat_max2(P1.RCVDT||P1.RCVTM) -- 回执交易日期
    ,P1.MSGID -- 回执报文标识编号
    ,P1.MSGTP -- 回执报文编号
    ,P1.MSGNO -- 通信级标识流水号
    ,P1.REFMSGNO -- 通信级参考流水号
    ,${iml_schema}.dateformat_max2(P1.ORACONSIGNDT) -- 原委托日期
    ,P1.ORATRANSSEQ -- 原报文标识编号
    ,P1.ORASNDBRN -- 原发起参与机构编号
    ,P1.ORAPCKNO -- 原报文类型编号
    ,P1.GLOBALSEQNO -- 全局流水号
    ,P1.SRCSYSSSN -- 统一支付渠道流水号
    ,P1.SGNNO -- 挂接协议编号
    ,P1.RETURNCODE -- ESC接口返回码
    ,P1.RETURNMSG -- ESC接口返回信息
    ,P1.TRANSSEQNO -- ESC接口交易流水号
    ,to_number(nvl(trim(P1.DSPTAMT),'0')) -- 调账金额
    ,P1.INFO -- 附言
    ,P1.NOTE -- 备注
    ,P1.MAGEBRN -- 管理机构编号
    ,${iml_schema}.dateformat_max2(P1.CHANGTIME) -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a1stdcpstrx' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a1stdcpstrx p1
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_digit_curr_bus_tran_flow truncate partition p_mpcsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_digit_curr_bus_tran_flow exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.evt_digit_curr_bus_tran_flow_mpcsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_digit_curr_bus_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_digit_curr_bus_tran_flow_mpcsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_digit_curr_bus_tran_flow', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);