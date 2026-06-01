/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbhissquare
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
create table ${iol_schema}.nfss_tbhissquare_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tbhissquare;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbhissquare_op purge;
drop table ${iol_schema}.nfss_tbhissquare_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbhissquare_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbhissquare where 0=1;

create table ${iol_schema}.nfss_tbhissquare_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbhissquare where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbhissquare_cl(
            square_no -- 清算流水号
            ,seq_no -- 清算顺序号
            ,trans_date -- 交易日期
            ,clear_date -- 清算日期
            ,square_date -- 实际入帐日期
            ,old_square_date -- 变动前square_date
            ,serial_no -- 流水号
            ,asso_serial -- 关联流水号
            ,from_flag -- 发起方
            ,trans_code -- 交易代码
            ,busin_code -- 业务代码
            ,client_type -- 客户类型
            ,in_client_no -- 内部客户编号
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,bank_acc -- 银行账号
            ,bank_acc_kind -- 银行帐户类型
            ,channel -- 交易渠道
            ,oper_no -- 交易柜员
            ,term_no -- 终端编号
            ,branch_no -- 交易机构
            ,open_branch -- 交易所属机构
            ,ta_code -- TA代码
            ,prd_code -- 产品代码
            ,liqu_dir -- 帐务方向
            ,amt -- 清算金额
            ,curr_type -- 币种
            ,cash_flag -- 钞汇标志
            ,unfrozen_amt -- 解冻金额
            ,host_trans_code -- 主机交易码
            ,host_date -- 主机日期
            ,host_serial -- 主机流水号
            ,frozen_amt -- 冻结金额
            ,check_status -- 勾对确认标志
            ,distrib_flag -- 上帐金额来源类型
            ,amt_flag -- 资金类别
            ,cost_income_flag -- 本金收益标志
            ,cfm_vol -- 确认份额
            ,cost -- 本金
            ,cfm_income -- 确认收益
            ,vol_cumulate -- 份额累积积数#
            ,prd_account -- 产品账号
            ,prd_account_kind -- 产品帐户类型
            ,summary -- 摘要说明
            ,status -- 状态
            ,old_square_no -- 原清算流水号
            ,err_code -- 返回码
            ,err_msg -- 错误信息
            ,deal_status -- 接口处理标志
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,reserve4 -- 保留域4
            ,reserve5 -- 保留域5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbhissquare_op(
            square_no -- 清算流水号
            ,seq_no -- 清算顺序号
            ,trans_date -- 交易日期
            ,clear_date -- 清算日期
            ,square_date -- 实际入帐日期
            ,old_square_date -- 变动前square_date
            ,serial_no -- 流水号
            ,asso_serial -- 关联流水号
            ,from_flag -- 发起方
            ,trans_code -- 交易代码
            ,busin_code -- 业务代码
            ,client_type -- 客户类型
            ,in_client_no -- 内部客户编号
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,bank_acc -- 银行账号
            ,bank_acc_kind -- 银行帐户类型
            ,channel -- 交易渠道
            ,oper_no -- 交易柜员
            ,term_no -- 终端编号
            ,branch_no -- 交易机构
            ,open_branch -- 交易所属机构
            ,ta_code -- TA代码
            ,prd_code -- 产品代码
            ,liqu_dir -- 帐务方向
            ,amt -- 清算金额
            ,curr_type -- 币种
            ,cash_flag -- 钞汇标志
            ,unfrozen_amt -- 解冻金额
            ,host_trans_code -- 主机交易码
            ,host_date -- 主机日期
            ,host_serial -- 主机流水号
            ,frozen_amt -- 冻结金额
            ,check_status -- 勾对确认标志
            ,distrib_flag -- 上帐金额来源类型
            ,amt_flag -- 资金类别
            ,cost_income_flag -- 本金收益标志
            ,cfm_vol -- 确认份额
            ,cost -- 本金
            ,cfm_income -- 确认收益
            ,vol_cumulate -- 份额累积积数#
            ,prd_account -- 产品账号
            ,prd_account_kind -- 产品帐户类型
            ,summary -- 摘要说明
            ,status -- 状态
            ,old_square_no -- 原清算流水号
            ,err_code -- 返回码
            ,err_msg -- 错误信息
            ,deal_status -- 接口处理标志
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,reserve4 -- 保留域4
            ,reserve5 -- 保留域5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.square_no, o.square_no) as square_no -- 清算流水号
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 清算顺序号
    ,nvl(n.trans_date, o.trans_date) as trans_date -- 交易日期
    ,nvl(n.clear_date, o.clear_date) as clear_date -- 清算日期
    ,nvl(n.square_date, o.square_date) as square_date -- 实际入帐日期
    ,nvl(n.old_square_date, o.old_square_date) as old_square_date -- 变动前square_date
    ,nvl(n.serial_no, o.serial_no) as serial_no -- 流水号
    ,nvl(n.asso_serial, o.asso_serial) as asso_serial -- 关联流水号
    ,nvl(n.from_flag, o.from_flag) as from_flag -- 发起方
    ,nvl(n.trans_code, o.trans_code) as trans_code -- 交易代码
    ,nvl(n.busin_code, o.busin_code) as busin_code -- 业务代码
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.in_client_no, o.in_client_no) as in_client_no -- 内部客户编号
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行编号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 银行账号
    ,nvl(n.bank_acc_kind, o.bank_acc_kind) as bank_acc_kind -- 银行帐户类型
    ,nvl(n.channel, o.channel) as channel -- 交易渠道
    ,nvl(n.oper_no, o.oper_no) as oper_no -- 交易柜员
    ,nvl(n.term_no, o.term_no) as term_no -- 终端编号
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 交易机构
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 交易所属机构
    ,nvl(n.ta_code, o.ta_code) as ta_code -- TA代码
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 产品代码
    ,nvl(n.liqu_dir, o.liqu_dir) as liqu_dir -- 帐务方向
    ,nvl(n.amt, o.amt) as amt -- 清算金额
    ,nvl(n.curr_type, o.curr_type) as curr_type -- 币种
    ,nvl(n.cash_flag, o.cash_flag) as cash_flag -- 钞汇标志
    ,nvl(n.unfrozen_amt, o.unfrozen_amt) as unfrozen_amt -- 解冻金额
    ,nvl(n.host_trans_code, o.host_trans_code) as host_trans_code -- 主机交易码
    ,nvl(n.host_date, o.host_date) as host_date -- 主机日期
    ,nvl(n.host_serial, o.host_serial) as host_serial -- 主机流水号
    ,nvl(n.frozen_amt, o.frozen_amt) as frozen_amt -- 冻结金额
    ,nvl(n.check_status, o.check_status) as check_status -- 勾对确认标志
    ,nvl(n.distrib_flag, o.distrib_flag) as distrib_flag -- 上帐金额来源类型
    ,nvl(n.amt_flag, o.amt_flag) as amt_flag -- 资金类别
    ,nvl(n.cost_income_flag, o.cost_income_flag) as cost_income_flag -- 本金收益标志
    ,nvl(n.cfm_vol, o.cfm_vol) as cfm_vol -- 确认份额
    ,nvl(n.cost, o.cost) as cost -- 本金
    ,nvl(n.cfm_income, o.cfm_income) as cfm_income -- 确认收益
    ,nvl(n.vol_cumulate, o.vol_cumulate) as vol_cumulate -- 份额累积积数#
    ,nvl(n.prd_account, o.prd_account) as prd_account -- 产品账号
    ,nvl(n.prd_account_kind, o.prd_account_kind) as prd_account_kind -- 产品帐户类型
    ,nvl(n.summary, o.summary) as summary -- 摘要说明
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.old_square_no, o.old_square_no) as old_square_no -- 原清算流水号
    ,nvl(n.err_code, o.err_code) as err_code -- 返回码
    ,nvl(n.err_msg, o.err_msg) as err_msg -- 错误信息
    ,nvl(n.deal_status, o.deal_status) as deal_status -- 接口处理标志
    ,nvl(n.amt1, o.amt1) as amt1 -- 备用金额1
    ,nvl(n.amt2, o.amt2) as amt2 -- 备用金额2
    ,nvl(n.amt3, o.amt3) as amt3 -- 备用金额3
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 保留域1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 保留域2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 保留域3
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 保留域4
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 保留域5
    ,case when
            n.square_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.square_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.square_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tbhissquare_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tbhissquare where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.square_no = n.square_no
where (
        o.square_no is null
    )
    or (
        n.square_no is null
    )
    or (
        o.seq_no <> n.seq_no
        or o.trans_date <> n.trans_date
        or o.clear_date <> n.clear_date
        or o.square_date <> n.square_date
        or o.old_square_date <> n.old_square_date
        or o.serial_no <> n.serial_no
        or o.asso_serial <> n.asso_serial
        or o.from_flag <> n.from_flag
        or o.trans_code <> n.trans_code
        or o.busin_code <> n.busin_code
        or o.client_type <> n.client_type
        or o.in_client_no <> n.in_client_no
        or o.bank_no <> n.bank_no
        or o.client_no <> n.client_no
        or o.bank_acc <> n.bank_acc
        or o.bank_acc_kind <> n.bank_acc_kind
        or o.channel <> n.channel
        or o.oper_no <> n.oper_no
        or o.term_no <> n.term_no
        or o.branch_no <> n.branch_no
        or o.open_branch <> n.open_branch
        or o.ta_code <> n.ta_code
        or o.prd_code <> n.prd_code
        or o.liqu_dir <> n.liqu_dir
        or o.amt <> n.amt
        or o.curr_type <> n.curr_type
        or o.cash_flag <> n.cash_flag
        or o.unfrozen_amt <> n.unfrozen_amt
        or o.host_trans_code <> n.host_trans_code
        or o.host_date <> n.host_date
        or o.host_serial <> n.host_serial
        or o.frozen_amt <> n.frozen_amt
        or o.check_status <> n.check_status
        or o.distrib_flag <> n.distrib_flag
        or o.amt_flag <> n.amt_flag
        or o.cost_income_flag <> n.cost_income_flag
        or o.cfm_vol <> n.cfm_vol
        or o.cost <> n.cost
        or o.cfm_income <> n.cfm_income
        or o.vol_cumulate <> n.vol_cumulate
        or o.prd_account <> n.prd_account
        or o.prd_account_kind <> n.prd_account_kind
        or o.summary <> n.summary
        or o.status <> n.status
        or o.old_square_no <> n.old_square_no
        or o.err_code <> n.err_code
        or o.err_msg <> n.err_msg
        or o.deal_status <> n.deal_status
        or o.amt1 <> n.amt1
        or o.amt2 <> n.amt2
        or o.amt3 <> n.amt3
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbhissquare_cl(
            square_no -- 清算流水号
            ,seq_no -- 清算顺序号
            ,trans_date -- 交易日期
            ,clear_date -- 清算日期
            ,square_date -- 实际入帐日期
            ,old_square_date -- 变动前square_date
            ,serial_no -- 流水号
            ,asso_serial -- 关联流水号
            ,from_flag -- 发起方
            ,trans_code -- 交易代码
            ,busin_code -- 业务代码
            ,client_type -- 客户类型
            ,in_client_no -- 内部客户编号
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,bank_acc -- 银行账号
            ,bank_acc_kind -- 银行帐户类型
            ,channel -- 交易渠道
            ,oper_no -- 交易柜员
            ,term_no -- 终端编号
            ,branch_no -- 交易机构
            ,open_branch -- 交易所属机构
            ,ta_code -- TA代码
            ,prd_code -- 产品代码
            ,liqu_dir -- 帐务方向
            ,amt -- 清算金额
            ,curr_type -- 币种
            ,cash_flag -- 钞汇标志
            ,unfrozen_amt -- 解冻金额
            ,host_trans_code -- 主机交易码
            ,host_date -- 主机日期
            ,host_serial -- 主机流水号
            ,frozen_amt -- 冻结金额
            ,check_status -- 勾对确认标志
            ,distrib_flag -- 上帐金额来源类型
            ,amt_flag -- 资金类别
            ,cost_income_flag -- 本金收益标志
            ,cfm_vol -- 确认份额
            ,cost -- 本金
            ,cfm_income -- 确认收益
            ,vol_cumulate -- 份额累积积数#
            ,prd_account -- 产品账号
            ,prd_account_kind -- 产品帐户类型
            ,summary -- 摘要说明
            ,status -- 状态
            ,old_square_no -- 原清算流水号
            ,err_code -- 返回码
            ,err_msg -- 错误信息
            ,deal_status -- 接口处理标志
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,reserve4 -- 保留域4
            ,reserve5 -- 保留域5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbhissquare_op(
            square_no -- 清算流水号
            ,seq_no -- 清算顺序号
            ,trans_date -- 交易日期
            ,clear_date -- 清算日期
            ,square_date -- 实际入帐日期
            ,old_square_date -- 变动前square_date
            ,serial_no -- 流水号
            ,asso_serial -- 关联流水号
            ,from_flag -- 发起方
            ,trans_code -- 交易代码
            ,busin_code -- 业务代码
            ,client_type -- 客户类型
            ,in_client_no -- 内部客户编号
            ,bank_no -- 银行编号
            ,client_no -- 客户编号
            ,bank_acc -- 银行账号
            ,bank_acc_kind -- 银行帐户类型
            ,channel -- 交易渠道
            ,oper_no -- 交易柜员
            ,term_no -- 终端编号
            ,branch_no -- 交易机构
            ,open_branch -- 交易所属机构
            ,ta_code -- TA代码
            ,prd_code -- 产品代码
            ,liqu_dir -- 帐务方向
            ,amt -- 清算金额
            ,curr_type -- 币种
            ,cash_flag -- 钞汇标志
            ,unfrozen_amt -- 解冻金额
            ,host_trans_code -- 主机交易码
            ,host_date -- 主机日期
            ,host_serial -- 主机流水号
            ,frozen_amt -- 冻结金额
            ,check_status -- 勾对确认标志
            ,distrib_flag -- 上帐金额来源类型
            ,amt_flag -- 资金类别
            ,cost_income_flag -- 本金收益标志
            ,cfm_vol -- 确认份额
            ,cost -- 本金
            ,cfm_income -- 确认收益
            ,vol_cumulate -- 份额累积积数#
            ,prd_account -- 产品账号
            ,prd_account_kind -- 产品帐户类型
            ,summary -- 摘要说明
            ,status -- 状态
            ,old_square_no -- 原清算流水号
            ,err_code -- 返回码
            ,err_msg -- 错误信息
            ,deal_status -- 接口处理标志
            ,amt1 -- 备用金额1
            ,amt2 -- 备用金额2
            ,amt3 -- 备用金额3
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,reserve4 -- 保留域4
            ,reserve5 -- 保留域5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.square_no -- 清算流水号
    ,o.seq_no -- 清算顺序号
    ,o.trans_date -- 交易日期
    ,o.clear_date -- 清算日期
    ,o.square_date -- 实际入帐日期
    ,o.old_square_date -- 变动前square_date
    ,o.serial_no -- 流水号
    ,o.asso_serial -- 关联流水号
    ,o.from_flag -- 发起方
    ,o.trans_code -- 交易代码
    ,o.busin_code -- 业务代码
    ,o.client_type -- 客户类型
    ,o.in_client_no -- 内部客户编号
    ,o.bank_no -- 银行编号
    ,o.client_no -- 客户编号
    ,o.bank_acc -- 银行账号
    ,o.bank_acc_kind -- 银行帐户类型
    ,o.channel -- 交易渠道
    ,o.oper_no -- 交易柜员
    ,o.term_no -- 终端编号
    ,o.branch_no -- 交易机构
    ,o.open_branch -- 交易所属机构
    ,o.ta_code -- TA代码
    ,o.prd_code -- 产品代码
    ,o.liqu_dir -- 帐务方向
    ,o.amt -- 清算金额
    ,o.curr_type -- 币种
    ,o.cash_flag -- 钞汇标志
    ,o.unfrozen_amt -- 解冻金额
    ,o.host_trans_code -- 主机交易码
    ,o.host_date -- 主机日期
    ,o.host_serial -- 主机流水号
    ,o.frozen_amt -- 冻结金额
    ,o.check_status -- 勾对确认标志
    ,o.distrib_flag -- 上帐金额来源类型
    ,o.amt_flag -- 资金类别
    ,o.cost_income_flag -- 本金收益标志
    ,o.cfm_vol -- 确认份额
    ,o.cost -- 本金
    ,o.cfm_income -- 确认收益
    ,o.vol_cumulate -- 份额累积积数#
    ,o.prd_account -- 产品账号
    ,o.prd_account_kind -- 产品帐户类型
    ,o.summary -- 摘要说明
    ,o.status -- 状态
    ,o.old_square_no -- 原清算流水号
    ,o.err_code -- 返回码
    ,o.err_msg -- 错误信息
    ,o.deal_status -- 接口处理标志
    ,o.amt1 -- 备用金额1
    ,o.amt2 -- 备用金额2
    ,o.amt3 -- 备用金额3
    ,o.reserve1 -- 保留域1
    ,o.reserve2 -- 保留域2
    ,o.reserve3 -- 保留域3
    ,o.reserve4 -- 保留域4
    ,o.reserve5 -- 保留域5
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nfss_tbhissquare_bk o
    left join ${iol_schema}.nfss_tbhissquare_op n
        on
            o.square_no = n.square_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tbhissquare_cl d
        on
            o.square_no = d.square_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nfss_tbhissquare;

-- 4.2 exchange partition
alter table ${iol_schema}.nfss_tbhissquare exchange partition p_19000101 with table ${iol_schema}.nfss_tbhissquare_cl;
alter table ${iol_schema}.nfss_tbhissquare exchange partition p_20991231 with table ${iol_schema}.nfss_tbhissquare_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbhissquare to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbhissquare_op purge;
drop table ${iol_schema}.nfss_tbhissquare_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tbhissquare_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbhissquare',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
