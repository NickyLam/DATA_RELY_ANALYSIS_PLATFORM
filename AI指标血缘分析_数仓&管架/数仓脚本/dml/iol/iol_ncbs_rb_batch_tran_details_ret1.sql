/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_batch_tran_details_ret1
CreateDate: 20250210
*/

set timing on
-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;

declare
  v_flag   number(10) :=0;

begin
  for tb in (select partition_name,table_name,substr(partition_name,3) as etl_dt
               from user_tab_partitions
                   where table_name = upper('ncbs_rb_batch_tran_details_bak${batch_date}')
                       and partition_name <> 'P_19000101'
             ) loop

  select count(*) into v_flag
    from all_tab_partitions
   where table_owner = upper('iol')
     and table_name = upper('ncbs_rb_batch_tran_details')
     and partition_name = tb.partition_name;

  if v_flag <> 0 then
    execute immediate 'alter table ncbs_rb_batch_tran_details drop partition '|| tb.partition_name ;
  end if;

    execute immediate 'alter table ncbs_rb_batch_tran_details add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';


-- 回插所有数据

insert /*+ append */ into ${iol_schema}.ncbs_rb_batch_tran_details (
    acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,ccy -- 币种
    ,client_type -- 客户类型
    ,doc_type -- 凭证类型
    ,gl_code -- 科目代码
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,voucher_no -- 凭证号码
    ,acct_desc -- 账户描述
    ,batch_no -- 批次号
    ,batch_status -- 批次处理状态
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,error_code -- 错误码
    ,error_desc -- 错误描述
    ,fh_seq_no -- 资金冻结流水号
    ,job_run_id -- 批处理任务id
    ,narrative -- 摘要
    ,oth_acct_desc -- 对方账户描述
    ,oth_gl_code -- 对方科目代码
    ,oth_seq_no -- 对方交易流水号
    ,oth_tran_type -- 对方交易类型
    ,prefix -- 前缀
    ,ret_msg -- 服务状态描述
    ,seq_no -- 序号
    ,serv_charge -- 服务费标识
    ,source_type -- 渠道编号
    ,tran_desc -- 交易描述
    ,tran_note -- 交易附言
    ,channel -- 渠道
    ,settlement_date -- 清算日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,oth_acct_ccy -- 对方账户币种
    ,oth_acct_seq_no -- 对方账户序列号
    ,oth_bank_code -- 对方银行代码
    ,oth_bank_name -- 对方银行名称
    ,oth_base_acct_no -- 对方账号/卡号
    ,oth_branch -- 对方账户开户机构
    ,oth_prod_type -- 对方账户产品类型
    ,oth_reference -- 对方交易参考号
    ,oth_tran_name -- 交易对手名称
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,remark3 -- 备注3
    ,remark4 -- 备注5
    ,remark5 -- 备注6
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,narrative_code -- 摘要码
    ,oth_real_bank_code -- 真实对方金融机构代码
    ,oth_real_bank_name -- 真实对方金融机构名称
    ,oth_real_base_acct_no -- 真实交易对手账号
    ,oth_real_document_id -- 真实交易对手证件号码
    ,oth_real_document_type -- 真实交易对手证件类型
    ,oth_real_prod_type -- 真实交易对手账户产品类型
    ,oth_real_tran_addr -- 真实交易发生地
    ,oth_real_tran_name -- 真实交易对手名称
    ,med_ins_tran_flag -- 医保账户交易标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_seq_no as acct_seq_no -- 账户子账号
    ,base_acct_no as base_acct_no -- 交易账号/卡号
    ,ccy as ccy -- 币种
    ,client_type as client_type -- 客户类型
    ,doc_type as doc_type -- 凭证类型
    ,gl_code as gl_code -- 科目代码
    ,prod_type as prod_type -- 产品编号
    ,reference as reference -- 交易参考号
    ,tran_type as tran_type -- 交易类型
    ,user_id as user_id -- 交易柜员编号
    ,voucher_no as voucher_no -- 凭证号码
    ,acct_desc as acct_desc -- 账户描述
    ,batch_no as batch_no -- 批次号
    ,batch_status as batch_status -- 批次处理状态
    ,channel_seq_no as channel_seq_no -- 全局流水号
    ,company as company -- 法人
    ,error_code as error_code -- 错误码
    ,error_desc as error_desc -- 错误描述
    ,fh_seq_no as fh_seq_no -- 资金冻结流水号
    ,job_run_id as job_run_id -- 批处理任务id
    ,narrative as narrative -- 摘要
    ,oth_acct_desc as oth_acct_desc -- 对方账户描述
    ,oth_gl_code as oth_gl_code -- 对方科目代码
    ,oth_seq_no as oth_seq_no -- 对方交易流水号
    ,oth_tran_type as oth_tran_type -- 对方交易类型
    ,prefix as prefix -- 前缀
    ,ret_msg as ret_msg -- 服务状态描述
    ,seq_no as seq_no -- 序号
    ,serv_charge as serv_charge -- 服务费标识
    ,source_type as source_type -- 渠道编号
    ,tran_desc as tran_desc -- 交易描述
    ,tran_note as tran_note -- 交易附言
    ,channel as channel -- 渠道
    ,settlement_date as settlement_date -- 清算日期
    ,tran_date as tran_date -- 交易日期
    ,tran_timestamp as tran_timestamp -- 交易时间戳
    ,acct_branch as acct_branch -- 开户机构编号
    ,acct_ccy as acct_ccy -- 账户币种
    ,oth_acct_ccy as oth_acct_ccy -- 对方账户币种
    ,oth_acct_seq_no as oth_acct_seq_no -- 对方账户序列号
    ,oth_bank_code as oth_bank_code -- 对方银行代码
    ,oth_bank_name as oth_bank_name -- 对方银行名称
    ,oth_base_acct_no as oth_base_acct_no -- 对方账号/卡号
    ,oth_branch as oth_branch -- 对方账户开户机构
    ,oth_prod_type as oth_prod_type -- 对方账户产品类型
    ,oth_reference as oth_reference -- 对方交易参考号
    ,oth_tran_name as oth_tran_name -- 交易对手名称
    ,remark1 as remark1 -- 备注1
    ,remark2 as remark2 -- 备注2
    ,remark3 as remark3 -- 备注3
    ,remark4 as remark4 -- 备注5
    ,remark5 as remark5 -- 备注6
    ,tran_amt as tran_amt -- 交易金额
    ,tran_branch as tran_branch -- 核心交易机构编号
    ,narrative_code as narrative_code -- 摘要码
    ,oth_real_bank_code as oth_real_bank_code -- 真实对方金融机构代码
    ,oth_real_bank_name as oth_real_bank_name -- 真实对方金融机构名称
    ,oth_real_base_acct_no as oth_real_base_acct_no -- 真实交易对手账号
    ,oth_real_document_id as oth_real_document_id -- 真实交易对手证件号码
    ,oth_real_document_type as oth_real_document_type -- 真实交易对手证件类型
    ,oth_real_prod_type as oth_real_prod_type -- 真实交易对手账户产品类型
    ,oth_real_tran_addr as oth_real_tran_addr -- 真实交易发生地
    ,oth_real_tran_name as oth_real_tran_name -- 真实交易对手名称
    ,' ' as med_ins_tran_flag -- 医保账户交易标志
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_batch_tran_details_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;

end loop;
end;
/

