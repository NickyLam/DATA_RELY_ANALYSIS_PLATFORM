/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbprdbankacc
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM ifms_tbprdbankacc_bak_${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ifms_tbprdbankacc');
  
  if v_var <> 0 then 
    execute immediate 'alter table ifms_tbprdbankacc drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ifms_tbprdbankacc add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ifms_tbprdbankacc(
            ta_code -- TA代码
            ,prd_code -- 产品代码
            ,bank_no -- 银行代码:租户编号(多租户模式用)
            ,open_bank_ver -- 验资户开户行
            ,open_bank_up -- 注册登记账户开户行
            ,bank_acc_up -- 上账银行账号
            ,bank_acc_down -- 下账银行账号
            ,bank_acc_ver -- 募集验资账户
            ,asso_code -- 关联代码:基金公司产品代码
            ,square_way -- 结算方式:[K_JSFS] 全额或净额
            ,bank_name -- 银行名称:托管银行名称
            ,branch_name -- 分支机构名称:托管机构名称
            ,prd_name -- 产品名称:外部产品名称
            ,bank_acc_up_name -- 上账银行账号名称
            ,bank_acc_down_name -- 下账银行账号名称
            ,bank_acc_ver_name -- 募集验资户账户名称
            ,reserve1 -- 保留字段1:募集验资账户支付系统编号(募集期)
            ,reserve2 -- 保留字段2:注册登记账户支付系统编号(申购期)
            ,debit_account -- 认申购账号
            ,crebit_account -- 赎回账号
            ,client_type -- 客户类型:K_KHLX 0-机构 1-个人
            ,realred_crebit_account -- 实时赎回垫资账号
            ,income_account -- 收益兑付账号
            ,pay_way -- 支付方式
            ,charge_account -- 手续费分配账号
            ,open_bank_down -- 兑付资金账户开户行
            ,open_bank_ver_name -- 验资户开户行名称
            ,open_bank_up_name -- 注册登记账户开户行名称
            ,open_bank_down_name -- 兑付资金账户开户行名称
            ,realred_crebit_account_name -- 实时赎回垫资账号名称:实时赎回垫资账号名称
            ,debit_account_name -- 认申购账号名称:认申购账号名称
            ,crebit_account_name -- 赎回账号名称:赎回账号名称
            ,income_account_name -- 收益兑付账号名称:收益兑付账号名称
            ,off_bal_account -- 表外账户:表外账户,记录表外账
            ,charge_account_name -- 手续费分配账号名称
            ,transfer_fee_acc -- 转让手续费账号:转让业务如收取转让手续时，需要将转让手续费转入此账号
            ,transfer_fee_acc_name -- 转让手续费账号名称
            ,service_fee_acc -- 服务费账号
            ,service_fee_acc_name -- 服务费账号名称
            ,out_bank_no -- 外部银行代码:归集账号的银行编号
            ,out_bank_name -- 转出/外部银行名称:归集账号的银行名称
            ,spno -- 联行号:归集账号的联行号
            ,debit_account_in_old -- 直销银行理财认申购归集账号(开立在传统核心系统)
            ,debit_account_in_new -- 直销银行理财认申购归集账号(开立在直销银行系统
            ,crebit_account_in_old -- 直销银行赎回账号(开立在传统核心系统)
            ,crebit_account_in_new -- 直销银行赎回账号(开立在直销银行系统)
            ,crebit_middle_account -- 赎回过渡账户
            ,crebit_middle_account_name -- 赎回过渡账户名称
            ,debit_middle_account -- 认申购过渡账号
            ,debit_middle_account_name -- 认申购过渡账户名称
            ,digital_wallet_bank -- 数字钱包开立机构
            ,advance_account -- 垫资账户
            ,advance_account_name -- 垫资账户名称
            ,draw_interacc -- 垫资中间账号
            ,draw_interacc_name -- 垫资中间户账户名称
            ,draw_interacc_bank_name -- 垫资中间户开户行名称
            ,draw_interacc_bank_organ -- 垫资中间户开户行机构编号
            ,failed_payment_account -- 入账失败挂账账户
            ,issuer_clear_bank_name -- 发行机构清算行名
            ,issuer_clear_account -- 发行机构认申购清算账号
            ,expense_account -- 费用账号
            ,pooling_account -- 行内归集账户
            ,pooling_account_name -- 行内归集账户名称
            ,suspend_account -- 挂账账号
            ,suspend_account_name -- 挂账账号名称
            ,suspend_acc_open_bank -- 挂账账号开户行
            ,suspend_acc_open_bank_cnaps -- 挂账账号开户行联行号
            ,suspend_out_bank_no -- 挂账账号银行编号
            ,failed_payment_account_name -- 入账失败挂账账户户名
            ,open_bank_realred_crebit -- 实时赎回垫资账号开户行
            ,open_bank_realred_crebit_name -- 实时赎回垫资账号开户行名称
            ,crebit_account_branch -- 赎回账号开户行号
            ,crebit_account_branch_name -- 赎回账号开户行名称
            ,debit_account_branch -- 认申购账号开户行号
            ,debit_account_branch_name -- 认申购账号开户行名称
            ,remit_mid_account -- 汇出待转户账户
            ,apply_middle_account -- 垫资请款过渡账户
            ,remit_mid_account_name -- 汇出待转户账户名称
            ,apply_middle_account_name -- 垫资请款过渡账户名称
            ,remit_mid_account_branch -- 汇出待转户账户开户行号
            ,remit_mid_account_branch_name -- 汇出待转户账户开户行名称
            ,apply_from_account -- 请款来账账号
            ,apply_from_account_name -- 请款来账账号名称
            ,refund_account -- 退款账号
            ,refund_account_name -- 退款账号名称
            ,bank_acc_down_sys_no -- 资金兑付账户支付系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            ta_code -- TA代码
            ,prd_code -- 产品代码
            ,bank_no -- 银行代码:租户编号(多租户模式用)
            ,open_bank_ver -- 验资户开户行
            ,open_bank_up -- 注册登记账户开户行
            ,bank_acc_up -- 上账银行账号
            ,bank_acc_down -- 下账银行账号
            ,bank_acc_ver -- 募集验资账户
            ,asso_code -- 关联代码:基金公司产品代码
            ,square_way -- 结算方式:[K_JSFS] 全额或净额
            ,bank_name -- 银行名称:托管银行名称
            ,branch_name -- 分支机构名称:托管机构名称
            ,prd_name -- 产品名称:外部产品名称
            ,bank_acc_up_name -- 上账银行账号名称
            ,bank_acc_down_name -- 下账银行账号名称
            ,bank_acc_ver_name -- 募集验资户账户名称
            ,reserve1 -- 保留字段1:募集验资账户支付系统编号(募集期)
            ,reserve2 -- 保留字段2:注册登记账户支付系统编号(申购期)
            ,debit_account -- 认申购账号
            ,crebit_account -- 赎回账号
            ,' ' as client_type -- 客户类型:K_KHLX 0-机构 1-个人
    ,' ' as realred_crebit_account -- 实时赎回垫资账号
    ,' ' as income_account -- 收益兑付账号
    ,' ' as pay_way -- 支付方式
    ,' ' as charge_account -- 手续费分配账号
    ,' ' as open_bank_down -- 兑付资金账户开户行
    ,' ' as open_bank_ver_name -- 验资户开户行名称
    ,' ' as open_bank_up_name -- 注册登记账户开户行名称
    ,' ' as open_bank_down_name -- 兑付资金账户开户行名称
    ,' ' as realred_crebit_account_name -- 实时赎回垫资账号名称:实时赎回垫资账号名称
    ,' ' as debit_account_name -- 认申购账号名称:认申购账号名称
    ,' ' as crebit_account_name -- 赎回账号名称:赎回账号名称
    ,' ' as income_account_name -- 收益兑付账号名称:收益兑付账号名称
    ,' ' as off_bal_account -- 表外账户:表外账户,记录表外账
    ,' ' as charge_account_name -- 手续费分配账号名称
    ,' ' as transfer_fee_acc -- 转让手续费账号:转让业务如收取转让手续时，需要将转让手续费转入此账号
    ,' ' as transfer_fee_acc_name -- 转让手续费账号名称
    ,' ' as service_fee_acc -- 服务费账号
    ,' ' as service_fee_acc_name -- 服务费账号名称
    ,' ' as out_bank_no -- 外部银行代码:归集账号的银行编号
    ,' ' as out_bank_name -- 转出/外部银行名称:归集账号的银行名称
    ,' ' as spno -- 联行号:归集账号的联行号
    ,' ' as debit_account_in_old -- 直销银行理财认申购归集账号(开立在传统核心系统)
    ,' ' as debit_account_in_new -- 直销银行理财认申购归集账号(开立在直销银行系统
    ,' ' as crebit_account_in_old -- 直销银行赎回账号(开立在传统核心系统)
    ,' ' as crebit_account_in_new -- 直销银行赎回账号(开立在直销银行系统)
    ,' ' as crebit_middle_account -- 赎回过渡账户
    ,' ' as crebit_middle_account_name -- 赎回过渡账户名称
    ,' ' as debit_middle_account -- 认申购过渡账号
    ,' ' as debit_middle_account_name -- 认申购过渡账户名称
    ,' ' as digital_wallet_bank -- 数字钱包开立机构
    ,' ' as advance_account -- 垫资账户
    ,' ' as advance_account_name -- 垫资账户名称
    ,' ' as draw_interacc -- 垫资中间账号
    ,' ' as draw_interacc_name -- 垫资中间户账户名称
    ,' ' as draw_interacc_bank_name -- 垫资中间户开户行名称
    ,' ' as draw_interacc_bank_organ -- 垫资中间户开户行机构编号
    ,' ' as failed_payment_account -- 入账失败挂账账户
    ,' ' as issuer_clear_bank_name -- 发行机构清算行名
    ,' ' as issuer_clear_account -- 发行机构认申购清算账号
    ,' ' as expense_account -- 费用账号
    ,' ' as pooling_account -- 行内归集账户
    ,' ' as pooling_account_name -- 行内归集账户名称
    ,' ' as suspend_account -- 挂账账号
    ,' ' as suspend_account_name -- 挂账账号名称
    ,' ' as suspend_acc_open_bank -- 挂账账号开户行
    ,' ' as suspend_acc_open_bank_cnaps -- 挂账账号开户行联行号
    ,' ' as suspend_out_bank_no -- 挂账账号银行编号
    ,' ' as failed_payment_account_name -- 入账失败挂账账户户名
    ,' ' as open_bank_realred_crebit -- 实时赎回垫资账号开户行
    ,' ' as open_bank_realred_crebit_name -- 实时赎回垫资账号开户行名称
    ,' ' as crebit_account_branch -- 赎回账号开户行号
    ,' ' as crebit_account_branch_name -- 赎回账号开户行名称
    ,' ' as debit_account_branch -- 认申购账号开户行号
    ,' ' as debit_account_branch_name -- 认申购账号开户行名称
    ,' ' as remit_mid_account -- 汇出待转户账户
    ,' ' as apply_middle_account -- 垫资请款过渡账户
    ,' ' as remit_mid_account_name -- 汇出待转户账户名称
    ,' ' as apply_middle_account_name -- 垫资请款过渡账户名称
    ,' ' as remit_mid_account_branch -- 汇出待转户账户开户行号
    ,' ' as remit_mid_account_branch_name -- 汇出待转户账户开户行名称
    ,' ' as apply_from_account -- 请款来账账号
    ,' ' as apply_from_account_name -- 请款来账账号名称
    ,' ' as refund_account -- 退款账号
    ,' ' as refund_account_name -- 退款账号名称
    ,' ' as bank_acc_down_sys_no -- 资金兑付账户支付系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ifms_tbprdbankacc_bak_${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
