/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_finance_batch_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_finance_batch_record
whenever sqlerror continue none;
drop table ${iol_schema}.icms_finance_batch_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_finance_batch_record(
    serialno varchar2(64) -- 流水号
    ,baserialno varchar2(64) -- 关联子授信编号
    ,objectno varchar2(64) -- 关联主授信编号
    ,ftserialno varchar2(64) -- 流程表流水号
    ,objecttype varchar2(64) -- 关联类型
    ,customerid varchar2(64) -- 客户编号
    ,productid varchar2(64) -- 产品编号
    ,businesscurrency varchar2(64) -- 币种
    ,occurtype varchar2(10) -- 发生方式
    ,exposuresum number(24,6) -- 敞口金额
    ,businesssum number(24,6) -- 额度金额
    ,termmonth number(38,0) -- 期限月
    ,iscycle varchar2(5) -- 是否循环
    ,isagree varchar2(5) -- 是否同意
    ,issure varchar2(5) -- 是否确认
    ,remark varchar2(4000) -- 备注
    ,inputorgid varchar2(64) -- 登记机构
    ,inputuserid varchar2(64) -- 登记人
    ,updateorgid varchar2(64) -- 更新机构
    ,updateuserid varchar2(64) -- 更新人
    ,inputdate date -- 登记时间
    ,updatedate date -- 更新时间
    ,issignificantnegativeinformation varchar2(2) -- 是否有重大负面信息
    ,iscontrollerchanged varchar2(2) -- 是否有重大负面信息
    ,israterisklevellower varchar2(8) -- 评级是否下调
    ,revenuescale varchar2(8) -- 营收规模
    ,profitability varchar2(8) -- 盈利能力
    ,operationcapability varchar2(8) -- 运营能力
    ,rigidliabilities varchar2(8) -- 刚性负债
    ,netoperatingcashflow varchar2(8) -- 经营性净现金流
    ,bdbusinesssum number(24,6) -- 借据额度金额
    ,enttype varchar2(64) -- 企业性质
    ,raterisklevel varchar2(8) -- 近期主体评级
    ,onlineamount number(24,6) -- 线上额度
    ,isexistsrisk varchar2(10) -- 是否存在其他重大风险
    ,isbusinesschange varchar2(10) -- 经营情况是否发生重大变化
    ,searchstatus varchar2(10) -- 查询外部数据状态
    ,searcherrorreason varchar2(4000) -- 查询外部数据异常原因
    ,searchdate date -- 外部数据日期
    ,othersum number(24,6) -- 其他有效授信
    ,singlecustomersum number(24,6) -- 单一客户管理限额
    ,belonggroupname varchar2(80) -- 归属集团（行内集团）
    ,nominalamount number(24,6) -- 集团管理额度
    ,grouprelationshipcheckresult varchar2(3000) -- 集团关系探测结果
    ,atualcontroller varchar2(1000) -- 实际控制人
    ,isshareholderchange varchar2(10) -- 控股股东是否发生变化
    ,newratingprospect varchar2(3000) -- 最新一期评级展望
    ,isissuebondschange varchar2(10) -- 近一年是否新发行债券
    ,isincomechange varchar2(10) -- 收入构成是否发生重大变化
    ,isnegativeinformationcheck varchar2(10) -- 是否命中负面信息校验
    ,isdefaultexist varchar2(10) -- 是否存在非标违约
    ,iscomticketoverdueexist varchar2(10) -- 是否存在商票逾期
    ,negativeinfo varchar2(3000) -- 负面信息说明
    ,issignificantnegativeinfomation varchar2(2) -- 是否有重大负面信息
    ,outgroupname varchar2(80) -- 外部集团
    ,negativeshow varchar2(1000) -- 负面信息
    ,newopiniondate varchar2(10) -- 最近一期审计意见时间
    ,newopinion varchar2(32) -- 最近一期审计意见
    ,isredeem varchar2(1) -- 是否未赎回二级资本债或永续债
    ,annualauditbusinesssum number(24,6) -- 年审核定额度
    ,annualauditexposuresum number(24,6) -- 年审核定敞口金额
    ,isyeartocheck varchar2(1) -- 是否年审
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
grant select on ${iol_schema}.icms_finance_batch_record to ${iml_schema};
grant select on ${iol_schema}.icms_finance_batch_record to ${icl_schema};
grant select on ${iol_schema}.icms_finance_batch_record to ${idl_schema};
grant select on ${iol_schema}.icms_finance_batch_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_finance_batch_record is '同业主动批量授信过程表';
comment on column ${iol_schema}.icms_finance_batch_record.serialno is '流水号';
comment on column ${iol_schema}.icms_finance_batch_record.baserialno is '关联子授信编号';
comment on column ${iol_schema}.icms_finance_batch_record.objectno is '关联主授信编号';
comment on column ${iol_schema}.icms_finance_batch_record.ftserialno is '流程表流水号';
comment on column ${iol_schema}.icms_finance_batch_record.objecttype is '关联类型';
comment on column ${iol_schema}.icms_finance_batch_record.customerid is '客户编号';
comment on column ${iol_schema}.icms_finance_batch_record.productid is '产品编号';
comment on column ${iol_schema}.icms_finance_batch_record.businesscurrency is '币种';
comment on column ${iol_schema}.icms_finance_batch_record.occurtype is '发生方式';
comment on column ${iol_schema}.icms_finance_batch_record.exposuresum is '敞口金额';
comment on column ${iol_schema}.icms_finance_batch_record.businesssum is '额度金额';
comment on column ${iol_schema}.icms_finance_batch_record.termmonth is '期限月';
comment on column ${iol_schema}.icms_finance_batch_record.iscycle is '是否循环';
comment on column ${iol_schema}.icms_finance_batch_record.isagree is '是否同意';
comment on column ${iol_schema}.icms_finance_batch_record.issure is '是否确认';
comment on column ${iol_schema}.icms_finance_batch_record.remark is '备注';
comment on column ${iol_schema}.icms_finance_batch_record.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_finance_batch_record.inputuserid is '登记人';
comment on column ${iol_schema}.icms_finance_batch_record.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_finance_batch_record.updateuserid is '更新人';
comment on column ${iol_schema}.icms_finance_batch_record.inputdate is '登记时间';
comment on column ${iol_schema}.icms_finance_batch_record.updatedate is '更新时间';
comment on column ${iol_schema}.icms_finance_batch_record.issignificantnegativeinformation is '是否有重大负面信息';
comment on column ${iol_schema}.icms_finance_batch_record.iscontrollerchanged is '是否有重大负面信息';
comment on column ${iol_schema}.icms_finance_batch_record.israterisklevellower is '评级是否下调';
comment on column ${iol_schema}.icms_finance_batch_record.revenuescale is '营收规模';
comment on column ${iol_schema}.icms_finance_batch_record.profitability is '盈利能力';
comment on column ${iol_schema}.icms_finance_batch_record.operationcapability is '运营能力';
comment on column ${iol_schema}.icms_finance_batch_record.rigidliabilities is '刚性负债';
comment on column ${iol_schema}.icms_finance_batch_record.netoperatingcashflow is '经营性净现金流';
comment on column ${iol_schema}.icms_finance_batch_record.bdbusinesssum is '借据额度金额';
comment on column ${iol_schema}.icms_finance_batch_record.enttype is '企业性质';
comment on column ${iol_schema}.icms_finance_batch_record.raterisklevel is '近期主体评级';
comment on column ${iol_schema}.icms_finance_batch_record.onlineamount is '线上额度';
comment on column ${iol_schema}.icms_finance_batch_record.isexistsrisk is '是否存在其他重大风险';
comment on column ${iol_schema}.icms_finance_batch_record.isbusinesschange is '经营情况是否发生重大变化';
comment on column ${iol_schema}.icms_finance_batch_record.searchstatus is '查询外部数据状态';
comment on column ${iol_schema}.icms_finance_batch_record.searcherrorreason is '查询外部数据异常原因';
comment on column ${iol_schema}.icms_finance_batch_record.searchdate is '外部数据日期';
comment on column ${iol_schema}.icms_finance_batch_record.othersum is '其他有效授信';
comment on column ${iol_schema}.icms_finance_batch_record.singlecustomersum is '单一客户管理限额';
comment on column ${iol_schema}.icms_finance_batch_record.belonggroupname is '归属集团（行内集团）';
comment on column ${iol_schema}.icms_finance_batch_record.nominalamount is '集团管理额度';
comment on column ${iol_schema}.icms_finance_batch_record.grouprelationshipcheckresult is '集团关系探测结果';
comment on column ${iol_schema}.icms_finance_batch_record.atualcontroller is '实际控制人';
comment on column ${iol_schema}.icms_finance_batch_record.isshareholderchange is '控股股东是否发生变化';
comment on column ${iol_schema}.icms_finance_batch_record.newratingprospect is '最新一期评级展望';
comment on column ${iol_schema}.icms_finance_batch_record.isissuebondschange is '近一年是否新发行债券';
comment on column ${iol_schema}.icms_finance_batch_record.isincomechange is '收入构成是否发生重大变化';
comment on column ${iol_schema}.icms_finance_batch_record.isnegativeinformationcheck is '是否命中负面信息校验';
comment on column ${iol_schema}.icms_finance_batch_record.isdefaultexist is '是否存在非标违约';
comment on column ${iol_schema}.icms_finance_batch_record.iscomticketoverdueexist is '是否存在商票逾期';
comment on column ${iol_schema}.icms_finance_batch_record.negativeinfo is '负面信息说明';
comment on column ${iol_schema}.icms_finance_batch_record.issignificantnegativeinfomation is '是否有重大负面信息';
comment on column ${iol_schema}.icms_finance_batch_record.outgroupname is '外部集团';
comment on column ${iol_schema}.icms_finance_batch_record.negativeshow is '负面信息';
comment on column ${iol_schema}.icms_finance_batch_record.newopiniondate is '最近一期审计意见时间';
comment on column ${iol_schema}.icms_finance_batch_record.newopinion is '最近一期审计意见';
comment on column ${iol_schema}.icms_finance_batch_record.isredeem is '是否未赎回二级资本债或永续债';
comment on column ${iol_schema}.icms_finance_batch_record.annualauditbusinesssum is '年审核定额度';
comment on column ${iol_schema}.icms_finance_batch_record.annualauditexposuresum is '年审核定敞口金额';
comment on column ${iol_schema}.icms_finance_batch_record.isyeartocheck is '是否年审';
comment on column ${iol_schema}.icms_finance_batch_record.start_dt is '开始时间';
comment on column ${iol_schema}.icms_finance_batch_record.end_dt is '结束时间';
comment on column ${iol_schema}.icms_finance_batch_record.id_mark is '增删标志';
comment on column ${iol_schema}.icms_finance_batch_record.etl_timestamp is 'ETL处理时间戳';
