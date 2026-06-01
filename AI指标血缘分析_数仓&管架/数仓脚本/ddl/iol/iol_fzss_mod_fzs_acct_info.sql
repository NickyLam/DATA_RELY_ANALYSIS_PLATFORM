/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fzss_mod_fzs_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fzss_mod_fzs_acct_info
whenever sqlerror continue none;
drop table ${iol_schema}.fzss_mod_fzs_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fzss_mod_fzs_acct_info(
    corp_id varchar2(10) -- 平台商户号
    ,sub_acct_no varchar2(40) -- 子账号 账号格式 对私：623627+01+序号+1位验证位 对公：70/71开头
    ,cust_id varchar2(32) -- 客户ID （2+1+8位序号） （2+2+8位序号）
    ,corp_work_date varchar2(8) -- 平台日期
    ,order_no varchar2(64) -- 订单号
    ,mybank varchar2(20) -- 法人标识代码
    ,zone_no varchar2(6) -- 分行号
    ,cmd_type varchar2(3) -- 开户指令类型 [枚举: A02-实名开户，A03-快捷开户]
    ,sub_acct_nm varchar2(256) -- 子账户名称
    ,member_name varchar2(256) -- 会员名称
    ,acct_cls varchar2(2) -- 子账号类别 [枚举: 01-其他子账号、02-功能户]
    ,acct_status varchar2(2) -- 账户状态 [枚举: A-正常,C-关闭,D-不动户,H-待激活,I-预开户,N-新建,数据字典：CD04011]
    ,balance number(20,2) -- 总余额 [枚举: 总余额]
    ,cash_amt number(20,2) -- 可提余额 [枚举: 清算后的余额]
    ,freeze_amt number(20,2) -- 冻结余额
    ,outstanding_amt number(20,2) -- 待清算余额
    ,open_brno varchar2(6) -- 开户机构号 [枚举: 从“平台商户信息表”取对应商户的开户机构号]
    ,acct_open_dt varchar2(8) -- 开户日期
    ,acct_open_tm varchar2(6) -- 开户时间
    ,acct_close_dt varchar2(8) -- 销户日期
    ,acct_close_tm varchar2(6) -- 销户时间
    ,tran_net_member_code varchar2(32) -- 平台用户编号 [枚举: 用户编号（平台侧唯一值）]
    ,cust_role varchar2(1) -- 会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]
    ,cust_type varchar2(1) -- 客户类型 [枚举: 1-对私,2-对公]
    ,remark varchar2(600) -- 备注
    ,create_timestamp timestamp -- 创建时间戳
    ,update_timestamp timestamp -- 更新时间戳
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
grant select on ${iol_schema}.fzss_mod_fzs_acct_info to ${iml_schema};
grant select on ${iol_schema}.fzss_mod_fzs_acct_info to ${icl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_acct_info to ${idl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_acct_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fzss_mod_fzs_acct_info is '子账户基本信息表';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.corp_id is '平台商户号';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.sub_acct_no is '子账号 账号格式 对私：623627+01+序号+1位验证位 对公：70/71开头';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.cust_id is '客户ID （2+1+8位序号） （2+2+8位序号）';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.corp_work_date is '平台日期';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.order_no is '订单号';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.mybank is '法人标识代码';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.zone_no is '分行号';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.cmd_type is '开户指令类型 [枚举: A02-实名开户，A03-快捷开户]';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.sub_acct_nm is '子账户名称';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.member_name is '会员名称';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.acct_cls is '子账号类别 [枚举: 01-其他子账号、02-功能户]';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.acct_status is '账户状态 [枚举: A-正常,C-关闭,D-不动户,H-待激活,I-预开户,N-新建,数据字典：CD04011]';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.balance is '总余额 [枚举: 总余额]';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.cash_amt is '可提余额 [枚举: 清算后的余额]';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.freeze_amt is '冻结余额';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.outstanding_amt is '待清算余额';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.open_brno is '开户机构号 [枚举: 从“平台商户信息表”取对应商户的开户机构号]';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.acct_open_dt is '开户日期';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.acct_open_tm is '开户时间';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.acct_close_dt is '销户日期';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.acct_close_tm is '销户时间';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.tran_net_member_code is '平台用户编号 [枚举: 用户编号（平台侧唯一值）]';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.cust_role is '会员角色标志 [枚举: 1-卖家,2-达人、分销者,3-其他]';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.cust_type is '客户类型 [枚举: 1-对私,2-对公]';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.remark is '备注';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.create_timestamp is '创建时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.update_timestamp is '更新时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.start_dt is '开始时间';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.end_dt is '结束时间';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.id_mark is '增删标志';
comment on column ${iol_schema}.fzss_mod_fzs_acct_info.etl_timestamp is 'ETL处理时间戳';
