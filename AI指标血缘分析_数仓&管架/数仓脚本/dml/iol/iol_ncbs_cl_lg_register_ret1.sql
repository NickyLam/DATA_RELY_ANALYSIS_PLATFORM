/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_lg_register
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
                       FROM ncbs_cl_lg_register_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_cl_lg_register');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_cl_lg_register drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_cl_lg_register add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.ncbs_cl_lg_register(
            ccy -- 币种
            ,client_no -- 客户编号
            ,contract_no -- 合同编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,remark -- 备注
            ,user_id -- 交易柜员编号
            ,acct_exec -- 银行客户经理编号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,compensate_status -- 保函赔付状态
            ,lg_no -- 保函编号
            ,lg_status -- 保函状态
            ,terminal_id -- 交易终端编号
            ,last_change_date -- 最后修改日期
            ,lg_end_date -- 保函终止日期
            ,lg_start_date -- 保函起始日期
            ,new_lg_end_date -- 新保函终止日期
            ,tran_timestamp -- 交易时间戳
            ,advanced_acct_no -- 垫款贷款账号
            ,advanced_amt -- 保函垫款金额
            ,apply_client_no -- 申请者客户号
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,back_acct_ccy -- 备款账号币种
            ,back_acct_no -- 备款入账账号
            ,back_acct_seq_no -- 备款账户序列号
            ,back_prod_type -- 备款账号产品类型
            ,beneficiary_acct_no -- 保函受益人账号
            ,beneficiary_address -- 受益人住址
            ,beneficiary_document_id -- 受益人证件号
            ,beneficiary_document_type -- 受益人证件类型
            ,beneficiary_name -- 受益人名称
            ,collat_value -- 押品账面价值
            ,contract_ccy -- 保函合同币种
            ,counterparty_branch -- 反担机构
            ,lg_amt -- 保函金额
            ,lg_branch -- 担保机构
            ,lg_compensate_balance -- 剩余赔付金额
            ,mortgage_contract_no -- 抵押合同编号
            ,open_branch -- 开立机构
            ,org_restraint_amt -- 保函原始冻结金额
            ,orig_loan_amt -- 贷款签约合同金额
            ,pri_plty_abs -- 垫款固定罚息利率
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_no -- 人行清算账户
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_prod_type -- 结算账户产品类型
            ,tran_branch -- 核心交易机构编号
            ,beneficiary_is_inner -- 受益人账号是否本行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            ccy -- 币种
            ,client_no -- 客户编号
            ,contract_no -- 合同编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,remark -- 备注
            ,user_id -- 交易柜员编号
            ,acct_exec -- 银行客户经理编号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,compensate_status -- 保函赔付状态
            ,lg_no -- 保函编号
            ,lg_status -- 保函状态
            ,terminal_id -- 交易终端编号
            ,last_change_date -- 最后修改日期
            ,lg_end_date -- 保函终止日期
            ,lg_start_date -- 保函起始日期
            ,new_lg_end_date -- 新保函终止日期
            ,tran_timestamp -- 交易时间戳
            ,advanced_acct_no -- 垫款贷款账号
            ,advanced_amt -- 保函垫款金额
            ,apply_client_no -- 申请者客户号
            ,appr_user_id -- 复核柜员
            ,auth_user_id -- 授权柜员
            ,back_acct_ccy -- 备款账号币种
            ,back_acct_no -- 备款入账账号
            ,back_acct_seq_no -- 备款账户序列号
            ,back_prod_type -- 备款账号产品类型
            ,beneficiary_acct_no -- 保函受益人账号
            ,beneficiary_address -- 受益人住址
            ,beneficiary_document_id -- 受益人证件号
            ,beneficiary_document_type -- 受益人证件类型
            ,beneficiary_name -- 受益人名称
            ,collat_value -- 押品账面价值
            ,contract_ccy -- 保函合同币种
            ,counterparty_branch -- 反担机构
            ,lg_amt -- 保函金额
            ,lg_branch -- 担保机构
            ,lg_compensate_balance -- 剩余赔付金额
            ,mortgage_contract_no -- 抵押合同编号
            ,open_branch -- 开立机构
            ,org_restraint_amt -- 保函原始冻结金额
            ,orig_loan_amt -- 贷款签约合同金额
            ,pri_plty_abs -- 垫款固定罚息利率
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_no -- 人行清算账户
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_prod_type -- 结算账户产品类型
            ,tran_branch -- 核心交易机构编号
            ,' ' as beneficiary_is_inner -- 受益人账号是否本行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_lg_register_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
