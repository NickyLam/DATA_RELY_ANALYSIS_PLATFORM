/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_acct_loan_change
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_acct_loan_change
whenever sqlerror continue none;
drop table ${iol_schema}.icms_acct_loan_change purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_acct_loan_change(
    serialno varchar2(40) -- 流水号
    ,objecttype varchar2(40) -- 对象类型
    ,objectno varchar2(40) -- 对象编号
    ,maturitydate varchar2(10) -- 新贷款到期日
    ,oldmaturitydate varchar2(10) -- 原贷款到期日
    ,loantermunit varchar2(10) -- 新贷款期限单位
    ,loanterm number(38,0) -- 新贷款期限
    ,oldloantermunit varchar2(10) -- 原贷款期限单位
    ,oldloanterm number(38,0) -- 原贷款期限
    ,accountingorgid varchar2(40) -- 新贷款账务机构
    ,oldaccountingorgid varchar2(32) -- 旧贷款账务机构
    ,remark varchar2(4000) -- 备注
    ,defaultdueday varchar2(2) -- 默认还款日
    ,ratechangeflag varchar2(10) -- 变更标志
    ,olddefaultdueday varchar2(2) -- 原默认还款日
    ,fbfromdate varchar2(10) -- 回退前日期
    ,fbtodate varchar2(10) -- 回退至日期
    ,revertflag varchar2(10) -- 恢复标示（ 0,待恢复,1,已恢复）
    ,attribute1 varchar2(40) -- 属性1
    ,attribute2 varchar2(40) -- 属性2
    ,attribute3 varchar2(40) -- 属性3
    ,attribute4 varchar2(40) -- 属性4
    ,attribute5 varchar2(40) -- 属性5
    ,attribute6 varchar2(40) -- 属性6
    ,attribute7 varchar2(40) -- 属性7
    ,attribute8 varchar2(40) -- 属性8
    ,attribute9 varchar2(40) -- 属性9
    ,attribute10 varchar2(40) -- 属性10
    ,attribute11 varchar2(40) -- 属性11
    ,accruedate varchar2(10) -- 属性
    ,accountno varchar2(40) -- 买入方存款账号
    ,attribute12 varchar2(40) -- 属性12
    ,migtflag varchar2(80) -- 迁移标志：CRS RCR ILC UPL
    ,attribute13 varchar2(40) -- 属性13
    ,attribute14 varchar2(40) -- 属性14
    ,attribute15 varchar2(40) -- 属性15
    ,attribute16 varchar2(40) -- 属性16
    ,attribute17 varchar2(40) -- 属性17
    ,attribute18 varchar2(40) -- 属性18
    ,attribute19 varchar2(40) -- 属性19
    ,attribute20 varchar2(40) -- 属性20
    ,attribute21 varchar2(40) -- 属性21
    ,attribute22 varchar2(40) -- 属性22
    ,attribute23 varchar2(40) -- 属性23
    ,attribute24 varchar2(40) -- 属性24
    ,attribute25 varchar2(40) -- 属性25
    ,attribute26 varchar2(40) -- 属性26
    ,finalmerger varchar2(10) -- 是否末期合并：0否，1是
    ,attribute27 varchar2(64) -- 属性27
    ,attribute28 varchar2(64) -- 属性28
    ,attribute29 varchar2(256) -- 属性29
    ,attribute30 varchar2(256) -- 属性30
    ,attribute31 varchar2(256) -- 属性31
    ,attribute32 varchar2(256) -- 属性32
    ,attribute33 varchar2(256) -- 属性33
    ,transferinterest varchar2(2) -- 是否转利息
    ,termchangetype varchar2(4) -- 期限变更类型
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
grant select on ${iol_schema}.icms_acct_loan_change to ${iml_schema};
grant select on ${iol_schema}.icms_acct_loan_change to ${icl_schema};
grant select on ${iol_schema}.icms_acct_loan_change to ${idl_schema};
grant select on ${iol_schema}.icms_acct_loan_change to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_acct_loan_change is '贷款-变更交易单据信息';
comment on column ${iol_schema}.icms_acct_loan_change.serialno is '流水号';
comment on column ${iol_schema}.icms_acct_loan_change.objecttype is '对象类型';
comment on column ${iol_schema}.icms_acct_loan_change.objectno is '对象编号';
comment on column ${iol_schema}.icms_acct_loan_change.maturitydate is '新贷款到期日';
comment on column ${iol_schema}.icms_acct_loan_change.oldmaturitydate is '原贷款到期日';
comment on column ${iol_schema}.icms_acct_loan_change.loantermunit is '新贷款期限单位';
comment on column ${iol_schema}.icms_acct_loan_change.loanterm is '新贷款期限';
comment on column ${iol_schema}.icms_acct_loan_change.oldloantermunit is '原贷款期限单位';
comment on column ${iol_schema}.icms_acct_loan_change.oldloanterm is '原贷款期限';
comment on column ${iol_schema}.icms_acct_loan_change.accountingorgid is '新贷款账务机构';
comment on column ${iol_schema}.icms_acct_loan_change.oldaccountingorgid is '旧贷款账务机构';
comment on column ${iol_schema}.icms_acct_loan_change.remark is '备注';
comment on column ${iol_schema}.icms_acct_loan_change.defaultdueday is '默认还款日';
comment on column ${iol_schema}.icms_acct_loan_change.ratechangeflag is '变更标志';
comment on column ${iol_schema}.icms_acct_loan_change.olddefaultdueday is '原默认还款日';
comment on column ${iol_schema}.icms_acct_loan_change.fbfromdate is '回退前日期';
comment on column ${iol_schema}.icms_acct_loan_change.fbtodate is '回退至日期';
comment on column ${iol_schema}.icms_acct_loan_change.revertflag is '恢复标示（ 0,待恢复,1,已恢复）';
comment on column ${iol_schema}.icms_acct_loan_change.attribute1 is '属性1';
comment on column ${iol_schema}.icms_acct_loan_change.attribute2 is '属性2';
comment on column ${iol_schema}.icms_acct_loan_change.attribute3 is '属性3';
comment on column ${iol_schema}.icms_acct_loan_change.attribute4 is '属性4';
comment on column ${iol_schema}.icms_acct_loan_change.attribute5 is '属性5';
comment on column ${iol_schema}.icms_acct_loan_change.attribute6 is '属性6';
comment on column ${iol_schema}.icms_acct_loan_change.attribute7 is '属性7';
comment on column ${iol_schema}.icms_acct_loan_change.attribute8 is '属性8';
comment on column ${iol_schema}.icms_acct_loan_change.attribute9 is '属性9';
comment on column ${iol_schema}.icms_acct_loan_change.attribute10 is '属性10';
comment on column ${iol_schema}.icms_acct_loan_change.attribute11 is '属性11';
comment on column ${iol_schema}.icms_acct_loan_change.accruedate is '属性';
comment on column ${iol_schema}.icms_acct_loan_change.accountno is '买入方存款账号';
comment on column ${iol_schema}.icms_acct_loan_change.attribute12 is '属性12';
comment on column ${iol_schema}.icms_acct_loan_change.migtflag is '迁移标志：CRS RCR ILC UPL';
comment on column ${iol_schema}.icms_acct_loan_change.attribute13 is '属性13';
comment on column ${iol_schema}.icms_acct_loan_change.attribute14 is '属性14';
comment on column ${iol_schema}.icms_acct_loan_change.attribute15 is '属性15';
comment on column ${iol_schema}.icms_acct_loan_change.attribute16 is '属性16';
comment on column ${iol_schema}.icms_acct_loan_change.attribute17 is '属性17';
comment on column ${iol_schema}.icms_acct_loan_change.attribute18 is '属性18';
comment on column ${iol_schema}.icms_acct_loan_change.attribute19 is '属性19';
comment on column ${iol_schema}.icms_acct_loan_change.attribute20 is '属性20';
comment on column ${iol_schema}.icms_acct_loan_change.attribute21 is '属性21';
comment on column ${iol_schema}.icms_acct_loan_change.attribute22 is '属性22';
comment on column ${iol_schema}.icms_acct_loan_change.attribute23 is '属性23';
comment on column ${iol_schema}.icms_acct_loan_change.attribute24 is '属性24';
comment on column ${iol_schema}.icms_acct_loan_change.attribute25 is '属性25';
comment on column ${iol_schema}.icms_acct_loan_change.attribute26 is '属性26';
comment on column ${iol_schema}.icms_acct_loan_change.finalmerger is '是否末期合并：0否，1是';
comment on column ${iol_schema}.icms_acct_loan_change.attribute27 is '属性27';
comment on column ${iol_schema}.icms_acct_loan_change.attribute28 is '属性28';
comment on column ${iol_schema}.icms_acct_loan_change.attribute29 is '属性29';
comment on column ${iol_schema}.icms_acct_loan_change.attribute30 is '属性30';
comment on column ${iol_schema}.icms_acct_loan_change.attribute31 is '属性31';
comment on column ${iol_schema}.icms_acct_loan_change.attribute32 is '属性32';
comment on column ${iol_schema}.icms_acct_loan_change.attribute33 is '属性33';
comment on column ${iol_schema}.icms_acct_loan_change.transferinterest is '是否转利息';
comment on column ${iol_schema}.icms_acct_loan_change.termchangetype is '期限变更类型';
comment on column ${iol_schema}.icms_acct_loan_change.start_dt is '开始时间';
comment on column ${iol_schema}.icms_acct_loan_change.end_dt is '结束时间';
comment on column ${iol_schema}.icms_acct_loan_change.id_mark is '增删标志';
comment on column ${iol_schema}.icms_acct_loan_change.etl_timestamp is 'ETL处理时间戳';
