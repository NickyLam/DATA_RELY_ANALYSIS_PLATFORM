/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_restraints_hist
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
create table ${iol_schema}.ncbs_rb_restraints_hist_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_restraints_hist
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_restraints_hist_op purge;
drop table ${iol_schema}.ncbs_rb_restraints_hist_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_restraints_hist_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_restraints_hist where 0=1;

create table ${iol_schema}.ncbs_rb_restraints_hist_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_restraints_hist where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_restraints_hist_cl(
            base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,restraint_type -- 限制类型
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,help_option -- 协助执行事项
            ,init_seq_no -- 初始限制流水号
            ,is_frozen -- 是否续冻
            ,last_status -- 前一限制状态
            ,main_flag -- 主、分账户类型标志
            ,narrative -- 摘要
            ,release_law_no -- 解冻机关法律文书号
            ,res_acct_range -- 限制账户范围
            ,res_law_no -- 冻结机关法律文书号
            ,res_priority -- 冻结级别
            ,res_seq_no -- 限制编号
            ,restraint_judiciary_name -- 冻结机关名称
            ,restraints_status -- 限制状态
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,sub_restraint_class -- 子限制类别
            ,system_phase -- 系统所处的阶段
            ,thaw_officer_name -- 经办人1姓名
            ,thaw_oth_officer_name -- 经办人2姓名
            ,under_lien -- 是否抵制押标志
            ,approval_date -- 复核日期
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,deduction_judiciary_name -- 有权机关名称
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
            ,pledged_amt -- 限制金额
            ,release_judiciary_name -- 解冻机关名称
            ,thaw_document_id -- 经办人1证件号码
            ,thaw_document_id2 -- 经办人1证件号码2
            ,thaw_document_type -- 经办人1证件类型1
            ,thaw_oth_document_id -- 经办人2证件号码
            ,thaw_oth_document_id2 -- 经办人2证件号码2
            ,thaw_oth_document_type -- 经办人2证件类型
            ,thaw_oth_document_type2 -- 经办人2证件类型2
            ,tran_branch -- 核心交易机构编号
            ,thaw_document_type2 -- 经办人1证件类型2
            ,reserve -- 冲正标识|冲正标识|Y-冲正数据 N-非冲正数据
            ,reaccount_cd -- 对账代码|对账代码
            ,tran_amt -- 交易金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_restraints_hist_op(
            base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,restraint_type -- 限制类型
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,help_option -- 协助执行事项
            ,init_seq_no -- 初始限制流水号
            ,is_frozen -- 是否续冻
            ,last_status -- 前一限制状态
            ,main_flag -- 主、分账户类型标志
            ,narrative -- 摘要
            ,release_law_no -- 解冻机关法律文书号
            ,res_acct_range -- 限制账户范围
            ,res_law_no -- 冻结机关法律文书号
            ,res_priority -- 冻结级别
            ,res_seq_no -- 限制编号
            ,restraint_judiciary_name -- 冻结机关名称
            ,restraints_status -- 限制状态
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,sub_restraint_class -- 子限制类别
            ,system_phase -- 系统所处的阶段
            ,thaw_officer_name -- 经办人1姓名
            ,thaw_oth_officer_name -- 经办人2姓名
            ,under_lien -- 是否抵制押标志
            ,approval_date -- 复核日期
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,deduction_judiciary_name -- 有权机关名称
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
            ,pledged_amt -- 限制金额
            ,release_judiciary_name -- 解冻机关名称
            ,thaw_document_id -- 经办人1证件号码
            ,thaw_document_id2 -- 经办人1证件号码2
            ,thaw_document_type -- 经办人1证件类型1
            ,thaw_oth_document_id -- 经办人2证件号码
            ,thaw_oth_document_id2 -- 经办人2证件号码2
            ,thaw_oth_document_type -- 经办人2证件类型
            ,thaw_oth_document_type2 -- 经办人2证件类型2
            ,tran_branch -- 核心交易机构编号
            ,thaw_document_type2 -- 经办人1证件类型2
            ,reserve -- 冲正标识|冲正标识|Y-冲正数据 N-非冲正数据
            ,reaccount_cd -- 对账代码|对账代码
            ,tran_amt -- 交易金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.restraint_type, o.restraint_type) as restraint_type -- 限制类型
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.term, o.term) as term -- 存期
    ,nvl(n.term_type, o.term_type) as term_type -- 期限单位
    ,nvl(n.channel_seq_no, o.channel_seq_no) as channel_seq_no -- 全局流水号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.help_option, o.help_option) as help_option -- 协助执行事项
    ,nvl(n.init_seq_no, o.init_seq_no) as init_seq_no -- 初始限制流水号
    ,nvl(n.is_frozen, o.is_frozen) as is_frozen -- 是否续冻
    ,nvl(n.last_status, o.last_status) as last_status -- 前一限制状态
    ,nvl(n.main_flag, o.main_flag) as main_flag -- 主、分账户类型标志
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.release_law_no, o.release_law_no) as release_law_no -- 解冻机关法律文书号
    ,nvl(n.res_acct_range, o.res_acct_range) as res_acct_range -- 限制账户范围
    ,nvl(n.res_law_no, o.res_law_no) as res_law_no -- 冻结机关法律文书号
    ,nvl(n.res_priority, o.res_priority) as res_priority -- 冻结级别
    ,nvl(n.res_seq_no, o.res_seq_no) as res_seq_no -- 限制编号
    ,nvl(n.restraint_judiciary_name, o.restraint_judiciary_name) as restraint_judiciary_name -- 冻结机关名称
    ,nvl(n.restraints_status, o.restraints_status) as restraints_status -- 限制状态
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.sub_restraint_class, o.sub_restraint_class) as sub_restraint_class -- 子限制类别
    ,nvl(n.system_phase, o.system_phase) as system_phase -- 系统所处的阶段
    ,nvl(n.thaw_officer_name, o.thaw_officer_name) as thaw_officer_name -- 经办人1姓名
    ,nvl(n.thaw_oth_officer_name, o.thaw_oth_officer_name) as thaw_oth_officer_name -- 经办人2姓名
    ,nvl(n.under_lien, o.under_lien) as under_lien -- 是否抵制押标志
    ,nvl(n.approval_date, o.approval_date) as approval_date -- 复核日期
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.deduction_judiciary_name, o.deduction_judiciary_name) as deduction_judiciary_name -- 有权机关名称
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
    ,nvl(n.pledged_amt, o.pledged_amt) as pledged_amt -- 限制金额
    ,nvl(n.release_judiciary_name, o.release_judiciary_name) as release_judiciary_name -- 解冻机关名称
    ,nvl(n.thaw_document_id, o.thaw_document_id) as thaw_document_id -- 经办人1证件号码
    ,nvl(n.thaw_document_id2, o.thaw_document_id2) as thaw_document_id2 -- 经办人1证件号码2
    ,nvl(n.thaw_document_type, o.thaw_document_type) as thaw_document_type -- 经办人1证件类型1
    ,nvl(n.thaw_oth_document_id, o.thaw_oth_document_id) as thaw_oth_document_id -- 经办人2证件号码
    ,nvl(n.thaw_oth_document_id2, o.thaw_oth_document_id2) as thaw_oth_document_id2 -- 经办人2证件号码2
    ,nvl(n.thaw_oth_document_type, o.thaw_oth_document_type) as thaw_oth_document_type -- 经办人2证件类型
    ,nvl(n.thaw_oth_document_type2, o.thaw_oth_document_type2) as thaw_oth_document_type2 -- 经办人2证件类型2
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.thaw_document_type2, o.thaw_document_type2) as thaw_document_type2 -- 经办人1证件类型2
    ,nvl(n.reserve, o.reserve) as reserve -- 冲正标识|冲正标识|Y-冲正数据 N-非冲正数据
    ,nvl(n.reaccount_cd, o.reaccount_cd) as reaccount_cd -- 对账代码|对账代码
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,case when
            n.seq_no is null
            and n.start_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_no is null
            and n.start_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_no is null
            and n.start_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_restraints_hist_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_restraints_hist where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
            and o.start_date = n.start_date
where (
        o.seq_no is null
        and o.start_date is null
    )
    or (
        n.seq_no is null
        and n.start_date is null
    )
    or (
        o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.internal_key <> n.internal_key
        or o.reference <> n.reference
        or o.restraint_type <> n.restraint_type
        or o.user_id <> n.user_id
        or o.term <> n.term
        or o.term_type <> n.term_type
        or o.channel_seq_no <> n.channel_seq_no
        or o.company <> n.company
        or o.help_option <> n.help_option
        or o.init_seq_no <> n.init_seq_no
        or o.is_frozen <> n.is_frozen
        or o.last_status <> n.last_status
        or o.main_flag <> n.main_flag
        or o.narrative <> n.narrative
        or o.release_law_no <> n.release_law_no
        or o.res_acct_range <> n.res_acct_range
        or o.res_law_no <> n.res_law_no
        or o.res_priority <> n.res_priority
        or o.res_seq_no <> n.res_seq_no
        or o.restraint_judiciary_name <> n.restraint_judiciary_name
        or o.restraints_status <> n.restraints_status
        or o.source_type <> n.source_type
        or o.sub_restraint_class <> n.sub_restraint_class
        or o.system_phase <> n.system_phase
        or o.thaw_officer_name <> n.thaw_officer_name
        or o.thaw_oth_officer_name <> n.thaw_oth_officer_name
        or o.under_lien <> n.under_lien
        or o.approval_date <> n.approval_date
        or o.end_date <> n.end_date
        or o.last_change_date <> n.last_change_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.auth_user_id <> n.auth_user_id
        or o.deduction_judiciary_name <> n.deduction_judiciary_name
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
        or o.pledged_amt <> n.pledged_amt
        or o.release_judiciary_name <> n.release_judiciary_name
        or o.thaw_document_id <> n.thaw_document_id
        or o.thaw_document_id2 <> n.thaw_document_id2
        or o.thaw_document_type <> n.thaw_document_type
        or o.thaw_oth_document_id <> n.thaw_oth_document_id
        or o.thaw_oth_document_id2 <> n.thaw_oth_document_id2
        or o.thaw_oth_document_type <> n.thaw_oth_document_type
        or o.thaw_oth_document_type2 <> n.thaw_oth_document_type2
        or o.tran_branch <> n.tran_branch
        or o.thaw_document_type2 <> n.thaw_document_type2
        or o.reserve <> n.reserve
        or o.reaccount_cd <> n.reaccount_cd
        or o.tran_amt <> n.tran_amt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_restraints_hist_cl(
            base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,restraint_type -- 限制类型
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,help_option -- 协助执行事项
            ,init_seq_no -- 初始限制流水号
            ,is_frozen -- 是否续冻
            ,last_status -- 前一限制状态
            ,main_flag -- 主、分账户类型标志
            ,narrative -- 摘要
            ,release_law_no -- 解冻机关法律文书号
            ,res_acct_range -- 限制账户范围
            ,res_law_no -- 冻结机关法律文书号
            ,res_priority -- 冻结级别
            ,res_seq_no -- 限制编号
            ,restraint_judiciary_name -- 冻结机关名称
            ,restraints_status -- 限制状态
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,sub_restraint_class -- 子限制类别
            ,system_phase -- 系统所处的阶段
            ,thaw_officer_name -- 经办人1姓名
            ,thaw_oth_officer_name -- 经办人2姓名
            ,under_lien -- 是否抵制押标志
            ,approval_date -- 复核日期
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,deduction_judiciary_name -- 有权机关名称
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
            ,pledged_amt -- 限制金额
            ,release_judiciary_name -- 解冻机关名称
            ,thaw_document_id -- 经办人1证件号码
            ,thaw_document_id2 -- 经办人1证件号码2
            ,thaw_document_type -- 经办人1证件类型1
            ,thaw_oth_document_id -- 经办人2证件号码
            ,thaw_oth_document_id2 -- 经办人2证件号码2
            ,thaw_oth_document_type -- 经办人2证件类型
            ,thaw_oth_document_type2 -- 经办人2证件类型2
            ,tran_branch -- 核心交易机构编号
            ,thaw_document_type2 -- 经办人1证件类型2
            ,reserve -- 冲正标识|冲正标识|Y-冲正数据 N-非冲正数据
            ,reaccount_cd -- 对账代码|对账代码
            ,tran_amt -- 交易金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_restraints_hist_op(
            base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,restraint_type -- 限制类型
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,help_option -- 协助执行事项
            ,init_seq_no -- 初始限制流水号
            ,is_frozen -- 是否续冻
            ,last_status -- 前一限制状态
            ,main_flag -- 主、分账户类型标志
            ,narrative -- 摘要
            ,release_law_no -- 解冻机关法律文书号
            ,res_acct_range -- 限制账户范围
            ,res_law_no -- 冻结机关法律文书号
            ,res_priority -- 冻结级别
            ,res_seq_no -- 限制编号
            ,restraint_judiciary_name -- 冻结机关名称
            ,restraints_status -- 限制状态
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,sub_restraint_class -- 子限制类别
            ,system_phase -- 系统所处的阶段
            ,thaw_officer_name -- 经办人1姓名
            ,thaw_oth_officer_name -- 经办人2姓名
            ,under_lien -- 是否抵制押标志
            ,approval_date -- 复核日期
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,deduction_judiciary_name -- 有权机关名称
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
            ,pledged_amt -- 限制金额
            ,release_judiciary_name -- 解冻机关名称
            ,thaw_document_id -- 经办人1证件号码
            ,thaw_document_id2 -- 经办人1证件号码2
            ,thaw_document_type -- 经办人1证件类型1
            ,thaw_oth_document_id -- 经办人2证件号码
            ,thaw_oth_document_id2 -- 经办人2证件号码2
            ,thaw_oth_document_type -- 经办人2证件类型
            ,thaw_oth_document_type2 -- 经办人2证件类型2
            ,tran_branch -- 核心交易机构编号
            ,thaw_document_type2 -- 经办人1证件类型2
            ,reserve -- 冲正标识|冲正标识|Y-冲正数据 N-非冲正数据
            ,reaccount_cd -- 对账代码|对账代码
            ,tran_amt -- 交易金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.reference -- 交易参考号
    ,o.restraint_type -- 限制类型
    ,o.user_id -- 交易柜员编号
    ,o.term -- 存期
    ,o.term_type -- 期限单位
    ,o.channel_seq_no -- 全局流水号
    ,o.company -- 法人
    ,o.help_option -- 协助执行事项
    ,o.init_seq_no -- 初始限制流水号
    ,o.is_frozen -- 是否续冻
    ,o.last_status -- 前一限制状态
    ,o.main_flag -- 主、分账户类型标志
    ,o.narrative -- 摘要
    ,o.release_law_no -- 解冻机关法律文书号
    ,o.res_acct_range -- 限制账户范围
    ,o.res_law_no -- 冻结机关法律文书号
    ,o.res_priority -- 冻结级别
    ,o.res_seq_no -- 限制编号
    ,o.restraint_judiciary_name -- 冻结机关名称
    ,o.restraints_status -- 限制状态
    ,o.seq_no -- 序号
    ,o.source_type -- 渠道编号
    ,o.sub_restraint_class -- 子限制类别
    ,o.system_phase -- 系统所处的阶段
    ,o.thaw_officer_name -- 经办人1姓名
    ,o.thaw_oth_officer_name -- 经办人2姓名
    ,o.under_lien -- 是否抵制押标志
    ,o.approval_date -- 复核日期
    ,o.end_date -- 结束日期
    ,o.last_change_date -- 最后修改日期
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.auth_user_id -- 授权柜员
    ,o.deduction_judiciary_name -- 有权机关名称
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
    ,o.pledged_amt -- 限制金额
    ,o.release_judiciary_name -- 解冻机关名称
    ,o.thaw_document_id -- 经办人1证件号码
    ,o.thaw_document_id2 -- 经办人1证件号码2
    ,o.thaw_document_type -- 经办人1证件类型1
    ,o.thaw_oth_document_id -- 经办人2证件号码
    ,o.thaw_oth_document_id2 -- 经办人2证件号码2
    ,o.thaw_oth_document_type -- 经办人2证件类型
    ,o.thaw_oth_document_type2 -- 经办人2证件类型2
    ,o.tran_branch -- 核心交易机构编号
    ,o.thaw_document_type2 -- 经办人1证件类型2
    ,o.reserve -- 冲正标识|冲正标识|Y-冲正数据 N-非冲正数据
    ,o.reaccount_cd -- 对账代码|对账代码
    ,o.tran_amt -- 交易金额
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
from ${iol_schema}.ncbs_rb_restraints_hist_bk o
    left join ${iol_schema}.ncbs_rb_restraints_hist_op n
        on
            o.seq_no = n.seq_no
            and o.start_date = n.start_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_restraints_hist_cl d
        on
            o.seq_no = d.seq_no
            and o.start_date = d.start_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_restraints_hist;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_restraints_hist') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_restraints_hist drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_restraints_hist add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_restraints_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_restraints_hist_cl;
alter table ${iol_schema}.ncbs_rb_restraints_hist exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_restraints_hist_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_restraints_hist to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_restraints_hist_op purge;
drop table ${iol_schema}.ncbs_rb_restraints_hist_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_restraints_hist_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_restraints_hist',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
