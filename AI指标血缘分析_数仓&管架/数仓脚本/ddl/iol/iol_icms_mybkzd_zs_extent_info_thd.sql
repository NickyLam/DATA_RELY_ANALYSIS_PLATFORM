/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybkzd_zs_extent_info_thd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybkzd_zs_extent_info_thd
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybkzd_zs_extent_info_thd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybkzd_zs_extent_info_thd(
    serialno varchar2(108) -- 信贷流水号
    ,riskseg varchar2(24) -- 风险等级
    ,repaymentseg varchar2(24) -- 偿债能力
    ,mobilefixedgrade varchar2(24) -- 经营者手机号稳定性等级(手机号稳定等级)
    ,adrstabilitygrade varchar2(24) -- 经营者地址稳定性等级(地址稳定等级)
    ,devstabilitygrade varchar2(24) -- 经营者设备稳定性等级(最近六个月设备稳定等级)
    ,totpayamt6mgrade varchar2(24) -- 近6个月交易金额等级(最近六个月支付金额等级)
    ,profession varchar2(768) -- 职业信息
    ,bankcardnumber varchar2(384) -- 银行卡号
    ,depositbankname varchar2(384) -- 开户行名称
    ,last6mavgassettotalgrade varchar2(24) -- 最近六个月流动资产价值等级
    ,havecarprobgrade varchar2(24) -- 有车概率等级
    ,havefangprobgrade varchar2(24) -- 有房概率等级
    ,ovdordercnt6mgrade varchar2(24) -- 最近六个月逾期笔数等级
    ,ovdorderamt6mgrade varchar2(24) -- 最近六个月逾期金额等级
    ,ovdorderdays6mgrade varchar2(24) -- 最近六个月逾期天数等级
    ,positivebizcnt1ygrade varchar2(24) -- 最近一年履约等级
    ,repayamt6mgrade varchar2(24) -- 近6个月还款金额等级(最近六个月还款金额等级)
    ,firstloanlengthgrade varchar2(24) -- 信贷时长等级
    ,riskscore varchar2(24) -- 风险分数
    ,alilast6mtradetotal varchar2(12) -- 支付宝交易笔数
    ,custid varchar2(384) -- 客户编码
    ,corecustname varchar2(3072) -- 核心企业名称
    ,corecustid varchar2(384) -- 核心企业统一社会信用代码证
    ,custname varchar2(3072) -- 经销商名称
    ,custcoopmonth varchar2(192) -- 合作月数
    ,custfrcode varchar2(192) -- 经销商法定代表人身份证件号
    ,custtotalresamtly varchar2(384) -- T-1年采购任务
    ,custamountlist varchar2(3072) -- 采购金额月份
    ,operationalcapgrade varchar2(24) -- 营运能力分层
    ,supplychainmgtgrade varchar2(24) -- 供应链管理分层
    ,custsegsmffinal varchar2(192) -- 采购贷客户分层
    ,smfrepaymentseg varchar2(192) -- 采购贷新偿债能力分层
    ,risksmffinal varchar2(192) -- 采购贷风险分层
    ,baserepaymentseg varchar2(24) -- 综合基础偿债
    ,altrepaymentseg varchar2(24) -- 大额经营偿债
    ,liquidasset6mgrade varchar2(24) -- 近6个月流动资产价值等级
    ,haveaptprobgrade varchar2(24) -- 有房概况等级
    ,bizstartgrade varchar2(24) -- 经营时长
    ,bizstabilitygrade varchar2(24) -- 近6个月经营稳定性分层
    ,totpaycnt6mgrade varchar2(24) -- 近6个月交易笔数等级
    ,avgdaybal6mgrade varchar2(24) -- 近6个月日均余额
    ,gmtfirstbilllenthgrade varchar2(24) -- 信贷时长
    ,clrbillcnt1yrgrade varchar2(24) -- 近一年履约等级
    ,maxovddays6mgrade varchar2(24) -- 近6个月逾期天数等级
    ,maxovdbillamt6mgrade varchar2(24) -- 近6个月逾期金额等级
    ,starts varchar2(96) -- 开店日期
    ,countyid varchar2(96) -- 商户所属地区
    ,finishedvalidexlovamtrm6 varchar2(96) -- 过去6个月月均完成交易金额
    ,finishedvalidexlovamtr12 varchar2(192) -- 过去12个月月均完成交易金额
    ,personalcreditreport varchar2(108) -- 个人征信信息
    ,businesstag varchar2(192) -- 业务标识
    ,businessscene varchar2(192) -- 业务场景
    ,custipid varchar2(192) -- 借款人在网商的会员ID
    ,custiproleid varchar2(192) -- 借款人在网商的会员角色ID
    ,lssuingauthority varchar2(384) -- 发证机关(身份证)
    ,issuedate varchar2(96) -- 证件签发日期(身份证)
    ,platformadmitlimit varchar2(64) -- 建议授信额度上限
    ,totaladmitlimit varchar2(64) -- 人维度总授信额度
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
grant select on ${iol_schema}.icms_mybkzd_zs_extent_info_thd to ${iml_schema};
grant select on ${iol_schema}.icms_mybkzd_zs_extent_info_thd to ${icl_schema};
grant select on ${iol_schema}.icms_mybkzd_zs_extent_info_thd to ${idl_schema};
grant select on ${iol_schema}.icms_mybkzd_zs_extent_info_thd to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybkzd_zs_extent_info_thd is '网商贷助贷终审扩展信息';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.serialno is '信贷流水号';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.riskseg is '风险等级';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.repaymentseg is '偿债能力';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.mobilefixedgrade is '经营者手机号稳定性等级(手机号稳定等级)';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.adrstabilitygrade is '经营者地址稳定性等级(地址稳定等级)';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.devstabilitygrade is '经营者设备稳定性等级(最近六个月设备稳定等级)';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.totpayamt6mgrade is '近6个月交易金额等级(最近六个月支付金额等级)';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.profession is '职业信息';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.bankcardnumber is '银行卡号';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.depositbankname is '开户行名称';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.last6mavgassettotalgrade is '最近六个月流动资产价值等级';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.havecarprobgrade is '有车概率等级';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.havefangprobgrade is '有房概率等级';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.ovdordercnt6mgrade is '最近六个月逾期笔数等级';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.ovdorderamt6mgrade is '最近六个月逾期金额等级';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.ovdorderdays6mgrade is '最近六个月逾期天数等级';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.positivebizcnt1ygrade is '最近一年履约等级';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.repayamt6mgrade is '近6个月还款金额等级(最近六个月还款金额等级)';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.firstloanlengthgrade is '信贷时长等级';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.riskscore is '风险分数';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.alilast6mtradetotal is '支付宝交易笔数';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.custid is '客户编码';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.corecustname is '核心企业名称';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.corecustid is '核心企业统一社会信用代码证';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.custname is '经销商名称';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.custcoopmonth is '合作月数';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.custfrcode is '经销商法定代表人身份证件号';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.custtotalresamtly is 'T-1年采购任务';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.custamountlist is '采购金额月份';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.operationalcapgrade is '营运能力分层';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.supplychainmgtgrade is '供应链管理分层';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.custsegsmffinal is '采购贷客户分层';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.smfrepaymentseg is '采购贷新偿债能力分层';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.risksmffinal is '采购贷风险分层';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.baserepaymentseg is '综合基础偿债';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.altrepaymentseg is '大额经营偿债';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.liquidasset6mgrade is '近6个月流动资产价值等级';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.haveaptprobgrade is '有房概况等级';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.bizstartgrade is '经营时长';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.bizstabilitygrade is '近6个月经营稳定性分层';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.totpaycnt6mgrade is '近6个月交易笔数等级';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.avgdaybal6mgrade is '近6个月日均余额';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.gmtfirstbilllenthgrade is '信贷时长';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.clrbillcnt1yrgrade is '近一年履约等级';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.maxovddays6mgrade is '近6个月逾期天数等级';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.maxovdbillamt6mgrade is '近6个月逾期金额等级';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.starts is '开店日期';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.countyid is '商户所属地区';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.finishedvalidexlovamtrm6 is '过去6个月月均完成交易金额';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.finishedvalidexlovamtr12 is '过去12个月月均完成交易金额';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.personalcreditreport is '个人征信信息';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.businesstag is '业务标识';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.businessscene is '业务场景';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.custipid is '借款人在网商的会员ID';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.custiproleid is '借款人在网商的会员角色ID';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.lssuingauthority is '发证机关(身份证)';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.issuedate is '证件签发日期(身份证)';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.platformadmitlimit is '建议授信额度上限';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.totaladmitlimit is '人维度总授信额度';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.start_dt is '开始时间';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.end_dt is '结束时间';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.id_mark is '增删标志';
comment on column ${iol_schema}.icms_mybkzd_zs_extent_info_thd.etl_timestamp is 'ETL处理时间戳';
