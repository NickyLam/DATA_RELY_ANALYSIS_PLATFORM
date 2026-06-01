/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_recovery_apply
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
create table ${iol_schema}.bdms_cpes_recovery_apply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_recovery_apply;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_recovery_apply_op purge;
drop table ${iol_schema}.bdms_cpes_recovery_apply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_recovery_apply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_recovery_apply where 0=1;

create table ${iol_schema}.bdms_cpes_recovery_apply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_recovery_apply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_recovery_apply_cl(
            id -- 
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,product_no -- 产品号
            ,apply_date -- 申请日期
            ,draft_type -- 票据类型：AC01-银承 AC02-商承
            ,draft_attr -- 票据介质：ME01-纸票 ME02-电票
            ,draft_id -- 票据ID
            ,draft_amount -- 票面金额
            ,remit_date -- 出票日
            ,maturity_date -- 到期日
            ,recoveryrole -- 追偿人类别： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
            ,recovery_crt_no -- 追偿人社会信息用代码
            ,recovery_name -- 追偿人名称
            ,recovery_bank_no -- 追偿人开户行号
            ,recovery_brh_no -- 追偿人机构代码
            ,recept_brh_id -- 追偿人承接机构代码
            ,payer_bank_no -- 付款行行号
            ,payer_sig_nk -- 付款行回复标志： SU00 同意 SU01 拒绝
            ,present_date -- 提示付款日期
            ,present_brh_no -- 提示付款机构代码
            ,present_sigmk -- 提示付款应答代码： SU00 同意 SU01 拒绝
            ,pst_refuse_rsn -- 提示付款拒绝原因： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
            ,pst_settle_rst -- 提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
            ,pst_misc -- 提示付款备注
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,status -- 票据状态
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,settle_result -- 清算结果： R20 结算成功 R21 结算失败 R23 已撤销
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,buss_flag -- 交易方向： 01 申请 02 签收
            ,cash_role -- 兑付机构角色： CR01 承兑保证行 CR02 贴现保证行 CR03 保证增信行 CR04 贴现行 CR05 承兑行
            ,re_recovery_lock_flag -- 再追偿锁定标识： 0 未锁定 1 已锁定
            ,belong_brh_no -- 所属票交所机构号/非法人产品
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_recovery_apply_op(
            id -- 
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,product_no -- 产品号
            ,apply_date -- 申请日期
            ,draft_type -- 票据类型：AC01-银承 AC02-商承
            ,draft_attr -- 票据介质：ME01-纸票 ME02-电票
            ,draft_id -- 票据ID
            ,draft_amount -- 票面金额
            ,remit_date -- 出票日
            ,maturity_date -- 到期日
            ,recoveryrole -- 追偿人类别： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
            ,recovery_crt_no -- 追偿人社会信息用代码
            ,recovery_name -- 追偿人名称
            ,recovery_bank_no -- 追偿人开户行号
            ,recovery_brh_no -- 追偿人机构代码
            ,recept_brh_id -- 追偿人承接机构代码
            ,payer_bank_no -- 付款行行号
            ,payer_sig_nk -- 付款行回复标志： SU00 同意 SU01 拒绝
            ,present_date -- 提示付款日期
            ,present_brh_no -- 提示付款机构代码
            ,present_sigmk -- 提示付款应答代码： SU00 同意 SU01 拒绝
            ,pst_refuse_rsn -- 提示付款拒绝原因： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
            ,pst_settle_rst -- 提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
            ,pst_misc -- 提示付款备注
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,status -- 票据状态
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,settle_result -- 清算结果： R20 结算成功 R21 结算失败 R23 已撤销
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,buss_flag -- 交易方向： 01 申请 02 签收
            ,cash_role -- 兑付机构角色： CR01 承兑保证行 CR02 贴现保证行 CR03 保证增信行 CR04 贴现行 CR05 承兑行
            ,re_recovery_lock_flag -- 再追偿锁定标识： 0 未锁定 1 已锁定
            ,belong_brh_no -- 所属票交所机构号/非法人产品
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 机构号
    ,nvl(n.product_no, o.product_no) as product_no -- 产品号
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 申请日期
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型：AC01-银承 AC02-商承
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据介质：ME01-纸票 ME02-电票
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据ID
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票面金额
    ,nvl(n.remit_date, o.remit_date) as remit_date -- 出票日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日
    ,nvl(n.recoveryrole, o.recoveryrole) as recoveryrole -- 追偿人类别： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,nvl(n.recovery_crt_no, o.recovery_crt_no) as recovery_crt_no -- 追偿人社会信息用代码
    ,nvl(n.recovery_name, o.recovery_name) as recovery_name -- 追偿人名称
    ,nvl(n.recovery_bank_no, o.recovery_bank_no) as recovery_bank_no -- 追偿人开户行号
    ,nvl(n.recovery_brh_no, o.recovery_brh_no) as recovery_brh_no -- 追偿人机构代码
    ,nvl(n.recept_brh_id, o.recept_brh_id) as recept_brh_id -- 追偿人承接机构代码
    ,nvl(n.payer_bank_no, o.payer_bank_no) as payer_bank_no -- 付款行行号
    ,nvl(n.payer_sig_nk, o.payer_sig_nk) as payer_sig_nk -- 付款行回复标志： SU00 同意 SU01 拒绝
    ,nvl(n.present_date, o.present_date) as present_date -- 提示付款日期
    ,nvl(n.present_brh_no, o.present_brh_no) as present_brh_no -- 提示付款机构代码
    ,nvl(n.present_sigmk, o.present_sigmk) as present_sigmk -- 提示付款应答代码： SU00 同意 SU01 拒绝
    ,nvl(n.pst_refuse_rsn, o.pst_refuse_rsn) as pst_refuse_rsn -- 提示付款拒绝原因： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,nvl(n.pst_settle_rst, o.pst_settle_rst) as pst_settle_rst -- 提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,nvl(n.pst_misc, o.pst_misc) as pst_misc -- 提示付款备注
    ,nvl(n.deal_status, o.deal_status) as deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,nvl(n.status, o.status) as status -- 票据状态
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.settle_result, o.settle_result) as settle_result -- 清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,nvl(n.err_code, o.err_code) as err_code -- 错误码
    ,nvl(n.err_msg, o.err_msg) as err_msg -- 错误信息
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作人
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.buss_flag, o.buss_flag) as buss_flag -- 交易方向： 01 申请 02 签收
    ,nvl(n.cash_role, o.cash_role) as cash_role -- 兑付机构角色： CR01 承兑保证行 CR02 贴现保证行 CR03 保证增信行 CR04 贴现行 CR05 承兑行
    ,nvl(n.re_recovery_lock_flag, o.re_recovery_lock_flag) as re_recovery_lock_flag -- 再追偿锁定标识： 0 未锁定 1 已锁定
    ,nvl(n.belong_brh_no, o.belong_brh_no) as belong_brh_no -- 所属票交所机构号/非法人产品
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_cpes_recovery_apply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_recovery_apply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.top_branch_no <> n.top_branch_no
        or o.branch_no <> n.branch_no
        or o.product_no <> n.product_no
        or o.apply_date <> n.apply_date
        or o.draft_type <> n.draft_type
        or o.draft_attr <> n.draft_attr
        or o.draft_id <> n.draft_id
        or o.draft_amount <> n.draft_amount
        or o.remit_date <> n.remit_date
        or o.maturity_date <> n.maturity_date
        or o.recoveryrole <> n.recoveryrole
        or o.recovery_crt_no <> n.recovery_crt_no
        or o.recovery_name <> n.recovery_name
        or o.recovery_bank_no <> n.recovery_bank_no
        or o.recovery_brh_no <> n.recovery_brh_no
        or o.recept_brh_id <> n.recept_brh_id
        or o.payer_bank_no <> n.payer_bank_no
        or o.payer_sig_nk <> n.payer_sig_nk
        or o.present_date <> n.present_date
        or o.present_brh_no <> n.present_brh_no
        or o.present_sigmk <> n.present_sigmk
        or o.pst_refuse_rsn <> n.pst_refuse_rsn
        or o.pst_settle_rst <> n.pst_settle_rst
        or o.pst_misc <> n.pst_misc
        or o.deal_status <> n.deal_status
        or o.status <> n.status
        or o.account_status <> n.account_status
        or o.settle_result <> n.settle_result
        or o.err_code <> n.err_code
        or o.err_msg <> n.err_msg
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.buss_flag <> n.buss_flag
        or o.cash_role <> n.cash_role
        or o.re_recovery_lock_flag <> n.re_recovery_lock_flag
        or o.belong_brh_no <> n.belong_brh_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_recovery_apply_cl(
            id -- 
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,product_no -- 产品号
            ,apply_date -- 申请日期
            ,draft_type -- 票据类型：AC01-银承 AC02-商承
            ,draft_attr -- 票据介质：ME01-纸票 ME02-电票
            ,draft_id -- 票据ID
            ,draft_amount -- 票面金额
            ,remit_date -- 出票日
            ,maturity_date -- 到期日
            ,recoveryrole -- 追偿人类别： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
            ,recovery_crt_no -- 追偿人社会信息用代码
            ,recovery_name -- 追偿人名称
            ,recovery_bank_no -- 追偿人开户行号
            ,recovery_brh_no -- 追偿人机构代码
            ,recept_brh_id -- 追偿人承接机构代码
            ,payer_bank_no -- 付款行行号
            ,payer_sig_nk -- 付款行回复标志： SU00 同意 SU01 拒绝
            ,present_date -- 提示付款日期
            ,present_brh_no -- 提示付款机构代码
            ,present_sigmk -- 提示付款应答代码： SU00 同意 SU01 拒绝
            ,pst_refuse_rsn -- 提示付款拒绝原因： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
            ,pst_settle_rst -- 提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
            ,pst_misc -- 提示付款备注
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,status -- 票据状态
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,settle_result -- 清算结果： R20 结算成功 R21 结算失败 R23 已撤销
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,buss_flag -- 交易方向： 01 申请 02 签收
            ,cash_role -- 兑付机构角色： CR01 承兑保证行 CR02 贴现保证行 CR03 保证增信行 CR04 贴现行 CR05 承兑行
            ,re_recovery_lock_flag -- 再追偿锁定标识： 0 未锁定 1 已锁定
            ,belong_brh_no -- 所属票交所机构号/非法人产品
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_recovery_apply_op(
            id -- 
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,product_no -- 产品号
            ,apply_date -- 申请日期
            ,draft_type -- 票据类型：AC01-银承 AC02-商承
            ,draft_attr -- 票据介质：ME01-纸票 ME02-电票
            ,draft_id -- 票据ID
            ,draft_amount -- 票面金额
            ,remit_date -- 出票日
            ,maturity_date -- 到期日
            ,recoveryrole -- 追偿人类别： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
            ,recovery_crt_no -- 追偿人社会信息用代码
            ,recovery_name -- 追偿人名称
            ,recovery_bank_no -- 追偿人开户行号
            ,recovery_brh_no -- 追偿人机构代码
            ,recept_brh_id -- 追偿人承接机构代码
            ,payer_bank_no -- 付款行行号
            ,payer_sig_nk -- 付款行回复标志： SU00 同意 SU01 拒绝
            ,present_date -- 提示付款日期
            ,present_brh_no -- 提示付款机构代码
            ,present_sigmk -- 提示付款应答代码： SU00 同意 SU01 拒绝
            ,pst_refuse_rsn -- 提示付款拒绝原因： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
            ,pst_settle_rst -- 提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
            ,pst_misc -- 提示付款备注
            ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
            ,status -- 票据状态
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,settle_result -- 清算结果： R20 结算成功 R21 结算失败 R23 已撤销
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,buss_flag -- 交易方向： 01 申请 02 签收
            ,cash_role -- 兑付机构角色： CR01 承兑保证行 CR02 贴现保证行 CR03 保证增信行 CR04 贴现行 CR05 承兑行
            ,re_recovery_lock_flag -- 再追偿锁定标识： 0 未锁定 1 已锁定
            ,belong_brh_no -- 所属票交所机构号/非法人产品
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.top_branch_no -- 总行机构号
    ,o.branch_no -- 机构号
    ,o.product_no -- 产品号
    ,o.apply_date -- 申请日期
    ,o.draft_type -- 票据类型：AC01-银承 AC02-商承
    ,o.draft_attr -- 票据介质：ME01-纸票 ME02-电票
    ,o.draft_id -- 票据ID
    ,o.draft_amount -- 票面金额
    ,o.remit_date -- 出票日
    ,o.maturity_date -- 到期日
    ,o.recoveryrole -- 追偿人类别： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,o.recovery_crt_no -- 追偿人社会信息用代码
    ,o.recovery_name -- 追偿人名称
    ,o.recovery_bank_no -- 追偿人开户行号
    ,o.recovery_brh_no -- 追偿人机构代码
    ,o.recept_brh_id -- 追偿人承接机构代码
    ,o.payer_bank_no -- 付款行行号
    ,o.payer_sig_nk -- 付款行回复标志： SU00 同意 SU01 拒绝
    ,o.present_date -- 提示付款日期
    ,o.present_brh_no -- 提示付款机构代码
    ,o.present_sigmk -- 提示付款应答代码： SU00 同意 SU01 拒绝
    ,o.pst_refuse_rsn -- 提示付款拒绝原因： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,o.pst_settle_rst -- 提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,o.pst_misc -- 提示付款备注
    ,o.deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,o.status -- 票据状态
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.settle_result -- 清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,o.err_code -- 错误码
    ,o.err_msg -- 错误信息
    ,o.last_upd_opr -- 最后操作人
    ,o.last_upd_time -- 最后修改时间
    ,o.buss_flag -- 交易方向： 01 申请 02 签收
    ,o.cash_role -- 兑付机构角色： CR01 承兑保证行 CR02 贴现保证行 CR03 保证增信行 CR04 贴现行 CR05 承兑行
    ,o.re_recovery_lock_flag -- 再追偿锁定标识： 0 未锁定 1 已锁定
    ,o.belong_brh_no -- 所属票交所机构号/非法人产品
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_cpes_recovery_apply_bk o
    left join ${iol_schema}.bdms_cpes_recovery_apply_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_recovery_apply_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.bdms_cpes_recovery_apply;

-- 4.2 exchange partition
alter table ${iol_schema}.bdms_cpes_recovery_apply exchange partition p_19000101 with table ${iol_schema}.bdms_cpes_recovery_apply_cl;
alter table ${iol_schema}.bdms_cpes_recovery_apply exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_recovery_apply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_recovery_apply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_recovery_apply_op purge;
drop table ${iol_schema}.bdms_cpes_recovery_apply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_recovery_apply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_recovery_apply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
