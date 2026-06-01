/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ba_upl_loan
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
create table ${iol_schema}.icms_ba_upl_loan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ba_upl_loan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ba_upl_loan_op purge;
drop table ${iol_schema}.icms_ba_upl_loan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ba_upl_loan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ba_upl_loan where 0=1;

create table ${iol_schema}.icms_ba_upl_loan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ba_upl_loan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ba_upl_loan_cl(
            serialno -- 授信流水号
            ,trustaccname -- 提前还款申请人
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,abstract -- 备注摘要
            ,price1 -- 均价
            ,guarinten -- 担保意向
            ,amount2 -- 面积
            ,keyinfoflag -- 关键信息检验标志
            ,feepayment -- 手续费支付方式
            ,paybankno -- 收款人行号
            ,purpose -- 用途
            ,payaccountname2 -- 第二还款账户名
            ,payaccountno2 -- 第二还款账户
            ,houseadd1 -- 房产证地址详细地址
            ,warrantorid -- 主要担保人代码
            ,isguaranty1 -- 是否抵押
            ,loanintsettlemethod -- 贷款结息方式
            ,incomeorgid -- 入账机构编号
            ,usedsum -- 已占用额度
            ,paybankaddcode -- 收款人开户行地点
            ,warrantor -- 主要担保人
            ,havecount2 -- 借款人产权份额
            ,paymenttype -- 支付方式
            ,preapproverid -- 面签人姓名编号
            ,trustpayaccountname -- 受托支付户名
            ,houseareacode2 -- 房产证地址区划代码
            ,housetype2 -- 房屋性质(住房、商住两用房、写字楼)
            ,holdcorpus -- 保留本金
            ,usedbailsum -- 已占用保证金金额
            ,feesum -- 手续费金额
            ,oldlcsum -- 原信用证金额
            ,schemeno -- 贷款方案编码
            ,qualitycontrolflag -- 质量控制标志
            ,houseadd2 -- 房产证地址详细地址
            ,orginalbusinessum -- 原贷款金额
            ,price2 -- 均价
            ,reservatestatus -- 预约状态
            ,loankind -- 期限类型
            ,paybankkindcode -- 收款人开户行类别
            ,loandeductmethod -- 贷款扣款方式
            ,subbusinesstype -- 助贷默认业务品种
            ,changetypeflag -- 是否变更业务品种
            ,amount1 -- 面积
            ,iskyd -- 是否快易贷
            ,loantradesum -- 贷款用途交易金额
            ,approvesum -- 最新审批金额
            ,isguaranty2 -- 是否抵押
            ,paysource -- 还款说明
            ,approvelevel -- 审批级别
            ,creditaggreement -- 使用授信协议号
            ,trustpayaccountno -- 受托支付账号
            ,iscompulsapproval -- 是否强制人工审批
            ,paybankname -- 收款人行名
            ,houseareacode1 -- 房产证地址区划代码
            ,housetype1 -- 房屋性质(住房、商住两用房、写字楼)
            ,havecount1 -- 借款人产权份额
            ,housenmber2 -- 房产证号
            ,salechannelid -- 渠道单位编码
            ,barcodeno -- 资料扫描编码
            ,ifdkqy -- 是否发起代扣管理费签约
            ,corpguarserialno -- 担保公司流水号
            ,batchpaymentflag -- 是否参与批扣
            ,persons1 -- 共有产权人数
            ,persons2 -- 共有产权人数
            ,housenmber1 -- 房产证号
            ,feeratio -- 个贷手续费率(%)
            ,promisesfeeratio -- 承诺费率
            ,mfeesum -- 管理费金额
            ,signedplace -- 签约地点
            ,guarusedsum -- 担保公司已占用额度
            ,saleteamid -- 营销单位编码
            ,introducerid -- 介绍人编号
            ,saleteamname -- 营销单位名称
            ,salechannelname -- 营销渠道名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ba_upl_loan_op(
            serialno -- 授信流水号
            ,trustaccname -- 提前还款申请人
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,abstract -- 备注摘要
            ,price1 -- 均价
            ,guarinten -- 担保意向
            ,amount2 -- 面积
            ,keyinfoflag -- 关键信息检验标志
            ,feepayment -- 手续费支付方式
            ,paybankno -- 收款人行号
            ,purpose -- 用途
            ,payaccountname2 -- 第二还款账户名
            ,payaccountno2 -- 第二还款账户
            ,houseadd1 -- 房产证地址详细地址
            ,warrantorid -- 主要担保人代码
            ,isguaranty1 -- 是否抵押
            ,loanintsettlemethod -- 贷款结息方式
            ,incomeorgid -- 入账机构编号
            ,usedsum -- 已占用额度
            ,paybankaddcode -- 收款人开户行地点
            ,warrantor -- 主要担保人
            ,havecount2 -- 借款人产权份额
            ,paymenttype -- 支付方式
            ,preapproverid -- 面签人姓名编号
            ,trustpayaccountname -- 受托支付户名
            ,houseareacode2 -- 房产证地址区划代码
            ,housetype2 -- 房屋性质(住房、商住两用房、写字楼)
            ,holdcorpus -- 保留本金
            ,usedbailsum -- 已占用保证金金额
            ,feesum -- 手续费金额
            ,oldlcsum -- 原信用证金额
            ,schemeno -- 贷款方案编码
            ,qualitycontrolflag -- 质量控制标志
            ,houseadd2 -- 房产证地址详细地址
            ,orginalbusinessum -- 原贷款金额
            ,price2 -- 均价
            ,reservatestatus -- 预约状态
            ,loankind -- 期限类型
            ,paybankkindcode -- 收款人开户行类别
            ,loandeductmethod -- 贷款扣款方式
            ,subbusinesstype -- 助贷默认业务品种
            ,changetypeflag -- 是否变更业务品种
            ,amount1 -- 面积
            ,iskyd -- 是否快易贷
            ,loantradesum -- 贷款用途交易金额
            ,approvesum -- 最新审批金额
            ,isguaranty2 -- 是否抵押
            ,paysource -- 还款说明
            ,approvelevel -- 审批级别
            ,creditaggreement -- 使用授信协议号
            ,trustpayaccountno -- 受托支付账号
            ,iscompulsapproval -- 是否强制人工审批
            ,paybankname -- 收款人行名
            ,houseareacode1 -- 房产证地址区划代码
            ,housetype1 -- 房屋性质(住房、商住两用房、写字楼)
            ,havecount1 -- 借款人产权份额
            ,housenmber2 -- 房产证号
            ,salechannelid -- 渠道单位编码
            ,barcodeno -- 资料扫描编码
            ,ifdkqy -- 是否发起代扣管理费签约
            ,corpguarserialno -- 担保公司流水号
            ,batchpaymentflag -- 是否参与批扣
            ,persons1 -- 共有产权人数
            ,persons2 -- 共有产权人数
            ,housenmber1 -- 房产证号
            ,feeratio -- 个贷手续费率(%)
            ,promisesfeeratio -- 承诺费率
            ,mfeesum -- 管理费金额
            ,signedplace -- 签约地点
            ,guarusedsum -- 担保公司已占用额度
            ,saleteamid -- 营销单位编码
            ,introducerid -- 介绍人编号
            ,saleteamname -- 营销单位名称
            ,salechannelname -- 营销渠道名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 授信流水号
    ,nvl(n.trustaccname, o.trustaccname) as trustaccname -- 提前还款申请人
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.abstract, o.abstract) as abstract -- 备注摘要
    ,nvl(n.price1, o.price1) as price1 -- 均价
    ,nvl(n.guarinten, o.guarinten) as guarinten -- 担保意向
    ,nvl(n.amount2, o.amount2) as amount2 -- 面积
    ,nvl(n.keyinfoflag, o.keyinfoflag) as keyinfoflag -- 关键信息检验标志
    ,nvl(n.feepayment, o.feepayment) as feepayment -- 手续费支付方式
    ,nvl(n.paybankno, o.paybankno) as paybankno -- 收款人行号
    ,nvl(n.purpose, o.purpose) as purpose -- 用途
    ,nvl(n.payaccountname2, o.payaccountname2) as payaccountname2 -- 第二还款账户名
    ,nvl(n.payaccountno2, o.payaccountno2) as payaccountno2 -- 第二还款账户
    ,nvl(n.houseadd1, o.houseadd1) as houseadd1 -- 房产证地址详细地址
    ,nvl(n.warrantorid, o.warrantorid) as warrantorid -- 主要担保人代码
    ,nvl(n.isguaranty1, o.isguaranty1) as isguaranty1 -- 是否抵押
    ,nvl(n.loanintsettlemethod, o.loanintsettlemethod) as loanintsettlemethod -- 贷款结息方式
    ,nvl(n.incomeorgid, o.incomeorgid) as incomeorgid -- 入账机构编号
    ,nvl(n.usedsum, o.usedsum) as usedsum -- 已占用额度
    ,nvl(n.paybankaddcode, o.paybankaddcode) as paybankaddcode -- 收款人开户行地点
    ,nvl(n.warrantor, o.warrantor) as warrantor -- 主要担保人
    ,nvl(n.havecount2, o.havecount2) as havecount2 -- 借款人产权份额
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 支付方式
    ,nvl(n.preapproverid, o.preapproverid) as preapproverid -- 面签人姓名编号
    ,nvl(n.trustpayaccountname, o.trustpayaccountname) as trustpayaccountname -- 受托支付户名
    ,nvl(n.houseareacode2, o.houseareacode2) as houseareacode2 -- 房产证地址区划代码
    ,nvl(n.housetype2, o.housetype2) as housetype2 -- 房屋性质(住房、商住两用房、写字楼)
    ,nvl(n.holdcorpus, o.holdcorpus) as holdcorpus -- 保留本金
    ,nvl(n.usedbailsum, o.usedbailsum) as usedbailsum -- 已占用保证金金额
    ,nvl(n.feesum, o.feesum) as feesum -- 手续费金额
    ,nvl(n.oldlcsum, o.oldlcsum) as oldlcsum -- 原信用证金额
    ,nvl(n.schemeno, o.schemeno) as schemeno -- 贷款方案编码
    ,nvl(n.qualitycontrolflag, o.qualitycontrolflag) as qualitycontrolflag -- 质量控制标志
    ,nvl(n.houseadd2, o.houseadd2) as houseadd2 -- 房产证地址详细地址
    ,nvl(n.orginalbusinessum, o.orginalbusinessum) as orginalbusinessum -- 原贷款金额
    ,nvl(n.price2, o.price2) as price2 -- 均价
    ,nvl(n.reservatestatus, o.reservatestatus) as reservatestatus -- 预约状态
    ,nvl(n.loankind, o.loankind) as loankind -- 期限类型
    ,nvl(n.paybankkindcode, o.paybankkindcode) as paybankkindcode -- 收款人开户行类别
    ,nvl(n.loandeductmethod, o.loandeductmethod) as loandeductmethod -- 贷款扣款方式
    ,nvl(n.subbusinesstype, o.subbusinesstype) as subbusinesstype -- 助贷默认业务品种
    ,nvl(n.changetypeflag, o.changetypeflag) as changetypeflag -- 是否变更业务品种
    ,nvl(n.amount1, o.amount1) as amount1 -- 面积
    ,nvl(n.iskyd, o.iskyd) as iskyd -- 是否快易贷
    ,nvl(n.loantradesum, o.loantradesum) as loantradesum -- 贷款用途交易金额
    ,nvl(n.approvesum, o.approvesum) as approvesum -- 最新审批金额
    ,nvl(n.isguaranty2, o.isguaranty2) as isguaranty2 -- 是否抵押
    ,nvl(n.paysource, o.paysource) as paysource -- 还款说明
    ,nvl(n.approvelevel, o.approvelevel) as approvelevel -- 审批级别
    ,nvl(n.creditaggreement, o.creditaggreement) as creditaggreement -- 使用授信协议号
    ,nvl(n.trustpayaccountno, o.trustpayaccountno) as trustpayaccountno -- 受托支付账号
    ,nvl(n.iscompulsapproval, o.iscompulsapproval) as iscompulsapproval -- 是否强制人工审批
    ,nvl(n.paybankname, o.paybankname) as paybankname -- 收款人行名
    ,nvl(n.houseareacode1, o.houseareacode1) as houseareacode1 -- 房产证地址区划代码
    ,nvl(n.housetype1, o.housetype1) as housetype1 -- 房屋性质(住房、商住两用房、写字楼)
    ,nvl(n.havecount1, o.havecount1) as havecount1 -- 借款人产权份额
    ,nvl(n.housenmber2, o.housenmber2) as housenmber2 -- 房产证号
    ,nvl(n.salechannelid, o.salechannelid) as salechannelid -- 渠道单位编码
    ,nvl(n.barcodeno, o.barcodeno) as barcodeno -- 资料扫描编码
    ,nvl(n.ifdkqy, o.ifdkqy) as ifdkqy -- 是否发起代扣管理费签约
    ,nvl(n.corpguarserialno, o.corpguarserialno) as corpguarserialno -- 担保公司流水号
    ,nvl(n.batchpaymentflag, o.batchpaymentflag) as batchpaymentflag -- 是否参与批扣
    ,nvl(n.persons1, o.persons1) as persons1 -- 共有产权人数
    ,nvl(n.persons2, o.persons2) as persons2 -- 共有产权人数
    ,nvl(n.housenmber1, o.housenmber1) as housenmber1 -- 房产证号
    ,nvl(n.feeratio, o.feeratio) as feeratio -- 个贷手续费率(%)
    ,nvl(n.promisesfeeratio, o.promisesfeeratio) as promisesfeeratio -- 承诺费率
    ,nvl(n.mfeesum, o.mfeesum) as mfeesum -- 管理费金额
    ,nvl(n.signedplace, o.signedplace) as signedplace -- 签约地点
    ,nvl(n.guarusedsum, o.guarusedsum) as guarusedsum -- 担保公司已占用额度
    ,nvl(n.saleteamid, o.saleteamid) as saleteamid -- 营销单位编码
    ,nvl(n.introducerid, o.introducerid) as introducerid -- 介绍人编号
    ,nvl(n.saleteamname, o.saleteamname) as saleteamname -- 营销单位名称
    ,nvl(n.salechannelname, o.salechannelname) as salechannelname -- 营销渠道名称
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ba_upl_loan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ba_upl_loan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.trustaccname <> n.trustaccname
        or o.migtflag <> n.migtflag
        or o.abstract <> n.abstract
        or o.price1 <> n.price1
        or o.guarinten <> n.guarinten
        or o.amount2 <> n.amount2
        or o.keyinfoflag <> n.keyinfoflag
        or o.feepayment <> n.feepayment
        or o.paybankno <> n.paybankno
        or o.purpose <> n.purpose
        or o.payaccountname2 <> n.payaccountname2
        or o.payaccountno2 <> n.payaccountno2
        or o.houseadd1 <> n.houseadd1
        or o.warrantorid <> n.warrantorid
        or o.isguaranty1 <> n.isguaranty1
        or o.loanintsettlemethod <> n.loanintsettlemethod
        or o.incomeorgid <> n.incomeorgid
        or o.usedsum <> n.usedsum
        or o.paybankaddcode <> n.paybankaddcode
        or o.warrantor <> n.warrantor
        or o.havecount2 <> n.havecount2
        or o.paymenttype <> n.paymenttype
        or o.preapproverid <> n.preapproverid
        or o.trustpayaccountname <> n.trustpayaccountname
        or o.houseareacode2 <> n.houseareacode2
        or o.housetype2 <> n.housetype2
        or o.holdcorpus <> n.holdcorpus
        or o.usedbailsum <> n.usedbailsum
        or o.feesum <> n.feesum
        or o.oldlcsum <> n.oldlcsum
        or o.schemeno <> n.schemeno
        or o.qualitycontrolflag <> n.qualitycontrolflag
        or o.houseadd2 <> n.houseadd2
        or o.orginalbusinessum <> n.orginalbusinessum
        or o.price2 <> n.price2
        or o.reservatestatus <> n.reservatestatus
        or o.loankind <> n.loankind
        or o.paybankkindcode <> n.paybankkindcode
        or o.loandeductmethod <> n.loandeductmethod
        or o.subbusinesstype <> n.subbusinesstype
        or o.changetypeflag <> n.changetypeflag
        or o.amount1 <> n.amount1
        or o.iskyd <> n.iskyd
        or o.loantradesum <> n.loantradesum
        or o.approvesum <> n.approvesum
        or o.isguaranty2 <> n.isguaranty2
        or o.paysource <> n.paysource
        or o.approvelevel <> n.approvelevel
        or o.creditaggreement <> n.creditaggreement
        or o.trustpayaccountno <> n.trustpayaccountno
        or o.iscompulsapproval <> n.iscompulsapproval
        or o.paybankname <> n.paybankname
        or o.houseareacode1 <> n.houseareacode1
        or o.housetype1 <> n.housetype1
        or o.havecount1 <> n.havecount1
        or o.housenmber2 <> n.housenmber2
        or o.salechannelid <> n.salechannelid
        or o.barcodeno <> n.barcodeno
        or o.ifdkqy <> n.ifdkqy
        or o.corpguarserialno <> n.corpguarserialno
        or o.batchpaymentflag <> n.batchpaymentflag
        or o.persons1 <> n.persons1
        or o.persons2 <> n.persons2
        or o.housenmber1 <> n.housenmber1
        or o.feeratio <> n.feeratio
        or o.promisesfeeratio <> n.promisesfeeratio
        or o.mfeesum <> n.mfeesum
        or o.signedplace <> n.signedplace
        or o.guarusedsum <> n.guarusedsum
        or o.saleteamid <> n.saleteamid
        or o.introducerid <> n.introducerid
        or o.saleteamname <> n.saleteamname
        or o.salechannelname <> n.salechannelname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ba_upl_loan_cl(
            serialno -- 授信流水号
            ,trustaccname -- 提前还款申请人
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,abstract -- 备注摘要
            ,price1 -- 均价
            ,guarinten -- 担保意向
            ,amount2 -- 面积
            ,keyinfoflag -- 关键信息检验标志
            ,feepayment -- 手续费支付方式
            ,paybankno -- 收款人行号
            ,purpose -- 用途
            ,payaccountname2 -- 第二还款账户名
            ,payaccountno2 -- 第二还款账户
            ,houseadd1 -- 房产证地址详细地址
            ,warrantorid -- 主要担保人代码
            ,isguaranty1 -- 是否抵押
            ,loanintsettlemethod -- 贷款结息方式
            ,incomeorgid -- 入账机构编号
            ,usedsum -- 已占用额度
            ,paybankaddcode -- 收款人开户行地点
            ,warrantor -- 主要担保人
            ,havecount2 -- 借款人产权份额
            ,paymenttype -- 支付方式
            ,preapproverid -- 面签人姓名编号
            ,trustpayaccountname -- 受托支付户名
            ,houseareacode2 -- 房产证地址区划代码
            ,housetype2 -- 房屋性质(住房、商住两用房、写字楼)
            ,holdcorpus -- 保留本金
            ,usedbailsum -- 已占用保证金金额
            ,feesum -- 手续费金额
            ,oldlcsum -- 原信用证金额
            ,schemeno -- 贷款方案编码
            ,qualitycontrolflag -- 质量控制标志
            ,houseadd2 -- 房产证地址详细地址
            ,orginalbusinessum -- 原贷款金额
            ,price2 -- 均价
            ,reservatestatus -- 预约状态
            ,loankind -- 期限类型
            ,paybankkindcode -- 收款人开户行类别
            ,loandeductmethod -- 贷款扣款方式
            ,subbusinesstype -- 助贷默认业务品种
            ,changetypeflag -- 是否变更业务品种
            ,amount1 -- 面积
            ,iskyd -- 是否快易贷
            ,loantradesum -- 贷款用途交易金额
            ,approvesum -- 最新审批金额
            ,isguaranty2 -- 是否抵押
            ,paysource -- 还款说明
            ,approvelevel -- 审批级别
            ,creditaggreement -- 使用授信协议号
            ,trustpayaccountno -- 受托支付账号
            ,iscompulsapproval -- 是否强制人工审批
            ,paybankname -- 收款人行名
            ,houseareacode1 -- 房产证地址区划代码
            ,housetype1 -- 房屋性质(住房、商住两用房、写字楼)
            ,havecount1 -- 借款人产权份额
            ,housenmber2 -- 房产证号
            ,salechannelid -- 渠道单位编码
            ,barcodeno -- 资料扫描编码
            ,ifdkqy -- 是否发起代扣管理费签约
            ,corpguarserialno -- 担保公司流水号
            ,batchpaymentflag -- 是否参与批扣
            ,persons1 -- 共有产权人数
            ,persons2 -- 共有产权人数
            ,housenmber1 -- 房产证号
            ,feeratio -- 个贷手续费率(%)
            ,promisesfeeratio -- 承诺费率
            ,mfeesum -- 管理费金额
            ,signedplace -- 签约地点
            ,guarusedsum -- 担保公司已占用额度
            ,saleteamid -- 营销单位编码
            ,introducerid -- 介绍人编号
            ,saleteamname -- 营销单位名称
            ,salechannelname -- 营销渠道名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ba_upl_loan_op(
            serialno -- 授信流水号
            ,trustaccname -- 提前还款申请人
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,abstract -- 备注摘要
            ,price1 -- 均价
            ,guarinten -- 担保意向
            ,amount2 -- 面积
            ,keyinfoflag -- 关键信息检验标志
            ,feepayment -- 手续费支付方式
            ,paybankno -- 收款人行号
            ,purpose -- 用途
            ,payaccountname2 -- 第二还款账户名
            ,payaccountno2 -- 第二还款账户
            ,houseadd1 -- 房产证地址详细地址
            ,warrantorid -- 主要担保人代码
            ,isguaranty1 -- 是否抵押
            ,loanintsettlemethod -- 贷款结息方式
            ,incomeorgid -- 入账机构编号
            ,usedsum -- 已占用额度
            ,paybankaddcode -- 收款人开户行地点
            ,warrantor -- 主要担保人
            ,havecount2 -- 借款人产权份额
            ,paymenttype -- 支付方式
            ,preapproverid -- 面签人姓名编号
            ,trustpayaccountname -- 受托支付户名
            ,houseareacode2 -- 房产证地址区划代码
            ,housetype2 -- 房屋性质(住房、商住两用房、写字楼)
            ,holdcorpus -- 保留本金
            ,usedbailsum -- 已占用保证金金额
            ,feesum -- 手续费金额
            ,oldlcsum -- 原信用证金额
            ,schemeno -- 贷款方案编码
            ,qualitycontrolflag -- 质量控制标志
            ,houseadd2 -- 房产证地址详细地址
            ,orginalbusinessum -- 原贷款金额
            ,price2 -- 均价
            ,reservatestatus -- 预约状态
            ,loankind -- 期限类型
            ,paybankkindcode -- 收款人开户行类别
            ,loandeductmethod -- 贷款扣款方式
            ,subbusinesstype -- 助贷默认业务品种
            ,changetypeflag -- 是否变更业务品种
            ,amount1 -- 面积
            ,iskyd -- 是否快易贷
            ,loantradesum -- 贷款用途交易金额
            ,approvesum -- 最新审批金额
            ,isguaranty2 -- 是否抵押
            ,paysource -- 还款说明
            ,approvelevel -- 审批级别
            ,creditaggreement -- 使用授信协议号
            ,trustpayaccountno -- 受托支付账号
            ,iscompulsapproval -- 是否强制人工审批
            ,paybankname -- 收款人行名
            ,houseareacode1 -- 房产证地址区划代码
            ,housetype1 -- 房屋性质(住房、商住两用房、写字楼)
            ,havecount1 -- 借款人产权份额
            ,housenmber2 -- 房产证号
            ,salechannelid -- 渠道单位编码
            ,barcodeno -- 资料扫描编码
            ,ifdkqy -- 是否发起代扣管理费签约
            ,corpguarserialno -- 担保公司流水号
            ,batchpaymentflag -- 是否参与批扣
            ,persons1 -- 共有产权人数
            ,persons2 -- 共有产权人数
            ,housenmber1 -- 房产证号
            ,feeratio -- 个贷手续费率(%)
            ,promisesfeeratio -- 承诺费率
            ,mfeesum -- 管理费金额
            ,signedplace -- 签约地点
            ,guarusedsum -- 担保公司已占用额度
            ,saleteamid -- 营销单位编码
            ,introducerid -- 介绍人编号
            ,saleteamname -- 营销单位名称
            ,salechannelname -- 营销渠道名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 授信流水号
    ,o.trustaccname -- 提前还款申请人
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.abstract -- 备注摘要
    ,o.price1 -- 均价
    ,o.guarinten -- 担保意向
    ,o.amount2 -- 面积
    ,o.keyinfoflag -- 关键信息检验标志
    ,o.feepayment -- 手续费支付方式
    ,o.paybankno -- 收款人行号
    ,o.purpose -- 用途
    ,o.payaccountname2 -- 第二还款账户名
    ,o.payaccountno2 -- 第二还款账户
    ,o.houseadd1 -- 房产证地址详细地址
    ,o.warrantorid -- 主要担保人代码
    ,o.isguaranty1 -- 是否抵押
    ,o.loanintsettlemethod -- 贷款结息方式
    ,o.incomeorgid -- 入账机构编号
    ,o.usedsum -- 已占用额度
    ,o.paybankaddcode -- 收款人开户行地点
    ,o.warrantor -- 主要担保人
    ,o.havecount2 -- 借款人产权份额
    ,o.paymenttype -- 支付方式
    ,o.preapproverid -- 面签人姓名编号
    ,o.trustpayaccountname -- 受托支付户名
    ,o.houseareacode2 -- 房产证地址区划代码
    ,o.housetype2 -- 房屋性质(住房、商住两用房、写字楼)
    ,o.holdcorpus -- 保留本金
    ,o.usedbailsum -- 已占用保证金金额
    ,o.feesum -- 手续费金额
    ,o.oldlcsum -- 原信用证金额
    ,o.schemeno -- 贷款方案编码
    ,o.qualitycontrolflag -- 质量控制标志
    ,o.houseadd2 -- 房产证地址详细地址
    ,o.orginalbusinessum -- 原贷款金额
    ,o.price2 -- 均价
    ,o.reservatestatus -- 预约状态
    ,o.loankind -- 期限类型
    ,o.paybankkindcode -- 收款人开户行类别
    ,o.loandeductmethod -- 贷款扣款方式
    ,o.subbusinesstype -- 助贷默认业务品种
    ,o.changetypeflag -- 是否变更业务品种
    ,o.amount1 -- 面积
    ,o.iskyd -- 是否快易贷
    ,o.loantradesum -- 贷款用途交易金额
    ,o.approvesum -- 最新审批金额
    ,o.isguaranty2 -- 是否抵押
    ,o.paysource -- 还款说明
    ,o.approvelevel -- 审批级别
    ,o.creditaggreement -- 使用授信协议号
    ,o.trustpayaccountno -- 受托支付账号
    ,o.iscompulsapproval -- 是否强制人工审批
    ,o.paybankname -- 收款人行名
    ,o.houseareacode1 -- 房产证地址区划代码
    ,o.housetype1 -- 房屋性质(住房、商住两用房、写字楼)
    ,o.havecount1 -- 借款人产权份额
    ,o.housenmber2 -- 房产证号
    ,o.salechannelid -- 渠道单位编码
    ,o.barcodeno -- 资料扫描编码
    ,o.ifdkqy -- 是否发起代扣管理费签约
    ,o.corpguarserialno -- 担保公司流水号
    ,o.batchpaymentflag -- 是否参与批扣
    ,o.persons1 -- 共有产权人数
    ,o.persons2 -- 共有产权人数
    ,o.housenmber1 -- 房产证号
    ,o.feeratio -- 个贷手续费率(%)
    ,o.promisesfeeratio -- 承诺费率
    ,o.mfeesum -- 管理费金额
    ,o.signedplace -- 签约地点
    ,o.guarusedsum -- 担保公司已占用额度
    ,o.saleteamid -- 营销单位编码
    ,o.introducerid -- 介绍人编号
    ,o.saleteamname -- 营销单位名称
    ,o.salechannelname -- 营销渠道名称
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
from ${iol_schema}.icms_ba_upl_loan_bk o
    left join ${iol_schema}.icms_ba_upl_loan_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ba_upl_loan_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ba_upl_loan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ba_upl_loan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ba_upl_loan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ba_upl_loan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ba_upl_loan exchange partition p_${batch_date} with table ${iol_schema}.icms_ba_upl_loan_cl;
alter table ${iol_schema}.icms_ba_upl_loan exchange partition p_20991231 with table ${iol_schema}.icms_ba_upl_loan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ba_upl_loan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ba_upl_loan_op purge;
drop table ${iol_schema}.icms_ba_upl_loan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ba_upl_loan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ba_upl_loan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
