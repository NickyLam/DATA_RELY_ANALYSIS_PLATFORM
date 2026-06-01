/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bank_draft_rgst_flow_mpcsi1
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
drop table ${iml_schema}.evt_bank_draft_rgst_flow_mpcsi1_tm purge;
alter table ${iml_schema}.evt_bank_draft_rgst_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_bank_draft_rgst_flow modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bank_draft_rgst_flow_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,tran_dt -- 交易日期
    ,bill_id -- 票据编号
    ,draw_dt -- 出票日期
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,proc_org_id -- 受理机构编号
    ,draft_type_cd -- 汇票类型代码
    ,curr_cd -- 币种代码
    ,draw_amt -- 出票金额
    ,cash_bk_bank_no -- 兑付行行号
    ,cash_bank_name -- 兑付行名称
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,cap_usage_cd -- 资金用途代码
    ,postsc -- 附言
    ,draft_status_cd -- 汇票状态代码
    ,draft_src_cd -- 汇票来源代码
    ,final_holder_open_bank_no -- 最后持票人开户行行号
    ,final_holder_acct_id -- 最后持票人账户编号
    ,final_holder_name -- 最后持票人名称
    ,proc_dt -- 受理日期
    ,proc_flow_num -- 受理流水号
    ,proc_teller_id -- 受理柜员编号
    ,amt_auth_teller_id -- 金额授权柜员编号
    ,matn_entra_teller_id -- 维护入场柜员编号
    ,matn_enter_acct_auth_teller_id -- 维护入账授权柜员编号
    ,print_teller_id -- 打印柜员编号
    ,print_cnt -- 打印次数
    ,cash_dt -- 兑付日期
    ,cash_amt -- 兑付金额
    ,msg_id -- 报文编号
    ,entr_dt -- 委托日期
    ,process_cd -- 处理码
    ,loss_stop_pay_dt -- 挂失止付日期
    ,loss_stop_pay_teller_id -- 挂失止付柜员编号
    ,unloss_or_revo_stop_pay_dt -- 解挂或撤销止付日期
    ,unloss_or_revo_stop_pay_teller_id -- 解挂或撤销止付柜员编号
    ,loss_applit_cert_type_cd -- 挂失申请人证件类型代码
    ,loss_applit_cert_no -- 挂失申请人证件号码
    ,loss_operr_name -- 挂失经办人名称
    ,loss_operr_cont_addr -- 挂失经办人联系地址
    ,loss_operr_phone -- 挂失经办人联系电话
    ,lost_reason -- 丧失理由
    ,lost_dt -- 丧失日期
    ,lost_site_descb -- 丧失地点描述
    ,unloss_applit_cert_type_cd -- 解挂申请人证件类型代码
    ,unloss_applit_cert_no -- 解挂申请人证件号码
    ,unloss_operr_name -- 解挂经办人名称
    ,unloss_operr_cont_addr -- 解挂经办人联系地址
    ,unloss_operr_phone -- 解挂经办人联系电话
    ,unloss_rest_descb -- 解挂处理结果描述
    ,stop_pay_proof_cate -- 止付证明类别
    ,stop_pay_proof_id -- 止付证明编号
    ,stop_pay_rs_descb -- 止付原因描述
    ,stop_pay_exec_org -- 止付执行机关
    ,stop_pay_exec_person_name -- 止付执行人员名称
    ,stop_pay_cert_type_cd -- 止付证件类型代码
    ,stop_pay_cert_no -- 止付证件号码
    ,revo_stop_pay_proof_cate_cd -- 撤销止付证明类别代码
    ,revo_stop_pay_proof_id -- 撤销止付证明编号
    ,revo_stop_pay_rs_descb -- 撤销止付原因描述
    ,revo_stop_pay_exec_org -- 撤销止付执行机关
    ,revo_stop_pay_exec_person_name -- 撤销止付执行人员名称
    ,revo_stop_pay_cert_type_cd -- 撤销止付证件类型代码
    ,revo_stop_pay_cert_no -- 撤销止付证件号码
    ,issue_draft_charge_way_cd -- 签发汇票收费方式代码
    ,charge_flg -- 收费标志
    ,comm_fee_amt -- 手续费金额
    ,remit_tran_fee_amt -- 汇划费用金额
    ,todos_amt -- 工本费金额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bank_draft_rgst_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a08thvhp-1
insert into ${iml_schema}.evt_bank_draft_rgst_flow_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,tran_dt -- 交易日期
    ,bill_id -- 票据编号
    ,draw_dt -- 出票日期
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,proc_org_id -- 受理机构编号
    ,draft_type_cd -- 汇票类型代码
    ,curr_cd -- 币种代码
    ,draw_amt -- 出票金额
    ,cash_bk_bank_no -- 兑付行行号
    ,cash_bank_name -- 兑付行名称
    ,recver_name -- 收款人名称
    ,recver_acct_id -- 收款人账户编号
    ,cap_usage_cd -- 资金用途代码
    ,postsc -- 附言
    ,draft_status_cd -- 汇票状态代码
    ,draft_src_cd -- 汇票来源代码
    ,final_holder_open_bank_no -- 最后持票人开户行行号
    ,final_holder_acct_id -- 最后持票人账户编号
    ,final_holder_name -- 最后持票人名称
    ,proc_dt -- 受理日期
    ,proc_flow_num -- 受理流水号
    ,proc_teller_id -- 受理柜员编号
    ,amt_auth_teller_id -- 金额授权柜员编号
    ,matn_entra_teller_id -- 维护入场柜员编号
    ,matn_enter_acct_auth_teller_id -- 维护入账授权柜员编号
    ,print_teller_id -- 打印柜员编号
    ,print_cnt -- 打印次数
    ,cash_dt -- 兑付日期
    ,cash_amt -- 兑付金额
    ,msg_id -- 报文编号
    ,entr_dt -- 委托日期
    ,process_cd -- 处理码
    ,loss_stop_pay_dt -- 挂失止付日期
    ,loss_stop_pay_teller_id -- 挂失止付柜员编号
    ,unloss_or_revo_stop_pay_dt -- 解挂或撤销止付日期
    ,unloss_or_revo_stop_pay_teller_id -- 解挂或撤销止付柜员编号
    ,loss_applit_cert_type_cd -- 挂失申请人证件类型代码
    ,loss_applit_cert_no -- 挂失申请人证件号码
    ,loss_operr_name -- 挂失经办人名称
    ,loss_operr_cont_addr -- 挂失经办人联系地址
    ,loss_operr_phone -- 挂失经办人联系电话
    ,lost_reason -- 丧失理由
    ,lost_dt -- 丧失日期
    ,lost_site_descb -- 丧失地点描述
    ,unloss_applit_cert_type_cd -- 解挂申请人证件类型代码
    ,unloss_applit_cert_no -- 解挂申请人证件号码
    ,unloss_operr_name -- 解挂经办人名称
    ,unloss_operr_cont_addr -- 解挂经办人联系地址
    ,unloss_operr_phone -- 解挂经办人联系电话
    ,unloss_rest_descb -- 解挂处理结果描述
    ,stop_pay_proof_cate -- 止付证明类别
    ,stop_pay_proof_id -- 止付证明编号
    ,stop_pay_rs_descb -- 止付原因描述
    ,stop_pay_exec_org -- 止付执行机关
    ,stop_pay_exec_person_name -- 止付执行人员名称
    ,stop_pay_cert_type_cd -- 止付证件类型代码
    ,stop_pay_cert_no -- 止付证件号码
    ,revo_stop_pay_proof_cate_cd -- 撤销止付证明类别代码
    ,revo_stop_pay_proof_id -- 撤销止付证明编号
    ,revo_stop_pay_rs_descb -- 撤销止付原因描述
    ,revo_stop_pay_exec_org -- 撤销止付执行机关
    ,revo_stop_pay_exec_person_name -- 撤销止付执行人员名称
    ,revo_stop_pay_cert_type_cd -- 撤销止付证件类型代码
    ,revo_stop_pay_cert_no -- 撤销止付证件号码
    ,issue_draft_charge_way_cd -- 签发汇票收费方式代码
    ,charge_flg -- 收费标志
    ,comm_fee_amt -- 手续费金额
    ,remit_tran_fee_amt -- 汇划费用金额
    ,todos_amt -- 工本费金额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201018'||p1.MAINSEQ||p1.TRANSDT -- 事件编号
    ,'9999' -- 法人编号
    ,P1.MAINSEQ -- 中台流水号
    ,${iml_schema}.dateformat_max2(P1.TRANSDT) -- 交易日期
    ,P1.CSHPBILLNB -- 票据编号
    ,${iml_schema}.dateformat_max2(P1.CSHPBILLDATE) -- 出票日期
    ,P1.PAYACCT -- 付款人账户编号
    ,P1.PAYNAME -- 付款人名称
    ,P1.MAGEBRN -- 受理机构编号
    ,P1.CSHPBILLTYPE -- 汇票类型代码
    ,P1.CCYNBR -- 币种代码
    ,P1.CSHPBILLAMT -- 出票金额
    ,P1.CSHPCASHBKNO -- 兑付行行号
    ,P1.CHNGNA -- 兑付行名称
    ,P1.INCONAME -- 收款人名称
    ,P1.INCOACCT -- 收款人账户编号
    ,P1.INFOCODE -- 资金用途代码
    ,P1.INFO -- 附言
    ,P1.BILLST -- 汇票状态代码
    ,P1.MSGSRC -- 汇票来源代码
    ,P1.CSHPLASTOPENBKNO -- 最后持票人开户行行号
    ,P1.CSHPLASTACCT -- 最后持票人账户编号
    ,P1.CSHPLASTNAME -- 最后持票人名称
    ,${iml_schema}.dateformat_max2(P1.OPERDT) -- 受理日期
    ,P1.OPERSQ -- 受理流水号
    ,P1.OPRTLR -- 受理柜员编号
    ,P1.CHKTLR -- 金额授权柜员编号
    ,P1.CLENUS -- 维护入场柜员编号
    ,P1.AUTTLR -- 维护入账授权柜员编号
    ,P1.PRTTLR -- 打印柜员编号
    ,P1.PRTCNT -- 打印次数
    ,${iml_schema}.dateformat_max2(P1.INCODT) -- 兑付日期
    ,P1.CHNGAM -- 兑付金额
    ,P1.REFDID -- 报文编号
    ,${iml_schema}.dateformat_max2(P1.CONSIGNDT) -- 委托日期
    ,P1.RESPCD -- 处理码
    ,${iml_schema}.dateformat_max2(P1.LOSTDT) -- 挂失止付日期
    ,P1.LOSTLR -- 挂失止付柜员编号
    ,${iml_schema}.dateformat_max2(P1.UNLSDT) -- 解挂或撤销止付日期
    ,P1.ULSTLR -- 解挂或撤销止付柜员编号
    ,P1.IDTFTP1 -- 挂失申请人证件类型代码
    ,P1.IDTFNO1 -- 挂失申请人证件号码
    ,P1.OPERNA1 -- 挂失经办人名称
    ,P1.LINKAD1 -- 挂失经办人联系地址
    ,P1.LINKTL1 -- 挂失经办人联系电话
    ,P1.LOSTRS1 -- 丧失理由
    ,${iml_schema}.dateformat_max2(P1.LOSTTM) -- 丧失日期
    ,P1.LOSTAD -- 丧失地点描述
    ,P1.IDTFTP2 -- 解挂申请人证件类型代码
    ,P1.IDTFNO2 -- 解挂申请人证件号码
    ,P1.OPERNA2 -- 解挂经办人名称
    ,P1.LINKAD2 -- 解挂经办人联系地址
    ,P1.LINKTL2 -- 解挂经办人联系电话
    ,P1.LOSTRS2 -- 解挂处理结果描述
    ,P1.PROVTP -- 止付证明类别
    ,P1.PROVNO -- 止付证明编号
    ,P1.REASON -- 止付原因描述
    ,P1.EXECUT -- 止付执行机关
    ,P1.EXECPE -- 止付执行人员名称
    ,P1.CERTTP -- 止付证件类型代码
    ,P1.CERTNO -- 止付证件号码
    ,P1.PROVTP2 -- 撤销止付证明类别代码
    ,P1.PROVNO2 -- 撤销止付证明编号
    ,P1.REASON2 -- 撤销止付原因描述
    ,P1.EXECUT2 -- 撤销止付执行机关
    ,P1.EXECPE2 -- 撤销止付执行人员名称
    ,P1.CERTTP2 -- 撤销止付证件类型代码
    ,P1.CERTNO2 -- 撤销止付证件号码
    ,P1.SIGNBILLTYPE -- 签发汇票收费方式代码
    ,P1.FLAG3 -- 收费标志
    ,P1.FEEAMT -- 手续费金额
    ,P1.FEEAMT1 -- 汇划费用金额
    ,P1.FEEAMT2 -- 工本费金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a08thvhp' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a08thvhp p1
where  1 = 1 
     and P1.TRANSDT='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_bank_draft_rgst_flow truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_bank_draft_rgst_flow exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_bank_draft_rgst_flow_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bank_draft_rgst_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_bank_draft_rgst_flow_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bank_draft_rgst_flow', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);