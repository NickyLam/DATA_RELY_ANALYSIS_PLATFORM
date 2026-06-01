/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_afterloan_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_afterloan_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_afterloan_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_afterloan_relative(
    balance number(24,6) -- 减免前本金汇总(本金汇总)
    ,classify varchar2(32) -- 本次资产分类
    ,completeflag varchar2(2) -- 完善标识
    ,disposalplan varchar2(3000) -- 处置计划及进展
    ,hangseqno varchar2(64) -- 挂账账户序列号(不良转让核心成功后返回，分期回款需要用到)
    ,inputdate date -- 登记时间
    ,inputorgid varchar2(64) -- 登记人所属机构
    ,inputuserid varchar2(64) -- 登记人
    ,lfbusinesssum number(24,6) -- 减免本金(正常本金)
    ,lfjtcompoundintratio number(24,8) -- 减免计提复利(计提复利)
    ,lfjtintamt number(24,6) -- 减免计提利息(计提利息)
    ,lfjtodpamt varchar2(22) -- 减免计提罚息(计提罚息)
    ,lfoverduebalance number(24,6) -- 减免逾期本金(逾期本金)
    ,lfserate number(24,6) -- 减免利率
    ,lfsjcompoundintratio number(24,8) -- 减免实欠复利(实欠复利)
    ,lfsjintamt number(24,6) -- 减免实欠利息(实欠利息)
    ,lfsqodpamt number(24,6) -- 减免实欠罚息(实欠罚息)
    ,loanstatus varchar2(4) -- 核算状态
    ,objecttype varchar2(48) -- 业务类型
    ,oldclassify varchar2(32) -- 上次资产分类
    ,propertyclue varchar2(3000) -- 资产线索
    ,relserialno varchar2(32) -- 关联流水号
    ,remark varchar2(3000) -- 其他需要说明的情况
    ,responsecode varchar2(2) -- 核心返回结果
    ,responsemessage varchar2(3000) -- 核心返回结果
    ,returnedaftermoney number(24,6) -- 本次回款后应收款金额
    ,returnedbeforemoney number(24,6) -- 本次回款前应收款金额
    ,returnedmoneysum number(24,6) -- 累计回款金额
    ,reversal varchar2(2) -- 冲正标识(冲正状态)
    ,serialno varchar2(32) -- 流水号
    ,ssjz varchar2(3000) -- 诉讼进展
    ,transferprice number(24,6) -- 分配转让价格
    ,transfersqprice number(24,6) -- 分配转让首期价格
    ,transferyskprice number(24,6) -- 分配转让应收款价格
    ,updatedate date -- 更新日期
    ,updateorgid varchar2(64) -- 更新机构
    ,updateuserid varchar2(64) -- 更新人
    ,wrnddfyamt number(24,6) -- 核销代垫费用
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
grant select on ${iol_schema}.icms_ap_afterloan_relative to ${iml_schema};
grant select on ${iol_schema}.icms_ap_afterloan_relative to ${icl_schema};
grant select on ${iol_schema}.icms_ap_afterloan_relative to ${idl_schema};
grant select on ${iol_schema}.icms_ap_afterloan_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_afterloan_relative is '资产保全（贷后）关联表';
comment on column ${iol_schema}.icms_ap_afterloan_relative.balance is '减免前本金汇总(本金汇总)';
comment on column ${iol_schema}.icms_ap_afterloan_relative.classify is '本次资产分类';
comment on column ${iol_schema}.icms_ap_afterloan_relative.completeflag is '完善标识';
comment on column ${iol_schema}.icms_ap_afterloan_relative.disposalplan is '处置计划及进展';
comment on column ${iol_schema}.icms_ap_afterloan_relative.hangseqno is '挂账账户序列号(不良转让核心成功后返回，分期回款需要用到)';
comment on column ${iol_schema}.icms_ap_afterloan_relative.inputdate is '登记时间';
comment on column ${iol_schema}.icms_ap_afterloan_relative.inputorgid is '登记人所属机构';
comment on column ${iol_schema}.icms_ap_afterloan_relative.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_afterloan_relative.lfbusinesssum is '减免本金(正常本金)';
comment on column ${iol_schema}.icms_ap_afterloan_relative.lfjtcompoundintratio is '减免计提复利(计提复利)';
comment on column ${iol_schema}.icms_ap_afterloan_relative.lfjtintamt is '减免计提利息(计提利息)';
comment on column ${iol_schema}.icms_ap_afterloan_relative.lfjtodpamt is '减免计提罚息(计提罚息)';
comment on column ${iol_schema}.icms_ap_afterloan_relative.lfoverduebalance is '减免逾期本金(逾期本金)';
comment on column ${iol_schema}.icms_ap_afterloan_relative.lfserate is '减免利率';
comment on column ${iol_schema}.icms_ap_afterloan_relative.lfsjcompoundintratio is '减免实欠复利(实欠复利)';
comment on column ${iol_schema}.icms_ap_afterloan_relative.lfsjintamt is '减免实欠利息(实欠利息)';
comment on column ${iol_schema}.icms_ap_afterloan_relative.lfsqodpamt is '减免实欠罚息(实欠罚息)';
comment on column ${iol_schema}.icms_ap_afterloan_relative.loanstatus is '核算状态';
comment on column ${iol_schema}.icms_ap_afterloan_relative.objecttype is '业务类型';
comment on column ${iol_schema}.icms_ap_afterloan_relative.oldclassify is '上次资产分类';
comment on column ${iol_schema}.icms_ap_afterloan_relative.propertyclue is '资产线索';
comment on column ${iol_schema}.icms_ap_afterloan_relative.relserialno is '关联流水号';
comment on column ${iol_schema}.icms_ap_afterloan_relative.remark is '其他需要说明的情况';
comment on column ${iol_schema}.icms_ap_afterloan_relative.responsecode is '核心返回结果';
comment on column ${iol_schema}.icms_ap_afterloan_relative.responsemessage is '核心返回结果';
comment on column ${iol_schema}.icms_ap_afterloan_relative.returnedaftermoney is '本次回款后应收款金额';
comment on column ${iol_schema}.icms_ap_afterloan_relative.returnedbeforemoney is '本次回款前应收款金额';
comment on column ${iol_schema}.icms_ap_afterloan_relative.returnedmoneysum is '累计回款金额';
comment on column ${iol_schema}.icms_ap_afterloan_relative.reversal is '冲正标识(冲正状态)';
comment on column ${iol_schema}.icms_ap_afterloan_relative.serialno is '流水号';
comment on column ${iol_schema}.icms_ap_afterloan_relative.ssjz is '诉讼进展';
comment on column ${iol_schema}.icms_ap_afterloan_relative.transferprice is '分配转让价格';
comment on column ${iol_schema}.icms_ap_afterloan_relative.transfersqprice is '分配转让首期价格';
comment on column ${iol_schema}.icms_ap_afterloan_relative.transferyskprice is '分配转让应收款价格';
comment on column ${iol_schema}.icms_ap_afterloan_relative.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_afterloan_relative.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_afterloan_relative.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_afterloan_relative.wrnddfyamt is '核销代垫费用';
comment on column ${iol_schema}.icms_ap_afterloan_relative.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_afterloan_relative.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_afterloan_relative.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_afterloan_relative.etl_timestamp is 'ETL处理时间戳';
