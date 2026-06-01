/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpp_flotation_quote_info
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
create table ${iol_schema}.bdms_cpp_flotation_quote_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpp_flotation_quote_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpp_flotation_quote_info_op purge;
drop table ${iol_schema}.bdms_cpp_flotation_quote_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpp_flotation_quote_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpp_flotation_quote_info where 0=1;

create table ${iol_schema}.bdms_cpp_flotation_quote_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpp_flotation_quote_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpp_flotation_quote_info_cl(
            id -- ID
            ,busi_id -- 业务表ID
            ,trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
            ,quote_no -- 报价单编号
            ,emc_brh_no -- 经济机构代码
            ,emc_user_id -- 经济机构交易员ID
            ,dscnt_brh_no -- 贴现机构代码
            ,dscnt_user_id -- 贴现交易员ID
            ,mem_no -- 本方会员代码
            ,cust_name -- 申请人名称
            ,cust_social_no -- 申请人社会信用代码
            ,cust_corp_scale -- 企业规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他
            ,cust_ind_clss -- 行业分类：详见概述分册
            ,cust_arc_flag -- 是否涉农企业： 0 否 1 是
            ,cust_grn_flag -- 是否绿色企业： 0 否 1 是
            ,cust_sci_flag -- 是否科技企业： 0 否 1 是
            ,cust_pop_flag -- 是否民营企业： 0 否 1 是
            ,cust_province -- 贴现申请人省份：参见附录省份代码
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据属性： ME01 纸票 ME02 电票
            ,bargain_falg -- 是否允许议价： 0 否 1 是
            ,sum_count -- 票据张数
            ,sum_amt -- 票据总金额
            ,rate -- 贴现利率
            ,ans_time -- 应答时间
            ,tenor_days -- 剩余期限
            ,settle_date -- 结算日期
            ,settle_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,clear_mode -- 清算方式： OLN01 线上清算 OLN02 线下清算
            ,pay_inetrest -- 应付利息
            ,settle_amt -- 结算金额
            ,trade_cp_type -- 交易对手类型
            ,esc_branch_type -- 剔除交易对手行别
            ,dscnt_entry_bank_no -- 贴现资金入账行号
            ,dscnt_entry_acct -- 贴现入账账号
            ,draft_number -- 票据号码
            ,draft_amt -- 票面金额
            ,maturity_date -- 票据到期日
            ,real_maturity_date -- 票据实际到期日
            ,drawer_name -- 出票人名称
            ,acceptor_name -- 承兑人名称
            ,quote_status -- 报价单状态： DES01 已保存* DES02 已挂牌 DES03 已摘牌 DES04 挂牌待确认* DES05 成交待确认* DES06 已撤回 DES07 已作废 DES08 已成交 DES09 已转对话报价 DES10 已拆单* DES11 摘牌待确认*
            ,process_code -- 处理码
            ,process_msg -- 处理信息
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,acceptor_bank_no -- 承兑人开户行号
            ,msg_id -- 报文标识号
            ,msg_type -- 报文编号
            ,msg_date -- 报文日期
            ,msg_tm -- 报文时间
            ,standard_amount -- 标准金额
            ,product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
            ,sub_range -- 子票据区间
            ,draft_channel -- 票据所在渠道
            ,cust_mem_no -- 票据业务所在渠道代码
            ,cust_dist_type -- 账号识别类型
            ,cust_acct_name -- 贴现申请人账户名称
            ,cust_brh_no -- 贴现申请人开户机构代码
            ,entry_acct_name -- 资金入账账户名称
            ,entry_brh_no -- 资金入账账户机构代码
            ,cust_acct -- 贴现申请人帐号
            ,entry_acct -- 资金入账账户
            ,create_by -- 创建人
            ,create_time -- 鍒涘缓鏃堕棿
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpp_flotation_quote_info_op(
            id -- ID
            ,busi_id -- 业务表ID
            ,trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
            ,quote_no -- 报价单编号
            ,emc_brh_no -- 经济机构代码
            ,emc_user_id -- 经济机构交易员ID
            ,dscnt_brh_no -- 贴现机构代码
            ,dscnt_user_id -- 贴现交易员ID
            ,mem_no -- 本方会员代码
            ,cust_name -- 申请人名称
            ,cust_social_no -- 申请人社会信用代码
            ,cust_corp_scale -- 企业规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他
            ,cust_ind_clss -- 行业分类：详见概述分册
            ,cust_arc_flag -- 是否涉农企业： 0 否 1 是
            ,cust_grn_flag -- 是否绿色企业： 0 否 1 是
            ,cust_sci_flag -- 是否科技企业： 0 否 1 是
            ,cust_pop_flag -- 是否民营企业： 0 否 1 是
            ,cust_province -- 贴现申请人省份：参见附录省份代码
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据属性： ME01 纸票 ME02 电票
            ,bargain_falg -- 是否允许议价： 0 否 1 是
            ,sum_count -- 票据张数
            ,sum_amt -- 票据总金额
            ,rate -- 贴现利率
            ,ans_time -- 应答时间
            ,tenor_days -- 剩余期限
            ,settle_date -- 结算日期
            ,settle_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,clear_mode -- 清算方式： OLN01 线上清算 OLN02 线下清算
            ,pay_inetrest -- 应付利息
            ,settle_amt -- 结算金额
            ,trade_cp_type -- 交易对手类型
            ,esc_branch_type -- 剔除交易对手行别
            ,dscnt_entry_bank_no -- 贴现资金入账行号
            ,dscnt_entry_acct -- 贴现入账账号
            ,draft_number -- 票据号码
            ,draft_amt -- 票面金额
            ,maturity_date -- 票据到期日
            ,real_maturity_date -- 票据实际到期日
            ,drawer_name -- 出票人名称
            ,acceptor_name -- 承兑人名称
            ,quote_status -- 报价单状态： DES01 已保存* DES02 已挂牌 DES03 已摘牌 DES04 挂牌待确认* DES05 成交待确认* DES06 已撤回 DES07 已作废 DES08 已成交 DES09 已转对话报价 DES10 已拆单* DES11 摘牌待确认*
            ,process_code -- 处理码
            ,process_msg -- 处理信息
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,acceptor_bank_no -- 承兑人开户行号
            ,msg_id -- 报文标识号
            ,msg_type -- 报文编号
            ,msg_date -- 报文日期
            ,msg_tm -- 报文时间
            ,standard_amount -- 标准金额
            ,product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
            ,sub_range -- 子票据区间
            ,draft_channel -- 票据所在渠道
            ,cust_mem_no -- 票据业务所在渠道代码
            ,cust_dist_type -- 账号识别类型
            ,cust_acct_name -- 贴现申请人账户名称
            ,cust_brh_no -- 贴现申请人开户机构代码
            ,entry_acct_name -- 资金入账账户名称
            ,entry_brh_no -- 资金入账账户机构代码
            ,cust_acct -- 贴现申请人帐号
            ,entry_acct -- 资金入账账户
            ,create_by -- 创建人
            ,create_time -- 鍒涘缓鏃堕棿
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.busi_id, o.busi_id) as busi_id -- 业务表ID
    ,nvl(n.trade_direct, o.trade_direct) as trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
    ,nvl(n.quote_no, o.quote_no) as quote_no -- 报价单编号
    ,nvl(n.emc_brh_no, o.emc_brh_no) as emc_brh_no -- 经济机构代码
    ,nvl(n.emc_user_id, o.emc_user_id) as emc_user_id -- 经济机构交易员ID
    ,nvl(n.dscnt_brh_no, o.dscnt_brh_no) as dscnt_brh_no -- 贴现机构代码
    ,nvl(n.dscnt_user_id, o.dscnt_user_id) as dscnt_user_id -- 贴现交易员ID
    ,nvl(n.mem_no, o.mem_no) as mem_no -- 本方会员代码
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 申请人名称
    ,nvl(n.cust_social_no, o.cust_social_no) as cust_social_no -- 申请人社会信用代码
    ,nvl(n.cust_corp_scale, o.cust_corp_scale) as cust_corp_scale -- 企业规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他
    ,nvl(n.cust_ind_clss, o.cust_ind_clss) as cust_ind_clss -- 行业分类：详见概述分册
    ,nvl(n.cust_arc_flag, o.cust_arc_flag) as cust_arc_flag -- 是否涉农企业： 0 否 1 是
    ,nvl(n.cust_grn_flag, o.cust_grn_flag) as cust_grn_flag -- 是否绿色企业： 0 否 1 是
    ,nvl(n.cust_sci_flag, o.cust_sci_flag) as cust_sci_flag -- 是否科技企业： 0 否 1 是
    ,nvl(n.cust_pop_flag, o.cust_pop_flag) as cust_pop_flag -- 是否民营企业： 0 否 1 是
    ,nvl(n.cust_province, o.cust_province) as cust_province -- 贴现申请人省份：参见附录省份代码
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： AC01 银承 AC02 商承
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据属性： ME01 纸票 ME02 电票
    ,nvl(n.bargain_falg, o.bargain_falg) as bargain_falg -- 是否允许议价： 0 否 1 是
    ,nvl(n.sum_count, o.sum_count) as sum_count -- 票据张数
    ,nvl(n.sum_amt, o.sum_amt) as sum_amt -- 票据总金额
    ,nvl(n.rate, o.rate) as rate -- 贴现利率
    ,nvl(n.ans_time, o.ans_time) as ans_time -- 应答时间
    ,nvl(n.tenor_days, o.tenor_days) as tenor_days -- 剩余期限
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 结算日期
    ,nvl(n.settle_speed, o.settle_speed) as settle_speed -- 清算速度： CS00 T+0 CS01 T+1
    ,nvl(n.clear_mode, o.clear_mode) as clear_mode -- 清算方式： OLN01 线上清算 OLN02 线下清算
    ,nvl(n.pay_inetrest, o.pay_inetrest) as pay_inetrest -- 应付利息
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.trade_cp_type, o.trade_cp_type) as trade_cp_type -- 交易对手类型
    ,nvl(n.esc_branch_type, o.esc_branch_type) as esc_branch_type -- 剔除交易对手行别
    ,nvl(n.dscnt_entry_bank_no, o.dscnt_entry_bank_no) as dscnt_entry_bank_no -- 贴现资金入账行号
    ,nvl(n.dscnt_entry_acct, o.dscnt_entry_acct) as dscnt_entry_acct -- 贴现入账账号
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据号码
    ,nvl(n.draft_amt, o.draft_amt) as draft_amt -- 票面金额
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 票据到期日
    ,nvl(n.real_maturity_date, o.real_maturity_date) as real_maturity_date -- 票据实际到期日
    ,nvl(n.drawer_name, o.drawer_name) as drawer_name -- 出票人名称
    ,nvl(n.acceptor_name, o.acceptor_name) as acceptor_name -- 承兑人名称
    ,nvl(n.quote_status, o.quote_status) as quote_status -- 报价单状态： DES01 已保存* DES02 已挂牌 DES03 已摘牌 DES04 挂牌待确认* DES05 成交待确认* DES06 已撤回 DES07 已作废 DES08 已成交 DES09 已转对话报价 DES10 已拆单* DES11 摘牌待确认*
    ,nvl(n.process_code, o.process_code) as process_code -- 处理码
    ,nvl(n.process_msg, o.process_msg) as process_msg -- 处理信息
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.acceptor_bank_no, o.acceptor_bank_no) as acceptor_bank_no -- 承兑人开户行号
    ,nvl(n.msg_id, o.msg_id) as msg_id -- 报文标识号
    ,nvl(n.msg_type, o.msg_type) as msg_type -- 报文编号
    ,nvl(n.msg_date, o.msg_date) as msg_date -- 报文日期
    ,nvl(n.msg_tm, o.msg_tm) as msg_tm -- 报文时间
    ,nvl(n.standard_amount, o.standard_amount) as standard_amount -- 标准金额
    ,nvl(n.product_type, o.product_type) as product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
    ,nvl(n.sub_range, o.sub_range) as sub_range -- 子票据区间
    ,nvl(n.draft_channel, o.draft_channel) as draft_channel -- 票据所在渠道
    ,nvl(n.cust_mem_no, o.cust_mem_no) as cust_mem_no -- 票据业务所在渠道代码
    ,nvl(n.cust_dist_type, o.cust_dist_type) as cust_dist_type -- 账号识别类型
    ,nvl(n.cust_acct_name, o.cust_acct_name) as cust_acct_name -- 贴现申请人账户名称
    ,nvl(n.cust_brh_no, o.cust_brh_no) as cust_brh_no -- 贴现申请人开户机构代码
    ,nvl(n.entry_acct_name, o.entry_acct_name) as entry_acct_name -- 资金入账账户名称
    ,nvl(n.entry_brh_no, o.entry_brh_no) as entry_brh_no -- 资金入账账户机构代码
    ,nvl(n.cust_acct, o.cust_acct) as cust_acct -- 贴现申请人帐号
    ,nvl(n.entry_acct, o.entry_acct) as entry_acct -- 资金入账账户
    ,nvl(n.create_by, o.create_by) as create_by -- 创建人
    ,nvl(n.create_time, o.create_time) as create_time -- 鍒涘缓鏃堕棿
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
from (select * from ${iol_schema}.bdms_cpp_flotation_quote_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpp_flotation_quote_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.busi_id <> n.busi_id
        or o.trade_direct <> n.trade_direct
        or o.quote_no <> n.quote_no
        or o.emc_brh_no <> n.emc_brh_no
        or o.emc_user_id <> n.emc_user_id
        or o.dscnt_brh_no <> n.dscnt_brh_no
        or o.dscnt_user_id <> n.dscnt_user_id
        or o.mem_no <> n.mem_no
        or o.cust_name <> n.cust_name
        or o.cust_social_no <> n.cust_social_no
        or o.cust_corp_scale <> n.cust_corp_scale
        or o.cust_ind_clss <> n.cust_ind_clss
        or o.cust_arc_flag <> n.cust_arc_flag
        or o.cust_grn_flag <> n.cust_grn_flag
        or o.cust_sci_flag <> n.cust_sci_flag
        or o.cust_pop_flag <> n.cust_pop_flag
        or o.cust_province <> n.cust_province
        or o.draft_type <> n.draft_type
        or o.draft_attr <> n.draft_attr
        or o.bargain_falg <> n.bargain_falg
        or o.sum_count <> n.sum_count
        or o.sum_amt <> n.sum_amt
        or o.rate <> n.rate
        or o.ans_time <> n.ans_time
        or o.tenor_days <> n.tenor_days
        or o.settle_date <> n.settle_date
        or o.settle_speed <> n.settle_speed
        or o.clear_mode <> n.clear_mode
        or o.pay_inetrest <> n.pay_inetrest
        or o.settle_amt <> n.settle_amt
        or o.trade_cp_type <> n.trade_cp_type
        or o.esc_branch_type <> n.esc_branch_type
        or o.dscnt_entry_bank_no <> n.dscnt_entry_bank_no
        or o.dscnt_entry_acct <> n.dscnt_entry_acct
        or o.draft_number <> n.draft_number
        or o.draft_amt <> n.draft_amt
        or o.maturity_date <> n.maturity_date
        or o.real_maturity_date <> n.real_maturity_date
        or o.drawer_name <> n.drawer_name
        or o.acceptor_name <> n.acceptor_name
        or o.quote_status <> n.quote_status
        or o.process_code <> n.process_code
        or o.process_msg <> n.process_msg
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.acceptor_bank_no <> n.acceptor_bank_no
        or o.msg_id <> n.msg_id
        or o.msg_type <> n.msg_type
        or o.msg_date <> n.msg_date
        or o.msg_tm <> n.msg_tm
        or o.standard_amount <> n.standard_amount
        or o.product_type <> n.product_type
        or o.sub_range <> n.sub_range
        or o.draft_channel <> n.draft_channel
        or o.cust_mem_no <> n.cust_mem_no
        or o.cust_dist_type <> n.cust_dist_type
        or o.cust_acct_name <> n.cust_acct_name
        or o.cust_brh_no <> n.cust_brh_no
        or o.entry_acct_name <> n.entry_acct_name
        or o.entry_brh_no <> n.entry_brh_no
        or o.cust_acct <> n.cust_acct
        or o.entry_acct <> n.entry_acct
        or o.create_by <> n.create_by
        or o.create_time <> n.create_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpp_flotation_quote_info_cl(
            id -- ID
            ,busi_id -- 业务表ID
            ,trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
            ,quote_no -- 报价单编号
            ,emc_brh_no -- 经济机构代码
            ,emc_user_id -- 经济机构交易员ID
            ,dscnt_brh_no -- 贴现机构代码
            ,dscnt_user_id -- 贴现交易员ID
            ,mem_no -- 本方会员代码
            ,cust_name -- 申请人名称
            ,cust_social_no -- 申请人社会信用代码
            ,cust_corp_scale -- 企业规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他
            ,cust_ind_clss -- 行业分类：详见概述分册
            ,cust_arc_flag -- 是否涉农企业： 0 否 1 是
            ,cust_grn_flag -- 是否绿色企业： 0 否 1 是
            ,cust_sci_flag -- 是否科技企业： 0 否 1 是
            ,cust_pop_flag -- 是否民营企业： 0 否 1 是
            ,cust_province -- 贴现申请人省份：参见附录省份代码
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据属性： ME01 纸票 ME02 电票
            ,bargain_falg -- 是否允许议价： 0 否 1 是
            ,sum_count -- 票据张数
            ,sum_amt -- 票据总金额
            ,rate -- 贴现利率
            ,ans_time -- 应答时间
            ,tenor_days -- 剩余期限
            ,settle_date -- 结算日期
            ,settle_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,clear_mode -- 清算方式： OLN01 线上清算 OLN02 线下清算
            ,pay_inetrest -- 应付利息
            ,settle_amt -- 结算金额
            ,trade_cp_type -- 交易对手类型
            ,esc_branch_type -- 剔除交易对手行别
            ,dscnt_entry_bank_no -- 贴现资金入账行号
            ,dscnt_entry_acct -- 贴现入账账号
            ,draft_number -- 票据号码
            ,draft_amt -- 票面金额
            ,maturity_date -- 票据到期日
            ,real_maturity_date -- 票据实际到期日
            ,drawer_name -- 出票人名称
            ,acceptor_name -- 承兑人名称
            ,quote_status -- 报价单状态： DES01 已保存* DES02 已挂牌 DES03 已摘牌 DES04 挂牌待确认* DES05 成交待确认* DES06 已撤回 DES07 已作废 DES08 已成交 DES09 已转对话报价 DES10 已拆单* DES11 摘牌待确认*
            ,process_code -- 处理码
            ,process_msg -- 处理信息
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,acceptor_bank_no -- 承兑人开户行号
            ,msg_id -- 报文标识号
            ,msg_type -- 报文编号
            ,msg_date -- 报文日期
            ,msg_tm -- 报文时间
            ,standard_amount -- 标准金额
            ,product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
            ,sub_range -- 子票据区间
            ,draft_channel -- 票据所在渠道
            ,cust_mem_no -- 票据业务所在渠道代码
            ,cust_dist_type -- 账号识别类型
            ,cust_acct_name -- 贴现申请人账户名称
            ,cust_brh_no -- 贴现申请人开户机构代码
            ,entry_acct_name -- 资金入账账户名称
            ,entry_brh_no -- 资金入账账户机构代码
            ,cust_acct -- 贴现申请人帐号
            ,entry_acct -- 资金入账账户
            ,create_by -- 创建人
            ,create_time -- 鍒涘缓鏃堕棿
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpp_flotation_quote_info_op(
            id -- ID
            ,busi_id -- 业务表ID
            ,trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
            ,quote_no -- 报价单编号
            ,emc_brh_no -- 经济机构代码
            ,emc_user_id -- 经济机构交易员ID
            ,dscnt_brh_no -- 贴现机构代码
            ,dscnt_user_id -- 贴现交易员ID
            ,mem_no -- 本方会员代码
            ,cust_name -- 申请人名称
            ,cust_social_no -- 申请人社会信用代码
            ,cust_corp_scale -- 企业规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他
            ,cust_ind_clss -- 行业分类：详见概述分册
            ,cust_arc_flag -- 是否涉农企业： 0 否 1 是
            ,cust_grn_flag -- 是否绿色企业： 0 否 1 是
            ,cust_sci_flag -- 是否科技企业： 0 否 1 是
            ,cust_pop_flag -- 是否民营企业： 0 否 1 是
            ,cust_province -- 贴现申请人省份：参见附录省份代码
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据属性： ME01 纸票 ME02 电票
            ,bargain_falg -- 是否允许议价： 0 否 1 是
            ,sum_count -- 票据张数
            ,sum_amt -- 票据总金额
            ,rate -- 贴现利率
            ,ans_time -- 应答时间
            ,tenor_days -- 剩余期限
            ,settle_date -- 结算日期
            ,settle_speed -- 清算速度： CS00 T+0 CS01 T+1
            ,clear_mode -- 清算方式： OLN01 线上清算 OLN02 线下清算
            ,pay_inetrest -- 应付利息
            ,settle_amt -- 结算金额
            ,trade_cp_type -- 交易对手类型
            ,esc_branch_type -- 剔除交易对手行别
            ,dscnt_entry_bank_no -- 贴现资金入账行号
            ,dscnt_entry_acct -- 贴现入账账号
            ,draft_number -- 票据号码
            ,draft_amt -- 票面金额
            ,maturity_date -- 票据到期日
            ,real_maturity_date -- 票据实际到期日
            ,drawer_name -- 出票人名称
            ,acceptor_name -- 承兑人名称
            ,quote_status -- 报价单状态： DES01 已保存* DES02 已挂牌 DES03 已摘牌 DES04 挂牌待确认* DES05 成交待确认* DES06 已撤回 DES07 已作废 DES08 已成交 DES09 已转对话报价 DES10 已拆单* DES11 摘牌待确认*
            ,process_code -- 处理码
            ,process_msg -- 处理信息
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,acceptor_bank_no -- 承兑人开户行号
            ,msg_id -- 报文标识号
            ,msg_type -- 报文编号
            ,msg_date -- 报文日期
            ,msg_tm -- 报文时间
            ,standard_amount -- 标准金额
            ,product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
            ,sub_range -- 子票据区间
            ,draft_channel -- 票据所在渠道
            ,cust_mem_no -- 票据业务所在渠道代码
            ,cust_dist_type -- 账号识别类型
            ,cust_acct_name -- 贴现申请人账户名称
            ,cust_brh_no -- 贴现申请人开户机构代码
            ,entry_acct_name -- 资金入账账户名称
            ,entry_brh_no -- 资金入账账户机构代码
            ,cust_acct -- 贴现申请人帐号
            ,entry_acct -- 资金入账账户
            ,create_by -- 创建人
            ,create_time -- 鍒涘缓鏃堕棿
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.busi_id -- 业务表ID
    ,o.trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
    ,o.quote_no -- 报价单编号
    ,o.emc_brh_no -- 经济机构代码
    ,o.emc_user_id -- 经济机构交易员ID
    ,o.dscnt_brh_no -- 贴现机构代码
    ,o.dscnt_user_id -- 贴现交易员ID
    ,o.mem_no -- 本方会员代码
    ,o.cust_name -- 申请人名称
    ,o.cust_social_no -- 申请人社会信用代码
    ,o.cust_corp_scale -- 企业规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他
    ,o.cust_ind_clss -- 行业分类：详见概述分册
    ,o.cust_arc_flag -- 是否涉农企业： 0 否 1 是
    ,o.cust_grn_flag -- 是否绿色企业： 0 否 1 是
    ,o.cust_sci_flag -- 是否科技企业： 0 否 1 是
    ,o.cust_pop_flag -- 是否民营企业： 0 否 1 是
    ,o.cust_province -- 贴现申请人省份：参见附录省份代码
    ,o.draft_type -- 票据类型： AC01 银承 AC02 商承
    ,o.draft_attr -- 票据属性： ME01 纸票 ME02 电票
    ,o.bargain_falg -- 是否允许议价： 0 否 1 是
    ,o.sum_count -- 票据张数
    ,o.sum_amt -- 票据总金额
    ,o.rate -- 贴现利率
    ,o.ans_time -- 应答时间
    ,o.tenor_days -- 剩余期限
    ,o.settle_date -- 结算日期
    ,o.settle_speed -- 清算速度： CS00 T+0 CS01 T+1
    ,o.clear_mode -- 清算方式： OLN01 线上清算 OLN02 线下清算
    ,o.pay_inetrest -- 应付利息
    ,o.settle_amt -- 结算金额
    ,o.trade_cp_type -- 交易对手类型
    ,o.esc_branch_type -- 剔除交易对手行别
    ,o.dscnt_entry_bank_no -- 贴现资金入账行号
    ,o.dscnt_entry_acct -- 贴现入账账号
    ,o.draft_number -- 票据号码
    ,o.draft_amt -- 票面金额
    ,o.maturity_date -- 票据到期日
    ,o.real_maturity_date -- 票据实际到期日
    ,o.drawer_name -- 出票人名称
    ,o.acceptor_name -- 承兑人名称
    ,o.quote_status -- 报价单状态： DES01 已保存* DES02 已挂牌 DES03 已摘牌 DES04 挂牌待确认* DES05 成交待确认* DES06 已撤回 DES07 已作废 DES08 已成交 DES09 已转对话报价 DES10 已拆单* DES11 摘牌待确认*
    ,o.process_code -- 处理码
    ,o.process_msg -- 处理信息
    ,o.last_upd_opr -- 最后操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注
    ,o.acceptor_bank_no -- 承兑人开户行号
    ,o.msg_id -- 报文标识号
    ,o.msg_type -- 报文编号
    ,o.msg_date -- 报文日期
    ,o.msg_tm -- 报文时间
    ,o.standard_amount -- 标准金额
    ,o.product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
    ,o.sub_range -- 子票据区间
    ,o.draft_channel -- 票据所在渠道
    ,o.cust_mem_no -- 票据业务所在渠道代码
    ,o.cust_dist_type -- 账号识别类型
    ,o.cust_acct_name -- 贴现申请人账户名称
    ,o.cust_brh_no -- 贴现申请人开户机构代码
    ,o.entry_acct_name -- 资金入账账户名称
    ,o.entry_brh_no -- 资金入账账户机构代码
    ,o.cust_acct -- 贴现申请人帐号
    ,o.entry_acct -- 资金入账账户
    ,o.create_by -- 创建人
    ,o.create_time -- 鍒涘缓鏃堕棿
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
from ${iol_schema}.bdms_cpp_flotation_quote_info_bk o
    left join ${iol_schema}.bdms_cpp_flotation_quote_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpp_flotation_quote_info_cl d
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
--truncate table ${iol_schema}.bdms_cpp_flotation_quote_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpp_flotation_quote_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpp_flotation_quote_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpp_flotation_quote_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpp_flotation_quote_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpp_flotation_quote_info_cl;
alter table ${iol_schema}.bdms_cpp_flotation_quote_info exchange partition p_20991231 with table ${iol_schema}.bdms_cpp_flotation_quote_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpp_flotation_quote_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpp_flotation_quote_info_op purge;
drop table ${iol_schema}.bdms_cpp_flotation_quote_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpp_flotation_quote_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpp_flotation_quote_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
