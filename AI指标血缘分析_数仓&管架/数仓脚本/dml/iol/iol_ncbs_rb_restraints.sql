/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_restraints
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ncbs_rb_restraints_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_restraints
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_restraints_op purge;
drop table ${iol_schema}.ncbs_rb_restraints_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_restraints_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_restraints where 0=1;

create table ${iol_schema}.ncbs_rb_restraints_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_restraints where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_restraints_cl(
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
            ,reserve -- 冲正标识|冲正标识|Y-冲正数据 N-非冲正数据"
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
    else
        into ${iol_schema}.ncbs_rb_restraints_op(
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
            ,reserve -- 冲正标识|冲正标识|Y-冲正数据 N-非冲正数据"
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
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.doc_type, o.doc_type) as doc_type -- 凭证类型
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.restraint_type, o.restraint_type) as restraint_type -- 限制类型
    ,nvl(n.tran_type, o.tran_type) as tran_type -- 交易类型
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.term, o.term) as term -- 存期
    ,nvl(n.term_type, o.term_type) as term_type -- 期限单位
    ,nvl(n.appr_flag, o.appr_flag) as appr_flag -- 复核标志
    ,nvl(n.channel_seq_no, o.channel_seq_no) as channel_seq_no -- 全局流水号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.deduction_law_no, o.deduction_law_no) as deduction_law_no -- 扣划法律文书号
    ,nvl(n.full_freeze_ind, o.full_freeze_ind) as full_freeze_ind -- 全额冻结标志
    ,nvl(n.help_option, o.help_option) as help_option -- 协助执行事项
    ,nvl(n.interrupt_flag, o.interrupt_flag) as interrupt_flag -- 是否中断
    ,nvl(n.is_frozen, o.is_frozen) as is_frozen -- 是否续冻
    ,nvl(n.maintain_type, o.maintain_type) as maintain_type -- 维护方式
    ,nvl(n.msg_bank, o.msg_bank) as msg_bank -- 银行信息
    ,nvl(n.msg_client, o.msg_client) as msg_client -- 客户信息
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.no_of_payment, o.no_of_payment) as no_of_payment -- 总支付笔数
    ,nvl(n.oth_acct_desc, o.oth_acct_desc) as oth_acct_desc -- 对方账户描述
    ,nvl(n.payment_made, o.payment_made) as payment_made -- 已支付笔数
    ,nvl(n.prefix, o.prefix) as prefix -- 前缀
    ,nvl(n.program_id, o.program_id) as program_id -- 交易代码
    ,nvl(n.release_law_no, o.release_law_no) as release_law_no -- 解冻机关法律文书号
    ,nvl(n.res_acct_range, o.res_acct_range) as res_acct_range -- 限制账户范围
    ,nvl(n.res_law_no, o.res_law_no) as res_law_no -- 冻结机关法律文书号
    ,nvl(n.res_priority, o.res_priority) as res_priority -- 冻结级别
    ,nvl(n.res_seq_no, o.res_seq_no) as res_seq_no -- 限制编号
    ,nvl(n.restraint_judiciary_name, o.restraint_judiciary_name) as restraint_judiciary_name -- 冻结机关名称
    ,nvl(n.restraints_status, o.restraints_status) as restraints_status -- 限制状态
    ,nvl(n.source_module, o.source_module) as source_module -- 源模块
    ,nvl(n.spec_code, o.spec_code) as spec_code -- 指定他行信息
    ,nvl(n.start_cheque_no, o.start_cheque_no) as start_cheque_no -- 起始支票号码
    ,nvl(n.stl_seq_no, o.stl_seq_no) as stl_seq_no -- 结算流水号
    ,nvl(n.sub_restraint_class, o.sub_restraint_class) as sub_restraint_class -- 子限制类别
    ,nvl(n.thaw_officer_name, o.thaw_officer_name) as thaw_officer_name -- 经办人1姓名
    ,nvl(n.thaw_oth_officer_name, o.thaw_oth_officer_name) as thaw_oth_officer_name -- 经办人2姓名
    ,nvl(n.under_lien, o.under_lien) as under_lien -- 是否抵制押标志
    ,nvl(n.wait_seq, o.wait_seq) as wait_seq -- 轮候冻结序号
    ,nvl(n.approval_date, o.approval_date) as approval_date -- 复核日期
    ,nvl(n.channel_date, o.channel_date) as channel_date -- 渠道日期
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.appr_user_id, o.appr_user_id) as appr_user_id -- 复核柜员
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.deduction_judiciary_name, o.deduction_judiciary_name) as deduction_judiciary_name -- 有权机关名称
    ,nvl(n.end_amt, o.end_amt) as end_amt -- 截止金额
    ,nvl(n.end_cheque_no, o.end_cheque_no) as end_cheque_no -- 终止支票号码
    ,nvl(n.judiciary_document_id, o.judiciary_document_id) as judiciary_document_id -- 执法人1证件号码
    ,nvl(n.judiciary_document_id2, o.judiciary_document_id2) as judiciary_document_id2 -- 执法人1证件号码2
    ,nvl(n.judiciary_document_type, o.judiciary_document_type) as judiciary_document_type -- 执法人1证件类型
    ,nvl(n.judiciary_document_type2, o.judiciary_document_type2) as judiciary_document_type2 -- 执法人1证件类型2
    ,nvl(n.judiciary_officer_name, o.judiciary_officer_name) as judiciary_officer_name -- 执法人1姓名
    ,nvl(n.judiciary_oth_document_id, o.judiciary_oth_document_id) as judiciary_oth_document_id -- 执法人2证件号码
    ,nvl(n.judiciary_oth_document_id2, o.judiciary_oth_document_id2) as judiciary_oth_document_id2 -- 执法人2证件号码2
    ,nvl(n.judiciary_oth_document_type, o.judiciary_oth_document_type) as judiciary_oth_document_type -- 执法人2证件类型
    ,nvl(n.judiciary_oth_document_type2, o.judiciary_oth_document_type2) as judiciary_oth_document_type2 -- 执法人2证件类型2
    ,nvl(n.judiciary_oth_officer_name, o.judiciary_oth_officer_name) as judiciary_oth_officer_name -- 执法人2姓名
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.oth_acct_ccy, o.oth_acct_ccy) as oth_acct_ccy -- 对方账户币种
    ,nvl(n.oth_acct_no, o.oth_acct_no) as oth_acct_no -- 对方账号
    ,nvl(n.oth_bank_code, o.oth_bank_code) as oth_bank_code -- 对方银行代码
    ,nvl(n.oth_base_acct_no, o.oth_base_acct_no) as oth_base_acct_no -- 对方账号/卡号
    ,nvl(n.oth_prod_type, o.oth_prod_type) as oth_prod_type -- 对方账户产品类型
    ,nvl(n.paid_amt, o.paid_amt) as paid_amt -- 已还金额
    ,nvl(n.pledged_acct_ccy, o.pledged_acct_ccy) as pledged_acct_ccy -- 抵押账户币种
    ,nvl(n.pledged_acct_no, o.pledged_acct_no) as pledged_acct_no -- 抵押账号
    ,nvl(n.pledged_acct_type, o.pledged_acct_type) as pledged_acct_type -- 抵押账户类型
    ,nvl(n.pledged_amt, o.pledged_amt) as pledged_amt -- 限制金额
    ,nvl(n.pledged_base_acct_no, o.pledged_base_acct_no) as pledged_base_acct_no -- 抵押主账号
    ,nvl(n.real_restraint_amt, o.real_restraint_amt) as real_restraint_amt -- 可扣划金额
    ,nvl(n.release_judiciary_name, o.release_judiciary_name) as release_judiciary_name -- 解冻机关名称
    ,nvl(n.start_amt, o.start_amt) as start_amt -- 起始金额
    ,nvl(n.thaw_document_id, o.thaw_document_id) as thaw_document_id -- 经办人1证件号码
    ,nvl(n.thaw_document_id2, o.thaw_document_id2) as thaw_document_id2 -- 经办人1证件号码2
    ,nvl(n.thaw_document_type, o.thaw_document_type) as thaw_document_type -- 经办人1证件类型1
    ,nvl(n.thaw_oth_document_id, o.thaw_oth_document_id) as thaw_oth_document_id -- 经办人2证件号码
    ,nvl(n.thaw_oth_document_id2, o.thaw_oth_document_id2) as thaw_oth_document_id2 -- 经办人2证件号码2
    ,nvl(n.thaw_oth_document_type, o.thaw_oth_document_type) as thaw_oth_document_type -- 经办人2证件类型
    ,nvl(n.thaw_oth_document_type2, o.thaw_oth_document_type2) as thaw_oth_document_type2 -- 经办人2证件类型2
    ,nvl(n.to_pay_amt, o.to_pay_amt) as to_pay_amt -- 支付金额
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.thaw_document_type2, o.thaw_document_type2) as thaw_document_type2 -- 经办人1证件类型2
    ,nvl(n.reaccount_cd, o.reaccount_cd) as reaccount_cd -- 对账代码
    ,nvl(n.reserve, o.reserve) as reserve -- 冲正标识|冲正标识|Y-冲正数据 N-非冲正数据"
    ,nvl(n.deduction_law_type, o.deduction_law_type) as deduction_law_type -- 扣划法律文书类型
    ,nvl(n.out_sign_user_id, o.out_sign_user_id) as out_sign_user_id -- 解约柜员
    ,nvl(n.unlost_time, o.unlost_time) as unlost_time -- 解挂时间
    ,nvl(n.sign_channel, o.sign_channel) as sign_channel -- 签约渠道|签约渠道
    ,nvl(n.sign_user_id, o.sign_user_id) as sign_user_id -- 签约柜员|签约柜员
    ,nvl(n.court_code, o.court_code) as court_code -- 执行机关码值
    ,nvl(n.actual_pld_amount, o.actual_pld_amount) as actual_pld_amount -- 实际控制金额|司法扣划实际控制金额
    ,nvl(n.oper_narrative, o.oper_narrative) as oper_narrative -- 操作备注
    ,nvl(n.start_timestamp, o.start_timestamp) as start_timestamp -- 加限的交易时间戳
    ,nvl(n.actual_effect_time, o.actual_effect_time) as actual_effect_time -- 实际生效时间
    ,case when
            n.client_no is null
            and n.internal_key is null
            and n.restraint_type is null
            and n.res_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.client_no is null
            and n.internal_key is null
            and n.restraint_type is null
            and n.res_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.client_no is null
            and n.internal_key is null
            and n.restraint_type is null
            and n.res_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_restraints_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_restraints where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.client_no = n.client_no
            and o.internal_key = n.internal_key
            and o.restraint_type = n.restraint_type
            and o.res_seq_no = n.res_seq_no
where (
        o.client_no is null
        and o.internal_key is null
        and o.restraint_type is null
        and o.res_seq_no is null
    )
    or (
        n.client_no is null
        and n.internal_key is null
        and n.restraint_type is null
        and n.res_seq_no is null
    )
    or (
        o.doc_type <> n.doc_type
        or o.reference <> n.reference
        or o.tran_type <> n.tran_type
        or o.user_id <> n.user_id
        or o.term <> n.term
        or o.term_type <> n.term_type
        or o.appr_flag <> n.appr_flag
        or o.channel_seq_no <> n.channel_seq_no
        or o.company <> n.company
        or o.deduction_law_no <> n.deduction_law_no
        or o.full_freeze_ind <> n.full_freeze_ind
        or o.help_option <> n.help_option
        or o.interrupt_flag <> n.interrupt_flag
        or o.is_frozen <> n.is_frozen
        or o.maintain_type <> n.maintain_type
        or o.msg_bank <> n.msg_bank
        or o.msg_client <> n.msg_client
        or o.narrative <> n.narrative
        or o.no_of_payment <> n.no_of_payment
        or o.oth_acct_desc <> n.oth_acct_desc
        or o.payment_made <> n.payment_made
        or o.prefix <> n.prefix
        or o.program_id <> n.program_id
        or o.release_law_no <> n.release_law_no
        or o.res_acct_range <> n.res_acct_range
        or o.res_law_no <> n.res_law_no
        or o.res_priority <> n.res_priority
        or o.restraint_judiciary_name <> n.restraint_judiciary_name
        or o.restraints_status <> n.restraints_status
        or o.source_module <> n.source_module
        or o.spec_code <> n.spec_code
        or o.start_cheque_no <> n.start_cheque_no
        or o.stl_seq_no <> n.stl_seq_no
        or o.sub_restraint_class <> n.sub_restraint_class
        or o.thaw_officer_name <> n.thaw_officer_name
        or o.thaw_oth_officer_name <> n.thaw_oth_officer_name
        or o.under_lien <> n.under_lien
        or o.wait_seq <> n.wait_seq
        or o.approval_date <> n.approval_date
        or o.channel_date <> n.channel_date
        or o.end_date <> n.end_date
        or o.last_change_date <> n.last_change_date
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.appr_user_id <> n.appr_user_id
        or o.auth_user_id <> n.auth_user_id
        or o.deduction_judiciary_name <> n.deduction_judiciary_name
        or o.end_amt <> n.end_amt
        or o.end_cheque_no <> n.end_cheque_no
        or o.judiciary_document_id <> n.judiciary_document_id
        or o.judiciary_document_id2 <> n.judiciary_document_id2
        or o.judiciary_document_type <> n.judiciary_document_type
        or o.judiciary_document_type2 <> n.judiciary_document_type2
        or o.judiciary_officer_name <> n.judiciary_officer_name
        or o.judiciary_oth_document_id <> n.judiciary_oth_document_id
        or o.judiciary_oth_document_id2 <> n.judiciary_oth_document_id2
        or o.judiciary_oth_document_type <> n.judiciary_oth_document_type
        or o.judiciary_oth_document_type2 <> n.judiciary_oth_document_type2
        or o.judiciary_oth_officer_name <> n.judiciary_oth_officer_name
        or o.last_change_user_id <> n.last_change_user_id
        or o.oth_acct_ccy <> n.oth_acct_ccy
        or o.oth_acct_no <> n.oth_acct_no
        or o.oth_bank_code <> n.oth_bank_code
        or o.oth_base_acct_no <> n.oth_base_acct_no
        or o.oth_prod_type <> n.oth_prod_type
        or o.paid_amt <> n.paid_amt
        or o.pledged_acct_ccy <> n.pledged_acct_ccy
        or o.pledged_acct_no <> n.pledged_acct_no
        or o.pledged_acct_type <> n.pledged_acct_type
        or o.pledged_amt <> n.pledged_amt
        or o.pledged_base_acct_no <> n.pledged_base_acct_no
        or o.real_restraint_amt <> n.real_restraint_amt
        or o.release_judiciary_name <> n.release_judiciary_name
        or o.start_amt <> n.start_amt
        or o.thaw_document_id <> n.thaw_document_id
        or o.thaw_document_id2 <> n.thaw_document_id2
        or o.thaw_document_type <> n.thaw_document_type
        or o.thaw_oth_document_id <> n.thaw_oth_document_id
        or o.thaw_oth_document_id2 <> n.thaw_oth_document_id2
        or o.thaw_oth_document_type <> n.thaw_oth_document_type
        or o.thaw_oth_document_type2 <> n.thaw_oth_document_type2
        or o.to_pay_amt <> n.to_pay_amt
        or o.tran_amt <> n.tran_amt
        or o.tran_branch <> n.tran_branch
        or o.thaw_document_type2 <> n.thaw_document_type2
        or o.reaccount_cd <> n.reaccount_cd
        or o.reserve <> n.reserve
        or o.deduction_law_type <> n.deduction_law_type
        or o.out_sign_user_id <> n.out_sign_user_id
        or o.unlost_time <> n.unlost_time
        or o.sign_channel <> n.sign_channel
        or o.sign_user_id <> n.sign_user_id
        or o.court_code <> n.court_code
        or o.actual_pld_amount <> n.actual_pld_amount
        or o.oper_narrative <> n.oper_narrative
        or o.start_timestamp <> n.start_timestamp
        or o.actual_effect_time <> n.actual_effect_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_restraints_cl(
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
            ,reserve -- 冲正标识|冲正标识|Y-冲正数据 N-非冲正数据"
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
    else
        into ${iol_schema}.ncbs_rb_restraints_op(
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
            ,reserve -- 冲正标识|冲正标识|Y-冲正数据 N-非冲正数据"
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
    o.client_no -- 客户编号
    ,o.doc_type -- 凭证类型
    ,o.internal_key -- 账户内部键值
    ,o.reference -- 交易参考号
    ,o.restraint_type -- 限制类型
    ,o.tran_type -- 交易类型
    ,o.user_id -- 交易柜员编号
    ,o.term -- 存期
    ,o.term_type -- 期限单位
    ,o.appr_flag -- 复核标志
    ,o.channel_seq_no -- 全局流水号
    ,o.company -- 法人
    ,o.deduction_law_no -- 扣划法律文书号
    ,o.full_freeze_ind -- 全额冻结标志
    ,o.help_option -- 协助执行事项
    ,o.interrupt_flag -- 是否中断
    ,o.is_frozen -- 是否续冻
    ,o.maintain_type -- 维护方式
    ,o.msg_bank -- 银行信息
    ,o.msg_client -- 客户信息
    ,o.narrative -- 摘要
    ,o.no_of_payment -- 总支付笔数
    ,o.oth_acct_desc -- 对方账户描述
    ,o.payment_made -- 已支付笔数
    ,o.prefix -- 前缀
    ,o.program_id -- 交易代码
    ,o.release_law_no -- 解冻机关法律文书号
    ,o.res_acct_range -- 限制账户范围
    ,o.res_law_no -- 冻结机关法律文书号
    ,o.res_priority -- 冻结级别
    ,o.res_seq_no -- 限制编号
    ,o.restraint_judiciary_name -- 冻结机关名称
    ,o.restraints_status -- 限制状态
    ,o.source_module -- 源模块
    ,o.spec_code -- 指定他行信息
    ,o.start_cheque_no -- 起始支票号码
    ,o.stl_seq_no -- 结算流水号
    ,o.sub_restraint_class -- 子限制类别
    ,o.thaw_officer_name -- 经办人1姓名
    ,o.thaw_oth_officer_name -- 经办人2姓名
    ,o.under_lien -- 是否抵制押标志
    ,o.wait_seq -- 轮候冻结序号
    ,o.approval_date -- 复核日期
    ,o.channel_date -- 渠道日期
    ,o.end_date -- 结束日期
    ,o.last_change_date -- 最后修改日期
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.appr_user_id -- 复核柜员
    ,o.auth_user_id -- 授权柜员
    ,o.deduction_judiciary_name -- 有权机关名称
    ,o.end_amt -- 截止金额
    ,o.end_cheque_no -- 终止支票号码
    ,o.judiciary_document_id -- 执法人1证件号码
    ,o.judiciary_document_id2 -- 执法人1证件号码2
    ,o.judiciary_document_type -- 执法人1证件类型
    ,o.judiciary_document_type2 -- 执法人1证件类型2
    ,o.judiciary_officer_name -- 执法人1姓名
    ,o.judiciary_oth_document_id -- 执法人2证件号码
    ,o.judiciary_oth_document_id2 -- 执法人2证件号码2
    ,o.judiciary_oth_document_type -- 执法人2证件类型
    ,o.judiciary_oth_document_type2 -- 执法人2证件类型2
    ,o.judiciary_oth_officer_name -- 执法人2姓名
    ,o.last_change_user_id -- 最后修改柜员
    ,o.oth_acct_ccy -- 对方账户币种
    ,o.oth_acct_no -- 对方账号
    ,o.oth_bank_code -- 对方银行代码
    ,o.oth_base_acct_no -- 对方账号/卡号
    ,o.oth_prod_type -- 对方账户产品类型
    ,o.paid_amt -- 已还金额
    ,o.pledged_acct_ccy -- 抵押账户币种
    ,o.pledged_acct_no -- 抵押账号
    ,o.pledged_acct_type -- 抵押账户类型
    ,o.pledged_amt -- 限制金额
    ,o.pledged_base_acct_no -- 抵押主账号
    ,o.real_restraint_amt -- 可扣划金额
    ,o.release_judiciary_name -- 解冻机关名称
    ,o.start_amt -- 起始金额
    ,o.thaw_document_id -- 经办人1证件号码
    ,o.thaw_document_id2 -- 经办人1证件号码2
    ,o.thaw_document_type -- 经办人1证件类型1
    ,o.thaw_oth_document_id -- 经办人2证件号码
    ,o.thaw_oth_document_id2 -- 经办人2证件号码2
    ,o.thaw_oth_document_type -- 经办人2证件类型
    ,o.thaw_oth_document_type2 -- 经办人2证件类型2
    ,o.to_pay_amt -- 支付金额
    ,o.tran_amt -- 交易金额
    ,o.tran_branch -- 核心交易机构编号
    ,o.thaw_document_type2 -- 经办人1证件类型2
    ,o.reaccount_cd -- 对账代码
    ,o.reserve -- 冲正标识|冲正标识|Y-冲正数据 N-非冲正数据"
    ,o.deduction_law_type -- 扣划法律文书类型
    ,o.out_sign_user_id -- 解约柜员
    ,o.unlost_time -- 解挂时间
    ,o.sign_channel -- 签约渠道|签约渠道
    ,o.sign_user_id -- 签约柜员|签约柜员
    ,o.court_code -- 执行机关码值
    ,o.actual_pld_amount -- 实际控制金额|司法扣划实际控制金额
    ,o.oper_narrative -- 操作备注
    ,o.start_timestamp -- 加限的交易时间戳
    ,o.actual_effect_time -- 实际生效时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_rb_restraints_bk o
    left join ${iol_schema}.ncbs_rb_restraints_op n
        on
            o.client_no = n.client_no
            and o.internal_key = n.internal_key
            and o.restraint_type = n.restraint_type
            and o.res_seq_no = n.res_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_restraints_cl d
        on
            o.client_no = d.client_no
            and o.internal_key = d.internal_key
            and o.restraint_type = d.restraint_type
            and o.res_seq_no = d.res_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_restraints;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_restraints') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_restraints drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_restraints add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_restraints exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_restraints_cl;
alter table ${iol_schema}.ncbs_rb_restraints exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_restraints_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_restraints to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_restraints_op purge;
drop table ${iol_schema}.ncbs_rb_restraints_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_restraints_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_restraints',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
