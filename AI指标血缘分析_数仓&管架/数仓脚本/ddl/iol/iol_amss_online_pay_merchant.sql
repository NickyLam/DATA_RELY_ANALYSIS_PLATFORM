/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_online_pay_merchant
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_online_pay_merchant
whenever sqlerror continue none;
drop table ${iol_schema}.amss_online_pay_merchant purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_online_pay_merchant(
    sign_num varchar2(256) -- 协议编号,主键
    ,mgmt_platf_chn varchar2(120) -- 管理平台渠道号
    ,sign_status varchar2(10) -- 签约状态，1-签约，默认1
    ,lnkm_name varchar2(120) -- 联系人
    ,lnkm_ceph_num varchar2(120) -- 联系人电话
    ,acct_num varchar2(120) -- 归集账号
    ,acct_name varchar2(120) -- 归集账号名
    ,fund_lmt number(22,2) -- 代付额度
    ,sign_rcv_acct varchar2(120) -- 签约付款账户
    ,sign_rcv_acct_name varchar2(256) -- 签约账户名称
    ,sign_rcv_acct_typ varchar2(100) -- 签约账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）
    ,create_time timestamp -- 创建时间
    ,create_emp varchar2(120) -- 创建者
    ,create_user number(32,0) -- 创建人id
    ,update_time timestamp -- 更新时间
    ,update_user number(32,0) -- 更新者id
    ,update_emp varchar2(120) -- 更新者
    ,physics_flag number(1,0) -- 物理标识，默认1正常，2删除
    ,merch_examine_status varchar2(120) -- 商户审核状态（0编辑待审核，1审核通过，2审核通过）
    ,sign_time timestamp -- 签约时间
    ,update_field varchar2(256) -- 编辑后的字段json串：{"updateFundLmt",:"11","updateSinglLmt":"1"}
    ,org_id varchar2(120) -- 所属分行
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
grant select on ${iol_schema}.amss_online_pay_merchant to ${iml_schema};
grant select on ${iol_schema}.amss_online_pay_merchant to ${icl_schema};
grant select on ${iol_schema}.amss_online_pay_merchant to ${idl_schema};
grant select on ${iol_schema}.amss_online_pay_merchant to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_online_pay_merchant is '网联代付商户表';
comment on column ${iol_schema}.amss_online_pay_merchant.sign_num is '协议编号,主键';
comment on column ${iol_schema}.amss_online_pay_merchant.mgmt_platf_chn is '管理平台渠道号';
comment on column ${iol_schema}.amss_online_pay_merchant.sign_status is '签约状态，1-签约，默认1';
comment on column ${iol_schema}.amss_online_pay_merchant.lnkm_name is '联系人';
comment on column ${iol_schema}.amss_online_pay_merchant.lnkm_ceph_num is '联系人电话';
comment on column ${iol_schema}.amss_online_pay_merchant.acct_num is '归集账号';
comment on column ${iol_schema}.amss_online_pay_merchant.acct_name is '归集账号名';
comment on column ${iol_schema}.amss_online_pay_merchant.fund_lmt is '代付额度';
comment on column ${iol_schema}.amss_online_pay_merchant.sign_rcv_acct is '签约付款账户';
comment on column ${iol_schema}.amss_online_pay_merchant.sign_rcv_acct_name is '签约账户名称';
comment on column ${iol_schema}.amss_online_pay_merchant.sign_rcv_acct_typ is '签约账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）';
comment on column ${iol_schema}.amss_online_pay_merchant.create_time is '创建时间';
comment on column ${iol_schema}.amss_online_pay_merchant.create_emp is '创建者';
comment on column ${iol_schema}.amss_online_pay_merchant.create_user is '创建人id';
comment on column ${iol_schema}.amss_online_pay_merchant.update_time is '更新时间';
comment on column ${iol_schema}.amss_online_pay_merchant.update_user is '更新者id';
comment on column ${iol_schema}.amss_online_pay_merchant.update_emp is '更新者';
comment on column ${iol_schema}.amss_online_pay_merchant.physics_flag is '物理标识，默认1正常，2删除';
comment on column ${iol_schema}.amss_online_pay_merchant.merch_examine_status is '商户审核状态（0编辑待审核，1审核通过，2审核通过）';
comment on column ${iol_schema}.amss_online_pay_merchant.sign_time is '签约时间';
comment on column ${iol_schema}.amss_online_pay_merchant.update_field is '编辑后的字段json串：{"updateFundLmt",:"11","updateSinglLmt":"1"}';
comment on column ${iol_schema}.amss_online_pay_merchant.org_id is '所属分行';
comment on column ${iol_schema}.amss_online_pay_merchant.start_dt is '开始时间';
comment on column ${iol_schema}.amss_online_pay_merchant.end_dt is '结束时间';
comment on column ${iol_schema}.amss_online_pay_merchant.id_mark is '增删标志';
comment on column ${iol_schema}.amss_online_pay_merchant.etl_timestamp is 'ETL处理时间戳';
