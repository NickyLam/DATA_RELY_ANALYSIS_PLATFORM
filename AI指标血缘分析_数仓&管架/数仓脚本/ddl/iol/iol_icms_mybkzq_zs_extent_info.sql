/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybkzq_zs_extent_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybkzq_zs_extent_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybkzq_zs_extent_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybkzq_zs_extent_info(
    serialno varchar2(32) -- 业务流水号
    ,injectid varchar2(64) -- 转让批次号
    ,drawndnseqno varchar2(64) -- 支用编号
    ,loantype varchar2(1000) -- 贷款类型
    ,loanusetype varchar2(64) -- 贷款用途
    ,assetclass varchar2(64) -- 贷款五级分类
    ,currencytype varchar2(64) -- 币种
    ,amt varchar2(64) -- 合同金额（元）
    ,bal varchar2(64) -- 贷款余额（元）
    ,inttype varchar2(64) -- 利率浮动方式
    ,intrate varchar2(64) -- 贷款利率（%）
    ,initrate varchar2(64) -- 初始利率（%）
    ,disbursedate varchar2(64) -- 贷款起息日
    ,duedate varchar2(64) -- 贷款到期日
    ,termnum varchar2(64) -- 贷款期限（月）
    ,reminddays varchar2(64) -- 贷款剩余期限（天）
    ,repaymodedesc varchar2(64) -- 贷款付息方式（个月/次）
    ,firstloandate varchar2(64) -- 用户首次贷款时间
    ,guaranteemethod varchar2(64) -- 担保方式
    ,guaranteeitem varchar2(64) -- 担保品
    ,creditbal varchar2(64) -- 单户授信（元）
    ,butype varchar2(64) -- 企业类型（债转特有）
    ,userage varchar2(64) -- 年龄
    ,riskseg varchar2(8) -- 风险分层
    ,repaymentseg varchar2(8) -- 偿债能力
    ,mobilefixedgrade varchar2(8) -- 手机号稳定等级
    ,adrstabilitygrade varchar2(8) -- 地址稳定等级
    ,devstabilitygrade varchar2(8) -- 最近六个月设备稳定等级
    ,totpayamt6mgrade varchar2(8) -- 最近六个月支付金额等级
    ,consumegrade varchar2(8) -- 消费档次
    ,profession varchar2(128) -- 职业信息
    ,bankcardnumber varchar2(128) -- 银行卡号
    ,depositbankname varchar2(128) -- 开户行名称
    ,last6mavgassettotalgrade varchar2(8) -- 最近六个月流动资产价值等级
    ,havecarprobgrade varchar2(8) -- 有车概率等级
    ,havefangprobgrade varchar2(8) -- 有房概率等级
    ,ovdordercnt6mgrade varchar2(8) -- 最近六个月逾期笔数等级
    ,ovdorderamt6mgrade varchar2(8) -- 最近六个月逾期金额等级
    ,ovdorderdays6mgrade varchar2(8) -- 最近六个月逾期天数等级
    ,positivebizcnt1ygrade varchar2(8) -- 最近一年履约等级
    ,repayamt6mgrade varchar2(8) -- 最近六个月还款金额等级
    ,firstloanlengthgrade varchar2(8) -- 信贷时长等级
    ,riskscore varchar2(8) -- 风险分数
    ,alilast6mtradetotal varchar2(4) -- 支付宝交易笔数
    ,baserepaymentseg varchar2(8) -- 综合基础偿债
    ,altrepaymentseg varchar2(8) -- 大额经营偿债
    ,liquidasset6mgrade varchar2(8) -- 近6个月流动资产价值等级
    ,haveaptprobgrade varchar2(8) -- 有房概况等级
    ,bizstartgrade varchar2(8) -- 经营时长
    ,bizstabilitygrade varchar2(8) -- 近6个月经营稳定性分层
    ,totpaycnt6mgrade varchar2(8) -- 近6个月交易笔数等级
    ,avgdaybal6mgrade varchar2(8) -- 近6个月日均余额
    ,gmtfirstbilllenthgrade varchar2(8) -- 信贷时长
    ,clrbillcnt1yrgrade varchar2(8) -- 近一年履约等级
    ,maxovddays6mgrade varchar2(8) -- 近6个月逾期天数等级
    ,maxovdbillamt6mgrade varchar2(8) -- 近6个月逾期金额等级
    ,starts varchar2(32) -- 开店日期
    ,countyid varchar2(32) -- 商户所属地区
    ,finishedvalidexlovamtrm6 varchar2(32) -- 过去6个月月均完成交易金额
    ,finishedvalidexlovamtrm12 varchar2(32) -- 过去12个月月均完成交易金额
    ,businessscene varchar2(64) -- 业务场景
    ,custipid varchar2(64) -- 借款人在网商的会员ID
    ,custiproleid varchar2(64) -- 借款人在网商的会员角色ID
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_mybkzq_zs_extent_info to ${iml_schema};
grant select on ${iol_schema}.icms_mybkzq_zs_extent_info to ${icl_schema};
grant select on ${iol_schema}.icms_mybkzq_zs_extent_info to ${idl_schema};
grant select on ${iol_schema}.icms_mybkzq_zs_extent_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybkzq_zs_extent_info is '网商贷债权直转终审扩展信息表';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.serialno is '业务流水号';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.injectid is '转让批次号';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.drawndnseqno is '支用编号';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.loantype is '贷款类型';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.loanusetype is '贷款用途';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.assetclass is '贷款五级分类';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.currencytype is '币种';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.amt is '合同金额（元）';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.bal is '贷款余额（元）';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.inttype is '利率浮动方式';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.intrate is '贷款利率（%）';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.initrate is '初始利率（%）';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.disbursedate is '贷款起息日';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.duedate is '贷款到期日';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.termnum is '贷款期限（月）';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.reminddays is '贷款剩余期限（天）';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.repaymodedesc is '贷款付息方式（个月/次）';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.firstloandate is '用户首次贷款时间';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.guaranteemethod is '担保方式';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.guaranteeitem is '担保品';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.creditbal is '单户授信（元）';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.butype is '企业类型（债转特有）';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.userage is '年龄';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.riskseg is '风险分层';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.repaymentseg is '偿债能力';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.mobilefixedgrade is '手机号稳定等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.adrstabilitygrade is '地址稳定等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.devstabilitygrade is '最近六个月设备稳定等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.totpayamt6mgrade is '最近六个月支付金额等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.consumegrade is '消费档次';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.profession is '职业信息';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.bankcardnumber is '银行卡号';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.depositbankname is '开户行名称';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.last6mavgassettotalgrade is '最近六个月流动资产价值等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.havecarprobgrade is '有车概率等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.havefangprobgrade is '有房概率等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.ovdordercnt6mgrade is '最近六个月逾期笔数等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.ovdorderamt6mgrade is '最近六个月逾期金额等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.ovdorderdays6mgrade is '最近六个月逾期天数等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.positivebizcnt1ygrade is '最近一年履约等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.repayamt6mgrade is '最近六个月还款金额等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.firstloanlengthgrade is '信贷时长等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.riskscore is '风险分数';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.alilast6mtradetotal is '支付宝交易笔数';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.baserepaymentseg is '综合基础偿债';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.altrepaymentseg is '大额经营偿债';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.liquidasset6mgrade is '近6个月流动资产价值等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.haveaptprobgrade is '有房概况等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.bizstartgrade is '经营时长';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.bizstabilitygrade is '近6个月经营稳定性分层';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.totpaycnt6mgrade is '近6个月交易笔数等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.avgdaybal6mgrade is '近6个月日均余额';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.gmtfirstbilllenthgrade is '信贷时长';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.clrbillcnt1yrgrade is '近一年履约等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.maxovddays6mgrade is '近6个月逾期天数等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.maxovdbillamt6mgrade is '近6个月逾期金额等级';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.starts is '开店日期';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.countyid is '商户所属地区';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.finishedvalidexlovamtrm6 is '过去6个月月均完成交易金额';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.finishedvalidexlovamtrm12 is '过去12个月月均完成交易金额';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.businessscene is '业务场景';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.custipid is '借款人在网商的会员ID';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.custiproleid is '借款人在网商的会员角色ID';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_mybkzq_zs_extent_info.etl_timestamp is 'ETL处理时间戳';
