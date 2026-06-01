/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_acc_inf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_acc_inf
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_acc_inf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_acc_inf(
    cai_cstno varchar2(30) -- 企业客户号(ecif号)
    ,cai_ctftype varchar2(10) -- 企业证件类型
    ,cai_ctfno varchar2(130) -- 企业证件号
    ,cai_userno varchar2(40) -- 录入操作员id(网银顺序号)
    ,cai_useralias varchar2(64) -- 录入操作员别名(登录名)
    ,cai_accno varchar2(40) -- 卡号/账号
    ,cai_acctype varchar2(8) -- 账号类型（21-单位结算卡；类型可以扩展）
    ,cai_accname varchar2(256) -- 户名
    ,cai_alias varchar2(256) -- 账户别名
    ,cai_crflag varchar2(1) -- 钞汇标志(c--钞;r--汇)
    ,cai_crytype varchar2(3) -- 币种（cry人民币）
    ,cai_branchno varchar2(15) -- 账户开户机构
    ,cai_state varchar2(1) -- 状态(0：正常;1：网银删除;2：冻结;3：暂停)
    ,cai_signflag varchar2(1) -- 账户签约标志（0：已签约；1：未签约）预留
    ,cai_signway varchar2(2) -- 账户加挂方式（0:柜台签约1:交易银行pc签约2:交易银行app签约3:支付签约）
    ,cai_hide varchar2(1) -- 是否隐藏(0：显示；1：隐藏；)
    ,cai_right varchar2(8) -- 账户权限，8位，1-开通，0-未开通。第1位：单位结算卡,其他预留传0
    ,cai_sourcesys varchar2(1) -- 来源系统(1:核心；1:电子账户系统)
    ,cai_firsttime varchar2(14) -- 首次绑定时间
    ,cai_updatetime varchar2(14) -- 更新时间
    ,cai_usetime varchar2(14) -- 最近使用时间(从未使用则为注册时间，格式为yyyymmddhhmiss)
    ,cai_remark1 varchar2(100) -- 预留字段1
    ,cai_remark2 varchar2(50) -- 预留字段2
    ,cai_remark3 varchar2(514) -- 预留字段3
    ,cai_closedate varchar2(14) -- 账户解挂日期
    ,cai_opendate varchar2(14) -- 核心开户时间
    ,cai_annualenddate varchar2(20) -- 账号年检到期日
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tbps_cpr_acc_inf to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_acc_inf to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_acc_inf to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_acc_inf to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_acc_inf is '交易银行账户信息表';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_cstno is '企业客户号(ecif号)';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_ctftype is '企业证件类型';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_ctfno is '企业证件号';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_userno is '录入操作员id(网银顺序号)';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_useralias is '录入操作员别名(登录名)';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_accno is '卡号/账号';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_acctype is '账号类型（21-单位结算卡；类型可以扩展）';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_accname is '户名';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_alias is '账户别名';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_crflag is '钞汇标志(c--钞;r--汇)';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_crytype is '币种（cry人民币）';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_branchno is '账户开户机构';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_state is '状态(0：正常;1：网银删除;2：冻结;3：暂停)';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_signflag is '账户签约标志（0：已签约；1：未签约）预留';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_signway is '账户加挂方式（0:柜台签约1:交易银行pc签约2:交易银行app签约3:支付签约）';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_hide is '是否隐藏(0：显示；1：隐藏；)';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_right is '账户权限，8位，1-开通，0-未开通。第1位：单位结算卡,其他预留传0';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_sourcesys is '来源系统(1:核心；1:电子账户系统)';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_firsttime is '首次绑定时间';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_updatetime is '更新时间';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_usetime is '最近使用时间(从未使用则为注册时间，格式为yyyymmddhhmiss)';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_remark1 is '预留字段1';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_remark2 is '预留字段2';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_remark3 is '预留字段3';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_closedate is '账户解挂日期';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_opendate is '核心开户时间';
comment on column ${iol_schema}.tbps_cpr_acc_inf.cai_annualenddate is '账号年检到期日';
comment on column ${iol_schema}.tbps_cpr_acc_inf.start_dt is '开始时间';
comment on column ${iol_schema}.tbps_cpr_acc_inf.end_dt is '结束时间';
comment on column ${iol_schema}.tbps_cpr_acc_inf.id_mark is '增删标志';
comment on column ${iol_schema}.tbps_cpr_acc_inf.etl_timestamp is 'ETL处理时间戳';
