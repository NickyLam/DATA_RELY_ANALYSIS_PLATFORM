/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_classify_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_classify_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_classify_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_classify_apply(
    serialno varchar2(40) -- 流水号
    ,creditaggreement varchar2(40) -- 额度合同号
    ,relativetype varchar2(10) -- 关联类型
    ,finalpolicyresult varchar2(20) -- 终审策略分类
    ,finalcustomerlevel varchar2(20) -- 终审监测评级
    ,inputuserid varchar2(40) -- 登记人
    ,flag varchar2(10) -- 标记
    ,relativeserialno varchar2(40) -- 关联流水号
    ,iscurrentmonth varchar2(6) -- 是否本月新发生
    ,totalsum number(24,6) -- 敞口
    ,maturity varchar2(10) -- 到期日
    ,vouchtype varchar2(20) -- 担保类型
    ,levelclassify varchar2(20) -- 评级对应的风险分类
    ,kernaladjustlevel varchar2(20) -- 
    ,alarminfo varchar2(400) -- 
    ,entrance varchar2(20) -- 申请发起入口1对公系统，2同业系统
    ,objecttype varchar2(40) -- 对象类型
    ,businesstype varchar2(18) -- 业务类型
    ,businesscurrency varchar2(40) -- 业务币种
    ,inputorgid varchar2(40) -- 登记机构
    ,policyresult varchar2(20) -- 本期申请策略分类
    ,updateorgid varchar2(64) -- 更新时间
    ,updatedate varchar2(10) -- 更新日期
    ,type varchar2(8) -- 类型
    ,licensedate varchar2(10) -- 营业执照登记日
    ,approveclassifyresult varchar2(20) -- 审批环节风险分类
    ,lastcustomerlevel varchar2(20) -- 上期监测评级
    ,updateuserid varchar2(64) -- 更新人
    ,pigeonholedate varchar2(10) -- 归案日期
    ,contractserialno varchar2(40) -- 合同号
    ,remark1 varchar2(4000) -- 意见
    ,customerlevel varchar2(20) -- 信用评级
    ,classifynum number(22) -- 分类笔数
    ,accountmonth varchar2(10) -- 分类截至日期
    ,customerid varchar2(40) -- 客户号
    ,relativeno varchar2(40) -- 关联号
    ,inputdate varchar2(10) -- 登记日期
    ,approveclassifytime varchar2(20) -- 审批时间
    ,coverage number(24,6) -- 担保覆盖率
    ,assurecustomerid varchar2(40) -- 保证人流水号
    ,approvestatus varchar2(10) -- 流程状态
    ,customername varchar2(100) -- 客户名
    ,remark varchar2(200) -- 备注
    ,guarantysum number(24,6) -- 处置抵质押物收回净值（元）
    ,classifymode varchar2(4) -- 关联合同类型
    ,finalclassifyresult varchar2(20) -- 终审风险分类
    ,alarmadjustlevel varchar2(20) -- 
    ,lastpolicyresult varchar2(20) -- 上期策略分类
    ,adjusttype varchar2(1) -- 
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,classifyresult varchar2(20) -- 分类结果
    ,lastclassifyresult varchar2(20) -- 上期风险分类
    ,customerleveltime varchar2(20) -- 信用评级时间
    ,approveevaluateresult varchar2(20) -- 审批环节主体评级
    ,opensum number(24,6) -- 
    ,assurelevel varchar2(10) -- 保证人信用等级
    ,adviseclassifyresult varchar2(10) -- 本期系统建议分类
    ,balance number(24,6) -- 余额
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
grant select on ${iol_schema}.icms_classify_apply to ${iml_schema};
grant select on ${iol_schema}.icms_classify_apply to ${icl_schema};
grant select on ${iol_schema}.icms_classify_apply to ${idl_schema};
grant select on ${iol_schema}.icms_classify_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_classify_apply is '风险分类申请表';
comment on column ${iol_schema}.icms_classify_apply.serialno is '流水号';
comment on column ${iol_schema}.icms_classify_apply.creditaggreement is '额度合同号';
comment on column ${iol_schema}.icms_classify_apply.relativetype is '关联类型';
comment on column ${iol_schema}.icms_classify_apply.finalpolicyresult is '终审策略分类';
comment on column ${iol_schema}.icms_classify_apply.finalcustomerlevel is '终审监测评级';
comment on column ${iol_schema}.icms_classify_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_classify_apply.flag is '标记';
comment on column ${iol_schema}.icms_classify_apply.relativeserialno is '关联流水号';
comment on column ${iol_schema}.icms_classify_apply.iscurrentmonth is '是否本月新发生';
comment on column ${iol_schema}.icms_classify_apply.totalsum is '敞口';
comment on column ${iol_schema}.icms_classify_apply.maturity is '到期日';
comment on column ${iol_schema}.icms_classify_apply.vouchtype is '担保类型';
comment on column ${iol_schema}.icms_classify_apply.levelclassify is '评级对应的风险分类';
comment on column ${iol_schema}.icms_classify_apply.kernaladjustlevel is '';
comment on column ${iol_schema}.icms_classify_apply.alarminfo is '';
comment on column ${iol_schema}.icms_classify_apply.entrance is '申请发起入口1对公系统，2同业系统';
comment on column ${iol_schema}.icms_classify_apply.objecttype is '对象类型';
comment on column ${iol_schema}.icms_classify_apply.businesstype is '业务类型';
comment on column ${iol_schema}.icms_classify_apply.businesscurrency is '业务币种';
comment on column ${iol_schema}.icms_classify_apply.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_classify_apply.policyresult is '本期申请策略分类';
comment on column ${iol_schema}.icms_classify_apply.updateorgid is '更新时间';
comment on column ${iol_schema}.icms_classify_apply.updatedate is '更新日期';
comment on column ${iol_schema}.icms_classify_apply.type is '类型';
comment on column ${iol_schema}.icms_classify_apply.licensedate is '营业执照登记日';
comment on column ${iol_schema}.icms_classify_apply.approveclassifyresult is '审批环节风险分类';
comment on column ${iol_schema}.icms_classify_apply.lastcustomerlevel is '上期监测评级';
comment on column ${iol_schema}.icms_classify_apply.updateuserid is '更新人';
comment on column ${iol_schema}.icms_classify_apply.pigeonholedate is '归案日期';
comment on column ${iol_schema}.icms_classify_apply.contractserialno is '合同号';
comment on column ${iol_schema}.icms_classify_apply.remark1 is '意见';
comment on column ${iol_schema}.icms_classify_apply.customerlevel is '信用评级';
comment on column ${iol_schema}.icms_classify_apply.classifynum is '分类笔数';
comment on column ${iol_schema}.icms_classify_apply.accountmonth is '分类截至日期';
comment on column ${iol_schema}.icms_classify_apply.customerid is '客户号';
comment on column ${iol_schema}.icms_classify_apply.relativeno is '关联号';
comment on column ${iol_schema}.icms_classify_apply.inputdate is '登记日期';
comment on column ${iol_schema}.icms_classify_apply.approveclassifytime is '审批时间';
comment on column ${iol_schema}.icms_classify_apply.coverage is '担保覆盖率';
comment on column ${iol_schema}.icms_classify_apply.assurecustomerid is '保证人流水号';
comment on column ${iol_schema}.icms_classify_apply.approvestatus is '流程状态';
comment on column ${iol_schema}.icms_classify_apply.customername is '客户名';
comment on column ${iol_schema}.icms_classify_apply.remark is '备注';
comment on column ${iol_schema}.icms_classify_apply.guarantysum is '处置抵质押物收回净值（元）';
comment on column ${iol_schema}.icms_classify_apply.classifymode is '关联合同类型';
comment on column ${iol_schema}.icms_classify_apply.finalclassifyresult is '终审风险分类';
comment on column ${iol_schema}.icms_classify_apply.alarmadjustlevel is '';
comment on column ${iol_schema}.icms_classify_apply.lastpolicyresult is '上期策略分类';
comment on column ${iol_schema}.icms_classify_apply.adjusttype is '';
comment on column ${iol_schema}.icms_classify_apply.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_classify_apply.classifyresult is '分类结果';
comment on column ${iol_schema}.icms_classify_apply.lastclassifyresult is '上期风险分类';
comment on column ${iol_schema}.icms_classify_apply.customerleveltime is '信用评级时间';
comment on column ${iol_schema}.icms_classify_apply.approveevaluateresult is '审批环节主体评级';
comment on column ${iol_schema}.icms_classify_apply.opensum is '';
comment on column ${iol_schema}.icms_classify_apply.assurelevel is '保证人信用等级';
comment on column ${iol_schema}.icms_classify_apply.adviseclassifyresult is '本期系统建议分类';
comment on column ${iol_schema}.icms_classify_apply.balance is '余额';
comment on column ${iol_schema}.icms_classify_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_classify_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_classify_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_classify_apply.etl_timestamp is 'ETL处理时间戳';
