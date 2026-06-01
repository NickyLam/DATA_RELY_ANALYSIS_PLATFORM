/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybkzd_repay_notice
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybkzd_repay_notice
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybkzd_repay_notice purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybkzd_repay_notice(
    serialno varchar2(32) -- 信贷流水号
    ,requestid varchar2(256) -- 请求幂等ID
    ,applyno varchar2(64) -- 申请单号
    ,certtype varchar2(32) -- 借款人证件类型
    ,certname varchar2(512) -- 借款人证件名称
    ,certno varchar2(64) -- 借款人证件号码
    ,custipid varchar2(64) -- 借款人在网商的会员ID
    ,repayamount varchar2(64) -- 还款金额
    ,extendfield1 varchar2(64) -- 拓展字段1
    ,extendfield2 varchar2(64) -- 拓展字段2
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记单位
    ,inputdate varchar2(24) -- 登记日期
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新单位
    ,updatedate varchar2(24) -- 更新日期
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
grant select on ${iol_schema}.icms_mybkzd_repay_notice to ${iml_schema};
grant select on ${iol_schema}.icms_mybkzd_repay_notice to ${icl_schema};
grant select on ${iol_schema}.icms_mybkzd_repay_notice to ${idl_schema};
grant select on ${iol_schema}.icms_mybkzd_repay_notice to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybkzd_repay_notice is '网商贷助贷还款通知信息表';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.serialno is '信贷流水号';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.requestid is '请求幂等ID';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.applyno is '申请单号';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.certtype is '借款人证件类型';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.certname is '借款人证件名称';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.certno is '借款人证件号码';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.custipid is '借款人在网商的会员ID';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.repayamount is '还款金额';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.extendfield1 is '拓展字段1';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.extendfield2 is '拓展字段2';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.inputuserid is '登记人';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.inputorgid is '登记单位';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.inputdate is '登记日期';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.updateuserid is '更新人';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.updateorgid is '更新单位';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.updatedate is '更新日期';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.start_dt is '开始时间';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.end_dt is '结束时间';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.id_mark is '增删标志';
comment on column ${iol_schema}.icms_mybkzd_repay_notice.etl_timestamp is 'ETL处理时间戳';
