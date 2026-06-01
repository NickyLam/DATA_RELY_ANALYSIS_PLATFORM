/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_batch_open_dct_details
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
create table ${iol_schema}.ncbs_rb_batch_open_dct_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_batch_open_dct_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_batch_open_dct_details_op purge;
drop table ${iol_schema}.ncbs_rb_batch_open_dct_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_open_dct_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_batch_open_dct_details where 0=1;

create table ${iol_schema}.ncbs_rb_batch_open_dct_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_batch_open_dct_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_batch_open_dct_details_cl(
            base_acct_no -- 交易账号/卡号
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,voucher_no -- 凭证号码
            ,withdrawal_type -- 支取方式
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_exec -- 银行客户经理编号
            ,acct_nature -- 存款账户类型
            ,auto_renew_rollover -- 自动转存方式
            ,bal_type -- 余额类型
            ,batch_no -- 批次号
            ,batch_open_status -- 批量开立状态
            ,card_pb_ind -- 卡/折标志
            ,cash_item -- 现金项目
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,contact_type -- 联系类型	
            ,copr_name -- 单位名称
            ,email -- 电子邮件
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,inland_offshore -- 境内境外标志
            ,job_run_id -- 批处理任务id
            ,location -- 客户地址
            ,mobile_no -- 电话号码
            ,occupation_code -- 职业
            ,oth_bal_type -- 对方余额类型
            ,oth_prefix -- 对方票据前缀
            ,phone_no -- 固定电话
            ,prefix -- 前缀
            ,print_cnt -- 打印次数
            ,ret_msg -- 服务状态描述
            ,reversal_flag -- 交易是否已冲正
            ,seq_no -- 序号
            ,sex -- 性别
            ,sub_seq_no -- 系统流水号
            ,birthday -- 生日
            ,document_expiry_date -- 证件失效日期
            ,effect_date -- 产品生效日期
            ,sign_time -- 登记时间
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,ch_client_name -- 客户中文名称
            ,contact_address -- 公司联系地址
            ,open_branch -- 开立机构
            ,open_ccy -- 批量开户币种
            ,oth_acct_ccy -- 对方账户币种
            ,oth_acct_name -- 对方账户名称
            ,oth_acct_no -- 对方账号
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_doc_type -- 对方凭证类型
            ,oth_prod_type -- 对方账户产品类型
            ,oth_voucher_no -- 对方票据号码
            ,tran_amt -- 交易金额
            ,deposit_nature -- 核心存款性质
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_batch_open_dct_details_op(
            base_acct_no -- 交易账号/卡号
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,voucher_no -- 凭证号码
            ,withdrawal_type -- 支取方式
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_exec -- 银行客户经理编号
            ,acct_nature -- 存款账户类型
            ,auto_renew_rollover -- 自动转存方式
            ,bal_type -- 余额类型
            ,batch_no -- 批次号
            ,batch_open_status -- 批量开立状态
            ,card_pb_ind -- 卡/折标志
            ,cash_item -- 现金项目
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,contact_type -- 联系类型	
            ,copr_name -- 单位名称
            ,email -- 电子邮件
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,inland_offshore -- 境内境外标志
            ,job_run_id -- 批处理任务id
            ,location -- 客户地址
            ,mobile_no -- 电话号码
            ,occupation_code -- 职业
            ,oth_bal_type -- 对方余额类型
            ,oth_prefix -- 对方票据前缀
            ,phone_no -- 固定电话
            ,prefix -- 前缀
            ,print_cnt -- 打印次数
            ,ret_msg -- 服务状态描述
            ,reversal_flag -- 交易是否已冲正
            ,seq_no -- 序号
            ,sex -- 性别
            ,sub_seq_no -- 系统流水号
            ,birthday -- 生日
            ,document_expiry_date -- 证件失效日期
            ,effect_date -- 产品生效日期
            ,sign_time -- 登记时间
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,ch_client_name -- 客户中文名称
            ,contact_address -- 公司联系地址
            ,open_branch -- 开立机构
            ,open_ccy -- 批量开户币种
            ,oth_acct_ccy -- 对方账户币种
            ,oth_acct_name -- 对方账户名称
            ,oth_acct_no -- 对方账号
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_doc_type -- 对方凭证类型
            ,oth_prod_type -- 对方账户产品类型
            ,oth_voucher_no -- 对方票据号码
            ,tran_amt -- 交易金额
            ,deposit_nature -- 核心存款性质
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_name, o.client_name) as client_name -- 客户名称
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.doc_type, o.doc_type) as doc_type -- 凭证类型
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.tran_type, o.tran_type) as tran_type -- 交易类型
    ,nvl(n.voucher_no, o.voucher_no) as voucher_no -- 凭证号码
    ,nvl(n.withdrawal_type, o.withdrawal_type) as withdrawal_type -- 支取方式
    ,nvl(n.term, o.term) as term -- 存期
    ,nvl(n.term_type, o.term_type) as term_type -- 期限单位
    ,nvl(n.acct_exec, o.acct_exec) as acct_exec -- 银行客户经理编号
    ,nvl(n.acct_nature, o.acct_nature) as acct_nature -- 存款账户类型
    ,nvl(n.auto_renew_rollover, o.auto_renew_rollover) as auto_renew_rollover -- 自动转存方式
    ,nvl(n.bal_type, o.bal_type) as bal_type -- 余额类型
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.batch_open_status, o.batch_open_status) as batch_open_status -- 批量开立状态
    ,nvl(n.card_pb_ind, o.card_pb_ind) as card_pb_ind -- 卡/折标志
    ,nvl(n.cash_item, o.cash_item) as cash_item -- 现金项目
    ,nvl(n.channel_seq_no, o.channel_seq_no) as channel_seq_no -- 全局流水号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.contact_type, o.contact_type) as contact_type -- 联系类型	
    ,nvl(n.copr_name, o.copr_name) as copr_name -- 单位名称
    ,nvl(n.email, o.email) as email -- 电子邮件
    ,nvl(n.error_code, o.error_code) as error_code -- 错误码
    ,nvl(n.error_desc, o.error_desc) as error_desc -- 错误描述
    ,nvl(n.inland_offshore, o.inland_offshore) as inland_offshore -- 境内境外标志
    ,nvl(n.job_run_id, o.job_run_id) as job_run_id -- 批处理任务id
    ,nvl(n.location, o.location) as location -- 客户地址
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 电话号码
    ,nvl(n.occupation_code, o.occupation_code) as occupation_code -- 职业
    ,nvl(n.oth_bal_type, o.oth_bal_type) as oth_bal_type -- 对方余额类型
    ,nvl(n.oth_prefix, o.oth_prefix) as oth_prefix -- 对方票据前缀
    ,nvl(n.phone_no, o.phone_no) as phone_no -- 固定电话
    ,nvl(n.prefix, o.prefix) as prefix -- 前缀
    ,nvl(n.print_cnt, o.print_cnt) as print_cnt -- 打印次数
    ,nvl(n.ret_msg, o.ret_msg) as ret_msg -- 服务状态描述
    ,nvl(n.reversal_flag, o.reversal_flag) as reversal_flag -- 交易是否已冲正
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.sub_seq_no, o.sub_seq_no) as sub_seq_no -- 系统流水号
    ,nvl(n.birthday, o.birthday) as birthday -- 生日
    ,nvl(n.document_expiry_date, o.document_expiry_date) as document_expiry_date -- 证件失效日期
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.sign_time, o.sign_time) as sign_time -- 登记时间
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.iss_country, o.iss_country) as iss_country -- 发证国家
    ,nvl(n.ch_client_name, o.ch_client_name) as ch_client_name -- 客户中文名称
    ,nvl(n.contact_address, o.contact_address) as contact_address -- 公司联系地址
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 开立机构
    ,nvl(n.open_ccy, o.open_ccy) as open_ccy -- 批量开户币种
    ,nvl(n.oth_acct_ccy, o.oth_acct_ccy) as oth_acct_ccy -- 对方账户币种
    ,nvl(n.oth_acct_name, o.oth_acct_name) as oth_acct_name -- 对方账户名称
    ,nvl(n.oth_acct_no, o.oth_acct_no) as oth_acct_no -- 对方账号
    ,nvl(n.oth_acct_seq_no, o.oth_acct_seq_no) as oth_acct_seq_no -- 对方账户序列号
    ,nvl(n.oth_doc_type, o.oth_doc_type) as oth_doc_type -- 对方凭证类型
    ,nvl(n.oth_prod_type, o.oth_prod_type) as oth_prod_type -- 对方账户产品类型
    ,nvl(n.oth_voucher_no, o.oth_voucher_no) as oth_voucher_no -- 对方票据号码
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.deposit_nature, o.deposit_nature) as deposit_nature -- 核心存款性质
    ,case when
            n.batch_no is null
            and n.seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.batch_no is null
            and n.seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.batch_no is null
            and n.seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_batch_open_dct_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_batch_open_dct_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.batch_no = n.batch_no
            and o.seq_no = n.seq_no
where (
        o.batch_no is null
        and o.seq_no is null
    )
    or (
        n.batch_no is null
        and n.seq_no is null
    )
    or (
        o.base_acct_no <> n.base_acct_no
        or o.client_name <> n.client_name
        or o.client_no <> n.client_no
        or o.client_type <> n.client_type
        or o.doc_type <> n.doc_type
        or o.document_id <> n.document_id
        or o.document_type <> n.document_type
        or o.prod_type <> n.prod_type
        or o.reference <> n.reference
        or o.tran_type <> n.tran_type
        or o.voucher_no <> n.voucher_no
        or o.withdrawal_type <> n.withdrawal_type
        or o.term <> n.term
        or o.term_type <> n.term_type
        or o.acct_exec <> n.acct_exec
        or o.acct_nature <> n.acct_nature
        or o.auto_renew_rollover <> n.auto_renew_rollover
        or o.bal_type <> n.bal_type
        or o.batch_open_status <> n.batch_open_status
        or o.card_pb_ind <> n.card_pb_ind
        or o.cash_item <> n.cash_item
        or o.channel_seq_no <> n.channel_seq_no
        or o.company <> n.company
        or o.contact_type <> n.contact_type
        or o.copr_name <> n.copr_name
        or o.email <> n.email
        or o.error_code <> n.error_code
        or o.error_desc <> n.error_desc
        or o.inland_offshore <> n.inland_offshore
        or o.job_run_id <> n.job_run_id
        or o.location <> n.location
        or o.mobile_no <> n.mobile_no
        or o.occupation_code <> n.occupation_code
        or o.oth_bal_type <> n.oth_bal_type
        or o.oth_prefix <> n.oth_prefix
        or o.phone_no <> n.phone_no
        or o.prefix <> n.prefix
        or o.print_cnt <> n.print_cnt
        or o.ret_msg <> n.ret_msg
        or o.reversal_flag <> n.reversal_flag
        or o.sex <> n.sex
        or o.sub_seq_no <> n.sub_seq_no
        or o.birthday <> n.birthday
        or o.document_expiry_date <> n.document_expiry_date
        or o.effect_date <> n.effect_date
        or o.sign_time <> n.sign_time
        or o.tran_timestamp <> n.tran_timestamp
        or o.iss_country <> n.iss_country
        or o.ch_client_name <> n.ch_client_name
        or o.contact_address <> n.contact_address
        or o.open_branch <> n.open_branch
        or o.open_ccy <> n.open_ccy
        or o.oth_acct_ccy <> n.oth_acct_ccy
        or o.oth_acct_name <> n.oth_acct_name
        or o.oth_acct_no <> n.oth_acct_no
        or o.oth_acct_seq_no <> n.oth_acct_seq_no
        or o.oth_doc_type <> n.oth_doc_type
        or o.oth_prod_type <> n.oth_prod_type
        or o.oth_voucher_no <> n.oth_voucher_no
        or o.tran_amt <> n.tran_amt
        or o.deposit_nature <> n.deposit_nature
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_batch_open_dct_details_cl(
            base_acct_no -- 交易账号/卡号
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,voucher_no -- 凭证号码
            ,withdrawal_type -- 支取方式
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_exec -- 银行客户经理编号
            ,acct_nature -- 存款账户类型
            ,auto_renew_rollover -- 自动转存方式
            ,bal_type -- 余额类型
            ,batch_no -- 批次号
            ,batch_open_status -- 批量开立状态
            ,card_pb_ind -- 卡/折标志
            ,cash_item -- 现金项目
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,contact_type -- 联系类型	
            ,copr_name -- 单位名称
            ,email -- 电子邮件
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,inland_offshore -- 境内境外标志
            ,job_run_id -- 批处理任务id
            ,location -- 客户地址
            ,mobile_no -- 电话号码
            ,occupation_code -- 职业
            ,oth_bal_type -- 对方余额类型
            ,oth_prefix -- 对方票据前缀
            ,phone_no -- 固定电话
            ,prefix -- 前缀
            ,print_cnt -- 打印次数
            ,ret_msg -- 服务状态描述
            ,reversal_flag -- 交易是否已冲正
            ,seq_no -- 序号
            ,sex -- 性别
            ,sub_seq_no -- 系统流水号
            ,birthday -- 生日
            ,document_expiry_date -- 证件失效日期
            ,effect_date -- 产品生效日期
            ,sign_time -- 登记时间
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,ch_client_name -- 客户中文名称
            ,contact_address -- 公司联系地址
            ,open_branch -- 开立机构
            ,open_ccy -- 批量开户币种
            ,oth_acct_ccy -- 对方账户币种
            ,oth_acct_name -- 对方账户名称
            ,oth_acct_no -- 对方账号
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_doc_type -- 对方凭证类型
            ,oth_prod_type -- 对方账户产品类型
            ,oth_voucher_no -- 对方票据号码
            ,tran_amt -- 交易金额
            ,deposit_nature -- 核心存款性质
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_batch_open_dct_details_op(
            base_acct_no -- 交易账号/卡号
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,tran_type -- 交易类型
            ,voucher_no -- 凭证号码
            ,withdrawal_type -- 支取方式
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_exec -- 银行客户经理编号
            ,acct_nature -- 存款账户类型
            ,auto_renew_rollover -- 自动转存方式
            ,bal_type -- 余额类型
            ,batch_no -- 批次号
            ,batch_open_status -- 批量开立状态
            ,card_pb_ind -- 卡/折标志
            ,cash_item -- 现金项目
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,contact_type -- 联系类型	
            ,copr_name -- 单位名称
            ,email -- 电子邮件
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,inland_offshore -- 境内境外标志
            ,job_run_id -- 批处理任务id
            ,location -- 客户地址
            ,mobile_no -- 电话号码
            ,occupation_code -- 职业
            ,oth_bal_type -- 对方余额类型
            ,oth_prefix -- 对方票据前缀
            ,phone_no -- 固定电话
            ,prefix -- 前缀
            ,print_cnt -- 打印次数
            ,ret_msg -- 服务状态描述
            ,reversal_flag -- 交易是否已冲正
            ,seq_no -- 序号
            ,sex -- 性别
            ,sub_seq_no -- 系统流水号
            ,birthday -- 生日
            ,document_expiry_date -- 证件失效日期
            ,effect_date -- 产品生效日期
            ,sign_time -- 登记时间
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,ch_client_name -- 客户中文名称
            ,contact_address -- 公司联系地址
            ,open_branch -- 开立机构
            ,open_ccy -- 批量开户币种
            ,oth_acct_ccy -- 对方账户币种
            ,oth_acct_name -- 对方账户名称
            ,oth_acct_no -- 对方账号
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_doc_type -- 对方凭证类型
            ,oth_prod_type -- 对方账户产品类型
            ,oth_voucher_no -- 对方票据号码
            ,tran_amt -- 交易金额
            ,deposit_nature -- 核心存款性质
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.base_acct_no -- 交易账号/卡号
    ,o.client_name -- 客户名称
    ,o.client_no -- 客户编号
    ,o.client_type -- 客户类型
    ,o.doc_type -- 凭证类型
    ,o.document_id -- 证件号码
    ,o.document_type -- 客户证件类型
    ,o.prod_type -- 产品编号
    ,o.reference -- 交易参考号
    ,o.tran_type -- 交易类型
    ,o.voucher_no -- 凭证号码
    ,o.withdrawal_type -- 支取方式
    ,o.term -- 存期
    ,o.term_type -- 期限单位
    ,o.acct_exec -- 银行客户经理编号
    ,o.acct_nature -- 存款账户类型
    ,o.auto_renew_rollover -- 自动转存方式
    ,o.bal_type -- 余额类型
    ,o.batch_no -- 批次号
    ,o.batch_open_status -- 批量开立状态
    ,o.card_pb_ind -- 卡/折标志
    ,o.cash_item -- 现金项目
    ,o.channel_seq_no -- 全局流水号
    ,o.company -- 法人
    ,o.contact_type -- 联系类型	
    ,o.copr_name -- 单位名称
    ,o.email -- 电子邮件
    ,o.error_code -- 错误码
    ,o.error_desc -- 错误描述
    ,o.inland_offshore -- 境内境外标志
    ,o.job_run_id -- 批处理任务id
    ,o.location -- 客户地址
    ,o.mobile_no -- 电话号码
    ,o.occupation_code -- 职业
    ,o.oth_bal_type -- 对方余额类型
    ,o.oth_prefix -- 对方票据前缀
    ,o.phone_no -- 固定电话
    ,o.prefix -- 前缀
    ,o.print_cnt -- 打印次数
    ,o.ret_msg -- 服务状态描述
    ,o.reversal_flag -- 交易是否已冲正
    ,o.seq_no -- 序号
    ,o.sex -- 性别
    ,o.sub_seq_no -- 系统流水号
    ,o.birthday -- 生日
    ,o.document_expiry_date -- 证件失效日期
    ,o.effect_date -- 产品生效日期
    ,o.sign_time -- 登记时间
    ,o.tran_timestamp -- 交易时间戳
    ,o.iss_country -- 发证国家
    ,o.ch_client_name -- 客户中文名称
    ,o.contact_address -- 公司联系地址
    ,o.open_branch -- 开立机构
    ,o.open_ccy -- 批量开户币种
    ,o.oth_acct_ccy -- 对方账户币种
    ,o.oth_acct_name -- 对方账户名称
    ,o.oth_acct_no -- 对方账号
    ,o.oth_acct_seq_no -- 对方账户序列号
    ,o.oth_doc_type -- 对方凭证类型
    ,o.oth_prod_type -- 对方账户产品类型
    ,o.oth_voucher_no -- 对方票据号码
    ,o.tran_amt -- 交易金额
    ,o.deposit_nature -- 核心存款性质
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
from ${iol_schema}.ncbs_rb_batch_open_dct_details_bk o
    left join ${iol_schema}.ncbs_rb_batch_open_dct_details_op n
        on
            o.batch_no = n.batch_no
            and o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_batch_open_dct_details_cl d
        on
            o.batch_no = d.batch_no
            and o.seq_no = d.seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_batch_open_dct_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_batch_open_dct_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_batch_open_dct_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_batch_open_dct_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_batch_open_dct_details exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_batch_open_dct_details_cl;
alter table ${iol_schema}.ncbs_rb_batch_open_dct_details exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_batch_open_dct_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_batch_open_dct_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_batch_open_dct_details_op purge;
drop table ${iol_schema}.ncbs_rb_batch_open_dct_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_batch_open_dct_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_batch_open_dct_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
