/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_afterloan_creditcardinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_afterloan_creditcardinfo
whenever sqlerror continue none;
drop table ${iol_schema}.icms_afterloan_creditcardinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_afterloan_creditcardinfo(
    serialno varchar2(40) -- 流水号
    ,overduedays number(22) -- 逾期天数
    ,mfcustomerid varchar2(40) -- 核心客户号
    ,updateuserid varchar2(8) -- 更新人
    ,customerid varchar2(32) -- 客户编号
    ,relativeserialno varchar2(40) -- 关联流水号
    ,updateorgid varchar2(12) -- 更新机构
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,usedcreditsum varchar2(32) -- 使用额度情况(满10万元到提醒性预警)
    ,inputuserid varchar2(8) -- 登记人
    ,artificialpersonname varchar2(80) -- 借款人/实际控制人信用卡开户行
    ,acctstatus varchar2(10) -- 账户状态
    ,inputorgid varchar2(32) -- 登记机构
    ,customername varchar2(80) -- 信用卡用户名称
    ,inputdate date -- 登记日期
    ,updatedate date -- 更新日期
    ,cardstate varchar2(32) -- 是否被启用(1是0否)
    ,overduebalance number(24,6) -- 逾期金额
    ,reportno varchar2(80) -- 报告编号
    ,currency varchar2(10) -- 币种代码
    ,querydate date -- 查询日期
    ,creditsum number(24,6) -- 卡额度
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
grant select on ${iol_schema}.icms_afterloan_creditcardinfo to ${iml_schema};
grant select on ${iol_schema}.icms_afterloan_creditcardinfo to ${icl_schema};
grant select on ${iol_schema}.icms_afterloan_creditcardinfo to ${idl_schema};
grant select on ${iol_schema}.icms_afterloan_creditcardinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_afterloan_creditcardinfo is '同业信用卡明细表';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.serialno is '流水号';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.overduedays is '逾期天数';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.mfcustomerid is '核心客户号';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.updateuserid is '更新人';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.customerid is '客户编号';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.relativeserialno is '关联流水号';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.usedcreditsum is '使用额度情况(满10万元到提醒性预警)';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.inputuserid is '登记人';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.artificialpersonname is '借款人/实际控制人信用卡开户行';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.acctstatus is '账户状态';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.customername is '信用卡用户名称';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.inputdate is '登记日期';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.updatedate is '更新日期';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.cardstate is '是否被启用(1是0否)';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.overduebalance is '逾期金额';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.reportno is '报告编号';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.currency is '币种代码';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.querydate is '查询日期';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.creditsum is '卡额度';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.start_dt is '开始时间';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.end_dt is '结束时间';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.id_mark is '增删标志';
comment on column ${iol_schema}.icms_afterloan_creditcardinfo.etl_timestamp is 'ETL处理时间戳';
