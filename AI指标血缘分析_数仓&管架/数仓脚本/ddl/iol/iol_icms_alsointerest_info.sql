/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_alsointerest_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_alsointerest_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_alsointerest_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_alsointerest_info(
    serialno varchar2(40) -- 流水号
    ,duebillserialno varchar2(40) -- 借据号
    ,paymentsum number(18,2) -- 还款金额
    ,dateno varchar2(10) -- 期号
    ,insttg varchar2(1) -- 利息类别
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,alsointerestsum number(24,6) -- 还息金额
    ,loansq varchar2(20) -- 序号
    ,paymentsubaccountno varchar2(5) -- 还款子户号
    ,signuptype varchar2(10) -- 签约类型
    ,paymentaccountno varchar2(40) -- 还款账号
    ,alsointerestdate varchar2(10) -- 还息日期
    ,pdtmno number(22) -- 产生利息的本金所属期数
    ,alsointerestno varchar2(40) -- 序号
    ,businesscurrency varchar2(18) -- 币种
    ,pdlnsq varchar2(20) -- 产生利息的本金余额序号
    ,interesttype varchar2(2) -- 利息种类
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
grant select on ${iol_schema}.icms_alsointerest_info to ${iml_schema};
grant select on ${iol_schema}.icms_alsointerest_info to ${icl_schema};
grant select on ${iol_schema}.icms_alsointerest_info to ${idl_schema};
grant select on ${iol_schema}.icms_alsointerest_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_alsointerest_info is '中间表还息信息';
comment on column ${iol_schema}.icms_alsointerest_info.serialno is '流水号';
comment on column ${iol_schema}.icms_alsointerest_info.duebillserialno is '借据号';
comment on column ${iol_schema}.icms_alsointerest_info.paymentsum is '还款金额';
comment on column ${iol_schema}.icms_alsointerest_info.dateno is '期号';
comment on column ${iol_schema}.icms_alsointerest_info.insttg is '利息类别';
comment on column ${iol_schema}.icms_alsointerest_info.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_alsointerest_info.alsointerestsum is '还息金额';
comment on column ${iol_schema}.icms_alsointerest_info.loansq is '序号';
comment on column ${iol_schema}.icms_alsointerest_info.paymentsubaccountno is '还款子户号';
comment on column ${iol_schema}.icms_alsointerest_info.signuptype is '签约类型';
comment on column ${iol_schema}.icms_alsointerest_info.paymentaccountno is '还款账号';
comment on column ${iol_schema}.icms_alsointerest_info.alsointerestdate is '还息日期';
comment on column ${iol_schema}.icms_alsointerest_info.pdtmno is '产生利息的本金所属期数';
comment on column ${iol_schema}.icms_alsointerest_info.alsointerestno is '序号';
comment on column ${iol_schema}.icms_alsointerest_info.businesscurrency is '币种';
comment on column ${iol_schema}.icms_alsointerest_info.pdlnsq is '产生利息的本金余额序号';
comment on column ${iol_schema}.icms_alsointerest_info.interesttype is '利息种类';
comment on column ${iol_schema}.icms_alsointerest_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_alsointerest_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_alsointerest_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_alsointerest_info.etl_timestamp is 'ETL处理时间戳';
