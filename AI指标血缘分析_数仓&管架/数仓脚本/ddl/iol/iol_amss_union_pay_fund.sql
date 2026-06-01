/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_union_pay_fund
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_union_pay_fund
whenever sqlerror continue none;
drop table ${iol_schema}.amss_union_pay_fund purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_union_pay_fund(
    fund_id varchar2(120) -- 基金公司信息表主键
    ,mgmt_platf_chn varchar2(120) -- 渠道号
    ,fund_name varchar2(1256) -- 基金公司名称
    ,fund_sname varchar2(120) -- 基金公司简称
    ,bank_org_code varchar2(120) -- 银行机构号
    ,channel_id varchar2(120) -- 所属机构（channelId）
    ,examine_status varchar2(20) -- 审核状态，默认1，审核通过（0编辑待审核，1审核通过，2审核不通过）
    ,status varchar2(20) -- 基金公司状态，默认1正常（0冻结，正常）
    ,oper_licence_num varchar2(256) -- 营业执照号
    ,oper_licence_valid_dt varchar2(120) -- 营业执照有效期
    ,lp_name varchar2(120) -- 法人姓名
    ,lp_ceph_num varchar2(120) -- 法人手机号
    ,lnkm_name varchar2(256) -- 联系人名称
    ,lnkm_ceph_num varchar2(120) -- 联系人号码
    ,lnkm_address varchar2(256) -- 联系人地址
    ,lnkm_iden_num varchar2(120) -- 联系人证件号码
    ,lnkm_iden_type varchar2(120) -- 联系人证件类型
    ,email varchar2(120) -- 邮箱
    ,sms_name varchar2(120) -- 短信通知人
    ,sms_ceph_num varchar2(120) -- 短信通知电话
    ,acct_num varchar2(120) -- 结算账户
    ,acct_name varchar2(120) -- 结算账户名
    ,acct_type varchar2(120) -- 结算账户类型
    ,open_bk_num varchar2(120) -- 开户行行号
    ,open_bk_name varchar2(120) -- 开户行行名
    ,open_bk_address varchar2(256) -- 开户行地址
    ,fund_lmt number(20,2) -- 基金额度
    ,single_lmt number(20,2) -- 单笔额度
    ,create_time timestamp -- 创建时间
    ,create_user number(10,0) -- 创建id
    ,create_emp varchar2(120) -- 创建者
    ,update_time timestamp -- 更新时间
    ,update_user number(10,0) -- 更新id
    ,update_emp varchar2(120) -- 更新者
    ,physics_flag number(1,0) -- 物理标识：默认1正常，2删除
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
grant select on ${iol_schema}.amss_union_pay_fund to ${iml_schema};
grant select on ${iol_schema}.amss_union_pay_fund to ${icl_schema};
grant select on ${iol_schema}.amss_union_pay_fund to ${idl_schema};
grant select on ${iol_schema}.amss_union_pay_fund to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_union_pay_fund is '银联代付-基金公司信息表';
comment on column ${iol_schema}.amss_union_pay_fund.fund_id is '基金公司信息表主键';
comment on column ${iol_schema}.amss_union_pay_fund.mgmt_platf_chn is '渠道号';
comment on column ${iol_schema}.amss_union_pay_fund.fund_name is '基金公司名称';
comment on column ${iol_schema}.amss_union_pay_fund.fund_sname is '基金公司简称';
comment on column ${iol_schema}.amss_union_pay_fund.bank_org_code is '银行机构号';
comment on column ${iol_schema}.amss_union_pay_fund.channel_id is '所属机构（channelId）';
comment on column ${iol_schema}.amss_union_pay_fund.examine_status is '审核状态，默认1，审核通过（0编辑待审核，1审核通过，2审核不通过）';
comment on column ${iol_schema}.amss_union_pay_fund.status is '基金公司状态，默认1正常（0冻结，正常）';
comment on column ${iol_schema}.amss_union_pay_fund.oper_licence_num is '营业执照号';
comment on column ${iol_schema}.amss_union_pay_fund.oper_licence_valid_dt is '营业执照有效期';
comment on column ${iol_schema}.amss_union_pay_fund.lp_name is '法人姓名';
comment on column ${iol_schema}.amss_union_pay_fund.lp_ceph_num is '法人手机号';
comment on column ${iol_schema}.amss_union_pay_fund.lnkm_name is '联系人名称';
comment on column ${iol_schema}.amss_union_pay_fund.lnkm_ceph_num is '联系人号码';
comment on column ${iol_schema}.amss_union_pay_fund.lnkm_address is '联系人地址';
comment on column ${iol_schema}.amss_union_pay_fund.lnkm_iden_num is '联系人证件号码';
comment on column ${iol_schema}.amss_union_pay_fund.lnkm_iden_type is '联系人证件类型';
comment on column ${iol_schema}.amss_union_pay_fund.email is '邮箱';
comment on column ${iol_schema}.amss_union_pay_fund.sms_name is '短信通知人';
comment on column ${iol_schema}.amss_union_pay_fund.sms_ceph_num is '短信通知电话';
comment on column ${iol_schema}.amss_union_pay_fund.acct_num is '结算账户';
comment on column ${iol_schema}.amss_union_pay_fund.acct_name is '结算账户名';
comment on column ${iol_schema}.amss_union_pay_fund.acct_type is '结算账户类型';
comment on column ${iol_schema}.amss_union_pay_fund.open_bk_num is '开户行行号';
comment on column ${iol_schema}.amss_union_pay_fund.open_bk_name is '开户行行名';
comment on column ${iol_schema}.amss_union_pay_fund.open_bk_address is '开户行地址';
comment on column ${iol_schema}.amss_union_pay_fund.fund_lmt is '基金额度';
comment on column ${iol_schema}.amss_union_pay_fund.single_lmt is '单笔额度';
comment on column ${iol_schema}.amss_union_pay_fund.create_time is '创建时间';
comment on column ${iol_schema}.amss_union_pay_fund.create_user is '创建id';
comment on column ${iol_schema}.amss_union_pay_fund.create_emp is '创建者';
comment on column ${iol_schema}.amss_union_pay_fund.update_time is '更新时间';
comment on column ${iol_schema}.amss_union_pay_fund.update_user is '更新id';
comment on column ${iol_schema}.amss_union_pay_fund.update_emp is '更新者';
comment on column ${iol_schema}.amss_union_pay_fund.physics_flag is '物理标识：默认1正常，2删除';
comment on column ${iol_schema}.amss_union_pay_fund.start_dt is '开始时间';
comment on column ${iol_schema}.amss_union_pay_fund.end_dt is '结束时间';
comment on column ${iol_schema}.amss_union_pay_fund.id_mark is '增删标志';
comment on column ${iol_schema}.amss_union_pay_fund.etl_timestamp is 'ETL处理时间戳';
