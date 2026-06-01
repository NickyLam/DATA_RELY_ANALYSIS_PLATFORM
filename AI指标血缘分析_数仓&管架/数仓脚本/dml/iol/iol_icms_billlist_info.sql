/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_billlist_info
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
create table ${iol_schema}.icms_billlist_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_billlist_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_billlist_info_op purge;
drop table ${iol_schema}.icms_billlist_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_billlist_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_billlist_info where 0=1;

create table ${iol_schema}.icms_billlist_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_billlist_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_billlist_info_cl(
            batchno -- 批次号
            ,contractno -- 协议编号
            ,keyno -- 单笔票据唯一标示
            ,discountsum -- 贴现利息
            ,discountdate -- 贴现日期
            ,draweracct1name -- 出票人开户行
            ,isbas -- 是否可转让
            ,duedate -- 到期日
            ,payee -- 收款人户名
            ,purchaserpercent -- 买方付息比例(贴现方式为协议付息才有效)
            ,updatedate -- 更新日期
            ,draweracctname -- 贴现客户账户开户行号
            ,acptdate -- 出票日
            ,drawercustomer -- 开票人户名
            ,manualpay -- 工本费
            ,othertxbalance -- 第三方付息金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,currency -- 币种
            ,guaracctno -- 保证金账户
            ,paysum -- 手续费
            ,czflag -- 冲账标志
            ,inputdate -- 录入时间
            ,buybenddate -- 约定赎回日
            ,acceptorbankname -- 承兑人开户行名称
            ,afeerate -- 贴现利率
            ,customername -- 客户名称
            ,guarterm -- 保证金存期
            ,otherdraweracctno -- 第三方付息账户
            ,isonline -- 是否线上清算
            ,inputorgid -- 录入机构
            ,buyenddate -- 赎回截止日
            ,putoutorgid -- 放款机构编号
            ,draweracctbankname -- 贴现客户账户开户行名
            ,updateuserid -- 更新人
            ,payeeacctname -- 收款人开户行
            ,guarsum -- 保证金金额
            ,businesstype -- 交易类型
            ,draweracctno1 -- 出票人账号
            ,inputuserid -- 录入人
            ,customerid -- 客户号
            ,discountway -- 贴现方式
            ,billclass -- 票据性质
            ,acptdate2 -- 承兑日
            ,interestday -- 计息天数
            ,isbecustody -- 是否代保管
            ,acceptorbankno -- 承兑人开户行号
            ,discounttype -- 贴现类型
            ,buybegindate -- 赎回开放日
            ,buyrate -- 赎回利率
            ,payeeacctno -- 收款人帐号
            ,changeday -- 调整天数
            ,billtype -- 票据类型
            ,billno -- 票据号码
            ,billdiscounttype -- 是否跨行贴现标识（1是2否）
            ,custbillacctname -- 客户结算账户户名
            ,draweracctno -- 贴现客户账户
            ,billsum -- 贴现票据金额
            ,paveeacctbankno -- 收款人行号
            ,acceptor -- 承兑人名称
            ,updateorgid -- 更新机构
            ,sectionno -- 区间号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_billlist_info_op(
            batchno -- 批次号
            ,contractno -- 协议编号
            ,keyno -- 单笔票据唯一标示
            ,discountsum -- 贴现利息
            ,discountdate -- 贴现日期
            ,draweracct1name -- 出票人开户行
            ,isbas -- 是否可转让
            ,duedate -- 到期日
            ,payee -- 收款人户名
            ,purchaserpercent -- 买方付息比例(贴现方式为协议付息才有效)
            ,updatedate -- 更新日期
            ,draweracctname -- 贴现客户账户开户行号
            ,acptdate -- 出票日
            ,drawercustomer -- 开票人户名
            ,manualpay -- 工本费
            ,othertxbalance -- 第三方付息金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,currency -- 币种
            ,guaracctno -- 保证金账户
            ,paysum -- 手续费
            ,czflag -- 冲账标志
            ,inputdate -- 录入时间
            ,buybenddate -- 约定赎回日
            ,acceptorbankname -- 承兑人开户行名称
            ,afeerate -- 贴现利率
            ,customername -- 客户名称
            ,guarterm -- 保证金存期
            ,otherdraweracctno -- 第三方付息账户
            ,isonline -- 是否线上清算
            ,inputorgid -- 录入机构
            ,buyenddate -- 赎回截止日
            ,putoutorgid -- 放款机构编号
            ,draweracctbankname -- 贴现客户账户开户行名
            ,updateuserid -- 更新人
            ,payeeacctname -- 收款人开户行
            ,guarsum -- 保证金金额
            ,businesstype -- 交易类型
            ,draweracctno1 -- 出票人账号
            ,inputuserid -- 录入人
            ,customerid -- 客户号
            ,discountway -- 贴现方式
            ,billclass -- 票据性质
            ,acptdate2 -- 承兑日
            ,interestday -- 计息天数
            ,isbecustody -- 是否代保管
            ,acceptorbankno -- 承兑人开户行号
            ,discounttype -- 贴现类型
            ,buybegindate -- 赎回开放日
            ,buyrate -- 赎回利率
            ,payeeacctno -- 收款人帐号
            ,changeday -- 调整天数
            ,billtype -- 票据类型
            ,billno -- 票据号码
            ,billdiscounttype -- 是否跨行贴现标识（1是2否）
            ,custbillacctname -- 客户结算账户户名
            ,draweracctno -- 贴现客户账户
            ,billsum -- 贴现票据金额
            ,paveeacctbankno -- 收款人行号
            ,acceptor -- 承兑人名称
            ,updateorgid -- 更新机构
            ,sectionno -- 区间号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.batchno, o.batchno) as batchno -- 批次号
    ,nvl(n.contractno, o.contractno) as contractno -- 协议编号
    ,nvl(n.keyno, o.keyno) as keyno -- 单笔票据唯一标示
    ,nvl(n.discountsum, o.discountsum) as discountsum -- 贴现利息
    ,nvl(n.discountdate, o.discountdate) as discountdate -- 贴现日期
    ,nvl(n.draweracct1name, o.draweracct1name) as draweracct1name -- 出票人开户行
    ,nvl(n.isbas, o.isbas) as isbas -- 是否可转让
    ,nvl(n.duedate, o.duedate) as duedate -- 到期日
    ,nvl(n.payee, o.payee) as payee -- 收款人户名
    ,nvl(n.purchaserpercent, o.purchaserpercent) as purchaserpercent -- 买方付息比例(贴现方式为协议付息才有效)
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.draweracctname, o.draweracctname) as draweracctname -- 贴现客户账户开户行号
    ,nvl(n.acptdate, o.acptdate) as acptdate -- 出票日
    ,nvl(n.drawercustomer, o.drawercustomer) as drawercustomer -- 开票人户名
    ,nvl(n.manualpay, o.manualpay) as manualpay -- 工本费
    ,nvl(n.othertxbalance, o.othertxbalance) as othertxbalance -- 第三方付息金额
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.guaracctno, o.guaracctno) as guaracctno -- 保证金账户
    ,nvl(n.paysum, o.paysum) as paysum -- 手续费
    ,nvl(n.czflag, o.czflag) as czflag -- 冲账标志
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 录入时间
    ,nvl(n.buybenddate, o.buybenddate) as buybenddate -- 约定赎回日
    ,nvl(n.acceptorbankname, o.acceptorbankname) as acceptorbankname -- 承兑人开户行名称
    ,nvl(n.afeerate, o.afeerate) as afeerate -- 贴现利率
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.guarterm, o.guarterm) as guarterm -- 保证金存期
    ,nvl(n.otherdraweracctno, o.otherdraweracctno) as otherdraweracctno -- 第三方付息账户
    ,nvl(n.isonline, o.isonline) as isonline -- 是否线上清算
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 录入机构
    ,nvl(n.buyenddate, o.buyenddate) as buyenddate -- 赎回截止日
    ,nvl(n.putoutorgid, o.putoutorgid) as putoutorgid -- 放款机构编号
    ,nvl(n.draweracctbankname, o.draweracctbankname) as draweracctbankname -- 贴现客户账户开户行名
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.payeeacctname, o.payeeacctname) as payeeacctname -- 收款人开户行
    ,nvl(n.guarsum, o.guarsum) as guarsum -- 保证金金额
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 交易类型
    ,nvl(n.draweracctno1, o.draweracctno1) as draweracctno1 -- 出票人账号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 录入人
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.discountway, o.discountway) as discountway -- 贴现方式
    ,nvl(n.billclass, o.billclass) as billclass -- 票据性质
    ,nvl(n.acptdate2, o.acptdate2) as acptdate2 -- 承兑日
    ,nvl(n.interestday, o.interestday) as interestday -- 计息天数
    ,nvl(n.isbecustody, o.isbecustody) as isbecustody -- 是否代保管
    ,nvl(n.acceptorbankno, o.acceptorbankno) as acceptorbankno -- 承兑人开户行号
    ,nvl(n.discounttype, o.discounttype) as discounttype -- 贴现类型
    ,nvl(n.buybegindate, o.buybegindate) as buybegindate -- 赎回开放日
    ,nvl(n.buyrate, o.buyrate) as buyrate -- 赎回利率
    ,nvl(n.payeeacctno, o.payeeacctno) as payeeacctno -- 收款人帐号
    ,nvl(n.changeday, o.changeday) as changeday -- 调整天数
    ,nvl(n.billtype, o.billtype) as billtype -- 票据类型
    ,nvl(n.billno, o.billno) as billno -- 票据号码
    ,nvl(n.billdiscounttype, o.billdiscounttype) as billdiscounttype -- 是否跨行贴现标识（1是2否）
    ,nvl(n.custbillacctname, o.custbillacctname) as custbillacctname -- 客户结算账户户名
    ,nvl(n.draweracctno, o.draweracctno) as draweracctno -- 贴现客户账户
    ,nvl(n.billsum, o.billsum) as billsum -- 贴现票据金额
    ,nvl(n.paveeacctbankno, o.paveeacctbankno) as paveeacctbankno -- 收款人行号
    ,nvl(n.acceptor, o.acceptor) as acceptor -- 承兑人名称
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.sectionno, o.sectionno) as sectionno -- 区间号
    ,case when
            n.batchno is null
            and n.contractno is null
            and n.keyno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.batchno is null
            and n.contractno is null
            and n.keyno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.batchno is null
            and n.contractno is null
            and n.keyno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_billlist_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_billlist_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.batchno = n.batchno
            and o.contractno = n.contractno
            and o.keyno = n.keyno
where (
        o.batchno is null
        and o.contractno is null
        and o.keyno is null
    )
    or (
        n.batchno is null
        and n.contractno is null
        and n.keyno is null
    )
    or (
        o.discountsum <> n.discountsum
        or o.discountdate <> n.discountdate
        or o.draweracct1name <> n.draweracct1name
        or o.isbas <> n.isbas
        or o.duedate <> n.duedate
        or o.payee <> n.payee
        or o.purchaserpercent <> n.purchaserpercent
        or o.updatedate <> n.updatedate
        or o.draweracctname <> n.draweracctname
        or o.acptdate <> n.acptdate
        or o.drawercustomer <> n.drawercustomer
        or o.manualpay <> n.manualpay
        or o.othertxbalance <> n.othertxbalance
        or o.migtflag <> n.migtflag
        or o.currency <> n.currency
        or o.guaracctno <> n.guaracctno
        or o.paysum <> n.paysum
        or o.czflag <> n.czflag
        or o.inputdate <> n.inputdate
        or o.buybenddate <> n.buybenddate
        or o.acceptorbankname <> n.acceptorbankname
        or o.afeerate <> n.afeerate
        or o.customername <> n.customername
        or o.guarterm <> n.guarterm
        or o.otherdraweracctno <> n.otherdraweracctno
        or o.isonline <> n.isonline
        or o.inputorgid <> n.inputorgid
        or o.buyenddate <> n.buyenddate
        or o.putoutorgid <> n.putoutorgid
        or o.draweracctbankname <> n.draweracctbankname
        or o.updateuserid <> n.updateuserid
        or o.payeeacctname <> n.payeeacctname
        or o.guarsum <> n.guarsum
        or o.businesstype <> n.businesstype
        or o.draweracctno1 <> n.draweracctno1
        or o.inputuserid <> n.inputuserid
        or o.customerid <> n.customerid
        or o.discountway <> n.discountway
        or o.billclass <> n.billclass
        or o.acptdate2 <> n.acptdate2
        or o.interestday <> n.interestday
        or o.isbecustody <> n.isbecustody
        or o.acceptorbankno <> n.acceptorbankno
        or o.discounttype <> n.discounttype
        or o.buybegindate <> n.buybegindate
        or o.buyrate <> n.buyrate
        or o.payeeacctno <> n.payeeacctno
        or o.changeday <> n.changeday
        or o.billtype <> n.billtype
        or o.billno <> n.billno
        or o.billdiscounttype <> n.billdiscounttype
        or o.custbillacctname <> n.custbillacctname
        or o.draweracctno <> n.draweracctno
        or o.billsum <> n.billsum
        or o.paveeacctbankno <> n.paveeacctbankno
        or o.acceptor <> n.acceptor
        or o.updateorgid <> n.updateorgid
        or o.sectionno <> n.sectionno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_billlist_info_cl(
            batchno -- 批次号
            ,contractno -- 协议编号
            ,keyno -- 单笔票据唯一标示
            ,discountsum -- 贴现利息
            ,discountdate -- 贴现日期
            ,draweracct1name -- 出票人开户行
            ,isbas -- 是否可转让
            ,duedate -- 到期日
            ,payee -- 收款人户名
            ,purchaserpercent -- 买方付息比例(贴现方式为协议付息才有效)
            ,updatedate -- 更新日期
            ,draweracctname -- 贴现客户账户开户行号
            ,acptdate -- 出票日
            ,drawercustomer -- 开票人户名
            ,manualpay -- 工本费
            ,othertxbalance -- 第三方付息金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,currency -- 币种
            ,guaracctno -- 保证金账户
            ,paysum -- 手续费
            ,czflag -- 冲账标志
            ,inputdate -- 录入时间
            ,buybenddate -- 约定赎回日
            ,acceptorbankname -- 承兑人开户行名称
            ,afeerate -- 贴现利率
            ,customername -- 客户名称
            ,guarterm -- 保证金存期
            ,otherdraweracctno -- 第三方付息账户
            ,isonline -- 是否线上清算
            ,inputorgid -- 录入机构
            ,buyenddate -- 赎回截止日
            ,putoutorgid -- 放款机构编号
            ,draweracctbankname -- 贴现客户账户开户行名
            ,updateuserid -- 更新人
            ,payeeacctname -- 收款人开户行
            ,guarsum -- 保证金金额
            ,businesstype -- 交易类型
            ,draweracctno1 -- 出票人账号
            ,inputuserid -- 录入人
            ,customerid -- 客户号
            ,discountway -- 贴现方式
            ,billclass -- 票据性质
            ,acptdate2 -- 承兑日
            ,interestday -- 计息天数
            ,isbecustody -- 是否代保管
            ,acceptorbankno -- 承兑人开户行号
            ,discounttype -- 贴现类型
            ,buybegindate -- 赎回开放日
            ,buyrate -- 赎回利率
            ,payeeacctno -- 收款人帐号
            ,changeday -- 调整天数
            ,billtype -- 票据类型
            ,billno -- 票据号码
            ,billdiscounttype -- 是否跨行贴现标识（1是2否）
            ,custbillacctname -- 客户结算账户户名
            ,draweracctno -- 贴现客户账户
            ,billsum -- 贴现票据金额
            ,paveeacctbankno -- 收款人行号
            ,acceptor -- 承兑人名称
            ,updateorgid -- 更新机构
            ,sectionno -- 区间号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_billlist_info_op(
            batchno -- 批次号
            ,contractno -- 协议编号
            ,keyno -- 单笔票据唯一标示
            ,discountsum -- 贴现利息
            ,discountdate -- 贴现日期
            ,draweracct1name -- 出票人开户行
            ,isbas -- 是否可转让
            ,duedate -- 到期日
            ,payee -- 收款人户名
            ,purchaserpercent -- 买方付息比例(贴现方式为协议付息才有效)
            ,updatedate -- 更新日期
            ,draweracctname -- 贴现客户账户开户行号
            ,acptdate -- 出票日
            ,drawercustomer -- 开票人户名
            ,manualpay -- 工本费
            ,othertxbalance -- 第三方付息金额
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,currency -- 币种
            ,guaracctno -- 保证金账户
            ,paysum -- 手续费
            ,czflag -- 冲账标志
            ,inputdate -- 录入时间
            ,buybenddate -- 约定赎回日
            ,acceptorbankname -- 承兑人开户行名称
            ,afeerate -- 贴现利率
            ,customername -- 客户名称
            ,guarterm -- 保证金存期
            ,otherdraweracctno -- 第三方付息账户
            ,isonline -- 是否线上清算
            ,inputorgid -- 录入机构
            ,buyenddate -- 赎回截止日
            ,putoutorgid -- 放款机构编号
            ,draweracctbankname -- 贴现客户账户开户行名
            ,updateuserid -- 更新人
            ,payeeacctname -- 收款人开户行
            ,guarsum -- 保证金金额
            ,businesstype -- 交易类型
            ,draweracctno1 -- 出票人账号
            ,inputuserid -- 录入人
            ,customerid -- 客户号
            ,discountway -- 贴现方式
            ,billclass -- 票据性质
            ,acptdate2 -- 承兑日
            ,interestday -- 计息天数
            ,isbecustody -- 是否代保管
            ,acceptorbankno -- 承兑人开户行号
            ,discounttype -- 贴现类型
            ,buybegindate -- 赎回开放日
            ,buyrate -- 赎回利率
            ,payeeacctno -- 收款人帐号
            ,changeday -- 调整天数
            ,billtype -- 票据类型
            ,billno -- 票据号码
            ,billdiscounttype -- 是否跨行贴现标识（1是2否）
            ,custbillacctname -- 客户结算账户户名
            ,draweracctno -- 贴现客户账户
            ,billsum -- 贴现票据金额
            ,paveeacctbankno -- 收款人行号
            ,acceptor -- 承兑人名称
            ,updateorgid -- 更新机构
            ,sectionno -- 区间号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.batchno -- 批次号
    ,o.contractno -- 协议编号
    ,o.keyno -- 单笔票据唯一标示
    ,o.discountsum -- 贴现利息
    ,o.discountdate -- 贴现日期
    ,o.draweracct1name -- 出票人开户行
    ,o.isbas -- 是否可转让
    ,o.duedate -- 到期日
    ,o.payee -- 收款人户名
    ,o.purchaserpercent -- 买方付息比例(贴现方式为协议付息才有效)
    ,o.updatedate -- 更新日期
    ,o.draweracctname -- 贴现客户账户开户行号
    ,o.acptdate -- 出票日
    ,o.drawercustomer -- 开票人户名
    ,o.manualpay -- 工本费
    ,o.othertxbalance -- 第三方付息金额
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.currency -- 币种
    ,o.guaracctno -- 保证金账户
    ,o.paysum -- 手续费
    ,o.czflag -- 冲账标志
    ,o.inputdate -- 录入时间
    ,o.buybenddate -- 约定赎回日
    ,o.acceptorbankname -- 承兑人开户行名称
    ,o.afeerate -- 贴现利率
    ,o.customername -- 客户名称
    ,o.guarterm -- 保证金存期
    ,o.otherdraweracctno -- 第三方付息账户
    ,o.isonline -- 是否线上清算
    ,o.inputorgid -- 录入机构
    ,o.buyenddate -- 赎回截止日
    ,o.putoutorgid -- 放款机构编号
    ,o.draweracctbankname -- 贴现客户账户开户行名
    ,o.updateuserid -- 更新人
    ,o.payeeacctname -- 收款人开户行
    ,o.guarsum -- 保证金金额
    ,o.businesstype -- 交易类型
    ,o.draweracctno1 -- 出票人账号
    ,o.inputuserid -- 录入人
    ,o.customerid -- 客户号
    ,o.discountway -- 贴现方式
    ,o.billclass -- 票据性质
    ,o.acptdate2 -- 承兑日
    ,o.interestday -- 计息天数
    ,o.isbecustody -- 是否代保管
    ,o.acceptorbankno -- 承兑人开户行号
    ,o.discounttype -- 贴现类型
    ,o.buybegindate -- 赎回开放日
    ,o.buyrate -- 赎回利率
    ,o.payeeacctno -- 收款人帐号
    ,o.changeday -- 调整天数
    ,o.billtype -- 票据类型
    ,o.billno -- 票据号码
    ,o.billdiscounttype -- 是否跨行贴现标识（1是2否）
    ,o.custbillacctname -- 客户结算账户户名
    ,o.draweracctno -- 贴现客户账户
    ,o.billsum -- 贴现票据金额
    ,o.paveeacctbankno -- 收款人行号
    ,o.acceptor -- 承兑人名称
    ,o.updateorgid -- 更新机构
    ,o.sectionno -- 区间号
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
from ${iol_schema}.icms_billlist_info_bk o
    left join ${iol_schema}.icms_billlist_info_op n
        on
            o.batchno = n.batchno
            and o.contractno = n.contractno
            and o.keyno = n.keyno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_billlist_info_cl d
        on
            o.batchno = d.batchno
            and o.contractno = d.contractno
            and o.keyno = d.keyno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_billlist_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_billlist_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_billlist_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_billlist_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_billlist_info exchange partition p_${batch_date} with table ${iol_schema}.icms_billlist_info_cl;
alter table ${iol_schema}.icms_billlist_info exchange partition p_20991231 with table ${iol_schema}.icms_billlist_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_billlist_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_billlist_info_op purge;
drop table ${iol_schema}.icms_billlist_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_billlist_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_billlist_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
