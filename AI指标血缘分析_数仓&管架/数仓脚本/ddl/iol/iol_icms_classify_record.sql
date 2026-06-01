/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_classify_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_classify_record
whenever sqlerror continue none;
drop table ${iol_schema}.icms_classify_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_classify_record(
    serialno varchar2(64) -- 流水号
    ,remark varchar2(4000) -- 备注
    ,relativeserialno varchar2(64) -- 关联结果编号关联分类结果编号
    ,objectno varchar2(64) -- 对象编号借据编号（借据编号/合同编号）
    ,accountmonth varchar2(64) -- 期次
    ,islowrisk varchar2(2) -- 是否低风险
    ,inputorgid varchar2(64) -- 登记机构
    ,corporgid varchar2(64) -- 法人机构编号
    ,oldserialno varchar2(64) -- 旧信贷流水号
    ,manuclassifyresult varchar2(64) -- 人工分类结果
    ,finalresult varchar2(64) -- 最终结果
    ,customerid varchar2(32) -- 客户编号
    ,balance number(24,6) -- 贷款余额
    ,classifystatus varchar2(64) -- 分类状态
    ,operatedate date -- 经办日期
    ,inputuserid varchar2(64) -- 登记人
    ,firstresult varchar2(18) -- 第一次分类结果
    ,objecttype varchar2(64) -- 对象类型对象类型(合同/借据)
    ,updatedate date -- 更新日期
    ,secondresult varchar2(18) -- 第二次分类结果
    ,classifytype varchar2(36) -- 分类方式分类方式(系统分类/人工分类)
    ,updateuserid varchar2(64) -- 更新人
    ,finishdate2 varchar2(10) -- FINISHDATE2
    ,contractserialno varchar2(32) -- 合同号
    ,customername varchar2(200) -- 客户名称
    ,currency varchar2(3) -- 币种
    ,operateorgid varchar2(64) -- 经办机构
    ,sysclassifyresult varchar2(64) -- 系统分类结果
    ,manuclassifyreason varchar2(1000) -- 人工分类理由
    ,belongdept varchar2(64) -- 所属条线
    ,reportperiod varchar2(64) -- 财报周期
    ,isthismonthoccur varchar2(2) -- 是否当月发生
    ,finishdate date -- 分类完成日期
    ,termmonth number(22) -- 贷款期限
    ,finishdate5 varchar2(10) -- FINISHDATE5
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,productid varchar2(64) -- 业务品种
    ,classifylevel varchar2(18) -- 认定级别
    ,reportaccountmonth varchar2(48) -- 财报会计月财报会计月
    ,inputdate date -- 登记日期
    ,lastresult varchar2(18) -- 上次分类结果
    ,businesssum number(24,6) -- 贷款金额
    ,operateuserid varchar2(64) -- 经办人
    ,updateorgid varchar2(64) -- 更新机构
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
grant select on ${iol_schema}.icms_classify_record to ${iml_schema};
grant select on ${iol_schema}.icms_classify_record to ${icl_schema};
grant select on ${iol_schema}.icms_classify_record to ${idl_schema};
grant select on ${iol_schema}.icms_classify_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_classify_record is '风险分类信息风险分类信息';
comment on column ${iol_schema}.icms_classify_record.serialno is '流水号';
comment on column ${iol_schema}.icms_classify_record.remark is '备注';
comment on column ${iol_schema}.icms_classify_record.relativeserialno is '关联结果编号关联分类结果编号';
comment on column ${iol_schema}.icms_classify_record.objectno is '对象编号借据编号（借据编号/合同编号）';
comment on column ${iol_schema}.icms_classify_record.accountmonth is '期次';
comment on column ${iol_schema}.icms_classify_record.islowrisk is '是否低风险';
comment on column ${iol_schema}.icms_classify_record.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_classify_record.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_classify_record.oldserialno is '旧信贷流水号';
comment on column ${iol_schema}.icms_classify_record.manuclassifyresult is '人工分类结果';
comment on column ${iol_schema}.icms_classify_record.finalresult is '最终结果';
comment on column ${iol_schema}.icms_classify_record.customerid is '客户编号';
comment on column ${iol_schema}.icms_classify_record.balance is '贷款余额';
comment on column ${iol_schema}.icms_classify_record.classifystatus is '分类状态';
comment on column ${iol_schema}.icms_classify_record.operatedate is '经办日期';
comment on column ${iol_schema}.icms_classify_record.inputuserid is '登记人';
comment on column ${iol_schema}.icms_classify_record.firstresult is '第一次分类结果';
comment on column ${iol_schema}.icms_classify_record.objecttype is '对象类型对象类型(合同/借据)';
comment on column ${iol_schema}.icms_classify_record.updatedate is '更新日期';
comment on column ${iol_schema}.icms_classify_record.secondresult is '第二次分类结果';
comment on column ${iol_schema}.icms_classify_record.classifytype is '分类方式分类方式(系统分类/人工分类)';
comment on column ${iol_schema}.icms_classify_record.updateuserid is '更新人';
comment on column ${iol_schema}.icms_classify_record.finishdate2 is 'FINISHDATE2';
comment on column ${iol_schema}.icms_classify_record.contractserialno is '合同号';
comment on column ${iol_schema}.icms_classify_record.customername is '客户名称';
comment on column ${iol_schema}.icms_classify_record.currency is '币种';
comment on column ${iol_schema}.icms_classify_record.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_classify_record.sysclassifyresult is '系统分类结果';
comment on column ${iol_schema}.icms_classify_record.manuclassifyreason is '人工分类理由';
comment on column ${iol_schema}.icms_classify_record.belongdept is '所属条线';
comment on column ${iol_schema}.icms_classify_record.reportperiod is '财报周期';
comment on column ${iol_schema}.icms_classify_record.isthismonthoccur is '是否当月发生';
comment on column ${iol_schema}.icms_classify_record.finishdate is '分类完成日期';
comment on column ${iol_schema}.icms_classify_record.termmonth is '贷款期限';
comment on column ${iol_schema}.icms_classify_record.finishdate5 is 'FINISHDATE5';
comment on column ${iol_schema}.icms_classify_record.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_classify_record.productid is '业务品种';
comment on column ${iol_schema}.icms_classify_record.classifylevel is '认定级别';
comment on column ${iol_schema}.icms_classify_record.reportaccountmonth is '财报会计月财报会计月';
comment on column ${iol_schema}.icms_classify_record.inputdate is '登记日期';
comment on column ${iol_schema}.icms_classify_record.lastresult is '上次分类结果';
comment on column ${iol_schema}.icms_classify_record.businesssum is '贷款金额';
comment on column ${iol_schema}.icms_classify_record.operateuserid is '经办人';
comment on column ${iol_schema}.icms_classify_record.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_classify_record.start_dt is '开始时间';
comment on column ${iol_schema}.icms_classify_record.end_dt is '结束时间';
comment on column ${iol_schema}.icms_classify_record.id_mark is '增删标志';
comment on column ${iol_schema}.icms_classify_record.etl_timestamp is 'ETL处理时间戳';
