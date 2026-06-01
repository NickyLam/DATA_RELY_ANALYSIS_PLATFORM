/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_vs_payment_trsi_bondsdeals
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
create table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_vs_payment_trsi_bondsdeals
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_op purge;
drop table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_vs_payment_trsi_bondsdeals where 0=1;

create table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_vs_payment_trsi_bondsdeals where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_cl(
            payment_id -- 支付id
            ,aspclient_id -- 部门id
            ,dealsconfirm_id -- 交易确认id
            ,deal_tablename -- 交易表名
            ,deal_id -- 原始交易id
            ,eventtype -- 事件类型
            ,sequence -- 序列号
            ,payment_id_prev -- 前一个支付id
            ,keepfolder_id -- 账户id
            ,assettype -- 资产类型
            ,buztype -- 交易类型
            ,dealtype -- 作业类型
            ,actiontype -- 操作类型
            ,releasedate -- 发布日期
            ,generatedate -- 生成日期
            ,settledate -- 交割日期
            ,cpty_id -- 交易对手id
            ,cpty_name -- 交易对手名称
            ,payreceivetype -- 收付类型
            ,settlecurrency -- 交割币种
            ,settleamount -- 交割金额
            ,securitycode -- 债券交割代码
            ,quantity -- 债券交割金额
            ,act_settledate -- 实际结算日期
            ,act_settlecurrency -- 实际交割币种
            ,act_settleamount -- 实际结算金额
            ,act_securitycode -- 实际交割债券代码
            ,act_quantity -- 实际债券交割金额
            ,pstatus -- 状态
            ,lastmodified -- 最后修改日期
            ,users_id_modifier -- 变更用户id
            ,settlemethod -- 交割方式
            ,act_settlemethod -- 实际交割方式
            ,act_advance_amount -- 预收金额
            ,note -- 备注信息
            ,serial_number -- 原始交易序号
            ,bs -- buy or sell
            ,self_serial_number -- 本方交易编号
            ,self_bs -- buy or sell
            ,self_cash_acc_ename -- 本方资金账户英文户名
            ,self_cash_acc_cname -- 本方资金账户中文户名
            ,self_cash_acc_bank -- 本方资金开户行
            ,self_cash_acc_no -- 本方资金账号
            ,self_cash_acc_bank_ex -- 本方资金开户联行号
            ,self_bond_acc_name -- 本方债券账户名称
            ,self_bond_acc_bank -- 本方债券账户银行
            ,self_bond_acc_no -- 本方债券账户号
            ,self_g_cash_amt -- 本方g_cash_amt
            ,self_g_bond_id -- 本方g_bond_id
            ,self_g_bond_name -- 本方g_bond_name
            ,self_g_bond_amt -- 本方g_bond_amt
            ,self_g_bond_total_amt -- 本方g_bond_total_amt
            ,self_g_ca_name -- 本方g_ca_name
            ,self_g_ca_bank -- 本方g_ca_bank
            ,self_g_ca_no -- 本方g_ca_no
            ,self_g_ca_bank_ex -- 本方g_ca_bank_ex
            ,self_g_ba_name -- 本方g_ba_name
            ,self_g_ba_bank -- 本方g_ba_bank
            ,self_g_ba_no -- 本方g_ba_no
            ,self_g_stl_date -- 本方g_stl_date
            ,self_g_mgr_bank -- 本方g_mgr_bank
            ,self_lastmodified -- 最后修改时间
            ,self_datasymbol_id -- 数据源id
            ,cpty_serial_number -- 交易对手交易编号
            ,cpty_bs -- buy or sell
            ,cpty_cash_acc_ename -- 对手方资金账户英文户名
            ,cpty_cash_acc_cname -- 对手方资金账户中文户名
            ,cpty_cash_acc_bank -- 对手方资金开户行
            ,cpty_cash_acc_no -- 对手方资金账号
            ,cpty_cash_acc_bank_ex -- 对手方资金开户联行号
            ,cpty_bond_acc_name -- 对手方债券账户名称
            ,cpty_bond_acc_bank -- 对手方债券账户银行
            ,cpty_bond_acc_no -- 对手方债券账户号
            ,cpty_g_cash_amt -- 对手方g_cash_amt
            ,cpty_g_bond_id -- 对手方g_bond_id
            ,cpty_g_bond_name -- 对手方g_bond_name
            ,cpty_g_bond_amt -- 对手方g_bond_amt
            ,cpty_g_bond_total_amt -- 对手方g_bond_total_amt
            ,cpty_g_ca_name -- 对手方g_ca_name
            ,cpty_g_ca_bank -- 对手方g_ca_bank
            ,cpty_g_ca_no -- 对手方g_ca_no
            ,cpty_g_ca_bank_ex -- 对手方g_ca_bank_ex
            ,cpty_g_ba_name -- 对手方g_ba_name
            ,cpty_g_ba_bank -- 对手方g_ba_bank
            ,cpty_g_ba_no -- 对手方g_ba_no
            ,cpty_g_stl_date -- 对手方g_stl_date
            ,cpty_g_mgr_bank -- 对手方g_mgr_bank
            ,cpty_lastmodified -- 最后修改时间
            ,cpty_datasymbol_id -- 数据源id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_op(
            payment_id -- 支付id
            ,aspclient_id -- 部门id
            ,dealsconfirm_id -- 交易确认id
            ,deal_tablename -- 交易表名
            ,deal_id -- 原始交易id
            ,eventtype -- 事件类型
            ,sequence -- 序列号
            ,payment_id_prev -- 前一个支付id
            ,keepfolder_id -- 账户id
            ,assettype -- 资产类型
            ,buztype -- 交易类型
            ,dealtype -- 作业类型
            ,actiontype -- 操作类型
            ,releasedate -- 发布日期
            ,generatedate -- 生成日期
            ,settledate -- 交割日期
            ,cpty_id -- 交易对手id
            ,cpty_name -- 交易对手名称
            ,payreceivetype -- 收付类型
            ,settlecurrency -- 交割币种
            ,settleamount -- 交割金额
            ,securitycode -- 债券交割代码
            ,quantity -- 债券交割金额
            ,act_settledate -- 实际结算日期
            ,act_settlecurrency -- 实际交割币种
            ,act_settleamount -- 实际结算金额
            ,act_securitycode -- 实际交割债券代码
            ,act_quantity -- 实际债券交割金额
            ,pstatus -- 状态
            ,lastmodified -- 最后修改日期
            ,users_id_modifier -- 变更用户id
            ,settlemethod -- 交割方式
            ,act_settlemethod -- 实际交割方式
            ,act_advance_amount -- 预收金额
            ,note -- 备注信息
            ,serial_number -- 原始交易序号
            ,bs -- buy or sell
            ,self_serial_number -- 本方交易编号
            ,self_bs -- buy or sell
            ,self_cash_acc_ename -- 本方资金账户英文户名
            ,self_cash_acc_cname -- 本方资金账户中文户名
            ,self_cash_acc_bank -- 本方资金开户行
            ,self_cash_acc_no -- 本方资金账号
            ,self_cash_acc_bank_ex -- 本方资金开户联行号
            ,self_bond_acc_name -- 本方债券账户名称
            ,self_bond_acc_bank -- 本方债券账户银行
            ,self_bond_acc_no -- 本方债券账户号
            ,self_g_cash_amt -- 本方g_cash_amt
            ,self_g_bond_id -- 本方g_bond_id
            ,self_g_bond_name -- 本方g_bond_name
            ,self_g_bond_amt -- 本方g_bond_amt
            ,self_g_bond_total_amt -- 本方g_bond_total_amt
            ,self_g_ca_name -- 本方g_ca_name
            ,self_g_ca_bank -- 本方g_ca_bank
            ,self_g_ca_no -- 本方g_ca_no
            ,self_g_ca_bank_ex -- 本方g_ca_bank_ex
            ,self_g_ba_name -- 本方g_ba_name
            ,self_g_ba_bank -- 本方g_ba_bank
            ,self_g_ba_no -- 本方g_ba_no
            ,self_g_stl_date -- 本方g_stl_date
            ,self_g_mgr_bank -- 本方g_mgr_bank
            ,self_lastmodified -- 最后修改时间
            ,self_datasymbol_id -- 数据源id
            ,cpty_serial_number -- 交易对手交易编号
            ,cpty_bs -- buy or sell
            ,cpty_cash_acc_ename -- 对手方资金账户英文户名
            ,cpty_cash_acc_cname -- 对手方资金账户中文户名
            ,cpty_cash_acc_bank -- 对手方资金开户行
            ,cpty_cash_acc_no -- 对手方资金账号
            ,cpty_cash_acc_bank_ex -- 对手方资金开户联行号
            ,cpty_bond_acc_name -- 对手方债券账户名称
            ,cpty_bond_acc_bank -- 对手方债券账户银行
            ,cpty_bond_acc_no -- 对手方债券账户号
            ,cpty_g_cash_amt -- 对手方g_cash_amt
            ,cpty_g_bond_id -- 对手方g_bond_id
            ,cpty_g_bond_name -- 对手方g_bond_name
            ,cpty_g_bond_amt -- 对手方g_bond_amt
            ,cpty_g_bond_total_amt -- 对手方g_bond_total_amt
            ,cpty_g_ca_name -- 对手方g_ca_name
            ,cpty_g_ca_bank -- 对手方g_ca_bank
            ,cpty_g_ca_no -- 对手方g_ca_no
            ,cpty_g_ca_bank_ex -- 对手方g_ca_bank_ex
            ,cpty_g_ba_name -- 对手方g_ba_name
            ,cpty_g_ba_bank -- 对手方g_ba_bank
            ,cpty_g_ba_no -- 对手方g_ba_no
            ,cpty_g_stl_date -- 对手方g_stl_date
            ,cpty_g_mgr_bank -- 对手方g_mgr_bank
            ,cpty_lastmodified -- 最后修改时间
            ,cpty_datasymbol_id -- 数据源id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.payment_id, o.payment_id) as payment_id -- 支付id
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门id
    ,nvl(n.dealsconfirm_id, o.dealsconfirm_id) as dealsconfirm_id -- 交易确认id
    ,nvl(n.deal_tablename, o.deal_tablename) as deal_tablename -- 交易表名
    ,nvl(n.deal_id, o.deal_id) as deal_id -- 原始交易id
    ,nvl(n.eventtype, o.eventtype) as eventtype -- 事件类型
    ,nvl(n.sequence, o.sequence) as sequence -- 序列号
    ,nvl(n.payment_id_prev, o.payment_id_prev) as payment_id_prev -- 前一个支付id
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 账户id
    ,nvl(n.assettype, o.assettype) as assettype -- 资产类型
    ,nvl(n.buztype, o.buztype) as buztype -- 交易类型
    ,nvl(n.dealtype, o.dealtype) as dealtype -- 作业类型
    ,nvl(n.actiontype, o.actiontype) as actiontype -- 操作类型
    ,nvl(n.releasedate, o.releasedate) as releasedate -- 发布日期
    ,nvl(n.generatedate, o.generatedate) as generatedate -- 生成日期
    ,nvl(n.settledate, o.settledate) as settledate -- 交割日期
    ,nvl(n.cpty_id, o.cpty_id) as cpty_id -- 交易对手id
    ,nvl(n.cpty_name, o.cpty_name) as cpty_name -- 交易对手名称
    ,nvl(n.payreceivetype, o.payreceivetype) as payreceivetype -- 收付类型
    ,nvl(n.settlecurrency, o.settlecurrency) as settlecurrency -- 交割币种
    ,nvl(n.settleamount, o.settleamount) as settleamount -- 交割金额
    ,nvl(n.securitycode, o.securitycode) as securitycode -- 债券交割代码
    ,nvl(n.quantity, o.quantity) as quantity -- 债券交割金额
    ,nvl(n.act_settledate, o.act_settledate) as act_settledate -- 实际结算日期
    ,nvl(n.act_settlecurrency, o.act_settlecurrency) as act_settlecurrency -- 实际交割币种
    ,nvl(n.act_settleamount, o.act_settleamount) as act_settleamount -- 实际结算金额
    ,nvl(n.act_securitycode, o.act_securitycode) as act_securitycode -- 实际交割债券代码
    ,nvl(n.act_quantity, o.act_quantity) as act_quantity -- 实际债券交割金额
    ,nvl(n.pstatus, o.pstatus) as pstatus -- 状态
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后修改日期
    ,nvl(n.users_id_modifier, o.users_id_modifier) as users_id_modifier -- 变更用户id
    ,nvl(n.settlemethod, o.settlemethod) as settlemethod -- 交割方式
    ,nvl(n.act_settlemethod, o.act_settlemethod) as act_settlemethod -- 实际交割方式
    ,nvl(n.act_advance_amount, o.act_advance_amount) as act_advance_amount -- 预收金额
    ,nvl(n.note, o.note) as note -- 备注信息
    ,nvl(n.serial_number, o.serial_number) as serial_number -- 原始交易序号
    ,nvl(n.bs, o.bs) as bs -- buy or sell
    ,nvl(n.self_serial_number, o.self_serial_number) as self_serial_number -- 本方交易编号
    ,nvl(n.self_bs, o.self_bs) as self_bs -- buy or sell
    ,nvl(n.self_cash_acc_ename, o.self_cash_acc_ename) as self_cash_acc_ename -- 本方资金账户英文户名
    ,nvl(n.self_cash_acc_cname, o.self_cash_acc_cname) as self_cash_acc_cname -- 本方资金账户中文户名
    ,nvl(n.self_cash_acc_bank, o.self_cash_acc_bank) as self_cash_acc_bank -- 本方资金开户行
    ,nvl(n.self_cash_acc_no, o.self_cash_acc_no) as self_cash_acc_no -- 本方资金账号
    ,nvl(n.self_cash_acc_bank_ex, o.self_cash_acc_bank_ex) as self_cash_acc_bank_ex -- 本方资金开户联行号
    ,nvl(n.self_bond_acc_name, o.self_bond_acc_name) as self_bond_acc_name -- 本方债券账户名称
    ,nvl(n.self_bond_acc_bank, o.self_bond_acc_bank) as self_bond_acc_bank -- 本方债券账户银行
    ,nvl(n.self_bond_acc_no, o.self_bond_acc_no) as self_bond_acc_no -- 本方债券账户号
    ,nvl(n.self_g_cash_amt, o.self_g_cash_amt) as self_g_cash_amt -- 本方g_cash_amt
    ,nvl(n.self_g_bond_id, o.self_g_bond_id) as self_g_bond_id -- 本方g_bond_id
    ,nvl(n.self_g_bond_name, o.self_g_bond_name) as self_g_bond_name -- 本方g_bond_name
    ,nvl(n.self_g_bond_amt, o.self_g_bond_amt) as self_g_bond_amt -- 本方g_bond_amt
    ,nvl(n.self_g_bond_total_amt, o.self_g_bond_total_amt) as self_g_bond_total_amt -- 本方g_bond_total_amt
    ,nvl(n.self_g_ca_name, o.self_g_ca_name) as self_g_ca_name -- 本方g_ca_name
    ,nvl(n.self_g_ca_bank, o.self_g_ca_bank) as self_g_ca_bank -- 本方g_ca_bank
    ,nvl(n.self_g_ca_no, o.self_g_ca_no) as self_g_ca_no -- 本方g_ca_no
    ,nvl(n.self_g_ca_bank_ex, o.self_g_ca_bank_ex) as self_g_ca_bank_ex -- 本方g_ca_bank_ex
    ,nvl(n.self_g_ba_name, o.self_g_ba_name) as self_g_ba_name -- 本方g_ba_name
    ,nvl(n.self_g_ba_bank, o.self_g_ba_bank) as self_g_ba_bank -- 本方g_ba_bank
    ,nvl(n.self_g_ba_no, o.self_g_ba_no) as self_g_ba_no -- 本方g_ba_no
    ,nvl(n.self_g_stl_date, o.self_g_stl_date) as self_g_stl_date -- 本方g_stl_date
    ,nvl(n.self_g_mgr_bank, o.self_g_mgr_bank) as self_g_mgr_bank -- 本方g_mgr_bank
    ,nvl(n.self_lastmodified, o.self_lastmodified) as self_lastmodified -- 最后修改时间
    ,nvl(n.self_datasymbol_id, o.self_datasymbol_id) as self_datasymbol_id -- 数据源id
    ,nvl(n.cpty_serial_number, o.cpty_serial_number) as cpty_serial_number -- 交易对手交易编号
    ,nvl(n.cpty_bs, o.cpty_bs) as cpty_bs -- buy or sell
    ,nvl(n.cpty_cash_acc_ename, o.cpty_cash_acc_ename) as cpty_cash_acc_ename -- 对手方资金账户英文户名
    ,nvl(n.cpty_cash_acc_cname, o.cpty_cash_acc_cname) as cpty_cash_acc_cname -- 对手方资金账户中文户名
    ,nvl(n.cpty_cash_acc_bank, o.cpty_cash_acc_bank) as cpty_cash_acc_bank -- 对手方资金开户行
    ,nvl(n.cpty_cash_acc_no, o.cpty_cash_acc_no) as cpty_cash_acc_no -- 对手方资金账号
    ,nvl(n.cpty_cash_acc_bank_ex, o.cpty_cash_acc_bank_ex) as cpty_cash_acc_bank_ex -- 对手方资金开户联行号
    ,nvl(n.cpty_bond_acc_name, o.cpty_bond_acc_name) as cpty_bond_acc_name -- 对手方债券账户名称
    ,nvl(n.cpty_bond_acc_bank, o.cpty_bond_acc_bank) as cpty_bond_acc_bank -- 对手方债券账户银行
    ,nvl(n.cpty_bond_acc_no, o.cpty_bond_acc_no) as cpty_bond_acc_no -- 对手方债券账户号
    ,nvl(n.cpty_g_cash_amt, o.cpty_g_cash_amt) as cpty_g_cash_amt -- 对手方g_cash_amt
    ,nvl(n.cpty_g_bond_id, o.cpty_g_bond_id) as cpty_g_bond_id -- 对手方g_bond_id
    ,nvl(n.cpty_g_bond_name, o.cpty_g_bond_name) as cpty_g_bond_name -- 对手方g_bond_name
    ,nvl(n.cpty_g_bond_amt, o.cpty_g_bond_amt) as cpty_g_bond_amt -- 对手方g_bond_amt
    ,nvl(n.cpty_g_bond_total_amt, o.cpty_g_bond_total_amt) as cpty_g_bond_total_amt -- 对手方g_bond_total_amt
    ,nvl(n.cpty_g_ca_name, o.cpty_g_ca_name) as cpty_g_ca_name -- 对手方g_ca_name
    ,nvl(n.cpty_g_ca_bank, o.cpty_g_ca_bank) as cpty_g_ca_bank -- 对手方g_ca_bank
    ,nvl(n.cpty_g_ca_no, o.cpty_g_ca_no) as cpty_g_ca_no -- 对手方g_ca_no
    ,nvl(n.cpty_g_ca_bank_ex, o.cpty_g_ca_bank_ex) as cpty_g_ca_bank_ex -- 对手方g_ca_bank_ex
    ,nvl(n.cpty_g_ba_name, o.cpty_g_ba_name) as cpty_g_ba_name -- 对手方g_ba_name
    ,nvl(n.cpty_g_ba_bank, o.cpty_g_ba_bank) as cpty_g_ba_bank -- 对手方g_ba_bank
    ,nvl(n.cpty_g_ba_no, o.cpty_g_ba_no) as cpty_g_ba_no -- 对手方g_ba_no
    ,nvl(n.cpty_g_stl_date, o.cpty_g_stl_date) as cpty_g_stl_date -- 对手方g_stl_date
    ,nvl(n.cpty_g_mgr_bank, o.cpty_g_mgr_bank) as cpty_g_mgr_bank -- 对手方g_mgr_bank
    ,nvl(n.cpty_lastmodified, o.cpty_lastmodified) as cpty_lastmodified -- 最后修改时间
    ,nvl(n.cpty_datasymbol_id, o.cpty_datasymbol_id) as cpty_datasymbol_id -- 数据源id
    ,case when
            n.payment_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.payment_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.payment_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_vs_payment_trsi_bondsdeals where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.payment_id = n.payment_id
where (
        o.payment_id is null
    )
    or (
        n.payment_id is null
    )
    or (
        o.aspclient_id <> n.aspclient_id
        or o.dealsconfirm_id <> n.dealsconfirm_id
        or o.deal_tablename <> n.deal_tablename
        or o.deal_id <> n.deal_id
        or o.eventtype <> n.eventtype
        or o.sequence <> n.sequence
        or o.payment_id_prev <> n.payment_id_prev
        or o.keepfolder_id <> n.keepfolder_id
        or o.assettype <> n.assettype
        or o.buztype <> n.buztype
        or o.dealtype <> n.dealtype
        or o.actiontype <> n.actiontype
        or o.releasedate <> n.releasedate
        or o.generatedate <> n.generatedate
        or o.settledate <> n.settledate
        or o.cpty_id <> n.cpty_id
        or o.cpty_name <> n.cpty_name
        or o.payreceivetype <> n.payreceivetype
        or o.settlecurrency <> n.settlecurrency
        or o.settleamount <> n.settleamount
        or o.securitycode <> n.securitycode
        or o.quantity <> n.quantity
        or o.act_settledate <> n.act_settledate
        or o.act_settlecurrency <> n.act_settlecurrency
        or o.act_settleamount <> n.act_settleamount
        or o.act_securitycode <> n.act_securitycode
        or o.act_quantity <> n.act_quantity
        or o.pstatus <> n.pstatus
        or o.lastmodified <> n.lastmodified
        or o.users_id_modifier <> n.users_id_modifier
        or o.settlemethod <> n.settlemethod
        or o.act_settlemethod <> n.act_settlemethod
        or o.act_advance_amount <> n.act_advance_amount
        or o.note <> n.note
        or o.serial_number <> n.serial_number
        or o.bs <> n.bs
        or o.self_serial_number <> n.self_serial_number
        or o.self_bs <> n.self_bs
        or o.self_cash_acc_ename <> n.self_cash_acc_ename
        or o.self_cash_acc_cname <> n.self_cash_acc_cname
        or o.self_cash_acc_bank <> n.self_cash_acc_bank
        or o.self_cash_acc_no <> n.self_cash_acc_no
        or o.self_cash_acc_bank_ex <> n.self_cash_acc_bank_ex
        or o.self_bond_acc_name <> n.self_bond_acc_name
        or o.self_bond_acc_bank <> n.self_bond_acc_bank
        or o.self_bond_acc_no <> n.self_bond_acc_no
        or o.self_g_cash_amt <> n.self_g_cash_amt
        or o.self_g_bond_id <> n.self_g_bond_id
        or o.self_g_bond_name <> n.self_g_bond_name
        or o.self_g_bond_amt <> n.self_g_bond_amt
        or o.self_g_bond_total_amt <> n.self_g_bond_total_amt
        or o.self_g_ca_name <> n.self_g_ca_name
        or o.self_g_ca_bank <> n.self_g_ca_bank
        or o.self_g_ca_no <> n.self_g_ca_no
        or o.self_g_ca_bank_ex <> n.self_g_ca_bank_ex
        or o.self_g_ba_name <> n.self_g_ba_name
        or o.self_g_ba_bank <> n.self_g_ba_bank
        or o.self_g_ba_no <> n.self_g_ba_no
        or o.self_g_stl_date <> n.self_g_stl_date
        or o.self_g_mgr_bank <> n.self_g_mgr_bank
        or o.self_lastmodified <> n.self_lastmodified
        or o.self_datasymbol_id <> n.self_datasymbol_id
        or o.cpty_serial_number <> n.cpty_serial_number
        or o.cpty_bs <> n.cpty_bs
        or o.cpty_cash_acc_ename <> n.cpty_cash_acc_ename
        or o.cpty_cash_acc_cname <> n.cpty_cash_acc_cname
        or o.cpty_cash_acc_bank <> n.cpty_cash_acc_bank
        or o.cpty_cash_acc_no <> n.cpty_cash_acc_no
        or o.cpty_cash_acc_bank_ex <> n.cpty_cash_acc_bank_ex
        or o.cpty_bond_acc_name <> n.cpty_bond_acc_name
        or o.cpty_bond_acc_bank <> n.cpty_bond_acc_bank
        or o.cpty_bond_acc_no <> n.cpty_bond_acc_no
        or o.cpty_g_cash_amt <> n.cpty_g_cash_amt
        or o.cpty_g_bond_id <> n.cpty_g_bond_id
        or o.cpty_g_bond_name <> n.cpty_g_bond_name
        or o.cpty_g_bond_amt <> n.cpty_g_bond_amt
        or o.cpty_g_bond_total_amt <> n.cpty_g_bond_total_amt
        or o.cpty_g_ca_name <> n.cpty_g_ca_name
        or o.cpty_g_ca_bank <> n.cpty_g_ca_bank
        or o.cpty_g_ca_no <> n.cpty_g_ca_no
        or o.cpty_g_ca_bank_ex <> n.cpty_g_ca_bank_ex
        or o.cpty_g_ba_name <> n.cpty_g_ba_name
        or o.cpty_g_ba_bank <> n.cpty_g_ba_bank
        or o.cpty_g_ba_no <> n.cpty_g_ba_no
        or o.cpty_g_stl_date <> n.cpty_g_stl_date
        or o.cpty_g_mgr_bank <> n.cpty_g_mgr_bank
        or o.cpty_lastmodified <> n.cpty_lastmodified
        or o.cpty_datasymbol_id <> n.cpty_datasymbol_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_cl(
            payment_id -- 支付id
            ,aspclient_id -- 部门id
            ,dealsconfirm_id -- 交易确认id
            ,deal_tablename -- 交易表名
            ,deal_id -- 原始交易id
            ,eventtype -- 事件类型
            ,sequence -- 序列号
            ,payment_id_prev -- 前一个支付id
            ,keepfolder_id -- 账户id
            ,assettype -- 资产类型
            ,buztype -- 交易类型
            ,dealtype -- 作业类型
            ,actiontype -- 操作类型
            ,releasedate -- 发布日期
            ,generatedate -- 生成日期
            ,settledate -- 交割日期
            ,cpty_id -- 交易对手id
            ,cpty_name -- 交易对手名称
            ,payreceivetype -- 收付类型
            ,settlecurrency -- 交割币种
            ,settleamount -- 交割金额
            ,securitycode -- 债券交割代码
            ,quantity -- 债券交割金额
            ,act_settledate -- 实际结算日期
            ,act_settlecurrency -- 实际交割币种
            ,act_settleamount -- 实际结算金额
            ,act_securitycode -- 实际交割债券代码
            ,act_quantity -- 实际债券交割金额
            ,pstatus -- 状态
            ,lastmodified -- 最后修改日期
            ,users_id_modifier -- 变更用户id
            ,settlemethod -- 交割方式
            ,act_settlemethod -- 实际交割方式
            ,act_advance_amount -- 预收金额
            ,note -- 备注信息
            ,serial_number -- 原始交易序号
            ,bs -- buy or sell
            ,self_serial_number -- 本方交易编号
            ,self_bs -- buy or sell
            ,self_cash_acc_ename -- 本方资金账户英文户名
            ,self_cash_acc_cname -- 本方资金账户中文户名
            ,self_cash_acc_bank -- 本方资金开户行
            ,self_cash_acc_no -- 本方资金账号
            ,self_cash_acc_bank_ex -- 本方资金开户联行号
            ,self_bond_acc_name -- 本方债券账户名称
            ,self_bond_acc_bank -- 本方债券账户银行
            ,self_bond_acc_no -- 本方债券账户号
            ,self_g_cash_amt -- 本方g_cash_amt
            ,self_g_bond_id -- 本方g_bond_id
            ,self_g_bond_name -- 本方g_bond_name
            ,self_g_bond_amt -- 本方g_bond_amt
            ,self_g_bond_total_amt -- 本方g_bond_total_amt
            ,self_g_ca_name -- 本方g_ca_name
            ,self_g_ca_bank -- 本方g_ca_bank
            ,self_g_ca_no -- 本方g_ca_no
            ,self_g_ca_bank_ex -- 本方g_ca_bank_ex
            ,self_g_ba_name -- 本方g_ba_name
            ,self_g_ba_bank -- 本方g_ba_bank
            ,self_g_ba_no -- 本方g_ba_no
            ,self_g_stl_date -- 本方g_stl_date
            ,self_g_mgr_bank -- 本方g_mgr_bank
            ,self_lastmodified -- 最后修改时间
            ,self_datasymbol_id -- 数据源id
            ,cpty_serial_number -- 交易对手交易编号
            ,cpty_bs -- buy or sell
            ,cpty_cash_acc_ename -- 对手方资金账户英文户名
            ,cpty_cash_acc_cname -- 对手方资金账户中文户名
            ,cpty_cash_acc_bank -- 对手方资金开户行
            ,cpty_cash_acc_no -- 对手方资金账号
            ,cpty_cash_acc_bank_ex -- 对手方资金开户联行号
            ,cpty_bond_acc_name -- 对手方债券账户名称
            ,cpty_bond_acc_bank -- 对手方债券账户银行
            ,cpty_bond_acc_no -- 对手方债券账户号
            ,cpty_g_cash_amt -- 对手方g_cash_amt
            ,cpty_g_bond_id -- 对手方g_bond_id
            ,cpty_g_bond_name -- 对手方g_bond_name
            ,cpty_g_bond_amt -- 对手方g_bond_amt
            ,cpty_g_bond_total_amt -- 对手方g_bond_total_amt
            ,cpty_g_ca_name -- 对手方g_ca_name
            ,cpty_g_ca_bank -- 对手方g_ca_bank
            ,cpty_g_ca_no -- 对手方g_ca_no
            ,cpty_g_ca_bank_ex -- 对手方g_ca_bank_ex
            ,cpty_g_ba_name -- 对手方g_ba_name
            ,cpty_g_ba_bank -- 对手方g_ba_bank
            ,cpty_g_ba_no -- 对手方g_ba_no
            ,cpty_g_stl_date -- 对手方g_stl_date
            ,cpty_g_mgr_bank -- 对手方g_mgr_bank
            ,cpty_lastmodified -- 最后修改时间
            ,cpty_datasymbol_id -- 数据源id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_op(
            payment_id -- 支付id
            ,aspclient_id -- 部门id
            ,dealsconfirm_id -- 交易确认id
            ,deal_tablename -- 交易表名
            ,deal_id -- 原始交易id
            ,eventtype -- 事件类型
            ,sequence -- 序列号
            ,payment_id_prev -- 前一个支付id
            ,keepfolder_id -- 账户id
            ,assettype -- 资产类型
            ,buztype -- 交易类型
            ,dealtype -- 作业类型
            ,actiontype -- 操作类型
            ,releasedate -- 发布日期
            ,generatedate -- 生成日期
            ,settledate -- 交割日期
            ,cpty_id -- 交易对手id
            ,cpty_name -- 交易对手名称
            ,payreceivetype -- 收付类型
            ,settlecurrency -- 交割币种
            ,settleamount -- 交割金额
            ,securitycode -- 债券交割代码
            ,quantity -- 债券交割金额
            ,act_settledate -- 实际结算日期
            ,act_settlecurrency -- 实际交割币种
            ,act_settleamount -- 实际结算金额
            ,act_securitycode -- 实际交割债券代码
            ,act_quantity -- 实际债券交割金额
            ,pstatus -- 状态
            ,lastmodified -- 最后修改日期
            ,users_id_modifier -- 变更用户id
            ,settlemethod -- 交割方式
            ,act_settlemethod -- 实际交割方式
            ,act_advance_amount -- 预收金额
            ,note -- 备注信息
            ,serial_number -- 原始交易序号
            ,bs -- buy or sell
            ,self_serial_number -- 本方交易编号
            ,self_bs -- buy or sell
            ,self_cash_acc_ename -- 本方资金账户英文户名
            ,self_cash_acc_cname -- 本方资金账户中文户名
            ,self_cash_acc_bank -- 本方资金开户行
            ,self_cash_acc_no -- 本方资金账号
            ,self_cash_acc_bank_ex -- 本方资金开户联行号
            ,self_bond_acc_name -- 本方债券账户名称
            ,self_bond_acc_bank -- 本方债券账户银行
            ,self_bond_acc_no -- 本方债券账户号
            ,self_g_cash_amt -- 本方g_cash_amt
            ,self_g_bond_id -- 本方g_bond_id
            ,self_g_bond_name -- 本方g_bond_name
            ,self_g_bond_amt -- 本方g_bond_amt
            ,self_g_bond_total_amt -- 本方g_bond_total_amt
            ,self_g_ca_name -- 本方g_ca_name
            ,self_g_ca_bank -- 本方g_ca_bank
            ,self_g_ca_no -- 本方g_ca_no
            ,self_g_ca_bank_ex -- 本方g_ca_bank_ex
            ,self_g_ba_name -- 本方g_ba_name
            ,self_g_ba_bank -- 本方g_ba_bank
            ,self_g_ba_no -- 本方g_ba_no
            ,self_g_stl_date -- 本方g_stl_date
            ,self_g_mgr_bank -- 本方g_mgr_bank
            ,self_lastmodified -- 最后修改时间
            ,self_datasymbol_id -- 数据源id
            ,cpty_serial_number -- 交易对手交易编号
            ,cpty_bs -- buy or sell
            ,cpty_cash_acc_ename -- 对手方资金账户英文户名
            ,cpty_cash_acc_cname -- 对手方资金账户中文户名
            ,cpty_cash_acc_bank -- 对手方资金开户行
            ,cpty_cash_acc_no -- 对手方资金账号
            ,cpty_cash_acc_bank_ex -- 对手方资金开户联行号
            ,cpty_bond_acc_name -- 对手方债券账户名称
            ,cpty_bond_acc_bank -- 对手方债券账户银行
            ,cpty_bond_acc_no -- 对手方债券账户号
            ,cpty_g_cash_amt -- 对手方g_cash_amt
            ,cpty_g_bond_id -- 对手方g_bond_id
            ,cpty_g_bond_name -- 对手方g_bond_name
            ,cpty_g_bond_amt -- 对手方g_bond_amt
            ,cpty_g_bond_total_amt -- 对手方g_bond_total_amt
            ,cpty_g_ca_name -- 对手方g_ca_name
            ,cpty_g_ca_bank -- 对手方g_ca_bank
            ,cpty_g_ca_no -- 对手方g_ca_no
            ,cpty_g_ca_bank_ex -- 对手方g_ca_bank_ex
            ,cpty_g_ba_name -- 对手方g_ba_name
            ,cpty_g_ba_bank -- 对手方g_ba_bank
            ,cpty_g_ba_no -- 对手方g_ba_no
            ,cpty_g_stl_date -- 对手方g_stl_date
            ,cpty_g_mgr_bank -- 对手方g_mgr_bank
            ,cpty_lastmodified -- 最后修改时间
            ,cpty_datasymbol_id -- 数据源id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.payment_id -- 支付id
    ,o.aspclient_id -- 部门id
    ,o.dealsconfirm_id -- 交易确认id
    ,o.deal_tablename -- 交易表名
    ,o.deal_id -- 原始交易id
    ,o.eventtype -- 事件类型
    ,o.sequence -- 序列号
    ,o.payment_id_prev -- 前一个支付id
    ,o.keepfolder_id -- 账户id
    ,o.assettype -- 资产类型
    ,o.buztype -- 交易类型
    ,o.dealtype -- 作业类型
    ,o.actiontype -- 操作类型
    ,o.releasedate -- 发布日期
    ,o.generatedate -- 生成日期
    ,o.settledate -- 交割日期
    ,o.cpty_id -- 交易对手id
    ,o.cpty_name -- 交易对手名称
    ,o.payreceivetype -- 收付类型
    ,o.settlecurrency -- 交割币种
    ,o.settleamount -- 交割金额
    ,o.securitycode -- 债券交割代码
    ,o.quantity -- 债券交割金额
    ,o.act_settledate -- 实际结算日期
    ,o.act_settlecurrency -- 实际交割币种
    ,o.act_settleamount -- 实际结算金额
    ,o.act_securitycode -- 实际交割债券代码
    ,o.act_quantity -- 实际债券交割金额
    ,o.pstatus -- 状态
    ,o.lastmodified -- 最后修改日期
    ,o.users_id_modifier -- 变更用户id
    ,o.settlemethod -- 交割方式
    ,o.act_settlemethod -- 实际交割方式
    ,o.act_advance_amount -- 预收金额
    ,o.note -- 备注信息
    ,o.serial_number -- 原始交易序号
    ,o.bs -- buy or sell
    ,o.self_serial_number -- 本方交易编号
    ,o.self_bs -- buy or sell
    ,o.self_cash_acc_ename -- 本方资金账户英文户名
    ,o.self_cash_acc_cname -- 本方资金账户中文户名
    ,o.self_cash_acc_bank -- 本方资金开户行
    ,o.self_cash_acc_no -- 本方资金账号
    ,o.self_cash_acc_bank_ex -- 本方资金开户联行号
    ,o.self_bond_acc_name -- 本方债券账户名称
    ,o.self_bond_acc_bank -- 本方债券账户银行
    ,o.self_bond_acc_no -- 本方债券账户号
    ,o.self_g_cash_amt -- 本方g_cash_amt
    ,o.self_g_bond_id -- 本方g_bond_id
    ,o.self_g_bond_name -- 本方g_bond_name
    ,o.self_g_bond_amt -- 本方g_bond_amt
    ,o.self_g_bond_total_amt -- 本方g_bond_total_amt
    ,o.self_g_ca_name -- 本方g_ca_name
    ,o.self_g_ca_bank -- 本方g_ca_bank
    ,o.self_g_ca_no -- 本方g_ca_no
    ,o.self_g_ca_bank_ex -- 本方g_ca_bank_ex
    ,o.self_g_ba_name -- 本方g_ba_name
    ,o.self_g_ba_bank -- 本方g_ba_bank
    ,o.self_g_ba_no -- 本方g_ba_no
    ,o.self_g_stl_date -- 本方g_stl_date
    ,o.self_g_mgr_bank -- 本方g_mgr_bank
    ,o.self_lastmodified -- 最后修改时间
    ,o.self_datasymbol_id -- 数据源id
    ,o.cpty_serial_number -- 交易对手交易编号
    ,o.cpty_bs -- buy or sell
    ,o.cpty_cash_acc_ename -- 对手方资金账户英文户名
    ,o.cpty_cash_acc_cname -- 对手方资金账户中文户名
    ,o.cpty_cash_acc_bank -- 对手方资金开户行
    ,o.cpty_cash_acc_no -- 对手方资金账号
    ,o.cpty_cash_acc_bank_ex -- 对手方资金开户联行号
    ,o.cpty_bond_acc_name -- 对手方债券账户名称
    ,o.cpty_bond_acc_bank -- 对手方债券账户银行
    ,o.cpty_bond_acc_no -- 对手方债券账户号
    ,o.cpty_g_cash_amt -- 对手方g_cash_amt
    ,o.cpty_g_bond_id -- 对手方g_bond_id
    ,o.cpty_g_bond_name -- 对手方g_bond_name
    ,o.cpty_g_bond_amt -- 对手方g_bond_amt
    ,o.cpty_g_bond_total_amt -- 对手方g_bond_total_amt
    ,o.cpty_g_ca_name -- 对手方g_ca_name
    ,o.cpty_g_ca_bank -- 对手方g_ca_bank
    ,o.cpty_g_ca_no -- 对手方g_ca_no
    ,o.cpty_g_ca_bank_ex -- 对手方g_ca_bank_ex
    ,o.cpty_g_ba_name -- 对手方g_ba_name
    ,o.cpty_g_ba_bank -- 对手方g_ba_bank
    ,o.cpty_g_ba_no -- 对手方g_ba_no
    ,o.cpty_g_stl_date -- 对手方g_stl_date
    ,o.cpty_g_mgr_bank -- 对手方g_mgr_bank
    ,o.cpty_lastmodified -- 最后修改时间
    ,o.cpty_datasymbol_id -- 数据源id
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
from ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_bk o
    left join ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_op n
        on
            o.payment_id = n.payment_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_cl d
        on
            o.payment_id = d.payment_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ctms_vs_payment_trsi_bondsdeals') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals exchange partition p_${batch_date} with table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_cl;
alter table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals exchange partition p_20991231 with table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_vs_payment_trsi_bondsdeals to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_op purge;
drop table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_vs_payment_trsi_bondsdeals',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
