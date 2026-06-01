/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fzss_mod_fzs_main_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fzss_mod_fzs_main_acct_info
whenever sqlerror continue none;
drop table ${iol_schema}.fzss_mod_fzs_main_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fzss_mod_fzs_main_acct_info(
    corp_id varchar2(10) -- 平台商户号
    ,mybank varchar2(20) -- 法人标识代码
    ,zone_no varchar2(6) -- 分行号
    ,ref_acct_type varchar2(2) -- 关联账号类型 [枚举: 1-一般户,2-存单开户账户,3-存单利息账户,4-绑定提现账户]
    ,ref_seq varchar2(5) -- 关联序号 可用于排序
    ,base_acct_no varchar2(40) -- 账号
    ,base_acct_name varchar2(256) -- 户名 监管账户的正式名称（官方注释：资金监管账户名）
    ,bank_flag varchar2(1) -- 行内外标志 [枚举: 1-行内,2-行外]
    ,cnaps_branch_id varchar2(16) -- 联行号
    ,open_bank_no varchar2(16) -- 开户机构号
    ,is_need_downhost varchar2(1) -- 是否需要下载核心流水 [枚举: 0-否,1-是]
    ,downhost_dealstatus varchar2(8) -- 流水下载状态 [枚举: 0-处理中,1-空闲]
    ,downhost_date varchar2(8) -- 流水最后下载日期
    ,downhost_pagenum varchar2(6) -- 流水最后下载页码 从0开始算
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
grant select on ${iol_schema}.fzss_mod_fzs_main_acct_info to ${iml_schema};
grant select on ${iol_schema}.fzss_mod_fzs_main_acct_info to ${icl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_main_acct_info to ${idl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_main_acct_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fzss_mod_fzs_main_acct_info is '平台监管账户信息表';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.corp_id is '平台商户号';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.mybank is '法人标识代码';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.zone_no is '分行号';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.ref_acct_type is '关联账号类型 [枚举: 1-一般户,2-存单开户账户,3-存单利息账户,4-绑定提现账户]';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.ref_seq is '关联序号 可用于排序';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.base_acct_no is '账号';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.base_acct_name is '户名 监管账户的正式名称（官方注释：资金监管账户名）';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.bank_flag is '行内外标志 [枚举: 1-行内,2-行外]';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.cnaps_branch_id is '联行号';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.open_bank_no is '开户机构号';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.is_need_downhost is '是否需要下载核心流水 [枚举: 0-否,1-是]';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.downhost_dealstatus is '流水下载状态 [枚举: 0-处理中,1-空闲]';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.downhost_date is '流水最后下载日期';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.downhost_pagenum is '流水最后下载页码 从0开始算';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.create_timestamp is '创建时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.update_timestamp is '更新时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.start_dt is '开始时间';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.end_dt is '结束时间';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.id_mark is '增删标志';
comment on column ${iol_schema}.fzss_mod_fzs_main_acct_info.etl_timestamp is 'ETL处理时间戳';
