/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_myjb_acc_loan3
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_myjb_acc_loan3
whenever sqlerror continue none;
drop table ${iol_schema}.icms_myjb_acc_loan3 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myjb_acc_loan3(
    billno varchar2(64) -- 借据号
    ,accountstatus varchar2(10) -- 合约状态，正常NORMAL,逾期OVD,结清CLEAR
    ,ovdprinpnltbal number(12,2) -- 逾期本金罚息余额（单位分），汇总所有期次的逾本罚余额
    ,isbankrel varchar2(1) -- 是否关联人1是2否
    ,cusname varchar2(128) -- 客户名称
    ,prinovddays number(22) -- 本金逾期天数
    ,ratelprtype varchar2(4) -- 利率类型1基准2lpr
    ,prdcode varchar2(64) -- 产品编号
    ,loanstartdate varchar2(8) -- 贷款起息日
    ,intbal number(12,2) -- 正常利息余额（单位分），汇总所有正常期次的利息余额
    ,loanstatus varchar2(2) -- 贷款状态
    ,nextrepaydate varchar2(8) -- 下一还款日期，格式：yyyyMMdd
    ,ovdterms number(22) -- 逾期期次数
    ,execrate number(14,10) -- 执行年利率，借呗推送日利率X360
    ,certtype varchar2(10) -- 证件类型
    ,usearea varchar2(2) -- 贷款资金使用位置
    ,intrepayfrequency varchar2(2) -- 利息还款频率
    ,applyno varchar2(64) -- 贷款申请单号
    ,biztype varchar2(30) -- 业务种类
    ,fundseqno varchar2(64) -- 放款资金流水号
    ,ovdintbal number(12,2) -- 逾期利息余额（单位分），汇总所有逾期期次的利息余额
    ,applydate varchar2(20) -- 申请支用时间
    ,encashacctno varchar2(64) -- 收款帐号
    ,accruedstatus varchar2(2) -- 应计非应计标识，应计0，非应计1
    ,unclearterms number(22) -- 未结清期数
    ,loanamount number(24,6) -- 放款金额
    ,encashaccttype varchar2(2) -- 收款帐号类型
    ,encashdate varchar2(20) -- 放款日期
    ,prinrepayfrequency varchar2(2) -- 本金还款频率
    ,overduebalance number(12,2) -- 逾期本金余额（单位分），汇总所有逾期期次的本金余额
    ,floatratebp number(14,10) -- 利率浮动点差BP
    ,modeltype varchar2(3) -- 产品模块
    ,certcode varchar2(60) -- 证件号码
    ,graceday number(22) -- 宽限期天数
    ,dayrate number(15,8) -- 贷款日利率
    ,writeoff varchar2(2) -- 核销标识，已核销为Y，否则为N
    ,guaranteetype varchar2(3) -- 担保类型
    ,creditno varchar2(64) -- 授信编号
    ,repayacctno varchar2(64) -- 还款帐号
    ,ovdintpnltbal number(12,2) -- 逾期利息罚息余额（单位分），汇总所有期次的逾利罚余额
    ,loanuse varchar2(2) -- 贷款用途
    ,assetthreetypecd varchar2(10) -- 业务模式(FVOCI模式,AC模式)
    ,inputdate varchar2(20) -- 数据日期
    ,currency varchar2(3) -- 币种
    ,loanenddate varchar2(8) -- 贷款到期日
    ,normalbalance number(12,2) -- 正常本金余额（单位分），汇总所有正常期次的本金余额
    ,ratefloatmode varchar2(2) -- 利率浮动方式
    ,totalterms number(22) -- 贷款期次数
    ,repayaccttype varchar2(2) -- 还款帐号类型
    ,cleardate varchar2(64) -- 结清日期，格式：yyyyMMdd
    ,lpr number(14,10) -- LPR
    ,assetclass varchar2(2) -- 五级分类标识，正常1，关注2，次级3，可疑4，损失5
    ,cusid varchar2(30) -- 客户号
    ,iswhite varchar2(2) -- 是否白名单
    ,repaymode varchar2(8) -- 还款方式
    ,ratetype varchar2(2) -- 利率类型
    ,settledate varchar2(8) -- 会计日期，格式：YYYYMMdd
    ,capoverduedays number(22) -- 利息逾期天数
    ,cusmgr varchar2(20) -- 客户经理
    ,classifyresult varchar2(2) -- 五级分类标识(信贷)
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
grant select on ${iol_schema}.icms_myjb_acc_loan3 to ${iml_schema};
grant select on ${iol_schema}.icms_myjb_acc_loan3 to ${icl_schema};
grant select on ${iol_schema}.icms_myjb_acc_loan3 to ${idl_schema};
grant select on ${iol_schema}.icms_myjb_acc_loan3 to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_myjb_acc_loan3 is '借呗借据信息-三期';
comment on column ${iol_schema}.icms_myjb_acc_loan3.billno is '借据号';
comment on column ${iol_schema}.icms_myjb_acc_loan3.accountstatus is '合约状态，正常NORMAL,逾期OVD,结清CLEAR';
comment on column ${iol_schema}.icms_myjb_acc_loan3.ovdprinpnltbal is '逾期本金罚息余额（单位分），汇总所有期次的逾本罚余额';
comment on column ${iol_schema}.icms_myjb_acc_loan3.isbankrel is '是否关联人1是2否';
comment on column ${iol_schema}.icms_myjb_acc_loan3.cusname is '客户名称';
comment on column ${iol_schema}.icms_myjb_acc_loan3.prinovddays is '本金逾期天数';
comment on column ${iol_schema}.icms_myjb_acc_loan3.ratelprtype is '利率类型1基准2lpr';
comment on column ${iol_schema}.icms_myjb_acc_loan3.prdcode is '产品编号';
comment on column ${iol_schema}.icms_myjb_acc_loan3.loanstartdate is '贷款起息日';
comment on column ${iol_schema}.icms_myjb_acc_loan3.intbal is '正常利息余额（单位分），汇总所有正常期次的利息余额';
comment on column ${iol_schema}.icms_myjb_acc_loan3.loanstatus is '贷款状态';
comment on column ${iol_schema}.icms_myjb_acc_loan3.nextrepaydate is '下一还款日期，格式：yyyyMMdd';
comment on column ${iol_schema}.icms_myjb_acc_loan3.ovdterms is '逾期期次数';
comment on column ${iol_schema}.icms_myjb_acc_loan3.execrate is '执行年利率，借呗推送日利率X360';
comment on column ${iol_schema}.icms_myjb_acc_loan3.certtype is '证件类型';
comment on column ${iol_schema}.icms_myjb_acc_loan3.usearea is '贷款资金使用位置';
comment on column ${iol_schema}.icms_myjb_acc_loan3.intrepayfrequency is '利息还款频率';
comment on column ${iol_schema}.icms_myjb_acc_loan3.applyno is '贷款申请单号';
comment on column ${iol_schema}.icms_myjb_acc_loan3.biztype is '业务种类';
comment on column ${iol_schema}.icms_myjb_acc_loan3.fundseqno is '放款资金流水号';
comment on column ${iol_schema}.icms_myjb_acc_loan3.ovdintbal is '逾期利息余额（单位分），汇总所有逾期期次的利息余额';
comment on column ${iol_schema}.icms_myjb_acc_loan3.applydate is '申请支用时间';
comment on column ${iol_schema}.icms_myjb_acc_loan3.encashacctno is '收款帐号';
comment on column ${iol_schema}.icms_myjb_acc_loan3.accruedstatus is '应计非应计标识，应计0，非应计1';
comment on column ${iol_schema}.icms_myjb_acc_loan3.unclearterms is '未结清期数';
comment on column ${iol_schema}.icms_myjb_acc_loan3.loanamount is '放款金额';
comment on column ${iol_schema}.icms_myjb_acc_loan3.encashaccttype is '收款帐号类型';
comment on column ${iol_schema}.icms_myjb_acc_loan3.encashdate is '放款日期';
comment on column ${iol_schema}.icms_myjb_acc_loan3.prinrepayfrequency is '本金还款频率';
comment on column ${iol_schema}.icms_myjb_acc_loan3.overduebalance is '逾期本金余额（单位分），汇总所有逾期期次的本金余额';
comment on column ${iol_schema}.icms_myjb_acc_loan3.floatratebp is '利率浮动点差BP';
comment on column ${iol_schema}.icms_myjb_acc_loan3.modeltype is '产品模块';
comment on column ${iol_schema}.icms_myjb_acc_loan3.certcode is '证件号码';
comment on column ${iol_schema}.icms_myjb_acc_loan3.graceday is '宽限期天数';
comment on column ${iol_schema}.icms_myjb_acc_loan3.dayrate is '贷款日利率';
comment on column ${iol_schema}.icms_myjb_acc_loan3.writeoff is '核销标识，已核销为Y，否则为N';
comment on column ${iol_schema}.icms_myjb_acc_loan3.guaranteetype is '担保类型';
comment on column ${iol_schema}.icms_myjb_acc_loan3.creditno is '授信编号';
comment on column ${iol_schema}.icms_myjb_acc_loan3.repayacctno is '还款帐号';
comment on column ${iol_schema}.icms_myjb_acc_loan3.ovdintpnltbal is '逾期利息罚息余额（单位分），汇总所有期次的逾利罚余额';
comment on column ${iol_schema}.icms_myjb_acc_loan3.loanuse is '贷款用途';
comment on column ${iol_schema}.icms_myjb_acc_loan3.assetthreetypecd is '业务模式(FVOCI模式,AC模式)';
comment on column ${iol_schema}.icms_myjb_acc_loan3.inputdate is '数据日期';
comment on column ${iol_schema}.icms_myjb_acc_loan3.currency is '币种';
comment on column ${iol_schema}.icms_myjb_acc_loan3.loanenddate is '贷款到期日';
comment on column ${iol_schema}.icms_myjb_acc_loan3.normalbalance is '正常本金余额（单位分），汇总所有正常期次的本金余额';
comment on column ${iol_schema}.icms_myjb_acc_loan3.ratefloatmode is '利率浮动方式';
comment on column ${iol_schema}.icms_myjb_acc_loan3.totalterms is '贷款期次数';
comment on column ${iol_schema}.icms_myjb_acc_loan3.repayaccttype is '还款帐号类型';
comment on column ${iol_schema}.icms_myjb_acc_loan3.cleardate is '结清日期，格式：yyyyMMdd';
comment on column ${iol_schema}.icms_myjb_acc_loan3.lpr is 'LPR';
comment on column ${iol_schema}.icms_myjb_acc_loan3.assetclass is '五级分类标识，正常1，关注2，次级3，可疑4，损失5';
comment on column ${iol_schema}.icms_myjb_acc_loan3.cusid is '客户号';
comment on column ${iol_schema}.icms_myjb_acc_loan3.iswhite is '是否白名单';
comment on column ${iol_schema}.icms_myjb_acc_loan3.repaymode is '还款方式';
comment on column ${iol_schema}.icms_myjb_acc_loan3.ratetype is '利率类型';
comment on column ${iol_schema}.icms_myjb_acc_loan3.settledate is '会计日期，格式：YYYYMMdd';
comment on column ${iol_schema}.icms_myjb_acc_loan3.capoverduedays is '利息逾期天数';
comment on column ${iol_schema}.icms_myjb_acc_loan3.cusmgr is '客户经理';
comment on column ${iol_schema}.icms_myjb_acc_loan3.classifyresult is '五级分类标识(信贷)';
comment on column ${iol_schema}.icms_myjb_acc_loan3.start_dt is '开始时间';
comment on column ${iol_schema}.icms_myjb_acc_loan3.end_dt is '结束时间';
comment on column ${iol_schema}.icms_myjb_acc_loan3.id_mark is '增删标志';
comment on column ${iol_schema}.icms_myjb_acc_loan3.etl_timestamp is 'ETL处理时间戳';
