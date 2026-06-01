/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_afterloan_creditcondition
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_afterloan_creditcondition
whenever sqlerror continue none;
drop table ${iol_schema}.icms_afterloan_creditcondition purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_afterloan_creditcondition(
    serialno varchar2(40) -- 流水号
    ,inputuserid varchar2(32) -- 登记人
    ,customerid varchar2(32) -- 借款人ID(信贷系统唯一标识)
    ,xqorgnum number(24,6) -- 发生信贷交易机构数(新增，对接二代征信)
    ,totalbalance number(24,6) -- 使用敞口余额
    ,updatedate date -- 更新日期
    ,overdueprincipal number(24,6) -- 逾期本金(新增，对接二代征信)
    ,berecoverbalance number(24,6) -- 被追偿业务余额（万元）(新增，对接二代征信)
    ,balance number(24,6) -- 授信余额
    ,otherduebusbalance number(24,6) -- 其他借贷交易余额（万元）(新增，对接二代征信)
    ,certid varchar2(32) -- 身份证号
    ,orgnum number(24,6) -- 授信机构数量（个）
    ,resourcechange varchar2(32) -- 他行授信策略变化情况
    ,inputorgid varchar2(32) -- 登记机构
    ,creditorgchange number(24,6) -- 借款人同业授信银行数变化
    ,certtype varchar2(4) -- 贷款证件类型
    ,otherloanwatchful number(24,6) -- 对外担保关注类余额（新增）
    ,otherloanharmful number(24,6) -- 对外担保不良类余额（新增）
    ,advancenum number(24,6) -- 垫款笔数(新增，对接二代征信)
    ,balancechange number(24,6) -- 授信余额变化情况
    ,inputdate varchar2(10) -- 登记日期
    ,watchfulbalance number(24,6) -- 关注余额
    ,overduebalance number(24,6) -- 欠息余额(含：逾期、垫款、欠息)
    ,customertype varchar2(10) -- 借款人类型
    ,reportno varchar2(80) -- 报告编号
    ,businesssumable number(24,6) -- 剩余可用授信额度（新增）
    ,duebusbalance number(24,6) -- 借贷交易被追偿余额（万元）(新增，对接二代征信)
    ,loanflag varchar2(18) -- 贷款卡状态
    ,businesssum number(24,6) -- 授信额度
    ,classifyresult varchar2(20) -- 最低五级分类
    ,loancardno varchar2(32) -- 贷款卡号
    ,classifyflit varchar2(2000) -- 他行五级分类迁徙情况
    ,otherloanassureamount number(24,6) -- 对外担保金额
    ,advancebalance number(24,6) -- 垫款余额(新增，对接二代征信)
    ,mfcustomerid varchar2(40) -- 核心客户号
    ,disposalbalance number(24,6) -- 由资产管理公司处置余额(新增，对接二代征信)
    ,customername varchar2(100) -- 借款人名称
    ,harmfulbalance number(24,6) -- 不良余额
    ,querydate varchar2(10) -- 查询日期
    ,guabusbalance number(24,6) -- 担保交易余额（万元）(新增，对接二代征信)
    ,adoverduebalance number(24,6) -- 逾期利息(新增，对接二代征信)
    ,hpncrlntxnsinstnum number(24,6) -- 逾期利息(新增，对接二代征信)
    ,crnotclsglninstnum number(24,6) -- 逾期利息(新增，对接二代征信)
    ,dbtcrtxnbal number(24,6) -- 逾期利息(新增，对接二代征信)
    ,berecsdbtcrtxnbal number(24,6) -- 逾期利息(新增，对接二代征信)
    ,wrnttxnbalbal number(24,6) -- 逾期利息(新增，对接二代征信)
    ,astdspbsnbal number(24,6) -- 逾期利息(新增，对接二代征信)
    ,adcshbsnacc number(24,6) -- 逾期利息(新增，对接二代征信)
    ,adcshbsnbal number(24,6) -- 逾期利息(新增，对接二代征信)
    ,curoduepnp number(24,6) -- 逾期利息(新增，对接二代征信)
    ,odinadoth number(24,6) -- 逾期利息(新增，对接二代征信)
    ,berecbaltot number(24,6) -- 逾期利息(新增，对接二代征信)
    ,othrdbtcrtnacbal number(24,6) -- 逾期利息(新增，对接二代征信)
    ,bal number(24,6) -- 逾期利息(新增，对接二代征信)
    ,migtflag varchar2(80) -- 迁移标志
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
grant select on ${iol_schema}.icms_afterloan_creditcondition to ${iml_schema};
grant select on ${iol_schema}.icms_afterloan_creditcondition to ${icl_schema};
grant select on ${iol_schema}.icms_afterloan_creditcondition to ${idl_schema};
grant select on ${iol_schema}.icms_afterloan_creditcondition to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_afterloan_creditcondition is '借款人授信情况表';
comment on column ${iol_schema}.icms_afterloan_creditcondition.serialno is '流水号';
comment on column ${iol_schema}.icms_afterloan_creditcondition.inputuserid is '登记人';
comment on column ${iol_schema}.icms_afterloan_creditcondition.customerid is '借款人ID(信贷系统唯一标识)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.xqorgnum is '发生信贷交易机构数(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.totalbalance is '使用敞口余额';
comment on column ${iol_schema}.icms_afterloan_creditcondition.updatedate is '更新日期';
comment on column ${iol_schema}.icms_afterloan_creditcondition.overdueprincipal is '逾期本金(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.berecoverbalance is '被追偿业务余额（万元）(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.balance is '授信余额';
comment on column ${iol_schema}.icms_afterloan_creditcondition.otherduebusbalance is '其他借贷交易余额（万元）(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.certid is '身份证号';
comment on column ${iol_schema}.icms_afterloan_creditcondition.orgnum is '授信机构数量（个）';
comment on column ${iol_schema}.icms_afterloan_creditcondition.resourcechange is '他行授信策略变化情况';
comment on column ${iol_schema}.icms_afterloan_creditcondition.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_afterloan_creditcondition.creditorgchange is '借款人同业授信银行数变化';
comment on column ${iol_schema}.icms_afterloan_creditcondition.certtype is '贷款证件类型';
comment on column ${iol_schema}.icms_afterloan_creditcondition.otherloanwatchful is '对外担保关注类余额（新增）';
comment on column ${iol_schema}.icms_afterloan_creditcondition.otherloanharmful is '对外担保不良类余额（新增）';
comment on column ${iol_schema}.icms_afterloan_creditcondition.advancenum is '垫款笔数(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.balancechange is '授信余额变化情况';
comment on column ${iol_schema}.icms_afterloan_creditcondition.inputdate is '登记日期';
comment on column ${iol_schema}.icms_afterloan_creditcondition.watchfulbalance is '关注余额';
comment on column ${iol_schema}.icms_afterloan_creditcondition.overduebalance is '欠息余额(含：逾期、垫款、欠息)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.customertype is '借款人类型';
comment on column ${iol_schema}.icms_afterloan_creditcondition.reportno is '报告编号';
comment on column ${iol_schema}.icms_afterloan_creditcondition.businesssumable is '剩余可用授信额度（新增）';
comment on column ${iol_schema}.icms_afterloan_creditcondition.duebusbalance is '借贷交易被追偿余额（万元）(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.loanflag is '贷款卡状态';
comment on column ${iol_schema}.icms_afterloan_creditcondition.businesssum is '授信额度';
comment on column ${iol_schema}.icms_afterloan_creditcondition.classifyresult is '最低五级分类';
comment on column ${iol_schema}.icms_afterloan_creditcondition.loancardno is '贷款卡号';
comment on column ${iol_schema}.icms_afterloan_creditcondition.classifyflit is '他行五级分类迁徙情况';
comment on column ${iol_schema}.icms_afterloan_creditcondition.otherloanassureamount is '对外担保金额';
comment on column ${iol_schema}.icms_afterloan_creditcondition.advancebalance is '垫款余额(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.mfcustomerid is '核心客户号';
comment on column ${iol_schema}.icms_afterloan_creditcondition.disposalbalance is '由资产管理公司处置余额(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.customername is '借款人名称';
comment on column ${iol_schema}.icms_afterloan_creditcondition.harmfulbalance is '不良余额';
comment on column ${iol_schema}.icms_afterloan_creditcondition.querydate is '查询日期';
comment on column ${iol_schema}.icms_afterloan_creditcondition.guabusbalance is '担保交易余额（万元）(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.adoverduebalance is '逾期利息(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.hpncrlntxnsinstnum is '逾期利息(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.crnotclsglninstnum is '逾期利息(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.dbtcrtxnbal is '逾期利息(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.berecsdbtcrtxnbal is '逾期利息(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.wrnttxnbalbal is '逾期利息(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.astdspbsnbal is '逾期利息(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.adcshbsnacc is '逾期利息(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.adcshbsnbal is '逾期利息(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.curoduepnp is '逾期利息(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.odinadoth is '逾期利息(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.berecbaltot is '逾期利息(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.othrdbtcrtnacbal is '逾期利息(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.bal is '逾期利息(新增，对接二代征信)';
comment on column ${iol_schema}.icms_afterloan_creditcondition.migtflag is '迁移标志';
comment on column ${iol_schema}.icms_afterloan_creditcondition.start_dt is '开始时间';
comment on column ${iol_schema}.icms_afterloan_creditcondition.end_dt is '结束时间';
comment on column ${iol_schema}.icms_afterloan_creditcondition.id_mark is '增删标志';
comment on column ${iol_schema}.icms_afterloan_creditcondition.etl_timestamp is 'ETL处理时间戳';
