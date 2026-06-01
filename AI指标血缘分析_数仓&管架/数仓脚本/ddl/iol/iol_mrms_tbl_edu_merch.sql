/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_edu_merch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_edu_merch
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_edu_merch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_edu_merch(
    merch_num varchar2(30) -- 商户号
    ,merch_name varchar2(192) -- 商户名称
    ,merch_status varchar2(3) -- 商户状态0待审核  1正常    2关闭
    ,jg_acct_no varchar2(48) -- 监管账号-付款账号
    ,jg_acct_name varchar2(192) -- 监管账号名
    ,jg_acct_bank_no varchar2(48) -- 监管账户开户行号
    ,jg_acct_type varchar2(2) -- 监管账户类型 0-对公账户，1-个人账户，2-内部户，3-监管账户
    ,dz_acct_no varchar2(48) -- 垫资账号-收款账号
    ,dz_acct_name varchar2(192) -- 垫资账号名称
    ,dz_acct_bank_no varchar2(48) -- 垫资户开户行号
    ,dz_acct_type varchar2(2) -- 垫资账户类型 0-对公账户，1-个人账户，2-内部户，3-监管账户
    ,brh_id varchar2(18) -- 所属机构号
    ,brh_name varchar2(180) -- 所属机构名
    ,created_time varchar2(30) -- 创建时间
    ,updated_time varchar2(30) -- 修改时间
    ,reserved1 varchar2(383) -- 保留字段
    ,reserved2 varchar2(383) -- 保留字段
    ,reserved3 varchar2(383) -- 保留字段
    ,reserved4 varchar2(383) -- 保留字段
    ,reserved5 varchar2(383) -- 保留字段
    ,is_w_control varchar2(2) -- 是否白名单控制 0否，1是
    ,check_tlr varchar2(30) -- 维护柜员
    ,acq_inst_id varchar2(30) -- 审批柜员
    ,spell_name varchar2(96) -- 商户简称
    ,jg_acct_bank_name varchar2(96) -- 清算账户开户行名
    ,ftp_host varchar2(750) -- 商户ftp-host
    ,ftp_port varchar2(30) -- 商户ftp-port
    ,ftp_user varchar2(750) -- 商户ftp-user
    ,ftp_password varchar2(750) -- 商户ftp-password
    ,ftp_local varchar2(750) -- 商户ftp-本地上传路径
    ,ftp_remote varchar2(750) -- 商户ftp-远程请求文件路径
    ,ftp_remote_ret varchar2(750) -- 商户ftp-远程回盘文件路径
    ,is_approve varchar2(30) -- 是否免审批即可转账 0 -否， 1- 是
    ,flow_status varchar2(2) -- 流程状态(0 添加待审核,1 修改待审核,2 关闭待审核,3 回退, 9 通过)
    ,buss_team_na varchar2(96) -- 业务团队名称
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
grant select on ${iol_schema}.mrms_tbl_edu_merch to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_edu_merch to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_edu_merch to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_edu_merch to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_edu_merch is '教育金商户表';
comment on column ${iol_schema}.mrms_tbl_edu_merch.merch_num is '商户号';
comment on column ${iol_schema}.mrms_tbl_edu_merch.merch_name is '商户名称';
comment on column ${iol_schema}.mrms_tbl_edu_merch.merch_status is '商户状态0待审核  1正常    2关闭';
comment on column ${iol_schema}.mrms_tbl_edu_merch.jg_acct_no is '监管账号-付款账号';
comment on column ${iol_schema}.mrms_tbl_edu_merch.jg_acct_name is '监管账号名';
comment on column ${iol_schema}.mrms_tbl_edu_merch.jg_acct_bank_no is '监管账户开户行号';
comment on column ${iol_schema}.mrms_tbl_edu_merch.jg_acct_type is '监管账户类型 0-对公账户，1-个人账户，2-内部户，3-监管账户';
comment on column ${iol_schema}.mrms_tbl_edu_merch.dz_acct_no is '垫资账号-收款账号';
comment on column ${iol_schema}.mrms_tbl_edu_merch.dz_acct_name is '垫资账号名称';
comment on column ${iol_schema}.mrms_tbl_edu_merch.dz_acct_bank_no is '垫资户开户行号';
comment on column ${iol_schema}.mrms_tbl_edu_merch.dz_acct_type is '垫资账户类型 0-对公账户，1-个人账户，2-内部户，3-监管账户';
comment on column ${iol_schema}.mrms_tbl_edu_merch.brh_id is '所属机构号';
comment on column ${iol_schema}.mrms_tbl_edu_merch.brh_name is '所属机构名';
comment on column ${iol_schema}.mrms_tbl_edu_merch.created_time is '创建时间';
comment on column ${iol_schema}.mrms_tbl_edu_merch.updated_time is '修改时间';
comment on column ${iol_schema}.mrms_tbl_edu_merch.reserved1 is '保留字段';
comment on column ${iol_schema}.mrms_tbl_edu_merch.reserved2 is '保留字段';
comment on column ${iol_schema}.mrms_tbl_edu_merch.reserved3 is '保留字段';
comment on column ${iol_schema}.mrms_tbl_edu_merch.reserved4 is '保留字段';
comment on column ${iol_schema}.mrms_tbl_edu_merch.reserved5 is '保留字段';
comment on column ${iol_schema}.mrms_tbl_edu_merch.is_w_control is '是否白名单控制 0否，1是';
comment on column ${iol_schema}.mrms_tbl_edu_merch.check_tlr is '维护柜员';
comment on column ${iol_schema}.mrms_tbl_edu_merch.acq_inst_id is '审批柜员';
comment on column ${iol_schema}.mrms_tbl_edu_merch.spell_name is '商户简称';
comment on column ${iol_schema}.mrms_tbl_edu_merch.jg_acct_bank_name is '清算账户开户行名';
comment on column ${iol_schema}.mrms_tbl_edu_merch.ftp_host is '商户ftp-host';
comment on column ${iol_schema}.mrms_tbl_edu_merch.ftp_port is '商户ftp-port';
comment on column ${iol_schema}.mrms_tbl_edu_merch.ftp_user is '商户ftp-user';
comment on column ${iol_schema}.mrms_tbl_edu_merch.ftp_password is '商户ftp-password';
comment on column ${iol_schema}.mrms_tbl_edu_merch.ftp_local is '商户ftp-本地上传路径';
comment on column ${iol_schema}.mrms_tbl_edu_merch.ftp_remote is '商户ftp-远程请求文件路径';
comment on column ${iol_schema}.mrms_tbl_edu_merch.ftp_remote_ret is '商户ftp-远程回盘文件路径';
comment on column ${iol_schema}.mrms_tbl_edu_merch.is_approve is '是否免审批即可转账 0 -否， 1- 是';
comment on column ${iol_schema}.mrms_tbl_edu_merch.flow_status is '流程状态(0 添加待审核,1 修改待审核,2 关闭待审核,3 回退, 9 通过)';
comment on column ${iol_schema}.mrms_tbl_edu_merch.buss_team_na is '业务团队名称';
comment on column ${iol_schema}.mrms_tbl_edu_merch.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_edu_merch.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_edu_merch.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_edu_merch.etl_timestamp is 'ETL处理时间戳';
