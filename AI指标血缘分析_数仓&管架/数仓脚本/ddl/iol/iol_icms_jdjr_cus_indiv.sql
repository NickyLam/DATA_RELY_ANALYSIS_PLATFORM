/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_jdjr_cus_indiv
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_jdjr_cus_indiv
whenever sqlerror continue none;
drop table ${iol_schema}.icms_jdjr_cus_indiv purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_jdjr_cus_indiv(
    cusno varchar2(60) -- 京东pin
    ,cusname varchar2(300) -- 客户姓名
    ,usearea varchar2(2) -- 境内境外标志
    ,certtype varchar2(5) -- 证件类型
    ,migtflag varchar2(80) -- 
    ,bankname varchar2(60) -- 绑定银行卡行名
    ,birthdt varchar2(10) -- 出生日期
    ,prdcode varchar2(60) -- 产品编号
    ,cussex varchar2(2) -- 性别
    ,bussdate varchar2(10) -- 数据日期
    ,certno varchar2(60) -- 证件号码
    ,localfalg varchar2(2) -- 居民标志
    ,adress varchar2(500) -- 通讯地址
    ,bandaccountno varchar2(60) -- 绑定银行卡卡号
    ,cusstatus varchar2(2) -- 客户状态
    ,telephone varchar2(20) -- 手机号码
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
grant select on ${iol_schema}.icms_jdjr_cus_indiv to ${iml_schema};
grant select on ${iol_schema}.icms_jdjr_cus_indiv to ${icl_schema};
grant select on ${iol_schema}.icms_jdjr_cus_indiv to ${idl_schema};
grant select on ${iol_schema}.icms_jdjr_cus_indiv to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_jdjr_cus_indiv is '激活及借款的客户全量数据';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.cusno is '京东pin';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.cusname is '客户姓名';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.usearea is '境内境外标志';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.certtype is '证件类型';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.migtflag is '';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.bankname is '绑定银行卡行名';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.birthdt is '出生日期';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.prdcode is '产品编号';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.cussex is '性别';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.bussdate is '数据日期';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.certno is '证件号码';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.localfalg is '居民标志';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.adress is '通讯地址';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.bandaccountno is '绑定银行卡卡号';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.cusstatus is '客户状态';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.telephone is '手机号码';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.start_dt is '开始时间';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.end_dt is '结束时间';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.id_mark is '增删标志';
comment on column ${iol_schema}.icms_jdjr_cus_indiv.etl_timestamp is 'ETL处理时间戳';
