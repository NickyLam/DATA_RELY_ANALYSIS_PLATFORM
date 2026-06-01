/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_batch_open_details
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
create table ${iol_schema}.ncbs_rb_batch_open_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_batch_open_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_batch_open_details_op purge;
drop table ${iol_schema}.ncbs_rb_batch_open_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_open_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_batch_open_details where 0=1;

create table ${iol_schema}.ncbs_rb_batch_open_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_batch_open_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_batch_open_details_cl(
            client_name -- 客户名称
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,prod_type -- 产品编号
            ,reason_code -- 账户用途
            ,reference -- 交易参考号
            ,voucher_no -- 凭证号码
            ,withdrawal_type -- 支取方式
            ,acct_class -- 账户等级
            ,acct_exec -- 银行客户经理编号
            ,acct_nature -- 存款账户类型
            ,all_dep_ind -- 通存标志
            ,all_dra_ind -- 通兑标志
            ,batch_no -- 批次号
            ,batch_status -- 批次处理状态
            ,card_pb_ind -- 卡/折标志
            ,category_type -- 存款人类别
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,contact_type -- 联系类型	
            ,copr_name -- 单位名称
            ,copr_soc_sec_no -- 单位社保参保号码
            ,dist_code -- 发证机关地区代码
            ,education -- 教育程度编号
            ,email -- 电子邮件
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,gain_type -- 卡片领取方式
            ,guardian -- 监护人名称
            ,guardian_phone -- 监护人联系电话
            ,guardian_ship -- 和监护人关系
            ,inland_offshore -- 境内境外标志
            ,int_ind_flag -- 是否计息
            ,job_run_id -- 批处理任务id
            ,local_message -- 地址说明
            ,location -- 客户地址
            ,mobile_no -- 电话号码
            ,occupation_code -- 职业
            ,phone_no -- 固定电话
            ,postal_code -- 邮政编码
            ,prefix -- 前缀
            ,print_cnt -- 打印次数
            ,race -- 种族
            ,resident_flag -- 居民性质
            ,ret_msg -- 服务状态描述
            ,reversal_flag -- 交易是否已冲正
            ,self_statement -- 取得自证声明标志
            ,seq_no -- 序号
            ,sex -- 性别
            ,soc_sec_no -- 客户社保参保号码
            ,sub_seq_no -- 系统流水号
            ,tran_note -- 交易附言
            ,birthday -- 生日
            ,document_expiry_date -- 证件失效日期
            ,iss_date -- 签发日期
            ,open_date -- 开立日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,ch_client_name -- 客户中文名称
            ,from_card_no -- 转出卡号
            ,guardian_document_id -- 监护人身份证号
            ,open_branch -- 开立机构
            ,open_ccy -- 批量开户币种
            ,to_card_no -- 终止卡号
            ,tran_amt -- 交易金额
            ,deposit_nature -- 核心存款性质
            ,batch_open_type -- 批量开立类型
            ,is_sell_cheque -- 是否允许出售支票标识
            ,all_dra_int_branch -- 通兑机构
            ,narrative_code -- 摘要码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_batch_open_details_op(
            client_name -- 客户名称
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,prod_type -- 产品编号
            ,reason_code -- 账户用途
            ,reference -- 交易参考号
            ,voucher_no -- 凭证号码
            ,withdrawal_type -- 支取方式
            ,acct_class -- 账户等级
            ,acct_exec -- 银行客户经理编号
            ,acct_nature -- 存款账户类型
            ,all_dep_ind -- 通存标志
            ,all_dra_ind -- 通兑标志
            ,batch_no -- 批次号
            ,batch_status -- 批次处理状态
            ,card_pb_ind -- 卡/折标志
            ,category_type -- 存款人类别
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,contact_type -- 联系类型	
            ,copr_name -- 单位名称
            ,copr_soc_sec_no -- 单位社保参保号码
            ,dist_code -- 发证机关地区代码
            ,education -- 教育程度编号
            ,email -- 电子邮件
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,gain_type -- 卡片领取方式
            ,guardian -- 监护人名称
            ,guardian_phone -- 监护人联系电话
            ,guardian_ship -- 和监护人关系
            ,inland_offshore -- 境内境外标志
            ,int_ind_flag -- 是否计息
            ,job_run_id -- 批处理任务id
            ,local_message -- 地址说明
            ,location -- 客户地址
            ,mobile_no -- 电话号码
            ,occupation_code -- 职业
            ,phone_no -- 固定电话
            ,postal_code -- 邮政编码
            ,prefix -- 前缀
            ,print_cnt -- 打印次数
            ,race -- 种族
            ,resident_flag -- 居民性质
            ,ret_msg -- 服务状态描述
            ,reversal_flag -- 交易是否已冲正
            ,self_statement -- 取得自证声明标志
            ,seq_no -- 序号
            ,sex -- 性别
            ,soc_sec_no -- 客户社保参保号码
            ,sub_seq_no -- 系统流水号
            ,tran_note -- 交易附言
            ,birthday -- 生日
            ,document_expiry_date -- 证件失效日期
            ,iss_date -- 签发日期
            ,open_date -- 开立日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,ch_client_name -- 客户中文名称
            ,from_card_no -- 转出卡号
            ,guardian_document_id -- 监护人身份证号
            ,open_branch -- 开立机构
            ,open_ccy -- 批量开户币种
            ,to_card_no -- 终止卡号
            ,tran_amt -- 交易金额
            ,deposit_nature -- 核心存款性质
            ,batch_open_type -- 批量开立类型
            ,is_sell_cheque -- 是否允许出售支票标识
            ,all_dra_int_branch -- 通兑机构
            ,narrative_code -- 摘要码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_name, o.client_name) as client_name -- 客户名称
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.doc_type, o.doc_type) as doc_type -- 凭证类型
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.reason_code, o.reason_code) as reason_code -- 账户用途
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.voucher_no, o.voucher_no) as voucher_no -- 凭证号码
    ,nvl(n.withdrawal_type, o.withdrawal_type) as withdrawal_type -- 支取方式
    ,nvl(n.acct_class, o.acct_class) as acct_class -- 账户等级
    ,nvl(n.acct_exec, o.acct_exec) as acct_exec -- 银行客户经理编号
    ,nvl(n.acct_nature, o.acct_nature) as acct_nature -- 存款账户类型
    ,nvl(n.all_dep_ind, o.all_dep_ind) as all_dep_ind -- 通存标志
    ,nvl(n.all_dra_ind, o.all_dra_ind) as all_dra_ind -- 通兑标志
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.batch_status, o.batch_status) as batch_status -- 批次处理状态
    ,nvl(n.card_pb_ind, o.card_pb_ind) as card_pb_ind -- 卡/折标志
    ,nvl(n.category_type, o.category_type) as category_type -- 存款人类别
    ,nvl(n.channel_seq_no, o.channel_seq_no) as channel_seq_no -- 全局流水号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.contact_type, o.contact_type) as contact_type -- 联系类型	
    ,nvl(n.copr_name, o.copr_name) as copr_name -- 单位名称
    ,nvl(n.copr_soc_sec_no, o.copr_soc_sec_no) as copr_soc_sec_no -- 单位社保参保号码
    ,nvl(n.dist_code, o.dist_code) as dist_code -- 发证机关地区代码
    ,nvl(n.education, o.education) as education -- 教育程度编号
    ,nvl(n.email, o.email) as email -- 电子邮件
    ,nvl(n.error_code, o.error_code) as error_code -- 错误码
    ,nvl(n.error_desc, o.error_desc) as error_desc -- 错误描述
    ,nvl(n.gain_type, o.gain_type) as gain_type -- 卡片领取方式
    ,nvl(n.guardian, o.guardian) as guardian -- 监护人名称
    ,nvl(n.guardian_phone, o.guardian_phone) as guardian_phone -- 监护人联系电话
    ,nvl(n.guardian_ship, o.guardian_ship) as guardian_ship -- 和监护人关系
    ,nvl(n.inland_offshore, o.inland_offshore) as inland_offshore -- 境内境外标志
    ,nvl(n.int_ind_flag, o.int_ind_flag) as int_ind_flag -- 是否计息
    ,nvl(n.job_run_id, o.job_run_id) as job_run_id -- 批处理任务id
    ,nvl(n.local_message, o.local_message) as local_message -- 地址说明
    ,nvl(n.location, o.location) as location -- 客户地址
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 电话号码
    ,nvl(n.occupation_code, o.occupation_code) as occupation_code -- 职业
    ,nvl(n.phone_no, o.phone_no) as phone_no -- 固定电话
    ,nvl(n.postal_code, o.postal_code) as postal_code -- 邮政编码
    ,nvl(n.prefix, o.prefix) as prefix -- 前缀
    ,nvl(n.print_cnt, o.print_cnt) as print_cnt -- 打印次数
    ,nvl(n.race, o.race) as race -- 种族
    ,nvl(n.resident_flag, o.resident_flag) as resident_flag -- 居民性质
    ,nvl(n.ret_msg, o.ret_msg) as ret_msg -- 服务状态描述
    ,nvl(n.reversal_flag, o.reversal_flag) as reversal_flag -- 交易是否已冲正
    ,nvl(n.self_statement, o.self_statement) as self_statement -- 取得自证声明标志
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.soc_sec_no, o.soc_sec_no) as soc_sec_no -- 客户社保参保号码
    ,nvl(n.sub_seq_no, o.sub_seq_no) as sub_seq_no -- 系统流水号
    ,nvl(n.tran_note, o.tran_note) as tran_note -- 交易附言
    ,nvl(n.birthday, o.birthday) as birthday -- 生日
    ,nvl(n.document_expiry_date, o.document_expiry_date) as document_expiry_date -- 证件失效日期
    ,nvl(n.iss_date, o.iss_date) as iss_date -- 签发日期
    ,nvl(n.open_date, o.open_date) as open_date -- 开立日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.iss_country, o.iss_country) as iss_country -- 发证国家
    ,nvl(n.ch_client_name, o.ch_client_name) as ch_client_name -- 客户中文名称
    ,nvl(n.from_card_no, o.from_card_no) as from_card_no -- 转出卡号
    ,nvl(n.guardian_document_id, o.guardian_document_id) as guardian_document_id -- 监护人身份证号
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 开立机构
    ,nvl(n.open_ccy, o.open_ccy) as open_ccy -- 批量开户币种
    ,nvl(n.to_card_no, o.to_card_no) as to_card_no -- 终止卡号
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.deposit_nature, o.deposit_nature) as deposit_nature -- 核心存款性质
    ,nvl(n.batch_open_type, o.batch_open_type) as batch_open_type -- 批量开立类型
    ,nvl(n.is_sell_cheque, o.is_sell_cheque) as is_sell_cheque -- 是否允许出售支票标识
    ,nvl(n.all_dra_int_branch, o.all_dra_int_branch) as all_dra_int_branch -- 通兑机构
    ,nvl(n.narrative_code, o.narrative_code) as narrative_code -- 摘要码
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
from (select * from ${iol_schema}.ncbs_rb_batch_open_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_batch_open_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        o.client_name <> n.client_name
        or o.client_no <> n.client_no
        or o.client_type <> n.client_type
        or o.doc_type <> n.doc_type
        or o.document_id <> n.document_id
        or o.document_type <> n.document_type
        or o.prod_type <> n.prod_type
        or o.reason_code <> n.reason_code
        or o.reference <> n.reference
        or o.voucher_no <> n.voucher_no
        or o.withdrawal_type <> n.withdrawal_type
        or o.acct_class <> n.acct_class
        or o.acct_exec <> n.acct_exec
        or o.acct_nature <> n.acct_nature
        or o.all_dep_ind <> n.all_dep_ind
        or o.all_dra_ind <> n.all_dra_ind
        or o.batch_status <> n.batch_status
        or o.card_pb_ind <> n.card_pb_ind
        or o.category_type <> n.category_type
        or o.channel_seq_no <> n.channel_seq_no
        or o.company <> n.company
        or o.contact_type <> n.contact_type
        or o.copr_name <> n.copr_name
        or o.copr_soc_sec_no <> n.copr_soc_sec_no
        or o.dist_code <> n.dist_code
        or o.education <> n.education
        or o.email <> n.email
        or o.error_code <> n.error_code
        or o.error_desc <> n.error_desc
        or o.gain_type <> n.gain_type
        or o.guardian <> n.guardian
        or o.guardian_phone <> n.guardian_phone
        or o.guardian_ship <> n.guardian_ship
        or o.inland_offshore <> n.inland_offshore
        or o.int_ind_flag <> n.int_ind_flag
        or o.job_run_id <> n.job_run_id
        or o.local_message <> n.local_message
        or o.location <> n.location
        or o.mobile_no <> n.mobile_no
        or o.occupation_code <> n.occupation_code
        or o.phone_no <> n.phone_no
        or o.postal_code <> n.postal_code
        or o.prefix <> n.prefix
        or o.print_cnt <> n.print_cnt
        or o.race <> n.race
        or o.resident_flag <> n.resident_flag
        or o.ret_msg <> n.ret_msg
        or o.reversal_flag <> n.reversal_flag
        or o.self_statement <> n.self_statement
        or o.sex <> n.sex
        or o.soc_sec_no <> n.soc_sec_no
        or o.sub_seq_no <> n.sub_seq_no
        or o.tran_note <> n.tran_note
        or o.birthday <> n.birthday
        or o.document_expiry_date <> n.document_expiry_date
        or o.iss_date <> n.iss_date
        or o.open_date <> n.open_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.iss_country <> n.iss_country
        or o.ch_client_name <> n.ch_client_name
        or o.from_card_no <> n.from_card_no
        or o.guardian_document_id <> n.guardian_document_id
        or o.open_branch <> n.open_branch
        or o.open_ccy <> n.open_ccy
        or o.to_card_no <> n.to_card_no
        or o.tran_amt <> n.tran_amt
        or o.deposit_nature <> n.deposit_nature
        or o.batch_open_type <> n.batch_open_type
        or o.is_sell_cheque <> n.is_sell_cheque
        or o.all_dra_int_branch <> n.all_dra_int_branch
        or o.narrative_code <> n.narrative_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_batch_open_details_cl(
            client_name -- 客户名称
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,prod_type -- 产品编号
            ,reason_code -- 账户用途
            ,reference -- 交易参考号
            ,voucher_no -- 凭证号码
            ,withdrawal_type -- 支取方式
            ,acct_class -- 账户等级
            ,acct_exec -- 银行客户经理编号
            ,acct_nature -- 存款账户类型
            ,all_dep_ind -- 通存标志
            ,all_dra_ind -- 通兑标志
            ,batch_no -- 批次号
            ,batch_status -- 批次处理状态
            ,card_pb_ind -- 卡/折标志
            ,category_type -- 存款人类别
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,contact_type -- 联系类型	
            ,copr_name -- 单位名称
            ,copr_soc_sec_no -- 单位社保参保号码
            ,dist_code -- 发证机关地区代码
            ,education -- 教育程度编号
            ,email -- 电子邮件
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,gain_type -- 卡片领取方式
            ,guardian -- 监护人名称
            ,guardian_phone -- 监护人联系电话
            ,guardian_ship -- 和监护人关系
            ,inland_offshore -- 境内境外标志
            ,int_ind_flag -- 是否计息
            ,job_run_id -- 批处理任务id
            ,local_message -- 地址说明
            ,location -- 客户地址
            ,mobile_no -- 电话号码
            ,occupation_code -- 职业
            ,phone_no -- 固定电话
            ,postal_code -- 邮政编码
            ,prefix -- 前缀
            ,print_cnt -- 打印次数
            ,race -- 种族
            ,resident_flag -- 居民性质
            ,ret_msg -- 服务状态描述
            ,reversal_flag -- 交易是否已冲正
            ,self_statement -- 取得自证声明标志
            ,seq_no -- 序号
            ,sex -- 性别
            ,soc_sec_no -- 客户社保参保号码
            ,sub_seq_no -- 系统流水号
            ,tran_note -- 交易附言
            ,birthday -- 生日
            ,document_expiry_date -- 证件失效日期
            ,iss_date -- 签发日期
            ,open_date -- 开立日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,ch_client_name -- 客户中文名称
            ,from_card_no -- 转出卡号
            ,guardian_document_id -- 监护人身份证号
            ,open_branch -- 开立机构
            ,open_ccy -- 批量开户币种
            ,to_card_no -- 终止卡号
            ,tran_amt -- 交易金额
            ,deposit_nature -- 核心存款性质
            ,batch_open_type -- 批量开立类型
            ,is_sell_cheque -- 是否允许出售支票标识
            ,all_dra_int_branch -- 通兑机构
            ,narrative_code -- 摘要码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_batch_open_details_op(
            client_name -- 客户名称
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,prod_type -- 产品编号
            ,reason_code -- 账户用途
            ,reference -- 交易参考号
            ,voucher_no -- 凭证号码
            ,withdrawal_type -- 支取方式
            ,acct_class -- 账户等级
            ,acct_exec -- 银行客户经理编号
            ,acct_nature -- 存款账户类型
            ,all_dep_ind -- 通存标志
            ,all_dra_ind -- 通兑标志
            ,batch_no -- 批次号
            ,batch_status -- 批次处理状态
            ,card_pb_ind -- 卡/折标志
            ,category_type -- 存款人类别
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,contact_type -- 联系类型	
            ,copr_name -- 单位名称
            ,copr_soc_sec_no -- 单位社保参保号码
            ,dist_code -- 发证机关地区代码
            ,education -- 教育程度编号
            ,email -- 电子邮件
            ,error_code -- 错误码
            ,error_desc -- 错误描述
            ,gain_type -- 卡片领取方式
            ,guardian -- 监护人名称
            ,guardian_phone -- 监护人联系电话
            ,guardian_ship -- 和监护人关系
            ,inland_offshore -- 境内境外标志
            ,int_ind_flag -- 是否计息
            ,job_run_id -- 批处理任务id
            ,local_message -- 地址说明
            ,location -- 客户地址
            ,mobile_no -- 电话号码
            ,occupation_code -- 职业
            ,phone_no -- 固定电话
            ,postal_code -- 邮政编码
            ,prefix -- 前缀
            ,print_cnt -- 打印次数
            ,race -- 种族
            ,resident_flag -- 居民性质
            ,ret_msg -- 服务状态描述
            ,reversal_flag -- 交易是否已冲正
            ,self_statement -- 取得自证声明标志
            ,seq_no -- 序号
            ,sex -- 性别
            ,soc_sec_no -- 客户社保参保号码
            ,sub_seq_no -- 系统流水号
            ,tran_note -- 交易附言
            ,birthday -- 生日
            ,document_expiry_date -- 证件失效日期
            ,iss_date -- 签发日期
            ,open_date -- 开立日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,ch_client_name -- 客户中文名称
            ,from_card_no -- 转出卡号
            ,guardian_document_id -- 监护人身份证号
            ,open_branch -- 开立机构
            ,open_ccy -- 批量开户币种
            ,to_card_no -- 终止卡号
            ,tran_amt -- 交易金额
            ,deposit_nature -- 核心存款性质
            ,batch_open_type -- 批量开立类型
            ,is_sell_cheque -- 是否允许出售支票标识
            ,all_dra_int_branch -- 通兑机构
            ,narrative_code -- 摘要码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_name -- 客户名称
    ,o.client_no -- 客户编号
    ,o.client_type -- 客户类型
    ,o.doc_type -- 凭证类型
    ,o.document_id -- 证件号码
    ,o.document_type -- 客户证件类型
    ,o.prod_type -- 产品编号
    ,o.reason_code -- 账户用途
    ,o.reference -- 交易参考号
    ,o.voucher_no -- 凭证号码
    ,o.withdrawal_type -- 支取方式
    ,o.acct_class -- 账户等级
    ,o.acct_exec -- 银行客户经理编号
    ,o.acct_nature -- 存款账户类型
    ,o.all_dep_ind -- 通存标志
    ,o.all_dra_ind -- 通兑标志
    ,o.batch_no -- 批次号
    ,o.batch_status -- 批次处理状态
    ,o.card_pb_ind -- 卡/折标志
    ,o.category_type -- 存款人类别
    ,o.channel_seq_no -- 全局流水号
    ,o.company -- 法人
    ,o.contact_type -- 联系类型	
    ,o.copr_name -- 单位名称
    ,o.copr_soc_sec_no -- 单位社保参保号码
    ,o.dist_code -- 发证机关地区代码
    ,o.education -- 教育程度编号
    ,o.email -- 电子邮件
    ,o.error_code -- 错误码
    ,o.error_desc -- 错误描述
    ,o.gain_type -- 卡片领取方式
    ,o.guardian -- 监护人名称
    ,o.guardian_phone -- 监护人联系电话
    ,o.guardian_ship -- 和监护人关系
    ,o.inland_offshore -- 境内境外标志
    ,o.int_ind_flag -- 是否计息
    ,o.job_run_id -- 批处理任务id
    ,o.local_message -- 地址说明
    ,o.location -- 客户地址
    ,o.mobile_no -- 电话号码
    ,o.occupation_code -- 职业
    ,o.phone_no -- 固定电话
    ,o.postal_code -- 邮政编码
    ,o.prefix -- 前缀
    ,o.print_cnt -- 打印次数
    ,o.race -- 种族
    ,o.resident_flag -- 居民性质
    ,o.ret_msg -- 服务状态描述
    ,o.reversal_flag -- 交易是否已冲正
    ,o.self_statement -- 取得自证声明标志
    ,o.seq_no -- 序号
    ,o.sex -- 性别
    ,o.soc_sec_no -- 客户社保参保号码
    ,o.sub_seq_no -- 系统流水号
    ,o.tran_note -- 交易附言
    ,o.birthday -- 生日
    ,o.document_expiry_date -- 证件失效日期
    ,o.iss_date -- 签发日期
    ,o.open_date -- 开立日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.iss_country -- 发证国家
    ,o.ch_client_name -- 客户中文名称
    ,o.from_card_no -- 转出卡号
    ,o.guardian_document_id -- 监护人身份证号
    ,o.open_branch -- 开立机构
    ,o.open_ccy -- 批量开户币种
    ,o.to_card_no -- 终止卡号
    ,o.tran_amt -- 交易金额
    ,o.deposit_nature -- 核心存款性质
    ,o.batch_open_type -- 批量开立类型
    ,o.is_sell_cheque -- 是否允许出售支票标识
    ,o.all_dra_int_branch -- 通兑机构
    ,o.narrative_code -- 摘要码
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
from ${iol_schema}.ncbs_rb_batch_open_details_bk o
    left join ${iol_schema}.ncbs_rb_batch_open_details_op n
        on
            o.batch_no = n.batch_no
            and o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_batch_open_details_cl d
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
--truncate table ${iol_schema}.ncbs_rb_batch_open_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_batch_open_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_batch_open_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_batch_open_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_batch_open_details exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_batch_open_details_cl;
alter table ${iol_schema}.ncbs_rb_batch_open_details exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_batch_open_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_batch_open_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_batch_open_details_op purge;
drop table ${iol_schema}.ncbs_rb_batch_open_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_batch_open_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_batch_open_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
