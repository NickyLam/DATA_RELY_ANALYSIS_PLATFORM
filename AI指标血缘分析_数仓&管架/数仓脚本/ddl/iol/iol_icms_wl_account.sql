/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wl_account
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wl_account
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wl_account purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wl_account(
    serialno nvarchar2(32) -- 卡变更流水号
    ,enddate date -- 分类失效日期
    ,createuser nvarchar2(32) -- 创建用户
    ,openbankno nvarchar2(20) -- 开户行号
    ,fncintcode nvarchar2(20) -- 金融机构编码
    ,openbranch nvarchar2(20) -- 开户网点
    ,migtflag varchar2(80) -- 
    ,organcode nvarchar2(12) -- 内部机构编号
    ,cardtype nvarchar2(10) -- 银行卡卡种
    ,bankpayid nvarchar2(20) -- 绑定银行支付ID
    ,updatetime date -- 更新时间
    ,accountname nvarchar2(128) -- 账户名称
    ,accounttype nvarchar2(1) -- 账户类型（0-一般户/借记卡，1-基本户/内部户，2-对公保证金户，3-对公活期账户，4-电子账户，9-虚拟账户）
    ,openbank nvarchar2(256) -- 开户行名
    ,updateuser nvarchar2(32) -- 更新用户
    ,accountno nvarchar2(24) -- 账户编号
    ,acctownid nvarchar2(32) -- 账号所属ID(客户编号或者合作机构编号)
    ,startdate date -- 分类生效日期
    ,accountflg number(10,0) -- 账户状态，0可用（默认），1不可用
    ,createtime date -- 创建时间
    ,assetstype number(2,0) -- 资产方账户类型（1-资金方账户2-资产方账户,3-个人账户）
    ,bindidno nvarchar2(30) -- 绑定身份证号
    ,bindcardno nvarchar2(30) -- 绑定银行卡号
    ,accountdesc nvarchar2(512) -- 账户描述
    ,openbranchname nvarchar2(80) -- 开户网点名称
    ,repaysignid nvarchar2(32) -- 扣款签约ID
    ,preserialno nvarchar2(32) -- 记录上次卡变更记录流水号
    ,openname nvarchar2(128) -- 开户名称（人或公司名）
    ,otherbankflag nvarchar2(1) -- 他行卡标识(0本行，1他行)
    ,accountnum nvarchar2(32) -- 账号
    ,bindphone nvarchar2(20) -- 绑定手机号
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
grant select on ${iol_schema}.icms_wl_account to ${iml_schema};
grant select on ${iol_schema}.icms_wl_account to ${icl_schema};
grant select on ${iol_schema}.icms_wl_account to ${idl_schema};
grant select on ${iol_schema}.icms_wl_account to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wl_account is '账户配置表';
comment on column ${iol_schema}.icms_wl_account.serialno is '卡变更流水号';
comment on column ${iol_schema}.icms_wl_account.enddate is '分类失效日期';
comment on column ${iol_schema}.icms_wl_account.createuser is '创建用户';
comment on column ${iol_schema}.icms_wl_account.openbankno is '开户行号';
comment on column ${iol_schema}.icms_wl_account.fncintcode is '金融机构编码';
comment on column ${iol_schema}.icms_wl_account.openbranch is '开户网点';
comment on column ${iol_schema}.icms_wl_account.migtflag is '';
comment on column ${iol_schema}.icms_wl_account.organcode is '内部机构编号';
comment on column ${iol_schema}.icms_wl_account.cardtype is '银行卡卡种';
comment on column ${iol_schema}.icms_wl_account.bankpayid is '绑定银行支付ID';
comment on column ${iol_schema}.icms_wl_account.updatetime is '更新时间';
comment on column ${iol_schema}.icms_wl_account.accountname is '账户名称';
comment on column ${iol_schema}.icms_wl_account.accounttype is '账户类型（0-一般户/借记卡，1-基本户/内部户，2-对公保证金户，3-对公活期账户，4-电子账户，9-虚拟账户）';
comment on column ${iol_schema}.icms_wl_account.openbank is '开户行名';
comment on column ${iol_schema}.icms_wl_account.updateuser is '更新用户';
comment on column ${iol_schema}.icms_wl_account.accountno is '账户编号';
comment on column ${iol_schema}.icms_wl_account.acctownid is '账号所属ID(客户编号或者合作机构编号)';
comment on column ${iol_schema}.icms_wl_account.startdate is '分类生效日期';
comment on column ${iol_schema}.icms_wl_account.accountflg is '账户状态，0可用（默认），1不可用';
comment on column ${iol_schema}.icms_wl_account.createtime is '创建时间';
comment on column ${iol_schema}.icms_wl_account.assetstype is '资产方账户类型（1-资金方账户2-资产方账户,3-个人账户）';
comment on column ${iol_schema}.icms_wl_account.bindidno is '绑定身份证号';
comment on column ${iol_schema}.icms_wl_account.bindcardno is '绑定银行卡号';
comment on column ${iol_schema}.icms_wl_account.accountdesc is '账户描述';
comment on column ${iol_schema}.icms_wl_account.openbranchname is '开户网点名称';
comment on column ${iol_schema}.icms_wl_account.repaysignid is '扣款签约ID';
comment on column ${iol_schema}.icms_wl_account.preserialno is '记录上次卡变更记录流水号';
comment on column ${iol_schema}.icms_wl_account.openname is '开户名称（人或公司名）';
comment on column ${iol_schema}.icms_wl_account.otherbankflag is '他行卡标识(0本行，1他行)';
comment on column ${iol_schema}.icms_wl_account.accountnum is '账号';
comment on column ${iol_schema}.icms_wl_account.bindphone is '绑定手机号';
comment on column ${iol_schema}.icms_wl_account.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wl_account.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wl_account.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wl_account.etl_timestamp is 'ETL处理时间戳';
