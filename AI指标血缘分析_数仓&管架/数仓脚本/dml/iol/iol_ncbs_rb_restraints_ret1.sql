/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_restraints_ret1
CreateDate: 20250618
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
                       FROM ncbs_rb_restraints_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('ncbs_rb_restraints');

  if v_var <> 0 then
    execute immediate 'alter table ncbs_rb_restraints drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table ncbs_rb_restraints add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.ncbs_rb_restraints (
    client_no -- 客户编号
    ,doc_type -- 凭证类型
    ,internal_key -- 账户内部键值
    ,reference -- 交易参考号
    ,restraint_type -- 限制类型
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,term -- 存期
    ,term_type -- 期限单位
    ,appr_flag -- 复核标志
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,deduction_law_no -- 扣划法律文书号
    ,full_freeze_ind -- 全额冻结标志
    ,help_option -- 协助执行事项
    ,interrupt_flag -- 是否中断
    ,is_frozen -- 是否续冻
    ,maintain_type -- 维护方式
    ,msg_bank -- 银行信息
    ,msg_client -- 客户信息
    ,narrative -- 摘要
    ,no_of_payment -- 总支付笔数
    ,oth_acct_desc -- 对方账户描述
    ,payment_made -- 已支付笔数
    ,prefix -- 前缀
    ,program_id -- 交易代码
    ,release_law_no -- 解冻机关法律文书号
    ,res_acct_range -- 限制账户范围
    ,res_law_no -- 冻结机关法律文书号
    ,res_priority -- 冻结级别
    ,res_seq_no -- 限制编号
    ,restraint_judiciary_name -- 冻结机关名称
    ,restraints_status -- 限制状态
    ,source_module -- 源模块
    ,spec_code -- 指定他行信息
    ,start_cheque_no -- 起始支票号码
    ,stl_seq_no -- 结算流水号
    ,sub_restraint_class -- 子限制类别
    ,thaw_officer_name -- 经办人1姓名
    ,thaw_oth_officer_name -- 经办人2姓名
    ,under_lien -- 是否抵制押标志
    ,wait_seq -- 轮候冻结序号
    ,approval_date -- 复核日期
    ,channel_date -- 渠道日期
    ,end_date -- 结束日期
    ,last_change_date -- 最后修改日期
    ,start_date -- 开始日期
    ,tran_timestamp -- 交易时间戳
    ,appr_user_id -- 复核柜员
    ,auth_user_id -- 授权柜员
    ,deduction_judiciary_name -- 有权机关名称
    ,end_amt -- 截止金额
    ,end_cheque_no -- 终止支票号码
    ,judiciary_document_id -- 执法人1证件号码
    ,judiciary_document_id2 -- 执法人1证件号码2
    ,judiciary_document_type -- 执法人1证件类型
    ,judiciary_document_type2 -- 执法人1证件类型2
    ,judiciary_officer_name -- 执法人1姓名
    ,judiciary_oth_document_id -- 执法人2证件号码
    ,judiciary_oth_document_id2 -- 执法人2证件号码2
    ,judiciary_oth_document_type -- 执法人2证件类型
    ,judiciary_oth_document_type2 -- 执法人2证件类型2
    ,judiciary_oth_officer_name -- 执法人2姓名
    ,last_change_user_id -- 最后修改柜员
    ,oth_acct_ccy -- 对方账户币种
    ,oth_acct_no -- 对方账号
    ,oth_bank_code -- 对方银行代码
    ,oth_base_acct_no -- 对方账号/卡号
    ,oth_prod_type -- 对方账户产品类型
    ,paid_amt -- 已还金额
    ,pledged_acct_ccy -- 抵押账户币种
    ,pledged_acct_no -- 抵押账号
    ,pledged_acct_type -- 抵押账户类型
    ,pledged_amt -- 限制金额
    ,pledged_base_acct_no -- 抵押主账号
    ,real_restraint_amt -- 可扣划金额
    ,release_judiciary_name -- 解冻机关名称
    ,start_amt -- 起始金额
    ,thaw_document_id -- 经办人1证件号码
    ,thaw_document_id2 -- 经办人1证件号码2
    ,thaw_document_type -- 经办人1证件类型1
    ,thaw_oth_document_id -- 经办人2证件号码
    ,thaw_oth_document_id2 -- 经办人2证件号码2
    ,thaw_oth_document_type -- 经办人2证件类型
    ,thaw_oth_document_type2 -- 经办人2证件类型2
    ,to_pay_amt -- 支付金额
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,thaw_document_type2 -- 经办人1证件类型2
    ,reaccount_cd -- 对账代码
    ,reserve -- 冲正标识|冲正标识|Y-冲正数据 N-非冲正数据'
    ,deduction_law_type -- 扣划法律文书类型
    ,out_sign_user_id -- 解约柜员
    ,unlost_time -- 解挂时间
    ,sign_channel -- 签约渠道|签约渠道
    ,sign_user_id -- 签约柜员|签约柜员
    ,court_code -- 执行机关码值
    ,actual_pld_amount -- 实际控制金额|司法扣划实际控制金额
    ,oper_narrative -- 操作备注
    ,start_timestamp -- 加限的交易时间戳
    ,actual_effect_time -- 实际生效时间
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    client_no as client_no -- 客户编号
    ,doc_type as doc_type -- 凭证类型
    ,internal_key as internal_key -- 账户内部键值
    ,reference as reference -- 交易参考号
    ,restraint_type as restraint_type -- 限制类型
    ,tran_type as tran_type -- 交易类型
    ,user_id as user_id -- 交易柜员编号
    ,term as term -- 存期
    ,term_type as term_type -- 期限单位
    ,appr_flag as appr_flag -- 复核标志
    ,channel_seq_no as channel_seq_no -- 全局流水号
    ,company as company -- 法人
    ,deduction_law_no as deduction_law_no -- 扣划法律文书号
    ,full_freeze_ind as full_freeze_ind -- 全额冻结标志
    ,help_option as help_option -- 协助执行事项
    ,interrupt_flag as interrupt_flag -- 是否中断
    ,is_frozen as is_frozen -- 是否续冻
    ,maintain_type as maintain_type -- 维护方式
    ,msg_bank as msg_bank -- 银行信息
    ,msg_client as msg_client -- 客户信息
    ,narrative as narrative -- 摘要
    ,no_of_payment as no_of_payment -- 总支付笔数
    ,oth_acct_desc as oth_acct_desc -- 对方账户描述
    ,payment_made as payment_made -- 已支付笔数
    ,prefix as prefix -- 前缀
    ,program_id as program_id -- 交易代码
    ,release_law_no as release_law_no -- 解冻机关法律文书号
    ,res_acct_range as res_acct_range -- 限制账户范围
    ,res_law_no as res_law_no -- 冻结机关法律文书号
    ,res_priority as res_priority -- 冻结级别
    ,res_seq_no as res_seq_no -- 限制编号
    ,restraint_judiciary_name as restraint_judiciary_name -- 冻结机关名称
    ,restraints_status as restraints_status -- 限制状态
    ,source_module as source_module -- 源模块
    ,spec_code as spec_code -- 指定他行信息
    ,start_cheque_no as start_cheque_no -- 起始支票号码
    ,stl_seq_no as stl_seq_no -- 结算流水号
    ,sub_restraint_class as sub_restraint_class -- 子限制类别
    ,thaw_officer_name as thaw_officer_name -- 经办人1姓名
    ,thaw_oth_officer_name as thaw_oth_officer_name -- 经办人2姓名
    ,under_lien as under_lien -- 是否抵制押标志
    ,wait_seq as wait_seq -- 轮候冻结序号
    ,approval_date as approval_date -- 复核日期
    ,channel_date as channel_date -- 渠道日期
    ,end_date as end_date -- 结束日期
    ,last_change_date as last_change_date -- 最后修改日期
    ,start_date as start_date -- 开始日期
    ,tran_timestamp as tran_timestamp -- 交易时间戳
    ,appr_user_id as appr_user_id -- 复核柜员
    ,auth_user_id as auth_user_id -- 授权柜员
    ,deduction_judiciary_name as deduction_judiciary_name -- 有权机关名称
    ,end_amt as end_amt -- 截止金额
    ,end_cheque_no as end_cheque_no -- 终止支票号码
    ,judiciary_document_id as judiciary_document_id -- 执法人1证件号码
    ,judiciary_document_id2 as judiciary_document_id2 -- 执法人1证件号码2
    ,judiciary_document_type as judiciary_document_type -- 执法人1证件类型
    ,judiciary_document_type2 as judiciary_document_type2 -- 执法人1证件类型2
    ,judiciary_officer_name as judiciary_officer_name -- 执法人1姓名
    ,judiciary_oth_document_id as judiciary_oth_document_id -- 执法人2证件号码
    ,judiciary_oth_document_id2 as judiciary_oth_document_id2 -- 执法人2证件号码2
    ,judiciary_oth_document_type as judiciary_oth_document_type -- 执法人2证件类型
    ,judiciary_oth_document_type2 as judiciary_oth_document_type2 -- 执法人2证件类型2
    ,judiciary_oth_officer_name as judiciary_oth_officer_name -- 执法人2姓名
    ,last_change_user_id as last_change_user_id -- 最后修改柜员
    ,oth_acct_ccy as oth_acct_ccy -- 对方账户币种
    ,oth_acct_no as oth_acct_no -- 对方账号
    ,oth_bank_code as oth_bank_code -- 对方银行代码
    ,oth_base_acct_no as oth_base_acct_no -- 对方账号/卡号
    ,oth_prod_type as oth_prod_type -- 对方账户产品类型
    ,paid_amt as paid_amt -- 已还金额
    ,pledged_acct_ccy as pledged_acct_ccy -- 抵押账户币种
    ,pledged_acct_no as pledged_acct_no -- 抵押账号
    ,pledged_acct_type as pledged_acct_type -- 抵押账户类型
    ,pledged_amt as pledged_amt -- 限制金额
    ,pledged_base_acct_no as pledged_base_acct_no -- 抵押主账号
    ,real_restraint_amt as real_restraint_amt -- 可扣划金额
    ,release_judiciary_name as release_judiciary_name -- 解冻机关名称
    ,start_amt as start_amt -- 起始金额
    ,thaw_document_id as thaw_document_id -- 经办人1证件号码
    ,thaw_document_id2 as thaw_document_id2 -- 经办人1证件号码2
    ,thaw_document_type as thaw_document_type -- 经办人1证件类型1
    ,thaw_oth_document_id as thaw_oth_document_id -- 经办人2证件号码
    ,thaw_oth_document_id2 as thaw_oth_document_id2 -- 经办人2证件号码2
    ,thaw_oth_document_type as thaw_oth_document_type -- 经办人2证件类型
    ,thaw_oth_document_type2 as thaw_oth_document_type2 -- 经办人2证件类型2
    ,to_pay_amt as to_pay_amt -- 支付金额
    ,tran_amt as tran_amt -- 交易金额
    ,tran_branch as tran_branch -- 核心交易机构编号
    ,thaw_document_type2 as thaw_document_type2 -- 经办人1证件类型2
    ,reaccount_cd as reaccount_cd -- 对账代码
    ,reserve as reserve -- 冲正标识|冲正标识|Y-冲正数据 N-非冲正数据'
    ,deduction_law_type as deduction_law_type -- 扣划法律文书类型
    ,out_sign_user_id as out_sign_user_id -- 解约柜员
    ,unlost_time as unlost_time -- 解挂时间
    ,sign_channel as sign_channel -- 签约渠道|签约渠道
    ,sign_user_id as sign_user_id -- 签约柜员|签约柜员
    ,court_code as court_code -- 执行机关码值
    ,actual_pld_amount as actual_pld_amount -- 实际控制金额|司法扣划实际控制金额
    ,' ' as oper_narrative -- 操作备注
    ,' ' as start_timestamp -- 加限的交易时间戳
    ,' ' as actual_effect_time -- 实际生效时间
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_restraints_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

