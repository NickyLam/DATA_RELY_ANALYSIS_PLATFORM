/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_transfer_order_detail
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
create table ${iol_schema}.tbps_cpr_transfer_order_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbps_cpr_transfer_order_detail;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_transfer_order_detail_op purge;
drop table ${iol_schema}.tbps_cpr_transfer_order_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_transfer_order_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_transfer_order_detail where 0=1;

create table ${iol_schema}.tbps_cpr_transfer_order_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_transfer_order_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_transfer_order_detail_cl(
            tod_orderno -- 预约号
            ,tod_trade_flowno -- 流水号
            ,tod_transcode -- 交易编码
            ,tod_payeracno -- 转出帐号
            ,tod_payeracname -- 转出帐号户名
            ,tod_payerdeptid -- 付款账号机构号
            ,tod_payerbankactype -- 付款账号账户类型
            ,tod_currency -- 币种
            ,tod_payeeacno -- 收款账号
            ,tod_payeeacname -- 收款账号户名
            ,tod_payeebankactype -- 转入账号账户类型
            ,tod_amount -- 交易金额
            ,tod_remark -- 附言
            ,tod_fee -- 费用
            ,tod_executeday -- 执行日期
            ,tod_isnormal -- 是否加急
            ,tod_hold_fund_id -- 止付编号
            ,tod_txn_narrative -- 止付原因
            ,tod_release_ref_nbr -- 解付备考号
            ,tod_valuedate -- 转账日期
            ,tod_intrate -- 费率
            ,tod_rflag -- 钞汇标志
            ,tod_payeecurrency -- 收款人币种
            ,tod_payeebankid -- 收款行行号
            ,tod_payeebankname -- 收款行名
            ,tod_provincecode -- 收款行省号
            ,tod_provincename -- 收款行省名
            ,tod_citycode -- 收款行城市号
            ,tod_cityname -- 收款行城市名
            ,tod_bankcode -- 交换号/联行号
            ,tod_lname -- 收款人网点名称
            ,tod_dreccode -- 收款人清算行号
            ,tod_payeemobile -- 收款人手机号
            ,tod_payeesms -- 收款人短信
            ,tod_notecode -- 付款用途
            ,tod_finalfee -- 最终手续费
            ,tod_discount -- 折扣
            ,tod_trspassword -- 交易密码
            ,tod_notifypayeeflag -- 是否通知收款人
            ,tod_savepayeeflag -- 是否保存收款人
            ,tod_payeeciftype -- 收款人客户类型
            ,tod_groundflag -- 落地标志
            ,tod_validatemsg -- 验证信息
            ,tod_discountrate -- 手续费折扣率
            ,tod_parentfee -- 实收手续费
            ,tod_sysflag -- 标识行内行外
            ,tod_parentaccno -- 父流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_transfer_order_detail_op(
            tod_orderno -- 预约号
            ,tod_trade_flowno -- 流水号
            ,tod_transcode -- 交易编码
            ,tod_payeracno -- 转出帐号
            ,tod_payeracname -- 转出帐号户名
            ,tod_payerdeptid -- 付款账号机构号
            ,tod_payerbankactype -- 付款账号账户类型
            ,tod_currency -- 币种
            ,tod_payeeacno -- 收款账号
            ,tod_payeeacname -- 收款账号户名
            ,tod_payeebankactype -- 转入账号账户类型
            ,tod_amount -- 交易金额
            ,tod_remark -- 附言
            ,tod_fee -- 费用
            ,tod_executeday -- 执行日期
            ,tod_isnormal -- 是否加急
            ,tod_hold_fund_id -- 止付编号
            ,tod_txn_narrative -- 止付原因
            ,tod_release_ref_nbr -- 解付备考号
            ,tod_valuedate -- 转账日期
            ,tod_intrate -- 费率
            ,tod_rflag -- 钞汇标志
            ,tod_payeecurrency -- 收款人币种
            ,tod_payeebankid -- 收款行行号
            ,tod_payeebankname -- 收款行名
            ,tod_provincecode -- 收款行省号
            ,tod_provincename -- 收款行省名
            ,tod_citycode -- 收款行城市号
            ,tod_cityname -- 收款行城市名
            ,tod_bankcode -- 交换号/联行号
            ,tod_lname -- 收款人网点名称
            ,tod_dreccode -- 收款人清算行号
            ,tod_payeemobile -- 收款人手机号
            ,tod_payeesms -- 收款人短信
            ,tod_notecode -- 付款用途
            ,tod_finalfee -- 最终手续费
            ,tod_discount -- 折扣
            ,tod_trspassword -- 交易密码
            ,tod_notifypayeeflag -- 是否通知收款人
            ,tod_savepayeeflag -- 是否保存收款人
            ,tod_payeeciftype -- 收款人客户类型
            ,tod_groundflag -- 落地标志
            ,tod_validatemsg -- 验证信息
            ,tod_discountrate -- 手续费折扣率
            ,tod_parentfee -- 实收手续费
            ,tod_sysflag -- 标识行内行外
            ,tod_parentaccno -- 父流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tod_orderno, o.tod_orderno) as tod_orderno -- 预约号
    ,nvl(n.tod_trade_flowno, o.tod_trade_flowno) as tod_trade_flowno -- 流水号
    ,nvl(n.tod_transcode, o.tod_transcode) as tod_transcode -- 交易编码
    ,nvl(n.tod_payeracno, o.tod_payeracno) as tod_payeracno -- 转出帐号
    ,nvl(n.tod_payeracname, o.tod_payeracname) as tod_payeracname -- 转出帐号户名
    ,nvl(n.tod_payerdeptid, o.tod_payerdeptid) as tod_payerdeptid -- 付款账号机构号
    ,nvl(n.tod_payerbankactype, o.tod_payerbankactype) as tod_payerbankactype -- 付款账号账户类型
    ,nvl(n.tod_currency, o.tod_currency) as tod_currency -- 币种
    ,nvl(n.tod_payeeacno, o.tod_payeeacno) as tod_payeeacno -- 收款账号
    ,nvl(n.tod_payeeacname, o.tod_payeeacname) as tod_payeeacname -- 收款账号户名
    ,nvl(n.tod_payeebankactype, o.tod_payeebankactype) as tod_payeebankactype -- 转入账号账户类型
    ,nvl(n.tod_amount, o.tod_amount) as tod_amount -- 交易金额
    ,nvl(n.tod_remark, o.tod_remark) as tod_remark -- 附言
    ,nvl(n.tod_fee, o.tod_fee) as tod_fee -- 费用
    ,nvl(n.tod_executeday, o.tod_executeday) as tod_executeday -- 执行日期
    ,nvl(n.tod_isnormal, o.tod_isnormal) as tod_isnormal -- 是否加急
    ,nvl(n.tod_hold_fund_id, o.tod_hold_fund_id) as tod_hold_fund_id -- 止付编号
    ,nvl(n.tod_txn_narrative, o.tod_txn_narrative) as tod_txn_narrative -- 止付原因
    ,nvl(n.tod_release_ref_nbr, o.tod_release_ref_nbr) as tod_release_ref_nbr -- 解付备考号
    ,nvl(n.tod_valuedate, o.tod_valuedate) as tod_valuedate -- 转账日期
    ,nvl(n.tod_intrate, o.tod_intrate) as tod_intrate -- 费率
    ,nvl(n.tod_rflag, o.tod_rflag) as tod_rflag -- 钞汇标志
    ,nvl(n.tod_payeecurrency, o.tod_payeecurrency) as tod_payeecurrency -- 收款人币种
    ,nvl(n.tod_payeebankid, o.tod_payeebankid) as tod_payeebankid -- 收款行行号
    ,nvl(n.tod_payeebankname, o.tod_payeebankname) as tod_payeebankname -- 收款行名
    ,nvl(n.tod_provincecode, o.tod_provincecode) as tod_provincecode -- 收款行省号
    ,nvl(n.tod_provincename, o.tod_provincename) as tod_provincename -- 收款行省名
    ,nvl(n.tod_citycode, o.tod_citycode) as tod_citycode -- 收款行城市号
    ,nvl(n.tod_cityname, o.tod_cityname) as tod_cityname -- 收款行城市名
    ,nvl(n.tod_bankcode, o.tod_bankcode) as tod_bankcode -- 交换号/联行号
    ,nvl(n.tod_lname, o.tod_lname) as tod_lname -- 收款人网点名称
    ,nvl(n.tod_dreccode, o.tod_dreccode) as tod_dreccode -- 收款人清算行号
    ,nvl(n.tod_payeemobile, o.tod_payeemobile) as tod_payeemobile -- 收款人手机号
    ,nvl(n.tod_payeesms, o.tod_payeesms) as tod_payeesms -- 收款人短信
    ,nvl(n.tod_notecode, o.tod_notecode) as tod_notecode -- 付款用途
    ,nvl(n.tod_finalfee, o.tod_finalfee) as tod_finalfee -- 最终手续费
    ,nvl(n.tod_discount, o.tod_discount) as tod_discount -- 折扣
    ,nvl(n.tod_trspassword, o.tod_trspassword) as tod_trspassword -- 交易密码
    ,nvl(n.tod_notifypayeeflag, o.tod_notifypayeeflag) as tod_notifypayeeflag -- 是否通知收款人
    ,nvl(n.tod_savepayeeflag, o.tod_savepayeeflag) as tod_savepayeeflag -- 是否保存收款人
    ,nvl(n.tod_payeeciftype, o.tod_payeeciftype) as tod_payeeciftype -- 收款人客户类型
    ,nvl(n.tod_groundflag, o.tod_groundflag) as tod_groundflag -- 落地标志
    ,nvl(n.tod_validatemsg, o.tod_validatemsg) as tod_validatemsg -- 验证信息
    ,nvl(n.tod_discountrate, o.tod_discountrate) as tod_discountrate -- 手续费折扣率
    ,nvl(n.tod_parentfee, o.tod_parentfee) as tod_parentfee -- 实收手续费
    ,nvl(n.tod_sysflag, o.tod_sysflag) as tod_sysflag -- 标识行内行外
    ,nvl(n.tod_parentaccno, o.tod_parentaccno) as tod_parentaccno -- 父流水号
    ,case when
            n.tod_orderno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tod_orderno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tod_orderno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbps_cpr_transfer_order_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbps_cpr_transfer_order_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tod_orderno = n.tod_orderno
where (
        o.tod_orderno is null
    )
    or (
        n.tod_orderno is null
    )
    or (
        o.tod_trade_flowno <> n.tod_trade_flowno
        or o.tod_transcode <> n.tod_transcode
        or o.tod_payeracno <> n.tod_payeracno
        or o.tod_payeracname <> n.tod_payeracname
        or o.tod_payerdeptid <> n.tod_payerdeptid
        or o.tod_payerbankactype <> n.tod_payerbankactype
        or o.tod_currency <> n.tod_currency
        or o.tod_payeeacno <> n.tod_payeeacno
        or o.tod_payeeacname <> n.tod_payeeacname
        or o.tod_payeebankactype <> n.tod_payeebankactype
        or o.tod_amount <> n.tod_amount
        or o.tod_remark <> n.tod_remark
        or o.tod_fee <> n.tod_fee
        or o.tod_executeday <> n.tod_executeday
        or o.tod_isnormal <> n.tod_isnormal
        or o.tod_hold_fund_id <> n.tod_hold_fund_id
        or o.tod_txn_narrative <> n.tod_txn_narrative
        or o.tod_release_ref_nbr <> n.tod_release_ref_nbr
        or o.tod_valuedate <> n.tod_valuedate
        or o.tod_intrate <> n.tod_intrate
        or o.tod_rflag <> n.tod_rflag
        or o.tod_payeecurrency <> n.tod_payeecurrency
        or o.tod_payeebankid <> n.tod_payeebankid
        or o.tod_payeebankname <> n.tod_payeebankname
        or o.tod_provincecode <> n.tod_provincecode
        or o.tod_provincename <> n.tod_provincename
        or o.tod_citycode <> n.tod_citycode
        or o.tod_cityname <> n.tod_cityname
        or o.tod_bankcode <> n.tod_bankcode
        or o.tod_lname <> n.tod_lname
        or o.tod_dreccode <> n.tod_dreccode
        or o.tod_payeemobile <> n.tod_payeemobile
        or o.tod_payeesms <> n.tod_payeesms
        or o.tod_notecode <> n.tod_notecode
        or o.tod_finalfee <> n.tod_finalfee
        or o.tod_discount <> n.tod_discount
        or o.tod_trspassword <> n.tod_trspassword
        or o.tod_notifypayeeflag <> n.tod_notifypayeeflag
        or o.tod_savepayeeflag <> n.tod_savepayeeflag
        or o.tod_payeeciftype <> n.tod_payeeciftype
        or o.tod_groundflag <> n.tod_groundflag
        or o.tod_validatemsg <> n.tod_validatemsg
        or o.tod_discountrate <> n.tod_discountrate
        or o.tod_parentfee <> n.tod_parentfee
        or o.tod_sysflag <> n.tod_sysflag
        or o.tod_parentaccno <> n.tod_parentaccno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_transfer_order_detail_cl(
            tod_orderno -- 预约号
            ,tod_trade_flowno -- 流水号
            ,tod_transcode -- 交易编码
            ,tod_payeracno -- 转出帐号
            ,tod_payeracname -- 转出帐号户名
            ,tod_payerdeptid -- 付款账号机构号
            ,tod_payerbankactype -- 付款账号账户类型
            ,tod_currency -- 币种
            ,tod_payeeacno -- 收款账号
            ,tod_payeeacname -- 收款账号户名
            ,tod_payeebankactype -- 转入账号账户类型
            ,tod_amount -- 交易金额
            ,tod_remark -- 附言
            ,tod_fee -- 费用
            ,tod_executeday -- 执行日期
            ,tod_isnormal -- 是否加急
            ,tod_hold_fund_id -- 止付编号
            ,tod_txn_narrative -- 止付原因
            ,tod_release_ref_nbr -- 解付备考号
            ,tod_valuedate -- 转账日期
            ,tod_intrate -- 费率
            ,tod_rflag -- 钞汇标志
            ,tod_payeecurrency -- 收款人币种
            ,tod_payeebankid -- 收款行行号
            ,tod_payeebankname -- 收款行名
            ,tod_provincecode -- 收款行省号
            ,tod_provincename -- 收款行省名
            ,tod_citycode -- 收款行城市号
            ,tod_cityname -- 收款行城市名
            ,tod_bankcode -- 交换号/联行号
            ,tod_lname -- 收款人网点名称
            ,tod_dreccode -- 收款人清算行号
            ,tod_payeemobile -- 收款人手机号
            ,tod_payeesms -- 收款人短信
            ,tod_notecode -- 付款用途
            ,tod_finalfee -- 最终手续费
            ,tod_discount -- 折扣
            ,tod_trspassword -- 交易密码
            ,tod_notifypayeeflag -- 是否通知收款人
            ,tod_savepayeeflag -- 是否保存收款人
            ,tod_payeeciftype -- 收款人客户类型
            ,tod_groundflag -- 落地标志
            ,tod_validatemsg -- 验证信息
            ,tod_discountrate -- 手续费折扣率
            ,tod_parentfee -- 实收手续费
            ,tod_sysflag -- 标识行内行外
            ,tod_parentaccno -- 父流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_transfer_order_detail_op(
            tod_orderno -- 预约号
            ,tod_trade_flowno -- 流水号
            ,tod_transcode -- 交易编码
            ,tod_payeracno -- 转出帐号
            ,tod_payeracname -- 转出帐号户名
            ,tod_payerdeptid -- 付款账号机构号
            ,tod_payerbankactype -- 付款账号账户类型
            ,tod_currency -- 币种
            ,tod_payeeacno -- 收款账号
            ,tod_payeeacname -- 收款账号户名
            ,tod_payeebankactype -- 转入账号账户类型
            ,tod_amount -- 交易金额
            ,tod_remark -- 附言
            ,tod_fee -- 费用
            ,tod_executeday -- 执行日期
            ,tod_isnormal -- 是否加急
            ,tod_hold_fund_id -- 止付编号
            ,tod_txn_narrative -- 止付原因
            ,tod_release_ref_nbr -- 解付备考号
            ,tod_valuedate -- 转账日期
            ,tod_intrate -- 费率
            ,tod_rflag -- 钞汇标志
            ,tod_payeecurrency -- 收款人币种
            ,tod_payeebankid -- 收款行行号
            ,tod_payeebankname -- 收款行名
            ,tod_provincecode -- 收款行省号
            ,tod_provincename -- 收款行省名
            ,tod_citycode -- 收款行城市号
            ,tod_cityname -- 收款行城市名
            ,tod_bankcode -- 交换号/联行号
            ,tod_lname -- 收款人网点名称
            ,tod_dreccode -- 收款人清算行号
            ,tod_payeemobile -- 收款人手机号
            ,tod_payeesms -- 收款人短信
            ,tod_notecode -- 付款用途
            ,tod_finalfee -- 最终手续费
            ,tod_discount -- 折扣
            ,tod_trspassword -- 交易密码
            ,tod_notifypayeeflag -- 是否通知收款人
            ,tod_savepayeeflag -- 是否保存收款人
            ,tod_payeeciftype -- 收款人客户类型
            ,tod_groundflag -- 落地标志
            ,tod_validatemsg -- 验证信息
            ,tod_discountrate -- 手续费折扣率
            ,tod_parentfee -- 实收手续费
            ,tod_sysflag -- 标识行内行外
            ,tod_parentaccno -- 父流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tod_orderno -- 预约号
    ,o.tod_trade_flowno -- 流水号
    ,o.tod_transcode -- 交易编码
    ,o.tod_payeracno -- 转出帐号
    ,o.tod_payeracname -- 转出帐号户名
    ,o.tod_payerdeptid -- 付款账号机构号
    ,o.tod_payerbankactype -- 付款账号账户类型
    ,o.tod_currency -- 币种
    ,o.tod_payeeacno -- 收款账号
    ,o.tod_payeeacname -- 收款账号户名
    ,o.tod_payeebankactype -- 转入账号账户类型
    ,o.tod_amount -- 交易金额
    ,o.tod_remark -- 附言
    ,o.tod_fee -- 费用
    ,o.tod_executeday -- 执行日期
    ,o.tod_isnormal -- 是否加急
    ,o.tod_hold_fund_id -- 止付编号
    ,o.tod_txn_narrative -- 止付原因
    ,o.tod_release_ref_nbr -- 解付备考号
    ,o.tod_valuedate -- 转账日期
    ,o.tod_intrate -- 费率
    ,o.tod_rflag -- 钞汇标志
    ,o.tod_payeecurrency -- 收款人币种
    ,o.tod_payeebankid -- 收款行行号
    ,o.tod_payeebankname -- 收款行名
    ,o.tod_provincecode -- 收款行省号
    ,o.tod_provincename -- 收款行省名
    ,o.tod_citycode -- 收款行城市号
    ,o.tod_cityname -- 收款行城市名
    ,o.tod_bankcode -- 交换号/联行号
    ,o.tod_lname -- 收款人网点名称
    ,o.tod_dreccode -- 收款人清算行号
    ,o.tod_payeemobile -- 收款人手机号
    ,o.tod_payeesms -- 收款人短信
    ,o.tod_notecode -- 付款用途
    ,o.tod_finalfee -- 最终手续费
    ,o.tod_discount -- 折扣
    ,o.tod_trspassword -- 交易密码
    ,o.tod_notifypayeeflag -- 是否通知收款人
    ,o.tod_savepayeeflag -- 是否保存收款人
    ,o.tod_payeeciftype -- 收款人客户类型
    ,o.tod_groundflag -- 落地标志
    ,o.tod_validatemsg -- 验证信息
    ,o.tod_discountrate -- 手续费折扣率
    ,o.tod_parentfee -- 实收手续费
    ,o.tod_sysflag -- 标识行内行外
    ,o.tod_parentaccno -- 父流水号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbps_cpr_transfer_order_detail_bk o
    left join ${iol_schema}.tbps_cpr_transfer_order_detail_op n
        on
            o.tod_orderno = n.tod_orderno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbps_cpr_transfer_order_detail_cl d
        on
            o.tod_orderno = d.tod_orderno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbps_cpr_transfer_order_detail;

-- 4.2 exchange partition
alter table ${iol_schema}.tbps_cpr_transfer_order_detail exchange partition p_19000101 with table ${iol_schema}.tbps_cpr_transfer_order_detail_cl;
alter table ${iol_schema}.tbps_cpr_transfer_order_detail exchange partition p_20991231 with table ${iol_schema}.tbps_cpr_transfer_order_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_transfer_order_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_transfer_order_detail_op purge;
drop table ${iol_schema}.tbps_cpr_transfer_order_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbps_cpr_transfer_order_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_transfer_order_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
