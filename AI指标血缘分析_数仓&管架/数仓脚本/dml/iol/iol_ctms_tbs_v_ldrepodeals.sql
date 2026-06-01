/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_ldrepodeals
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
create table ${iol_schema}.ctms_tbs_v_ldrepodeals_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_ldrepodeals
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_ldrepodeals_op purge;
drop table ${iol_schema}.ctms_tbs_v_ldrepodeals_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_ldrepodeals_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_ldrepodeals where 0=1;

create table ${iol_schema}.ctms_tbs_v_ldrepodeals_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_ldrepodeals where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_ldrepodeals_cl(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,bondscode -- 债券代码
            ,bondsname -- 债券名称
            ,serial_number -- 交易号(标识数据表中记录的唯一组合)
            ,trade_date -- 首期交易日
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,buyorsell -- 交易方向
            ,face_amount -- 质押券面额
            ,repo_rate -- 质押比例
            ,amount -- 首期结算金额
            ,maturity_amount -- 到期结算金额
            ,fee -- 首期费用
            ,tax_amt -- 首期税金
            ,broker_amt -- 首期佣金
            ,interest -- 应计利息
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手ID
            ,settle_type -- 首期结算方式
            ,settle_type2 -- 到期结算方式
            ,dealer_id -- 交易员ID
            ,dealer_name -- 交易员姓名
            ,ref_number -- 成交编号
            ,cfets_from -- 是否是CFETS交易
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源ID
            ,trade_rate -- 回购利率
            ,repo_days -- 回购天数
            ,ldrepodeals_id_grand -- 原始交易ID
            ,repo_id -- 回购名称
            ,counterparty_type -- 计息基准
            ,clearing_type -- 清算类型
            ,repo_method -- 回购方式
            ,contract_no -- 合约编号
            ,trade_time -- 交易时间
            ,market_type -- 交易场所
            ,market_sub_type -- 交易场所子类
            ,repo_type -- 回购类型
            ,dn_dealer -- 本币交易员
            ,shch_amount -- 上清所交易金额
            ,cdc_amount -- 中债登交易金额
            ,shch_maturity_amount -- 上清所到期结算金额
            ,cdc_maturity_amount -- 中债登到期结算金额
            ,shch_interest -- 上清所利息
            ,cdc_interest -- 中债登利息
            ,sec_face_amt -- 券面总额（合计）
            ,shch_sec_face_amt -- 上清所券面总额（合计）
            ,cdc_sec_face_amt -- 中债登券面总额（合计）
            ,repo_face_amt -- 抵押品券面总额（合计）
            ,shch_repo_face_amt -- 上清所抵押品券面总额（合计）
            ,cdc_repo_face_amt -- 中债登抵押品券面总额（合计）
            ,shch_n_cdc -- 是否跨托管
            ,approval_number -- 审批单号
            ,note -- 备注
            ,repo_bonds -- WTRADE_REPO_BONDS是否有对应的质押券数据,Y:所有质押券信息在WTRADE_REPO_BONDS中,前25张券在wtrade_repo.SECURITY_CODE中,N:所有质押券信息在wtrade_repo.SECURITY_CODE中,不在WTRADE_REPO_BONDS中
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_ldrepodeals_op(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,bondscode -- 债券代码
            ,bondsname -- 债券名称
            ,serial_number -- 交易号(标识数据表中记录的唯一组合)
            ,trade_date -- 首期交易日
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,buyorsell -- 交易方向
            ,face_amount -- 质押券面额
            ,repo_rate -- 质押比例
            ,amount -- 首期结算金额
            ,maturity_amount -- 到期结算金额
            ,fee -- 首期费用
            ,tax_amt -- 首期税金
            ,broker_amt -- 首期佣金
            ,interest -- 应计利息
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手ID
            ,settle_type -- 首期结算方式
            ,settle_type2 -- 到期结算方式
            ,dealer_id -- 交易员ID
            ,dealer_name -- 交易员姓名
            ,ref_number -- 成交编号
            ,cfets_from -- 是否是CFETS交易
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源ID
            ,trade_rate -- 回购利率
            ,repo_days -- 回购天数
            ,ldrepodeals_id_grand -- 原始交易ID
            ,repo_id -- 回购名称
            ,counterparty_type -- 计息基准
            ,clearing_type -- 清算类型
            ,repo_method -- 回购方式
            ,contract_no -- 合约编号
            ,trade_time -- 交易时间
            ,market_type -- 交易场所
            ,market_sub_type -- 交易场所子类
            ,repo_type -- 回购类型
            ,dn_dealer -- 本币交易员
            ,shch_amount -- 上清所交易金额
            ,cdc_amount -- 中债登交易金额
            ,shch_maturity_amount -- 上清所到期结算金额
            ,cdc_maturity_amount -- 中债登到期结算金额
            ,shch_interest -- 上清所利息
            ,cdc_interest -- 中债登利息
            ,sec_face_amt -- 券面总额（合计）
            ,shch_sec_face_amt -- 上清所券面总额（合计）
            ,cdc_sec_face_amt -- 中债登券面总额（合计）
            ,repo_face_amt -- 抵押品券面总额（合计）
            ,shch_repo_face_amt -- 上清所抵押品券面总额（合计）
            ,cdc_repo_face_amt -- 中债登抵押品券面总额（合计）
            ,shch_n_cdc -- 是否跨托管
            ,approval_number -- 审批单号
            ,note -- 备注
            ,repo_bonds -- WTRADE_REPO_BONDS是否有对应的质押券数据,Y:所有质押券信息在WTRADE_REPO_BONDS中,前25张券在wtrade_repo.SECURITY_CODE中,N:所有质押券信息在wtrade_repo.SECURITY_CODE中,不在WTRADE_REPO_BONDS中
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.deal_id, o.deal_id) as deal_id -- 引用表ID
    ,nvl(n.deal_tablename, o.deal_tablename) as deal_tablename -- 引用表名
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门编号
    ,nvl(n.bondscode, o.bondscode) as bondscode -- 债券代码
    ,nvl(n.bondsname, o.bondsname) as bondsname -- 债券名称
    ,nvl(n.serial_number, o.serial_number) as serial_number -- 交易号(标识数据表中记录的唯一组合)
    ,nvl(n.trade_date, o.trade_date) as trade_date -- 首期交易日
    ,nvl(n.value_date, o.value_date) as value_date -- 首期交割日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期交割日
    ,nvl(n.buyorsell, o.buyorsell) as buyorsell -- 交易方向
    ,nvl(n.face_amount, o.face_amount) as face_amount -- 质押券面额
    ,nvl(n.repo_rate, o.repo_rate) as repo_rate -- 质押比例
    ,nvl(n.amount, o.amount) as amount -- 首期结算金额
    ,nvl(n.maturity_amount, o.maturity_amount) as maturity_amount -- 到期结算金额
    ,nvl(n.fee, o.fee) as fee -- 首期费用
    ,nvl(n.tax_amt, o.tax_amt) as tax_amt -- 首期税金
    ,nvl(n.broker_amt, o.broker_amt) as broker_amt -- 首期佣金
    ,nvl(n.interest, o.interest) as interest -- 应计利息
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 交易组别
    ,nvl(n.portfolio_name, o.portfolio_name) as portfolio_name -- 交易组别名称
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 账户ID
    ,nvl(n.keepfolder_shortname, o.keepfolder_shortname) as keepfolder_shortname -- 账户名称
    ,nvl(n.cptys_short_name, o.cptys_short_name) as cptys_short_name -- 交易对手名
    ,nvl(n.cptys_id, o.cptys_id) as cptys_id -- 交易对手ID
    ,nvl(n.settle_type, o.settle_type) as settle_type -- 首期结算方式
    ,nvl(n.settle_type2, o.settle_type2) as settle_type2 -- 到期结算方式
    ,nvl(n.dealer_id, o.dealer_id) as dealer_id -- 交易员ID
    ,nvl(n.dealer_name, o.dealer_name) as dealer_name -- 交易员姓名
    ,nvl(n.ref_number, o.ref_number) as ref_number -- 成交编号
    ,nvl(n.cfets_from, o.cfets_from) as cfets_from -- 是否是CFETS交易
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后修改时间
    ,nvl(n.datasymbol_id, o.datasymbol_id) as datasymbol_id -- 数据源ID
    ,nvl(n.trade_rate, o.trade_rate) as trade_rate -- 回购利率
    ,nvl(n.repo_days, o.repo_days) as repo_days -- 回购天数
    ,nvl(n.ldrepodeals_id_grand, o.ldrepodeals_id_grand) as ldrepodeals_id_grand -- 原始交易ID
    ,nvl(n.repo_id, o.repo_id) as repo_id -- 回购名称
    ,nvl(n.counterparty_type, o.counterparty_type) as counterparty_type -- 计息基准
    ,nvl(n.clearing_type, o.clearing_type) as clearing_type -- 清算类型
    ,nvl(n.repo_method, o.repo_method) as repo_method -- 回购方式
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合约编号
    ,nvl(n.trade_time, o.trade_time) as trade_time -- 交易时间
    ,nvl(n.market_type, o.market_type) as market_type -- 交易场所
    ,nvl(n.market_sub_type, o.market_sub_type) as market_sub_type -- 交易场所子类
    ,nvl(n.repo_type, o.repo_type) as repo_type -- 回购类型
    ,nvl(n.dn_dealer, o.dn_dealer) as dn_dealer -- 本币交易员
    ,nvl(n.shch_amount, o.shch_amount) as shch_amount -- 上清所交易金额
    ,nvl(n.cdc_amount, o.cdc_amount) as cdc_amount -- 中债登交易金额
    ,nvl(n.shch_maturity_amount, o.shch_maturity_amount) as shch_maturity_amount -- 上清所到期结算金额
    ,nvl(n.cdc_maturity_amount, o.cdc_maturity_amount) as cdc_maturity_amount -- 中债登到期结算金额
    ,nvl(n.shch_interest, o.shch_interest) as shch_interest -- 上清所利息
    ,nvl(n.cdc_interest, o.cdc_interest) as cdc_interest -- 中债登利息
    ,nvl(n.sec_face_amt, o.sec_face_amt) as sec_face_amt -- 券面总额（合计）
    ,nvl(n.shch_sec_face_amt, o.shch_sec_face_amt) as shch_sec_face_amt -- 上清所券面总额（合计）
    ,nvl(n.cdc_sec_face_amt, o.cdc_sec_face_amt) as cdc_sec_face_amt -- 中债登券面总额（合计）
    ,nvl(n.repo_face_amt, o.repo_face_amt) as repo_face_amt -- 抵押品券面总额（合计）
    ,nvl(n.shch_repo_face_amt, o.shch_repo_face_amt) as shch_repo_face_amt -- 上清所抵押品券面总额（合计）
    ,nvl(n.cdc_repo_face_amt, o.cdc_repo_face_amt) as cdc_repo_face_amt -- 中债登抵押品券面总额（合计）
    ,nvl(n.shch_n_cdc, o.shch_n_cdc) as shch_n_cdc -- 是否跨托管
    ,nvl(n.approval_number, o.approval_number) as approval_number -- 审批单号
    ,nvl(n.note, o.note) as note -- 备注
    ,nvl(n.repo_bonds, o.repo_bonds) as repo_bonds -- WTRADE_REPO_BONDS是否有对应的质押券数据,Y:所有质押券信息在WTRADE_REPO_BONDS中,前25张券在wtrade_repo.SECURITY_CODE中,N:所有质押券信息在wtrade_repo.SECURITY_CODE中,不在WTRADE_REPO_BONDS中
    ,case when
            n.deal_id is null
            and n.deal_tablename is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.deal_id is null
            and n.deal_tablename is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.deal_id is null
            and n.deal_tablename is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_v_ldrepodeals_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_ldrepodeals where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.deal_id = n.deal_id
            and o.deal_tablename = n.deal_tablename
where (
        o.deal_id is null
        and o.deal_tablename is null
    )
    or (
        n.deal_id is null
        and n.deal_tablename is null
    )
    or (
        o.aspclient_id <> n.aspclient_id
        or o.bondscode <> n.bondscode
        or o.bondsname <> n.bondsname
        or o.serial_number <> n.serial_number
        or o.trade_date <> n.trade_date
        or o.value_date <> n.value_date
        or o.maturity_date <> n.maturity_date
        or o.buyorsell <> n.buyorsell
        or o.face_amount <> n.face_amount
        or o.repo_rate <> n.repo_rate
        or o.amount <> n.amount
        or o.maturity_amount <> n.maturity_amount
        or o.fee <> n.fee
        or o.tax_amt <> n.tax_amt
        or o.broker_amt <> n.broker_amt
        or o.interest <> n.interest
        or o.portfolio_id <> n.portfolio_id
        or o.portfolio_name <> n.portfolio_name
        or o.keepfolder_id <> n.keepfolder_id
        or o.keepfolder_shortname <> n.keepfolder_shortname
        or o.cptys_short_name <> n.cptys_short_name
        or o.cptys_id <> n.cptys_id
        or o.settle_type <> n.settle_type
        or o.settle_type2 <> n.settle_type2
        or o.dealer_id <> n.dealer_id
        or o.dealer_name <> n.dealer_name
        or o.ref_number <> n.ref_number
        or o.cfets_from <> n.cfets_from
        or o.lastmodified <> n.lastmodified
        or o.datasymbol_id <> n.datasymbol_id
        or o.trade_rate <> n.trade_rate
        or o.repo_days <> n.repo_days
        or o.ldrepodeals_id_grand <> n.ldrepodeals_id_grand
        or o.repo_id <> n.repo_id
        or o.counterparty_type <> n.counterparty_type
        or o.clearing_type <> n.clearing_type
        or o.repo_method <> n.repo_method
        or o.contract_no <> n.contract_no
        or o.trade_time <> n.trade_time
        or o.market_type <> n.market_type
        or o.market_sub_type <> n.market_sub_type
        or o.repo_type <> n.repo_type
        or o.dn_dealer <> n.dn_dealer
        or o.shch_amount <> n.shch_amount
        or o.cdc_amount <> n.cdc_amount
        or o.shch_maturity_amount <> n.shch_maturity_amount
        or o.cdc_maturity_amount <> n.cdc_maturity_amount
        or o.shch_interest <> n.shch_interest
        or o.cdc_interest <> n.cdc_interest
        or o.sec_face_amt <> n.sec_face_amt
        or o.shch_sec_face_amt <> n.shch_sec_face_amt
        or o.cdc_sec_face_amt <> n.cdc_sec_face_amt
        or o.repo_face_amt <> n.repo_face_amt
        or o.shch_repo_face_amt <> n.shch_repo_face_amt
        or o.cdc_repo_face_amt <> n.cdc_repo_face_amt
        or o.shch_n_cdc <> n.shch_n_cdc
        or o.approval_number <> n.approval_number
        or o.note <> n.note
        or o.repo_bonds <> n.repo_bonds
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_ldrepodeals_cl(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,bondscode -- 债券代码
            ,bondsname -- 债券名称
            ,serial_number -- 交易号(标识数据表中记录的唯一组合)
            ,trade_date -- 首期交易日
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,buyorsell -- 交易方向
            ,face_amount -- 质押券面额
            ,repo_rate -- 质押比例
            ,amount -- 首期结算金额
            ,maturity_amount -- 到期结算金额
            ,fee -- 首期费用
            ,tax_amt -- 首期税金
            ,broker_amt -- 首期佣金
            ,interest -- 应计利息
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手ID
            ,settle_type -- 首期结算方式
            ,settle_type2 -- 到期结算方式
            ,dealer_id -- 交易员ID
            ,dealer_name -- 交易员姓名
            ,ref_number -- 成交编号
            ,cfets_from -- 是否是CFETS交易
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源ID
            ,trade_rate -- 回购利率
            ,repo_days -- 回购天数
            ,ldrepodeals_id_grand -- 原始交易ID
            ,repo_id -- 回购名称
            ,counterparty_type -- 计息基准
            ,clearing_type -- 清算类型
            ,repo_method -- 回购方式
            ,contract_no -- 合约编号
            ,trade_time -- 交易时间
            ,market_type -- 交易场所
            ,market_sub_type -- 交易场所子类
            ,repo_type -- 回购类型
            ,dn_dealer -- 本币交易员
            ,shch_amount -- 上清所交易金额
            ,cdc_amount -- 中债登交易金额
            ,shch_maturity_amount -- 上清所到期结算金额
            ,cdc_maturity_amount -- 中债登到期结算金额
            ,shch_interest -- 上清所利息
            ,cdc_interest -- 中债登利息
            ,sec_face_amt -- 券面总额（合计）
            ,shch_sec_face_amt -- 上清所券面总额（合计）
            ,cdc_sec_face_amt -- 中债登券面总额（合计）
            ,repo_face_amt -- 抵押品券面总额（合计）
            ,shch_repo_face_amt -- 上清所抵押品券面总额（合计）
            ,cdc_repo_face_amt -- 中债登抵押品券面总额（合计）
            ,shch_n_cdc -- 是否跨托管
            ,approval_number -- 审批单号
            ,note -- 备注
            ,repo_bonds -- WTRADE_REPO_BONDS是否有对应的质押券数据,Y:所有质押券信息在WTRADE_REPO_BONDS中,前25张券在wtrade_repo.SECURITY_CODE中,N:所有质押券信息在wtrade_repo.SECURITY_CODE中,不在WTRADE_REPO_BONDS中
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_ldrepodeals_op(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,bondscode -- 债券代码
            ,bondsname -- 债券名称
            ,serial_number -- 交易号(标识数据表中记录的唯一组合)
            ,trade_date -- 首期交易日
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,buyorsell -- 交易方向
            ,face_amount -- 质押券面额
            ,repo_rate -- 质押比例
            ,amount -- 首期结算金额
            ,maturity_amount -- 到期结算金额
            ,fee -- 首期费用
            ,tax_amt -- 首期税金
            ,broker_amt -- 首期佣金
            ,interest -- 应计利息
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手ID
            ,settle_type -- 首期结算方式
            ,settle_type2 -- 到期结算方式
            ,dealer_id -- 交易员ID
            ,dealer_name -- 交易员姓名
            ,ref_number -- 成交编号
            ,cfets_from -- 是否是CFETS交易
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源ID
            ,trade_rate -- 回购利率
            ,repo_days -- 回购天数
            ,ldrepodeals_id_grand -- 原始交易ID
            ,repo_id -- 回购名称
            ,counterparty_type -- 计息基准
            ,clearing_type -- 清算类型
            ,repo_method -- 回购方式
            ,contract_no -- 合约编号
            ,trade_time -- 交易时间
            ,market_type -- 交易场所
            ,market_sub_type -- 交易场所子类
            ,repo_type -- 回购类型
            ,dn_dealer -- 本币交易员
            ,shch_amount -- 上清所交易金额
            ,cdc_amount -- 中债登交易金额
            ,shch_maturity_amount -- 上清所到期结算金额
            ,cdc_maturity_amount -- 中债登到期结算金额
            ,shch_interest -- 上清所利息
            ,cdc_interest -- 中债登利息
            ,sec_face_amt -- 券面总额（合计）
            ,shch_sec_face_amt -- 上清所券面总额（合计）
            ,cdc_sec_face_amt -- 中债登券面总额（合计）
            ,repo_face_amt -- 抵押品券面总额（合计）
            ,shch_repo_face_amt -- 上清所抵押品券面总额（合计）
            ,cdc_repo_face_amt -- 中债登抵押品券面总额（合计）
            ,shch_n_cdc -- 是否跨托管
            ,approval_number -- 审批单号
            ,note -- 备注
            ,repo_bonds -- WTRADE_REPO_BONDS是否有对应的质押券数据,Y:所有质押券信息在WTRADE_REPO_BONDS中,前25张券在wtrade_repo.SECURITY_CODE中,N:所有质押券信息在wtrade_repo.SECURITY_CODE中,不在WTRADE_REPO_BONDS中
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.deal_id -- 引用表ID
    ,o.deal_tablename -- 引用表名
    ,o.aspclient_id -- 部门编号
    ,o.bondscode -- 债券代码
    ,o.bondsname -- 债券名称
    ,o.serial_number -- 交易号(标识数据表中记录的唯一组合)
    ,o.trade_date -- 首期交易日
    ,o.value_date -- 首期交割日
    ,o.maturity_date -- 到期交割日
    ,o.buyorsell -- 交易方向
    ,o.face_amount -- 质押券面额
    ,o.repo_rate -- 质押比例
    ,o.amount -- 首期结算金额
    ,o.maturity_amount -- 到期结算金额
    ,o.fee -- 首期费用
    ,o.tax_amt -- 首期税金
    ,o.broker_amt -- 首期佣金
    ,o.interest -- 应计利息
    ,o.portfolio_id -- 交易组别
    ,o.portfolio_name -- 交易组别名称
    ,o.keepfolder_id -- 账户ID
    ,o.keepfolder_shortname -- 账户名称
    ,o.cptys_short_name -- 交易对手名
    ,o.cptys_id -- 交易对手ID
    ,o.settle_type -- 首期结算方式
    ,o.settle_type2 -- 到期结算方式
    ,o.dealer_id -- 交易员ID
    ,o.dealer_name -- 交易员姓名
    ,o.ref_number -- 成交编号
    ,o.cfets_from -- 是否是CFETS交易
    ,o.lastmodified -- 最后修改时间
    ,o.datasymbol_id -- 数据源ID
    ,o.trade_rate -- 回购利率
    ,o.repo_days -- 回购天数
    ,o.ldrepodeals_id_grand -- 原始交易ID
    ,o.repo_id -- 回购名称
    ,o.counterparty_type -- 计息基准
    ,o.clearing_type -- 清算类型
    ,o.repo_method -- 回购方式
    ,o.contract_no -- 合约编号
    ,o.trade_time -- 交易时间
    ,o.market_type -- 交易场所
    ,o.market_sub_type -- 交易场所子类
    ,o.repo_type -- 回购类型
    ,o.dn_dealer -- 本币交易员
    ,o.shch_amount -- 上清所交易金额
    ,o.cdc_amount -- 中债登交易金额
    ,o.shch_maturity_amount -- 上清所到期结算金额
    ,o.cdc_maturity_amount -- 中债登到期结算金额
    ,o.shch_interest -- 上清所利息
    ,o.cdc_interest -- 中债登利息
    ,o.sec_face_amt -- 券面总额（合计）
    ,o.shch_sec_face_amt -- 上清所券面总额（合计）
    ,o.cdc_sec_face_amt -- 中债登券面总额（合计）
    ,o.repo_face_amt -- 抵押品券面总额（合计）
    ,o.shch_repo_face_amt -- 上清所抵押品券面总额（合计）
    ,o.cdc_repo_face_amt -- 中债登抵押品券面总额（合计）
    ,o.shch_n_cdc -- 是否跨托管
    ,o.approval_number -- 审批单号
    ,o.note -- 备注
    ,o.repo_bonds -- WTRADE_REPO_BONDS是否有对应的质押券数据,Y:所有质押券信息在WTRADE_REPO_BONDS中,前25张券在wtrade_repo.SECURITY_CODE中,N:所有质押券信息在wtrade_repo.SECURITY_CODE中,不在WTRADE_REPO_BONDS中
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
from ${iol_schema}.ctms_tbs_v_ldrepodeals_bk o
    left join ${iol_schema}.ctms_tbs_v_ldrepodeals_op n
        on
            o.deal_id = n.deal_id
            and o.deal_tablename = n.deal_tablename
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_ldrepodeals_cl d
        on
            o.deal_id = d.deal_id
            and o.deal_tablename = d.deal_tablename
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ctms_tbs_v_ldrepodeals;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ctms_tbs_v_ldrepodeals') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ctms_tbs_v_ldrepodeals drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ctms_tbs_v_ldrepodeals add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ctms_tbs_v_ldrepodeals exchange partition p_${batch_date} with table ${iol_schema}.ctms_tbs_v_ldrepodeals_cl;
alter table ${iol_schema}.ctms_tbs_v_ldrepodeals exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_ldrepodeals_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_ldrepodeals to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_ldrepodeals_op purge;
drop table ${iol_schema}.ctms_tbs_v_ldrepodeals_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_ldrepodeals_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_ldrepodeals',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
