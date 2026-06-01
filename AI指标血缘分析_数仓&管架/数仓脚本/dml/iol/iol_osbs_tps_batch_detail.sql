/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_tps_batch_detail
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
create table ${iol_schema}.osbs_tps_batch_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_tps_batch_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_batch_detail_op purge;
drop table ${iol_schema}.osbs_tps_batch_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_batch_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_batch_detail where 0=1;

create table ${iol_schema}.osbs_tps_batch_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_batch_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_batch_detail_cl(
            tbd_batchno -- 批次号
            ,tbd_detailno -- 明细流水号
            ,tbd_flowno -- 流水号
            ,tbd_payeracno -- 付款账号
            ,tbd_payeracname -- 付款账号名称
            ,tbd_payerbankactype -- 付款账号账户类型
            ,tbd_currency -- 币种
            ,tbd_payerdeptid -- 付款部门ID
            ,tbd_payercrflag -- 付款钞汇标志(C-现钞,R-现汇,X-不适用)
            ,tbd_payersubacno -- 付款子账户
            ,tbd_payersubactype -- 付款子账户账户类型
            ,tbd_payersubacseq -- 付款子账号顺序号
            ,tbd_payeeacno -- 收款账户
            ,tbd_payeeacname -- 收款账户名称
            ,tbd_payeebankactype -- 收款账户账户类型(1-个人,2-企业)
            ,tbd_payeecurrency -- 收款币种
            ,tbd_payeecrflag -- 收款钞汇标志
            ,tbd_payeeciftype -- 收款客户类型
            ,tbd_payeebankid -- 收款银行号
            ,tbd_payeebankname -- 收款银行名
            ,tbd_payeeprovincecode -- 收款省份号码
            ,tbd_payeeprovincename -- 收款省份名称
            ,tbd_payeecitycode -- 收款城市号
            ,tbd_payeecityname -- 收款城市名
            ,tbd_payeeuniondeptid -- 收款网点ID
            ,tbd_payeeuniondeptname -- 收款网点名称
            ,tbd_payeeclearbankid -- 收款清算行ID
            ,tbd_payeercbcitycode -- 收款RCB城市号
            ,tbd_rcbpost -- RCB邮政编码
            ,tbd_payeemobile -- 收款手机号
            ,tbd_payeesms -- 收款SMS
            ,tbd_amount -- 金额
            ,tbd_fee -- 收费
            ,tbd_notecode -- 附言
            ,tbd_remark -- 备注
            ,tbd_transcode -- 交易码(Transfer-跨行转账,BankInnerTransfer-行内转账)
            ,tbd_transdate -- 交易日期
            ,tbd_transtime -- 交易时间
            ,tbd_savepayeeflag -- 是否保存收款人(0-否,1-是)
            ,tbd_notifypayeeflag -- 是否通知收款人(0-否,1-是)
            ,tbd_detailstate -- I-入库，等待跑批,L-结果未明，正在跑批,S-转账成功,U-结果未明,F-转账失败,C-批量预约已撤销
            ,tbd_returncode -- 返回码
            ,tbd_returnmsg -- 返回信息
            ,tbd_processstarttime -- 处理开始时间
            ,tbd_processendtime -- 处理结束时间
            ,tbd_processjnlno -- 处理流水号
            ,tbd_routerjnlno -- 路由流水号
            ,tbd_hostjnlno -- 核心流水号
            ,tbd_validatemsg -- 校验信息
            ,tbd_discountrate -- 折扣率
            ,tbd_parentfee -- 上层收费
            ,tbd_hostdate -- 主机日期
            ,tbd_transfertype -- 转出方式
            ,tbd_transferdate -- 转出日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_batch_detail_op(
            tbd_batchno -- 批次号
            ,tbd_detailno -- 明细流水号
            ,tbd_flowno -- 流水号
            ,tbd_payeracno -- 付款账号
            ,tbd_payeracname -- 付款账号名称
            ,tbd_payerbankactype -- 付款账号账户类型
            ,tbd_currency -- 币种
            ,tbd_payerdeptid -- 付款部门ID
            ,tbd_payercrflag -- 付款钞汇标志(C-现钞,R-现汇,X-不适用)
            ,tbd_payersubacno -- 付款子账户
            ,tbd_payersubactype -- 付款子账户账户类型
            ,tbd_payersubacseq -- 付款子账号顺序号
            ,tbd_payeeacno -- 收款账户
            ,tbd_payeeacname -- 收款账户名称
            ,tbd_payeebankactype -- 收款账户账户类型(1-个人,2-企业)
            ,tbd_payeecurrency -- 收款币种
            ,tbd_payeecrflag -- 收款钞汇标志
            ,tbd_payeeciftype -- 收款客户类型
            ,tbd_payeebankid -- 收款银行号
            ,tbd_payeebankname -- 收款银行名
            ,tbd_payeeprovincecode -- 收款省份号码
            ,tbd_payeeprovincename -- 收款省份名称
            ,tbd_payeecitycode -- 收款城市号
            ,tbd_payeecityname -- 收款城市名
            ,tbd_payeeuniondeptid -- 收款网点ID
            ,tbd_payeeuniondeptname -- 收款网点名称
            ,tbd_payeeclearbankid -- 收款清算行ID
            ,tbd_payeercbcitycode -- 收款RCB城市号
            ,tbd_rcbpost -- RCB邮政编码
            ,tbd_payeemobile -- 收款手机号
            ,tbd_payeesms -- 收款SMS
            ,tbd_amount -- 金额
            ,tbd_fee -- 收费
            ,tbd_notecode -- 附言
            ,tbd_remark -- 备注
            ,tbd_transcode -- 交易码(Transfer-跨行转账,BankInnerTransfer-行内转账)
            ,tbd_transdate -- 交易日期
            ,tbd_transtime -- 交易时间
            ,tbd_savepayeeflag -- 是否保存收款人(0-否,1-是)
            ,tbd_notifypayeeflag -- 是否通知收款人(0-否,1-是)
            ,tbd_detailstate -- I-入库，等待跑批,L-结果未明，正在跑批,S-转账成功,U-结果未明,F-转账失败,C-批量预约已撤销
            ,tbd_returncode -- 返回码
            ,tbd_returnmsg -- 返回信息
            ,tbd_processstarttime -- 处理开始时间
            ,tbd_processendtime -- 处理结束时间
            ,tbd_processjnlno -- 处理流水号
            ,tbd_routerjnlno -- 路由流水号
            ,tbd_hostjnlno -- 核心流水号
            ,tbd_validatemsg -- 校验信息
            ,tbd_discountrate -- 折扣率
            ,tbd_parentfee -- 上层收费
            ,tbd_hostdate -- 主机日期
            ,tbd_transfertype -- 转出方式
            ,tbd_transferdate -- 转出日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tbd_batchno, o.tbd_batchno) as tbd_batchno -- 批次号
    ,nvl(n.tbd_detailno, o.tbd_detailno) as tbd_detailno -- 明细流水号
    ,nvl(n.tbd_flowno, o.tbd_flowno) as tbd_flowno -- 流水号
    ,nvl(n.tbd_payeracno, o.tbd_payeracno) as tbd_payeracno -- 付款账号
    ,nvl(n.tbd_payeracname, o.tbd_payeracname) as tbd_payeracname -- 付款账号名称
    ,nvl(n.tbd_payerbankactype, o.tbd_payerbankactype) as tbd_payerbankactype -- 付款账号账户类型
    ,nvl(n.tbd_currency, o.tbd_currency) as tbd_currency -- 币种
    ,nvl(n.tbd_payerdeptid, o.tbd_payerdeptid) as tbd_payerdeptid -- 付款部门ID
    ,nvl(n.tbd_payercrflag, o.tbd_payercrflag) as tbd_payercrflag -- 付款钞汇标志(C-现钞,R-现汇,X-不适用)
    ,nvl(n.tbd_payersubacno, o.tbd_payersubacno) as tbd_payersubacno -- 付款子账户
    ,nvl(n.tbd_payersubactype, o.tbd_payersubactype) as tbd_payersubactype -- 付款子账户账户类型
    ,nvl(n.tbd_payersubacseq, o.tbd_payersubacseq) as tbd_payersubacseq -- 付款子账号顺序号
    ,nvl(n.tbd_payeeacno, o.tbd_payeeacno) as tbd_payeeacno -- 收款账户
    ,nvl(n.tbd_payeeacname, o.tbd_payeeacname) as tbd_payeeacname -- 收款账户名称
    ,nvl(n.tbd_payeebankactype, o.tbd_payeebankactype) as tbd_payeebankactype -- 收款账户账户类型(1-个人,2-企业)
    ,nvl(n.tbd_payeecurrency, o.tbd_payeecurrency) as tbd_payeecurrency -- 收款币种
    ,nvl(n.tbd_payeecrflag, o.tbd_payeecrflag) as tbd_payeecrflag -- 收款钞汇标志
    ,nvl(n.tbd_payeeciftype, o.tbd_payeeciftype) as tbd_payeeciftype -- 收款客户类型
    ,nvl(n.tbd_payeebankid, o.tbd_payeebankid) as tbd_payeebankid -- 收款银行号
    ,nvl(n.tbd_payeebankname, o.tbd_payeebankname) as tbd_payeebankname -- 收款银行名
    ,nvl(n.tbd_payeeprovincecode, o.tbd_payeeprovincecode) as tbd_payeeprovincecode -- 收款省份号码
    ,nvl(n.tbd_payeeprovincename, o.tbd_payeeprovincename) as tbd_payeeprovincename -- 收款省份名称
    ,nvl(n.tbd_payeecitycode, o.tbd_payeecitycode) as tbd_payeecitycode -- 收款城市号
    ,nvl(n.tbd_payeecityname, o.tbd_payeecityname) as tbd_payeecityname -- 收款城市名
    ,nvl(n.tbd_payeeuniondeptid, o.tbd_payeeuniondeptid) as tbd_payeeuniondeptid -- 收款网点ID
    ,nvl(n.tbd_payeeuniondeptname, o.tbd_payeeuniondeptname) as tbd_payeeuniondeptname -- 收款网点名称
    ,nvl(n.tbd_payeeclearbankid, o.tbd_payeeclearbankid) as tbd_payeeclearbankid -- 收款清算行ID
    ,nvl(n.tbd_payeercbcitycode, o.tbd_payeercbcitycode) as tbd_payeercbcitycode -- 收款RCB城市号
    ,nvl(n.tbd_rcbpost, o.tbd_rcbpost) as tbd_rcbpost -- RCB邮政编码
    ,nvl(n.tbd_payeemobile, o.tbd_payeemobile) as tbd_payeemobile -- 收款手机号
    ,nvl(n.tbd_payeesms, o.tbd_payeesms) as tbd_payeesms -- 收款SMS
    ,nvl(n.tbd_amount, o.tbd_amount) as tbd_amount -- 金额
    ,nvl(n.tbd_fee, o.tbd_fee) as tbd_fee -- 收费
    ,nvl(n.tbd_notecode, o.tbd_notecode) as tbd_notecode -- 附言
    ,nvl(n.tbd_remark, o.tbd_remark) as tbd_remark -- 备注
    ,nvl(n.tbd_transcode, o.tbd_transcode) as tbd_transcode -- 交易码(Transfer-跨行转账,BankInnerTransfer-行内转账)
    ,nvl(n.tbd_transdate, o.tbd_transdate) as tbd_transdate -- 交易日期
    ,nvl(n.tbd_transtime, o.tbd_transtime) as tbd_transtime -- 交易时间
    ,nvl(n.tbd_savepayeeflag, o.tbd_savepayeeflag) as tbd_savepayeeflag -- 是否保存收款人(0-否,1-是)
    ,nvl(n.tbd_notifypayeeflag, o.tbd_notifypayeeflag) as tbd_notifypayeeflag -- 是否通知收款人(0-否,1-是)
    ,nvl(n.tbd_detailstate, o.tbd_detailstate) as tbd_detailstate -- I-入库，等待跑批,L-结果未明，正在跑批,S-转账成功,U-结果未明,F-转账失败,C-批量预约已撤销
    ,nvl(n.tbd_returncode, o.tbd_returncode) as tbd_returncode -- 返回码
    ,nvl(n.tbd_returnmsg, o.tbd_returnmsg) as tbd_returnmsg -- 返回信息
    ,nvl(n.tbd_processstarttime, o.tbd_processstarttime) as tbd_processstarttime -- 处理开始时间
    ,nvl(n.tbd_processendtime, o.tbd_processendtime) as tbd_processendtime -- 处理结束时间
    ,nvl(n.tbd_processjnlno, o.tbd_processjnlno) as tbd_processjnlno -- 处理流水号
    ,nvl(n.tbd_routerjnlno, o.tbd_routerjnlno) as tbd_routerjnlno -- 路由流水号
    ,nvl(n.tbd_hostjnlno, o.tbd_hostjnlno) as tbd_hostjnlno -- 核心流水号
    ,nvl(n.tbd_validatemsg, o.tbd_validatemsg) as tbd_validatemsg -- 校验信息
    ,nvl(n.tbd_discountrate, o.tbd_discountrate) as tbd_discountrate -- 折扣率
    ,nvl(n.tbd_parentfee, o.tbd_parentfee) as tbd_parentfee -- 上层收费
    ,nvl(n.tbd_hostdate, o.tbd_hostdate) as tbd_hostdate -- 主机日期
    ,nvl(n.tbd_transfertype, o.tbd_transfertype) as tbd_transfertype -- 转出方式
    ,nvl(n.tbd_transferdate, o.tbd_transferdate) as tbd_transferdate -- 转出日期
    ,case when
            n.tbd_batchno is null
            and n.tbd_detailno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tbd_batchno is null
            and n.tbd_detailno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tbd_batchno is null
            and n.tbd_detailno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_tps_batch_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_tps_batch_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tbd_batchno = n.tbd_batchno
            and o.tbd_detailno = n.tbd_detailno
where (
        o.tbd_batchno is null
        and o.tbd_detailno is null
    )
    or (
        n.tbd_batchno is null
        and n.tbd_detailno is null
    )
    or (
        o.tbd_flowno <> n.tbd_flowno
        or o.tbd_payeracno <> n.tbd_payeracno
        or o.tbd_payeracname <> n.tbd_payeracname
        or o.tbd_payerbankactype <> n.tbd_payerbankactype
        or o.tbd_currency <> n.tbd_currency
        or o.tbd_payerdeptid <> n.tbd_payerdeptid
        or o.tbd_payercrflag <> n.tbd_payercrflag
        or o.tbd_payersubacno <> n.tbd_payersubacno
        or o.tbd_payersubactype <> n.tbd_payersubactype
        or o.tbd_payersubacseq <> n.tbd_payersubacseq
        or o.tbd_payeeacno <> n.tbd_payeeacno
        or o.tbd_payeeacname <> n.tbd_payeeacname
        or o.tbd_payeebankactype <> n.tbd_payeebankactype
        or o.tbd_payeecurrency <> n.tbd_payeecurrency
        or o.tbd_payeecrflag <> n.tbd_payeecrflag
        or o.tbd_payeeciftype <> n.tbd_payeeciftype
        or o.tbd_payeebankid <> n.tbd_payeebankid
        or o.tbd_payeebankname <> n.tbd_payeebankname
        or o.tbd_payeeprovincecode <> n.tbd_payeeprovincecode
        or o.tbd_payeeprovincename <> n.tbd_payeeprovincename
        or o.tbd_payeecitycode <> n.tbd_payeecitycode
        or o.tbd_payeecityname <> n.tbd_payeecityname
        or o.tbd_payeeuniondeptid <> n.tbd_payeeuniondeptid
        or o.tbd_payeeuniondeptname <> n.tbd_payeeuniondeptname
        or o.tbd_payeeclearbankid <> n.tbd_payeeclearbankid
        or o.tbd_payeercbcitycode <> n.tbd_payeercbcitycode
        or o.tbd_rcbpost <> n.tbd_rcbpost
        or o.tbd_payeemobile <> n.tbd_payeemobile
        or o.tbd_payeesms <> n.tbd_payeesms
        or o.tbd_amount <> n.tbd_amount
        or o.tbd_fee <> n.tbd_fee
        or o.tbd_notecode <> n.tbd_notecode
        or o.tbd_remark <> n.tbd_remark
        or o.tbd_transcode <> n.tbd_transcode
        or o.tbd_transdate <> n.tbd_transdate
        or o.tbd_transtime <> n.tbd_transtime
        or o.tbd_savepayeeflag <> n.tbd_savepayeeflag
        or o.tbd_notifypayeeflag <> n.tbd_notifypayeeflag
        or o.tbd_detailstate <> n.tbd_detailstate
        or o.tbd_returncode <> n.tbd_returncode
        or o.tbd_returnmsg <> n.tbd_returnmsg
        or o.tbd_processstarttime <> n.tbd_processstarttime
        or o.tbd_processendtime <> n.tbd_processendtime
        or o.tbd_processjnlno <> n.tbd_processjnlno
        or o.tbd_routerjnlno <> n.tbd_routerjnlno
        or o.tbd_hostjnlno <> n.tbd_hostjnlno
        or o.tbd_validatemsg <> n.tbd_validatemsg
        or o.tbd_discountrate <> n.tbd_discountrate
        or o.tbd_parentfee <> n.tbd_parentfee
        or o.tbd_hostdate <> n.tbd_hostdate
        or o.tbd_transfertype <> n.tbd_transfertype
        or o.tbd_transferdate <> n.tbd_transferdate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_batch_detail_cl(
            tbd_batchno -- 批次号
            ,tbd_detailno -- 明细流水号
            ,tbd_flowno -- 流水号
            ,tbd_payeracno -- 付款账号
            ,tbd_payeracname -- 付款账号名称
            ,tbd_payerbankactype -- 付款账号账户类型
            ,tbd_currency -- 币种
            ,tbd_payerdeptid -- 付款部门ID
            ,tbd_payercrflag -- 付款钞汇标志(C-现钞,R-现汇,X-不适用)
            ,tbd_payersubacno -- 付款子账户
            ,tbd_payersubactype -- 付款子账户账户类型
            ,tbd_payersubacseq -- 付款子账号顺序号
            ,tbd_payeeacno -- 收款账户
            ,tbd_payeeacname -- 收款账户名称
            ,tbd_payeebankactype -- 收款账户账户类型(1-个人,2-企业)
            ,tbd_payeecurrency -- 收款币种
            ,tbd_payeecrflag -- 收款钞汇标志
            ,tbd_payeeciftype -- 收款客户类型
            ,tbd_payeebankid -- 收款银行号
            ,tbd_payeebankname -- 收款银行名
            ,tbd_payeeprovincecode -- 收款省份号码
            ,tbd_payeeprovincename -- 收款省份名称
            ,tbd_payeecitycode -- 收款城市号
            ,tbd_payeecityname -- 收款城市名
            ,tbd_payeeuniondeptid -- 收款网点ID
            ,tbd_payeeuniondeptname -- 收款网点名称
            ,tbd_payeeclearbankid -- 收款清算行ID
            ,tbd_payeercbcitycode -- 收款RCB城市号
            ,tbd_rcbpost -- RCB邮政编码
            ,tbd_payeemobile -- 收款手机号
            ,tbd_payeesms -- 收款SMS
            ,tbd_amount -- 金额
            ,tbd_fee -- 收费
            ,tbd_notecode -- 附言
            ,tbd_remark -- 备注
            ,tbd_transcode -- 交易码(Transfer-跨行转账,BankInnerTransfer-行内转账)
            ,tbd_transdate -- 交易日期
            ,tbd_transtime -- 交易时间
            ,tbd_savepayeeflag -- 是否保存收款人(0-否,1-是)
            ,tbd_notifypayeeflag -- 是否通知收款人(0-否,1-是)
            ,tbd_detailstate -- I-入库，等待跑批,L-结果未明，正在跑批,S-转账成功,U-结果未明,F-转账失败,C-批量预约已撤销
            ,tbd_returncode -- 返回码
            ,tbd_returnmsg -- 返回信息
            ,tbd_processstarttime -- 处理开始时间
            ,tbd_processendtime -- 处理结束时间
            ,tbd_processjnlno -- 处理流水号
            ,tbd_routerjnlno -- 路由流水号
            ,tbd_hostjnlno -- 核心流水号
            ,tbd_validatemsg -- 校验信息
            ,tbd_discountrate -- 折扣率
            ,tbd_parentfee -- 上层收费
            ,tbd_hostdate -- 主机日期
            ,tbd_transfertype -- 转出方式
            ,tbd_transferdate -- 转出日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_batch_detail_op(
            tbd_batchno -- 批次号
            ,tbd_detailno -- 明细流水号
            ,tbd_flowno -- 流水号
            ,tbd_payeracno -- 付款账号
            ,tbd_payeracname -- 付款账号名称
            ,tbd_payerbankactype -- 付款账号账户类型
            ,tbd_currency -- 币种
            ,tbd_payerdeptid -- 付款部门ID
            ,tbd_payercrflag -- 付款钞汇标志(C-现钞,R-现汇,X-不适用)
            ,tbd_payersubacno -- 付款子账户
            ,tbd_payersubactype -- 付款子账户账户类型
            ,tbd_payersubacseq -- 付款子账号顺序号
            ,tbd_payeeacno -- 收款账户
            ,tbd_payeeacname -- 收款账户名称
            ,tbd_payeebankactype -- 收款账户账户类型(1-个人,2-企业)
            ,tbd_payeecurrency -- 收款币种
            ,tbd_payeecrflag -- 收款钞汇标志
            ,tbd_payeeciftype -- 收款客户类型
            ,tbd_payeebankid -- 收款银行号
            ,tbd_payeebankname -- 收款银行名
            ,tbd_payeeprovincecode -- 收款省份号码
            ,tbd_payeeprovincename -- 收款省份名称
            ,tbd_payeecitycode -- 收款城市号
            ,tbd_payeecityname -- 收款城市名
            ,tbd_payeeuniondeptid -- 收款网点ID
            ,tbd_payeeuniondeptname -- 收款网点名称
            ,tbd_payeeclearbankid -- 收款清算行ID
            ,tbd_payeercbcitycode -- 收款RCB城市号
            ,tbd_rcbpost -- RCB邮政编码
            ,tbd_payeemobile -- 收款手机号
            ,tbd_payeesms -- 收款SMS
            ,tbd_amount -- 金额
            ,tbd_fee -- 收费
            ,tbd_notecode -- 附言
            ,tbd_remark -- 备注
            ,tbd_transcode -- 交易码(Transfer-跨行转账,BankInnerTransfer-行内转账)
            ,tbd_transdate -- 交易日期
            ,tbd_transtime -- 交易时间
            ,tbd_savepayeeflag -- 是否保存收款人(0-否,1-是)
            ,tbd_notifypayeeflag -- 是否通知收款人(0-否,1-是)
            ,tbd_detailstate -- I-入库，等待跑批,L-结果未明，正在跑批,S-转账成功,U-结果未明,F-转账失败,C-批量预约已撤销
            ,tbd_returncode -- 返回码
            ,tbd_returnmsg -- 返回信息
            ,tbd_processstarttime -- 处理开始时间
            ,tbd_processendtime -- 处理结束时间
            ,tbd_processjnlno -- 处理流水号
            ,tbd_routerjnlno -- 路由流水号
            ,tbd_hostjnlno -- 核心流水号
            ,tbd_validatemsg -- 校验信息
            ,tbd_discountrate -- 折扣率
            ,tbd_parentfee -- 上层收费
            ,tbd_hostdate -- 主机日期
            ,tbd_transfertype -- 转出方式
            ,tbd_transferdate -- 转出日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tbd_batchno -- 批次号
    ,o.tbd_detailno -- 明细流水号
    ,o.tbd_flowno -- 流水号
    ,o.tbd_payeracno -- 付款账号
    ,o.tbd_payeracname -- 付款账号名称
    ,o.tbd_payerbankactype -- 付款账号账户类型
    ,o.tbd_currency -- 币种
    ,o.tbd_payerdeptid -- 付款部门ID
    ,o.tbd_payercrflag -- 付款钞汇标志(C-现钞,R-现汇,X-不适用)
    ,o.tbd_payersubacno -- 付款子账户
    ,o.tbd_payersubactype -- 付款子账户账户类型
    ,o.tbd_payersubacseq -- 付款子账号顺序号
    ,o.tbd_payeeacno -- 收款账户
    ,o.tbd_payeeacname -- 收款账户名称
    ,o.tbd_payeebankactype -- 收款账户账户类型(1-个人,2-企业)
    ,o.tbd_payeecurrency -- 收款币种
    ,o.tbd_payeecrflag -- 收款钞汇标志
    ,o.tbd_payeeciftype -- 收款客户类型
    ,o.tbd_payeebankid -- 收款银行号
    ,o.tbd_payeebankname -- 收款银行名
    ,o.tbd_payeeprovincecode -- 收款省份号码
    ,o.tbd_payeeprovincename -- 收款省份名称
    ,o.tbd_payeecitycode -- 收款城市号
    ,o.tbd_payeecityname -- 收款城市名
    ,o.tbd_payeeuniondeptid -- 收款网点ID
    ,o.tbd_payeeuniondeptname -- 收款网点名称
    ,o.tbd_payeeclearbankid -- 收款清算行ID
    ,o.tbd_payeercbcitycode -- 收款RCB城市号
    ,o.tbd_rcbpost -- RCB邮政编码
    ,o.tbd_payeemobile -- 收款手机号
    ,o.tbd_payeesms -- 收款SMS
    ,o.tbd_amount -- 金额
    ,o.tbd_fee -- 收费
    ,o.tbd_notecode -- 附言
    ,o.tbd_remark -- 备注
    ,o.tbd_transcode -- 交易码(Transfer-跨行转账,BankInnerTransfer-行内转账)
    ,o.tbd_transdate -- 交易日期
    ,o.tbd_transtime -- 交易时间
    ,o.tbd_savepayeeflag -- 是否保存收款人(0-否,1-是)
    ,o.tbd_notifypayeeflag -- 是否通知收款人(0-否,1-是)
    ,o.tbd_detailstate -- I-入库，等待跑批,L-结果未明，正在跑批,S-转账成功,U-结果未明,F-转账失败,C-批量预约已撤销
    ,o.tbd_returncode -- 返回码
    ,o.tbd_returnmsg -- 返回信息
    ,o.tbd_processstarttime -- 处理开始时间
    ,o.tbd_processendtime -- 处理结束时间
    ,o.tbd_processjnlno -- 处理流水号
    ,o.tbd_routerjnlno -- 路由流水号
    ,o.tbd_hostjnlno -- 核心流水号
    ,o.tbd_validatemsg -- 校验信息
    ,o.tbd_discountrate -- 折扣率
    ,o.tbd_parentfee -- 上层收费
    ,o.tbd_hostdate -- 主机日期
    ,o.tbd_transfertype -- 转出方式
    ,o.tbd_transferdate -- 转出日期
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
from ${iol_schema}.osbs_tps_batch_detail_bk o
    left join ${iol_schema}.osbs_tps_batch_detail_op n
        on
            o.tbd_batchno = n.tbd_batchno
            and o.tbd_detailno = n.tbd_detailno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_tps_batch_detail_cl d
        on
            o.tbd_batchno = d.tbd_batchno
            and o.tbd_detailno = d.tbd_detailno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.osbs_tps_batch_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('osbs_tps_batch_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.osbs_tps_batch_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.osbs_tps_batch_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.osbs_tps_batch_detail exchange partition p_${batch_date} with table ${iol_schema}.osbs_tps_batch_detail_cl;
alter table ${iol_schema}.osbs_tps_batch_detail exchange partition p_20991231 with table ${iol_schema}.osbs_tps_batch_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_tps_batch_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_batch_detail_op purge;
drop table ${iol_schema}.osbs_tps_batch_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_tps_batch_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_tps_batch_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
