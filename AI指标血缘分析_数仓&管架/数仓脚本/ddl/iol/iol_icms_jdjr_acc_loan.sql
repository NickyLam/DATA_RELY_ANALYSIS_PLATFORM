/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_jdjr_acc_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_jdjr_acc_loan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_jdjr_acc_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_jdjr_acc_loan(
    contno varchar2(30) -- 客户签订的合同号码，即借据号、出资方贷款单号
    ,countenchashfee number(26,8) -- 应计取现手续费
    ,laonrealityrate number(15,8) -- 借款执行利率
    ,limitno varchar2(60) -- 客户额度编号
    ,cusid varchar2(32) -- 客户号
    ,prdcode varchar2(60) -- 产品编号(行内)
    ,enchashfeerate number(26,8) -- 取现手续费利率
    ,cusno varchar2(60) -- 京东pin
    ,loanterms varchar2(2) -- 贷款期数
    ,lpr number(14,10) -- LPR
    ,instovdinterest number(26,8) -- 改分期逾期利息
    ,volfeerate number(26,8) -- 违约金利率
    ,loaninneraccount varchar2(64) -- 贷款入帐账号
    ,ratefloatmode varchar2(2) -- 利率浮动方式
    ,iswhite varchar2(2) -- 
    ,bussdate varchar2(10) -- 数据日期
    ,instpricbalance number(26,8) -- 改分期本金余额
    ,loanrepayaccount varchar2(64) -- 还款账号
    ,execrate number(14,10) -- 执行年利率，京东推送日利率X360
    ,floatratebp number(14,10) -- 利率浮动点差BP
    ,loanserno varchar2(30) -- 放款流水号
    ,certno varchar2(20) -- 证件号
    ,intovdstartdt varchar2(10) -- 利息逾期日期
    ,loanovdbalance number(26,8) -- 逾期贷款余额
    ,inpnltamt number(26,8) -- 应计罚息
    ,withenchashfeeday number(26,8) -- 当日计提取现手续费
    ,repayinthz varchar2(6) -- 利息还款频率
    ,prinovdstartdt varchar2(10) -- 本金逾期日期
    ,loanoutintbalance number(26,8) -- 表外欠息
    ,loanrate number(26,8) -- 借款利率
    ,laonrealityratetype varchar2(2) -- 借款执行利率类型
    ,feeratetype varchar2(1) -- 手续费费率类型D、日M、月W、周
    ,isbankrel varchar2(1) -- 是否关联人1是2否
    ,currency varchar2(3) -- 参见币种表
    ,instpricovdbalance number(26,8) -- 改分期本金逾期余额
    ,migtflag varchar2(80) -- 
    ,loanenddt varchar2(10) -- 业务到期日期
    ,prdno varchar2(4) -- 产品编号
    ,loanstartdt varchar2(10) -- 放款日期
    ,localarea varchar2(6) -- 贷款资金使用位置
    ,intnextpaydt varchar2(10) -- 下一付息日
    ,intflag varchar2(1) -- 计息标志
    ,repaychangetype varchar2(1) -- 新增还款变更类型
    ,volfeeratetype varchar2(1) -- 违约金费率类型
    ,loanno varchar2(60) -- 借据号
    ,ovdterms varchar2(2) -- 逾期期数
    ,countvolfee number(26,8) -- 应计违约金
    ,loanstatus varchar2(10) -- 贷款状态
    ,pnltrate number(26,8) -- 罚息利率
    ,loanratetype varchar2(1) -- 借款利率类型
    ,instinterest number(26,8) -- 改分期利息
    ,volfeeday number(26,8) -- 当日违约金
    ,assetthreetypecd varchar2(10) -- 业务模式(FVOCI模式,AC模式)
    ,selfpayamt number(26,8) -- 自主支付金额
    ,todaypnltintamt number(26,8) -- 当日罚息
    ,instintpenalty number(26,8) -- 改分期罚息
    ,busmodel varchar2(6) -- 业务模式
    ,loanamt number(26,8) -- 贷款放款金额
    ,repayprinhz varchar2(6) -- 本金还款频率
    ,ratetype varchar2(6) -- 利率调整方式
    ,todayintamt number(26,8) -- 当日利息
    ,cusname varchar2(64) -- 客户姓名
    ,ratelprtype varchar2(4) -- 利率类型1基准利率2LPR
    ,loansucessreceivedate varchar2(10) -- 放款成功接收日期YYYYMMMMDD
    ,loanbalance number(26,8) -- 贷款余额
    ,loanovdintbalance number(26,8) -- 逾期利息
    ,granttype varchar2(3) -- 贷款担保方式
    ,repaytype varchar2(1) -- 还款方式
    ,ordinterest number(26,8) -- 普通利息
    ,ordovdinterest number(26,8) -- 普通逾期利息
    ,ordintpenalty number(26,8) -- 普通罚息
    ,unrepaysterms varchar2(2) -- 待还期数
    ,outterms varchar2(2) -- 表外期数
    ,ovdflag varchar2(1) -- 贷款逾期标志
    ,intamt number(26,8) -- 应计利息
    ,inputid varchar2(32) -- 所属客户经理
    ,ordpricbalance number(26,8) -- 普通本金余额
    ,ovddays number(22) -- 逾期天数
    ,ordpricovdbalance number(26,8) -- 普通本金逾期余额
    ,pnltratetype varchar2(1) -- 罚息利率类型
    ,loanuseway varchar2(30) -- 借款用途
    ,entrustedpayamt number(26,8) -- 受托支付金额
    ,extenddays number(22) -- 逾期宽限天数
    ,cleardate varchar2(64) -- 结清日期
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
grant select on ${iol_schema}.icms_jdjr_acc_loan to ${iml_schema};
grant select on ${iol_schema}.icms_jdjr_acc_loan to ${icl_schema};
grant select on ${iol_schema}.icms_jdjr_acc_loan to ${idl_schema};
grant select on ${iol_schema}.icms_jdjr_acc_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_jdjr_acc_loan is '京东借据信息';
comment on column ${iol_schema}.icms_jdjr_acc_loan.contno is '客户签订的合同号码，即借据号、出资方贷款单号';
comment on column ${iol_schema}.icms_jdjr_acc_loan.countenchashfee is '应计取现手续费';
comment on column ${iol_schema}.icms_jdjr_acc_loan.laonrealityrate is '借款执行利率';
comment on column ${iol_schema}.icms_jdjr_acc_loan.limitno is '客户额度编号';
comment on column ${iol_schema}.icms_jdjr_acc_loan.cusid is '客户号';
comment on column ${iol_schema}.icms_jdjr_acc_loan.prdcode is '产品编号(行内)';
comment on column ${iol_schema}.icms_jdjr_acc_loan.enchashfeerate is '取现手续费利率';
comment on column ${iol_schema}.icms_jdjr_acc_loan.cusno is '京东pin';
comment on column ${iol_schema}.icms_jdjr_acc_loan.loanterms is '贷款期数';
comment on column ${iol_schema}.icms_jdjr_acc_loan.lpr is 'LPR';
comment on column ${iol_schema}.icms_jdjr_acc_loan.instovdinterest is '改分期逾期利息';
comment on column ${iol_schema}.icms_jdjr_acc_loan.volfeerate is '违约金利率';
comment on column ${iol_schema}.icms_jdjr_acc_loan.loaninneraccount is '贷款入帐账号';
comment on column ${iol_schema}.icms_jdjr_acc_loan.ratefloatmode is '利率浮动方式';
comment on column ${iol_schema}.icms_jdjr_acc_loan.iswhite is '';
comment on column ${iol_schema}.icms_jdjr_acc_loan.bussdate is '数据日期';
comment on column ${iol_schema}.icms_jdjr_acc_loan.instpricbalance is '改分期本金余额';
comment on column ${iol_schema}.icms_jdjr_acc_loan.loanrepayaccount is '还款账号';
comment on column ${iol_schema}.icms_jdjr_acc_loan.execrate is '执行年利率，京东推送日利率X360';
comment on column ${iol_schema}.icms_jdjr_acc_loan.floatratebp is '利率浮动点差BP';
comment on column ${iol_schema}.icms_jdjr_acc_loan.loanserno is '放款流水号';
comment on column ${iol_schema}.icms_jdjr_acc_loan.certno is '证件号';
comment on column ${iol_schema}.icms_jdjr_acc_loan.intovdstartdt is '利息逾期日期';
comment on column ${iol_schema}.icms_jdjr_acc_loan.loanovdbalance is '逾期贷款余额';
comment on column ${iol_schema}.icms_jdjr_acc_loan.inpnltamt is '应计罚息';
comment on column ${iol_schema}.icms_jdjr_acc_loan.withenchashfeeday is '当日计提取现手续费';
comment on column ${iol_schema}.icms_jdjr_acc_loan.repayinthz is '利息还款频率';
comment on column ${iol_schema}.icms_jdjr_acc_loan.prinovdstartdt is '本金逾期日期';
comment on column ${iol_schema}.icms_jdjr_acc_loan.loanoutintbalance is '表外欠息';
comment on column ${iol_schema}.icms_jdjr_acc_loan.loanrate is '借款利率';
comment on column ${iol_schema}.icms_jdjr_acc_loan.laonrealityratetype is '借款执行利率类型';
comment on column ${iol_schema}.icms_jdjr_acc_loan.feeratetype is '手续费费率类型D、日M、月W、周';
comment on column ${iol_schema}.icms_jdjr_acc_loan.isbankrel is '是否关联人1是2否';
comment on column ${iol_schema}.icms_jdjr_acc_loan.currency is '参见币种表';
comment on column ${iol_schema}.icms_jdjr_acc_loan.instpricovdbalance is '改分期本金逾期余额';
comment on column ${iol_schema}.icms_jdjr_acc_loan.migtflag is '';
comment on column ${iol_schema}.icms_jdjr_acc_loan.loanenddt is '业务到期日期';
comment on column ${iol_schema}.icms_jdjr_acc_loan.prdno is '产品编号';
comment on column ${iol_schema}.icms_jdjr_acc_loan.loanstartdt is '放款日期';
comment on column ${iol_schema}.icms_jdjr_acc_loan.localarea is '贷款资金使用位置';
comment on column ${iol_schema}.icms_jdjr_acc_loan.intnextpaydt is '下一付息日';
comment on column ${iol_schema}.icms_jdjr_acc_loan.intflag is '计息标志';
comment on column ${iol_schema}.icms_jdjr_acc_loan.repaychangetype is '新增还款变更类型';
comment on column ${iol_schema}.icms_jdjr_acc_loan.volfeeratetype is '违约金费率类型';
comment on column ${iol_schema}.icms_jdjr_acc_loan.loanno is '借据号';
comment on column ${iol_schema}.icms_jdjr_acc_loan.ovdterms is '逾期期数';
comment on column ${iol_schema}.icms_jdjr_acc_loan.countvolfee is '应计违约金';
comment on column ${iol_schema}.icms_jdjr_acc_loan.loanstatus is '贷款状态';
comment on column ${iol_schema}.icms_jdjr_acc_loan.pnltrate is '罚息利率';
comment on column ${iol_schema}.icms_jdjr_acc_loan.loanratetype is '借款利率类型';
comment on column ${iol_schema}.icms_jdjr_acc_loan.instinterest is '改分期利息';
comment on column ${iol_schema}.icms_jdjr_acc_loan.volfeeday is '当日违约金';
comment on column ${iol_schema}.icms_jdjr_acc_loan.assetthreetypecd is '业务模式(FVOCI模式,AC模式)';
comment on column ${iol_schema}.icms_jdjr_acc_loan.selfpayamt is '自主支付金额';
comment on column ${iol_schema}.icms_jdjr_acc_loan.todaypnltintamt is '当日罚息';
comment on column ${iol_schema}.icms_jdjr_acc_loan.instintpenalty is '改分期罚息';
comment on column ${iol_schema}.icms_jdjr_acc_loan.busmodel is '业务模式';
comment on column ${iol_schema}.icms_jdjr_acc_loan.loanamt is '贷款放款金额';
comment on column ${iol_schema}.icms_jdjr_acc_loan.repayprinhz is '本金还款频率';
comment on column ${iol_schema}.icms_jdjr_acc_loan.ratetype is '利率调整方式';
comment on column ${iol_schema}.icms_jdjr_acc_loan.todayintamt is '当日利息';
comment on column ${iol_schema}.icms_jdjr_acc_loan.cusname is '客户姓名';
comment on column ${iol_schema}.icms_jdjr_acc_loan.ratelprtype is '利率类型1基准利率2LPR';
comment on column ${iol_schema}.icms_jdjr_acc_loan.loansucessreceivedate is '放款成功接收日期YYYYMMMMDD';
comment on column ${iol_schema}.icms_jdjr_acc_loan.loanbalance is '贷款余额';
comment on column ${iol_schema}.icms_jdjr_acc_loan.loanovdintbalance is '逾期利息';
comment on column ${iol_schema}.icms_jdjr_acc_loan.granttype is '贷款担保方式';
comment on column ${iol_schema}.icms_jdjr_acc_loan.repaytype is '还款方式';
comment on column ${iol_schema}.icms_jdjr_acc_loan.ordinterest is '普通利息';
comment on column ${iol_schema}.icms_jdjr_acc_loan.ordovdinterest is '普通逾期利息';
comment on column ${iol_schema}.icms_jdjr_acc_loan.ordintpenalty is '普通罚息';
comment on column ${iol_schema}.icms_jdjr_acc_loan.unrepaysterms is '待还期数';
comment on column ${iol_schema}.icms_jdjr_acc_loan.outterms is '表外期数';
comment on column ${iol_schema}.icms_jdjr_acc_loan.ovdflag is '贷款逾期标志';
comment on column ${iol_schema}.icms_jdjr_acc_loan.intamt is '应计利息';
comment on column ${iol_schema}.icms_jdjr_acc_loan.inputid is '所属客户经理';
comment on column ${iol_schema}.icms_jdjr_acc_loan.ordpricbalance is '普通本金余额';
comment on column ${iol_schema}.icms_jdjr_acc_loan.ovddays is '逾期天数';
comment on column ${iol_schema}.icms_jdjr_acc_loan.ordpricovdbalance is '普通本金逾期余额';
comment on column ${iol_schema}.icms_jdjr_acc_loan.pnltratetype is '罚息利率类型';
comment on column ${iol_schema}.icms_jdjr_acc_loan.loanuseway is '借款用途';
comment on column ${iol_schema}.icms_jdjr_acc_loan.entrustedpayamt is '受托支付金额';
comment on column ${iol_schema}.icms_jdjr_acc_loan.extenddays is '逾期宽限天数';
comment on column ${iol_schema}.icms_jdjr_acc_loan.cleardate is '结清日期';
comment on column ${iol_schema}.icms_jdjr_acc_loan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_jdjr_acc_loan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_jdjr_acc_loan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_jdjr_acc_loan.etl_timestamp is 'ETL处理时间戳';
