/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_htes_draft_info
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
create table ${iol_schema}.bdms_htes_draft_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_htes_draft_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_htes_draft_info_op purge;
drop table ${iol_schema}.bdms_htes_draft_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_htes_draft_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_htes_draft_info where 0=1;

create table ${iol_schema}.bdms_htes_draft_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_htes_draft_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_htes_draft_info_cl(
            id -- ID
            ,draft_number -- 票据（包）号
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,remit_date -- 出票日期
            ,maturity_date -- 票据到期日期
            ,draft_amount -- 票据（包）金额
            ,remitter_name -- 出票人名称
            ,remitter_account -- 出票人账号
            ,remitter_credit_no -- 出票人社会信用代码
            ,remitter_brh_no -- 出票人开户机构代码
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,acceptor_name -- 承兑人名称
            ,acceptor_account -- 承兑人账号
            ,acceptor_credit_no -- 承兑人社会信用代码
            ,acceptor_brh_no -- 承兑人开户机构代码
            ,acceptor_bank_no -- 承兑人开户行行号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,payee_name -- 收款人名称
            ,payee_account -- 收款人账号
            ,payee_credit_no -- 收款人社会信用代码
            ,payee_brh_no -- 收款人开户机构代码
            ,payee_bank_no -- 收款人开户行行号
            ,payee_bank_name -- 收款人开户行行名
            ,payer_brh_no -- 付款行机构代码
            ,payer_bank_no -- 付款行行号
            ,guarantee_brh_no -- 保证增信行机构代码
            ,payer_confirm_brh_no -- 付款确认机构代码
            ,discount_brh_no -- 贴现行行机构代码
            ,accept_gua_brh_no -- 承兑保证行机构代码
            ,disc_gua_brh_no -- 贴现保证机构代码
            ,store_brh_no -- 库存保管机构代码
            ,flow_status -- 票据流转状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			TF0101 待收票 TF0301 可流通 TF0302 已锁定 TF0303 不可转让 			TF0304 已质押 TF0305 待赎回 TF0401 托收在途 TF0402 追索中 TF0501 已结束 		2,产品中心新增码值： 			TF0999 不可流通 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】
            ,risk_status -- 风险票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,store_status -- 票据库存状态：见中国票据交易系统直连接口规范【概述分册】
            ,status -- 票据状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			CS01 已出票 CS02 已承兑 CS03 已收票 CS04 已到期 CS05 已终止 CS06 已结清 		2,产品中心新增码值： 			CS99 已拆分 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】
            ,org_flow_status -- 原流转状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_risk_status -- 原风险票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_status -- 原票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_store_status -- 原票据库存状态：见中国票据交易系统直连接口规范【概述分册】
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注域
            ,disc_date -- 贴现日期
            ,emerg_flag -- 是否应急票据： 0 否 1 是
            ,bp_no -- 供应链票据包编号
            ,forehand_range -- 前手区间
            ,current_range -- 当前区间
            ,product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,draft_remark -- 票面备注
            ,draft_explain -- 票面说明
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,remitter_mem_no -- 出票人渠道代码
            ,remitter_dist_tp -- 出票人识别类型： DT01 票据账户 DT02 银行账户
            ,remitter_brh_name -- 出票人开户行机构名称
            ,acceptor_mem_no -- 承兑人渠道代码
            ,acceptor_dist_tp -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
            ,acceptor_brh_name -- 承兑人开户行机构名称
            ,payee_mem_no -- 收款人渠道代码
            ,payee_dist_tp -- 收款人识别类型： DT01 票据账户 DT02 银行账户
            ,payee_brh_name -- 收款人开户行机构名称
            ,holder_mem_no -- 持票人渠道代码
            ,holder_name -- 持票人名称
            ,holder_crt_no -- 持票人社会信用代码
            ,holder_dist_tp -- 持票人识别类型： DT01 票据账户 DT02 银行账户
            ,holder_acct_no -- 持票人账号
            ,holder_bank_no -- 持票人开户行行号
            ,holder_bank_name -- 持票人开户行名称
            ,holder_brh_no -- 持票人开户行机构代码
            ,holder_brh_name -- 持票人开户行机构名称
            ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
            ,consignment_code -- 到期无条件委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,owership_flag -- 权属标识
            ,payer_name -- 付款人名称
            ,payer_account -- 付款人账号
            ,payer_credit_no -- 付款人社会信用代码
            ,payer_bank_name -- 付款人开户行名称
            ,payer_mem_no -- 付款人渠道代码
            ,payer_dist_tp -- 付款人识别类型： DT01 票据账户 DT02 银行账户
            ,payer_brh_name -- 付款人开户行机构名称
            ,acceptor_acctname -- 承兑人账户名称
            ,remitter_acctname -- 出票人账户名称
            ,payee_acctname -- 收款人账户名称
            ,create_time -- 创建时间
            ,create_by -- 创建人
            ,remitter_account_name -- 接收人账户名称
            ,acceptor_account_name -- 承兑人账户名称
            ,payee_account_name -- 付款人账户名称
            ,holder_acct_name -- 持票人账户名称
            ,draft_pay_status -- 票据支付状态： 空	PS00 预锁定	PS01 锁定	PS02 即时支付预锁定	PS03 解锁（接收人可签收）	PS04 解锁（发起人可撤销）	PS05 已完成	PS06 已取消	PS07 即时支付锁定	PS08
            ,pay_no -- 票据支付订单编号
            ,settle_date -- 结清日期
            ,migrate_flag -- ECDS迁移票据标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_htes_draft_info_op(
            id -- ID
            ,draft_number -- 票据（包）号
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,remit_date -- 出票日期
            ,maturity_date -- 票据到期日期
            ,draft_amount -- 票据（包）金额
            ,remitter_name -- 出票人名称
            ,remitter_account -- 出票人账号
            ,remitter_credit_no -- 出票人社会信用代码
            ,remitter_brh_no -- 出票人开户机构代码
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,acceptor_name -- 承兑人名称
            ,acceptor_account -- 承兑人账号
            ,acceptor_credit_no -- 承兑人社会信用代码
            ,acceptor_brh_no -- 承兑人开户机构代码
            ,acceptor_bank_no -- 承兑人开户行行号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,payee_name -- 收款人名称
            ,payee_account -- 收款人账号
            ,payee_credit_no -- 收款人社会信用代码
            ,payee_brh_no -- 收款人开户机构代码
            ,payee_bank_no -- 收款人开户行行号
            ,payee_bank_name -- 收款人开户行行名
            ,payer_brh_no -- 付款行机构代码
            ,payer_bank_no -- 付款行行号
            ,guarantee_brh_no -- 保证增信行机构代码
            ,payer_confirm_brh_no -- 付款确认机构代码
            ,discount_brh_no -- 贴现行行机构代码
            ,accept_gua_brh_no -- 承兑保证行机构代码
            ,disc_gua_brh_no -- 贴现保证机构代码
            ,store_brh_no -- 库存保管机构代码
            ,flow_status -- 票据流转状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			TF0101 待收票 TF0301 可流通 TF0302 已锁定 TF0303 不可转让 			TF0304 已质押 TF0305 待赎回 TF0401 托收在途 TF0402 追索中 TF0501 已结束 		2,产品中心新增码值： 			TF0999 不可流通 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】
            ,risk_status -- 风险票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,store_status -- 票据库存状态：见中国票据交易系统直连接口规范【概述分册】
            ,status -- 票据状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			CS01 已出票 CS02 已承兑 CS03 已收票 CS04 已到期 CS05 已终止 CS06 已结清 		2,产品中心新增码值： 			CS99 已拆分 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】
            ,org_flow_status -- 原流转状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_risk_status -- 原风险票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_status -- 原票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_store_status -- 原票据库存状态：见中国票据交易系统直连接口规范【概述分册】
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注域
            ,disc_date -- 贴现日期
            ,emerg_flag -- 是否应急票据： 0 否 1 是
            ,bp_no -- 供应链票据包编号
            ,forehand_range -- 前手区间
            ,current_range -- 当前区间
            ,product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,draft_remark -- 票面备注
            ,draft_explain -- 票面说明
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,remitter_mem_no -- 出票人渠道代码
            ,remitter_dist_tp -- 出票人识别类型： DT01 票据账户 DT02 银行账户
            ,remitter_brh_name -- 出票人开户行机构名称
            ,acceptor_mem_no -- 承兑人渠道代码
            ,acceptor_dist_tp -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
            ,acceptor_brh_name -- 承兑人开户行机构名称
            ,payee_mem_no -- 收款人渠道代码
            ,payee_dist_tp -- 收款人识别类型： DT01 票据账户 DT02 银行账户
            ,payee_brh_name -- 收款人开户行机构名称
            ,holder_mem_no -- 持票人渠道代码
            ,holder_name -- 持票人名称
            ,holder_crt_no -- 持票人社会信用代码
            ,holder_dist_tp -- 持票人识别类型： DT01 票据账户 DT02 银行账户
            ,holder_acct_no -- 持票人账号
            ,holder_bank_no -- 持票人开户行行号
            ,holder_bank_name -- 持票人开户行名称
            ,holder_brh_no -- 持票人开户行机构代码
            ,holder_brh_name -- 持票人开户行机构名称
            ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
            ,consignment_code -- 到期无条件委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,owership_flag -- 权属标识
            ,payer_name -- 付款人名称
            ,payer_account -- 付款人账号
            ,payer_credit_no -- 付款人社会信用代码
            ,payer_bank_name -- 付款人开户行名称
            ,payer_mem_no -- 付款人渠道代码
            ,payer_dist_tp -- 付款人识别类型： DT01 票据账户 DT02 银行账户
            ,payer_brh_name -- 付款人开户行机构名称
            ,acceptor_acctname -- 承兑人账户名称
            ,remitter_acctname -- 出票人账户名称
            ,payee_acctname -- 收款人账户名称
            ,create_time -- 创建时间
            ,create_by -- 创建人
            ,remitter_account_name -- 接收人账户名称
            ,acceptor_account_name -- 承兑人账户名称
            ,payee_account_name -- 付款人账户名称
            ,holder_acct_name -- 持票人账户名称
            ,draft_pay_status -- 票据支付状态： 空	PS00 预锁定	PS01 锁定	PS02 即时支付预锁定	PS03 解锁（接收人可签收）	PS04 解锁（发起人可撤销）	PS05 已完成	PS06 已取消	PS07 即时支付锁定	PS08
            ,pay_no -- 票据支付订单编号
            ,settle_date -- 结清日期
            ,migrate_flag -- ECDS迁移票据标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据（包）号
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： AC01 银承 AC02 商承
    ,nvl(n.remit_date, o.remit_date) as remit_date -- 出票日期
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 票据到期日期
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票据（包）金额
    ,nvl(n.remitter_name, o.remitter_name) as remitter_name -- 出票人名称
    ,nvl(n.remitter_account, o.remitter_account) as remitter_account -- 出票人账号
    ,nvl(n.remitter_credit_no, o.remitter_credit_no) as remitter_credit_no -- 出票人社会信用代码
    ,nvl(n.remitter_brh_no, o.remitter_brh_no) as remitter_brh_no -- 出票人开户机构代码
    ,nvl(n.remitter_bank_no, o.remitter_bank_no) as remitter_bank_no -- 出票人开户行行号
    ,nvl(n.remitter_bank_name, o.remitter_bank_name) as remitter_bank_name -- 出票人开户行名称
    ,nvl(n.acceptor_name, o.acceptor_name) as acceptor_name -- 承兑人名称
    ,nvl(n.acceptor_account, o.acceptor_account) as acceptor_account -- 承兑人账号
    ,nvl(n.acceptor_credit_no, o.acceptor_credit_no) as acceptor_credit_no -- 承兑人社会信用代码
    ,nvl(n.acceptor_brh_no, o.acceptor_brh_no) as acceptor_brh_no -- 承兑人开户机构代码
    ,nvl(n.acceptor_bank_no, o.acceptor_bank_no) as acceptor_bank_no -- 承兑人开户行行号
    ,nvl(n.acceptor_bank_name, o.acceptor_bank_name) as acceptor_bank_name -- 承兑人开户行名称
    ,nvl(n.payee_name, o.payee_name) as payee_name -- 收款人名称
    ,nvl(n.payee_account, o.payee_account) as payee_account -- 收款人账号
    ,nvl(n.payee_credit_no, o.payee_credit_no) as payee_credit_no -- 收款人社会信用代码
    ,nvl(n.payee_brh_no, o.payee_brh_no) as payee_brh_no -- 收款人开户机构代码
    ,nvl(n.payee_bank_no, o.payee_bank_no) as payee_bank_no -- 收款人开户行行号
    ,nvl(n.payee_bank_name, o.payee_bank_name) as payee_bank_name -- 收款人开户行行名
    ,nvl(n.payer_brh_no, o.payer_brh_no) as payer_brh_no -- 付款行机构代码
    ,nvl(n.payer_bank_no, o.payer_bank_no) as payer_bank_no -- 付款行行号
    ,nvl(n.guarantee_brh_no, o.guarantee_brh_no) as guarantee_brh_no -- 保证增信行机构代码
    ,nvl(n.payer_confirm_brh_no, o.payer_confirm_brh_no) as payer_confirm_brh_no -- 付款确认机构代码
    ,nvl(n.discount_brh_no, o.discount_brh_no) as discount_brh_no -- 贴现行行机构代码
    ,nvl(n.accept_gua_brh_no, o.accept_gua_brh_no) as accept_gua_brh_no -- 承兑保证行机构代码
    ,nvl(n.disc_gua_brh_no, o.disc_gua_brh_no) as disc_gua_brh_no -- 贴现保证机构代码
    ,nvl(n.store_brh_no, o.store_brh_no) as store_brh_no -- 库存保管机构代码
    ,nvl(n.flow_status, o.flow_status) as flow_status -- 票据流转状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			TF0101 待收票 TF0301 可流通 TF0302 已锁定 TF0303 不可转让 			TF0304 已质押 TF0305 待赎回 TF0401 托收在途 TF0402 追索中 TF0501 已结束 		2,产品中心新增码值： 			TF0999 不可流通 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】
    ,nvl(n.risk_status, o.risk_status) as risk_status -- 风险票据状态：见中国票据交易系统直连接口规范【概述分册】
    ,nvl(n.store_status, o.store_status) as store_status -- 票据库存状态：见中国票据交易系统直连接口规范【概述分册】
    ,nvl(n.status, o.status) as status -- 票据状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			CS01 已出票 CS02 已承兑 CS03 已收票 CS04 已到期 CS05 已终止 CS06 已结清 		2,产品中心新增码值： 			CS99 已拆分 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】
    ,nvl(n.org_flow_status, o.org_flow_status) as org_flow_status -- 原流转状态：见中国票据交易系统直连接口规范【概述分册】
    ,nvl(n.org_risk_status, o.org_risk_status) as org_risk_status -- 原风险票据状态：见中国票据交易系统直连接口规范【概述分册】
    ,nvl(n.org_status, o.org_status) as org_status -- 原票据状态：见中国票据交易系统直连接口规范【概述分册】
    ,nvl(n.org_store_status, o.org_store_status) as org_store_status -- 原票据库存状态：见中国票据交易系统直连接口规范【概述分册】
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注域
    ,nvl(n.disc_date, o.disc_date) as disc_date -- 贴现日期
    ,nvl(n.emerg_flag, o.emerg_flag) as emerg_flag -- 是否应急票据： 0 否 1 是
    ,nvl(n.bp_no, o.bp_no) as bp_no -- 供应链票据包编号
    ,nvl(n.forehand_range, o.forehand_range) as forehand_range -- 前手区间
    ,nvl(n.current_range, o.current_range) as current_range -- 当前区间
    ,nvl(n.product_type, o.product_type) as product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
    ,nvl(n.cd_range, o.cd_range) as cd_range -- 子票区间
    ,nvl(n.standard_amt, o.standard_amt) as standard_amt -- 标准金额
    ,nvl(n.draft_remark, o.draft_remark) as draft_remark -- 票面备注
    ,nvl(n.draft_explain, o.draft_explain) as draft_explain -- 票面说明
    ,nvl(n.cd_split, o.cd_split) as cd_split -- 是否允许分包流转： 0 否 1 是
    ,nvl(n.remitter_mem_no, o.remitter_mem_no) as remitter_mem_no -- 出票人渠道代码
    ,nvl(n.remitter_dist_tp, o.remitter_dist_tp) as remitter_dist_tp -- 出票人识别类型： DT01 票据账户 DT02 银行账户
    ,nvl(n.remitter_brh_name, o.remitter_brh_name) as remitter_brh_name -- 出票人开户行机构名称
    ,nvl(n.acceptor_mem_no, o.acceptor_mem_no) as acceptor_mem_no -- 承兑人渠道代码
    ,nvl(n.acceptor_dist_tp, o.acceptor_dist_tp) as acceptor_dist_tp -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
    ,nvl(n.acceptor_brh_name, o.acceptor_brh_name) as acceptor_brh_name -- 承兑人开户行机构名称
    ,nvl(n.payee_mem_no, o.payee_mem_no) as payee_mem_no -- 收款人渠道代码
    ,nvl(n.payee_dist_tp, o.payee_dist_tp) as payee_dist_tp -- 收款人识别类型： DT01 票据账户 DT02 银行账户
    ,nvl(n.payee_brh_name, o.payee_brh_name) as payee_brh_name -- 收款人开户行机构名称
    ,nvl(n.holder_mem_no, o.holder_mem_no) as holder_mem_no -- 持票人渠道代码
    ,nvl(n.holder_name, o.holder_name) as holder_name -- 持票人名称
    ,nvl(n.holder_crt_no, o.holder_crt_no) as holder_crt_no -- 持票人社会信用代码
    ,nvl(n.holder_dist_tp, o.holder_dist_tp) as holder_dist_tp -- 持票人识别类型： DT01 票据账户 DT02 银行账户
    ,nvl(n.holder_acct_no, o.holder_acct_no) as holder_acct_no -- 持票人账号
    ,nvl(n.holder_bank_no, o.holder_bank_no) as holder_bank_no -- 持票人开户行行号
    ,nvl(n.holder_bank_name, o.holder_bank_name) as holder_bank_name -- 持票人开户行名称
    ,nvl(n.holder_brh_no, o.holder_brh_no) as holder_brh_no -- 持票人开户行机构代码
    ,nvl(n.holder_brh_name, o.holder_brh_name) as holder_brh_name -- 持票人开户行机构名称
    ,nvl(n.transfer_flag, o.transfer_flag) as transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
    ,nvl(n.consignment_code, o.consignment_code) as consignment_code -- 到期无条件委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
    ,nvl(n.owership_flag, o.owership_flag) as owership_flag -- 权属标识
    ,nvl(n.payer_name, o.payer_name) as payer_name -- 付款人名称
    ,nvl(n.payer_account, o.payer_account) as payer_account -- 付款人账号
    ,nvl(n.payer_credit_no, o.payer_credit_no) as payer_credit_no -- 付款人社会信用代码
    ,nvl(n.payer_bank_name, o.payer_bank_name) as payer_bank_name -- 付款人开户行名称
    ,nvl(n.payer_mem_no, o.payer_mem_no) as payer_mem_no -- 付款人渠道代码
    ,nvl(n.payer_dist_tp, o.payer_dist_tp) as payer_dist_tp -- 付款人识别类型： DT01 票据账户 DT02 银行账户
    ,nvl(n.payer_brh_name, o.payer_brh_name) as payer_brh_name -- 付款人开户行机构名称
    ,nvl(n.acceptor_acctname, o.acceptor_acctname) as acceptor_acctname -- 承兑人账户名称
    ,nvl(n.remitter_acctname, o.remitter_acctname) as remitter_acctname -- 出票人账户名称
    ,nvl(n.payee_acctname, o.payee_acctname) as payee_acctname -- 收款人账户名称
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.create_by, o.create_by) as create_by -- 创建人
    ,nvl(n.remitter_account_name, o.remitter_account_name) as remitter_account_name -- 接收人账户名称
    ,nvl(n.acceptor_account_name, o.acceptor_account_name) as acceptor_account_name -- 承兑人账户名称
    ,nvl(n.payee_account_name, o.payee_account_name) as payee_account_name -- 付款人账户名称
    ,nvl(n.holder_acct_name, o.holder_acct_name) as holder_acct_name -- 持票人账户名称
    ,nvl(n.draft_pay_status, o.draft_pay_status) as draft_pay_status -- 票据支付状态： 空	PS00 预锁定	PS01 锁定	PS02 即时支付预锁定	PS03 解锁（接收人可签收）	PS04 解锁（发起人可撤销）	PS05 已完成	PS06 已取消	PS07 即时支付锁定	PS08
    ,nvl(n.pay_no, o.pay_no) as pay_no -- 票据支付订单编号
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 结清日期
    ,nvl(n.migrate_flag, o.migrate_flag) as migrate_flag -- ECDS迁移票据标志
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
from (select * from ${iol_schema}.bdms_htes_draft_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_htes_draft_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.draft_number <> n.draft_number
        or o.draft_attr <> n.draft_attr
        or o.draft_type <> n.draft_type
        or o.remit_date <> n.remit_date
        or o.maturity_date <> n.maturity_date
        or o.draft_amount <> n.draft_amount
        or o.remitter_name <> n.remitter_name
        or o.remitter_account <> n.remitter_account
        or o.remitter_credit_no <> n.remitter_credit_no
        or o.remitter_brh_no <> n.remitter_brh_no
        or o.remitter_bank_no <> n.remitter_bank_no
        or o.remitter_bank_name <> n.remitter_bank_name
        or o.acceptor_name <> n.acceptor_name
        or o.acceptor_account <> n.acceptor_account
        or o.acceptor_credit_no <> n.acceptor_credit_no
        or o.acceptor_brh_no <> n.acceptor_brh_no
        or o.acceptor_bank_no <> n.acceptor_bank_no
        or o.acceptor_bank_name <> n.acceptor_bank_name
        or o.payee_name <> n.payee_name
        or o.payee_account <> n.payee_account
        or o.payee_credit_no <> n.payee_credit_no
        or o.payee_brh_no <> n.payee_brh_no
        or o.payee_bank_no <> n.payee_bank_no
        or o.payee_bank_name <> n.payee_bank_name
        or o.payer_brh_no <> n.payer_brh_no
        or o.payer_bank_no <> n.payer_bank_no
        or o.guarantee_brh_no <> n.guarantee_brh_no
        or o.payer_confirm_brh_no <> n.payer_confirm_brh_no
        or o.discount_brh_no <> n.discount_brh_no
        or o.accept_gua_brh_no <> n.accept_gua_brh_no
        or o.disc_gua_brh_no <> n.disc_gua_brh_no
        or o.store_brh_no <> n.store_brh_no
        or o.flow_status <> n.flow_status
        or o.risk_status <> n.risk_status
        or o.store_status <> n.store_status
        or o.status <> n.status
        or o.org_flow_status <> n.org_flow_status
        or o.org_risk_status <> n.org_risk_status
        or o.org_status <> n.org_status
        or o.org_store_status <> n.org_store_status
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.disc_date <> n.disc_date
        or o.emerg_flag <> n.emerg_flag
        or o.bp_no <> n.bp_no
        or o.forehand_range <> n.forehand_range
        or o.current_range <> n.current_range
        or o.product_type <> n.product_type
        or o.cd_range <> n.cd_range
        or o.standard_amt <> n.standard_amt
        or o.draft_remark <> n.draft_remark
        or o.draft_explain <> n.draft_explain
        or o.cd_split <> n.cd_split
        or o.remitter_mem_no <> n.remitter_mem_no
        or o.remitter_dist_tp <> n.remitter_dist_tp
        or o.remitter_brh_name <> n.remitter_brh_name
        or o.acceptor_mem_no <> n.acceptor_mem_no
        or o.acceptor_dist_tp <> n.acceptor_dist_tp
        or o.acceptor_brh_name <> n.acceptor_brh_name
        or o.payee_mem_no <> n.payee_mem_no
        or o.payee_dist_tp <> n.payee_dist_tp
        or o.payee_brh_name <> n.payee_brh_name
        or o.holder_mem_no <> n.holder_mem_no
        or o.holder_name <> n.holder_name
        or o.holder_crt_no <> n.holder_crt_no
        or o.holder_dist_tp <> n.holder_dist_tp
        or o.holder_acct_no <> n.holder_acct_no
        or o.holder_bank_no <> n.holder_bank_no
        or o.holder_bank_name <> n.holder_bank_name
        or o.holder_brh_no <> n.holder_brh_no
        or o.holder_brh_name <> n.holder_brh_name
        or o.transfer_flag <> n.transfer_flag
        or o.consignment_code <> n.consignment_code
        or o.owership_flag <> n.owership_flag
        or o.payer_name <> n.payer_name
        or o.payer_account <> n.payer_account
        or o.payer_credit_no <> n.payer_credit_no
        or o.payer_bank_name <> n.payer_bank_name
        or o.payer_mem_no <> n.payer_mem_no
        or o.payer_dist_tp <> n.payer_dist_tp
        or o.payer_brh_name <> n.payer_brh_name
        or o.acceptor_acctname <> n.acceptor_acctname
        or o.remitter_acctname <> n.remitter_acctname
        or o.payee_acctname <> n.payee_acctname
        or o.create_time <> n.create_time
        or o.create_by <> n.create_by
        or o.remitter_account_name <> n.remitter_account_name
        or o.acceptor_account_name <> n.acceptor_account_name
        or o.payee_account_name <> n.payee_account_name
        or o.holder_acct_name <> n.holder_acct_name
        or o.draft_pay_status <> n.draft_pay_status
        or o.pay_no <> n.pay_no
        or o.settle_date <> n.settle_date
        or o.migrate_flag <> n.migrate_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_htes_draft_info_cl(
            id -- ID
            ,draft_number -- 票据（包）号
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,remit_date -- 出票日期
            ,maturity_date -- 票据到期日期
            ,draft_amount -- 票据（包）金额
            ,remitter_name -- 出票人名称
            ,remitter_account -- 出票人账号
            ,remitter_credit_no -- 出票人社会信用代码
            ,remitter_brh_no -- 出票人开户机构代码
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,acceptor_name -- 承兑人名称
            ,acceptor_account -- 承兑人账号
            ,acceptor_credit_no -- 承兑人社会信用代码
            ,acceptor_brh_no -- 承兑人开户机构代码
            ,acceptor_bank_no -- 承兑人开户行行号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,payee_name -- 收款人名称
            ,payee_account -- 收款人账号
            ,payee_credit_no -- 收款人社会信用代码
            ,payee_brh_no -- 收款人开户机构代码
            ,payee_bank_no -- 收款人开户行行号
            ,payee_bank_name -- 收款人开户行行名
            ,payer_brh_no -- 付款行机构代码
            ,payer_bank_no -- 付款行行号
            ,guarantee_brh_no -- 保证增信行机构代码
            ,payer_confirm_brh_no -- 付款确认机构代码
            ,discount_brh_no -- 贴现行行机构代码
            ,accept_gua_brh_no -- 承兑保证行机构代码
            ,disc_gua_brh_no -- 贴现保证机构代码
            ,store_brh_no -- 库存保管机构代码
            ,flow_status -- 票据流转状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			TF0101 待收票 TF0301 可流通 TF0302 已锁定 TF0303 不可转让 			TF0304 已质押 TF0305 待赎回 TF0401 托收在途 TF0402 追索中 TF0501 已结束 		2,产品中心新增码值： 			TF0999 不可流通 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】
            ,risk_status -- 风险票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,store_status -- 票据库存状态：见中国票据交易系统直连接口规范【概述分册】
            ,status -- 票据状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			CS01 已出票 CS02 已承兑 CS03 已收票 CS04 已到期 CS05 已终止 CS06 已结清 		2,产品中心新增码值： 			CS99 已拆分 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】
            ,org_flow_status -- 原流转状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_risk_status -- 原风险票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_status -- 原票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_store_status -- 原票据库存状态：见中国票据交易系统直连接口规范【概述分册】
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注域
            ,disc_date -- 贴现日期
            ,emerg_flag -- 是否应急票据： 0 否 1 是
            ,bp_no -- 供应链票据包编号
            ,forehand_range -- 前手区间
            ,current_range -- 当前区间
            ,product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,draft_remark -- 票面备注
            ,draft_explain -- 票面说明
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,remitter_mem_no -- 出票人渠道代码
            ,remitter_dist_tp -- 出票人识别类型： DT01 票据账户 DT02 银行账户
            ,remitter_brh_name -- 出票人开户行机构名称
            ,acceptor_mem_no -- 承兑人渠道代码
            ,acceptor_dist_tp -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
            ,acceptor_brh_name -- 承兑人开户行机构名称
            ,payee_mem_no -- 收款人渠道代码
            ,payee_dist_tp -- 收款人识别类型： DT01 票据账户 DT02 银行账户
            ,payee_brh_name -- 收款人开户行机构名称
            ,holder_mem_no -- 持票人渠道代码
            ,holder_name -- 持票人名称
            ,holder_crt_no -- 持票人社会信用代码
            ,holder_dist_tp -- 持票人识别类型： DT01 票据账户 DT02 银行账户
            ,holder_acct_no -- 持票人账号
            ,holder_bank_no -- 持票人开户行行号
            ,holder_bank_name -- 持票人开户行名称
            ,holder_brh_no -- 持票人开户行机构代码
            ,holder_brh_name -- 持票人开户行机构名称
            ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
            ,consignment_code -- 到期无条件委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,owership_flag -- 权属标识
            ,payer_name -- 付款人名称
            ,payer_account -- 付款人账号
            ,payer_credit_no -- 付款人社会信用代码
            ,payer_bank_name -- 付款人开户行名称
            ,payer_mem_no -- 付款人渠道代码
            ,payer_dist_tp -- 付款人识别类型： DT01 票据账户 DT02 银行账户
            ,payer_brh_name -- 付款人开户行机构名称
            ,acceptor_acctname -- 承兑人账户名称
            ,remitter_acctname -- 出票人账户名称
            ,payee_acctname -- 收款人账户名称
            ,create_time -- 创建时间
            ,create_by -- 创建人
            ,remitter_account_name -- 接收人账户名称
            ,acceptor_account_name -- 承兑人账户名称
            ,payee_account_name -- 付款人账户名称
            ,holder_acct_name -- 持票人账户名称
            ,draft_pay_status -- 票据支付状态： 空	PS00 预锁定	PS01 锁定	PS02 即时支付预锁定	PS03 解锁（接收人可签收）	PS04 解锁（发起人可撤销）	PS05 已完成	PS06 已取消	PS07 即时支付锁定	PS08
            ,pay_no -- 票据支付订单编号
            ,settle_date -- 结清日期
            ,migrate_flag -- ECDS迁移票据标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_htes_draft_info_op(
            id -- ID
            ,draft_number -- 票据（包）号
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,remit_date -- 出票日期
            ,maturity_date -- 票据到期日期
            ,draft_amount -- 票据（包）金额
            ,remitter_name -- 出票人名称
            ,remitter_account -- 出票人账号
            ,remitter_credit_no -- 出票人社会信用代码
            ,remitter_brh_no -- 出票人开户机构代码
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,acceptor_name -- 承兑人名称
            ,acceptor_account -- 承兑人账号
            ,acceptor_credit_no -- 承兑人社会信用代码
            ,acceptor_brh_no -- 承兑人开户机构代码
            ,acceptor_bank_no -- 承兑人开户行行号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,payee_name -- 收款人名称
            ,payee_account -- 收款人账号
            ,payee_credit_no -- 收款人社会信用代码
            ,payee_brh_no -- 收款人开户机构代码
            ,payee_bank_no -- 收款人开户行行号
            ,payee_bank_name -- 收款人开户行行名
            ,payer_brh_no -- 付款行机构代码
            ,payer_bank_no -- 付款行行号
            ,guarantee_brh_no -- 保证增信行机构代码
            ,payer_confirm_brh_no -- 付款确认机构代码
            ,discount_brh_no -- 贴现行行机构代码
            ,accept_gua_brh_no -- 承兑保证行机构代码
            ,disc_gua_brh_no -- 贴现保证机构代码
            ,store_brh_no -- 库存保管机构代码
            ,flow_status -- 票据流转状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			TF0101 待收票 TF0301 可流通 TF0302 已锁定 TF0303 不可转让 			TF0304 已质押 TF0305 待赎回 TF0401 托收在途 TF0402 追索中 TF0501 已结束 		2,产品中心新增码值： 			TF0999 不可流通 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】
            ,risk_status -- 风险票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,store_status -- 票据库存状态：见中国票据交易系统直连接口规范【概述分册】
            ,status -- 票据状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			CS01 已出票 CS02 已承兑 CS03 已收票 CS04 已到期 CS05 已终止 CS06 已结清 		2,产品中心新增码值： 			CS99 已拆分 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】
            ,org_flow_status -- 原流转状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_risk_status -- 原风险票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_status -- 原票据状态：见中国票据交易系统直连接口规范【概述分册】
            ,org_store_status -- 原票据库存状态：见中国票据交易系统直连接口规范【概述分册】
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注域
            ,disc_date -- 贴现日期
            ,emerg_flag -- 是否应急票据： 0 否 1 是
            ,bp_no -- 供应链票据包编号
            ,forehand_range -- 前手区间
            ,current_range -- 当前区间
            ,product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,cd_range -- 子票区间
            ,standard_amt -- 标准金额
            ,draft_remark -- 票面备注
            ,draft_explain -- 票面说明
            ,cd_split -- 是否允许分包流转： 0 否 1 是
            ,remitter_mem_no -- 出票人渠道代码
            ,remitter_dist_tp -- 出票人识别类型： DT01 票据账户 DT02 银行账户
            ,remitter_brh_name -- 出票人开户行机构名称
            ,acceptor_mem_no -- 承兑人渠道代码
            ,acceptor_dist_tp -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
            ,acceptor_brh_name -- 承兑人开户行机构名称
            ,payee_mem_no -- 收款人渠道代码
            ,payee_dist_tp -- 收款人识别类型： DT01 票据账户 DT02 银行账户
            ,payee_brh_name -- 收款人开户行机构名称
            ,holder_mem_no -- 持票人渠道代码
            ,holder_name -- 持票人名称
            ,holder_crt_no -- 持票人社会信用代码
            ,holder_dist_tp -- 持票人识别类型： DT01 票据账户 DT02 银行账户
            ,holder_acct_no -- 持票人账号
            ,holder_bank_no -- 持票人开户行行号
            ,holder_bank_name -- 持票人开户行名称
            ,holder_brh_no -- 持票人开户行机构代码
            ,holder_brh_name -- 持票人开户行机构名称
            ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
            ,consignment_code -- 到期无条件委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
            ,owership_flag -- 权属标识
            ,payer_name -- 付款人名称
            ,payer_account -- 付款人账号
            ,payer_credit_no -- 付款人社会信用代码
            ,payer_bank_name -- 付款人开户行名称
            ,payer_mem_no -- 付款人渠道代码
            ,payer_dist_tp -- 付款人识别类型： DT01 票据账户 DT02 银行账户
            ,payer_brh_name -- 付款人开户行机构名称
            ,acceptor_acctname -- 承兑人账户名称
            ,remitter_acctname -- 出票人账户名称
            ,payee_acctname -- 收款人账户名称
            ,create_time -- 创建时间
            ,create_by -- 创建人
            ,remitter_account_name -- 接收人账户名称
            ,acceptor_account_name -- 承兑人账户名称
            ,payee_account_name -- 付款人账户名称
            ,holder_acct_name -- 持票人账户名称
            ,draft_pay_status -- 票据支付状态： 空	PS00 预锁定	PS01 锁定	PS02 即时支付预锁定	PS03 解锁（接收人可签收）	PS04 解锁（发起人可撤销）	PS05 已完成	PS06 已取消	PS07 即时支付锁定	PS08
            ,pay_no -- 票据支付订单编号
            ,settle_date -- 结清日期
            ,migrate_flag -- ECDS迁移票据标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.draft_number -- 票据（包）号
    ,o.draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,o.draft_type -- 票据类型： AC01 银承 AC02 商承
    ,o.remit_date -- 出票日期
    ,o.maturity_date -- 票据到期日期
    ,o.draft_amount -- 票据（包）金额
    ,o.remitter_name -- 出票人名称
    ,o.remitter_account -- 出票人账号
    ,o.remitter_credit_no -- 出票人社会信用代码
    ,o.remitter_brh_no -- 出票人开户机构代码
    ,o.remitter_bank_no -- 出票人开户行行号
    ,o.remitter_bank_name -- 出票人开户行名称
    ,o.acceptor_name -- 承兑人名称
    ,o.acceptor_account -- 承兑人账号
    ,o.acceptor_credit_no -- 承兑人社会信用代码
    ,o.acceptor_brh_no -- 承兑人开户机构代码
    ,o.acceptor_bank_no -- 承兑人开户行行号
    ,o.acceptor_bank_name -- 承兑人开户行名称
    ,o.payee_name -- 收款人名称
    ,o.payee_account -- 收款人账号
    ,o.payee_credit_no -- 收款人社会信用代码
    ,o.payee_brh_no -- 收款人开户机构代码
    ,o.payee_bank_no -- 收款人开户行行号
    ,o.payee_bank_name -- 收款人开户行行名
    ,o.payer_brh_no -- 付款行机构代码
    ,o.payer_bank_no -- 付款行行号
    ,o.guarantee_brh_no -- 保证增信行机构代码
    ,o.payer_confirm_brh_no -- 付款确认机构代码
    ,o.discount_brh_no -- 贴现行行机构代码
    ,o.accept_gua_brh_no -- 承兑保证行机构代码
    ,o.disc_gua_brh_no -- 贴现保证机构代码
    ,o.store_brh_no -- 库存保管机构代码
    ,o.flow_status -- 票据流转状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			TF0101 待收票 TF0301 可流通 TF0302 已锁定 TF0303 不可转让 			TF0304 已质押 TF0305 待赎回 TF0401 托收在途 TF0402 追索中 TF0501 已结束 		2,产品中心新增码值： 			TF0999 不可流通 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】
    ,o.risk_status -- 风险票据状态：见中国票据交易系统直连接口规范【概述分册】
    ,o.store_status -- 票据库存状态：见中国票据交易系统直连接口规范【概述分册】
    ,o.status -- 票据状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			CS01 已出票 CS02 已承兑 CS03 已收票 CS04 已到期 CS05 已终止 CS06 已结清 		2,产品中心新增码值： 			CS99 已拆分 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】
    ,o.org_flow_status -- 原流转状态：见中国票据交易系统直连接口规范【概述分册】
    ,o.org_risk_status -- 原风险票据状态：见中国票据交易系统直连接口规范【概述分册】
    ,o.org_status -- 原票据状态：见中国票据交易系统直连接口规范【概述分册】
    ,o.org_store_status -- 原票据库存状态：见中国票据交易系统直连接口规范【概述分册】
    ,o.last_upd_opr -- 最后操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注域
    ,o.disc_date -- 贴现日期
    ,o.emerg_flag -- 是否应急票据： 0 否 1 是
    ,o.bp_no -- 供应链票据包编号
    ,o.forehand_range -- 前手区间
    ,o.current_range -- 当前区间
    ,o.product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
    ,o.cd_range -- 子票区间
    ,o.standard_amt -- 标准金额
    ,o.draft_remark -- 票面备注
    ,o.draft_explain -- 票面说明
    ,o.cd_split -- 是否允许分包流转： 0 否 1 是
    ,o.remitter_mem_no -- 出票人渠道代码
    ,o.remitter_dist_tp -- 出票人识别类型： DT01 票据账户 DT02 银行账户
    ,o.remitter_brh_name -- 出票人开户行机构名称
    ,o.acceptor_mem_no -- 承兑人渠道代码
    ,o.acceptor_dist_tp -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
    ,o.acceptor_brh_name -- 承兑人开户行机构名称
    ,o.payee_mem_no -- 收款人渠道代码
    ,o.payee_dist_tp -- 收款人识别类型： DT01 票据账户 DT02 银行账户
    ,o.payee_brh_name -- 收款人开户行机构名称
    ,o.holder_mem_no -- 持票人渠道代码
    ,o.holder_name -- 持票人名称
    ,o.holder_crt_no -- 持票人社会信用代码
    ,o.holder_dist_tp -- 持票人识别类型： DT01 票据账户 DT02 银行账户
    ,o.holder_acct_no -- 持票人账号
    ,o.holder_bank_no -- 持票人开户行行号
    ,o.holder_bank_name -- 持票人开户行名称
    ,o.holder_brh_no -- 持票人开户行机构代码
    ,o.holder_brh_name -- 持票人开户行机构名称
    ,o.transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
    ,o.consignment_code -- 到期无条件委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
    ,o.owership_flag -- 权属标识
    ,o.payer_name -- 付款人名称
    ,o.payer_account -- 付款人账号
    ,o.payer_credit_no -- 付款人社会信用代码
    ,o.payer_bank_name -- 付款人开户行名称
    ,o.payer_mem_no -- 付款人渠道代码
    ,o.payer_dist_tp -- 付款人识别类型： DT01 票据账户 DT02 银行账户
    ,o.payer_brh_name -- 付款人开户行机构名称
    ,o.acceptor_acctname -- 承兑人账户名称
    ,o.remitter_acctname -- 出票人账户名称
    ,o.payee_acctname -- 收款人账户名称
    ,o.create_time -- 创建时间
    ,o.create_by -- 创建人
    ,o.remitter_account_name -- 接收人账户名称
    ,o.acceptor_account_name -- 承兑人账户名称
    ,o.payee_account_name -- 付款人账户名称
    ,o.holder_acct_name -- 持票人账户名称
    ,o.draft_pay_status -- 票据支付状态： 空	PS00 预锁定	PS01 锁定	PS02 即时支付预锁定	PS03 解锁（接收人可签收）	PS04 解锁（发起人可撤销）	PS05 已完成	PS06 已取消	PS07 即时支付锁定	PS08
    ,o.pay_no -- 票据支付订单编号
    ,o.settle_date -- 结清日期
    ,o.migrate_flag -- ECDS迁移票据标志
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
from ${iol_schema}.bdms_htes_draft_info_bk o
    left join ${iol_schema}.bdms_htes_draft_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_htes_draft_info_cl d
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
--truncate table ${iol_schema}.bdms_htes_draft_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_htes_draft_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_htes_draft_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_htes_draft_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_htes_draft_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_htes_draft_info_cl;
alter table ${iol_schema}.bdms_htes_draft_info exchange partition p_20991231 with table ${iol_schema}.bdms_htes_draft_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_htes_draft_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_htes_draft_info_op purge;
drop table ${iol_schema}.bdms_htes_draft_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_htes_draft_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_htes_draft_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
