/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cas_settle_info
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
create table ${iol_schema}.bdms_cas_settle_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cas_settle_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cas_settle_info_op purge;
drop table ${iol_schema}.bdms_cas_settle_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cas_settle_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cas_settle_info where 0=1;

create table ${iol_schema}.bdms_cas_settle_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cas_settle_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cas_settle_info_cl(
            id -- ID
            ,brh_no -- 机构代码
            ,settle_req_no -- 结算请求编号/交割单编号
            ,settle_tm -- 结算时间
            ,buss_type -- 业务类型： 1 查询 2 通知 3 出入金 4 结息
            ,settle_type -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_req_type -- 结算业务类型： RE1011 转贴现 RE1021 质押式回购首期 RE1022 质押式回购到期 RE1031 买断式回购首期 RE1032 买断式回购到期 RE2011 托收 RE2021 追索 T10008 扣费 RE1023 质押式回购提前赎回 RE1024 质押式回购逾期赎回 RE3011 再贴现买断 RE3021再贴现质押式回购首期 RE3022 再贴现质押式回购到期 RE3023 再贴现质押式回购提前赎回 RE3024 再贴现质押式回购逾期赎回
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,trade_direct -- 交易方向： 1 买入或接收方 2 卖出或发起方
            ,settle_amt -- 结算金额
            ,pay_interest -- 应付利息
            ,draft_count -- 票据张数
            ,deal_no -- 成交单编号
            ,ccpc_msg_id -- 大额支付系统报文标识号
            ,draft_number -- 票据（包）号
            ,rcv_brh_no -- 收款方机构代码
            ,rcv_tacct_no -- 收款方托管账号
            ,rcv_tacct_name -- 收款方托管账户名称
            ,rcv_facct_no -- 收款方资金账号
            ,rcv_facct_name -- 收款方资金账户名称
            ,pay_brh_no -- 付款方机构代码
            ,pay_tacct_no -- 付款方托管账号
            ,pay_tacct_name -- 付款方托管账户名称
            ,pay_facct_no -- 付款方资金账号
            ,pay_facct_name -- 付款方资金账户名称
            ,settle_status -- 结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销 MS07 提前赎回结算成功 MS08 逾期赎回结算成功
            ,queue_no -- 队列编号
            ,fee_no -- 扣费编号
            ,queue_seq -- 排队顺序号
            ,que_adj_rst -- 排队调整结果
            ,pro_code -- 队列调整结果码
            ,settle_result -- 结算结果： R20 结算成功 R21 结算失败 R23 已撤销
            ,settle_frsn -- 结算失败原因
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,rcv_corp_br_id -- 收款方企业开户行机构代码
            ,rcv_op_bk_id -- 收款方企业开户行行号
            ,rcv_corp_name -- 收款方企业账户名称
            ,rcv_corp_acct -- 收款方企业账号
            ,rcv_corp_soc_code -- 收款方统一社会信用代码
            ,pay_corp_br_id -- 付款方企业开户行机构代码
            ,pay_op_bk_id -- 付款方企业开户行行号
            ,pay_corp_name -- 付款方企业账户名称
            ,pay_corp_acct -- 付款方企业账号
            ,pay_corp_soc_code -- 付款方统一社会信用代码
            ,is_batch -- 是否批量清算
            ,pay_cd_acct_no -- 付款方企业票据账户账号
            ,rcv_cd_acct_no -- 收款方企业票据账户账号
            ,cd_range -- 票据子区间
            ,analysis_id -- 业务报文解析表ID
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cas_settle_info_op(
            id -- ID
            ,brh_no -- 机构代码
            ,settle_req_no -- 结算请求编号/交割单编号
            ,settle_tm -- 结算时间
            ,buss_type -- 业务类型： 1 查询 2 通知 3 出入金 4 结息
            ,settle_type -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_req_type -- 结算业务类型： RE1011 转贴现 RE1021 质押式回购首期 RE1022 质押式回购到期 RE1031 买断式回购首期 RE1032 买断式回购到期 RE2011 托收 RE2021 追索 T10008 扣费 RE1023 质押式回购提前赎回 RE1024 质押式回购逾期赎回 RE3011 再贴现买断 RE3021再贴现质押式回购首期 RE3022 再贴现质押式回购到期 RE3023 再贴现质押式回购提前赎回 RE3024 再贴现质押式回购逾期赎回
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,trade_direct -- 交易方向： 1 买入或接收方 2 卖出或发起方
            ,settle_amt -- 结算金额
            ,pay_interest -- 应付利息
            ,draft_count -- 票据张数
            ,deal_no -- 成交单编号
            ,ccpc_msg_id -- 大额支付系统报文标识号
            ,draft_number -- 票据（包）号
            ,rcv_brh_no -- 收款方机构代码
            ,rcv_tacct_no -- 收款方托管账号
            ,rcv_tacct_name -- 收款方托管账户名称
            ,rcv_facct_no -- 收款方资金账号
            ,rcv_facct_name -- 收款方资金账户名称
            ,pay_brh_no -- 付款方机构代码
            ,pay_tacct_no -- 付款方托管账号
            ,pay_tacct_name -- 付款方托管账户名称
            ,pay_facct_no -- 付款方资金账号
            ,pay_facct_name -- 付款方资金账户名称
            ,settle_status -- 结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销 MS07 提前赎回结算成功 MS08 逾期赎回结算成功
            ,queue_no -- 队列编号
            ,fee_no -- 扣费编号
            ,queue_seq -- 排队顺序号
            ,que_adj_rst -- 排队调整结果
            ,pro_code -- 队列调整结果码
            ,settle_result -- 结算结果： R20 结算成功 R21 结算失败 R23 已撤销
            ,settle_frsn -- 结算失败原因
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,rcv_corp_br_id -- 收款方企业开户行机构代码
            ,rcv_op_bk_id -- 收款方企业开户行行号
            ,rcv_corp_name -- 收款方企业账户名称
            ,rcv_corp_acct -- 收款方企业账号
            ,rcv_corp_soc_code -- 收款方统一社会信用代码
            ,pay_corp_br_id -- 付款方企业开户行机构代码
            ,pay_op_bk_id -- 付款方企业开户行行号
            ,pay_corp_name -- 付款方企业账户名称
            ,pay_corp_acct -- 付款方企业账号
            ,pay_corp_soc_code -- 付款方统一社会信用代码
            ,is_batch -- 是否批量清算
            ,pay_cd_acct_no -- 付款方企业票据账户账号
            ,rcv_cd_acct_no -- 收款方企业票据账户账号
            ,cd_range -- 票据子区间
            ,analysis_id -- 业务报文解析表ID
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.brh_no, o.brh_no) as brh_no -- 机构代码
    ,nvl(n.settle_req_no, o.settle_req_no) as settle_req_no -- 结算请求编号/交割单编号
    ,nvl(n.settle_tm, o.settle_tm) as settle_tm -- 结算时间
    ,nvl(n.buss_type, o.buss_type) as buss_type -- 业务类型： 1 查询 2 通知 3 出入金 4 结息
    ,nvl(n.settle_type, o.settle_type) as settle_type -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,nvl(n.settle_req_type, o.settle_req_type) as settle_req_type -- 结算业务类型： RE1011 转贴现 RE1021 质押式回购首期 RE1022 质押式回购到期 RE1031 买断式回购首期 RE1032 买断式回购到期 RE2011 托收 RE2021 追索 T10008 扣费 RE1023 质押式回购提前赎回 RE1024 质押式回购逾期赎回 RE3011 再贴现买断 RE3021再贴现质押式回购首期 RE3022 再贴现质押式回购到期 RE3023 再贴现质押式回购提前赎回 RE3024 再贴现质押式回购逾期赎回
    ,nvl(n.clear_type, o.clear_type) as clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
    ,nvl(n.trade_direct, o.trade_direct) as trade_direct -- 交易方向： 1 买入或接收方 2 卖出或发起方
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.pay_interest, o.pay_interest) as pay_interest -- 应付利息
    ,nvl(n.draft_count, o.draft_count) as draft_count -- 票据张数
    ,nvl(n.deal_no, o.deal_no) as deal_no -- 成交单编号
    ,nvl(n.ccpc_msg_id, o.ccpc_msg_id) as ccpc_msg_id -- 大额支付系统报文标识号
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据（包）号
    ,nvl(n.rcv_brh_no, o.rcv_brh_no) as rcv_brh_no -- 收款方机构代码
    ,nvl(n.rcv_tacct_no, o.rcv_tacct_no) as rcv_tacct_no -- 收款方托管账号
    ,nvl(n.rcv_tacct_name, o.rcv_tacct_name) as rcv_tacct_name -- 收款方托管账户名称
    ,nvl(n.rcv_facct_no, o.rcv_facct_no) as rcv_facct_no -- 收款方资金账号
    ,nvl(n.rcv_facct_name, o.rcv_facct_name) as rcv_facct_name -- 收款方资金账户名称
    ,nvl(n.pay_brh_no, o.pay_brh_no) as pay_brh_no -- 付款方机构代码
    ,nvl(n.pay_tacct_no, o.pay_tacct_no) as pay_tacct_no -- 付款方托管账号
    ,nvl(n.pay_tacct_name, o.pay_tacct_name) as pay_tacct_name -- 付款方托管账户名称
    ,nvl(n.pay_facct_no, o.pay_facct_no) as pay_facct_no -- 付款方资金账号
    ,nvl(n.pay_facct_name, o.pay_facct_name) as pay_facct_name -- 付款方资金账户名称
    ,nvl(n.settle_status, o.settle_status) as settle_status -- 结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销 MS07 提前赎回结算成功 MS08 逾期赎回结算成功
    ,nvl(n.queue_no, o.queue_no) as queue_no -- 队列编号
    ,nvl(n.fee_no, o.fee_no) as fee_no -- 扣费编号
    ,nvl(n.queue_seq, o.queue_seq) as queue_seq -- 排队顺序号
    ,nvl(n.que_adj_rst, o.que_adj_rst) as que_adj_rst -- 排队调整结果
    ,nvl(n.pro_code, o.pro_code) as pro_code -- 队列调整结果码
    ,nvl(n.settle_result, o.settle_result) as settle_result -- 结算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,nvl(n.settle_frsn, o.settle_frsn) as settle_frsn -- 结算失败原因
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作人
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.rcv_corp_br_id, o.rcv_corp_br_id) as rcv_corp_br_id -- 收款方企业开户行机构代码
    ,nvl(n.rcv_op_bk_id, o.rcv_op_bk_id) as rcv_op_bk_id -- 收款方企业开户行行号
    ,nvl(n.rcv_corp_name, o.rcv_corp_name) as rcv_corp_name -- 收款方企业账户名称
    ,nvl(n.rcv_corp_acct, o.rcv_corp_acct) as rcv_corp_acct -- 收款方企业账号
    ,nvl(n.rcv_corp_soc_code, o.rcv_corp_soc_code) as rcv_corp_soc_code -- 收款方统一社会信用代码
    ,nvl(n.pay_corp_br_id, o.pay_corp_br_id) as pay_corp_br_id -- 付款方企业开户行机构代码
    ,nvl(n.pay_op_bk_id, o.pay_op_bk_id) as pay_op_bk_id -- 付款方企业开户行行号
    ,nvl(n.pay_corp_name, o.pay_corp_name) as pay_corp_name -- 付款方企业账户名称
    ,nvl(n.pay_corp_acct, o.pay_corp_acct) as pay_corp_acct -- 付款方企业账号
    ,nvl(n.pay_corp_soc_code, o.pay_corp_soc_code) as pay_corp_soc_code -- 付款方统一社会信用代码
    ,nvl(n.is_batch, o.is_batch) as is_batch -- 是否批量清算
    ,nvl(n.pay_cd_acct_no, o.pay_cd_acct_no) as pay_cd_acct_no -- 付款方企业票据账户账号
    ,nvl(n.rcv_cd_acct_no, o.rcv_cd_acct_no) as rcv_cd_acct_no -- 收款方企业票据账户账号
    ,nvl(n.cd_range, o.cd_range) as cd_range -- 票据子区间
    ,nvl(n.analysis_id, o.analysis_id) as analysis_id -- 业务报文解析表ID
    ,nvl(n.create_by, o.create_by) as create_by -- 创建人
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
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
from (select * from ${iol_schema}.bdms_cas_settle_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cas_settle_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.brh_no <> n.brh_no
        or o.settle_req_no <> n.settle_req_no
        or o.settle_tm <> n.settle_tm
        or o.buss_type <> n.buss_type
        or o.settle_type <> n.settle_type
        or o.settle_req_type <> n.settle_req_type
        or o.clear_type <> n.clear_type
        or o.trade_direct <> n.trade_direct
        or o.settle_amt <> n.settle_amt
        or o.pay_interest <> n.pay_interest
        or o.draft_count <> n.draft_count
        or o.deal_no <> n.deal_no
        or o.ccpc_msg_id <> n.ccpc_msg_id
        or o.draft_number <> n.draft_number
        or o.rcv_brh_no <> n.rcv_brh_no
        or o.rcv_tacct_no <> n.rcv_tacct_no
        or o.rcv_tacct_name <> n.rcv_tacct_name
        or o.rcv_facct_no <> n.rcv_facct_no
        or o.rcv_facct_name <> n.rcv_facct_name
        or o.pay_brh_no <> n.pay_brh_no
        or o.pay_tacct_no <> n.pay_tacct_no
        or o.pay_tacct_name <> n.pay_tacct_name
        or o.pay_facct_no <> n.pay_facct_no
        or o.pay_facct_name <> n.pay_facct_name
        or o.settle_status <> n.settle_status
        or o.queue_no <> n.queue_no
        or o.fee_no <> n.fee_no
        or o.queue_seq <> n.queue_seq
        or o.que_adj_rst <> n.que_adj_rst
        or o.pro_code <> n.pro_code
        or o.settle_result <> n.settle_result
        or o.settle_frsn <> n.settle_frsn
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.rcv_corp_br_id <> n.rcv_corp_br_id
        or o.rcv_op_bk_id <> n.rcv_op_bk_id
        or o.rcv_corp_name <> n.rcv_corp_name
        or o.rcv_corp_acct <> n.rcv_corp_acct
        or o.rcv_corp_soc_code <> n.rcv_corp_soc_code
        or o.pay_corp_br_id <> n.pay_corp_br_id
        or o.pay_op_bk_id <> n.pay_op_bk_id
        or o.pay_corp_name <> n.pay_corp_name
        or o.pay_corp_acct <> n.pay_corp_acct
        or o.pay_corp_soc_code <> n.pay_corp_soc_code
        or o.is_batch <> n.is_batch
        or o.pay_cd_acct_no <> n.pay_cd_acct_no
        or o.rcv_cd_acct_no <> n.rcv_cd_acct_no
        or o.cd_range <> n.cd_range
        or o.analysis_id <> n.analysis_id
        or o.create_by <> n.create_by
        or o.create_time <> n.create_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cas_settle_info_cl(
            id -- ID
            ,brh_no -- 机构代码
            ,settle_req_no -- 结算请求编号/交割单编号
            ,settle_tm -- 结算时间
            ,buss_type -- 业务类型： 1 查询 2 通知 3 出入金 4 结息
            ,settle_type -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_req_type -- 结算业务类型： RE1011 转贴现 RE1021 质押式回购首期 RE1022 质押式回购到期 RE1031 买断式回购首期 RE1032 买断式回购到期 RE2011 托收 RE2021 追索 T10008 扣费 RE1023 质押式回购提前赎回 RE1024 质押式回购逾期赎回 RE3011 再贴现买断 RE3021再贴现质押式回购首期 RE3022 再贴现质押式回购到期 RE3023 再贴现质押式回购提前赎回 RE3024 再贴现质押式回购逾期赎回
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,trade_direct -- 交易方向： 1 买入或接收方 2 卖出或发起方
            ,settle_amt -- 结算金额
            ,pay_interest -- 应付利息
            ,draft_count -- 票据张数
            ,deal_no -- 成交单编号
            ,ccpc_msg_id -- 大额支付系统报文标识号
            ,draft_number -- 票据（包）号
            ,rcv_brh_no -- 收款方机构代码
            ,rcv_tacct_no -- 收款方托管账号
            ,rcv_tacct_name -- 收款方托管账户名称
            ,rcv_facct_no -- 收款方资金账号
            ,rcv_facct_name -- 收款方资金账户名称
            ,pay_brh_no -- 付款方机构代码
            ,pay_tacct_no -- 付款方托管账号
            ,pay_tacct_name -- 付款方托管账户名称
            ,pay_facct_no -- 付款方资金账号
            ,pay_facct_name -- 付款方资金账户名称
            ,settle_status -- 结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销 MS07 提前赎回结算成功 MS08 逾期赎回结算成功
            ,queue_no -- 队列编号
            ,fee_no -- 扣费编号
            ,queue_seq -- 排队顺序号
            ,que_adj_rst -- 排队调整结果
            ,pro_code -- 队列调整结果码
            ,settle_result -- 结算结果： R20 结算成功 R21 结算失败 R23 已撤销
            ,settle_frsn -- 结算失败原因
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,rcv_corp_br_id -- 收款方企业开户行机构代码
            ,rcv_op_bk_id -- 收款方企业开户行行号
            ,rcv_corp_name -- 收款方企业账户名称
            ,rcv_corp_acct -- 收款方企业账号
            ,rcv_corp_soc_code -- 收款方统一社会信用代码
            ,pay_corp_br_id -- 付款方企业开户行机构代码
            ,pay_op_bk_id -- 付款方企业开户行行号
            ,pay_corp_name -- 付款方企业账户名称
            ,pay_corp_acct -- 付款方企业账号
            ,pay_corp_soc_code -- 付款方统一社会信用代码
            ,is_batch -- 是否批量清算
            ,pay_cd_acct_no -- 付款方企业票据账户账号
            ,rcv_cd_acct_no -- 收款方企业票据账户账号
            ,cd_range -- 票据子区间
            ,analysis_id -- 业务报文解析表ID
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cas_settle_info_op(
            id -- ID
            ,brh_no -- 机构代码
            ,settle_req_no -- 结算请求编号/交割单编号
            ,settle_tm -- 结算时间
            ,buss_type -- 业务类型： 1 查询 2 通知 3 出入金 4 结息
            ,settle_type -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_req_type -- 结算业务类型： RE1011 转贴现 RE1021 质押式回购首期 RE1022 质押式回购到期 RE1031 买断式回购首期 RE1032 买断式回购到期 RE2011 托收 RE2021 追索 T10008 扣费 RE1023 质押式回购提前赎回 RE1024 质押式回购逾期赎回 RE3011 再贴现买断 RE3021再贴现质押式回购首期 RE3022 再贴现质押式回购到期 RE3023 再贴现质押式回购提前赎回 RE3024 再贴现质押式回购逾期赎回
            ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
            ,trade_direct -- 交易方向： 1 买入或接收方 2 卖出或发起方
            ,settle_amt -- 结算金额
            ,pay_interest -- 应付利息
            ,draft_count -- 票据张数
            ,deal_no -- 成交单编号
            ,ccpc_msg_id -- 大额支付系统报文标识号
            ,draft_number -- 票据（包）号
            ,rcv_brh_no -- 收款方机构代码
            ,rcv_tacct_no -- 收款方托管账号
            ,rcv_tacct_name -- 收款方托管账户名称
            ,rcv_facct_no -- 收款方资金账号
            ,rcv_facct_name -- 收款方资金账户名称
            ,pay_brh_no -- 付款方机构代码
            ,pay_tacct_no -- 付款方托管账号
            ,pay_tacct_name -- 付款方托管账户名称
            ,pay_facct_no -- 付款方资金账号
            ,pay_facct_name -- 付款方资金账户名称
            ,settle_status -- 结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销 MS07 提前赎回结算成功 MS08 逾期赎回结算成功
            ,queue_no -- 队列编号
            ,fee_no -- 扣费编号
            ,queue_seq -- 排队顺序号
            ,que_adj_rst -- 排队调整结果
            ,pro_code -- 队列调整结果码
            ,settle_result -- 结算结果： R20 结算成功 R21 结算失败 R23 已撤销
            ,settle_frsn -- 结算失败原因
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,rcv_corp_br_id -- 收款方企业开户行机构代码
            ,rcv_op_bk_id -- 收款方企业开户行行号
            ,rcv_corp_name -- 收款方企业账户名称
            ,rcv_corp_acct -- 收款方企业账号
            ,rcv_corp_soc_code -- 收款方统一社会信用代码
            ,pay_corp_br_id -- 付款方企业开户行机构代码
            ,pay_op_bk_id -- 付款方企业开户行行号
            ,pay_corp_name -- 付款方企业账户名称
            ,pay_corp_acct -- 付款方企业账号
            ,pay_corp_soc_code -- 付款方统一社会信用代码
            ,is_batch -- 是否批量清算
            ,pay_cd_acct_no -- 付款方企业票据账户账号
            ,rcv_cd_acct_no -- 收款方企业票据账户账号
            ,cd_range -- 票据子区间
            ,analysis_id -- 业务报文解析表ID
            ,create_by -- 创建人
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.brh_no -- 机构代码
    ,o.settle_req_no -- 结算请求编号/交割单编号
    ,o.settle_tm -- 结算时间
    ,o.buss_type -- 业务类型： 1 查询 2 通知 3 出入金 4 结息
    ,o.settle_type -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,o.settle_req_type -- 结算业务类型： RE1011 转贴现 RE1021 质押式回购首期 RE1022 质押式回购到期 RE1031 买断式回购首期 RE1032 买断式回购到期 RE2011 托收 RE2021 追索 T10008 扣费 RE1023 质押式回购提前赎回 RE1024 质押式回购逾期赎回 RE3011 再贴现买断 RE3021再贴现质押式回购首期 RE3022 再贴现质押式回购到期 RE3023 再贴现质押式回购提前赎回 RE3024 再贴现质押式回购逾期赎回
    ,o.clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
    ,o.trade_direct -- 交易方向： 1 买入或接收方 2 卖出或发起方
    ,o.settle_amt -- 结算金额
    ,o.pay_interest -- 应付利息
    ,o.draft_count -- 票据张数
    ,o.deal_no -- 成交单编号
    ,o.ccpc_msg_id -- 大额支付系统报文标识号
    ,o.draft_number -- 票据（包）号
    ,o.rcv_brh_no -- 收款方机构代码
    ,o.rcv_tacct_no -- 收款方托管账号
    ,o.rcv_tacct_name -- 收款方托管账户名称
    ,o.rcv_facct_no -- 收款方资金账号
    ,o.rcv_facct_name -- 收款方资金账户名称
    ,o.pay_brh_no -- 付款方机构代码
    ,o.pay_tacct_no -- 付款方托管账号
    ,o.pay_tacct_name -- 付款方托管账户名称
    ,o.pay_facct_no -- 付款方资金账号
    ,o.pay_facct_name -- 付款方资金账户名称
    ,o.settle_status -- 结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销 MS07 提前赎回结算成功 MS08 逾期赎回结算成功
    ,o.queue_no -- 队列编号
    ,o.fee_no -- 扣费编号
    ,o.queue_seq -- 排队顺序号
    ,o.que_adj_rst -- 排队调整结果
    ,o.pro_code -- 队列调整结果码
    ,o.settle_result -- 结算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,o.settle_frsn -- 结算失败原因
    ,o.last_upd_opr -- 最后操作人
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注
    ,o.rcv_corp_br_id -- 收款方企业开户行机构代码
    ,o.rcv_op_bk_id -- 收款方企业开户行行号
    ,o.rcv_corp_name -- 收款方企业账户名称
    ,o.rcv_corp_acct -- 收款方企业账号
    ,o.rcv_corp_soc_code -- 收款方统一社会信用代码
    ,o.pay_corp_br_id -- 付款方企业开户行机构代码
    ,o.pay_op_bk_id -- 付款方企业开户行行号
    ,o.pay_corp_name -- 付款方企业账户名称
    ,o.pay_corp_acct -- 付款方企业账号
    ,o.pay_corp_soc_code -- 付款方统一社会信用代码
    ,o.is_batch -- 是否批量清算
    ,o.pay_cd_acct_no -- 付款方企业票据账户账号
    ,o.rcv_cd_acct_no -- 收款方企业票据账户账号
    ,o.cd_range -- 票据子区间
    ,o.analysis_id -- 业务报文解析表ID
    ,o.create_by -- 创建人
    ,o.create_time -- 创建时间
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
from ${iol_schema}.bdms_cas_settle_info_bk o
    left join ${iol_schema}.bdms_cas_settle_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cas_settle_info_cl d
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
--truncate table ${iol_schema}.bdms_cas_settle_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cas_settle_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cas_settle_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cas_settle_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cas_settle_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_cas_settle_info_cl;
alter table ${iol_schema}.bdms_cas_settle_info exchange partition p_20991231 with table ${iol_schema}.bdms_cas_settle_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cas_settle_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cas_settle_info_op purge;
drop table ${iol_schema}.bdms_cas_settle_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cas_settle_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cas_settle_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
