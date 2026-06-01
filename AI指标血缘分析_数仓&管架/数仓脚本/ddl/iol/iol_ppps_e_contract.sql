/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ppps_e_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ppps_e_contract
whenever sqlerror continue none;
drop table ${iol_schema}.ppps_e_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_e_contract(
    id number(11) -- 自增主键
    ,sgn_no varchar2(60) -- 签约协议号
    ,issr_id varchar2(14) -- 发起方所属机构编号
    ,sgn_date varchar2(8) -- 签约日期:yyyyMMdd
    ,sgn_time varchar2(6) -- 签约时间:HHmmss
    ,sgn_status varchar2(1) -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
    ,sgn_acct_issr_id varchar2(120) -- 签约人银行账户所属机构标识
    ,sgn_acct_tp varchar2(2) -- 签约账户类型:00-个人借记，01-个人贷记，02-个人准待机，03-个人支付，04-单位支付，05-对公账户，06-备付金，07-存折
    ,sgn_acct_id_de varchar2(64) -- 签约账号
    ,sgn_acct_nm_de varchar2(256) -- 签约账户户名
    ,sgn_acct_lvl varchar2(1) -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
    ,id_tp varchar2(20) -- 证件类型
    ,id_no_de varchar2(60) -- 证件号码
    ,mob_no_de varchar2(24) -- 手机号
    ,instg_id varchar2(60) -- 支付账户所属机构标识
    ,instg_acct_de varchar2(120) -- 签约人支付账号
    ,expire_date varchar2(20) -- 协议失效日期
    ,insert_time date -- 创建时间
    ,update_time date -- 最后更新时间
    ,remark varchar2(200) -- 备注信息
    ,enabled_state varchar2(10) -- 启用状态（ACTIVE-正常 INACTIVE-失效）
    ,pty_id varchar2(16) -- 客户号
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
grant select on ${iol_schema}.ppps_e_contract to ${iml_schema};
grant select on ${iol_schema}.ppps_e_contract to ${icl_schema};
grant select on ${iol_schema}.ppps_e_contract to ${idl_schema};
grant select on ${iol_schema}.ppps_e_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.ppps_e_contract is '签约微信、支付宝快捷支付表';
comment on column ${iol_schema}.ppps_e_contract.id is '自增主键';
comment on column ${iol_schema}.ppps_e_contract.sgn_no is '签约协议号';
comment on column ${iol_schema}.ppps_e_contract.issr_id is '发起方所属机构编号';
comment on column ${iol_schema}.ppps_e_contract.sgn_date is '签约日期:yyyyMMdd';
comment on column ${iol_schema}.ppps_e_contract.sgn_time is '签约时间:HHmmss';
comment on column ${iol_schema}.ppps_e_contract.sgn_status is '签约状态：0-正常（成功），1-失败，2-已解约，3-过期';
comment on column ${iol_schema}.ppps_e_contract.sgn_acct_issr_id is '签约人银行账户所属机构标识';
comment on column ${iol_schema}.ppps_e_contract.sgn_acct_tp is '签约账户类型:00-个人借记，01-个人贷记，02-个人准待机，03-个人支付，04-单位支付，05-对公账户，06-备付金，07-存折';
comment on column ${iol_schema}.ppps_e_contract.sgn_acct_id_de is '签约账号';
comment on column ${iol_schema}.ppps_e_contract.sgn_acct_nm_de is '签约账户户名';
comment on column ${iol_schema}.ppps_e_contract.sgn_acct_lvl is '签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户';
comment on column ${iol_schema}.ppps_e_contract.id_tp is '证件类型';
comment on column ${iol_schema}.ppps_e_contract.id_no_de is '证件号码';
comment on column ${iol_schema}.ppps_e_contract.mob_no_de is '手机号';
comment on column ${iol_schema}.ppps_e_contract.instg_id is '支付账户所属机构标识';
comment on column ${iol_schema}.ppps_e_contract.instg_acct_de is '签约人支付账号';
comment on column ${iol_schema}.ppps_e_contract.expire_date is '协议失效日期';
comment on column ${iol_schema}.ppps_e_contract.insert_time is '创建时间';
comment on column ${iol_schema}.ppps_e_contract.update_time is '最后更新时间';
comment on column ${iol_schema}.ppps_e_contract.remark is '备注信息';
comment on column ${iol_schema}.ppps_e_contract.enabled_state is '启用状态（ACTIVE-正常 INACTIVE-失效）';
comment on column ${iol_schema}.ppps_e_contract.pty_id is '客户号';
comment on column ${iol_schema}.ppps_e_contract.start_dt is '开始时间';
comment on column ${iol_schema}.ppps_e_contract.end_dt is '结束时间';
comment on column ${iol_schema}.ppps_e_contract.id_mark is '增删标志';
comment on column ${iol_schema}.ppps_e_contract.etl_timestamp is 'ETL处理时间戳';
