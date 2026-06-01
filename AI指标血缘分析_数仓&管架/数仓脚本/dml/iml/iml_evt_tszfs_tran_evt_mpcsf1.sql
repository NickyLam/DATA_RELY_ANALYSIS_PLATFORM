/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_tszfs_tran_evt_mpcsf1
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
drop table ${iml_schema}.evt_tszfs_tran_evt_mpcsf1_tm purge;
alter table ${iml_schema}.evt_tszfs_tran_evt add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_tszfs_tran_evt modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_tszfs_tran_evt_mpcsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,tran_dt -- 交易日期
    ,bank_int_bus_seq_num -- 行内业务序号
    ,msg_type_id -- 报文类型编号
    ,bus_type_cd -- 业务类型代码
    ,bus_id -- 业务编号
    ,pay_tran_seq_num -- 支付交易序号
    ,dtl_entr_dt -- 明细委托日期
    ,csner_id -- 委托方编号
    ,belong_batch_bus_seq_num -- 所属批量包业务序号
    ,pkg_seq_num -- 包序号
    ,host_tran_code -- 主机交易码
    ,midgrod_tran_code -- 中台交易码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,pay_bank_no -- 付款行行号
    ,pay_bank_name -- 付款行行名称
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行行名称
    ,payer_open_bank_no -- 付款人开户行行号
    ,payer_open_bank_name -- 付款人开户行名称
    ,payer_acct_num -- 付款人账号
    ,payer_name -- 付款人名称
    ,payer_addr -- 付款人地址
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_acct_num -- 收款人账号
    ,recver_name -- 收款人名称
    ,recver_addr -- 收款人地址
    ,init_bus_type_cd -- 原业务类型代码
    ,init_entr_dt -- 原委托日期
    ,init_pay_tran_seq_num -- 原支付交易序号
    ,init_csner_id -- 原委托方编号
    ,init_belong_bus_seq_num -- 原所属包业务序号
    ,offs_bal_num_site -- 轧差场次
    ,offs_bal_dt -- 轧差日期
    ,proc_status_cd -- 处理状态代码
    ,rest_cd -- 处理结果代码
    ,nostro_flg -- 往来账标志
    ,debit_crdt_cd -- 借贷代码
    ,proc_org_id -- 处理机构编号
    ,input_teller_id -- 录入柜员编号
    ,check_teller_id -- 复核柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,input_check_teller_dept_id -- 录入复核柜员部门编号
    ,auth_teller_dept_id -- 授权柜员部门编号
    ,refund_rs_cd -- 退汇原因代码
    ,sys_type_cd -- 系统类型代码
    ,node_type_cd -- 节点类型代码
    ,refund_rest_cd -- 退汇结果代码
    ,center_return_status_cd -- 中心返回状态代码
    ,center_return_proc_code -- 中心返回处理编码
    ,center_return_process_cd_comnt -- 中心返回处理码处理说明
    ,bank_return_proc_code -- 银行返回处理编码
    ,bank_return_process_cd_comnt -- 银行返回处理码处理说明
    ,reg_bus_batch_no -- 定期业务批次号
    ,clear_dt -- 清算日期
    ,err_code -- 错误编码
    ,err_info -- 错误信息
    ,prior_level -- 优先级别
    ,check_entry_status_cd -- 对账状态代码
    ,print_cnt -- 打印次数
    ,nostro_tm -- 往来账时间
    ,charge_flg -- 收费标志
    ,bank_int_out_line_flg -- 行内行外标志
    ,matn_enter_acct_acct_num -- 维护入账账号
    ,reg_main_name -- 挂账或维护入账姓名
    ,matn_enter_acct_dt -- 维护入账日期
    ,matn_enter_acct_teller_id -- 维护入账柜员编号
    ,matn_enter_acct_dept_id -- 维护入账部门编号
    ,mpr_host_flow_num -- 维护入账冲账主机流水号
    ,mpr_host_dt -- 维护入账冲账主机日期
    ,mpr_teller_id -- 维护入账冲账柜员编号
    ,agent_flg -- 代理标志
    ,vouch_type_cd -- 凭证类型代码
    ,entr_vouch_dt -- 委托凭证日期
    ,entr_vouch_id -- 委托凭证编号
    ,cert_kind_cd -- 证件种类代码
    ,cert_no -- 证件号码
    ,tran_flow_num -- 交易流水号
    ,send_tran_flow_num -- 发送交易流水号
    ,mode_pay_cd -- 支付方式代码
    ,exch_bus_cors_tran_chn_cd -- 汇兑业务对应交易渠道代码
    ,comm_fee -- 手续费
    ,remit_tran_fee -- 汇划费
    ,todos -- 工本费
    ,comm_fee_tot -- 手续费总额
    ,recnt_modif_tm -- 最近修改时间
    ,rec_status_cd -- 记录状态代码
    ,prod_cd -- 产品代码
    ,intnal_acct_flg -- 内部账标志
    ,actl_deduct_acct_num -- 实际扣账账号
    ,actl_deduct_acct_name -- 实际扣账户名称
    ,ground_proc_status_cd -- 落地处理状态代码
    ,verify_proc_status_cd -- 查证处理状态代码
    ,rgst_addit_data_name -- 登记附加数据表名称
    ,on_acct_rs_cd -- 挂账原因代码
    ,modif_teller_id -- 修改柜员编号
    ,rg_cd -- 地区代码
    ,acct_info_check_flg -- 账户信息检查标志
    ,cash_tran_flg -- 现金转账标志
    ,realtm_crdt_enter_acct_flg -- 实时贷记实时入账标志
    ,ec_flg -- 钞汇标志
    ,reg_debit_crdt_agt_id -- 定期借贷记协议编号
    ,reissue_flg -- 补发标志
    ,bill_flg -- 票据标志
    ,bill_type_cd -- 票据类型代码
    ,bill_num -- 票据号码
    ,chn_dt -- 渠道日期
    ,chn_flow_num -- 渠道流水号
    ,init_bus_seq_num -- 原业务包序号
    ,corp_cd -- 企业单位代码
    ,fee_item_cd -- 费项代码
    ,fee_item_name -- 费项名称
    ,bus_amt -- 业务金额
    ,pay_bank_withhold_comm_fee -- 需付款行代扣手续费
    ,strk_bal_rs -- 冲账原因
    ,happ_od_flg -- 发生透支标志
    ,od_amt -- 透支金额
    ,delay_duran_cd -- 延时时长代码
    ,auto_refund_flg -- 自动退汇标志
    ,auto_refund_cnt -- 自动退汇次数
    ,vtual_acct_bind_acct -- 虚户绑定账户
    ,vtual_acct_bind_acct_name -- 虚户绑定账户名称
    ,indv_corp_flg -- 个人企业标志
    ,upp_return_order_no -- UPP返回订单号
    ,actl_recver_num_type_cd -- 实际收款人账号类型代码
    ,acct_type_cd -- 账户类型代码
    ,vtual_open_acct_org_id -- 虚户绑定账户开户机构编号
    ,open_acct_org_id -- 开户机构编号
    ,acct_cate_cd -- 账户类别代码
    ,follow_up_oper_flg -- 后续操作标志
    ,cust_id -- 交易客户编号
    ,agt_id -- 协议编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_tszfs_tran_evt
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- mpcs_a68tszfstrx-
insert into ${iml_schema}.evt_tszfs_tran_evt_mpcsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,tran_dt -- 交易日期
    ,bank_int_bus_seq_num -- 行内业务序号
    ,msg_type_id -- 报文类型编号
    ,bus_type_cd -- 业务类型代码
    ,bus_id -- 业务编号
    ,pay_tran_seq_num -- 支付交易序号
    ,dtl_entr_dt -- 明细委托日期
    ,csner_id -- 委托方编号
    ,belong_batch_bus_seq_num -- 所属批量包业务序号
    ,pkg_seq_num -- 包序号
    ,host_tran_code -- 主机交易码
    ,midgrod_tran_code -- 中台交易码
    ,host_dt -- 主机日期
    ,host_flow_num -- 主机流水号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,pay_bank_no -- 付款行行号
    ,pay_bank_name -- 付款行行名称
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行行名称
    ,payer_open_bank_no -- 付款人开户行行号
    ,payer_open_bank_name -- 付款人开户行名称
    ,payer_acct_num -- 付款人账号
    ,payer_name -- 付款人名称
    ,payer_addr -- 付款人地址
    ,recver_open_bank_no -- 收款人开户行行号
    ,recver_open_bank_name -- 收款人开户行名称
    ,recver_acct_num -- 收款人账号
    ,recver_name -- 收款人名称
    ,recver_addr -- 收款人地址
    ,init_bus_type_cd -- 原业务类型代码
    ,init_entr_dt -- 原委托日期
    ,init_pay_tran_seq_num -- 原支付交易序号
    ,init_csner_id -- 原委托方编号
    ,init_belong_bus_seq_num -- 原所属包业务序号
    ,offs_bal_num_site -- 轧差场次
    ,offs_bal_dt -- 轧差日期
    ,proc_status_cd -- 处理状态代码
    ,rest_cd -- 处理结果代码
    ,nostro_flg -- 往来账标志
    ,debit_crdt_cd -- 借贷代码
    ,proc_org_id -- 处理机构编号
    ,input_teller_id -- 录入柜员编号
    ,check_teller_id -- 复核柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,input_check_teller_dept_id -- 录入复核柜员部门编号
    ,auth_teller_dept_id -- 授权柜员部门编号
    ,refund_rs_cd -- 退汇原因代码
    ,sys_type_cd -- 系统类型代码
    ,node_type_cd -- 节点类型代码
    ,refund_rest_cd -- 退汇结果代码
    ,center_return_status_cd -- 中心返回状态代码
    ,center_return_proc_code -- 中心返回处理编码
    ,center_return_process_cd_comnt -- 中心返回处理码处理说明
    ,bank_return_proc_code -- 银行返回处理编码
    ,bank_return_process_cd_comnt -- 银行返回处理码处理说明
    ,reg_bus_batch_no -- 定期业务批次号
    ,clear_dt -- 清算日期
    ,err_code -- 错误编码
    ,err_info -- 错误信息
    ,prior_level -- 优先级别
    ,check_entry_status_cd -- 对账状态代码
    ,print_cnt -- 打印次数
    ,nostro_tm -- 往来账时间
    ,charge_flg -- 收费标志
    ,bank_int_out_line_flg -- 行内行外标志
    ,matn_enter_acct_acct_num -- 维护入账账号
    ,reg_main_name -- 挂账或维护入账姓名
    ,matn_enter_acct_dt -- 维护入账日期
    ,matn_enter_acct_teller_id -- 维护入账柜员编号
    ,matn_enter_acct_dept_id -- 维护入账部门编号
    ,mpr_host_flow_num -- 维护入账冲账主机流水号
    ,mpr_host_dt -- 维护入账冲账主机日期
    ,mpr_teller_id -- 维护入账冲账柜员编号
    ,agent_flg -- 代理标志
    ,vouch_type_cd -- 凭证类型代码
    ,entr_vouch_dt -- 委托凭证日期
    ,entr_vouch_id -- 委托凭证编号
    ,cert_kind_cd -- 证件种类代码
    ,cert_no -- 证件号码
    ,tran_flow_num -- 交易流水号
    ,send_tran_flow_num -- 发送交易流水号
    ,mode_pay_cd -- 支付方式代码
    ,exch_bus_cors_tran_chn_cd -- 汇兑业务对应交易渠道代码
    ,comm_fee -- 手续费
    ,remit_tran_fee -- 汇划费
    ,todos -- 工本费
    ,comm_fee_tot -- 手续费总额
    ,recnt_modif_tm -- 最近修改时间
    ,rec_status_cd -- 记录状态代码
    ,prod_cd -- 产品代码
    ,intnal_acct_flg -- 内部账标志
    ,actl_deduct_acct_num -- 实际扣账账号
    ,actl_deduct_acct_name -- 实际扣账户名称
    ,ground_proc_status_cd -- 落地处理状态代码
    ,verify_proc_status_cd -- 查证处理状态代码
    ,rgst_addit_data_name -- 登记附加数据表名称
    ,on_acct_rs_cd -- 挂账原因代码
    ,modif_teller_id -- 修改柜员编号
    ,rg_cd -- 地区代码
    ,acct_info_check_flg -- 账户信息检查标志
    ,cash_tran_flg -- 现金转账标志
    ,realtm_crdt_enter_acct_flg -- 实时贷记实时入账标志
    ,ec_flg -- 钞汇标志
    ,reg_debit_crdt_agt_id -- 定期借贷记协议编号
    ,reissue_flg -- 补发标志
    ,bill_flg -- 票据标志
    ,bill_type_cd -- 票据类型代码
    ,bill_num -- 票据号码
    ,chn_dt -- 渠道日期
    ,chn_flow_num -- 渠道流水号
    ,init_bus_seq_num -- 原业务包序号
    ,corp_cd -- 企业单位代码
    ,fee_item_cd -- 费项代码
    ,fee_item_name -- 费项名称
    ,bus_amt -- 业务金额
    ,pay_bank_withhold_comm_fee -- 需付款行代扣手续费
    ,strk_bal_rs -- 冲账原因
    ,happ_od_flg -- 发生透支标志
    ,od_amt -- 透支金额
    ,delay_duran_cd -- 延时时长代码
    ,auto_refund_flg -- 自动退汇标志
    ,auto_refund_cnt -- 自动退汇次数
    ,vtual_acct_bind_acct -- 虚户绑定账户
    ,vtual_acct_bind_acct_name -- 虚户绑定账户名称
    ,indv_corp_flg -- 个人企业标志
    ,upp_return_order_no -- UPP返回订单号
    ,actl_recver_num_type_cd -- 实际收款人账号类型代码
    ,acct_type_cd -- 账户类型代码
    ,vtual_open_acct_org_id -- 虚户绑定账户开户机构编号
    ,open_acct_org_id -- 开户机构编号
    ,acct_cate_cd -- 账户类别代码
    ,follow_up_oper_flg -- 后续操作标志
    ,cust_id -- 交易客户编号
    ,agt_id -- 协议编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102048'||P1.TRANSDT||P1.MAINSEQ -- 事件编号
    ,'9999' -- 法人编号
    ,P1.MAINSEQ -- 中台流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSDT) -- 交易日期
    ,P1.BUSINESSTRACE -- 行内业务序号
    ,P1.PCKNO -- 报文类型编号
    ,NVL(TRIM(P1.TXTPCD),'-') -- 业务类型代码
    ,P1.TXCD -- 业务编号
    ,P1.TXID -- 支付交易序号
    ,${iml_schema}.DATEFORMAT_MAX(P1.CNSDT) -- 明细委托日期
    ,P1.INSTGPTY -- 委托方编号
    ,P1.PKGBUSINESSTRACE -- 所属批量包业务序号
    ,P1.PKSQNO -- 包序号
    ,P1.HOSTTRCD -- 主机交易码
    ,P1.FRONTTRCD -- 中台交易码
    ,${iml_schema}.DATEFORMAT_MIN(P1.HOSTDATE) -- 主机日期
    ,P1.HOSTNBR -- 主机流水号
    ,nvl(trim(P1.CRCYCD),'CNY') -- 币种代码
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.TRANSAMT, '[0-9.]+')),0)) -- 交易金额
    ,P1.DBTRID -- 付款行行号
    ,P1.SNDBRNNAME -- 付款行行名称
    ,P1.CDTRID -- 收款行行号
    ,P1.RCVBRNNAME -- 收款行行名称
    ,P1.PAYOPENBANK -- 付款人开户行行号
    ,P1.PAYOPENBANKNM -- 付款人开户行名称
    ,P1.PAYACCT -- 付款人账号
    ,P1.PAYNAME -- 付款人名称
    ,P1.PAYADDR -- 付款人地址
    ,P1.RCVOPENBANK -- 收款人开户行行号
    ,P1.RCVOPENBANKNM -- 收款人开户行名称
    ,P1.RCVACCT -- 收款人账号
    ,P1.RCVNAME -- 收款人名称
    ,P1.RCVADDR -- 收款人地址
    ,NVL(TRIM(P1.ORGNLTXTPCD),'-') -- 原业务类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.ORGNLCNSDT) -- 原委托日期
    ,P1.ORGNLTXID -- 原支付交易序号
    ,P1.ORGNLINSTGPTY -- 原委托方编号
    ,P1.ORGNLPKGBUSTRACE -- 原所属包业务序号
    ,P1.NETGRND -- 轧差场次
    ,${iml_schema}.DATEFORMAT_MAX(P1.NETGDT) -- 轧差日期
    ,P1.TRANST -- 处理状态代码
    ,case when length(nvl(trim(iotype||'C' ||TRANST),''))<3 then '-'
when TXTPCD in ('101','103','106','801','305','306','803','402','804') then iotype||'C'||TRANST  when  TXTPCD in('102','112','104','107','405','805','501') then iotype||'D'||TRANST else '-' end  -- 处理结果代码
    ,P1.IOTYPE -- 往来账标志
    ,NVL(TRIM(P1.FLAG4),'-') -- 借贷代码
    ,P1.MAGEBRN -- 处理机构编号
    ,P1.OPRTLR -- 录入柜员编号
    ,P1.CHKTLR -- 复核柜员编号
    ,P1.AUTTLR -- 授权柜员编号
    ,P1.OPRBRN -- 录入复核柜员部门编号
    ,P1.AUTBRN -- 授权柜员部门编号
    ,P1.CACLRS -- 退汇原因代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||substr(CACLRS,1,2) END -- 系统类型代码
    ,NVL(trim(substr(CACLRS,3,1)),'-') -- 节点类型代码
    ,NVL(trim(substr(CACLRS,length(CACLRS)-4,5)),'-') -- 退汇结果代码
    ,NVL(TRIM(P1.PROCESSCODE),'-') -- 中心返回状态代码
    ,P1.RSPNCD -- 中心返回处理编码
    ,P1.RSPNINF -- 中心返回处理码处理说明
    ,P1.RTNCD -- 银行返回处理编码
    ,P1.RTNINF -- 银行返回处理码处理说明
    ,P1.DISKNO -- 定期业务批次号
    ,${iml_schema}.DATEFORMAT_MIN(P1.CLERDT) -- 清算日期
    ,P1.BPERNO -- 错误编码
    ,P1.BPERMG -- 错误信息
    ,P1.LEVELS -- 优先级别
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CHKSTA END -- 对账状态代码
    ,P1.PRTCNT -- 打印次数
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSMITDT) -- 往来账时间
    ,P1.FEEFLAG -- 收费标志
    ,P1.INOUTFLAG -- 行内行外标志
    ,P1.SACACT -- 维护入账账号
    ,P1.SACANA -- 挂账或维护入账姓名
    ,${iml_schema}.DATEFORMAT_MAX(P1.CLENDT) -- 维护入账日期
    ,P1.CLENUS -- 维护入账柜员编号
    ,P1.CLRBRN -- 维护入账部门编号
    ,P1.EDHTNO -- 维护入账冲账主机流水号
    ,${iml_schema}.DATEFORMAT_MAX(P1.EDHTDT) -- 维护入账冲账主机日期
    ,P1.ENDTLR -- 维护入账冲账柜员编号
    ,P1.PRDNBR -- 代理标志
    ,NVL(TRIM(P1.BOOKCD),'000') -- 凭证类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.COBKDT) -- 委托凭证日期
    ,P1.BOOKNBR -- 委托凭证编号
    ,nvl(trim(P1.IDTYPE),'0000') END -- 证件种类代码
    ,P1.IDNO -- 证件号码
    ,P1.TRANSQ -- 交易流水号
    ,P1.SDTRSQ -- 发送交易流水号
    ,NVL(TRIM(P1.PAYMOD),'-') -- 支付方式代码
    ,nvl(trim(P1.OPNWIN),'-') -- 汇兑业务对应交易渠道代码
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.FEAMT1, '[0-9.]+')),0)) -- 手续费
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.FEAMT2, '[0-9.]+')),0)) -- 汇划费
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.FEAMT3, '[0-9.]+')),0)) -- 工本费
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.CALFEE, '[0-9.]+')),0)) -- 手续费总额
    ,${iml_schema}.DATEFORMAT_MIN(P1.CHNGTI) -- 最近修改时间
    ,NVL(TRIM(P1.RCDSTA),'-') -- 记录状态代码
    ,NVL(TRIM(P1.PRODCD),'UNKN') -- 产品代码
    ,P1.ISINOUT -- 内部账标志
    ,P1.INACCT -- 实际扣账账号
    ,P1.INNAME -- 实际扣账户名称
    ,NVL(TRIM(P1.LANDDEALSTS),'-') -- 落地处理状态代码
    ,NVL(TRIM(P1.CHECKDEALSTS),'-') -- 查证处理状态代码
    ,P1.APPENDDATATABLE -- 登记附加数据表名称
    ,NVL(TRIM(P1.HANGUPREASON),'-') -- 挂账原因代码
    ,P1.MODIFYTLR -- 修改柜员编号
    ,NVL(TRIM(P1.AREACD),'-') -- 地区代码
    ,P1.ACCTCHCKFLG -- 账户信息检查标志
    ,P1.SERVMODE -- 现金转账标志
    ,P1.REALTMCDTFLG -- 实时贷记实时入账标志
    ,P1.CHFLAG -- 钞汇标志
    ,P1.PROTOCOLNB -- 定期借贷记协议编号
    ,P1.RESNDFLG -- 补发标志
    ,P1.BLLIND -- 票据标志
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.BLLTP END -- 票据类型代码
    ,P1.BILLNB -- 票据号码
    ,${iml_schema}.DATEFORMAT_MIN(P1.CHANNELDT) -- 渠道日期
    ,P1.TRANFLOWNO -- 渠道流水号
    ,P1.ORGNLPKSQNO -- 原业务包序号
    ,P1.CORPRTNID -- 企业单位代码
    ,P1.PMTITMCD -- 费项代码
    ,P1.PMTITMNM -- 费项名称
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.BILLAMOUNT, '[0-9.]+')),0)) -- 业务金额
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.FEEAMOUNT, '[0-9.]+')),0)) -- 需付款行代扣手续费
    ,P1.INFO2 -- 冲账原因
    ,P1.OD_FLAG -- 发生透支标志
    ,P1.OD_OVTRANAM -- 透支金额
    ,NVL(TRIM(P1.TOACCOUNTFLAG),'-') -- 延时时长代码
    ,P1.AUTOFLAG -- 自动退汇标志
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.AUTOCOUNT, '[0-9.]+')),0)) -- 自动退汇次数
    ,P1.BINDACCT -- 虚户绑定账户
    ,P1.BINDACCTNM -- 虚户绑定账户名称
    ,P1.EFLAG -- 个人企业标志
    ,P1.UPPORDERID -- UPP返回订单号
    ,NVL(TRIM(P1.INTOACCOUNTTYPE),'-') -- 实际收款人账号类型代码
    ,NVL(TRIM(P1.ACCTTYPE),'-') -- 账户类型代码
    ,P1.BINDACCTOPNBRN -- 虚户绑定账户开户机构编号
    ,P1.BRANCHID -- 开户机构编号
    ,NVL(TRIM(P1.TACCTP),'-') -- 账户类别代码
    ,P1.HANDLEFLAG -- 后续操作标志
    ,P1.CUSTNO -- 交易客户编号
    ,P1.PMTID -- 协议编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a68tszfstrx' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a68tszfstrx p1
    left join ${iml_schema}.ref_pub_cd_map r5 on substr(CACLRS,1,2) = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'MPCS'
        AND R5.SRC_TAB_EN_NAME= 'MPCS_A68TSZFSTRX'
        AND R5.SRC_FIELD_EN_NAME= 'CACLRS'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_TSZFS_TRAN_EVT'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'SYS_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CHKSTA = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A68TSZFSTRX'
        AND R2.SRC_FIELD_EN_NAME= 'CHKSTA'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_TSZFS_TRAN_EVT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CHECK_ENTRY_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.IDTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A68TSZFSTRX'
        AND R3.SRC_FIELD_EN_NAME= 'IDTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_TSZFS_TRAN_EVT'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CERT_KIND_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.OPNWIN = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'MPCS'
        AND R6.SRC_TAB_EN_NAME= 'MPCS_A68TSZFSTRX'
        AND R6.SRC_FIELD_EN_NAME= 'OPNWIN'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_TSZFS_TRAN_EVT'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'EXCH_BUS_CORS_TRAN_CHN_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.BLLTP = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MPCS'
        AND R4.SRC_TAB_EN_NAME= 'MPCS_A68TSZFSTRX'
        AND R4.SRC_FIELD_EN_NAME= 'BLLTP'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_TSZFS_TRAN_EVT'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'BILL_TYPE_CD'
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_tszfs_tran_evt truncate partition p_mpcsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_tszfs_tran_evt exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.evt_tszfs_tran_evt_mpcsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_tszfs_tran_evt to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_tszfs_tran_evt_mpcsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_tszfs_tran_evt', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);