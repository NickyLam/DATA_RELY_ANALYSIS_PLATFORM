/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_evt_tax_pay_tran_flow
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_evt_tax_pay_tran_flow drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_evt_tax_pay_tran_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_evt_tax_pay_tran_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_evt_tax_pay_tran_flow partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,tran_dt  -- 交易日期
    ,tran_flow_num  -- 交易流水号
    ,tran_tm  -- 交易时间
    ,tran_type_subdv_cd  -- 交易类型细分代码
    ,nostro_cd  -- 往来账代码
    ,tran_status_cd  -- 交易状态代码
    ,mgmt_org_id  -- 管理机构编号
    ,check_entry_dt  -- 对账日期
    ,core_tran_dt  -- 核心交易日期
    ,core_tran_flow_num  -- 核心交易流水号
    ,revs_dt  -- 冲正日期
    ,revs_flow_num  -- 冲正流水号
    ,return_code  -- 返回码
    ,return_info  -- 返回信息
    ,init_rg_cd  -- 发起地区代码
    ,recv_rg_cd  -- 接收地区代码
    ,entr_dt  -- 委托日期
    ,mode_pay_cd  -- 支付方式代码
    ,curr_cd  -- 币种代码
    ,tran_amt  -- 交易金额
    ,comm_fee  -- 手续费
    ,postage  -- 邮电费
    ,todos  -- 工本费
    ,origi_bank_no  -- 发起行行号
    ,pay_bank_no  -- 付款行行号
    ,payer_open_bank_no  -- 付款人开户行行号
    ,payer_acct_id  -- 付款人账户编号
    ,payer_name  -- 付款人名称
    ,payer_open_acct_org_id  -- 付款人开户机构编号
    ,recv_bank_no  -- 收款行行号
    ,recver_open_bank_no  -- 收款人开户行行号
    ,recver_acct_id  -- 收款人账户编号
    ,recver_name  -- 收款人名称
    ,bus_chn_cd  -- 业务渠道代码
    ,bank_no  -- 经收处银行行号
    ,bank_submit_dt  -- 银行提交日期
    ,tax_bur_flow_num  -- 税局流水号
    ,org_cate_cd  -- 机关类别代码
    ,impose_org_id  -- 征收机关编号
    ,impose_org_submit_dt  -- 征收机关提交日期
    ,impose_org_flow_num  -- 征收机关流水号
    ,recvbl_trea_id  -- 收款国库编号
    ,tran_type_cd  -- 交易类型代码
    ,impose_org_revs_dt  -- 征收机关冲正日期
    ,impose_org_revs_flow_num  -- 征收机关冲正流水号
    ,taxpayer_id  -- 纳税人编号
    ,taxpayer_name  -- 纳税人名称
    ,decl_way_cd  -- 申报方式代码
    ,decl_flow_num  -- 申报流水号
    ,pay_way_cd  -- 缴款方式代码
    ,clear_dt  -- 清算日期
    ,bus_org_id  -- 营业机构编号
    ,teller_id  -- 柜员编号
    ,auth_teller_id  -- 授权柜员编号
    ,auth_brac_id  -- 授权网点编号
    ,bus_type_cd  -- 业务类型代码
    ,refund_acct_id  -- 退款账户编号
    ,refund_acct_name  -- 退款户账户名称
    ,pay_ps_tel_num  -- 缴款人电话号码
    ,pay_ps_cert_type_cd  -- 缴款人证件类型代码
    ,pay_ps_cert_no  -- 缴款人证件号码
    ,vouch_type_cd  -- 凭证类型代码
    ,vouch_id  -- 凭证编号
    ,tran_chn_cd  -- 交易渠道代码
    ,chn_flow_num  -- 渠道流水号
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,t1.tran_dt  -- 交易日期
    ,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'')  -- 交易流水号
    ,t1.tran_tm  -- 交易时间
    ,replace(replace(t1.tran_type_subdv_cd,chr(13),''),chr(10),'')  -- 交易类型细分代码
    ,replace(replace(t1.nostro_cd,chr(13),''),chr(10),'')  -- 往来账代码
    ,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'')  -- 交易状态代码
    ,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'')  -- 管理机构编号
    ,t1.check_entry_dt  -- 对账日期
    ,t1.core_tran_dt  -- 核心交易日期
    ,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'')  -- 核心交易流水号
    ,t1.revs_dt  -- 冲正日期
    ,replace(replace(t1.revs_flow_num,chr(13),''),chr(10),'')  -- 冲正流水号
    ,replace(replace(t1.return_code,chr(13),''),chr(10),'')  -- 返回码
    ,replace(replace(t1.return_info,chr(13),''),chr(10),'')  -- 返回信息
    ,replace(replace(t1.init_rg_cd,chr(13),''),chr(10),'')  -- 发起地区代码
    ,replace(replace(t1.recv_rg_cd,chr(13),''),chr(10),'')  -- 接收地区代码
    ,t1.entr_dt  -- 委托日期
    ,replace(replace(t1.mode_pay_cd,chr(13),''),chr(10),'')  -- 支付方式代码
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.tran_amt  -- 交易金额
    ,t1.comm_fee  -- 手续费
    ,t1.postage  -- 邮电费
    ,t1.todos  -- 工本费
    ,replace(replace(t1.origi_bank_no,chr(13),''),chr(10),'')  -- 发起行行号
    ,replace(replace(t1.pay_bank_no,chr(13),''),chr(10),'')  -- 付款行行号
    ,replace(replace(t1.payer_open_bank_no,chr(13),''),chr(10),'')  -- 付款人开户行行号
    ,replace(replace(t1.payer_acct_id,chr(13),''),chr(10),'')  -- 付款人账户编号
    ,replace(replace(t1.payer_name,chr(13),''),chr(10),'')  -- 付款人名称
    ,replace(replace(t1.payer_open_acct_org_id,chr(13),''),chr(10),'')  -- 付款人开户机构编号
    ,replace(replace(t1.recv_bank_no,chr(13),''),chr(10),'')  -- 收款行行号
    ,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'')  -- 收款人开户行行号
    ,replace(replace(t1.recver_acct_id,chr(13),''),chr(10),'')  -- 收款人账户编号
    ,replace(replace(t1.recver_name,chr(13),''),chr(10),'')  -- 收款人名称
    ,replace(replace(t1.bus_chn_cd,chr(13),''),chr(10),'')  -- 业务渠道代码
    ,replace(replace(t1.bank_no,chr(13),''),chr(10),'')  -- 经收处银行行号
    ,t1.bank_submit_dt  -- 银行提交日期
    ,replace(replace(t1.tax_bur_flow_num,chr(13),''),chr(10),'')  -- 税局流水号
    ,replace(replace(t1.org_cate_cd,chr(13),''),chr(10),'')  -- 机关类别代码
    ,replace(replace(t1.impose_org_id,chr(13),''),chr(10),'')  -- 征收机关编号
    ,t1.impose_org_submit_dt  -- 征收机关提交日期
    ,replace(replace(t1.impose_org_flow_num,chr(13),''),chr(10),'')  -- 征收机关流水号
    ,replace(replace(t1.recvbl_trea_id,chr(13),''),chr(10),'')  -- 收款国库编号
    ,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'')  -- 交易类型代码
    ,t1.impose_org_revs_dt  -- 征收机关冲正日期
    ,replace(replace(t1.impose_org_revs_flow_num,chr(13),''),chr(10),'')  -- 征收机关冲正流水号
    ,replace(replace(t1.taxpayer_id,chr(13),''),chr(10),'')  -- 纳税人编号
    ,replace(replace(t1.taxpayer_name,chr(13),''),chr(10),'')  -- 纳税人名称
    ,replace(replace(t1.decl_way_cd,chr(13),''),chr(10),'')  -- 申报方式代码
    ,replace(replace(t1.decl_flow_num,chr(13),''),chr(10),'')  -- 申报流水号
    ,replace(replace(t1.pay_way_cd,chr(13),''),chr(10),'')  -- 缴款方式代码
    ,t1.clear_dt  -- 清算日期
    ,replace(replace(t1.bus_org_id,chr(13),''),chr(10),'')  -- 营业机构编号
    ,replace(replace(t1.teller_id,chr(13),''),chr(10),'')  -- 柜员编号
    ,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'')  -- 授权柜员编号
    ,replace(replace(t1.auth_brac_id,chr(13),''),chr(10),'')  -- 授权网点编号
    ,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'')  -- 业务类型代码
    ,replace(replace(t1.refund_acct_id,chr(13),''),chr(10),'')  -- 退款账户编号
    ,replace(replace(t1.refund_acct_name,chr(13),''),chr(10),'')  -- 退款户账户名称
    ,replace(replace(t1.pay_ps_tel_num,chr(13),''),chr(10),'')  -- 缴款人电话号码
    ,replace(replace(t1.pay_ps_cert_type_cd,chr(13),''),chr(10),'')  -- 缴款人证件类型代码
    ,replace(replace(t1.pay_ps_cert_no,chr(13),''),chr(10),'')  -- 缴款人证件号码
    ,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'')  -- 凭证类型代码
    ,replace(replace(t1.vouch_id,chr(13),''),chr(10),'')  -- 凭证编号
    ,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'')  -- 交易渠道代码
    ,replace(replace(t1.chn_flow_num,chr(13),''),chr(10),'')  -- 渠道流水号
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from iml.v_evt_tax_pay_tran_flow t1    --财税缴费交易流水
where 1=1 ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_evt_tax_pay_tran_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);