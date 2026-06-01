/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wld_tm_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wld_tm_loan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wld_tm_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wld_tm_loan(
    org varchar2(12) -- 机构号
    ,loanid number(20) -- 借据id
    ,acctno number(20) -- 账户编号
    ,accttype varchar2(1) -- 账户类型
    ,refnbr varchar2(23) -- 交易参考号
    ,logicalcardno varchar2(19) -- 逻辑卡号
    ,cardno varchar2(19) -- 卡号
    ,registerdate date -- 贷款注册日期
    ,requesttime date -- 请求日期时间
    ,loantype varchar2(5) -- 贷款类型
    ,loanstatus varchar2(1) -- 贷款状态
    ,lastloanstatus varchar2(1) -- 贷款上次状态
    ,loaninitterm number(38) -- 贷款总期数
    ,currterm number(38) -- 当前期数
    ,remainterm number(38) -- 剩余期数
    ,loaninitprin number(15,2) -- 贷款总本金
    ,loanfixedpmtprin number(15,2) -- 贷款每期应还本金
    ,loanfirsttermprin number(15,2) -- 贷款首期应还本金
    ,loanfinaltermprin number(15,2) -- 贷款末期应还本金
    ,loaninitfee1 number(15,2) -- 贷款总手续费
    ,loanfixedfee1 number(15,2) -- 贷款每期手续费
    ,loanfirsttermfee1 number(15,2) -- 贷款首期手续费
    ,loanfinaltermfee1 number(15,2) -- 贷款末期手续费
    ,unearnedprin number(15,2) -- 贷款账单的本金
    ,unearnedfee1 number(15,2) -- 贷款账单手续费
    ,paidoutdate date -- 还清日期
    ,terminatedate date -- 提前终止日期
    ,terminatereasoncd varchar2(1) -- 贷款终止原因代码
    ,prinpaid number(15,2) -- 已偿还本金
    ,integerpaid number(15,2) -- 已偿还利息
    ,feepaid number(15,2) -- 已偿还费用
    ,loancurrbal number(15,2) -- 贷款当前总余额
    ,loanbalxfrout number(15,2) -- 贷款未到期余额
    ,loanbalxfrin number(15,2) -- 贷款已到期余额
    ,loanbalprincipal number(15,2) -- 欠款总本金
    ,loanbalintegererest number(15,2) -- 欠款总利息
    ,loanbalpenalty number(15,2) -- 欠款总罚息
    ,loanprinxfrout number(15,2) -- 贷款未到期本金
    ,loanprinxfrin number(15,2) -- 贷款已到期本金
    ,loanfee1xfrout number(15,2) -- 贷款未到期手续费
    ,loanfee1xfrin number(15,2) -- 贷款已到期手续费
    ,origtxnamt number(15,2) -- 原始交易币种金额
    ,origtransdate date -- 原始交易日期
    ,origauthcode varchar2(6) -- 原始交易授权码
    ,jpaversion number(38) -- 乐观锁版本号
    ,loancode varchar2(12) -- 贷款产品号
    ,registerid number(20) -- 贷款申请顺序号
    ,reschinitprin number(15,2) -- 展期本金金额
    ,reschdate date -- 展期生效日期
    ,befreschfixedpmtprin number(15,2) -- 展期前每期应还本金
    ,befreschinitterm number(38) -- 展期前总期数
    ,befreschfirsttermprin number(15,2) -- 展期前贷款首期应还本金
    ,befreschfinaltermprin number(15,2) -- 展期前贷款末期应还本金
    ,befreschinitfee1 number(15,2) -- 展期前贷款总手续费
    ,befreschfixedfee1 number(15,2) -- 贷款每期手续费
    ,befreschfirsttermfee1 number(15,2) -- 展期前贷款首期手续费
    ,befreschfinaltermfee1 number(15,2) -- 展期前贷款末期手续费
    ,reschfirsttermfee1 number(15,2) -- 展期后首期手续费
    ,loanfeemethod varchar2(1) -- 贷款手续费收取方式
    ,integererestrate number(19,6) -- 基础利率
    ,penaltyrate number(19,6) -- 罚息利率
    ,compoundrate number(19,6) -- 复利利率
    ,floatrate number(15,6) -- 浮动比例
    ,loanreceiptnbr varchar2(20) -- 借据号
    ,loanexpiredate date -- 贷款到期日期
    ,loancd varchar2(2) -- 贷款逾期最大期数
    ,paymenthist varchar2(24) -- 24个月还款状态
    ,ctdpaymentamt number(15,2) -- 当期还款额
    ,pastreschcnt number(38) -- 已展期次数
    ,pastshortedcnt number(38) -- 已缩期次数
    ,advpmtamt number(15,2) -- 提前还款金额
    ,lastactiondate date -- 上次行动日期
    ,lastactiontype varchar2(1) -- 上次行动类型
    ,lastmodifieddatetime date -- 修改时间
    ,activatedate date -- 激活日期
    ,integererestcalcbase varchar2(1) -- 计息基数
    ,firstbilldate date -- 首个到期还款日
    ,agecd varchar2(1) -- 账龄
    ,recalcind varchar2(1) -- 利率重算标志
    ,recalcdate date -- 利率重算日
    ,gracedate date -- 宽限日期
    ,canceldate date -- 撤销日期
    ,cancelreason varchar2(200) -- 贷款撤销原因
    ,bankgroupid varchar2(5) -- 参贷方案编号
    ,duedays number(38) -- 当前逾期天数
    ,contractver varchar2(800) -- 合同版本号
    ,loaninitintegererest number(15,2) -- 贷款总利息
    ,befinitintegererest number(15,2) -- 原贷款总利息
    ,bankproportion number(5,2) -- 银行出资比例
    ,writeoffdate varchar2(10) -- 核销日期
    ,hxloaninitprin number(15,2) -- 核销本金
    ,loanintrpenalty number(15,2) -- 核销利息罚息
    ,wldcustid number(20) -- 微粒贷客户号
    ,customerid varchar2(32) -- 客户编号
    ,productid varchar2(12) -- 产品编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_wld_tm_loan to ${iml_schema};
grant select on ${iol_schema}.icms_wld_tm_loan to ${icl_schema};
grant select on ${iol_schema}.icms_wld_tm_loan to ${idl_schema};
grant select on ${iol_schema}.icms_wld_tm_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wld_tm_loan is '微粒贷分期信息表';
comment on column ${iol_schema}.icms_wld_tm_loan.org is '机构号';
comment on column ${iol_schema}.icms_wld_tm_loan.loanid is '借据id';
comment on column ${iol_schema}.icms_wld_tm_loan.acctno is '账户编号';
comment on column ${iol_schema}.icms_wld_tm_loan.accttype is '账户类型';
comment on column ${iol_schema}.icms_wld_tm_loan.refnbr is '交易参考号';
comment on column ${iol_schema}.icms_wld_tm_loan.logicalcardno is '逻辑卡号';
comment on column ${iol_schema}.icms_wld_tm_loan.cardno is '卡号';
comment on column ${iol_schema}.icms_wld_tm_loan.registerdate is '贷款注册日期';
comment on column ${iol_schema}.icms_wld_tm_loan.requesttime is '请求日期时间';
comment on column ${iol_schema}.icms_wld_tm_loan.loantype is '贷款类型';
comment on column ${iol_schema}.icms_wld_tm_loan.loanstatus is '贷款状态';
comment on column ${iol_schema}.icms_wld_tm_loan.lastloanstatus is '贷款上次状态';
comment on column ${iol_schema}.icms_wld_tm_loan.loaninitterm is '贷款总期数';
comment on column ${iol_schema}.icms_wld_tm_loan.currterm is '当前期数';
comment on column ${iol_schema}.icms_wld_tm_loan.remainterm is '剩余期数';
comment on column ${iol_schema}.icms_wld_tm_loan.loaninitprin is '贷款总本金';
comment on column ${iol_schema}.icms_wld_tm_loan.loanfixedpmtprin is '贷款每期应还本金';
comment on column ${iol_schema}.icms_wld_tm_loan.loanfirsttermprin is '贷款首期应还本金';
comment on column ${iol_schema}.icms_wld_tm_loan.loanfinaltermprin is '贷款末期应还本金';
comment on column ${iol_schema}.icms_wld_tm_loan.loaninitfee1 is '贷款总手续费';
comment on column ${iol_schema}.icms_wld_tm_loan.loanfixedfee1 is '贷款每期手续费';
comment on column ${iol_schema}.icms_wld_tm_loan.loanfirsttermfee1 is '贷款首期手续费';
comment on column ${iol_schema}.icms_wld_tm_loan.loanfinaltermfee1 is '贷款末期手续费';
comment on column ${iol_schema}.icms_wld_tm_loan.unearnedprin is '贷款账单的本金';
comment on column ${iol_schema}.icms_wld_tm_loan.unearnedfee1 is '贷款账单手续费';
comment on column ${iol_schema}.icms_wld_tm_loan.paidoutdate is '还清日期';
comment on column ${iol_schema}.icms_wld_tm_loan.terminatedate is '提前终止日期';
comment on column ${iol_schema}.icms_wld_tm_loan.terminatereasoncd is '贷款终止原因代码';
comment on column ${iol_schema}.icms_wld_tm_loan.prinpaid is '已偿还本金';
comment on column ${iol_schema}.icms_wld_tm_loan.integerpaid is '已偿还利息';
comment on column ${iol_schema}.icms_wld_tm_loan.feepaid is '已偿还费用';
comment on column ${iol_schema}.icms_wld_tm_loan.loancurrbal is '贷款当前总余额';
comment on column ${iol_schema}.icms_wld_tm_loan.loanbalxfrout is '贷款未到期余额';
comment on column ${iol_schema}.icms_wld_tm_loan.loanbalxfrin is '贷款已到期余额';
comment on column ${iol_schema}.icms_wld_tm_loan.loanbalprincipal is '欠款总本金';
comment on column ${iol_schema}.icms_wld_tm_loan.loanbalintegererest is '欠款总利息';
comment on column ${iol_schema}.icms_wld_tm_loan.loanbalpenalty is '欠款总罚息';
comment on column ${iol_schema}.icms_wld_tm_loan.loanprinxfrout is '贷款未到期本金';
comment on column ${iol_schema}.icms_wld_tm_loan.loanprinxfrin is '贷款已到期本金';
comment on column ${iol_schema}.icms_wld_tm_loan.loanfee1xfrout is '贷款未到期手续费';
comment on column ${iol_schema}.icms_wld_tm_loan.loanfee1xfrin is '贷款已到期手续费';
comment on column ${iol_schema}.icms_wld_tm_loan.origtxnamt is '原始交易币种金额';
comment on column ${iol_schema}.icms_wld_tm_loan.origtransdate is '原始交易日期';
comment on column ${iol_schema}.icms_wld_tm_loan.origauthcode is '原始交易授权码';
comment on column ${iol_schema}.icms_wld_tm_loan.jpaversion is '乐观锁版本号';
comment on column ${iol_schema}.icms_wld_tm_loan.loancode is '贷款产品号';
comment on column ${iol_schema}.icms_wld_tm_loan.registerid is '贷款申请顺序号';
comment on column ${iol_schema}.icms_wld_tm_loan.reschinitprin is '展期本金金额';
comment on column ${iol_schema}.icms_wld_tm_loan.reschdate is '展期生效日期';
comment on column ${iol_schema}.icms_wld_tm_loan.befreschfixedpmtprin is '展期前每期应还本金';
comment on column ${iol_schema}.icms_wld_tm_loan.befreschinitterm is '展期前总期数';
comment on column ${iol_schema}.icms_wld_tm_loan.befreschfirsttermprin is '展期前贷款首期应还本金';
comment on column ${iol_schema}.icms_wld_tm_loan.befreschfinaltermprin is '展期前贷款末期应还本金';
comment on column ${iol_schema}.icms_wld_tm_loan.befreschinitfee1 is '展期前贷款总手续费';
comment on column ${iol_schema}.icms_wld_tm_loan.befreschfixedfee1 is '贷款每期手续费';
comment on column ${iol_schema}.icms_wld_tm_loan.befreschfirsttermfee1 is '展期前贷款首期手续费';
comment on column ${iol_schema}.icms_wld_tm_loan.befreschfinaltermfee1 is '展期前贷款末期手续费';
comment on column ${iol_schema}.icms_wld_tm_loan.reschfirsttermfee1 is '展期后首期手续费';
comment on column ${iol_schema}.icms_wld_tm_loan.loanfeemethod is '贷款手续费收取方式';
comment on column ${iol_schema}.icms_wld_tm_loan.integererestrate is '基础利率';
comment on column ${iol_schema}.icms_wld_tm_loan.penaltyrate is '罚息利率';
comment on column ${iol_schema}.icms_wld_tm_loan.compoundrate is '复利利率';
comment on column ${iol_schema}.icms_wld_tm_loan.floatrate is '浮动比例';
comment on column ${iol_schema}.icms_wld_tm_loan.loanreceiptnbr is '借据号';
comment on column ${iol_schema}.icms_wld_tm_loan.loanexpiredate is '贷款到期日期';
comment on column ${iol_schema}.icms_wld_tm_loan.loancd is '贷款逾期最大期数';
comment on column ${iol_schema}.icms_wld_tm_loan.paymenthist is '24个月还款状态';
comment on column ${iol_schema}.icms_wld_tm_loan.ctdpaymentamt is '当期还款额';
comment on column ${iol_schema}.icms_wld_tm_loan.pastreschcnt is '已展期次数';
comment on column ${iol_schema}.icms_wld_tm_loan.pastshortedcnt is '已缩期次数';
comment on column ${iol_schema}.icms_wld_tm_loan.advpmtamt is '提前还款金额';
comment on column ${iol_schema}.icms_wld_tm_loan.lastactiondate is '上次行动日期';
comment on column ${iol_schema}.icms_wld_tm_loan.lastactiontype is '上次行动类型';
comment on column ${iol_schema}.icms_wld_tm_loan.lastmodifieddatetime is '修改时间';
comment on column ${iol_schema}.icms_wld_tm_loan.activatedate is '激活日期';
comment on column ${iol_schema}.icms_wld_tm_loan.integererestcalcbase is '计息基数';
comment on column ${iol_schema}.icms_wld_tm_loan.firstbilldate is '首个到期还款日';
comment on column ${iol_schema}.icms_wld_tm_loan.agecd is '账龄';
comment on column ${iol_schema}.icms_wld_tm_loan.recalcind is '利率重算标志';
comment on column ${iol_schema}.icms_wld_tm_loan.recalcdate is '利率重算日';
comment on column ${iol_schema}.icms_wld_tm_loan.gracedate is '宽限日期';
comment on column ${iol_schema}.icms_wld_tm_loan.canceldate is '撤销日期';
comment on column ${iol_schema}.icms_wld_tm_loan.cancelreason is '贷款撤销原因';
comment on column ${iol_schema}.icms_wld_tm_loan.bankgroupid is '参贷方案编号';
comment on column ${iol_schema}.icms_wld_tm_loan.duedays is '当前逾期天数';
comment on column ${iol_schema}.icms_wld_tm_loan.contractver is '合同版本号';
comment on column ${iol_schema}.icms_wld_tm_loan.loaninitintegererest is '贷款总利息';
comment on column ${iol_schema}.icms_wld_tm_loan.befinitintegererest is '原贷款总利息';
comment on column ${iol_schema}.icms_wld_tm_loan.bankproportion is '银行出资比例';
comment on column ${iol_schema}.icms_wld_tm_loan.writeoffdate is '核销日期';
comment on column ${iol_schema}.icms_wld_tm_loan.hxloaninitprin is '核销本金';
comment on column ${iol_schema}.icms_wld_tm_loan.loanintrpenalty is '核销利息罚息';
comment on column ${iol_schema}.icms_wld_tm_loan.wldcustid is '微粒贷客户号';
comment on column ${iol_schema}.icms_wld_tm_loan.customerid is '客户编号';
comment on column ${iol_schema}.icms_wld_tm_loan.productid is '产品编号';
comment on column ${iol_schema}.icms_wld_tm_loan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wld_tm_loan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wld_tm_loan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wld_tm_loan.etl_timestamp is 'ETL处理时间戳';
