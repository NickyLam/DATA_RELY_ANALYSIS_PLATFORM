/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_remindalert_wastbook
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_remindalert_wastbook
whenever sqlerror continue none;
drop table ${iol_schema}.icms_remindalert_wastbook purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_remindalert_wastbook(
    serialno varchar2(64) -- 流水号
    ,remark4 varchar2(1000) -- 客户经理生效原因
    ,submitriskorgid varchar2(40) -- 风险经理机构
    ,signlevel varchar2(18) -- 信号级别
    ,querydate varchar2(40) -- 征信查询日期
    ,effectflag varchar2(32) -- 生效/失效预警申请
    ,inputdate date -- 登记时间
    ,inputuserid varchar2(64) -- 登记人
    ,remark varchar2(1000) -- 原因
    ,certid varchar2(60) -- 证件号码
    ,loanoverdate varchar2(2) -- 是否贷款逾期
    ,creditcardoverdate varchar2(2) -- 是否信用卡逾期
    ,allcreditcardusedamount number(24,6) -- 所有信用卡已使用额度
    ,updateorgid varchar2(64) -- 更新机构
    ,customertype varchar2(32) -- 客户类型
    ,newcreditloannum number(22) -- 新增信用贷款笔数
    ,remark2 varchar2(1000) -- 风险经理失效原因
    ,managerorgid varchar2(64) -- 管户机构
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,guarantyforothersyq varchar2(2) -- 对外担保是否逾期
    ,updateuserid varchar2(64) -- 更新人
    ,customerid varchar2(64) -- 客户编号
    ,objecttype varchar2(32) -- 监测类型
    ,certtype varchar2(32) -- 证件类型
    ,reportscope varchar2(32) -- 报表口径
    ,newcreditloanbalance number(24,6) -- 新增信用贷款余额
    ,querytimesamonth number(22) -- 近一月征信查询次数
    ,allcreditcardamount number(24,6) -- 所有信用卡授信额度
    ,inputorgid varchar2(64) -- 登记机构
    ,laststatusflag varchar2(32) -- 最新状态标志
    ,relatingname varchar2(80) -- 关联企业名称
    ,alertcontent varchar2(4000) -- 预警内容
    ,customername varchar2(200) -- 客户名称
    ,relatingid varchar2(64) -- 关联企业编号
    ,signname varchar2(200) -- 信号名称
    ,manageruserid varchar2(64) -- 管户人
    ,objectno varchar2(32) -- 监测流水号
    ,remark1 varchar2(1000) -- 客户经理失效原因
    ,guarantyforothers number(24,6) -- 对外担保金额
    ,creditcardusedrate number(24,6) -- 信用卡使用率
    ,alertinfosource varchar2(18) -- 预警信息来源
    ,updatedate date -- 更新日期
    ,reportdate varchar2(18) -- 报表日期
    ,rowsubject varchar2(32) -- 报表科目
    ,submitriskmanager varchar2(40) -- 风险经理编号
    ,duebillserialno varchar2(40) -- 借据号
    ,status varchar2(32) -- 状态标志
    ,remark3 varchar2(1000) -- 总经理室失效原因
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
grant select on ${iol_schema}.icms_remindalert_wastbook to ${iml_schema};
grant select on ${iol_schema}.icms_remindalert_wastbook to ${icl_schema};
grant select on ${iol_schema}.icms_remindalert_wastbook to ${idl_schema};
grant select on ${iol_schema}.icms_remindalert_wastbook to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_remindalert_wastbook is '提醒性预警任务记录';
comment on column ${iol_schema}.icms_remindalert_wastbook.serialno is '流水号';
comment on column ${iol_schema}.icms_remindalert_wastbook.remark4 is '客户经理生效原因';
comment on column ${iol_schema}.icms_remindalert_wastbook.submitriskorgid is '风险经理机构';
comment on column ${iol_schema}.icms_remindalert_wastbook.signlevel is '信号级别';
comment on column ${iol_schema}.icms_remindalert_wastbook.querydate is '征信查询日期';
comment on column ${iol_schema}.icms_remindalert_wastbook.effectflag is '生效/失效预警申请';
comment on column ${iol_schema}.icms_remindalert_wastbook.inputdate is '登记时间';
comment on column ${iol_schema}.icms_remindalert_wastbook.inputuserid is '登记人';
comment on column ${iol_schema}.icms_remindalert_wastbook.remark is '原因';
comment on column ${iol_schema}.icms_remindalert_wastbook.certid is '证件号码';
comment on column ${iol_schema}.icms_remindalert_wastbook.loanoverdate is '是否贷款逾期';
comment on column ${iol_schema}.icms_remindalert_wastbook.creditcardoverdate is '是否信用卡逾期';
comment on column ${iol_schema}.icms_remindalert_wastbook.allcreditcardusedamount is '所有信用卡已使用额度';
comment on column ${iol_schema}.icms_remindalert_wastbook.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_remindalert_wastbook.customertype is '客户类型';
comment on column ${iol_schema}.icms_remindalert_wastbook.newcreditloannum is '新增信用贷款笔数';
comment on column ${iol_schema}.icms_remindalert_wastbook.remark2 is '风险经理失效原因';
comment on column ${iol_schema}.icms_remindalert_wastbook.managerorgid is '管户机构';
comment on column ${iol_schema}.icms_remindalert_wastbook.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_remindalert_wastbook.guarantyforothersyq is '对外担保是否逾期';
comment on column ${iol_schema}.icms_remindalert_wastbook.updateuserid is '更新人';
comment on column ${iol_schema}.icms_remindalert_wastbook.customerid is '客户编号';
comment on column ${iol_schema}.icms_remindalert_wastbook.objecttype is '监测类型';
comment on column ${iol_schema}.icms_remindalert_wastbook.certtype is '证件类型';
comment on column ${iol_schema}.icms_remindalert_wastbook.reportscope is '报表口径';
comment on column ${iol_schema}.icms_remindalert_wastbook.newcreditloanbalance is '新增信用贷款余额';
comment on column ${iol_schema}.icms_remindalert_wastbook.querytimesamonth is '近一月征信查询次数';
comment on column ${iol_schema}.icms_remindalert_wastbook.allcreditcardamount is '所有信用卡授信额度';
comment on column ${iol_schema}.icms_remindalert_wastbook.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_remindalert_wastbook.laststatusflag is '最新状态标志';
comment on column ${iol_schema}.icms_remindalert_wastbook.relatingname is '关联企业名称';
comment on column ${iol_schema}.icms_remindalert_wastbook.alertcontent is '预警内容';
comment on column ${iol_schema}.icms_remindalert_wastbook.customername is '客户名称';
comment on column ${iol_schema}.icms_remindalert_wastbook.relatingid is '关联企业编号';
comment on column ${iol_schema}.icms_remindalert_wastbook.signname is '信号名称';
comment on column ${iol_schema}.icms_remindalert_wastbook.manageruserid is '管户人';
comment on column ${iol_schema}.icms_remindalert_wastbook.objectno is '监测流水号';
comment on column ${iol_schema}.icms_remindalert_wastbook.remark1 is '客户经理失效原因';
comment on column ${iol_schema}.icms_remindalert_wastbook.guarantyforothers is '对外担保金额';
comment on column ${iol_schema}.icms_remindalert_wastbook.creditcardusedrate is '信用卡使用率';
comment on column ${iol_schema}.icms_remindalert_wastbook.alertinfosource is '预警信息来源';
comment on column ${iol_schema}.icms_remindalert_wastbook.updatedate is '更新日期';
comment on column ${iol_schema}.icms_remindalert_wastbook.reportdate is '报表日期';
comment on column ${iol_schema}.icms_remindalert_wastbook.rowsubject is '报表科目';
comment on column ${iol_schema}.icms_remindalert_wastbook.submitriskmanager is '风险经理编号';
comment on column ${iol_schema}.icms_remindalert_wastbook.duebillserialno is '借据号';
comment on column ${iol_schema}.icms_remindalert_wastbook.status is '状态标志';
comment on column ${iol_schema}.icms_remindalert_wastbook.remark3 is '总经理室失效原因';
comment on column ${iol_schema}.icms_remindalert_wastbook.start_dt is '开始时间';
comment on column ${iol_schema}.icms_remindalert_wastbook.end_dt is '结束时间';
comment on column ${iol_schema}.icms_remindalert_wastbook.id_mark is '增删标志';
comment on column ${iol_schema}.icms_remindalert_wastbook.etl_timestamp is 'ETL处理时间戳';
