/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_draft_centre_info
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
create table ${iol_schema}.bdms_bms_draft_centre_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_draft_centre_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_draft_centre_info_op purge;
drop table ${iol_schema}.bdms_bms_draft_centre_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_draft_centre_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_draft_centre_info where 0=1;

create table ${iol_schema}.bdms_bms_draft_centre_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_draft_centre_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_draft_centre_info_cl(
            id -- ID
            ,draft_number -- 票据号码
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,src_type -- 票据来源
            ,buy_contract_id -- 买入协议ID
            ,trans_id -- 交易ID
            ,remit_date -- 出票日期
            ,maturity_date -- 票据到期日期
            ,draft_amount -- 票面金额
            ,remitter_role -- 出票人类别
            ,remitter_cmonid -- 出票人组织机构代码
            ,remitter_name -- 出票人名称
            ,remitter_account -- 出票人账号
            ,remitter_bank_no -- 出票人开户行号
            ,remitter_bank_name -- 出票人开户行名称
            ,df_drwr_cdtratgs -- 出票人-信用等级
            ,df_drwr_cdtratgsagcy -- 出票人-评级机构
            ,df_drwr_cdtratgduedt -- 出票人-评级到期日
            ,acceptor_role -- 承兑人类别
            ,acceptor_name -- 承兑人
            ,acceptor_bank_no -- 承兑人开户行
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,drawee_bank_name -- 付款行全称
            ,drawee_bank_no -- 付款行行号
            ,drawee_address -- 付款行地址
            ,payee_name -- 票面收款人名称
            ,payee_account -- 票面收款人账号
            ,payee_bank_no -- 票面收款人开户行号
            ,payee_bank_name -- 票面收款人开户行
            ,payee_cust_no -- 收款人客户NO
            ,payee_organ_code -- 票面收款人组织机构代码
            ,draft_remark -- 票面备注
            ,inner_accept_flag -- 是否系统内承兑： 0 否 1 是
            ,belong_branch_no -- 票据所属机构号
            ,store_status -- 实物库存状态
            ,last_operator_no -- 最后修改操作员号
            ,last_txn_date -- 最后修改时间
            ,endorse_times -- 背书次数
            ,deduct_status -- 扣款状态（是否扣款）： 0 否 1 是
            ,first_trans_id -- 最初进系统的交易ID
            ,recently_trans_id -- 最近进系统的交易ID
            ,payment_status -- 付款状态（是否付款）： 0 否 1 是
            ,del_flag -- 删除标志： 0 否 1 是
            ,report_of_loss_flag -- 挂失状态（是否挂失）： 0 否 1 是
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,reserve4 -- 备注4
            ,apply_trans_id -- 申请ID
            ,sign_trans_id -- 签收ID
            ,prov_interest -- PROV_INTEREST
            ,rema_interest -- REMA_INTEREST
            ,is_receipt -- 是否是小票（1-是，0-否。金额小于等于500万元人民币，且承兑银行非我行（系统外银行）为”是“ ，反之为”否“）
            ,stock_status -- 是否再贴现（1-已再贴现，0-库存。）
            ,draft_transfer_flag -- 票面不得转让标志：EM00 可再转让 EM01 不得转让
            ,voucher_no -- 凭证号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_draft_centre_info_op(
            id -- ID
            ,draft_number -- 票据号码
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,src_type -- 票据来源
            ,buy_contract_id -- 买入协议ID
            ,trans_id -- 交易ID
            ,remit_date -- 出票日期
            ,maturity_date -- 票据到期日期
            ,draft_amount -- 票面金额
            ,remitter_role -- 出票人类别
            ,remitter_cmonid -- 出票人组织机构代码
            ,remitter_name -- 出票人名称
            ,remitter_account -- 出票人账号
            ,remitter_bank_no -- 出票人开户行号
            ,remitter_bank_name -- 出票人开户行名称
            ,df_drwr_cdtratgs -- 出票人-信用等级
            ,df_drwr_cdtratgsagcy -- 出票人-评级机构
            ,df_drwr_cdtratgduedt -- 出票人-评级到期日
            ,acceptor_role -- 承兑人类别
            ,acceptor_name -- 承兑人
            ,acceptor_bank_no -- 承兑人开户行
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,drawee_bank_name -- 付款行全称
            ,drawee_bank_no -- 付款行行号
            ,drawee_address -- 付款行地址
            ,payee_name -- 票面收款人名称
            ,payee_account -- 票面收款人账号
            ,payee_bank_no -- 票面收款人开户行号
            ,payee_bank_name -- 票面收款人开户行
            ,payee_cust_no -- 收款人客户NO
            ,payee_organ_code -- 票面收款人组织机构代码
            ,draft_remark -- 票面备注
            ,inner_accept_flag -- 是否系统内承兑： 0 否 1 是
            ,belong_branch_no -- 票据所属机构号
            ,store_status -- 实物库存状态
            ,last_operator_no -- 最后修改操作员号
            ,last_txn_date -- 最后修改时间
            ,endorse_times -- 背书次数
            ,deduct_status -- 扣款状态（是否扣款）： 0 否 1 是
            ,first_trans_id -- 最初进系统的交易ID
            ,recently_trans_id -- 最近进系统的交易ID
            ,payment_status -- 付款状态（是否付款）： 0 否 1 是
            ,del_flag -- 删除标志： 0 否 1 是
            ,report_of_loss_flag -- 挂失状态（是否挂失）： 0 否 1 是
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,reserve4 -- 备注4
            ,apply_trans_id -- 申请ID
            ,sign_trans_id -- 签收ID
            ,prov_interest -- PROV_INTEREST
            ,rema_interest -- REMA_INTEREST
            ,is_receipt -- 是否是小票（1-是，0-否。金额小于等于500万元人民币，且承兑银行非我行（系统外银行）为”是“ ，反之为”否“）
            ,stock_status -- 是否再贴现（1-已再贴现，0-库存。）
            ,draft_transfer_flag -- 票面不得转让标志：EM00 可再转让 EM01 不得转让
            ,voucher_no -- 凭证号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据号码
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据属性： 1 纸票 2 电票
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： 1 银票 2 商票
    ,nvl(n.src_type, o.src_type) as src_type -- 票据来源
    ,nvl(n.buy_contract_id, o.buy_contract_id) as buy_contract_id -- 买入协议ID
    ,nvl(n.trans_id, o.trans_id) as trans_id -- 交易ID
    ,nvl(n.remit_date, o.remit_date) as remit_date -- 出票日期
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 票据到期日期
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票面金额
    ,nvl(n.remitter_role, o.remitter_role) as remitter_role -- 出票人类别
    ,nvl(n.remitter_cmonid, o.remitter_cmonid) as remitter_cmonid -- 出票人组织机构代码
    ,nvl(n.remitter_name, o.remitter_name) as remitter_name -- 出票人名称
    ,nvl(n.remitter_account, o.remitter_account) as remitter_account -- 出票人账号
    ,nvl(n.remitter_bank_no, o.remitter_bank_no) as remitter_bank_no -- 出票人开户行号
    ,nvl(n.remitter_bank_name, o.remitter_bank_name) as remitter_bank_name -- 出票人开户行名称
    ,nvl(n.df_drwr_cdtratgs, o.df_drwr_cdtratgs) as df_drwr_cdtratgs -- 出票人-信用等级
    ,nvl(n.df_drwr_cdtratgsagcy, o.df_drwr_cdtratgsagcy) as df_drwr_cdtratgsagcy -- 出票人-评级机构
    ,nvl(n.df_drwr_cdtratgduedt, o.df_drwr_cdtratgduedt) as df_drwr_cdtratgduedt -- 出票人-评级到期日
    ,nvl(n.acceptor_role, o.acceptor_role) as acceptor_role -- 承兑人类别
    ,nvl(n.acceptor_name, o.acceptor_name) as acceptor_name -- 承兑人
    ,nvl(n.acceptor_bank_no, o.acceptor_bank_no) as acceptor_bank_no -- 承兑人开户行
    ,nvl(n.acceptor_account, o.acceptor_account) as acceptor_account -- 承兑人账号
    ,nvl(n.acceptor_bank_name, o.acceptor_bank_name) as acceptor_bank_name -- 承兑人开户行名称
    ,nvl(n.drawee_bank_name, o.drawee_bank_name) as drawee_bank_name -- 付款行全称
    ,nvl(n.drawee_bank_no, o.drawee_bank_no) as drawee_bank_no -- 付款行行号
    ,nvl(n.drawee_address, o.drawee_address) as drawee_address -- 付款行地址
    ,nvl(n.payee_name, o.payee_name) as payee_name -- 票面收款人名称
    ,nvl(n.payee_account, o.payee_account) as payee_account -- 票面收款人账号
    ,nvl(n.payee_bank_no, o.payee_bank_no) as payee_bank_no -- 票面收款人开户行号
    ,nvl(n.payee_bank_name, o.payee_bank_name) as payee_bank_name -- 票面收款人开户行
    ,nvl(n.payee_cust_no, o.payee_cust_no) as payee_cust_no -- 收款人客户NO
    ,nvl(n.payee_organ_code, o.payee_organ_code) as payee_organ_code -- 票面收款人组织机构代码
    ,nvl(n.draft_remark, o.draft_remark) as draft_remark -- 票面备注
    ,nvl(n.inner_accept_flag, o.inner_accept_flag) as inner_accept_flag -- 是否系统内承兑： 0 否 1 是
    ,nvl(n.belong_branch_no, o.belong_branch_no) as belong_branch_no -- 票据所属机构号
    ,nvl(n.store_status, o.store_status) as store_status -- 实物库存状态
    ,nvl(n.last_operator_no, o.last_operator_no) as last_operator_no -- 最后修改操作员号
    ,nvl(n.last_txn_date, o.last_txn_date) as last_txn_date -- 最后修改时间
    ,nvl(n.endorse_times, o.endorse_times) as endorse_times -- 背书次数
    ,nvl(n.deduct_status, o.deduct_status) as deduct_status -- 扣款状态（是否扣款）： 0 否 1 是
    ,nvl(n.first_trans_id, o.first_trans_id) as first_trans_id -- 最初进系统的交易ID
    ,nvl(n.recently_trans_id, o.recently_trans_id) as recently_trans_id -- 最近进系统的交易ID
    ,nvl(n.payment_status, o.payment_status) as payment_status -- 付款状态（是否付款）： 0 否 1 是
    ,nvl(n.del_flag, o.del_flag) as del_flag -- 删除标志： 0 否 1 是
    ,nvl(n.report_of_loss_flag, o.report_of_loss_flag) as report_of_loss_flag -- 挂失状态（是否挂失）： 0 否 1 是
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备注1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备注2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备注3
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 备注4
    ,nvl(n.apply_trans_id, o.apply_trans_id) as apply_trans_id -- 申请ID
    ,nvl(n.sign_trans_id, o.sign_trans_id) as sign_trans_id -- 签收ID
    ,nvl(n.prov_interest, o.prov_interest) as prov_interest -- PROV_INTEREST
    ,nvl(n.rema_interest, o.rema_interest) as rema_interest -- REMA_INTEREST
    ,nvl(n.is_receipt, o.is_receipt) as is_receipt -- 是否是小票（1-是，0-否。金额小于等于500万元人民币，且承兑银行非我行（系统外银行）为”是“ ，反之为”否“）
    ,nvl(n.stock_status, o.stock_status) as stock_status -- 是否再贴现（1-已再贴现，0-库存。）
    ,nvl(n.draft_transfer_flag, o.draft_transfer_flag) as draft_transfer_flag -- 票面不得转让标志：EM00 可再转让 EM01 不得转让
    ,nvl(n.voucher_no, o.voucher_no) as voucher_no -- 凭证号
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
from (select * from ${iol_schema}.bdms_bms_draft_centre_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_draft_centre_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.src_type <> n.src_type
        or o.buy_contract_id <> n.buy_contract_id
        or o.trans_id <> n.trans_id
        or o.remit_date <> n.remit_date
        or o.maturity_date <> n.maturity_date
        or o.draft_amount <> n.draft_amount
        or o.remitter_role <> n.remitter_role
        or o.remitter_cmonid <> n.remitter_cmonid
        or o.remitter_name <> n.remitter_name
        or o.remitter_account <> n.remitter_account
        or o.remitter_bank_no <> n.remitter_bank_no
        or o.remitter_bank_name <> n.remitter_bank_name
        or o.df_drwr_cdtratgs <> n.df_drwr_cdtratgs
        or o.df_drwr_cdtratgsagcy <> n.df_drwr_cdtratgsagcy
        or o.df_drwr_cdtratgduedt <> n.df_drwr_cdtratgduedt
        or o.acceptor_role <> n.acceptor_role
        or o.acceptor_name <> n.acceptor_name
        or o.acceptor_bank_no <> n.acceptor_bank_no
        or o.acceptor_account <> n.acceptor_account
        or o.acceptor_bank_name <> n.acceptor_bank_name
        or o.drawee_bank_name <> n.drawee_bank_name
        or o.drawee_bank_no <> n.drawee_bank_no
        or o.drawee_address <> n.drawee_address
        or o.payee_name <> n.payee_name
        or o.payee_account <> n.payee_account
        or o.payee_bank_no <> n.payee_bank_no
        or o.payee_bank_name <> n.payee_bank_name
        or o.payee_cust_no <> n.payee_cust_no
        or o.payee_organ_code <> n.payee_organ_code
        or o.draft_remark <> n.draft_remark
        or o.inner_accept_flag <> n.inner_accept_flag
        or o.belong_branch_no <> n.belong_branch_no
        or o.store_status <> n.store_status
        or o.last_operator_no <> n.last_operator_no
        or o.last_txn_date <> n.last_txn_date
        or o.endorse_times <> n.endorse_times
        or o.deduct_status <> n.deduct_status
        or o.first_trans_id <> n.first_trans_id
        or o.recently_trans_id <> n.recently_trans_id
        or o.payment_status <> n.payment_status
        or o.del_flag <> n.del_flag
        or o.report_of_loss_flag <> n.report_of_loss_flag
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.apply_trans_id <> n.apply_trans_id
        or o.sign_trans_id <> n.sign_trans_id
        or o.prov_interest <> n.prov_interest
        or o.rema_interest <> n.rema_interest
        or o.is_receipt <> n.is_receipt
        or o.stock_status <> n.stock_status
        or o.draft_transfer_flag <> n.draft_transfer_flag
        or o.voucher_no <> n.voucher_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_draft_centre_info_cl(
            id -- ID
            ,draft_number -- 票据号码
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,src_type -- 票据来源
            ,buy_contract_id -- 买入协议ID
            ,trans_id -- 交易ID
            ,remit_date -- 出票日期
            ,maturity_date -- 票据到期日期
            ,draft_amount -- 票面金额
            ,remitter_role -- 出票人类别
            ,remitter_cmonid -- 出票人组织机构代码
            ,remitter_name -- 出票人名称
            ,remitter_account -- 出票人账号
            ,remitter_bank_no -- 出票人开户行号
            ,remitter_bank_name -- 出票人开户行名称
            ,df_drwr_cdtratgs -- 出票人-信用等级
            ,df_drwr_cdtratgsagcy -- 出票人-评级机构
            ,df_drwr_cdtratgduedt -- 出票人-评级到期日
            ,acceptor_role -- 承兑人类别
            ,acceptor_name -- 承兑人
            ,acceptor_bank_no -- 承兑人开户行
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,drawee_bank_name -- 付款行全称
            ,drawee_bank_no -- 付款行行号
            ,drawee_address -- 付款行地址
            ,payee_name -- 票面收款人名称
            ,payee_account -- 票面收款人账号
            ,payee_bank_no -- 票面收款人开户行号
            ,payee_bank_name -- 票面收款人开户行
            ,payee_cust_no -- 收款人客户NO
            ,payee_organ_code -- 票面收款人组织机构代码
            ,draft_remark -- 票面备注
            ,inner_accept_flag -- 是否系统内承兑： 0 否 1 是
            ,belong_branch_no -- 票据所属机构号
            ,store_status -- 实物库存状态
            ,last_operator_no -- 最后修改操作员号
            ,last_txn_date -- 最后修改时间
            ,endorse_times -- 背书次数
            ,deduct_status -- 扣款状态（是否扣款）： 0 否 1 是
            ,first_trans_id -- 最初进系统的交易ID
            ,recently_trans_id -- 最近进系统的交易ID
            ,payment_status -- 付款状态（是否付款）： 0 否 1 是
            ,del_flag -- 删除标志： 0 否 1 是
            ,report_of_loss_flag -- 挂失状态（是否挂失）： 0 否 1 是
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,reserve4 -- 备注4
            ,apply_trans_id -- 申请ID
            ,sign_trans_id -- 签收ID
            ,prov_interest -- PROV_INTEREST
            ,rema_interest -- REMA_INTEREST
            ,is_receipt -- 是否是小票（1-是，0-否。金额小于等于500万元人民币，且承兑银行非我行（系统外银行）为”是“ ，反之为”否“）
            ,stock_status -- 是否再贴现（1-已再贴现，0-库存。）
            ,draft_transfer_flag -- 票面不得转让标志：EM00 可再转让 EM01 不得转让
            ,voucher_no -- 凭证号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_draft_centre_info_op(
            id -- ID
            ,draft_number -- 票据号码
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,src_type -- 票据来源
            ,buy_contract_id -- 买入协议ID
            ,trans_id -- 交易ID
            ,remit_date -- 出票日期
            ,maturity_date -- 票据到期日期
            ,draft_amount -- 票面金额
            ,remitter_role -- 出票人类别
            ,remitter_cmonid -- 出票人组织机构代码
            ,remitter_name -- 出票人名称
            ,remitter_account -- 出票人账号
            ,remitter_bank_no -- 出票人开户行号
            ,remitter_bank_name -- 出票人开户行名称
            ,df_drwr_cdtratgs -- 出票人-信用等级
            ,df_drwr_cdtratgsagcy -- 出票人-评级机构
            ,df_drwr_cdtratgduedt -- 出票人-评级到期日
            ,acceptor_role -- 承兑人类别
            ,acceptor_name -- 承兑人
            ,acceptor_bank_no -- 承兑人开户行
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,drawee_bank_name -- 付款行全称
            ,drawee_bank_no -- 付款行行号
            ,drawee_address -- 付款行地址
            ,payee_name -- 票面收款人名称
            ,payee_account -- 票面收款人账号
            ,payee_bank_no -- 票面收款人开户行号
            ,payee_bank_name -- 票面收款人开户行
            ,payee_cust_no -- 收款人客户NO
            ,payee_organ_code -- 票面收款人组织机构代码
            ,draft_remark -- 票面备注
            ,inner_accept_flag -- 是否系统内承兑： 0 否 1 是
            ,belong_branch_no -- 票据所属机构号
            ,store_status -- 实物库存状态
            ,last_operator_no -- 最后修改操作员号
            ,last_txn_date -- 最后修改时间
            ,endorse_times -- 背书次数
            ,deduct_status -- 扣款状态（是否扣款）： 0 否 1 是
            ,first_trans_id -- 最初进系统的交易ID
            ,recently_trans_id -- 最近进系统的交易ID
            ,payment_status -- 付款状态（是否付款）： 0 否 1 是
            ,del_flag -- 删除标志： 0 否 1 是
            ,report_of_loss_flag -- 挂失状态（是否挂失）： 0 否 1 是
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,reserve4 -- 备注4
            ,apply_trans_id -- 申请ID
            ,sign_trans_id -- 签收ID
            ,prov_interest -- PROV_INTEREST
            ,rema_interest -- REMA_INTEREST
            ,is_receipt -- 是否是小票（1-是，0-否。金额小于等于500万元人民币，且承兑银行非我行（系统外银行）为”是“ ，反之为”否“）
            ,stock_status -- 是否再贴现（1-已再贴现，0-库存。）
            ,draft_transfer_flag -- 票面不得转让标志：EM00 可再转让 EM01 不得转让
            ,voucher_no -- 凭证号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.draft_number -- 票据号码
    ,o.draft_attr -- 票据属性： 1 纸票 2 电票
    ,o.draft_type -- 票据类型： 1 银票 2 商票
    ,o.src_type -- 票据来源
    ,o.buy_contract_id -- 买入协议ID
    ,o.trans_id -- 交易ID
    ,o.remit_date -- 出票日期
    ,o.maturity_date -- 票据到期日期
    ,o.draft_amount -- 票面金额
    ,o.remitter_role -- 出票人类别
    ,o.remitter_cmonid -- 出票人组织机构代码
    ,o.remitter_name -- 出票人名称
    ,o.remitter_account -- 出票人账号
    ,o.remitter_bank_no -- 出票人开户行号
    ,o.remitter_bank_name -- 出票人开户行名称
    ,o.df_drwr_cdtratgs -- 出票人-信用等级
    ,o.df_drwr_cdtratgsagcy -- 出票人-评级机构
    ,o.df_drwr_cdtratgduedt -- 出票人-评级到期日
    ,o.acceptor_role -- 承兑人类别
    ,o.acceptor_name -- 承兑人
    ,o.acceptor_bank_no -- 承兑人开户行
    ,o.acceptor_account -- 承兑人账号
    ,o.acceptor_bank_name -- 承兑人开户行名称
    ,o.drawee_bank_name -- 付款行全称
    ,o.drawee_bank_no -- 付款行行号
    ,o.drawee_address -- 付款行地址
    ,o.payee_name -- 票面收款人名称
    ,o.payee_account -- 票面收款人账号
    ,o.payee_bank_no -- 票面收款人开户行号
    ,o.payee_bank_name -- 票面收款人开户行
    ,o.payee_cust_no -- 收款人客户NO
    ,o.payee_organ_code -- 票面收款人组织机构代码
    ,o.draft_remark -- 票面备注
    ,o.inner_accept_flag -- 是否系统内承兑： 0 否 1 是
    ,o.belong_branch_no -- 票据所属机构号
    ,o.store_status -- 实物库存状态
    ,o.last_operator_no -- 最后修改操作员号
    ,o.last_txn_date -- 最后修改时间
    ,o.endorse_times -- 背书次数
    ,o.deduct_status -- 扣款状态（是否扣款）： 0 否 1 是
    ,o.first_trans_id -- 最初进系统的交易ID
    ,o.recently_trans_id -- 最近进系统的交易ID
    ,o.payment_status -- 付款状态（是否付款）： 0 否 1 是
    ,o.del_flag -- 删除标志： 0 否 1 是
    ,o.report_of_loss_flag -- 挂失状态（是否挂失）： 0 否 1 是
    ,o.reserve1 -- 备注1
    ,o.reserve2 -- 备注2
    ,o.reserve3 -- 备注3
    ,o.reserve4 -- 备注4
    ,o.apply_trans_id -- 申请ID
    ,o.sign_trans_id -- 签收ID
    ,o.prov_interest -- PROV_INTEREST
    ,o.rema_interest -- REMA_INTEREST
    ,o.is_receipt -- 是否是小票（1-是，0-否。金额小于等于500万元人民币，且承兑银行非我行（系统外银行）为”是“ ，反之为”否“）
    ,o.stock_status -- 是否再贴现（1-已再贴现，0-库存。）
    ,o.draft_transfer_flag -- 票面不得转让标志：EM00 可再转让 EM01 不得转让
    ,o.voucher_no -- 凭证号
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
from ${iol_schema}.bdms_bms_draft_centre_info_bk o
    left join ${iol_schema}.bdms_bms_draft_centre_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_draft_centre_info_cl d
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
--truncate table ${iol_schema}.bdms_bms_draft_centre_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_draft_centre_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_draft_centre_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_draft_centre_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_draft_centre_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_draft_centre_info_cl;
alter table ${iol_schema}.bdms_bms_draft_centre_info exchange partition p_20991231 with table ${iol_schema}.bdms_bms_draft_centre_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_draft_centre_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_draft_centre_info_op purge;
drop table ${iol_schema}.bdms_bms_draft_centre_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_draft_centre_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_draft_centre_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
