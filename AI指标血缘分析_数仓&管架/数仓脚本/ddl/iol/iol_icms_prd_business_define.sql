/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_prd_business_define
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_prd_business_define
whenever sqlerror continue none;
drop table ${iol_schema}.icms_prd_business_define purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_business_define(
    productid varchar2(12) -- 可售产品编号
    ,graceperiod number(38,0) -- 宽限期
    ,maxbusinesssum number(24,6) -- 自动放款最大金额
    ,rateeffecttype varchar2(10) -- 利率生效方式
    ,isfinterest varchar2(10) -- 是否收罚息
    ,guarcontractrelate varchar2(10) -- 保函与基础合同的关系
    ,newproductname varchar2(200) -- 产品名称
    ,maxloanterm number(38,0) -- 最长贷款期限(月)
    ,ratechangecycle varchar2(10) -- 利率变更周期
    ,isassociatebail varchar2(10) -- 是否关联保证金
    ,issupprepayment varchar2(10) -- 是否支持提前还款
    ,increasegrantapprove varchar2(10) -- 增量发放审批
    ,oldproductid varchar2(32) -- 产品代码
    ,singlegrant varchar2(10) -- 单笔发放
    ,isassets varchar2(10) -- 是否资产证券化
    ,inputuserid varchar2(32) -- 登记人
    ,inputdate date -- 登记日期
    ,backflag varchar2(10) -- 自动回收标志
    ,guaradvanceproduct varchar2(500) -- 保函垫款产品
    ,onceminpaymentflag number(24,6) -- 单次最小发放金额(元)
    ,waivedautopayflag varchar2(10) -- 持续扣款标志
    ,acceptinttype varchar2(10) -- 前收息标识
    ,domesticoroverseas varchar2(32) -- 境内境外
    ,customertype varchar2(32) -- 客户类型
    ,termmonthflag varchar2(10) -- 贷款期限控制标识
    ,updateuserid varchar2(32) -- 更新人
    ,updatedate date -- 更新日期
    ,isopenautofreezebail varchar2(10) -- 开立时是否自动冻结保证金
    ,updateorgid varchar2(32) -- 更新机构
    ,industrytype varchar2(500) -- 客户所属行业
    ,isautoputoutregister varchar2(10) -- 是否自动出账登记
    ,isgrantapproveflag varchar2(10) -- 发放是否允许审批标识
    ,ictype varchar2(10) -- 计息标志
    ,ratetype varchar2(500) -- 利率启用方式
    ,compoundintflag varchar2(10) -- 是否收复利
    ,overdueclaimsdays number(38,0) -- 逾期理赔天数
    ,isautopayment varchar2(10) -- 是否自动受托支付
    ,claimsraio number(24,6) -- 理赔比例
    ,expirydate date -- 产品失效日期
    ,maxyearrate number(24,6) -- 最大年化利率
    ,sinosurename varchar2(80) -- 受托支付账户名称
    ,minloanterm number(38,0) -- 最短贷款期限(月)
    ,maxextendcount number(4,0) -- 展期最大次数
    ,effectivedate date -- 产品生效日期
    ,maxissuecount number(38,0) -- 最大缩期次数
    ,newproductid varchar2(32) -- 新产品代码
    ,sinosureaccount varchar2(32) -- 受托支付账户
    ,currency varchar2(500) -- 币种
    ,propietaryflag varchar2(10) -- 自营标志
    ,isexpireautounfreezebail varchar2(10) -- 到期是否自动解冻保证金
    ,hostbanknature varchar2(87) -- 银团贷款性质
    ,assettrandflag varchar2(10) -- 是否资产转让
    ,accounttype varchar2(32) -- 账户类型
    ,borrowaccountcheck varchar2(10) -- 借款人账户检查
    ,inputorgid varchar2(32) -- 登记机构
    ,mincreditterm number(38,0) -- 额度最小期限
    ,guarattribute varchar2(10) -- 保函属性
    ,customerlevel varchar2(32) -- 最低客户评级
    ,prepayamt varchar2(10) -- 还款金额控制
    ,installmentsmenthod varchar2(50) -- 可选还款方式
    ,compountinterest varchar2(10) -- 复利的复利
    ,isissue varchar2(10) -- 是否允许缩期
    ,cycleflag varchar2(10) -- 是否循环
    ,oncepaymentflag varchar2(10) -- 单次发放金额控制标识
    ,isextend varchar2(10) -- 是否允许展期
    ,minyearrate number(24,6) -- 最小年化利率
    ,issuponlineputout varchar2(10) -- 是否支持线上放款申请
    ,productname varchar2(200) -- 产品名称
    ,vouchtype varchar2(33) -- 可选担保方式
    ,isautorecheckputout varchar2(10) -- 是否自动复核放款
    ,discounttype varchar2(32) -- 贴现贷款类型
    ,istakebackautounfreezebail varchar2(10) -- 收回时是否自动解冻保证金
    ,oncemaxpaymentflag number(24,6) -- 单次最大发放金额(元)
    ,iswaivedcomp varchar2(10) -- 罚息的复利
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
grant select on ${iol_schema}.icms_prd_business_define to ${iml_schema};
grant select on ${iol_schema}.icms_prd_business_define to ${icl_schema};
grant select on ${iol_schema}.icms_prd_business_define to ${idl_schema};
grant select on ${iol_schema}.icms_prd_business_define to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_prd_business_define is '产品附属表';
comment on column ${iol_schema}.icms_prd_business_define.productid is '可售产品编号';
comment on column ${iol_schema}.icms_prd_business_define.graceperiod is '宽限期';
comment on column ${iol_schema}.icms_prd_business_define.maxbusinesssum is '自动放款最大金额';
comment on column ${iol_schema}.icms_prd_business_define.rateeffecttype is '利率生效方式';
comment on column ${iol_schema}.icms_prd_business_define.isfinterest is '是否收罚息';
comment on column ${iol_schema}.icms_prd_business_define.guarcontractrelate is '保函与基础合同的关系';
comment on column ${iol_schema}.icms_prd_business_define.newproductname is '产品名称';
comment on column ${iol_schema}.icms_prd_business_define.maxloanterm is '最长贷款期限(月)';
comment on column ${iol_schema}.icms_prd_business_define.ratechangecycle is '利率变更周期';
comment on column ${iol_schema}.icms_prd_business_define.isassociatebail is '是否关联保证金';
comment on column ${iol_schema}.icms_prd_business_define.issupprepayment is '是否支持提前还款';
comment on column ${iol_schema}.icms_prd_business_define.increasegrantapprove is '增量发放审批';
comment on column ${iol_schema}.icms_prd_business_define.oldproductid is '产品代码';
comment on column ${iol_schema}.icms_prd_business_define.singlegrant is '单笔发放';
comment on column ${iol_schema}.icms_prd_business_define.isassets is '是否资产证券化';
comment on column ${iol_schema}.icms_prd_business_define.inputuserid is '登记人';
comment on column ${iol_schema}.icms_prd_business_define.inputdate is '登记日期';
comment on column ${iol_schema}.icms_prd_business_define.backflag is '自动回收标志';
comment on column ${iol_schema}.icms_prd_business_define.guaradvanceproduct is '保函垫款产品';
comment on column ${iol_schema}.icms_prd_business_define.onceminpaymentflag is '单次最小发放金额(元)';
comment on column ${iol_schema}.icms_prd_business_define.waivedautopayflag is '持续扣款标志';
comment on column ${iol_schema}.icms_prd_business_define.acceptinttype is '前收息标识';
comment on column ${iol_schema}.icms_prd_business_define.domesticoroverseas is '境内境外';
comment on column ${iol_schema}.icms_prd_business_define.customertype is '客户类型';
comment on column ${iol_schema}.icms_prd_business_define.termmonthflag is '贷款期限控制标识';
comment on column ${iol_schema}.icms_prd_business_define.updateuserid is '更新人';
comment on column ${iol_schema}.icms_prd_business_define.updatedate is '更新日期';
comment on column ${iol_schema}.icms_prd_business_define.isopenautofreezebail is '开立时是否自动冻结保证金';
comment on column ${iol_schema}.icms_prd_business_define.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_prd_business_define.industrytype is '客户所属行业';
comment on column ${iol_schema}.icms_prd_business_define.isautoputoutregister is '是否自动出账登记';
comment on column ${iol_schema}.icms_prd_business_define.isgrantapproveflag is '发放是否允许审批标识';
comment on column ${iol_schema}.icms_prd_business_define.ictype is '计息标志';
comment on column ${iol_schema}.icms_prd_business_define.ratetype is '利率启用方式';
comment on column ${iol_schema}.icms_prd_business_define.compoundintflag is '是否收复利';
comment on column ${iol_schema}.icms_prd_business_define.overdueclaimsdays is '逾期理赔天数';
comment on column ${iol_schema}.icms_prd_business_define.isautopayment is '是否自动受托支付';
comment on column ${iol_schema}.icms_prd_business_define.claimsraio is '理赔比例';
comment on column ${iol_schema}.icms_prd_business_define.expirydate is '产品失效日期';
comment on column ${iol_schema}.icms_prd_business_define.maxyearrate is '最大年化利率';
comment on column ${iol_schema}.icms_prd_business_define.sinosurename is '受托支付账户名称';
comment on column ${iol_schema}.icms_prd_business_define.minloanterm is '最短贷款期限(月)';
comment on column ${iol_schema}.icms_prd_business_define.maxextendcount is '展期最大次数';
comment on column ${iol_schema}.icms_prd_business_define.effectivedate is '产品生效日期';
comment on column ${iol_schema}.icms_prd_business_define.maxissuecount is '最大缩期次数';
comment on column ${iol_schema}.icms_prd_business_define.newproductid is '新产品代码';
comment on column ${iol_schema}.icms_prd_business_define.sinosureaccount is '受托支付账户';
comment on column ${iol_schema}.icms_prd_business_define.currency is '币种';
comment on column ${iol_schema}.icms_prd_business_define.propietaryflag is '自营标志';
comment on column ${iol_schema}.icms_prd_business_define.isexpireautounfreezebail is '到期是否自动解冻保证金';
comment on column ${iol_schema}.icms_prd_business_define.hostbanknature is '银团贷款性质';
comment on column ${iol_schema}.icms_prd_business_define.assettrandflag is '是否资产转让';
comment on column ${iol_schema}.icms_prd_business_define.accounttype is '账户类型';
comment on column ${iol_schema}.icms_prd_business_define.borrowaccountcheck is '借款人账户检查';
comment on column ${iol_schema}.icms_prd_business_define.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_prd_business_define.mincreditterm is '额度最小期限';
comment on column ${iol_schema}.icms_prd_business_define.guarattribute is '保函属性';
comment on column ${iol_schema}.icms_prd_business_define.customerlevel is '最低客户评级';
comment on column ${iol_schema}.icms_prd_business_define.prepayamt is '还款金额控制';
comment on column ${iol_schema}.icms_prd_business_define.installmentsmenthod is '可选还款方式';
comment on column ${iol_schema}.icms_prd_business_define.compountinterest is '复利的复利';
comment on column ${iol_schema}.icms_prd_business_define.isissue is '是否允许缩期';
comment on column ${iol_schema}.icms_prd_business_define.cycleflag is '是否循环';
comment on column ${iol_schema}.icms_prd_business_define.oncepaymentflag is '单次发放金额控制标识';
comment on column ${iol_schema}.icms_prd_business_define.isextend is '是否允许展期';
comment on column ${iol_schema}.icms_prd_business_define.minyearrate is '最小年化利率';
comment on column ${iol_schema}.icms_prd_business_define.issuponlineputout is '是否支持线上放款申请';
comment on column ${iol_schema}.icms_prd_business_define.productname is '产品名称';
comment on column ${iol_schema}.icms_prd_business_define.vouchtype is '可选担保方式';
comment on column ${iol_schema}.icms_prd_business_define.isautorecheckputout is '是否自动复核放款';
comment on column ${iol_schema}.icms_prd_business_define.discounttype is '贴现贷款类型';
comment on column ${iol_schema}.icms_prd_business_define.istakebackautounfreezebail is '收回时是否自动解冻保证金';
comment on column ${iol_schema}.icms_prd_business_define.oncemaxpaymentflag is '单次最大发放金额(元)';
comment on column ${iol_schema}.icms_prd_business_define.iswaivedcomp is '罚息的复利';
comment on column ${iol_schema}.icms_prd_business_define.start_dt is '开始时间';
comment on column ${iol_schema}.icms_prd_business_define.end_dt is '结束时间';
comment on column ${iol_schema}.icms_prd_business_define.id_mark is '增删标志';
comment on column ${iol_schema}.icms_prd_business_define.etl_timestamp is 'ETL处理时间戳';
