/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bp_personal_loan
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
create table ${iol_schema}.icms_bp_personal_loan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_bp_personal_loan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bp_personal_loan_op purge;
drop table ${iol_schema}.icms_bp_personal_loan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bp_personal_loan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bp_personal_loan where 0=1;

create table ${iol_schema}.icms_bp_personal_loan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bp_personal_loan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bp_personal_loan_cl(
            serialno -- 出账流水号
            ,isnogroup -- 是否集团客户
            ,groupcustname -- 集团客户名称
            ,relationship -- 借款人与集团关系
            ,payee_bank_name -- 收款人行名
            ,loanfinishdate -- 贷款终止日
            ,putouttime -- 放款时间
            ,payorderid -- 支付订单号
            ,isrecordtax -- 是否录入印花税
            ,payaccounttel -- 开户绑定手机号
            ,loanbegindate -- 贷款发放日
            ,payacctno -- 受托支付账号编号
            ,channelcode -- 放款渠道码
            ,remark -- 备注
            ,loanstage -- 贷款期数
            ,loantruedate -- 贷款实际发放日
            ,guacontno -- 担保保证函编号
            ,taxaccount -- 印花税扣税账号
            ,repaydatetype -- 还款日确定
            ,imageno -- 影像编号
            ,approveenddate -- 放款结束时间
            ,taxaccountname -- 印花税扣税账号名称
            ,putoutconditionremark -- 出账落实条件说明
            ,groupcustcode -- 集团客户号
            ,informflag -- 放款通知是否成功
            ,approvestartdate -- 审批开始时间
            ,availexposure -- 集团客户可用敞口额度
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,applysum -- 申请放款金额
            ,taxamount -- 印花税金额
            ,imageupflag -- 影像上传结果1完成上传2未完成上传
            ,paymentmethodtype -- 支付工具类型
            ,confirmstate -- 受托支付确认状态
            ,confirmtime -- 受托支付确认时间
            ,checkresult -- 风控规则结果
            ,payaccounttype -- 卡类型0:本行卡1:他行卡
            ,repaymentmethodtype -- 还款支付工具类型
            ,cashsum -- 自主支付金额
            ,exchangeresultremark -- 交易结果描述
            ,balldate -- 气球贷摊销日期
            ,relaserialno -- 关联流水号
            ,isbelongterm -- 是否靠档计息
            ,productchannel -- 产品渠道标识
            ,moneylevelresult -- 命中反洗钱评级情况（0-未命中,1-命中,2-仅命中）
            ,isicmsfactory -- 信贷工厂模式（01-是,02-否,03-无）
            ,recoverflag -- 实时追缴标志字段：N否，Y是
            ,repayacctwthrobankcard -- 还款账户是否他行卡：N否，Y是
            ,postacctwthrobankcard -- 入账账户是否他行卡：N否，Y是
            ,hangseqno -- 挂账序列号
            ,settleprodtype -- 入账账户产品类型
            ,loanprodtype -- 还款账户产品类型
            ,nextcycledate -- 下一结息日
            ,finalmerger -- 末期合并
            ,prerepaydeal -- 还款计划变更方式
            ,invstflg -- 尽调标志（N否，Y是，是否尽调为否的时候则为互联网业务）
            ,offlchkidenflg -- 线下核身标志（N否，Y是）
            ,iscentralizedaccount -- 是否集中出账（好企贷IPC产品）
            ,priceorderno -- 定价单号
            ,priceapprovestatus -- 定价单审批状态
            ,priceenddate -- 定价单生效截止日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bp_personal_loan_op(
            serialno -- 出账流水号
            ,isnogroup -- 是否集团客户
            ,groupcustname -- 集团客户名称
            ,relationship -- 借款人与集团关系
            ,payee_bank_name -- 收款人行名
            ,loanfinishdate -- 贷款终止日
            ,putouttime -- 放款时间
            ,payorderid -- 支付订单号
            ,isrecordtax -- 是否录入印花税
            ,payaccounttel -- 开户绑定手机号
            ,loanbegindate -- 贷款发放日
            ,payacctno -- 受托支付账号编号
            ,channelcode -- 放款渠道码
            ,remark -- 备注
            ,loanstage -- 贷款期数
            ,loantruedate -- 贷款实际发放日
            ,guacontno -- 担保保证函编号
            ,taxaccount -- 印花税扣税账号
            ,repaydatetype -- 还款日确定
            ,imageno -- 影像编号
            ,approveenddate -- 放款结束时间
            ,taxaccountname -- 印花税扣税账号名称
            ,putoutconditionremark -- 出账落实条件说明
            ,groupcustcode -- 集团客户号
            ,informflag -- 放款通知是否成功
            ,approvestartdate -- 审批开始时间
            ,availexposure -- 集团客户可用敞口额度
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,applysum -- 申请放款金额
            ,taxamount -- 印花税金额
            ,imageupflag -- 影像上传结果1完成上传2未完成上传
            ,paymentmethodtype -- 支付工具类型
            ,confirmstate -- 受托支付确认状态
            ,confirmtime -- 受托支付确认时间
            ,checkresult -- 风控规则结果
            ,payaccounttype -- 卡类型0:本行卡1:他行卡
            ,repaymentmethodtype -- 还款支付工具类型
            ,cashsum -- 自主支付金额
            ,exchangeresultremark -- 交易结果描述
            ,balldate -- 气球贷摊销日期
            ,relaserialno -- 关联流水号
            ,isbelongterm -- 是否靠档计息
            ,productchannel -- 产品渠道标识
            ,moneylevelresult -- 命中反洗钱评级情况（0-未命中,1-命中,2-仅命中）
            ,isicmsfactory -- 信贷工厂模式（01-是,02-否,03-无）
            ,recoverflag -- 实时追缴标志字段：N否，Y是
            ,repayacctwthrobankcard -- 还款账户是否他行卡：N否，Y是
            ,postacctwthrobankcard -- 入账账户是否他行卡：N否，Y是
            ,hangseqno -- 挂账序列号
            ,settleprodtype -- 入账账户产品类型
            ,loanprodtype -- 还款账户产品类型
            ,nextcycledate -- 下一结息日
            ,finalmerger -- 末期合并
            ,prerepaydeal -- 还款计划变更方式
            ,invstflg -- 尽调标志（N否，Y是，是否尽调为否的时候则为互联网业务）
            ,offlchkidenflg -- 线下核身标志（N否，Y是）
            ,iscentralizedaccount -- 是否集中出账（好企贷IPC产品）
            ,priceorderno -- 定价单号
            ,priceapprovestatus -- 定价单审批状态
            ,priceenddate -- 定价单生效截止日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 出账流水号
    ,nvl(n.isnogroup, o.isnogroup) as isnogroup -- 是否集团客户
    ,nvl(n.groupcustname, o.groupcustname) as groupcustname -- 集团客户名称
    ,nvl(n.relationship, o.relationship) as relationship -- 借款人与集团关系
    ,nvl(n.payee_bank_name, o.payee_bank_name) as payee_bank_name -- 收款人行名
    ,nvl(n.loanfinishdate, o.loanfinishdate) as loanfinishdate -- 贷款终止日
    ,nvl(n.putouttime, o.putouttime) as putouttime -- 放款时间
    ,nvl(n.payorderid, o.payorderid) as payorderid -- 支付订单号
    ,nvl(n.isrecordtax, o.isrecordtax) as isrecordtax -- 是否录入印花税
    ,nvl(n.payaccounttel, o.payaccounttel) as payaccounttel -- 开户绑定手机号
    ,nvl(n.loanbegindate, o.loanbegindate) as loanbegindate -- 贷款发放日
    ,nvl(n.payacctno, o.payacctno) as payacctno -- 受托支付账号编号
    ,nvl(n.channelcode, o.channelcode) as channelcode -- 放款渠道码
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.loanstage, o.loanstage) as loanstage -- 贷款期数
    ,nvl(n.loantruedate, o.loantruedate) as loantruedate -- 贷款实际发放日
    ,nvl(n.guacontno, o.guacontno) as guacontno -- 担保保证函编号
    ,nvl(n.taxaccount, o.taxaccount) as taxaccount -- 印花税扣税账号
    ,nvl(n.repaydatetype, o.repaydatetype) as repaydatetype -- 还款日确定
    ,nvl(n.imageno, o.imageno) as imageno -- 影像编号
    ,nvl(n.approveenddate, o.approveenddate) as approveenddate -- 放款结束时间
    ,nvl(n.taxaccountname, o.taxaccountname) as taxaccountname -- 印花税扣税账号名称
    ,nvl(n.putoutconditionremark, o.putoutconditionremark) as putoutconditionremark -- 出账落实条件说明
    ,nvl(n.groupcustcode, o.groupcustcode) as groupcustcode -- 集团客户号
    ,nvl(n.informflag, o.informflag) as informflag -- 放款通知是否成功
    ,nvl(n.approvestartdate, o.approvestartdate) as approvestartdate -- 审批开始时间
    ,nvl(n.availexposure, o.availexposure) as availexposure -- 集团客户可用敞口额度
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.applysum, o.applysum) as applysum -- 申请放款金额
    ,nvl(n.taxamount, o.taxamount) as taxamount -- 印花税金额
    ,nvl(n.imageupflag, o.imageupflag) as imageupflag -- 影像上传结果1完成上传2未完成上传
    ,nvl(n.paymentmethodtype, o.paymentmethodtype) as paymentmethodtype -- 支付工具类型
    ,nvl(n.confirmstate, o.confirmstate) as confirmstate -- 受托支付确认状态
    ,nvl(n.confirmtime, o.confirmtime) as confirmtime -- 受托支付确认时间
    ,nvl(n.checkresult, o.checkresult) as checkresult -- 风控规则结果
    ,nvl(n.payaccounttype, o.payaccounttype) as payaccounttype -- 卡类型0:本行卡1:他行卡
    ,nvl(n.repaymentmethodtype, o.repaymentmethodtype) as repaymentmethodtype -- 还款支付工具类型
    ,nvl(n.cashsum, o.cashsum) as cashsum -- 自主支付金额
    ,nvl(n.exchangeresultremark, o.exchangeresultremark) as exchangeresultremark -- 交易结果描述
    ,nvl(n.balldate, o.balldate) as balldate -- 气球贷摊销日期
    ,nvl(n.relaserialno, o.relaserialno) as relaserialno -- 关联流水号
    ,nvl(n.isbelongterm, o.isbelongterm) as isbelongterm -- 是否靠档计息
    ,nvl(n.productchannel, o.productchannel) as productchannel -- 产品渠道标识
    ,nvl(n.moneylevelresult, o.moneylevelresult) as moneylevelresult -- 命中反洗钱评级情况（0-未命中,1-命中,2-仅命中）
    ,nvl(n.isicmsfactory, o.isicmsfactory) as isicmsfactory -- 信贷工厂模式（01-是,02-否,03-无）
    ,nvl(n.recoverflag, o.recoverflag) as recoverflag -- 实时追缴标志字段：N否，Y是
    ,nvl(n.repayacctwthrobankcard, o.repayacctwthrobankcard) as repayacctwthrobankcard -- 还款账户是否他行卡：N否，Y是
    ,nvl(n.postacctwthrobankcard, o.postacctwthrobankcard) as postacctwthrobankcard -- 入账账户是否他行卡：N否，Y是
    ,nvl(n.hangseqno, o.hangseqno) as hangseqno -- 挂账序列号
    ,nvl(n.settleprodtype, o.settleprodtype) as settleprodtype -- 入账账户产品类型
    ,nvl(n.loanprodtype, o.loanprodtype) as loanprodtype -- 还款账户产品类型
    ,nvl(n.nextcycledate, o.nextcycledate) as nextcycledate -- 下一结息日
    ,nvl(n.finalmerger, o.finalmerger) as finalmerger -- 末期合并
    ,nvl(n.prerepaydeal, o.prerepaydeal) as prerepaydeal -- 还款计划变更方式
    ,nvl(n.invstflg, o.invstflg) as invstflg -- 尽调标志（N否，Y是，是否尽调为否的时候则为互联网业务）
    ,nvl(n.offlchkidenflg, o.offlchkidenflg) as offlchkidenflg -- 线下核身标志（N否，Y是）
    ,nvl(n.iscentralizedaccount, o.iscentralizedaccount) as iscentralizedaccount -- 是否集中出账（好企贷IPC产品）
    ,nvl(n.priceorderno, o.priceorderno) as priceorderno -- 定价单号
    ,nvl(n.priceapprovestatus, o.priceapprovestatus) as priceapprovestatus -- 定价单审批状态
    ,nvl(n.priceenddate, o.priceenddate) as priceenddate -- 定价单生效截止日
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
from (select * from ${iol_schema}.icms_bp_personal_loan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_bp_personal_loan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.isnogroup <> n.isnogroup
        or o.groupcustname <> n.groupcustname
        or o.relationship <> n.relationship
        or o.payee_bank_name <> n.payee_bank_name
        or o.loanfinishdate <> n.loanfinishdate
        or o.putouttime <> n.putouttime
        or o.payorderid <> n.payorderid
        or o.isrecordtax <> n.isrecordtax
        or o.payaccounttel <> n.payaccounttel
        or o.loanbegindate <> n.loanbegindate
        or o.payacctno <> n.payacctno
        or o.channelcode <> n.channelcode
        or o.remark <> n.remark
        or o.loanstage <> n.loanstage
        or o.loantruedate <> n.loantruedate
        or o.guacontno <> n.guacontno
        or o.taxaccount <> n.taxaccount
        or o.repaydatetype <> n.repaydatetype
        or o.imageno <> n.imageno
        or o.approveenddate <> n.approveenddate
        or o.taxaccountname <> n.taxaccountname
        or o.putoutconditionremark <> n.putoutconditionremark
        or o.groupcustcode <> n.groupcustcode
        or o.informflag <> n.informflag
        or o.approvestartdate <> n.approvestartdate
        or o.availexposure <> n.availexposure
        or o.migtflag <> n.migtflag
        or o.applysum <> n.applysum
        or o.taxamount <> n.taxamount
        or o.imageupflag <> n.imageupflag
        or o.paymentmethodtype <> n.paymentmethodtype
        or o.confirmstate <> n.confirmstate
        or o.confirmtime <> n.confirmtime
        or o.checkresult <> n.checkresult
        or o.payaccounttype <> n.payaccounttype
        or o.repaymentmethodtype <> n.repaymentmethodtype
        or o.cashsum <> n.cashsum
        or o.exchangeresultremark <> n.exchangeresultremark
        or o.balldate <> n.balldate
        or o.relaserialno <> n.relaserialno
        or o.isbelongterm <> n.isbelongterm
        or o.productchannel <> n.productchannel
        or o.moneylevelresult <> n.moneylevelresult
        or o.isicmsfactory <> n.isicmsfactory
        or o.recoverflag <> n.recoverflag
        or o.repayacctwthrobankcard <> n.repayacctwthrobankcard
        or o.postacctwthrobankcard <> n.postacctwthrobankcard
        or o.hangseqno <> n.hangseqno
        or o.settleprodtype <> n.settleprodtype
        or o.loanprodtype <> n.loanprodtype
        or o.nextcycledate <> n.nextcycledate
        or o.finalmerger <> n.finalmerger
        or o.prerepaydeal <> n.prerepaydeal
        or o.invstflg <> n.invstflg
        or o.offlchkidenflg <> n.offlchkidenflg
        or o.iscentralizedaccount <> n.iscentralizedaccount
        or o.priceorderno <> n.priceorderno
        or o.priceapprovestatus <> n.priceapprovestatus
        or o.priceenddate <> n.priceenddate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bp_personal_loan_cl(
            serialno -- 出账流水号
            ,isnogroup -- 是否集团客户
            ,groupcustname -- 集团客户名称
            ,relationship -- 借款人与集团关系
            ,payee_bank_name -- 收款人行名
            ,loanfinishdate -- 贷款终止日
            ,putouttime -- 放款时间
            ,payorderid -- 支付订单号
            ,isrecordtax -- 是否录入印花税
            ,payaccounttel -- 开户绑定手机号
            ,loanbegindate -- 贷款发放日
            ,payacctno -- 受托支付账号编号
            ,channelcode -- 放款渠道码
            ,remark -- 备注
            ,loanstage -- 贷款期数
            ,loantruedate -- 贷款实际发放日
            ,guacontno -- 担保保证函编号
            ,taxaccount -- 印花税扣税账号
            ,repaydatetype -- 还款日确定
            ,imageno -- 影像编号
            ,approveenddate -- 放款结束时间
            ,taxaccountname -- 印花税扣税账号名称
            ,putoutconditionremark -- 出账落实条件说明
            ,groupcustcode -- 集团客户号
            ,informflag -- 放款通知是否成功
            ,approvestartdate -- 审批开始时间
            ,availexposure -- 集团客户可用敞口额度
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,applysum -- 申请放款金额
            ,taxamount -- 印花税金额
            ,imageupflag -- 影像上传结果1完成上传2未完成上传
            ,paymentmethodtype -- 支付工具类型
            ,confirmstate -- 受托支付确认状态
            ,confirmtime -- 受托支付确认时间
            ,checkresult -- 风控规则结果
            ,payaccounttype -- 卡类型0:本行卡1:他行卡
            ,repaymentmethodtype -- 还款支付工具类型
            ,cashsum -- 自主支付金额
            ,exchangeresultremark -- 交易结果描述
            ,balldate -- 气球贷摊销日期
            ,relaserialno -- 关联流水号
            ,isbelongterm -- 是否靠档计息
            ,productchannel -- 产品渠道标识
            ,moneylevelresult -- 命中反洗钱评级情况（0-未命中,1-命中,2-仅命中）
            ,isicmsfactory -- 信贷工厂模式（01-是,02-否,03-无）
            ,recoverflag -- 实时追缴标志字段：N否，Y是
            ,repayacctwthrobankcard -- 还款账户是否他行卡：N否，Y是
            ,postacctwthrobankcard -- 入账账户是否他行卡：N否，Y是
            ,hangseqno -- 挂账序列号
            ,settleprodtype -- 入账账户产品类型
            ,loanprodtype -- 还款账户产品类型
            ,nextcycledate -- 下一结息日
            ,finalmerger -- 末期合并
            ,prerepaydeal -- 还款计划变更方式
            ,invstflg -- 尽调标志（N否，Y是，是否尽调为否的时候则为互联网业务）
            ,offlchkidenflg -- 线下核身标志（N否，Y是）
            ,iscentralizedaccount -- 是否集中出账（好企贷IPC产品）
            ,priceorderno -- 定价单号
            ,priceapprovestatus -- 定价单审批状态
            ,priceenddate -- 定价单生效截止日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bp_personal_loan_op(
            serialno -- 出账流水号
            ,isnogroup -- 是否集团客户
            ,groupcustname -- 集团客户名称
            ,relationship -- 借款人与集团关系
            ,payee_bank_name -- 收款人行名
            ,loanfinishdate -- 贷款终止日
            ,putouttime -- 放款时间
            ,payorderid -- 支付订单号
            ,isrecordtax -- 是否录入印花税
            ,payaccounttel -- 开户绑定手机号
            ,loanbegindate -- 贷款发放日
            ,payacctno -- 受托支付账号编号
            ,channelcode -- 放款渠道码
            ,remark -- 备注
            ,loanstage -- 贷款期数
            ,loantruedate -- 贷款实际发放日
            ,guacontno -- 担保保证函编号
            ,taxaccount -- 印花税扣税账号
            ,repaydatetype -- 还款日确定
            ,imageno -- 影像编号
            ,approveenddate -- 放款结束时间
            ,taxaccountname -- 印花税扣税账号名称
            ,putoutconditionremark -- 出账落实条件说明
            ,groupcustcode -- 集团客户号
            ,informflag -- 放款通知是否成功
            ,approvestartdate -- 审批开始时间
            ,availexposure -- 集团客户可用敞口额度
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,applysum -- 申请放款金额
            ,taxamount -- 印花税金额
            ,imageupflag -- 影像上传结果1完成上传2未完成上传
            ,paymentmethodtype -- 支付工具类型
            ,confirmstate -- 受托支付确认状态
            ,confirmtime -- 受托支付确认时间
            ,checkresult -- 风控规则结果
            ,payaccounttype -- 卡类型0:本行卡1:他行卡
            ,repaymentmethodtype -- 还款支付工具类型
            ,cashsum -- 自主支付金额
            ,exchangeresultremark -- 交易结果描述
            ,balldate -- 气球贷摊销日期
            ,relaserialno -- 关联流水号
            ,isbelongterm -- 是否靠档计息
            ,productchannel -- 产品渠道标识
            ,moneylevelresult -- 命中反洗钱评级情况（0-未命中,1-命中,2-仅命中）
            ,isicmsfactory -- 信贷工厂模式（01-是,02-否,03-无）
            ,recoverflag -- 实时追缴标志字段：N否，Y是
            ,repayacctwthrobankcard -- 还款账户是否他行卡：N否，Y是
            ,postacctwthrobankcard -- 入账账户是否他行卡：N否，Y是
            ,hangseqno -- 挂账序列号
            ,settleprodtype -- 入账账户产品类型
            ,loanprodtype -- 还款账户产品类型
            ,nextcycledate -- 下一结息日
            ,finalmerger -- 末期合并
            ,prerepaydeal -- 还款计划变更方式
            ,invstflg -- 尽调标志（N否，Y是，是否尽调为否的时候则为互联网业务）
            ,offlchkidenflg -- 线下核身标志（N否，Y是）
            ,iscentralizedaccount -- 是否集中出账（好企贷IPC产品）
            ,priceorderno -- 定价单号
            ,priceapprovestatus -- 定价单审批状态
            ,priceenddate -- 定价单生效截止日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 出账流水号
    ,o.isnogroup -- 是否集团客户
    ,o.groupcustname -- 集团客户名称
    ,o.relationship -- 借款人与集团关系
    ,o.payee_bank_name -- 收款人行名
    ,o.loanfinishdate -- 贷款终止日
    ,o.putouttime -- 放款时间
    ,o.payorderid -- 支付订单号
    ,o.isrecordtax -- 是否录入印花税
    ,o.payaccounttel -- 开户绑定手机号
    ,o.loanbegindate -- 贷款发放日
    ,o.payacctno -- 受托支付账号编号
    ,o.channelcode -- 放款渠道码
    ,o.remark -- 备注
    ,o.loanstage -- 贷款期数
    ,o.loantruedate -- 贷款实际发放日
    ,o.guacontno -- 担保保证函编号
    ,o.taxaccount -- 印花税扣税账号
    ,o.repaydatetype -- 还款日确定
    ,o.imageno -- 影像编号
    ,o.approveenddate -- 放款结束时间
    ,o.taxaccountname -- 印花税扣税账号名称
    ,o.putoutconditionremark -- 出账落实条件说明
    ,o.groupcustcode -- 集团客户号
    ,o.informflag -- 放款通知是否成功
    ,o.approvestartdate -- 审批开始时间
    ,o.availexposure -- 集团客户可用敞口额度
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.applysum -- 申请放款金额
    ,o.taxamount -- 印花税金额
    ,o.imageupflag -- 影像上传结果1完成上传2未完成上传
    ,o.paymentmethodtype -- 支付工具类型
    ,o.confirmstate -- 受托支付确认状态
    ,o.confirmtime -- 受托支付确认时间
    ,o.checkresult -- 风控规则结果
    ,o.payaccounttype -- 卡类型0:本行卡1:他行卡
    ,o.repaymentmethodtype -- 还款支付工具类型
    ,o.cashsum -- 自主支付金额
    ,o.exchangeresultremark -- 交易结果描述
    ,o.balldate -- 气球贷摊销日期
    ,o.relaserialno -- 关联流水号
    ,o.isbelongterm -- 是否靠档计息
    ,o.productchannel -- 产品渠道标识
    ,o.moneylevelresult -- 命中反洗钱评级情况（0-未命中,1-命中,2-仅命中）
    ,o.isicmsfactory -- 信贷工厂模式（01-是,02-否,03-无）
    ,o.recoverflag -- 实时追缴标志字段：N否，Y是
    ,o.repayacctwthrobankcard -- 还款账户是否他行卡：N否，Y是
    ,o.postacctwthrobankcard -- 入账账户是否他行卡：N否，Y是
    ,o.hangseqno -- 挂账序列号
    ,o.settleprodtype -- 入账账户产品类型
    ,o.loanprodtype -- 还款账户产品类型
    ,o.nextcycledate -- 下一结息日
    ,o.finalmerger -- 末期合并
    ,o.prerepaydeal -- 还款计划变更方式
    ,o.invstflg -- 尽调标志（N否，Y是，是否尽调为否的时候则为互联网业务）
    ,o.offlchkidenflg -- 线下核身标志（N否，Y是）
    ,o.iscentralizedaccount -- 是否集中出账（好企贷IPC产品）
    ,o.priceorderno -- 定价单号
    ,o.priceapprovestatus -- 定价单审批状态
    ,o.priceenddate -- 定价单生效截止日
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
from ${iol_schema}.icms_bp_personal_loan_bk o
    left join ${iol_schema}.icms_bp_personal_loan_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_bp_personal_loan_cl d
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
--truncate table ${iol_schema}.icms_bp_personal_loan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_bp_personal_loan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_bp_personal_loan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_bp_personal_loan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_bp_personal_loan exchange partition p_${batch_date} with table ${iol_schema}.icms_bp_personal_loan_cl;
alter table ${iol_schema}.icms_bp_personal_loan exchange partition p_20991231 with table ${iol_schema}.icms_bp_personal_loan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_bp_personal_loan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bp_personal_loan_op purge;
drop table ${iol_schema}.icms_bp_personal_loan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_bp_personal_loan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_bp_personal_loan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
